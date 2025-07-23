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

class GemObjectImpl extends GemObject {
  // ignore: unused_field
  late dynamic _objectPtr;
  @override
  void initBase(final int id) {
    // Call platform-specific method to retain JS object
  }
  void initJsObject(final dynamic jsObject) {
    _objectPtr = jsObject;
  }
}
