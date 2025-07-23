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

import java.net.InetSocketAddress
import java.net.Proxy
import java.net.SocketAddress

class ProxyConfiguration(
    val proxyHost: String,
    val proxyPort: Int,
    val proxyType: Proxy.Type
) {
    val proxy: Proxy
        get() = if (proxyHost.isNotEmpty()) {
            var sa: SocketAddress? = null
            try {
                sa = InetSocketAddress.createUnresolved(proxyHost, proxyPort)
            } catch (e: IllegalArgumentException) {
            }
            sa?.let { Proxy(proxyType, it) } ?: Proxy.NO_PROXY
        } else {
            Proxy.NO_PROXY
        }
}
