/*
 * SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
 * SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
 *
 * Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
 * intellectual property and proprietary rights in and to this material, related
 * documentation and any modifications thereto. Any use, reproduction,
 * disclosure or distribution of this material and related documentation
 * without an express license agreement from Magic Lane Intellectual Property B.V.
 * or its affiliates is strictly prohibited.
 */

package com.magiclane.gem_kit

import android.annotation.SuppressLint
import android.annotation.TargetApi
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Build
import com.magiclane.sdk.core.EProxyType
import com.magiclane.sdk.core.ProxyDetails
import com.magiclane.sdk.util.SdkCall
import com.magiclane.sdk.util.Util
import java.lang.ref.WeakReference
import java.net.Proxy

@SuppressLint("MissingPermission")
class NetworkManager(context: Context) {
    enum class EConnectionType(val value: Int) {
        NotConnected(-1),
        Wifi(0),
        Mobile(1),
        Ethernet(2);
    }

    var onConnectionTypeChangedCallback: (EConnectionType, ProxyDetails, ProxyDetails) -> Unit =
        { _, _, _ -> }

    private var mConnectionType = EConnectionType.NotConnected
    private val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

    private lateinit var connectivityManagerCallback: ConnectivityManager.NetworkCallback

    private val networkReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            updateConnection(getConnectionType())
        }
    }

    private val uninitialize = {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            cm.unregisterNetworkCallback(connectivityManagerCallback)
        } else {
            context.unregisterReceiver(networkReceiver)
        }
    }

    init {
        when {
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.N -> {
                try {
                    cm.registerDefaultNetworkCallback(getConnectivityManagerCallback())
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }

            Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP -> {
                lollipopNetworkAvailableRequest()
            }

            else -> {
                context.registerReceiver(
                    networkReceiver,
                    IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION)
                )
            }
        }
    }

    fun finalize() = uninitialize()

    private fun getConnectionType(): EConnectionType {
        var connectionType = EConnectionType.NotConnected

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                cm.run {
                    cm.getNetworkCapabilities(cm.activeNetwork)?.run {
                        connectionType = when {
                            hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> EConnectionType.Wifi
                            hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> EConnectionType.Mobile
                            hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) -> EConnectionType.Ethernet
                            else -> EConnectionType.NotConnected
                        }
                    }
                }
            } else {
                cm.run {
                    cm.activeNetworkInfo?.run {
                        connectionType = when (type) {
                            ConnectivityManager.TYPE_WIFI -> EConnectionType.Wifi
                            ConnectivityManager.TYPE_MOBILE -> EConnectionType.Mobile
                            ConnectivityManager.TYPE_ETHERNET -> EConnectionType.Ethernet
                            else -> EConnectionType.NotConnected
                        }
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        return connectionType
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    private fun lollipopNetworkAvailableRequest() {
        val builder =
            NetworkRequest.Builder()
                .addTransportType(NetworkCapabilities.TRANSPORT_CELLULAR)
                .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
                .addTransportType(NetworkCapabilities.TRANSPORT_ETHERNET)

        try {
            cm.registerNetworkCallback(
                builder.build(),
                getConnectivityManagerCallback()
            )
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun getConnectivityManagerCallback(): ConnectivityManager.NetworkCallback {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            connectivityManagerCallback = object : ConnectivityManager.NetworkCallback() {
                override fun onAvailable(network: Network) {
                    var connectionType = getConnectionType()
                    
                    if (connectionType == EConnectionType.NotConnected)
                    {
                        connectionType = EConnectionType.Mobile
                        
                        val thisWeakRef = WeakReference(this@NetworkManager)
                        Util.postOnMainDelayed({
                            thisWeakRef.get()?.let {
                                if (it.getConnectionType() == EConnectionType.Wifi)
                                {
                                    it.updateConnection(EConnectionType.Wifi)
                                }   
                            }
                        }, 1000)
                    }
                    
                    updateConnection(connectionType)
                }

                override fun onLost(network: Network) {
                    updateConnection(EConnectionType.NotConnected)
                }
            }
        }
        return connectivityManagerCallback
    }
    fun refreshConnection(actualConnectionType: EConnectionType) = SdkCall.postAsync {
       
            val sendNotConnectedEvent = (actualConnectionType != EConnectionType.NotConnected) && (mConnectionType != EConnectionType.NotConnected)
            
            mConnectionType = actualConnectionType

            var httpsProxyConfig: ProxyConfiguration? = null
            var httpProxyConfig: ProxyConfiguration? = null

            if (mConnectionType != EConnectionType.NotConnected) {
                httpsProxyConfig = ProxyUtils.getProxyConfiguration(true)
                httpProxyConfig = ProxyUtils.getProxyConfiguration(false)
            }

            var connectionType = mConnectionType
            if (mConnectionType == EConnectionType.Ethernet) {
                connectionType = EConnectionType.Wifi
            }

            val https = ProxyDetails()
            https.type = when (httpsProxyConfig?.proxyType ?: Proxy.Type.DIRECT) {
                Proxy.Type.DIRECT -> EProxyType.Direct
                Proxy.Type.HTTP -> EProxyType.Http
                Proxy.Type.SOCKS -> EProxyType.Socks
            }

            https.name = httpsProxyConfig?.proxyHost ?: ""
            https.port = httpsProxyConfig?.proxyPort ?: -1

            val http = ProxyDetails()
            http.type = when (httpProxyConfig?.proxyType ?: Proxy.Type.DIRECT) {
                Proxy.Type.DIRECT -> EProxyType.Direct
                Proxy.Type.HTTP -> EProxyType.Http
                Proxy.Type.SOCKS -> EProxyType.Socks
            }

            http.name = httpProxyConfig?.proxyHost ?: ""
            http.port = httpProxyConfig?.proxyPort ?: -1

            if (sendNotConnectedEvent)
            {
                val proxyDetails = ProxyDetails()

                proxyDetails.type = EProxyType.Direct
                proxyDetails.name = ""
                proxyDetails.port = -1
                
                onConnectionTypeChangedCallback(EConnectionType.NotConnected, proxyDetails, proxyDetails)    
            }
            
            onConnectionTypeChangedCallback(connectionType, https, http)
    }
    private fun updateConnection(actualConnectionType: EConnectionType) = SdkCall.postAsync {
        if (actualConnectionType != mConnectionType) {
           refreshConnection(actualConnectionType)
        }
    }
}
