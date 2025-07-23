// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'package:gem_kit/src/core/coordinates.dart';

/// Timestamp & distance & coordinates structure
///
/// {@category Core}
class TimeDistanceCoordinate {
  /// Creates a new time distance coordinate.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The coordinates.
  /// * **IN** *distance* The distance in meters.
  /// * **IN** *stamp* The time stamp in milliseconds.
  TimeDistanceCoordinate({
    required this.coords,
    this.distance = 0,
    this.stamp = 0,
  });

  factory TimeDistanceCoordinate.fromJson(final Map<String, dynamic> json) {
    return TimeDistanceCoordinate(
      coords: Coordinates.fromJson(json['coords']),
      distance: json['distance'],
      stamp: json['stamp'],
    );
  }

  /// WGS coordinates.
  Coordinates coords;

  /// Relative distance in meters.
  int distance;

  /// Time stamp in milliseconds.
  int stamp;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['coords'] = coords;
    json['distance'] = distance;
    json['stamp'] = stamp;
    return json;
  }

  @override
  bool operator ==(covariant final TimeDistanceCoordinate other) {
    if (identical(this, other)) {
      return true;
    }

    return other.coords == coords &&
        other.distance == distance &&
        other.stamp == stamp;
  }

  @override
  int get hashCode {
    return coords.hashCode ^ distance.hashCode ^ stamp.hashCode;
  }
}
