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
import 'package:gem_kit/map.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Geographic coordinates referenced list of item alarms.
///
/// {@category Routes & Navigation}
abstract class AlarmsList<T> {
  /// Get reference coordinates.
  ///
  /// **Returns**
  ///
  /// * The reference coordinates
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Coordinates get referenceCoordinates;

  /// Get the distance in meters from the item to the reference coordinate.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The index of the overlay item.
  ///
  /// **Returns**
  ///
  /// * The distance to the item specified by index, or 0 if the index is not in range
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int getDistance(final int index);

  /// Get the number of items.
  ///
  /// **Returns**
  ///
  /// * The number of items
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get size;

  /// The items list
  ///
  /// **Returns**
  ///
  /// * The items list of the given type
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  List<T> get items;
}

/// Geographic coordinates referenced list of [OverlayItem] alarms.
///
/// {@category Routes & Navigation}
class OverlayItemAlarmsList extends GemAutoreleaseObject
    implements AlarmsList<OverlayItemPosition> {
  @internal
  OverlayItemAlarmsList.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  dynamic get pointerId => _pointerId;

  @override
  Coordinates get referenceCoordinates {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItemAlarmsList',
      'getReferenceCoordinates',
    );

    return Coordinates.fromJson(resultString['result']);
  }

  @override
  int getDistance(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItemAlarmsList',
      'getDistance',
      args: index,
    );

    return resultString['result'];
  }

  @override
  int get size {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItemAlarmsList',
      'size',
    );

    return resultString['result'];
  }

  @override
  List<OverlayItemPosition> get items {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItemAlarmsList',
      'getItems',
    );

    final OverlayItemPositionList list = OverlayItemPositionList.init(
      resultString['result'],
    );
    return list.toList();
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, Object>{
        'class': 'OverlayItemAlarmsList',
        'id': _pointerId,
      }),
    );
  }
}

/// Geographic coordinates referenced list of [Landmark] alarms.
///
/// {@category Routes & Navigation}
class LandmarkAlarmsList extends GemAutoreleaseObject
    implements AlarmsList<LandmarkPosition> {
  @internal
  LandmarkAlarmsList.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  dynamic get pointerId => _pointerId;

  @override
  Coordinates get referenceCoordinates {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkAlarmsList',
      'getReferenceCoordinates',
    );

    return Coordinates.fromJson(resultString['result']);
  }

  @override
  int getDistance(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkAlarmsList',
      'getDistance',
      args: index,
    );

    return resultString['result'];
  }

  @override
  int get size {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkAlarmsList',
      'size',
    );

    return resultString['result'];
  }

  @override
  List<LandmarkPosition> get items {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkAlarmsList',
      'getItems',
    );

    final LandmarkPositionList list = LandmarkPositionList.init(
      resultString['result'],
    );
    return list.toList();
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, Object>{
        'class': 'LandmarkAlarmsList',
        'id': _pointerId,
      }),
    );
  }
}
