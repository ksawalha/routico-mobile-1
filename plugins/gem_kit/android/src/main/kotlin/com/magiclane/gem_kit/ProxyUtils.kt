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

import android.os.Build
import java.net.InetSocketAddress
import java.net.Proxy
import java.net.ProxySelector
import java.net.URI

object ProxyUtils {

    private val sdkInt = Build.VERSION.SDK_INT

    // ---------------------------------------------------------------------------------------------

    fun getProxyConfiguration(bHttpsProxyConfiguration: Boolean): ProxyConfiguration? {
        return if (bHttpsProxyConfiguration) {
            getProxyConfiguration(URI.create("https://www.magiclane.com"))
        } else {
            getProxyConfiguration(URI.create("http://www.magiclane.com"))
        }
    }

    // ---------------------------------------------------------------------------------------------

    @Throws(Exception::class)
    fun getProxyConfiguration(uri: URI?): ProxyConfiguration? {
        if (sdkInt >= 12) {
            return getProxySelectorConfiguration(uri) as ProxyConfiguration
        }

        return null
    }

    // ---------------------------------------------------------------------------------------------

    private fun getProxySelectorConfiguration(uri: URI?): ProxyConfiguration? {
        val defaultProxySelector = ProxySelector.getDefault()
        val proxy: Proxy?
        val proxyList = defaultProxySelector.select(uri)

        if (proxyList.size > 0) {
            proxy = proxyList[0]
        } else {
            return null
        }

        var proxyConfig: ProxyConfiguration? = null
        if (proxy === Proxy.NO_PROXY) {
            proxyConfig = ProxyConfiguration("", -1, proxy.type())
        } else {
            if (proxy.address() != null) {
                val proxyAddress = proxy.address() as InetSocketAddress
                proxyConfig =
                    ProxyConfiguration(proxyAddress.hostName, proxyAddress.port, proxy.type())
            }
        }

        return proxyConfig
    }
}
