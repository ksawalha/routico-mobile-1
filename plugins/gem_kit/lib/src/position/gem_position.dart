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
import 'package:gem_kit/sense.dart';

/// Position provider
///
/// {@category Sensor Data Source}
enum Provider {
  /// @brief The position provider is unknown.
  unknown,

  /// @brief The position is obtained from a GPS sensor.
  gps,

  /// @brief The position is obtained from a network-based source.
  network,

  /// @brief The position is improved using inertial sensors for better accuracy.
  sensorFusion,

  /// @brief The position is matched with a map for better accuracy.
  mapMatching,

  /// @brief The position data comes from a simulation environment.
  simulation,
}

/// @nodoc
///
/// This class will not be documented.
extension ProviderExtension on Provider {
  int get id {
    switch (this) {
      case Provider.unknown:
        return 0;
      case Provider.gps:
        return 1;
      case Provider.network:
        return 2;
      case Provider.sensorFusion:
        return 3;
      case Provider.mapMatching:
        return 4;
      case Provider.simulation:
        return 5;
    }
  }

  static Provider fromId(final int id) {
    switch (id) {
      case 0:
        return Provider.unknown;
      case 1:
        return Provider.gps;
      case 2:
        return Provider.network;
      case 3:
        return Provider.sensorFusion;
      case 4:
        return Provider.mapMatching;
      case 5:
        return Provider.simulation;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Position class
///
/// More map-matched information about position is provided by the [GemImprovedPosition] class.
///
/// {@category Sensor Data Source}
abstract class GemPosition extends SenseData {
  /// Satellite timestamp.
  ///
  /// Timestamps are expected to increase monotonously for subsequent positions; data with timestamp from the past will be discarded.
  DateTime get satelliteTime;

  /// Provider type: GPS, Network, Unknown
  Provider get provider;

  /// Geographical latitude in degrees.
  ///
  /// From -90 to +90; positive on northern hemisphere
  /// If value is out of the -90...90 range, the position is considered invalid.
  double get latitude;

  /// Geographical longitude in degrees.
  /// From -180 to +180; positive on eastern hemisphere
  /// If value is out of the -180...180 range, the position is considered invalid.
  double get longitude;

  /// Altitude above main sea level in meters.
  ///
  /// It can be negative or positive
  double get altitude;

  /// Travel speed in m/s.
  ///
  /// A negative value (-1 by default) means the position has no speed information.
  /// If car is going backwards, the course should change by 180, but the speed should still be non-negative.
  double get speed;

  /// Travel speed accuracy in m/s.
  ///
  /// Typical accuracy for consumer GPS is 2 m/s at steady speed and high position accuracy.
  /// Valid speed accuracy should always be positive.
  double get speedAccuracy;

  /// The course (direction) of the movement in degrees.
  ///
  /// Represents true heading, not magnetic heading.
  /// 0 means true north, 90 east, 180 south, 270 west.
  /// A negative value (-1 by default) means the position has no course information.
  double get course;

  /// Course accuracy in degrees.
  /// @details Typical accuracy for consumer GPS is 25 degrees at high speeds.
  /// @details Valid course accuracy should always be positive.
  double get courseAccuracy;

  /// Horizontal accuracy of position.
  ///
  /// Typical accuracy for consumer GPS is 5-20 meters.
  /// Valid position accuracy should always be positive.
  /// The horizontal position accuracy in meters.
  double get accuracyH;

  /// Vertical accuracy of position.
  ///
  /// Valid position accuracy should always be positive.
  /// The vertical position accuracy in meters.
  double get accuracyV;

  /// Fix quality (whether this position is trustworthy). See [PositionQuality] for details.
  PositionQuality get fixQuality;

  /// Query if this object has coordinates.
  ///
  /// Returns true if coordinates are available and valid, false if not.
  bool get hasCoordinates;

  /// Altitude above main sea level.
  ///
  /// The altitude in meters.
  bool get hasAltitude;

  /// Query if this object has speed.
  ///
  /// Returns true if speed is available and valid, false if not.
  bool get hasSpeed;

  /// Query if this object has speed.
  ///
  /// Returns true if speed accuracy is available and valid, false if not.
  bool get hasSpeedAccuracy;

  /// Query if this object has course.
  ///
  /// Returns true if course is available and valid, false if not.
  bool get hasCourse;

  /// Query if this object has course accuracy.
  ///
  /// Returns true if course accuracy is available and valid, false if not.
  bool get hasCourseAccuracy;

  /// Query if this object has horizontal accuracy.
  ///
  /// Returns true if horizontal accuracy is available and valid, false if not.
  bool get hasHorizontalAccuracy;

  /// Query if this object has vertical accuracy.
  ///
  /// Returns true if vertical accuracy is available and valid, false if not.
  bool get hasVerticalAccuracy;

  /// Geographical coordinates of the position.
  ///
  /// Contains given latitude, longitude and altitude
  Coordinates get coordinates =>
      Coordinates(latitude: latitude, longitude: longitude, altitude: altitude);

  @Deprecated('Use satelliteTime instead')
  DateTime get timestamp => satelliteTime;
}

/// Improved position class
///
/// Contains additional information than [GemPosition] obtained via map matching.
///
/// {@category Sensor Data Source}
abstract class GemImprovedPosition extends GemPosition {
  /// Position road modifiers.
  ///
  /// Provides information about the road the position is on.
  Set<RoadModifier> get roadModifiers;

  /// Get position road speed limit in m/s.
  ///
  /// If speed limit doesn't exist in map data, 0 is returned.
  double get speedLimit;

  /// Check if improved position has a road localization.
  ///
  /// True of false accordingly.
  bool get hasRoadLocalization;

  /// Check if improved position has terrain data.
  ///
  /// True of false accordingly.
  bool get hasTerrainData;

  /// Get terrain altitude.
  ///
  /// This a map data based value comparing to [altitude] which is GPS sensor data.
  /// The terrain altitude in meters.
  double get terrainAltitude;

  /// Get terrain slope in degrees.
  ///
  /// The current slope in degrees, positive value for ascent, negative for descent.
  double get terrainSlope;

  /// Get position road address.
  ///
  /// The address info reference.
  AddressInfo get address;
}
