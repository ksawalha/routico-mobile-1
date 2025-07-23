// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

/// GEM SDK content types.
///
/// {@category Content}
enum ContentType {
  /// Augmented reality car models. Not fully supported in the Flutter Maps SDK.
  carModel,

  /// View styles for high resolution displays (e.g. mobile phones)
  viewStyleHighRes,

  /// Road map
  roadMap,

  /// Human voice. Not fully supported in the Flutter Maps SDK.
  humanVoice,

  /// Computer voice. Not fully supported in the Flutter Maps SDK.
  computerVoice,

  /// View styles for low resolution displays (e.g. desktop monitors)
  viewStyleLowRes,

  /// Unknown content type
  unknown,
}

/// This class will not be documented
/// @nodoc
///
/// {@category Content}
extension ContentTypeExtension on ContentType {
  int get id {
    switch (this) {
      case ContentType.carModel:
        return 1;
      case ContentType.viewStyleHighRes:
        return 2;
      case ContentType.roadMap:
        return 3;
      case ContentType.humanVoice:
        return 4;
      case ContentType.computerVoice:
        return 5;
      case ContentType.viewStyleLowRes:
        return 6;
      case ContentType.unknown:
        return 0;
    }
  }

  static ContentType fromId(final int id) {
    switch (id) {
      case 1:
        return ContentType.carModel;
      case 2:
        return ContentType.viewStyleHighRes;
      case 3:
        return ContentType.roadMap;
      case 4:
        return ContentType.humanVoice;
      case 5:
        return ContentType.computerVoice;
      case 6:
        return ContentType.viewStyleLowRes;
      case 0:
        return ContentType.unknown;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}
