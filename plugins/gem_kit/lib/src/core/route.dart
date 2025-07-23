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
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/core/extensions.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/core/route_listener.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/navigation/navigation_instruction.dart';
import 'package:gem_kit/src/routing/routing_preferences.dart';
import 'package:meta/meta.dart';

/// Step unit type
///
/// {@category Routes & Navigation}
enum StepType { distance, time }

/// Status of routing service
///
/// {@category Routes & Navigation}
enum RouteStatus {
  /// Uninitialized
  uninitialized,

  /// Calculating
  calculating,

  /// Waiting for internet connection
  waitingInternetConnection,

  /// Ready
  ready,

  /// Error
  error,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension RouteStatusExtension on RouteStatus {
  int get id {
    switch (this) {
      case RouteStatus.uninitialized:
        return 0;
      case RouteStatus.calculating:
        return 1;
      case RouteStatus.waitingInternetConnection:
        return 2;
      case RouteStatus.ready:
        return 3;
      case RouteStatus.error:
        return 4;
    }
  }

  static RouteStatus fromId(final int id) {
    switch (id) {
      case 0:
        return RouteStatus.uninitialized;
      case 1:
        return RouteStatus.calculating;
      case 2:
        return RouteStatus.waitingInternetConnection;
      case 3:
        return RouteStatus.ready;
      case 4:
        return RouteStatus.error;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Type of transit
///
/// {@category Routes & Navigation}
enum TransitType {
  /// Walk
  walk,

  /// Bus
  bus,

  /// Underground
  underground,

  /// Railway
  railway,

  /// Tram
  tram,

  /// Water transport
  waterTransport,

  /// Other
  other,

  /// Shared bike
  sharedBike,

  /// Shared scooter
  sharedScooter,

  /// Shared car
  sharedCar,

  /// Unknown
  unknown,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension TransitTypeExtension on TransitType {
  int get id {
    switch (this) {
      case TransitType.walk:
        return 0;
      case TransitType.bus:
        return 1;
      case TransitType.underground:
        return 2;
      case TransitType.railway:
        return 3;
      case TransitType.tram:
        return 4;
      case TransitType.waterTransport:
        return 5;
      case TransitType.other:
        return 6;
      case TransitType.sharedBike:
        return 7;
      case TransitType.sharedScooter:
        return 8;
      case TransitType.sharedCar:
        return 9;
      case TransitType.unknown:
        return 10;
    }
  }

  static TransitType fromId(final int id) {
    switch (id) {
      case 0:
        return TransitType.walk;
      case 1:
        return TransitType.bus;
      case 2:
        return TransitType.underground;
      case 3:
        return TransitType.railway;
      case 4:
        return TransitType.tram;
      case 5:
        return TransitType.waterTransport;
      case 6:
        return TransitType.other;
      case 7:
        return TransitType.sharedBike;
      case 8:
        return TransitType.sharedScooter;
      case 9:
        return TransitType.sharedCar;
      case 10:
        return TransitType.unknown;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Status of realtime information
///
/// {@category Routes & Navigation}
enum RealtimeStatus {
  /// Delay
  delay,

  /// On time
  onTime,

  /// Not available
  notAvailable,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension RealtimeStatusExtension on RealtimeStatus {
  int get id {
    switch (this) {
      case RealtimeStatus.delay:
        return 0;
      case RealtimeStatus.onTime:
        return 1;
      case RealtimeStatus.notAvailable:
        return 2;
    }
  }

  static RealtimeStatus fromId(final int id) {
    switch (id) {
      case 0:
        return RealtimeStatus.delay;
      case 1:
        return RealtimeStatus.onTime;
      case 2:
        return RealtimeStatus.notAvailable;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Get route waypoints options
///
/// {@category Routes & Navigation}
enum GetWaypointsOptions {
  /// Initial route calculation waypoints
  initial,

  /// Remaining to travel set from the initial calculation waypoints
  ///
  /// Navigating a route will remove all passed by intermediate waypoints.
  remainingInitial,

  /// Remaining to travel set ( user set + service added set )
  ///
  /// Routing service may add additional waypoints to route result, e.g. for follow track and EV routing
  remaining,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension GetWaypointsOptionsExtension on GetWaypointsOptions {
  int get id {
    switch (this) {
      case GetWaypointsOptions.initial:
        return 0;
      case GetWaypointsOptions.remainingInitial:
        return 1;
      case GetWaypointsOptions.remaining:
        return 2;
    }
  }

  static GetWaypointsOptions fromId(final int id) {
    switch (id) {
      case 0:
        return GetWaypointsOptions.initial;
      case 1:
        return GetWaypointsOptions.remainingInitial;
      case 2:
        return GetWaypointsOptions.remaining;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Road instruction interface
///
/// {@category Routes & Navigation}
class RouteInstructionBase extends GemAutoreleaseObject {
  // ignore: unused_element
  RouteInstructionBase._() : _pointerId = -1;

  @internal
  RouteInstructionBase.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Get coordinates for this route instruction.
  ///
  /// **Returns**
  ///
  /// * Coordinates of the instruction location
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Coordinates get coordinates {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'getCoordinates',
    );

    return Coordinates.fromJson(resultString['result']);
  }

  /// Get ISO 3166-1 alpha-3 country code for the navigation instruction.
  ///
  /// Empty string means no country.
  ///
  /// **Returns**
  ///
  /// *  Country ISO code. See: http://en.wikipedia.org/wiki/ISO_3166-1 for the list of codes.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get countryCodeISO {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'getCountryCodeISO',
    );

    return resultString['result'];
  }

  /// Get the exit route instruction text.
  ///
  /// If the instruction is not an exit, returns empty string.
  ///
  /// **Returns**
  ///
  /// *  String that contains exit route instruction text
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get exitDetails {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'getExitDetails',
    );

    return resultString['result'];
  }

  /// Get textual description for the follow road information.
  ///
  /// **Returns**
  ///
  /// * Follow road instruction
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get followRoadInstruction {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'getFollowRoadInstruction',
    );

    return resultString['result'];
  }

  /// Get image for the realistic turn information.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* Size of the image.
  /// * **IN** *format* Format of the image.
  /// * **IN** *renderSettings* Render settings for the image
  ///
  /// **Returns**
  ///
  /// * The image for the realistic next turn. The API user is responsible to check if the image is valid.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Uint8List? getRealisticNextTurnImage({
    final Size? size,
    final ImageFileFormat? format,
    final AbstractGeometryImageRenderSettings renderSettings =
        const AbstractGeometryImageRenderSettings(),
  }) {
    return GemKitPlatform.instance.callGetImage(
      pointerId,
      'RouteInstructionGetRealisticNextTurnImage',
      size?.width.toInt() ?? -1,
      size?.height.toInt() ?? -1,
      format?.id ?? -1,
      arg: jsonEncode(renderSettings),
    );
  }

  /// Get the image of the realistic next turn image
  ///
  /// **Parameters**
  ///
  /// **Returns**
  ///
  /// * The image for the realistic next turn image. The user is responsible to check if the image is valid.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  AbstractGeometryImg get realisticNextTurnImg {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'getRealisticNextTurnImg',
    );

    return AbstractGeometryImg.init(resultString['result']);
  }

  /// Get remaining travel distance in meters and remaining travel time in seconds.
  ///
  /// **Returns**
  ///
  /// * [TimeDistance] object containing the remaining travel time and distance.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get remainingTravelTimeDistance {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'getRemainingTravelTimeDistance',
    );

    return TimeDistance.fromJson(resultString['result']);
  }

  /// Get remaining travel time in seconds to the next way point and the remaining travel distance in meters to the next way point.
  ///
  /// **Returns**
  ///
  /// * [TimeDistance] object containing the remaining travel time and distance to the next waypoint.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get remainingTravelTimeDistanceToNextWaypoint {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'getRemainingTravelTimeDistanceToNextWaypoint',
    );

    return TimeDistance.fromJson(resultString['result']);
  }

  /// Get road information.
  ///
  /// **Returns**
  ///
  /// *  [List]<[RoadInfo]> containing the road information.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<RoadInfo> get roadInfo {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'getRoadInfo',
    );

    final List<dynamic> listJson = resultString['result'];
    final List<RoadInfo> retList = listJson
        .map((final dynamic categoryJson) => RoadInfo.fromJson(categoryJson))
        .toList();
    return retList;
  }

  /// Get road image.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* the image size
  /// * **IN** *format* the image format
  /// * **IN** *backgroundColor* the image background color.
  /// Might not be visible for images that already have a default background image
  ///
  /// **Returns**
  ///
  /// * RoadInfo Image associated with the road information.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Uint8List? getRoadInfoImage({
    final Size? size,
    final ImageFileFormat? format,
    final Color backgroundColor = Colors.transparent,
  }) {
    final Rgba bkColor = backgroundColor.toRgba();
    return GemKitPlatform.instance.callGetImage(
      pointerId,
      'RouteInstructionGetRoadInfoImage',
      size?.width.toInt() ?? -1,
      size?.height.toInt() ?? -1,
      format?.id ?? -1,
      arg: jsonEncode(bkColor),
    );
  }

  /// Get the image of the road info
  ///
  /// **Parameters**
  ///
  /// **Returns**
  ///
  /// * The image for the road info. The user is responsible to check if the image is valid.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RoadInfoImg get roadInfoImg {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'getRoadInfoImg',
    );

    return RoadInfoImg.init(resultString['result']);
  }

  /// Get extended signpost details.
  ///
  /// **Returns**
  ///
  /// * [SignpostDetails] object containing the signpost details.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  SignpostDetails get signpostDetails {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'getSignpostDetails',
    );

    return SignpostDetails.init(resultString['result']);
  }

  /// Get textual description for the signpost information.
  ///
  /// **Returns**
  ///
  /// * [String] containing the signpost instructions.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get signpostInstruction {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'getSignpostInstruction',
    );

    return resultString['result'];
  }

  /// Get distance to the next turn in meters, time in seconds.
  ///
  /// **Returns**
  ///
  /// * [TimeDistance] object containing the traveled time and distance.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get timeDistanceToNextTurn {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'getTimeDistanceToNextTurn',
    );

    return TimeDistance.fromJson(resultString['result']);
  }

  /// Get the traveled distance in meters and the traveled time in seconds.
  ///
  /// **Returns**
  ///
  /// * [TimeDistance] object containing the traveled time and distance.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get traveledTimeDistance {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'getTraveledTimeDistance',
    );

    return TimeDistance.fromJson(resultString['result']);
  }

  /// Get full details for the turn.
  ///
  /// **Returns**
  ///
  /// * Full details for the turn. This may be used instead of [getTurnImage] in order to customize display in UI.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TurnDetails get turnDetails {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'getTurnDetails',
    );

    return TurnDetails.init(resultString['result']);
  }

  /// Get turn image.
  ///
  /// ** Parameters**
  ///
  /// * **IN** *size* Size of the image.
  /// * **IN** *format* Format of the image
  ///
  /// **Returns**
  ///
  /// * The image for the turn. The API user is responsible to check if the image is valid.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Uint8List? getTurnImage({final Size? size, final ImageFileFormat? format}) {
    return GemKitPlatform.instance.callGetImage(
      pointerId,
      'RouteInstructionGetTurnImage',
      size?.width.toInt() ?? -1,
      size?.height.toInt() ?? -1,
      format?.id ?? -1,
    );
  }

  /// Get the turn image
  ///
  /// **Returns**
  ///
  /// * Turn image. The user is responsible to check if the image is valid
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Img get turnImg {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'getTurnImg',
    );

    return Img.init(resultString['result']);
  }

  /// Get textual description for the turn.
  ///
  /// **Returns**
  ///
  /// * The turn instruction
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get turnInstruction {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'getTurnInstruction',
    );

    return resultString['result'];
  }

  /// Check if follow road information is available.
  ///
  /// **Returns**
  ///
  /// * True if follow road information is available, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasFollowRoadInfo {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'hasFollowRoadInfo',
    );

    return resultString['result'];
  }

  /// Check if signpost information is available.
  ///
  /// **Returns**
  ///
  /// * True if signpost information is available, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasSignpostInfo {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'hasSignpostInfo',
    );

    return resultString['result'];
  }

  /// Check if turn information is available.
  ///
  /// **Returns**
  ///
  /// * True if turn information is available, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasTurnInfo {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'hasTurnInfo',
    );

    return resultString['result'];
  }

  /// Check if road information is available.
  ///
  /// **Returns**
  ///
  /// * True if road information is available, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasRoadInfo {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'hasRoadInfo',
    );

    return resultString['result'];
  }

  /// Check if this instruction is of common type.
  ///
  /// A common type route instruction is part of a common type route segment, see [RouteSegment.isCommon].
  ///
  /// **Returns**
  ///
  /// * True if instruction is common type, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isCommon {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'isCommon',
    );

    return resultString['result'];
  }

  /// Check if the route instruction is a main road exit instruction.
  ///
  /// **Returns**
  ///
  /// *  True if an exit is involved, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isExit {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'isExit',
    );

    return resultString['result'];
  }

  /// Check if the route instruction is a ferry.
  ///
  /// **Returns**
  ///
  /// * True if a ferry is involved, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isFerry {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'isFerry',
    );

    return resultString['result'];
  }

  /// Check if the route instruction is a toll road.
  ///
  /// **Returns**
  ///
  /// * True if a toll road is involved, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isTollRoad {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstructionBase',
      'isTollRoad',
    );

    return resultString['result'];
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, Object>{
          'class': 'RouteInstructionBase',
          'id': _pointerId,
        }),
      );
}

/// Route instruction class
///
/// This class should not be instantiated directly.
///
/// {@category Routes & Navigation}
class RouteInstruction extends RouteInstructionBase {
  @internal
  RouteInstruction.init(super.id) : super.init();

  /// Convert to a [EVRouteInstruction] from this one.
  ///
  /// **Returns**
  ///
  /// * [EVRouteInstruction] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  EVRouteInstruction toEVRouteInstruction() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstruction',
      'toEVRouteInstruction',
    );

    return EVRouteInstruction.init(resultString['result']);
  }

  /// Convert to a PTRouteInstruction from this one.
  ///
  /// **Returns**
  ///
  /// * PTRouteInstruction
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  PTRouteInstruction? toPTRouteInstruction() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteInstruction',
      'toPTRouteInstruction',
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return PTRouteInstruction.init(resultString['result']);
  }
}

/// Route segment class
///
/// This class should not be instantiated directly. Instead, use the [Route.segments] getter to obtain a list of instances.
///
/// {@category Core}
class RouteSegment extends RouteSegmentBase {
  @internal
  RouteSegment.init(super.id) : super.init();

  /// Convert to a [EVRouteSegment] from this one.
  ///
  /// **Returns**
  ///
  /// * [EVRouteSegment] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  EVRouteSegment toEVRouteSegment() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteSegment',
      'toEVRouteSegment',
    );

    return EVRouteSegment.init(resultString['result']);
  }

  /// Convert to a [PTRouteSegment] from this one.
  ///
  /// **Returns**
  ///
  /// * [PTRouteSegment] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  PTRouteSegment? toPTRouteSegment() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteSegment',
      'toPTRouteSegment',
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return PTRouteSegment(resultString['result']);
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, Object>{'class': 'RouteSegment', 'id': _pointerId}),
      );
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
abstract class RouteSegmentBase extends GemAutoreleaseObject {
  // ignore: unused_element
  RouteSegmentBase._() : _pointerId = -1;

  @internal
  RouteSegmentBase.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Get the list containing segment start and end waypoints.
  ///
  /// **Returns**
  ///
  /// * A list of landmarks along the route
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> get waypoints {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteSegmentBase',
      'getWaypoints',
    );

    return LandmarkList.init(resultString['result']).toList();
  }

  /// Get length in meters and estimated travel time in seconds for the route / route segment.
  ///
  /// **Returns**
  ///
  /// * [TimeDistance] object containing the time and distance information for the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get timeDistance {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteSegmentBase',
      'getTimeDistance',
    );

    return TimeDistance.fromJson(resultString['result']);
  }

  /// Get geographic area of the route
  ///
  /// The geographic area is the smallest rectangle that can be drawn around the route.
  ///
  /// **Returns**
  ///
  /// * Geographic area covered by the route, [RectangleGeographicArea] object.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea get geographicArea {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteSegmentBase',
      'getGeographicArea',
    );

    return RectangleGeographicArea.fromJson(resultString['result']);
  }

  /// Method to check if traveling the route or route segment incurs cost to the user.
  ///
  /// **Returns**
  ///
  /// * True if the route incurs costs, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get incursCosts {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteSegmentBase',
      'getIncursCosts',
    );

    return resultString['result'];
  }

  /// Get summary of the route segment.
  ///
  /// **Returns**
  ///
  /// * The summary of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get summary {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteSegmentBase',
      'getSummary',
    );

    return resultString['result'];
  }

  /// Get route instructions list.
  ///
  /// **Returns**
  ///
  /// * A list of route instructions for the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<RouteInstruction> get instructions {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteSegmentBase',
      'getInstructions',
    );

    return RouteInstructionList.init(resultString['result']).toList();
  }

  /// Check if this segment is of common type.
  ///
  /// A common type route segment has the same travel mode as the parent route.
  ///
  /// E.g. a walk segment in a public transport route has isCommon == false.
  ///
  /// **Returns**
  ///
  /// * True if the segment is common type, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isCommon {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteSegmentBase',
      'isCommon',
    );

    return resultString['result'];
  }
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
abstract class RouteBase extends GemAutoreleaseObject {
  // ignore: unused_element
  RouteBase() : _pointerId = -1;

  @internal
  RouteBase.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final dynamic _pointerId;

  dynamic get pointerId => _pointerId;

  /// Export route data in the requested data format.
  ///
  /// **Parameters**
  ///
  /// * **IN** *format* Data format, see [PathFileFormat]
  ///
  /// **Returns**
  ///
  /// * The string with the exported data.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String exportAs(final PathFileFormat format) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'exportAs',
      args: format.index,
    );

    final String encodedResult = resultString['result'];
    final Uint8List resultAsUint8List = base64Decode(encodedResult);
    final String result = utf8.decode(resultAsUint8List);

    return result;
  }

  /// Get index of the closest route segment to the given coordinates.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coord* The geographic coordinates to check against the route segments
  ///
  /// **Returns**
  ///
  /// * [GemError.general].code (-1) on error and the index of the closest route segment to the given coordinates otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int getClosestSegment(final Coordinates coord) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getClosestSegment',
      args: coord,
    );

    return resultString['result'];
  }

  /// Get a coordinate on route at the given distance from the departure / starting point.
  ///
  /// **Parameters**
  ///
  /// * **IN** *distance* The distance from the route start, in meters.
  ///
  /// **Returns**
  ///
  /// * Coordinates at the specified distance along the route.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Coordinates getCoordinateOnRoute(final int distance) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getCoordinateOnRoute',
      args: distance,
    );

    return Coordinates.fromJson(resultString['result']);
  }

  /// Get route distance from departure at the given coordinate.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coord* The geographic coordinates where the distance is to be measured
  /// * **IN** *distance* Boolean indicating whether to consider only the active part of the route (true) or the entire route (false).
  ///
  /// **Returns**
  ///
  /// * Coordinates at the specified distance along the route.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int getDistanceOnRoute(final Coordinates coords, final bool activePart) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getDistanceOnRoute',
      args: <String, Object>{'coords': coords, 'activePart': activePart},
    );

    return resultString['result'];
  }

  /// Get dominant road names
  ///
  /// A road is considered dominant when it covers n% from route total length.
  ///
  /// **Returns**
  ///
  /// * The names list. If a road has multiple names, they will be presented as 'name1 / name2 / ... / namex'
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<String> get dominantRoads {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getDominantRoads',
    );

    return (resultString['result'] as List<dynamic>)
        .map((final dynamic e) => e as String)
        .toList();
  }

  /// Get geographic area of the route. The geographic area is the smallest rectangle that can be drawn around the route.
  ///
  /// **Returns**
  ///
  /// * The names list. If a road has multiple names, they will be presented as 'name1 / name2 / ... / namex'
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea get geographicArea {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getGeographicArea',
    );

    return RectangleGeographicArea.fromJson(resultString['result']);
  }

  /// Method to check if traveling the route or route segment incurs cost to the user.
  ///
  /// **Returns**
  ///
  /// * Boolean indicating whether the route incurs additional costs (e.g., tolls)
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get incursCosts {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getIncursCosts',
    );

    return resultString['result'];
  }

  /// Build path from route start - end segment.
  ///
  /// **Parameters**
  ///
  /// * **IN** *start* Start distance from route start.
  /// * **IN** *end* End distance from route start.
  ///
  /// **Returns**
  ///
  /// * [Path] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Path? getPath(final int start, final int end) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getPath',
      args: <String, int>{'start': start, 'end': end},
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return Path.init(resultString['result']);
  }

  /// Get polygon area of the route.
  ///
  /// **Returns**
  ///
  /// * [PolygonGeographicArea] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  PolygonGeographicArea get polygonGeographicArea {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getPolygonGeographicArea',
    );

    final List<Coordinates> listJson = (resultString['result'] as List<dynamic>)
        .map(
          (final dynamic item) =>
              Coordinates.fromJson(item as Map<String, dynamic>),
        )
        .toList();
    return PolygonGeographicArea(coordinates: listJson);
  }

  /// Get the route preferences.
  ///
  /// **Returns**
  ///
  /// * [RoutePreferences] object managing user preferences for route calculations.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RoutePreferences get preferences {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getPreferences',
    );

    return RoutePreferences.fromJson(resultString['result']);
  }

  /// Get route segments.
  ///
  /// **Returns**
  ///
  /// * Segments of the route, each detailed with specific route information.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<RouteSegment> get segments {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getSegments',
    );

    return RouteSegmentList.init(resultString['result']).toList();
  }

  /// Get route status.
  ///
  /// **Returns**
  ///
  /// * Current status of the route.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RouteStatus get status {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getStatus',
    );

    return RouteStatusExtension.fromId(resultString['result']);
  }

  /// Get the summary of the route.
  ///
  /// **Returns**
  ///
  /// * A summary of the route, including key metrics and descriptions.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get summary {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getSummary',
    );

    return resultString['result'];
  }

  /// Get route terrain profile.
  ///
  /// The [BuildTerrainProfile.enable] parameter must be set to true in the [RoutePreferences.buildTerrainProfile] object passed to [RoutingService.calculateRoute] for this getter to work.
  ///
  /// **Returns**
  ///
  /// * Terrain profile of the route, detailing elevation changes.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RouteTerrainProfile? get terrainProfile {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getTerrainProfile',
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return RouteTerrainProfile.init(resultString['result']);
  }

  /// Get length in meters and estimated travel time in seconds for the route / route segment.
  ///
  /// **Parameters**
  ///
  /// * **IN** *activePart* If true, returns only the active part of the route metrics, if false returns whole route metrics.
  ///
  /// **Returns**
  ///
  /// * [TimeDistance] object containing the time and distance information for the route.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance getTimeDistance({final bool activePart = true}) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getTimeDistance',
      args: activePart,
    );

    return TimeDistance.fromJson(resultString['result']);
  }

  /// Build a list of timestamp coordinates from a route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *start* 	Start distance from route start.
  /// * **IN** *end* 	End distance from route start.
  /// * **IN** *step* The step on which the coordinates are created.
  /// * **IN** *stepType* The step unit type. See [StepType]
  ///
  /// **Returns**
  ///
  /// * The result list of [TimeDistanceCoordinate] objects containing the time and distance information for the route.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<TimeDistanceCoordinate> getTimeDistanceCoordinates({
    required final int start,
    required final int end,
    required final int step,
    required final StepType stepType,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getTimeDistanceCoordinates',
      args: <String, Object>{
        'start': start,
        'end': end,
        'step': step,
        'stepType': stepType == StepType.distance,
      },
    );

    final List<dynamic> timeDistanceJson = resultString['result'];

    return timeDistanceJson
        .map((final dynamic e) => TimeDistanceCoordinate.fromJson(e))
        .toList();
  }

  /// Get a time-distance coordinate on route closest to the given reference coordinate.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coordinates* The reference coordinate.
  ///
  /// **Returns**
  ///
  /// * [TimeDistanceCoordinate] Time-distance coordinate on route closest to the reference coordinate
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TimeDistanceCoordinate getTimeDistanceCoordinateOnRoute(
    final Coordinates coordinates,
  ) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getTimeDistanceCoordinateOnRoute',
      args: coordinates.toJson(),
    );

    final Map<String, dynamic> timeDistanceJson =
        resultString['result'] as Map<String, dynamic>;

    return TimeDistanceCoordinate.fromJson(timeDistanceJson);
  }

  /// Get list of traffic events affecting the route.
  ///
  /// **Returns**
  ///
  /// * List of traffic events affecting the route
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<RouteTrafficEvent> get trafficEvents {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getTrafficEvents',
    );

    return RouteTrafficEventList.init(resultString['result']).toList();
  }

  /// Get list of route waypoints.
  ///
  /// The waypoints are ordered like: departure, first waypoint, ..., destination.
  ///
  /// If the route is target for a navigation, the list will contain the remaining to travel waypoints.
  ///
  /// **Parameters**
  ///
  /// * **IN** *options* Waypoints options
  ///
  /// **Returns**
  ///
  /// * List of [Landmark]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> getWaypoints({
    final GetWaypointsOptions options = GetWaypointsOptions.remainingInitial,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getWaypoints',
      args: options.id,
    );

    return LandmarkList.init(resultString['result']).toList();
  }

  /// Get a new waypoints configuration using the given intermediate via waypoint.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmark* The via waypoint to be inserted in the remaining route waypoints.
  ///
  /// **Returns**
  ///
  /// * A new route waypoints list including the given via placed in a proper position with respect to the existing route waypoints.
  ///
  /// If the route is target for a navigation, the list will contain the remaining to travel waypoints.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> getWaypointsVia(final Landmark landmark) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getWaypointsVia',
      args: <String, dynamic>{'landmark': landmark.pointerId},
    );

    return LandmarkList.init(resultString['result']).toList();
  }

  /// Check if the route contains ferry connections.
  ///
  /// **Returns**
  ///
  /// * Boolean indicating whether the route includes ferry connections.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasFerryConnections {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'hasFerryConnections',
    );

    return resultString['result'];
  }

  /// Check if the route contains toll roads.
  ///
  /// **Returns**
  ///
  /// * Boolean indicating whether the route includes toll roads.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasTollRoads {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'hasTollRoads',
    );

    return resultString['result'];
  }

  /// Get tiles collection area of the route.
  ///
  /// **Returns**
  ///
  /// * Detailed geographic area of the route represented in tiles.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TilesCollectionGeographicArea get tilesGeographicArea {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getTilesGeographicArea',
    );

    return TilesCollectionGeographicArea.init(resultString['result']);
  }

  /// Set listener for events related to the current route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *routeListener* The listener to be set
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  set routeListener(final RouteListener? routeListener) {
    objectMethod(
      _pointerId,
      'RouteBase',
      'setRouteListener',
      args: routeListener == null ? 0 : routeListener.id,
    );

    if (routeListener != null) {
      GemKitPlatform.instance.registerEventHandler(
        routeListener.id,
        routeListener,
      );
    }
  }

  /// Clear the route listener, removing any previously set listener for route-related events.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void clearRouteListener() {
    objectMethod(_pointerId, 'RouteBase', 'clearRouteListener');
  }

  /// Get route related events listener.
  ///
  /// **Returns**
  ///
  /// * The route related events listener
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  RouteListener? get routeListener {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBase',
      'getRouteListener',
    );

    if (resultString['result'] == -1) {
      return null;
    }

    final EventHandler? foundHandler =
        GemKitPlatform.instance.getEventHandler(resultString['result']);
    if (foundHandler == null || foundHandler is! RouteListener) {
      return null;
    }

    return foundHandler;
  }
}

/// Route class
///
/// {@category Routes & Navigation}
class Route extends RouteBase {
  // ignore: unused_element
  Route._();

  @internal
  Route.init(super.id) : super.init();

  /// Comparison operator equal.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The [Route] object to be compared.
  ///
  /// **Returns**
  ///
  /// * True if the two objects are equal, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool equals(final Route route) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Route',
      'equals',
      args: route.pointerId,
    );

    return resultString['result'];
  }

  /// Check if route is an Electric Vehicle Route
  ///
  /// **Returns**
  ///
  /// * True if the route is an EV route, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get isEVRoute {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Route',
      'isEVRoute',
    );

    return resultString['result'];
  }

  /// Check if route is an Over Track Route
  ///
  /// **Returns**
  ///
  /// * True if the route is an OT route, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get isOTRoute {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Route',
      'isOTRoute',
    );

    return resultString['result'];
  }

  /// Check if route is a Public Transport Route
  ///
  /// **Returns**
  ///
  /// * True if the route is a PT route, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get isPTRoute {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Route',
      'isPTRoute',
    );

    return resultString['result'];
  }

  /// Get the route's extra information.
  ///
  /// **Returns**
  ///
  /// * [SearchableParameterList] object containing extra information associated with the route.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  SearchableParameterList get extraInfo {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Route',
      'getExtraInfo',
    );

    return SearchableParameterList.init(resultString['result']);
  }

  /// Set user extra info.
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* A [SearchableParameterList] containing extra information to be associated with the route.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set extraInfo(final SearchableParameterList value) {
    objectMethod(_pointerId, 'Route', 'setExtraInfo', args: value.pointerId);
  }

  /// Convert to a [EVRoute] from this one.
  ///
  /// **Returns**
  ///
  /// * [EVRoute] object if the route is an electric vehicle route, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  EVRoute? toEVRoute() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Route',
      'toEVRoute',
    );

    if (resultString['result'] == -1) {
      return null;
    }
    return EVRoute.init(resultString['result']);
  }

  /// Convert to a [OTRoute] from this one.
  ///
  /// **Returns**
  ///
  /// * [OTRoute] object if the route is an over track route, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  OTRoute? toOTRoute() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Route',
      'toOTRoute',
    );

    if (resultString['result'] == -1) {
      return null;
    }
    return OTRoute.init(resultString['result']);
  }

  /// Convert to a [PTRoute] from this one.
  ///
  /// **Returns**
  ///
  /// * [PTRoute] object if the route is a public transport route, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  PTRoute? toPTRoute() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Route',
      'toPTRoute',
    );

    if (resultString['result'] == -1) {
      return null;
    }
    return PTRoute.init(resultString['result']);
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, dynamic>{'class': 'Route', 'id': _pointerId}),
      );
}

/// Electric vehicle route instruction class
///
/// {@category Routes & Navigation}
class EVRouteInstruction extends RouteInstructionBase {
  @internal
  EVRouteInstruction.init(super.id) : super.init();

  /// Get SoC at the instruction begin.
  ///
  /// **Returns**
  ///
  /// * The SoC percentage at the segment start.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get beginSoC {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'EVRouteInstruction',
      'getBeginSoC',
    );

    return resultString['result'];
  }

  /// Get charge time during instruction begin - end interval.
  ///
  /// **Returns**
  ///
  /// * Charging time in seconds required for this segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get chargingTime {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'EVRouteInstruction',
      'getChargingTime',
    );

    return resultString['result'];
  }

  /// Get SoC at the instruction end.
  ///
  /// **Returns**
  ///
  /// * The SoC percentage at the segment end.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get endSoC {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'EVRouteInstruction',
      'getEndSoC',
    );

    return resultString['result'];
  }

  /// Check if instruction is a stop for battery charge.
  ///
  /// **Returns**
  ///
  /// * True if there is a charging stop in this segment, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isChargeStop {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'EVRouteInstruction',
      'isChargeStop',
    );

    return resultString['result'];
  }
}

/// Electric vehicle route class
///
/// {@category Routes & Navigation}
class EVRoute extends RouteBase {
  // ignore: unused_element
  EVRoute._();

  @internal
  EVRoute.init(super.id) : super.init();

  /// Get departure SoC.
  ///
  /// **Returns**
  ///
  /// * The state of charge at the departure point, as a percentage.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get departureSoC {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'EVRoute',
      'getDepartureSoC',
    );

    return resultString['result'];
  }

  /// Get destination SoC.
  ///
  /// **Returns**
  ///
  /// * The state of charge at the destination point, as a percentage.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get destinationSoC {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'EVRoute',
      'getDestinationSoC',
    );

    return resultString['result'];
  }

  /// Get total charging time in seconds.
  ///
  /// **Returns**
  ///
  /// * Total charging time required for the trip, in seconds.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get totalChargingTime {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'EVRoute',
      'getTotalChargingTime',
    );

    return resultString['result'];
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, dynamic>{'class': 'EVRoute', 'id': _pointerId}),
      );
}

/// Public transport route class
///
/// {@category Routes & Navigation}
class PTRoute extends RouteBase {
  @internal
  PTRoute.init(super.id) : super.init();

  /// Get Fare
  ///
  /// **Returns**
  ///
  /// * Fare of the route.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String? get publicTransportFare {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRoute',
      'getPTFare',
    );

    final dynamic result = resultString['result'];

    return (result == null || result is! String || result.isEmpty)
        ? null
        : result;
  }

  /// Get Frequency
  ///
  /// **Returns**
  ///
  /// * Frequency of the route.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get publicTransportFrequency {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRoute',
      'getPTFrequency',
    );

    return resultString['result'];
  }

  /// Check if the solution meets all the preferences
  ///
  /// **Returns**
  ///
  /// * True if the solution meets all the preferences, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get publicTransportRespectsAllConditions {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRoute',
      'getPTRespectsAllConditions',
    );

    return resultString['result'];
  }

  /// Get number of BuyTicketInformation objects for PT route.
  ///
  /// **Returns**
  ///
  /// * Number of BuyTicketInformation objects.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get countBuyTicketInformation {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRoute',
      'getCountBuyTicketInformation',
    );

    return resultString['result'];
  }

  /// Get buy ticket data obj specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN**	*index*	The index of the buy ticket data object.
  ///
  /// **Returns**
  ///
  /// * Valid [PTBuyTicketInformation] object for corresponding index.
  /// * Empty [PTBuyTicketInformation] object if id index is out of bounds.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  PTBuyTicketInformation? getBuyTicketInformation(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRoute',
      'getBuyTicketInformation',
      args: index,
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return PTBuyTicketInformation(resultString['result']);
  }
}

/// Over track route
///
/// {@category Routes & Navigation}
class OTRoute extends RouteBase {
  @internal
  OTRoute.init(super.id) : super.init();

  /// Get name
  ///
  /// **Returns**
  ///
  /// * Name of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Path? get track {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OTRoute',
      'getTrack',
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return Path.init(resultString['result']);
  }
}

/// Public transport route segment
///
/// {@category Routes & Navigation}
class PTRouteSegment extends RouteSegmentBase {
  PTRouteSegment(super.pointerId) : super.init();

  /// Get name
  ///
  /// **Returns**
  ///
  /// * Name of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getName',
    );

    return resultString['result'];
  }

  /// Get platform code
  ///
  /// **Returns**
  ///
  /// * Platform code of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get platformCode {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getPlatformCode',
    );

    return resultString['result'];
  }

  /// Get arrival time
  ///
  /// **Returns**
  ///
  /// * Arrival time of the route segment if available, null otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DateTime? get arrivalTime {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getArrivalTime',
    );

    final int val = resultString['result'];
    if (val < -8640000000000000 || val > 8640000000000000) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(val, isUtc: true);
  }

  /// Get departure time
  ///
  /// **Returns**
  ///
  /// * Departure time of the route segment if available, null otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DateTime? get departureTime {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getDepartureTime',
    );

    final int val = resultString['result'];
    if (val < -8640000000000000 || val > 8640000000000000) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(val, isUtc: true);
  }

  /// Get wheelchair support
  ///
  /// **Returns**
  ///
  /// * True if the route segment has wheelchair support, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasWheelchairSupport {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getHasWheelchairSupport',
    );

    return resultString['result'];
  }

  /// Get short name.
  ///
  /// **Returns**
  ///
  /// * Short name of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get shortName {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getShortName',
    );

    return resultString['result'];
  }

  /// Get route URL
  ///
  /// **Returns**
  ///
  /// * Route URL of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get routeUrl {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getRouteUrl',
    );

    return resultString['result'];
  }

  /// Get agency name
  ///
  /// **Returns**
  ///
  /// * Agency name of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get agencyName {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getAgencyName',
    );

    return resultString['result'];
  }

  /// Get agency phone
  ///
  /// **Returns**
  ///
  /// * Agency phone of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get agencyPhone {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getAgencyPhone',
    );

    return resultString['result'];
  }

  /// Get agency URL
  ///
  /// **Returns**
  ///
  /// * Agency URL of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get agencyUrl {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getAgencyUrl',
    );

    return resultString['result'];
  }

  /// Get agency fare URL
  ///
  /// **Returns**
  ///
  /// * Agency fare URL of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get agencyFareUrl {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getAgencyFareUrl',
    );

    return resultString['result'];
  }

  /// Get line from
  ///
  /// **Returns**
  ///
  /// * Line from of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get lineFrom {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getLineFrom',
    );

    return resultString['result'];
  }

  /// Get line towards
  ///
  /// **Returns**
  ///
  /// * Line towards of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get lineTowards {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getLineTowards',
    );

    return resultString['result'];
  }

  /// Get arrival delay in seconds
  ///
  /// **Returns**
  ///
  /// * Arrival delay in seconds of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get arrivalDelayInSeconds {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getArrivalDelayInSeconds',
    );

    return resultString['result'];
  }

  /// Get departure delay in seconds
  ///
  /// **Returns**
  ///
  /// * Departure delay in seconds of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get departureDelayInSeconds {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getDepartureDelayInSeconds',
    );

    return resultString['result'];
  }

  /// Get if the route segment has bicycle support
  ///
  /// **Returns**
  ///
  /// * True if the route segment has bicycle support, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasBicycleSupport {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getHasBicycleSupport',
    );

    return resultString['result'];
  }

  /// Get if the route segment requires to stay on same transit
  ///
  /// **Returns**
  ///
  /// * True if the route segment requires to stay on same transit, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get stayOnSameTransit {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getStayOnSameTransit',
    );

    return resultString['result'];
  }

  /// Get transit type of the route segment
  ///
  /// **Returns**
  ///
  /// * Transit type of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TransitType get transitType {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getTransitType',
    );

    return TransitTypeExtension.fromId(resultString['result']);
  }

  /// Get real time status of the route segment
  ///
  /// **Returns**
  ///
  /// * Real time status of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RealtimeStatus get realtimeStatus {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getRealtimeStatus',
    );

    return RealtimeStatusExtension.fromId(resultString['result']);
  }

  /// Get line block ID of the route segment
  ///
  /// **Returns**
  ///
  /// * Line block ID of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get lineBlockID {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getLineBlockID',
    );

    return resultString['result'];
  }

  /// Get line color of the route segment
  ///
  /// **Returns**
  ///
  /// * Line color of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Color get lineColor {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getLineColor',
    );

    return ColorExtension.fromJson(resultString['result']);
  }

  /// Get line text color of the route segment
  ///
  /// **Returns**
  ///
  /// * Line text color of the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Color get lineTextColor {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getLineTextColor',
    );

    return ColorExtension.fromJson(resultString['result']);
  }

  /// Get count of alerts in the route segment
  ///
  /// **Returns**
  ///
  /// * Count of alerts in the route segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get countAlerts {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getCountAlerts',
    );

    return resultString['result'];
  }

  /// Get alert by index
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Index of the alert
  ///
  /// **Returns**
  ///
  /// * [PTAlert] object.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  PTAlert? getAlert(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'getAlert',
      args: <String, int>{'index': index},
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return PTAlert(resultString['result']);
  }

  /// Is significant route segment
  ///
  /// **Returns**
  ///
  /// * True if the route segment is significant, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isSignificant {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'isSignificant',
    );

    return resultString['result'];
  }

  /// Is station walk route segment
  ///
  /// **Returns**
  ///
  /// * True if the route segment is station walk, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isStationWalk {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteSegment',
      'isStationWalk',
    );

    return resultString['result'];
  }
}

/// Electric vehicle segment class
///
/// {@category Routes & Navigation}
class EVRouteSegment extends RouteSegmentBase {
  @internal
  EVRouteSegment.init(super.id) : super.init();

  /// Get SoC at route segment begin.
  ///
  /// **Returns**
  ///
  /// * The SoC percentage at the segment start.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get beginSoC {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'EVRouteSegment',
      'getBeginSoC',
    );

    return resultString['result'];
  }

  /// Get SoC at route segment end.
  ///
  /// **Returns**
  ///
  /// * The SoC percentage at the segment end.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get endSoC {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'EVRouteSegment',
      'getEndSoC',
    );

    return resultString['result'];
  }

  /// Get charge time during segment begin - end interval.
  ///
  /// **Returns**
  ///
  /// * Charging time in seconds required for this segment.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get chargingTime {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'EVRouteSegment',
      'getChargingTime',
    );

    return resultString['result'];
  }

  /// Check if segment ends with a charge stop instruction.
  ///
  /// **Returns**
  ///
  /// * True if there is a charging stop in this segment, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasChargeStop {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'EVRouteSegment',
      'hasChargeStop',
    );

    return resultString['result'];
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(
            <String, Object>{'class': 'EVRouteSegment', 'id': _pointerId}),
      );
}

/// Public transport buy ticket information class.
///
/// {@category Routes & Navigation}
class PTBuyTicketInformation extends GemAutoreleaseObject {
  PTBuyTicketInformation(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(id);
  }
  final int _pointerId;
  int get pointerId => _pointerId;

  /// Get buy ticket URL
  ///
  /// **Returns**
  ///
  /// * Buy ticket URL
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get buyTicketURL {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTBuyTicketInformation',
      'getBuyTicketURL',
    );

    return resultString['result'];
  }

  /// Get indexes of the affected solution parts
  ///
  /// **Returns**
  ///
  /// * Indexes list of the affected solution parts
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<int> get solutionPartIndexes {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTBuyTicketInformation',
      'getSolutionPartIndexes',
    );

    return List<int>.from(resultString['result']);
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, Object>{
          'class': 'PTBuyTicketInformation',
          'id': _pointerId,
        }),
      );
}

/// Public transport route instruction class.
///
/// {@category Routes & Navigation}
class PTRouteInstruction extends RouteInstructionBase {
  PTRouteInstruction.init(super.id) : super.init();

  /// Get public transit route instruction name
  ///
  /// **Returns**
  ///
  /// * Instruction name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteInstruction',
      'getName',
    );

    return resultString['result'];
  }

  /// Get platform code
  ///
  /// **Returns**
  ///
  /// * Platform code
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get platformCode {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteInstruction',
      'getPlatformCode',
    );

    return resultString['result'];
  }

  /// Get public transit route instruction arrival time
  ///
  /// **Returns**
  ///
  /// * Arrival time if available, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DateTime? get arrivalTime {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteInstruction',
      'getArrivalTime',
    );

    final int val = resultString['result'];
    if (val < -8640000000000000 || val > 8640000000000000) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(val, isUtc: true);
  }

  /// Get public transit route instruction departure time
  ///
  /// **Returns**
  ///
  /// * Departure time if available, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DateTime? get departureTime {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteInstruction',
      'getDepartureTime',
    );

    final int val = resultString['result'];
    if (val < -8640000000000000 || val > 8640000000000000) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(val, isUtc: true);
  }

  /// Get if public transit route instruction has wheelchair support
  ///
  /// **Returns**
  ///
  /// * True if has wheelchair support, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasWheelchairSupport {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTRouteInstruction',
      'getHasWheelchairSupport',
    );

    return resultString['result'];
  }
}

/// Public transport alert class
///
/// {@category Routes & Navigation}
class PTAlert {
  PTAlert(this._pointerId);
  final int _pointerId;

  /// Get number of url translations in this alert.
  ///
  /// **Returns**
  ///
  /// * Number of url translations.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get countUrlTranslations {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTAlert',
      'getCountUrlTranslations',
    );

    return resultString['result'];
  }

  /// Get number of header text translations in this alert.
  ///
  /// **Returns**
  ///
  /// * Number of header text translations.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get countHeaderTextTranslations {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTAlert',
      'getCountHeaderTextTranslations',
    );

    return resultString['result'];
  }

  /// Get number of description text translations in this alert.
  ///
  /// **Returns**
  ///
  /// * Number of description text translations.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get countDescriptionTextTranslations {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTAlert',
      'getCountDescriptionTextTranslations',
    );

    return resultString['result'];
  }

  /// Get url translation specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Index of the url translation
  ///
  /// **Returns**
  ///
  /// * Valid [PTTranslation] object for corresponding index
  /// * Empty [PTTranslation] if index is out of bounds.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  PTTranslation? getUrlTranslation(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTAlert',
      'getUrlTranslation',
      args: index,
    );

    if (resultString['result']['isValid'] == false) {
      return null;
    }

    return PTTranslation.fromJson(resultString['result']);
  }

  /// Get header text translation specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Index of the header text translation
  ///
  /// **Returns**
  ///
  /// * Valid [PTTranslation] object for corresponding index
  /// * Empty [PTTranslation] if index is out of bounds.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  PTTranslation? getHeaderTextTranslation(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTAlert',
      'getHeaderTextTranslation',
      args: index,
    );

    if (resultString['result']['isValid'] == false) {
      return null;
    }

    return PTTranslation.fromJson(resultString['result']);
  }

  /// Get description text translation specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Index of the description text translation
  ///
  /// **Returns**
  ///
  /// * Valid [PTTranslation] object for corresponding index
  /// * Empty [PTTranslation] if index is out of bounds.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  PTTranslation? getDescriptionTextTranslation(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PTAlert',
      'getDescriptionTextTranslation',
      args: index,
    );

    if (resultString['result']['isValid'] == false) {
      return null;
    }

    return PTTranslation.fromJson(resultString['result']);
  }
}

/// Public transport translation class
///
/// {@category Routes & Navigation}
class PTTranslation {
  PTTranslation(this.text, this.language);

  factory PTTranslation.fromJson(final Map<String, dynamic> json) {
    return PTTranslation(json['text'], json['language']);
  }

  /// The text message.
  final String text;

  /// The language code of the text message, in BCP-47 format.
  final String language;
}

/// Road Info object
///
/// {@category Routes & Navigation}
class RoadInfo {
  RoadInfo({required this.roadname, required this.shieldtype});

  factory RoadInfo.fromJson(final Map<String, dynamic> json) {
    return RoadInfo(
      roadname: json['roadname'] ?? '',
      shieldtype: RoadShieldTypeExtension.fromId(
        json['shieldtype'] ?? RoadShieldType.invalid.id,
      ),
    );
  }

  /// The road name
  String roadname;

  /// The road shield type
  RoadShieldType shieldtype;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['roadname'] = roadname;
    json['shieldtype'] = shieldtype.id;
    return json;
  }

  @override
  bool operator ==(covariant final RoadInfo other) {
    return roadname == other.roadname && shieldtype == other.shieldtype;
  }

  @override
  int get hashCode => roadname.hashCode ^ shieldtype.hashCode;
}
