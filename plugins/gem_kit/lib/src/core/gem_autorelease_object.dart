// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'package:gem_kit/src/core/gem_object_interface.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

/// This class will not be documented.
///
/// @nodoc
class GemAutoreleaseObject {
  GemAutoreleaseObject();
  // ignore: unused_field
  late GemObject _gemObject;

  /// The timestamp when the dart object was created
  ///
  /// Used to make sure the correct object is released
  final int _timestamp = DateTime.now().millisecondsSinceEpoch;

  /// Registers an object for auto release.
  ///
  /// When the object is not used anymore, it will be released automatically from C++.
  void registerAutoReleaseObject(final int pointerId) {
    _gemObject = GemKitPlatform.instance.registerWeakRelease(
      this,
      pointerId,
      _timestamp,
    );
  }
}
