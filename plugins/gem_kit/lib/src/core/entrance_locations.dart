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

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Type of an entrance location.
///
/// {@category Places}
enum EntranceLocationType {
  /// Unknown access type
  unknownAccessType,

  /// Access for vehicles
  vehicleAccess,

  /// Access for pedestrians
  pedestrianAccess,
}

/// This class will not be documented.
///
/// @nodoc
extension EntranceLocationTypeExtension on EntranceLocationType {
  int get id {
    switch (this) {
      case EntranceLocationType.unknownAccessType:
        return 0;
      case EntranceLocationType.vehicleAccess:
        return 1;
      case EntranceLocationType.pedestrianAccess:
        return 2;
    }
  }

  static EntranceLocationType fromId(final int id) {
    switch (id) {
      case 0:
        return EntranceLocationType.unknownAccessType;
      case 1:
        return EntranceLocationType.vehicleAccess;
      case 2:
        return EntranceLocationType.pedestrianAccess;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Stores locations & access types for entrances to landmarks.
///
/// This class should not be instantiated directly. Instead, use the [Landmark.entrances] getter to obtain an instance.
///
/// {@category Places}
class EntranceLocations extends GemAutoreleaseObject {
  // ignore: unused_element
  EntranceLocations._() : _id = 0;

  @internal
  EntranceLocations.init(final int id) : _id = id {
    super.registerAutoReleaseObject(_id);
  }
  final int _id;
  int get id => _id;

  /// Get the entrances count.
  ///
  /// **Returns**
  ///
  /// * The number of entrances
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get count {
    final OperationResult resultString = objectMethod(
      _id,
      'EntranceLocations',
      'getCount',
    );

    return resultString['result'];
  }

  /// Get the coordinates specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** index - Index of entrance location for which the coordinates will be returned.
  ///
  /// **Returns**
  ///
  /// * Coordinates - Coordinates of the entrance location specified by index.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Coordinates? getCoordinates(final int index) {
    if (index > count) {
      return null;
    }

    final OperationResult resultString = objectMethod(
      _id,
      'EntranceLocations',
      'getCoordinates',
      args: index,
    );

    return Coordinates.fromJson(resultString['result']);
  }

  /// Get the entrance type specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** index - Index of entrance location for which the type will be returned.
  ///
  /// **Returns**
  ///
  /// * EntranceLocationType - Type of the entrance location specified by index.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  EntranceLocationType getType(final int index) {
    final OperationResult resultString = objectMethod(
      _id,
      'EntranceLocations',
      'getType',
      args: index,
    );

    return EntranceLocationTypeExtension.fromId(resultString['result']);
  }

  /// Add new entrance location.
  ///
  /// **Parameters**
  ///
  /// * **IN** coordinates - Coordinates of the entrance location.
  /// * **IN** type - Type of the entrance location.
  ///
  /// **Returns**
  ///
  /// * bool - true if the entrance location was added successfully, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool addEntranceLocation({
    required final Coordinates coordinates,
    required final EntranceLocationType type,
  }) {
    final OperationResult resultString = objectMethod(
      _id,
      'EntranceLocations',
      'addEntranceLocation',
      args: <String, dynamic>{
        'entranceType': type.id,
        'coordinates': coordinates,
      },
    );

    return resultString['result'];
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, dynamic>{'class': 'EntranceLocations', 'id': _id}),
      );
}
