// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

/// Landmark Browse Session
///
/// This class should not be instantiated directly. Instead, use the [LandmarkStore.createLandmarkBrowseSession] getter to obtain an instance.
///
/// {@category Places}
class LandmarkBrowseSession extends GemAutoreleaseObject {
  LandmarkBrowseSession.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }

  /// Get the session id
  ///
  /// **Returns**
  ///
  /// * The session id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get id {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkBrowseSession',
      'getId',
    );

    return resultString['result'];
  }

  /// Get the landmark store id
  ///
  /// **Returns**
  ///
  /// * The [LandmarkStore.id]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get landmarkStoreId {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkBrowseSession',
      'getLandmarkStoreId',
    );

    return resultString['result'];
  }

  /// Get the number of landmarks in the session
  ///
  /// **Returns**
  ///
  /// * The number of landmarks
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get landmarkCount {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkBrowseSession',
      'getLandmarkCount',
    );

    return resultString['result'];
  }

  /// Get the landmarks in the session between the specified start and end index: [start, end)
  ///
  /// **Parameters**
  ///
  /// * **IN** *start* The start index
  /// * **IN** *end* The end index
  ///
  /// **Returns**
  ///
  /// * The list of landmarks
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  List<Landmark> getLandmarks(int start, int end) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkBrowseSession',
      'getLandmarks',
      args: <String, int>{'first': start, 'second': end},
    );

    return LandmarkList.init(resultString['result']).toList();
  }

  /// Get the position of the landmark with the specified [Landmark.id]
  ///
  /// The position is 0 based
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkId* The id of the landmark
  ///
  /// **Returns**
  ///
  /// * The position of the landmark if it is in the session, [GemError.notFound].code otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int getLandmarkPosition(final int landmarkId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkBrowseSession',
      'getLandmarkPos',
      args: landmarkId,
    );

    return resultString['result'];
  }

  /// Get the browse session settings
  ///
  /// Modifing the returned object will have no effect on the session
  ///
  /// **Returns**
  ///
  /// * The settings
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  LandmarkBrowseSessionSettings get settings {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkBrowseSession',
      'getSettings',
    );

    return LandmarkBrowseSessionSettings.fromJson(resultString['result']);
  }

  final int _pointerId;
  int get pointerId => _pointerId;
}

/// Ways in which Landmarks from a [LandmarkBrowseSession] can be ordered
///
/// {@category Core}
enum LandmarkOrder {
  /// Order by landmark name
  name,

  /// Order by landmark date (date of insertion)
  date,

  /// Order by distance relative to the given [Coordinates]
  distance,
}

/// @nodoc
extension LandmarkOrderExtension on LandmarkOrder {
  int get id {
    switch (this) {
      case LandmarkOrder.name:
        return 0;
      case LandmarkOrder.date:
        return 1;
      case LandmarkOrder.distance:
        return 2;
    }
  }

  static LandmarkOrder fromId(final int id) {
    switch (id) {
      case 0:
        return LandmarkOrder.name;
      case 1:
        return LandmarkOrder.date;
      case 2:
        return LandmarkOrder.distance;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Used in specifying the settings of a [LandmarkBrowseSession]
///
/// {@category Core}
class LandmarkBrowseSessionSettings {
  LandmarkBrowseSessionSettings({
    this.descendingOrder = false,
    this.orderBy = LandmarkOrder.name,
    this.nameFilter = '',
    this.categoryIdFilter = LandmarkStore.invalidLandmarkCategId,
    Coordinates? coordinates,
  }) {
    this.coordinates = coordinates ?? Coordinates();
  }

  factory LandmarkBrowseSessionSettings.fromJson(
      final Map<String, dynamic> json) {
    return LandmarkBrowseSessionSettings(
      descendingOrder: json['descendingOrder'],
      orderBy: LandmarkOrderExtension.fromId(json['orderBy']),
      nameFilter: json['nameFilter'],
      categoryIdFilter: json['categoryIdFilter'],
      coordinates: Coordinates.fromJson(json['coordinates']),
    );
  }

  /// Specify if descending order is desired. By default it is ascending.
  bool descendingOrder;

  /// Specify the kind of order desired. By default the landmarks are ordered by name.
  LandmarkOrder orderBy;

  /// Specify the name filter. By default it is empty.
  String nameFilter;

  /// Specify the category filter. By default it is [LandmarkStore.invalidLandmarkCategId].
  int categoryIdFilter;

  /// Coordinates relative to which the order by distance is made in case of [LandmarkOrder.distance]
  late Coordinates coordinates;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['descendingOrder'] = descendingOrder;
    json['orderBy'] = orderBy.id;
    json['nameFilter'] = nameFilter;
    json['categoryIdFilter'] = categoryIdFilter;
    json['coordinates'] = coordinates.toJson();
    return json;
  }

  @override
  bool operator ==(covariant LandmarkBrowseSessionSettings other) =>
      other.descendingOrder == descendingOrder &&
      other.orderBy == orderBy &&
      other.nameFilter == nameFilter &&
      other.categoryIdFilter == categoryIdFilter &&
      other.coordinates == coordinates;

  @override
  int get hashCode =>
      descendingOrder.hashCode ^
      orderBy.hashCode ^
      nameFilter.hashCode ^
      categoryIdFilter.hashCode ^
      coordinates.hashCode;
}
