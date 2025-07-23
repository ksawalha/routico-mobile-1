// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'package:gem_kit/src/core/auto_update_settings.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

/// GEM SDK global functions.
///
/// {@category Core}
class GemKit {
  /// Initialize GEM SDK.
  ///
  /// All GEM SDK objects must be used only after a successful call to this function
  ///
  /// **Parameters**
  ///
  /// * **IN** *appAuthorization* Application token that enables the SDK. Required for evaluation SDKs.
  /// The map will have a watermark and some features might not work as expected without this parameter.
  ///
  /// * **IN** *autoUpdateSettings* Auto update settings
  static Future<void> initialize({
    final String? appAuthorization,
    final bool allowInternetConnection = true,
    final AutoUpdateSettings autoUpdateSettings = const AutoUpdateSettings(),
  }) =>
      GemKitPlatform.instance.loadNative(
        appAuthorization: appAuthorization,
        autoUpdateSettings: autoUpdateSettings,
        allowInternetConnection: allowInternetConnection,
      );

  /// Release GEM SDK. After this call all remained SDK objects cannot be used.
  static Future<void> release() async {
    await GemKitPlatform.disposeGemSdk();
  }
}
