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

/// Route terrain profile
///
/// This class should not be instantiated directly. Instead, use the [RouteBase.terrainProfile] getter to obtain an instance.
/// Note that the [RoutePreferences.buildTerrainProfile] setting should be configured correctly when calling the [RoutingService.calculateRoute] method for the [RouteBase.terrainProfile] getter to return a valid object.
///
/// {@category Routes & Navigation}
class RouteTerrainProfile extends GemAutoreleaseObject {
  // ignore: unused_element
  RouteTerrainProfile._() : _pointerId = -1;

  @internal
  RouteTerrainProfile.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Get list of route climb sections.
  ///
  /// Climb sections are the difficult climbing parts of a route. The climb categories are defined in [Grade].
  ///
  /// If none of the climbing parts of a route are at least [Grade.grade4], the list will be empty.
  ///
  /// **Returns**
  ///
  /// * The climb sections list
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<ClimbSection> get climbSections {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTerrainProfile',
      'getClimbSections',
    );

    final List<dynamic> listJson = resultString['result'];
    final List<ClimbSection> retList = listJson
        .map(
          (final dynamic categoryJson) => ClimbSection.fromJson(categoryJson),
        )
        .toList();
    return retList;
  }

  /// Get elevation at the given distance in meters from departure point/start of route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *distance* Distance in meters from start of route
  ///
  /// **Returns**
  ///
  /// * The elevation in meters
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double getElevation(final int distance) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTerrainProfile',
      'getElevation',
      args: distance,
    );

    return resultString['result'];
  }

  /// Get elevation samples list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *countSamples* Number of samples.
  /// * **IN** *distBegin* Begin distance on route for sample interval.
  /// * **IN** *distEnd* End distance on route for sample interval.
  ///
  /// **Returns**
  ///
  /// * Record of (samples, resolution)
  ///
  /// Returns a record of empty list and 0.0 for invalid parameters.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  (List<double>, double) getElevationSamples(
    final int countSamples,
    final int distBegin,
    final int distEnd,
  ) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTerrainProfile',
      'getElevationSamplesBE',
      args: <String, int>{
        'countSamples': countSamples,
        'distBegin': distBegin,
        'distEnd': distEnd,
      },
    );

    final List<dynamic> listDynamic = resultString['result']['floatlist'];
    final List<double> listFloat = listDynamic.cast<double>();
    final double sample = resultString['result']['sample'];

    return (listFloat, sample);
  }

  /// Get elevation samples list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *countSamples* Number of samples.
  ///
  /// **Returns**
  ///
  /// * Record of (samples, resolution)
  ///
  /// Returns a record of empty list and 0.0 for invalid parameters.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  (List<double>, double) getElevationSamplesByCount(
    final int countSamples,
  ) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTerrainProfile',
      'getElevationSamples',
      args: countSamples,
    );

    final List<dynamic> listDynamic = resultString['result']['floatlist'];
    final List<double> listFloat = listDynamic.cast<double>();
    final double sample = resultString['result']['sample'];

    return (listFloat, sample);
  }

  /// Get terrain maximum elevation.
  ///
  /// **Returns**
  ///
  /// * Terrain maximum elevation
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get maxElevation {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTerrainProfile',
      'getMaxElevation',
    );

    return resultString['result'];
  }

  /// Get the distance (from route start) where the elevation is maximum.
  ///
  /// **Returns**
  ///
  /// * Terrain maximum elevation distance in meters
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get maxElevationDistance {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTerrainProfile',
      'getMaxElevationDistance',
    );

    return resultString['result'];
  }

  /// Get terrain minimum elevation.
  ///
  /// **Returns**
  ///
  /// * Terrain minimum elevation
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get minElevation {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTerrainProfile',
      'getMinElevation',
    );

    return resultString['result'];
  }

  /// Get the distance (from route start) where the elevation is minimum.
  ///
  /// **Returns**
  ///
  /// * Terrain minimum elevation distance
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get minElevationDistance {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTerrainProfile',
      'getMinElevationDistance',
    );

    return resultString['result'];
  }

  /// Get list of route type sections.
  ///
  /// Each section has the start distance from route start and the road type (see [RoadType]).
  ///
  /// The end of the section is the distance from start of the next section or route total length (for the last section)
  ///
  /// **Returns**
  ///
  /// * The road type sections list
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<RoadTypeSection> get roadTypeSections {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTerrainProfile',
      'getRoadTypeSections',
    );

    final List<dynamic> listJson = resultString['result'];
    final List<RoadTypeSection> retList = listJson
        .map(
          (final dynamic categoryJson) =>
              RoadTypeSection.fromJson(categoryJson),
        )
        .toList();
    return retList;
  }

  /// Get list of route sections which are abrupt, that is, they have a significant elevation change.
  ///
  /// **Parameters**
  ///
  /// * **IN** *categs* The user list of steep categories. Each entry contains the max slope for the steep category as diffX / diffY.
  ///
  /// A common steep categories list is `{-16.f, -10.f, -7.f, -4.f, -1.f, 1.f, 4.f, 7.f, 10.f, 16.f}`
  ///
  /// A positive value is for an ascension category, a negative value if a descent category.
  ///
  /// Each section has the start distance from route start and the category (index in user defined steep categories).
  ///
  /// The end of the section is the distance from start of the next section or route total length (for the last section)
  ///
  /// **Returns**
  ///
  /// * The steep sections list
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<SteepSection> getSteepSections(final List<double> categs) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTerrainProfile',
      'getSteepSections',
      args: categs,
    );

    final List<dynamic> listJson = resultString['result'];
    final List<SteepSection> retList = listJson
        .map(
          (final dynamic categoryJson) => SteepSection.fromJson(categoryJson),
        )
        .toList();
    return retList;
  }

  /// Get list of route surface sections.
  ///
  /// Each section has the start distance from route start and the surface type (see [SurfaceType]).
  ///
  /// The end of the section is the distance from start of the next section or route total length (for the last section)
  ///
  /// **Returns**
  ///
  /// * The surface sections list
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<SurfaceSection> get surfaceSections {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTerrainProfile',
      'getSurfaceSections',
    );

    final List<dynamic> listJson = resultString['result'];
    final List<SurfaceSection> retList = listJson
        .map(
          (final dynamic categoryJson) => SurfaceSection.fromJson(categoryJson),
        )
        .toList();
    return retList;
  }

  /// Get total terrain elevation down.
  ///
  /// **Returns**
  ///
  /// * Total terrain elevation down
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  double get totalDown {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTerrainProfile',
      'getTotalDown',
    );

    return resultString['result'];
  }

  /// Get total terrain elevation up.
  ///
  /// **Returns**
  ///
  /// * Total terrain elevation up
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  double get totalUp {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTerrainProfile',
      'getTotalUp',
    );

    return resultString['result'];
  }

  /// Get total terrain elevation down.
  ///
  /// **Parameters**
  ///
  /// * **IN** *start* Begin distance on route for sample interval.
  /// * **IN** *end* End distance on route for sample interval.
  ///
  /// **Returns**
  ///
  /// * Total terrain elevation down
  ///
  /// If start or end are invalid, the result will be 0.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  double getTotalDown(int start, int end) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTerrainProfile',
      'getTotalDownBE',
      args: <String, int>{'first': start, 'second': end},
    );

    double result = resultString['result'];

    if (result.abs() < 0.0001) {
      result = 0;
    }

    return result;
  }

  /// Get total terrain elevation down.
  ///
  /// **Parameters**
  ///
  /// * **IN** *start* Begin distance on route for sample interval.
  /// * **IN** *end* End distance on route for sample interval.
  ///
  /// **Returns**
  ///
  /// * Total terrain elevation down
  ///
  /// If start or end are invalid, the result will be 0.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  double getTotalUp(int start, int end) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTerrainProfile',
      'getTotalUpBE',
      args: <String, int>{'first': start, 'second': end},
    );

    double result = resultString['result'];

    if (result.abs() < 0.0001) {
      result = 0;
    }

    return result;
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, Object>{
          'class': 'RouteTerrainProfile',
          'id': _pointerId,
        }),
      );
}

/// Climb grade - UCI based, see https://bicycles.stackexchange.com/questions/1210/how-are-the-categories-for-climbs-decided
///
/// Categories are sorted in descending order by difficulty ( EGradeHC - most difficult, EGrade4 - less difficult )
/// {@category Routes & Navigation}
enum Grade { gradeHC, grade1, grade2, grade3, grade4 }

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension GradeExtension on Grade {
  int get id {
    switch (this) {
      case Grade.gradeHC:
        return 0;
      case Grade.grade1:
        return 1;
      case Grade.grade2:
        return 2;
      case Grade.grade3:
        return 3;
      case Grade.grade4:
        return 4;
    }
  }

  static Grade fromId(final int id) {
    switch (id) {
      case 0:
        return Grade.gradeHC;
      case 1:
        return Grade.grade1;
      case 2:
        return Grade.grade2;
      case 3:
        return Grade.grade3;
      case 4:
        return Grade.grade4;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Get surface type
///
/// {@category Routes & Navigation}
enum SurfaceType {
  /// Asphalt
  asphalt,

  /// Paved
  paved,

  /// Unpaved
  unpaved,

  /// Unknown
  unknown,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension SurfaceTypeExtension on SurfaceType {
  int get id {
    switch (this) {
      case SurfaceType.asphalt:
        return 0;
      case SurfaceType.paved:
        return 1;
      case SurfaceType.unpaved:
        return 2;
      case SurfaceType.unknown:
        return 3;
    }
  }

  static SurfaceType fromId(final int id) {
    switch (id) {
      case 0:
        return SurfaceType.asphalt;
      case 1:
        return SurfaceType.paved;
      case 2:
        return SurfaceType.unpaved;
      case 3:
        return SurfaceType.unknown;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Get road type
///
/// {@category Routes & Navigation}
enum RoadType {
  /// Motorways
  motorways,

  /// State road
  stateRoad,

  /// Road
  road,

  /// Street
  street,

  /// Cycleway
  cycleway,

  /// Path
  path,

  /// Single track
  singleTrack,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension RoadTypeExtension on RoadType {
  int get id {
    switch (this) {
      case RoadType.motorways:
        return 0;
      case RoadType.stateRoad:
        return 1;
      case RoadType.road:
        return 2;
      case RoadType.street:
        return 3;
      case RoadType.cycleway:
        return 4;
      case RoadType.path:
        return 5;
      case RoadType.singleTrack:
        return 6;
    }
  }

  static RoadType fromId(final int id) {
    switch (id) {
      case 0:
        return RoadType.motorways;
      case 1:
        return RoadType.stateRoad;
      case 2:
        return RoadType.road;
      case 3:
        return RoadType.street;
      case 4:
        return RoadType.cycleway;
      case 5:
        return RoadType.path;
      case 6:
        return RoadType.singleTrack;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Climb section
///
/// {@category Routes & Navigation}
class ClimbSection {
  ClimbSection({
    required this.startDistanceM,
    required this.endDistanceM,
    required this.slope,
    required this.grade,
  });

  factory ClimbSection.fromJson(final Map<String, dynamic> json) {
    return ClimbSection(
      startDistanceM: json['startDistanceM'],
      endDistanceM: json['endDistanceM'],
      slope: json['slope'],
      grade: GradeExtension.fromId(json['grade']),
    );
  }

  /// Distance in meters where this section starts.
  int startDistanceM;

  /// Distance in meters where this section ends.
  int endDistanceM;

  /// Slope value.
  double slope;

  /// The grade value of this section.
  Grade grade;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['startDistanceM'] = startDistanceM;
    json['endDistanceM'] = endDistanceM;
    json['slope'] = slope;
    json['grade'] = grade.id;
    return json;
  }

  @override
  bool operator ==(covariant final ClimbSection other) {
    if (identical(this, other)) {
      return true;
    }

    return other.startDistanceM == startDistanceM &&
        other.endDistanceM == endDistanceM &&
        other.slope == slope &&
        other.grade == grade;
  }

  @override
  int get hashCode {
    return startDistanceM.hashCode ^
        endDistanceM.hashCode ^
        slope.hashCode ^
        grade.hashCode;
  }
}

/// Surface sections
///
/// Sections list is in route begin -> end walk order.
///
/// {@category Routes & Navigation}
class SurfaceSection {
  SurfaceSection({required this.startDistanceM, required this.type});

  factory SurfaceSection.fromJson(final Map<String, dynamic> json) {
    return SurfaceSection(
      startDistanceM: json['startDistanceM'],
      type: SurfaceTypeExtension.fromId(json['type']),
    );
  }

  /// Distance in meters where the section starts.
  int startDistanceM;

  /// The type of surface.
  SurfaceType type;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['startDistanceM'] = startDistanceM;
    json['type'] = type.id;
    return json;
  }

  @override
  bool operator ==(covariant final SurfaceSection other) {
    if (identical(this, other)) {
      return true;
    }

    return other.startDistanceM == startDistanceM && other.type == type;
  }

  @override
  int get hashCode {
    return startDistanceM.hashCode ^ type.hashCode;
  }
}

/// Road type sections
///
/// Sections list is in route begin -> end walk orders
///
/// {@category Routes & Navigation}
class RoadTypeSection {
  RoadTypeSection({required this.startDistanceM, required this.type});

  factory RoadTypeSection.fromJson(final Map<String, dynamic> json) {
    return RoadTypeSection(
      startDistanceM: json['startDistanceM'],
      type: RoadTypeExtension.fromId(json['type']),
    );
  }

  /// Distance in meters where the section starts
  int startDistanceM;

  /// The road type
  RoadType type;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['startDistanceM'] = startDistanceM;
    json['type'] = type.id;
    return json;
  }

  @override
  bool operator ==(covariant final RoadTypeSection other) {
    if (identical(this, other)) {
      return true;
    }

    return other.startDistanceM == startDistanceM && other.type == type;
  }

  @override
  int get hashCode {
    return startDistanceM.hashCode ^ type.hashCode;
  }
}

/// Steep sections
///
/// Sections list is in route begin -> end walk order.
///
/// {@category Routes & Navigation}
class SteepSection {
  SteepSection({required this.startDistanceM, required this.categ});

  factory SteepSection.fromJson(final Map<String, dynamic> json) {
    return SteepSection(
      startDistanceM: json['startDistanceM'],
      categ: json['categ'],
    );
  }

  /// Distance in meters where the section starts.
  int startDistanceM;

  /// The category of steep ( index in user steep categories list provided to the [RouteTerrainProfile.getSteepSections] method)
  int categ;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['startDistanceM'] = startDistanceM;
    json['categ'] = categ;
    return json;
  }

  @override
  bool operator ==(covariant final SteepSection other) {
    if (identical(this, other)) {
      return true;
    }

    return other.startDistanceM == startDistanceM && other.categ == categ;
  }

  @override
  int get hashCode {
    return startDistanceM.hashCode ^ categ.hashCode;
  }
}
