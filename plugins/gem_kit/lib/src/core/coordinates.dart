// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'dart:math';

/// Coordinates class
///
/// {@category Core}
class Coordinates {
  /// Create a coordinates object from latitude, longitude and altitude.
  ///
  /// **Parameters**
  ///
  /// * **IN** *latitude* Latitude in degrees. Valid values **-90.0 - +90.0**.
  /// * **IN** *longitude* Longitude in degrees. Valid values **-180.0 - +180.0**.
  /// * **IN** *altitude* Altitude in meters.
  /// * **IN** *horizontalaccuracy* Latitude / longitude accuracy in meters. Deprecated, will be ignored.
  /// * **IN** *verticalaccuracy* Altitude accuracy in meters. Deprecated, will be ignored.
  /// * **IN** *sceneobject* Parent scene object in which coordinates system values are expressed.
  Coordinates({
    this.latitude = 2147483647,
    this.longitude = 2147483647,
    this.altitude = 0,
    @Deprecated('horizontal & vertical accuracy were removed from Coordinates.')
    this.horizontalaccuracy = 0,
    @Deprecated('horizontal & vertical accuracy were removed from Coordinates.')
    this.verticalaccuracy = 0,
    this.sceneobject = 0,
  });

  /// Create a coordinates object from latitude, longitude and optional altitude.
  ///
  /// **Parameters**
  ///
  /// * **IN** *latitude* Latitude in degrees. Valid values **-90.0 - +90.0**.
  /// * **IN** *longitude* Longitude in degrees. Valid values **-180.0 - +180.0**.
  /// * **IN** *altitude* Altitude in meters.
  Coordinates.fromLatLong(this.latitude, this.longitude, [this.altitude = 0]) {
    horizontalaccuracy = 0;
    verticalaccuracy = 0;
    sceneobject = 0;
  }

  factory Coordinates.fromJson(final Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['latitude'], // ?? _maxInt32,
      longitude: json['longitude'], // ?? _maxInt32,
      altitude: json['altitude'],
      horizontalaccuracy: json['horizontalaccuracy'],
      verticalaccuracy: json['verticalaccuracy'],
      sceneobject: json['sceneobject'],
    );
  }

  /// Latitude in degrees. Valid values -90.0 .. +90.00.
  ///
  /// It is positive towards the north pole. Negative values are towards the south pole.
  /// At the Equator the value is 0.
  double latitude;

  /// Longitude in degrees. Valid values -180.0 .. +180.00.
  ///
  /// It is positive towards the east. Negative values are towards the west.
  /// At the  Greenwich meridian the value is 0.
  double longitude;

  /// Altitude in meters.
  ///
  /// It can be negative.
  double? altitude;

  /// Horizontal accuracy of the location in meters.
  @Deprecated('horizontal & vertical accuracy were removed from Coordinates')
  double? horizontalaccuracy;

  /// Vertical accuracy of the location in meters.
  @Deprecated('horizontal & vertical accuracy were removed from Coordinates')
  double? verticalaccuracy;

  /// Parent scene object to which coordinates belongs.
  ///
  /// Scene object id.
  int? sceneobject;

  /// Create a new coordinates object with the same proprieties as the original.
  ///
  /// **Returns**
  ///
  /// * a new Coordinates object with the same proprieties
  Coordinates get copy {
    return Coordinates(
      latitude: latitude,
      longitude: longitude,
      altitude: altitude,
      horizontalaccuracy: horizontalaccuracy,
      verticalaccuracy: verticalaccuracy,
      sceneobject: sceneobject,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['latitude'] = latitude;
    json['longitude'] = longitude;
    if (altitude != null) {
      json['altitude'] = altitude;
    }
    if (horizontalaccuracy != null) {
      json['horizontalaccuracy'] = horizontalaccuracy;
    }
    if (verticalaccuracy != null) {
      json['verticalaccuracy'] = verticalaccuracy;
    }
    if (sceneobject != null) {
      json['sceneobject'] = sceneobject;
    }
    return json;
  }

  /// Calculate the distance in meters between two WGS84 coordinates.
  ///
  /// **Parameters**
  ///
  /// * **IN** *other* The other coordinates
  /// * **IN** *ignoreAltitude* Ignore altitude difference (if they are not null) when calculating the distance
  ///
  /// **Returns**
  ///
  /// Distance in meters between current current coordinates and the [other] parameter
  double distance(final Coordinates other, {bool ignoreAltitude = false}) {
    const double earthRadius = 6371000; // Earth's radius in meters

    double toRadians(final double value) {
      return value * pi / 180; // Convert degrees to radians
    }

    final double deltaLatitude = toRadians(other.latitude - latitude);
    final double deltaLongitude = toRadians(other.longitude - longitude);

    final double a = sin(deltaLatitude / 2) * sin(deltaLatitude / 2) +
        cos(toRadians(latitude)) *
            cos(toRadians(other.latitude)) *
            sin(deltaLongitude / 2) *
            sin(deltaLongitude / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double altitudeDifference = 0;
    if (!ignoreAltitude && other.altitude != null && altitude != null) {
      altitudeDifference = other.altitude! - altitude!;
    }

    final double distance = sqrt(
      (c * c * earthRadius * earthRadius) +
          (altitudeDifference * altitudeDifference),
    );

    return distance;
  }

  /// Checks if the coordinates are valid
  ///
  /// **Returns**
  ///
  /// * True if the coordinates are valid, false otherwise
  bool get isValid {
    return (latitude.toInt() != _maxInt32 && longitude.toInt() != _maxInt32) &&
        (latitude != -99999 && longitude != -99999);
  }

  /// Creates a new coordinates object with the given meters offset
  ///
  /// **Parameters**
  ///
  /// * **IN** *metersLatitude* Latitude offset in meters
  /// * **IN** *metersLongitude* Longitude offset in meters
  ///
  /// **Returns**
  ///
  /// * A new [Coordinates] object with the given meters offset
  Coordinates copyWithMetersOffset({
    required final int metersLatitude,
    required final int metersLongitude,
  }) {
    const double earthRadius = 6371000; // Earth's radius in meters
    final double latitudeInDegrees = metersLatitude / earthRadius * (180 / pi);
    final double longitudeInDegrees =
        metersLongitude / (earthRadius * cos(latitude * pi / 180)) * (180 / pi);

    return Coordinates(
      latitude: latitude + latitudeInDegrees,
      longitude: longitude + longitudeInDegrees,
      altitude: altitude,
      horizontalaccuracy: horizontalaccuracy,
      verticalaccuracy: verticalaccuracy,
      sceneobject: sceneobject,
    );
  }

  @override
  bool operator ==(covariant final Coordinates other) {
    if (identical(this, other)) {
      return true;
    }

    return other.latitude == latitude &&
        other.longitude == longitude &&
        other.altitude == altitude;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^ longitude.hashCode ^ altitude.hashCode;
  }

  @override
  String toString() {
    return 'Coordinates(lat: $latitude, long: $longitude, alt: $altitude, ha: $horizontalaccuracy, va: $verticalaccuracy, so: $sceneobject)';
  }

  static const int _maxInt32 = (1 << 31) - 1;
}
