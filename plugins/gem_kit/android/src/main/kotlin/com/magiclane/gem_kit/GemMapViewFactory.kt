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

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import android.app.Activity

@Suppress("UNCHECKED_CAST")
class GemMapViewFactory(private val gemKitPlugin: GemKitPlugin,
                        private val flutterAssets: FlutterPlugin.FlutterAssets,
    ) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        gemKitPlugin.initializeGemSdkIfNeeded(
            context = context,
            activity = context as? Activity,
            setNetworkProvider = true
        )
        return GemMapView(gemKitPlugin, viewId, context, args, flutterAssets)
    }
}
