// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/images.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Landmark category class
///
/// {@category Core}
class LandmarkCategory extends GemAutoreleaseObject {
  factory LandmarkCategory() {
    return LandmarkCategory._create();
  }

  @internal
  LandmarkCategory.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Get the category Id.
  ///
  /// **Returns**
  ///
  /// * The category Id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get id {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkCategory',
      'getId',
    );

    return resultString['result'];
  }

  /// Get the category image.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* Size of the image
  /// * **IN** *format* Format of the image
  ///
  /// **Returns**
  ///
  /// * The category image if available, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Uint8List? getImage({final Size? size, final ImageFileFormat? format}) {
    return GemKitPlatform.instance.callGetImage(
      _pointerId,
      'LandmarkCategory',
      size?.width.toInt() ?? -1,
      size?.height.toInt() ?? -1,
      format?.id ?? -1,
    );
  }

  /// Get the category image
  ///
  /// **Returns**
  ///
  /// * Category image. The user is responsible to check if the image is valid
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Img get img {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkCategory',
      'getImg',
    );

    return Img.init(resultString['result']);
  }

  /// Get the category name.
  ///
  /// **Returns**
  ///
  /// * The category name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkCategory',
      'getName',
    );

    return resultString['result'];
  }

  /// Set the category name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* Category name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set name(final String name) {
    objectMethod(_pointerId, 'LandmarkCategory', 'setName', args: name);
  }

  /// Get parent landmark store id. If the category doesn't belong to a landmark store the function will return [GemError.notFound].code
  ///
  /// **Returns**
  ///
  /// * The landmark store id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get landmarkStoreId {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkCategory',
      'getLandmarkStoreId',
    );

    return resultString['result'];
  }

  static LandmarkCategory _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'LandmarkCategory'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return LandmarkCategory.init(decodedVal['result']);
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(
            <String, Object>{'class': 'LandmarkCategory', 'id': _pointerId}),
      );
}
