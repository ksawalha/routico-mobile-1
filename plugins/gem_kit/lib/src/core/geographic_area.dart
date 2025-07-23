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

import 'package:flutter/foundation.dart';
import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/coordinates.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Types of geographic areas
///
/// {@category Core}
enum GeographicAreaType {
  // Undefined
  undefined,

  // Circle area
  circle,

  // Rectangle area
  rectangle,

  // Polygon area
  polygon,

  // Area representing as a collection of tiles
  tileCollection,
}

/// @nodoc
///
/// {@category Core}
extension GeographicAreaTypeExtension on GeographicAreaType {
  int get id {
    switch (this) {
      case GeographicAreaType.undefined:
        return 0;
      case GeographicAreaType.circle:
        return 1;
      case GeographicAreaType.rectangle:
        return 2;
      case GeographicAreaType.polygon:
        return 3;
      case GeographicAreaType.tileCollection:
        return 4;
    }
  }

  static GeographicAreaType fromId(final int id) {
    switch (id) {
      case 0:
        return GeographicAreaType.undefined;
      case 1:
        return GeographicAreaType.circle;
      case 2:
        return GeographicAreaType.rectangle;
      case 3:
        return GeographicAreaType.polygon;
      case 4:
        return GeographicAreaType.tileCollection;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// This object represents a geographical area on the surface of a WGS 84 Ellipsoid.
///
/// In the calculations related to these geographical areas the altitude information contained in the Coordinates
/// object is ignored. All geographical areas deal with [Coordinates] objects.
///
/// The [TilesCollectionGeographicArea] class is treated differently from other geographical areas. Its bounding box is used instead of the full object
///
/// {@category Core}
abstract class GeographicArea {
  factory GeographicArea.fromJson(final Map<String, dynamic> json) {
    switch (json['type']) {
      case 1:
        return CircleGeographicArea.fromJson(json);
      case 2:
        return RectangleGeographicArea.fromJson(json);
      case 3:
        return PolygonGeographicArea.fromJson(json);
      default:
        return RectangleGeographicArea(
          topLeft: Coordinates(),
          bottomRight: Coordinates(),
        );
    }
  }

  /// Checks if the specified point is contained within the geographic area.
  ///
  /// **Parameters**
  ///
  /// * **IN** *point* A [Coordinates] object representing the point to check.
  ///
  /// **Returns**
  ///
  /// * True if the point is within the geographic area, false otherwise.
  bool containsCoordinates(final Coordinates point);

  /// Get the bounding box.
  /// This is the smallest rectangle that can be drawn around the area such that it surrounds this geographic area
  /// completely.
  ///
  /// If the area is bigger than what is allowed in the WGS 84 coordinate system, the rectangle is truncated to valid
  /// WGS 84 coordinate values. The RectangleGeographicArea is always aligned with parallels and meridians.
  ///
  /// **Returns**
  /// * A [RectangleGeographicArea] object representing the bounding box.
  RectangleGeographicArea get boundingBox;

  /// Retrieves the center point of the geographic area.
  /// Calculates and returns the geographic center of the area.
  ///
  /// **Returns**
  ///
  /// * [Coordinates] object representing the center point of the area.
  Coordinates get centerPoint;

  /// Checks if the geographic area is empty.
  ///
  /// **Returns**
  ///
  /// * true if the area is empty, false otherwise.
  bool get isEmpty;

  /// Retrieves the specific type of the geographic area.
  ///
  /// **Returns**
  ///
  /// * The [GeographicAreaType] of the area.
  GeographicAreaType get type;

  Map<String, dynamic> toJson();
}

/// RectangleGeographicArea object.
///
/// {@category Core}
class RectangleGeographicArea implements GeographicArea {
  RectangleGeographicArea({required this.topLeft, required this.bottomRight});

  factory RectangleGeographicArea.fromJson(final Map<String, dynamic> json) {
    return RectangleGeographicArea(
      topLeft: Coordinates.fromJson(json['topleft']),
      bottomRight: Coordinates.fromJson(json['bottomright']),
    );
  }
  Coordinates topLeft;
  Coordinates bottomRight;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['topleft'] = topLeft.toJson();
    json['bottomright'] = bottomRight.toJson();
    json['type'] = 2;
    return json;
  }

  /// Checks if this rectangle intersects with another rectangle.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area*	The [RectangleGeographicArea] to check intersection with.
  ///
  /// **Returns**
  ///
  /// * True if the rectangles intersect, false otherwise.
  bool intersects(final RectangleGeographicArea area) {
    return bottomRight.longitude >= area.topLeft.longitude &&
        area.bottomRight.longitude >= topLeft.longitude &&
        topLeft.latitude >= area.bottomRight.latitude &&
        area.topLeft.latitude >= bottomRight.latitude;
  }

  /// Checks if this rectangle completely contains another rectangle.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area*	The [RectangleGeographicArea] to check containment of.
  ///
  /// **Returns**
  ///
  /// * True if this rectangle contains the other, false otherwise.
  bool contains(final RectangleGeographicArea area) {
    return bottomRight.longitude >= area.bottomRight.longitude &&
        topLeft.longitude <= area.topLeft.longitude &&
        topLeft.latitude >= area.topLeft.latitude &&
        bottomRight.latitude <= area.bottomRight.latitude;
  }

  /// Creates a new RectangleGeographicArea as the union of this rectangle and another rectangle.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area*	The [RectangleGeographicArea] to unite with.
  ///
  /// **Returns**
  ///
  /// * A new [RectangleGeographicArea] object representing the union.
  RectangleGeographicArea makeUnion(final RectangleGeographicArea area) {
    return RectangleGeographicArea(
      topLeft: Coordinates(
        longitude: min(topLeft.longitude, area.topLeft.longitude),
        latitude: max(topLeft.latitude, area.topLeft.latitude),
      ),
      bottomRight: Coordinates(
        longitude: max(bottomRight.longitude, area.bottomRight.longitude),
        latitude: min(bottomRight.latitude, area.bottomRight.latitude),
      ),
    );
  }

  /// Creates a new RectangleGeographicArea as the intersection of this rectangle and another rectangle.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area*	The [RectangleGeographicArea] to intersect with.
  ///
  /// **Returns**
  ///
  /// * A new [RectangleGeographicArea] object representing the intersection.
  RectangleGeographicArea makeIntersection(final RectangleGeographicArea area) {
    return RectangleGeographicArea(
      topLeft: Coordinates(
        longitude: max(topLeft.longitude, area.topLeft.longitude),
        latitude: min(topLeft.latitude, area.topLeft.latitude),
      ),
      bottomRight: Coordinates(
        longitude: min(bottomRight.longitude, area.bottomRight.longitude),
        latitude: max(bottomRight.latitude, area.bottomRight.latitude),
      ),
    );
  }

  /// Create a new RectangleGeographicArea object with the same properties as the original.
  ///
  /// **Returns**
  /// * a new Coordinates object with the same properties
  RectangleGeographicArea get copy {
    return RectangleGeographicArea(
      topLeft: topLeft.copy,
      bottomRight: bottomRight.copy,
    );
  }

  @override
  bool get isEmpty {
    return topLeft.longitude - bottomRight.longitude == 0.0 &&
        topLeft.latitude - bottomRight.latitude == 0.0;
  }

  @override
  RectangleGeographicArea get boundingBox => copy;

  @override
  bool containsCoordinates(final Coordinates point) {
    return (point.longitude >= topLeft.longitude &&
            point.longitude <= bottomRight.longitude) &&
        (point.latitude <= topLeft.latitude &&
            point.latitude >= bottomRight.latitude);
  }

  @override
  Coordinates get centerPoint {
    final bool isAltitudeNull =
        topLeft.altitude == null || bottomRight.altitude == null;

    return Coordinates(
      latitude: (topLeft.latitude + bottomRight.latitude) * 0.5,
      longitude: (topLeft.longitude + bottomRight.longitude) * 0.5,
      altitude: isAltitudeNull
          ? null
          : (topLeft.altitude! + bottomRight.altitude!) * 0.5,
    );
  }

  @override
  bool operator ==(covariant final RectangleGeographicArea other) {
    if (identical(this, other)) {
      return true;
    }

    return other.topLeft == topLeft && other.bottomRight == bottomRight;
  }

  @override
  int get hashCode => topLeft.hashCode ^ bottomRight.hashCode;

  @override
  String toString() =>
      'RectangleGeographicArea(topleft: $topLeft, bottomright: $bottomRight)';

  @override
  GeographicAreaType get type => GeographicAreaType.rectangle;
}

/// CircleGeographicArea object.
///
/// {@category Core}
class CircleGeographicArea implements GeographicArea {
  CircleGeographicArea({required this.radius, required this.centerCoordinates});

  factory CircleGeographicArea.fromJson(final Map<String, dynamic> json) {
    return CircleGeographicArea(
      radius: json['radius'],
      centerCoordinates: Coordinates.fromJson(json['centerCoordinates']),
    );
  }
  int radius;
  Coordinates centerCoordinates;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['radius'] = radius;
    json['centerCoordinates'] = centerCoordinates;
    json['type'] = 1;

    return json;
  }

  @override
  RectangleGeographicArea get boundingBox {
    return RectangleGeographicArea(
      topLeft: centerCoordinates.copyWithMetersOffset(
        metersLatitude: -radius,
        metersLongitude: -radius,
      ),
      bottomRight: centerCoordinates.copyWithMetersOffset(
        metersLatitude: radius,
        metersLongitude: radius,
      ),
    );
  }

  @override
  Coordinates get centerPoint {
    return centerCoordinates.copy;
  }

  @override
  bool containsCoordinates(final Coordinates point) {
    return point.distance(centerCoordinates, ignoreAltitude: true) <= radius;
  }

  @override
  bool get isEmpty => radius == 0;

  @override
  bool operator ==(covariant final CircleGeographicArea other) {
    if (identical(this, other)) {
      return true;
    }

    return other.radius == radius &&
        other.centerCoordinates == centerCoordinates;
  }

  @override
  int get hashCode => radius.hashCode ^ centerCoordinates.hashCode;

  @override
  String toString() =>
      'CircleGeographicArea(radius: $radius, centerCoordinates: $centerCoordinates)';
  @override
  GeographicAreaType get type => GeographicAreaType.circle;
}

/// PolygonGeographicArea object.
///
/// {@category Core}
class PolygonGeographicArea implements GeographicArea {
  PolygonGeographicArea({this.coordinates = const <Coordinates>[]});

  factory PolygonGeographicArea.fromJson(final Map<String, dynamic> json) {
    final List<Coordinates> coords = (json['coordinates'] as List<dynamic>)
        .map((dynamic e) => Coordinates.fromJson(e))
        .toList();
    return PolygonGeographicArea(coordinates: coords);
  }
  List<Coordinates> coordinates;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['coordinates'] = coordinates;
    json['type'] = 3;
    return json;
  }

  @override
  RectangleGeographicArea get boundingBox {
    if (coordinates.isEmpty) {
      return RectangleGeographicArea(
        topLeft: Coordinates(),
        bottomRight: Coordinates(),
      );
    }

    late double left, right, top, bottom;
    left = right = coordinates.first.longitude;
    top = bottom = coordinates.first.latitude;

    for (final Coordinates coordinate in coordinates) {
      right = max(right, coordinate.longitude);
      bottom = min(bottom, coordinate.latitude);
      left = min(left, coordinate.longitude);
      top = max(top, coordinate.latitude);
    }

    return RectangleGeographicArea(
      topLeft: Coordinates(longitude: left, latitude: top),
      bottomRight: Coordinates(longitude: right, latitude: bottom),
    );
  }

  @override
  Coordinates get centerPoint {
    final int nVecs = coordinates.length;

    if (nVecs < 3) {
      return Coordinates();
    }

    double ai, atmp = 0, xtmp = 0, ytmp = 0;

    int i = nVecs - 1;
    int j = 0;

    while (j < nVecs) {
      final Coordinates ci = coordinates[i];
      final Coordinates cj = coordinates[j];

      ai = _crossProductScalarValue(
        ci.longitude,
        ci.latitude,
        cj.longitude,
        cj.latitude,
      );
      atmp += ai;

      xtmp += (cj.longitude + ci.longitude) * ai;
      ytmp += (cj.latitude + ci.latitude) * ai;

      i = j++;
    }

    if (atmp == 0) {
      return Coordinates();
    }

    return Coordinates(
      longitude: xtmp / (3 * atmp),
      latitude: ytmp / (3 * atmp),
    );
  }

  @override
  bool containsCoordinates(final Coordinates point) {
    final int nVecs = coordinates.length;
    if (nVecs < 3) {
      return false;
    }

    int i = 0;
    int j = nVecs - 1;

    bool status = false;

    while (i < nVecs) {
      final Coordinates ci = coordinates[i];
      final Coordinates cj = coordinates[j];

      if ((ci.latitude > point.latitude) != (cj.latitude > point.latitude)) {
        final double intersectLongitude = (point.latitude - ci.latitude) *
                (cj.longitude - ci.longitude) /
                (cj.latitude - ci.latitude) +
            ci.longitude;

        if (point.longitude < intersectLongitude) {
          status = !status;
        }
      }

      j = i++;
    }

    return status;
  }

  @override
  bool get isEmpty => boundingBox.isEmpty;

  double _crossProductScalarValue(
    final double ax,
    final double ay,
    final double bx,
    final double by,
  ) {
    return ax * by - ay * bx;
  }

  @override
  bool operator ==(covariant final PolygonGeographicArea other) {
    if (identical(this, other)) {
      return true;
    }

    return listEquals(other.coordinates, coordinates);
  }

  @override
  int get hashCode {
    int hash = 0;
    for (final Coordinates coordinate in coordinates) {
      hash = hash ^ coordinate.hashCode;
    }

    return hash;
  }

  @override
  String toString() => 'PolygonGeographicArea(coordinates: $coordinates)';

  @override
  GeographicAreaType get type => GeographicAreaType.polygon;
}

/// TilesCollectionGeographicArea object.
///
/// {@category Core}
class TilesCollectionGeographicArea extends GemAutoreleaseObject
    implements GeographicArea {
  // ignore: unused_element
  TilesCollectionGeographicArea._() : _pointerId = -1;

  @internal
  TilesCollectionGeographicArea.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  @override
  Coordinates get centerPoint {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TilesCollectionGeographicArea',
      'getCenterPoint',
    );

    return Coordinates.fromJson(resultString['result']);
  }

  @override
  RectangleGeographicArea get boundingBox {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TilesCollectionGeographicArea',
      'getBoundingBox',
    );

    return RectangleGeographicArea.fromJson(resultString['result']);
  }

  @override
  bool containsCoordinates(final Coordinates coords) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TilesCollectionGeographicArea',
      'containsCoordinates',
      args: coords,
    );

    return resultString['result'];
  }

  @override
  bool get isEmpty => boundingBox.isEmpty;

  @override
  Map<String, dynamic> toJson() {
    return boundingBox.toJson();
  }

  @override
  GeographicAreaType get type => GeographicAreaType.tileCollection;
}
