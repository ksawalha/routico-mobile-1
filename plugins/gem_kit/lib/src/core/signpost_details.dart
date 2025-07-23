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

import 'package:gem_kit/core.dart';
import 'package:gem_kit/navigation.dart';
import 'package:gem_kit/src/core/extensions.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Signpost details class
///
/// This class should not be instantiated directly. Instead, use the [NavigationInstruction.signpostDetails] getter to obtain an instance.
///
/// {@category Core}
class SignpostDetails extends GemAutoreleaseObject {
  // ignore: unused_element
  SignpostDetails._() : _pointerId = -1;

  @internal
  SignpostDetails.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Get the background color for the signpost.
  ///
  /// **Returns**
  ///
  /// * The background color for the signpost.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Color get backgroundColor {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostDetails',
      'getBackgroundColor',
    );

    return ColorExtension.fromJson(resultString['result']);
  }

  /// Get the border color for the signpost.
  ///
  /// **Returns**
  ///
  /// * The border color for the signpost.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Color get borderColor {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostDetails',
      'getBorderColor',
    );

    return ColorExtension.fromJson(resultString['result']);
  }

  /// Get the text color for the signpost.
  ///
  /// **Returns**
  ///
  /// * The text color for the signpost.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Color get textColor {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostDetails',
      'getTextColor',
    );

    return ColorExtension.fromJson(resultString['result']);
  }

  /// Check the background color for the signpost.
  ///
  /// **Returns**
  ///
  /// * True if the signpost has a background color, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasBackgroundColor {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostDetails',
      'hasBackgroundColor',
    );

    return resultString['result'];
  }

  /// Check the border color for the signpost.
  ///
  /// **Returns**
  ///
  /// * True if the signpost has a border color, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasBorderColor {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostDetails',
      'hasBorderColor',
    );

    return resultString['result'];
  }

  /// Check the text color for the signpost.
  ///
  /// **Returns**
  ///
  /// * True if the signpost has a text color, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasTextColor {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostDetails',
      'hasTextColor',
    );

    return resultString['result'];
  }

  /// Get the image of this SignpostDetails.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The image sizes
  /// * **IN** *format* [ImageFileFormat] of the image.
  /// * **IN** *renderSettings* [SignpostImageRenderSettings] of the image.
  ///
  /// **Returns**
  ///
  /// * The image if it is available, otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Uint8List? getImage({
    final Size? size,
    final ImageFileFormat? format,
    final SignpostImageRenderSettings renderSettings =
        const SignpostImageRenderSettings(),
  }) {
    return GemKitPlatform.instance.callGetImage(
      pointerId,
      'SignPostDetailsGetImage',
      size?.width.toInt() ?? -1,
      size?.height.toInt() ?? -1,
      format?.id ?? -1,
      arg: jsonEncode(renderSettings),
    );
  }

  /// Get the image of this SignpostDetails.
  ///
  /// **Parameters**
  ///
  /// **Returns**
  ///
  /// * The image for the signpost. The user is responsible to check if the image is valid.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  SignpostImg get image {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostDetails',
      'getImg',
    );

    return SignpostImg.init(resultString['result']);
  }

  /// Get the list with SignpostItem elements.
  ///
  /// **Returns**
  ///
  /// * The list with [SignpostItem] elements.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<SignpostItem> get items {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostDetails',
      'getItems',
    );

    return SignpostItemList.init(resultString['result']).toList();
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, Object>{
        'class': 'SignpostDetails',
        'id': _pointerId,
      }),
    );
  }
}

/// SignpostItem object.
///
/// This class should not be instantiated directly. Instead, use the [SignpostDetails.items] getter to a list of instances.
///
/// {@category Core}
class SignpostItem extends GemAutoreleaseObject {
  // ignore: unused_element
  SignpostItem._() : _pointerId = -1;

  @internal
  SignpostItem.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Get the one based column.
  ///
  /// Not all items may have a column assigned.
  ///
  /// **Returns**
  ///
  /// * Column of the item. Zero indicates N/A
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get column {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostItem',
      'getColumn',
    );

    return resultString['result'];
  }

  /// Get the connection.
  ///
  /// **Returns**
  ///
  /// * Connection type of the item.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  SignpostConnectionInfo get connectionInfo {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostItem',
      'getConnectionInfo',
    );

    return SignpostConnectionInfoExtension.fromId(resultString['result']);
  }

  /// Get the one based column.
  ///
  /// Not all items may have a phoneme assigned.
  ///
  /// **Returns**
  ///
  /// * Phoneme of the item
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get phoneme {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostItem',
      'getPhoneme',
    );

    return resultString['result'];
  }

  /// Gets the pictogram type for the item.
  ///
  /// Only items with type [SignpostItemType.pictogram] will return a valid value.
  ///
  /// **Returns**
  ///
  /// * The pictogram type for the signpost.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  SignpostPictogramType get pictogramType {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostItem',
      'getPictogramType',
    );

    return SignpostPictogramTypeExtension.fromId(resultString['result']);
  }

  /// Get the one based row.
  ///
  /// Not all items may have a row assigned.
  ///
  /// **Returns**
  ///
  /// * Row of the item. Zero indicates N/A
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get row {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostItem',
      'getRow',
    );

    return resultString['result'];
  }

  /// Get the shield type for the item.
  ///
  /// Only items with type [SignpostItemType.routeNumber] will return a valid value.
  ///
  /// **Returns**
  ///
  /// * The shield type for the signpost.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RoadShieldType get shieldType {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostItem',
      'getShieldType',
    );

    return RoadShieldTypeExtension.fromId(resultString['result']);
  }

  /// Get the text.
  ///
  /// Not all items may have text assigned.
  ///
  /// **Returns**
  ///
  /// * Text of the item.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get text {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostItem',
      'getText',
    );

    return resultString['result'];
  }

  /// Get the type.
  ///
  /// **Returns**
  ///
  /// * Type of the item.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  SignpostItemType get type {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostItem',
      'getType',
    );

    return SignpostItemTypeExtension.fromId(resultString['result']);
  }

  /// Get the ambiguity.
  ///
  /// **Returns**
  ///
  /// * True for items with ambiguity. Don't use such items for TTS.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasAmbiguity {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostItem',
      'hasAmbiguity',
    );

    return resultString['result'];
  }

  /// Get the shield level.
  ///
  /// **Returns**
  ///
  /// * True for road code items with same shield level as the road the signpost is attached to.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasSameShieldLevel {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SignpostItem',
      'hasSameShieldLevel',
    );

    return resultString['result'];
  }
}
