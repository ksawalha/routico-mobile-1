// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'dart:core';
import 'dart:math';

/// @nodoc
///
/// {@category Core}
extension Compare<T> on Comparable<T> {
  bool operator <=(final T other) => compareTo(other) <= 0;
  bool operator >=(final T other) => compareTo(other) >= 0;
  bool operator <(final T other) => compareTo(other) < 0;
  bool operator >(final T other) => compareTo(other) > 0;
}

/// A generic type consisting of x and y coordinates.
///
/// {@category Core}
class XyType<T extends num> {
  XyType({required this.x, required this.y});

  XyType.fromPoint(final Point<T> point)
      : x = point.x,
        y = point.y;

  factory XyType.fromJson(final Map<String, dynamic> json) {
    return XyType<T>(x: json['x'] ?? 0, y: json['y'] ?? 0);
  }
  T x;
  T y;

  Point<T> toPoint() => Point<T>(x, y);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['x'] = x;
    json['y'] = y;
    return json;
  }

  @override
  bool operator ==(covariant final XyType<T> other) {
    if (identical(this, other)) {
      return true;
    }

    return other.x == x && other.y == y;
  }

  @override
  int get hashCode {
    return x.hashCode ^ y.hashCode;
  }
}

/// A generic type consisting of x, y, width and height coordinates.
///
/// {@category Core}
class RectType<T extends num> {
  RectType({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory RectType.fromJson(final Map<String, dynamic> json) {
    return RectType<T>(
      x: json['x'] ?? 0,
      y: json['y'] ?? 0,
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }

  /// Create an object from a [Rectangle]
  factory RectType.fromRectangle(final Rectangle<T> rectangle) => RectType<T>(
        x: rectangle.left,
        y: rectangle.top,
        width: rectangle.width,
        height: rectangle.height,
      );
  T x;
  T y;
  T width;
  T height;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['x'] = x;
    json['y'] = y;
    json['width'] = width;
    json['height'] = height;
    return json;
  }

  @override
  bool operator ==(covariant final RectType<T> other) {
    if (identical(this, other)) {
      return true;
    }

    return other.x == x &&
        other.y == y &&
        other.width == width &&
        other.height == height;
  }

  /// Transform the object to a [Rectangle]
  Rectangle<T> get toRectangle => Rectangle<T>(x, y, width, height);

  @override
  int get hashCode {
    return x.hashCode ^ y.hashCode ^ width.hashCode ^ height.hashCode;
  }
}

/// Time distance representation based on meters and seconds.
///
/// {@category Core}
class TimeDistance {
  /// Constructor with unrestricted and restricted times and distances
  ///
  /// **Parameters**
  ///
  /// * **IN** *unrestrictedTimeS* Unrestricted time in seconds
  /// * **IN** *restrictedTimeS* Restricted time in seconds
  /// * **IN** *unrestrictedDistanceM* Unrestricted distance in meters
  /// * **IN** *restrictedDistanceM* Restricted distance in meters
  /// * **IN** *ndBeginEndRatio* Restricted begin/end ratio
  TimeDistance({
    this.unrestrictedTimeS = 0,
    this.restrictedTimeS = 0,
    this.unrestrictedDistanceM = 0,
    this.restrictedDistanceM = 0,
    this.ndBeginEndRatio = -1.0,
  });

  factory TimeDistance.fromJson(final Map<String, dynamic> json) {
    return TimeDistance(
      unrestrictedTimeS: json['unrestrictedTimeS'] ?? 0,
      restrictedTimeS: json['restrictedTimeS'] ?? 0,
      unrestrictedDistanceM: json['unrestrictedDistanceM'] ?? 0,
      restrictedDistanceM: json['restrictedDistanceM'] ?? 0,
      ndBeginEndRatio: json['ndBeginEndRatio'] ?? -1.0,
    );
  }

  /// Unrestricted time in seconds
  int unrestrictedTimeS;

  /// Restricted time in seconds
  int restrictedTimeS;

  /// Unrestricted distance in meters
  int unrestrictedDistanceM;

  /// Restricted distance in meters
  int restrictedDistanceM;

  /// Restricted begin/end ratio.
  double ndBeginEndRatio;

  /// Total time in seconds
  int get totalTimeS => unrestrictedTimeS + restrictedTimeS;

  /// Total distance in meters
  int get totalDistanceM => unrestrictedDistanceM + restrictedDistanceM;

  /// Check if empty. Returns true if empty, false otherwise
  bool get isEmpty => totalTimeS == 0;

  /// Check if not empty. Returns true if not empty, false otherwise
  bool get isNotEmpty => !isEmpty;

  /// Check if it has different begin/end.
  /// Returns true if it has different begin/end, false otherwise
  bool get hasRestrictedBeginEndDifferentiation => ndBeginEndRatio >= 0;

  /// Restricted time at begin
  int get restrictedTimeAtBegin {
    if (hasRestrictedBeginEndDifferentiation) {
      return (restrictedTimeS * (1 - ndBeginEndRatio)).round();
    }

    return 0;
  }

  /// Restricted time at begin
  int get restrictedTimeAtEnd {
    if (hasRestrictedBeginEndDifferentiation) {
      return (restrictedTimeS * ndBeginEndRatio).round();
    }

    return 0;
  }

  /// Restricted distance at begin
  int get restrictedDistanceAtBegin {
    if (hasRestrictedBeginEndDifferentiation) {
      return (restrictedDistanceM * (1 - ndBeginEndRatio)).round();
    }

    return 0;
  }

  /// Restricted distance at end
  int get restrictedDistanceAtEnd {
    if (hasRestrictedBeginEndDifferentiation) {
      return (restrictedDistanceM * ndBeginEndRatio).round();
    }

    return 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['unrestrictedTimeS'] = unrestrictedTimeS;
    json['restrictedTimeS'] = restrictedTimeS;
    json['unrestrictedDistanceM'] = unrestrictedDistanceM;
    json['restrictedDistanceM'] = restrictedDistanceM;
    json['ndBeginEndRatio'] = ndBeginEndRatio;
    return json;
  }

  @override
  bool operator ==(covariant final TimeDistance other) {
    if (identical(this, other)) {
      return true;
    }

    return other.unrestrictedTimeS == unrestrictedTimeS &&
        other.restrictedTimeS == restrictedTimeS &&
        other.unrestrictedDistanceM == unrestrictedDistanceM &&
        other.restrictedDistanceM == restrictedDistanceM &&
        other.ndBeginEndRatio == ndBeginEndRatio;
  }

  @override
  int get hashCode {
    return Object.hash(
      unrestrictedTimeS,
      restrictedTimeS,
      unrestrictedDistanceM,
      restrictedDistanceM,
      ndBeginEndRatio,
    );
  }

  TimeDistance operator +(final TimeDistance other) {
    return TimeDistance(
      unrestrictedTimeS: unrestrictedTimeS + other.unrestrictedTimeS,
      restrictedTimeS: restrictedTimeS + other.restrictedTimeS,
      unrestrictedDistanceM:
          unrestrictedDistanceM + other.unrestrictedDistanceM,
      restrictedDistanceM: restrictedDistanceM + other.restrictedDistanceM,
    );
  }
}

/// This class will not be documented
/// @nodoc
///
/// {@category Core}
class Rgba {
  Rgba({this.r = 0, this.g = 0, this.b = 0, this.a = 255});

  factory Rgba.fromDoubleValue({
    required final double r,
    required final double g,
    required final double b,
    final double a = 1.0,
  }) {
    return Rgba(
      r: (r * 255).toInt(),
      g: (g * 255).toInt(),
      b: (b * 255).toInt(),
      a: (a * 255).toInt(),
    );
  }

  factory Rgba.transparent() {
    return Rgba(a: 0);
  }

  factory Rgba.fromJson(final Map<String, dynamic> json) {
    return Rgba(r: json['r'], g: json['g'], b: json['b'], a: json['a']);
  }
  int r;
  int g;
  int b;
  int a;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['r'] = r;
    json['g'] = g;
    json['b'] = b;
    json['a'] = a;
    return json;
  }

  @override
  bool operator ==(covariant final Rgba other) {
    if (identical(this, other)) {
      return true;
    }
    return r == other.r && g == other.g && b == other.b && a == other.a;
  }

  @override
  int get hashCode {
    return r.hashCode ^ g.hashCode ^ b.hashCode ^ a.hashCode;
  }

  @override
  String toString() {
    return 'Rgba(r: $r, g: $g, b: $b, a: $a)';
  }
}

/// SDK version representation as four ints and a text string.
///
/// {@category Core}
class SdkVersion {
  SdkVersion({
    this.minor = 0,
    this.major = 0,
    this.year = 0,
    this.week = 0,
    this.revision = '',
  });

  factory SdkVersion.fromJson(final Map<String, dynamic> json) {
    return SdkVersion(
      minor: json['minor'],
      major: json['major'],
      week: json['week'],
      year: json['year'],
      revision: json['revision'],
    );
  }

  /// Minor SDK version number, such as 2 in version 1.2;
  int minor;

  /// Major SDK version number, such as 1 in version 1.2;
  int major;

  /// SDK year, decimal 1 or 2 digits
  int year;

  /// The week of the year, decimal 1 or 2 digits
  int week;

  /// SDK revision string
  String revision;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['minor'] = minor;
    json['major'] = major;
    json['year'] = year;
    json['week'] = week;
    json['revision'] = revision;
    return json;
  }
}

/// Define the content version with major and minor.
///
/// {@category Core}
class Version implements Comparable<Version> {
  Version({final int encodedVersion = 0}) : _encodedVersion = encodedVersion;

  factory Version.fromJson(final Map<String, dynamic> json) {
    final int encodedVersion = json['version'];
    return Version(encodedVersion: encodedVersion);
  }

  factory Version.fromMajorAndMinor({
    required final int major,
    required final int minor,
  }) {
    return Version(encodedVersion: (minor << 16) | major);
  }

  /// Minor version number
  int get minor => (_encodedVersion >> 16) & 0xFFFF;

  /// Major version number
  int get major => _encodedVersion & 0xFFFF;

  /// Encoded version number
  int _encodedVersion;

  @override
  int compareTo(final Version other) {
    if (major == other.major) {
      return minor.compareTo(other.minor);
    }
    return major.compareTo(other.major);
  }

  @override
  bool operator ==(covariant final Version other) {
    if (identical(this, other)) {
      return true;
    }

    return major == other.major && minor == other.minor;
  }

  /// Check if the version is valid
  ///
  /// A version is valid minor and major are greater than 0
  ///
  /// **Returns:**
  ///
  /// * True if the version is valid
  /// * False if the version is not valid
  bool get isValid {
    return _encodedVersion != 0;
  }

  @override
  int get hashCode => major.hashCode ^ minor.hashCode;

  @override
  String toString() => '$major.$minor';
}

/// A pair consisting of 2 objects
///
/// {@category Core}
class Pair<T1, T2> {
  /// Constructor for the pair class
  Pair(this.first, this.second);

  /// First element
  final T1 first;

  /// Second element
  final T2 second;

  @override
  bool operator ==(covariant final Pair<T1, T2> other) {
    if (identical(this, other)) {
      return true;
    }
    return first == other.first && second == other.second;
  }

  @override
  int get hashCode => first.hashCode ^ second.hashCode;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'first': first, 'second': second};
  }
}

/// A point in 3d space, consisting of x, y and z coordinates.
///
/// {@category Core}
class Point3d {
  /// The constructor for the point class
  Point3d({this.x = 0.0, this.y = 0.0, this.z = 0.0});

  factory Point3d.fromJson(final Map<String, dynamic> json) {
    return Point3d(x: json['x'], y: json['y'], z: json['z']);
  }

  /// The value on the X axis
  double x;

  /// The value on the Y axis
  double y;

  /// The value on the Z axis
  double z;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['x'] = x;
    json['y'] = y;
    json['z'] = z;
    return json;
  }

  @override
  String toString() {
    return 'Point3d(x: $x, y: $y, z: $z)';
  }

  @override
  bool operator ==(covariant final Point3d other) {
    if (identical(this, other)) {
      return true;
    }

    return other.x == x && other.y == y && other.z == z;
  }

  @override
  int get hashCode {
    return x.hashCode ^ y.hashCode ^ z.hashCode;
  }
}

/// A point in 4d space, consisting of x, y, z and w coordinates.
///
/// {@category Core}
class Point4d {
  /// Constructor for the point class
  Point4d({this.x = 0.0, this.y = 0.0, this.z = 0.0, this.w = 0.0});

  factory Point4d.fromJson(final Map<String, dynamic> json) {
    return Point4d(x: json['x'], y: json['y'], z: json['z'], w: json['w']);
  }

  /// The value on the X axis
  double x;

  /// The value on the Y axis
  double y;

  /// The value on the Z axis
  double z;

  /// The value on the W axis
  double w;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['x'] = x;
    json['y'] = y;
    json['z'] = z;
    json['w'] = w;
    return json;
  }

  @override
  String toString() {
    return 'Point4d(x: $x, y: $y, z: $z, w: $w)';
  }

  @override
  bool operator ==(covariant final Point4d other) {
    if (identical(this, other)) {
      return true;
    }

    return other.x == x && other.y == y && other.z == z && other.w == w;
  }

  @override
  int get hashCode {
    return x.hashCode ^ y.hashCode ^ z.hashCode ^ w.hashCode;
  }
}

/// The position and orientation of an object in 3D space
///
/// {@category Core}
class PositionOrientation {
  /// Constructor for the class
  PositionOrientation({required this.position, required this.orientation});

  factory PositionOrientation.fromJson(final Map<String, dynamic> json) {
    return PositionOrientation(
      position: Point3d.fromJson(json['position']),
      orientation: Point4d.fromJson(json['orientation']),
    );
  }

  /// The object position
  Point3d position;

  /// The object orientation
  Point4d orientation;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['position'] = position.toJson();
    json['orientation'] = orientation.toJson();
    return json;
  }

  @override
  String toString() {
    return 'PositionOrientation(position: $position, orientation: $orientation)';
  }

  @override
  bool operator ==(covariant final PositionOrientation other) {
    if (identical(this, other)) {
      return true;
    }

    return other.position == position && other.orientation == orientation;
  }

  @override
  int get hashCode {
    return position.hashCode ^ orientation.hashCode;
  }
}

/// @nodoc
class NativeObject {
  NativeObject(this.address, this.length);
  dynamic address;
  int length;
}
