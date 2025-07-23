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
import com.magiclane.sdk.core.ENetworkType
import com.magiclane.sdk.core.GemError
import com.magiclane.sdk.core.INetworkListener
import com.magiclane.sdk.core.NetworkListener
import com.magiclane.sdk.core.NetworkProvider
import com.magiclane.sdk.core.ProxyDetails

object DefaultNetworkProvider : NetworkProvider() {
    private var networkListener: INetworkListener? = null
    private var mConnected = false
    private var networkType = NetworkManager.EConnectionType.NotConnected
    private var listeners = ArrayList<INetworkListener>()

    override fun connectionError(host: String) {
    }

    override fun setListener(listener: INetworkListener?) {
        networkListener?.let { listeners.remove(it) }
        networkListener = listener
        listener?.let { listeners.add(it) }
    }

    fun addListener(listener: NetworkListener) {
        if (!listeners.contains(listener))
            listeners.add(listener)
    }

    fun removeListener(listener: NetworkListener) {
        listeners.remove(listener)
    }

    fun onNetworkConnectionTypeChanged(
        type: NetworkManager.EConnectionType,
        https: ProxyDetails,
        http: ProxyDetails
    ) {
        val connectResult = if (type.value < 0) {
            GemError.NoConnection
        } else GemError.NoError

        mConnected = (connectResult == GemError.NoError)
        networkType = type

        var gemNetworkType = ENetworkType.Free
        if (type == NetworkManager.EConnectionType.Mobile) {
            gemNetworkType = ENetworkType.ExtraCharged
        }

        listeners.forEach { it.onConnectFinished(connectResult, gemNetworkType, https, http) }
    }

    fun onNetworkFailed(errorCode: Int) {
        listeners.forEach { it.onNetworkFailed(errorCode) }
    }

    fun mobileCountryCodeChanged(mcc: Int) {
        listeners.forEach { it.onMobileCountryCodeChanged(mcc) }
    }

    fun isConnected(): Boolean {
        return mConnected && (networkType == NetworkManager.EConnectionType.Wifi || networkType == NetworkManager.EConnectionType.Mobile)
    }

    fun isWifiConnected(): Boolean {
        return mConnected && networkType == NetworkManager.EConnectionType.Wifi
    }

    fun isMobileDataConnected(): Boolean {
        return mConnected && networkType == NetworkManager.EConnectionType.Mobile
    }

    fun getNetworkName(connected: Boolean, networkType: ENetworkType): String {
        if (!connected) {
            return "None"
        }

        return when (networkType) {
            ENetworkType.Free -> "Wi-Fi"
            ENetworkType.ExtraCharged -> "Mobile Data"
        }
    }
}
