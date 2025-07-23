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
import com.magiclane.sdk.core.ApiCallLogger

class CustomApiCallLogger(
    var logLevel: Int = 0,
    var useSystemLogging: Boolean = true
) : ApiCallLogger() {
    override fun onGetLogLevel(): Int = logLevel
    override fun onUseSystemLogging(): Boolean = useSystemLogging
}