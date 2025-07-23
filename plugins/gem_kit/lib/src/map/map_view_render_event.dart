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

/// Map view render event
///
/// {@category Maps & 3D Scene}
class MapViewRenderInfo {
  MapViewRenderInfo({
    required this.dataTransitionStatus,
    required this.cameraTransitionStatus,
    required this.area,
    required this.markersIds,
    required this.sourcesIds,
    this.areaSecond,
  });

  factory MapViewRenderInfo.fromJson(final Map<String, dynamic> json) {
    return MapViewRenderInfo(
      dataTransitionStatus: ViewDataTransitionStatusExtension.fromId(
        json['viewDataTransitionStatus'] != 0,
      ),
      cameraTransitionStatus: ViewCameraTransitionStatusExtension.fromId(
        json['cameraStatus'] != 0,
      ),
      area: RectangleGeographicArea(
        topLeft: Coordinates.fromLatLong(json['leftTopX'], json['leftTopY']),
        bottomRight: Coordinates.fromLatLong(
          json['rightBottomX'],
          json['rightBottomY'],
        ),
      ),
      markersIds: json['markersIds'].cast<int>(),
      sourcesIds: json['sourcesIds'].cast<int>(),
    );
  }

  /// View data transition status
  final ViewDataTransitionStatus dataTransitionStatus;

  /// View camera transition status
  final ViewCameraTransitionStatus cameraTransitionStatus;

  /// Geographic area that is rendered on the map
  final RectangleGeographicArea area;

  /// Ids of markers that are rendered on the map
  final List<int> markersIds;

  /// Ids of sources that are rendered on the map
  final List<int> sourcesIds;

  /// Second geographic area that is rendered on the map
  final RectangleGeographicArea? areaSecond;
}

/// Enumeration used to specify view data transition.
///
/// {@category Maps & 3D Scene}
enum ViewDataTransitionStatus {
  /// All data view transitions are complete
  complete,

  /// View data transitions are incomplete because online data is expected to arrive via the connection
  incompleteOnline,
}

/// @nodoc
///
/// {@category Maps & 3D Scene}
extension ViewDataTransitionStatusExtension on ViewDataTransitionStatus {
  bool get id {
    switch (this) {
      case ViewDataTransitionStatus.complete:
        return false;
      case ViewDataTransitionStatus.incompleteOnline:
        return true;
    }
  }

  static ViewDataTransitionStatus fromId(final bool id) {
    switch (id) {
      case false:
        return ViewDataTransitionStatus.complete;
      case true:
        return ViewDataTransitionStatus.incompleteOnline;
    }
  }
}

/// Enumeration used to specify view camera transition.
///
/// {@category Maps & 3D Scene}
enum ViewCameraTransitionStatus {
  /// Camera is stationary
  stationary,

  /// Camera is moving
  moving,
}

/// @nodoc
///
/// {@category Maps & 3D Scene}
extension ViewCameraTransitionStatusExtension on ViewCameraTransitionStatus {
  bool get id {
    switch (this) {
      case ViewCameraTransitionStatus.stationary:
        return false;
      case ViewCameraTransitionStatus.moving:
        return true;
    }
  }

  static ViewCameraTransitionStatus fromId(final bool id) {
    switch (id) {
      case false:
        return ViewCameraTransitionStatus.stationary;
      case true:
        return ViewCameraTransitionStatus.moving;
    }
  }
}
