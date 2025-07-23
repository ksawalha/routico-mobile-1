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
import 'dart:ui';

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Road shield type
///
/// {@category Routes & Navigation}
enum RoadShieldType {
  /// Invalid
  invalid,

  /// County
  county,

  /// State
  state,

  /// Federal
  federal,

  /// Interstate
  interstate,

  /// Four
  four,

  /// Five
  five,

  /// Six
  six,

  /// Seven
  seven,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension RoadShieldTypeExtension on RoadShieldType {
  int get id {
    switch (this) {
      case RoadShieldType.invalid:
        return 0;
      case RoadShieldType.county:
        return 1;
      case RoadShieldType.state:
        return 2;
      case RoadShieldType.federal:
        return 3;
      case RoadShieldType.interstate:
        return 4;
      case RoadShieldType.four:
        return 5;
      case RoadShieldType.five:
        return 6;
      case RoadShieldType.six:
        return 7;
      case RoadShieldType.seven:
        return 8;
    }
  }

  static RoadShieldType fromId(final int id) {
    switch (id) {
      case 0:
        return RoadShieldType.invalid;
      case 1:
        return RoadShieldType.county;
      case 2:
        return RoadShieldType.state;
      case 3:
        return RoadShieldType.federal;
      case 4:
        return RoadShieldType.interstate;
      case 5:
        return RoadShieldType.four;
      case 6:
        return RoadShieldType.five;
      case 7:
        return RoadShieldType.six;
      case 8:
        return RoadShieldType.seven;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Signpost item type
///
/// {@category Routes & Navigation}
enum SignpostItemType {
  /// Invalid
  invalid,

  /// Place name
  placeName,

  /// Route number
  routeNumber,

  /// Route name
  routeName,

  /// Exit number
  exitNumber,

  /// Exit name
  exitName,

  /// Pictogram
  pictogram,

  /// Other
  otherDestination,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension SignpostItemTypeExtension on SignpostItemType {
  int get id {
    switch (this) {
      case SignpostItemType.invalid:
        return 0;
      case SignpostItemType.placeName:
        return 1;
      case SignpostItemType.routeNumber:
        return 2;
      case SignpostItemType.routeName:
        return 3;
      case SignpostItemType.exitNumber:
        return 4;
      case SignpostItemType.exitName:
        return 5;
      case SignpostItemType.pictogram:
        return 6;
      case SignpostItemType.otherDestination:
        return 7;
    }
  }

  static SignpostItemType fromId(final int id) {
    switch (id) {
      case 0:
        return SignpostItemType.invalid;
      case 1:
        return SignpostItemType.placeName;
      case 2:
        return SignpostItemType.routeNumber;
      case 3:
        return SignpostItemType.routeName;
      case 4:
        return SignpostItemType.exitNumber;
      case 5:
        return SignpostItemType.exitName;
      case 6:
        return SignpostItemType.pictogram;
      case 7:
        return SignpostItemType.otherDestination;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Signpost pictogram type.
///
/// {@category Routes & Navigation}
enum SignpostPictogramType {
  /// Invalid
  invalid,

  /// Airport
  airport,

  /// Bus station
  busStation,

  /// Fair ground
  fairGround,

  /// Ferry
  ferry,

  /// First aid post
  firstAidPost,

  /// Harbour
  harbour,

  /// Hospital
  hospital,

  /// Hotel/motel
  hotelMotel,

  /// Industrial area
  industrialArea,

  /// Information centre
  informationCentre,

  /// Parking facility
  parkingFacility,

  /// Petrol station
  petrolStation,

  /// Railway station
  railwayStation,

  /// Rest area
  restArea,

  /// Restaurant
  restaurant,

  /// Toilet
  toilet,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension SignpostPictogramTypeExtension on SignpostPictogramType {
  int get id {
    switch (this) {
      case SignpostPictogramType.invalid:
        return 0;
      case SignpostPictogramType.airport:
        return 1;
      case SignpostPictogramType.busStation:
        return 2;
      case SignpostPictogramType.fairGround:
        return 3;
      case SignpostPictogramType.ferry:
        return 4;
      case SignpostPictogramType.firstAidPost:
        return 5;
      case SignpostPictogramType.harbour:
        return 6;
      case SignpostPictogramType.hospital:
        return 7;
      case SignpostPictogramType.hotelMotel:
        return 8;
      case SignpostPictogramType.industrialArea:
        return 9;
      case SignpostPictogramType.informationCentre:
        return 10;
      case SignpostPictogramType.parkingFacility:
        return 11;
      case SignpostPictogramType.petrolStation:
        return 12;
      case SignpostPictogramType.railwayStation:
        return 13;
      case SignpostPictogramType.restArea:
        return 14;
      case SignpostPictogramType.restaurant:
        return 15;
      case SignpostPictogramType.toilet:
        return 16;
    }
  }

  static SignpostPictogramType fromId(final int id) {
    switch (id) {
      case 0:
        return SignpostPictogramType.invalid;
      case 1:
        return SignpostPictogramType.airport;
      case 2:
        return SignpostPictogramType.busStation;
      case 3:
        return SignpostPictogramType.fairGround;
      case 4:
        return SignpostPictogramType.ferry;
      case 5:
        return SignpostPictogramType.firstAidPost;
      case 6:
        return SignpostPictogramType.harbour;
      case 7:
        return SignpostPictogramType.hospital;
      case 8:
        return SignpostPictogramType.hotelMotel;
      case 9:
        return SignpostPictogramType.industrialArea;
      case 10:
        return SignpostPictogramType.informationCentre;
      case 11:
        return SignpostPictogramType.parkingFacility;
      case 12:
        return SignpostPictogramType.petrolStation;
      case 13:
        return SignpostPictogramType.railwayStation;
      case 14:
        return SignpostPictogramType.restArea;
      case 15:
        return SignpostPictogramType.restaurant;
      case 16:
        return SignpostPictogramType.toilet;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Signpost connection info.
///
/// {@category Routes & Navigation}
enum SignpostConnectionInfo {
  /// Invalid
  invalid,

  /// Branch
  branch,

  /// Towards
  towards,

  /// Exit
  exit,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension SignpostConnectionInfoExtension on SignpostConnectionInfo {
  int get id {
    switch (this) {
      case SignpostConnectionInfo.invalid:
        return 0;
      case SignpostConnectionInfo.branch:
        return 1;
      case SignpostConnectionInfo.towards:
        return 2;
      case SignpostConnectionInfo.exit:
        return 3;
    }
  }

  static SignpostConnectionInfo fromId(final int id) {
    switch (id) {
      case 0:
        return SignpostConnectionInfo.invalid;
      case 1:
        return SignpostConnectionInfo.branch;
      case 2:
        return SignpostConnectionInfo.towards;
      case 3:
        return SignpostConnectionInfo.exit;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Navigation states
///
/// {@category Routes & Navigation}
enum NavigationStatus {
  /// Running, this is the normal state
  running,

  /// Paused, waiting for route to update
  ///
  /// Check navigation route status for details about route update
  waitingRoute,

  /// Paused, waiting for GPS location to recover
  waitingGps,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension NavigationStatusExtension on NavigationStatus {
  int get id {
    switch (this) {
      case NavigationStatus.running:
        return 0;
      case NavigationStatus.waitingRoute:
        return 1;
      case NavigationStatus.waitingGps:
        return 2;
    }
  }

  static NavigationStatus fromId(final int id) {
    switch (id) {
      case 0:
        return NavigationStatus.running;
      case 1:
        return NavigationStatus.waitingRoute;
      case 2:
        return NavigationStatus.waitingGps;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Navigation instruction class
///
/// This class should not be instantiated directly. Instead, use the related methods from a [NavigationService] instance.
///
/// {@category Routes & Navigation}
class NavigationInstruction extends GemAutoreleaseObject {
  // ignore: unused_element
  NavigationInstruction._() : _pointerId = -1;

  @internal
  NavigationInstruction.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Get the ISO 3166-1 alpha-3 country code for the current navigation instruction.
  ///
  /// Empty string means no country. See: http://en.wikipedia.org/wiki/ISO_3166-1 for the list of codes.
  ///
  /// **Returns**
  ///
  /// * The ISO 3166-1 alpha-3 country code for the current navigation instruction.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get currentCountryCodeISO {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getCurrentCountryCodeISO',
    );

    return resultString['result'];
  }

  /// Get the current street name.
  ///
  /// **Returns**
  ///
  /// * The current street name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get currentStreetName {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getCurrentStreetName',
    );

    return resultString['result'];
  }

  /// Get the maximum speed limit on the current street in meters per second.
  ///
  /// **Returns**
  ///
  /// * 0 if maximum speed limit is not available.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get currentStreetSpeedLimit {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getCurrentStreetSpeedLimit',
    );

    return resultString['result'];
  }

  /// Get drive side flag of the current traveled road.
  ///
  /// **Returns**
  ///
  /// * The drive side flag of the current traveled road, [DriveSide] value
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DriveSide get driveSide {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getDriveSide',
    );

    return DriveSideExtension.fromId(resultString['result']);
  }

  /// Check if next next turn information is available.
  ///
  /// **Returns**
  ///
  /// * True if next next turn information is available, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasNextNextTurnInfo {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'hasNextNextTurnInfo',
    );

    return resultString['result'];
  }

  /// Check if next next turn information is available.
  ///
  /// **Returns**
  ///
  /// * True if next turn information is available, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasNextTurnInfo {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'hasNextTurnInfo',
    );

    return resultString['result'];
  }

  /// Get the index of the current route instruction on the current route segment.
  ///
  /// **Returns**
  ///
  /// * The index of the next route instruction on the current route segment
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get instructionIndex {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getInstructionIndex',
    );

    return resultString['result'];
  }

  /// Get an image representation of current lane configuration.
  ///
  /// **Returns**
  ///
  /// * The lane image if lane information is available
  /// * null if no image is available
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Uint8List? getLaneImage({
    final Size? size,
    final ImageFileFormat? format,
    final LaneImageRenderSettings renderSettings =
        const LaneImageRenderSettings(),
  }) {
    return GemKitPlatform.instance.callGetImage(
      pointerId,
      'NavigationInstructionGetLaneImage',
      size?.width.toInt() ?? -1,
      size?.height.toInt() ?? -1,
      format?.id ?? -1,
      arg: jsonEncode(renderSettings),
    );
  }

  /// Get the image of the lane image
  ///
  /// **Parameters**
  ///
  /// **Returns**
  ///
  /// * The image for the lane image. The user is responsible to check if the image is valid.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  LaneImg get laneImg {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getLaneImg',
    );

    return LaneImg.init(resultString['result']);
  }

  /// Get the navigation/simulation status.
  ///
  /// **Returns**
  ///
  /// * The navigation/simulation status
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  NavigationStatus get navigationStatus {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getNavigationStatus',
    );

    return NavigationStatusExtension.fromId(resultString['result']);
  }

  /// Get the ISO 3166-1 alpha-3 country code for the next navigation instruction.
  ///
  /// Empty string means no country. See: http://en.wikipedia.org/wiki/ISO_3166-1 for the list of codes.
  ///
  /// **Returns**
  ///
  /// * The ISO 3166-1 alpha-3 country code for the next navigation instruction
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get nextCountryCodeISO {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getNextCountryCodeISO',
    );

    return resultString['result'];
  }

  /// Get the next next street name.
  ///
  /// **Returns**
  ///
  /// * The next street name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get nextNextStreetName {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getNextNextStreetName',
    );

    return resultString['result'];
  }

  /// Get the full details for the next-next turn.
  ///
  /// This may be used instead of `_getNextNextTurnIcon_` in order to customize turn display in UI.
  ///
  /// **Returns**
  ///
  /// * The full details for the next-next turn
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TurnDetails? get nextNextTurnDetails {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getNextNextTurnDetails',
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return TurnDetails.init(resultString['result']);
  }

  /// Get the schematic image of the next next turn.
  ///
  /// A simplified representation of the next next turn image. A detailed representation can be obtained with [nextNextTurnDetails].abstractGeometryImage.
  ///
  /// **Returns**
  ///
  /// * The image of the next next turn if available
  /// * null if no image is available
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Uint8List? getNextNextTurnImage({
    final Size? size,
    final ImageFileFormat? format,
  }) {
    return GemKitPlatform.instance.callGetImage(
      pointerId,
      'NavigationInstructionGetNextNextTurnImage',
      size?.width.toInt() ?? -1,
      size?.height.toInt() ?? -1,
      format?.id ?? -1,
    );
  }

  /// Get the image of the next next turn instruction.
  ///
  /// **Returns**
  ///
  /// * The next next turn image. The user is responsible to check if the image is valid.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  Img get nextNextTurnImg {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getNextNextTurnImg',
    );

    return Img.init(resultString['result']);
  }

  /// Get the textual description for the next next turn.
  ///
  /// **Returns**
  ///
  /// * The textual description for the next next turn
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get nextNextTurnInstruction {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getNextNextTurnInstruction',
    );

    return resultString['result'];
  }

  /// Get the next speed limit variation.
  ///
  /// **Parameters**
  ///
  /// * **IN** *checkDistance*	The speed limit variation search distance.
  ///
  /// **Returns**
  ///
  /// * The [NextSpeedLimit] object. Check the [NextSpeedLimit.status] to check the availability of the result.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  NextSpeedLimit getNextSpeedLimitVariation({
    final int checkDistance = 2147483647,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getNextSpeedLimitVariation',
      args: checkDistance,
    );

    return NextSpeedLimit.fromJson(resultString['result']);
  }

  /// Get the next next street name.
  ///
  /// **Returns**
  ///
  /// * The next next street name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get nextStreetName {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getNextStreetName',
    );

    return resultString['result'];
  }

  /// Get the full details for the next turn.
  ///
  /// This may be used instead of [getNextTurnImage] in order to customize turn display in UI.
  ///
  /// **Returns**
  ///
  /// * The full details for the next turn
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TurnDetails? get nextTurnDetails {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getNextTurnDetails',
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return TurnDetails.init(resultString['result']);
  }

  /// Get the schematic image of the next turn.
  ///
  /// A simplified representation of the next turn image. A detailed representation can be obtained with [nextTurnDetails].abstractGeometryImage.
  ///
  /// **Returns**
  ///
  /// * The image of the next turn
  Uint8List? getNextTurnImage({
    final Size? size,
    final ImageFileFormat? format,
  }) {
    return GemKitPlatform.instance.callGetImage(
      pointerId,
      'NavigationInstructionGetNextTurnImage',
      size?.width.toInt() ?? -1,
      size?.height.toInt() ?? -1,
      format?.id ?? -1,
    );
  }

  /// Get the image of the next turn instruction.
  ///
  /// **Returns**
  ///
  /// * The next turn image. The user is responsible to check if the image is valid.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  Img get nextTurnImg {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getNextTurnImg',
    );

    return Img.init(resultString['result']);
  }

  /// Get the textual description for the next turn.
  ///
  /// **Returns**
  ///
  /// * The textual description for the next turn
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get nextTurnInstruction {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getNextTurnInstruction',
    );

    return resultString['result'];
  }

  /// Get remaining travel time in seconds and remaining travel distance in meters to the destination.
  ///
  /// **Returns**
  ///
  /// * The remaining travel time in seconds and remaining travel distance in meters.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get remainingTravelTimeDistance {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getRemainingTravelTimeDistance',
    );

    return TimeDistance.fromJson(resultString['result']);
  }

  /// Get remaining traveling time in seconds to the next way point and the remaining travel distance in meters to the next way point.
  ///
  /// **Returns**
  ///
  /// * Remaining travel time in seconds to the next way point and the remaining travel distance in meters to the next waypoint.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get remainingTravelTimeDistanceToNextWaypoint {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getRemainingTravelTimeDistanceToNextWaypoint',
    );

    return TimeDistance.fromJson(resultString['result']);
  }

  /// Get the current road information.
  ///
  /// **Returns**
  ///
  /// * The current road information list reference
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<RoadInfo> get currentRoadInformation {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getCurrentRoadInformation',
    );

    final List<RoadInfo> list = (resultString['result'] as List<dynamic>)
        .map((final dynamic e) => RoadInfo.fromJson(e))
        .toList();
    return list;
  }

  /// Get the next road information.
  ///
  /// **Returns**
  ///
  /// * The next road information list reference
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<RoadInfo> get nextRoadInformation {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getNextRoadInformation',
    );

    final List<RoadInfo> list = (resultString['result'] as List<dynamic>)
        .map((final dynamic e) => RoadInfo.fromJson(e))
        .toList();
    return list;
  }

  /// Get the next next road information.
  ///
  /// **Returns**
  ///
  /// * The next next road information list reference
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<RoadInfo> get nextNextRoadInformation {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getNextNextRoadInformation',
    );

    final List<RoadInfo> list = (resultString['result'] as List<dynamic>)
        .map((final dynamic e) => RoadInfo.fromJson(e))
        .toList();
    return list;
  }

  /// Get the index of the current route segment.
  ///
  /// **Returns**
  ///
  /// * The index of the current route segment
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get segmentIndex {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getSegmentIndex',
    );

    return resultString['result'];
  }

  /// Check if signpost information is available.
  ///
  /// **Returns**
  ///
  /// * True if the instruction has signpost information, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasSignpostInfo {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'hasSignpostInfo',
    );

    return resultString['result'];
  }

  /// Get the extended signpost details.
  ///
  /// **Returns**
  ///
  /// * The extended signpost details.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  SignpostDetails? get signpostDetails {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getSignpostDetails',
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return SignpostDetails.init(resultString['result']);
  }

  /// Get the textual description for the signpost information.
  ///
  /// **Returns**
  ///
  /// * The textual description for the signpost information.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get signpostInstruction {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getSignpostInstruction',
    );

    return resultString['result'];
  }

  /// Get the distance to the next-next turn in meters and time in seconds.
  ///
  /// If there are no next next turn available, the time distance to next turn will be returned
  ///
  /// **Returns**
  ///
  /// * The time to the next-next turn in seconds and distance in meters
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get timeDistanceToNextNextTurn {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getTimeDistanceToNextNextTurn',
    );

    return TimeDistance.fromJson(resultString['result']);
  }

  /// Get the time to the next turn in seconds, distance in meters.
  ///
  /// **Returns**
  ///
  /// * The time to the next turn in seconds, distance in meters.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get timeDistanceToNextTurn {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getTimeDistanceToNextTurn',
    );

    return TimeDistance.fromJson(resultString['result']);
  }

  /// Get the traveled distance in meters and the traveled time in seconds.
  ///
  /// **Returns**
  ///
  /// * The traveled time in seconds and the the traveled distance in meters
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get traveledTimeDistance {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'NavigationInstruction',
      'getTraveledTimeDistance',
    );

    return TimeDistance.fromJson(resultString['result']);
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, Object>{
        'class': 'NavigationInstruction',
        'id': _pointerId,
      }),
    );
  }
}

/// The status of a [NextSpeedLimit] item
enum NextSpeedLimitStatus {
  /// The speed changes within the given distance
  withSpeedChange,

  /// The speed does not change within the given distance
  noSpeedChange,

  /// No speed info is available
  noData,
}

/// Next speed limit info
///
/// {@category Routes & Navigation}
class NextSpeedLimit {
  NextSpeedLimit({
    required this.coords,
    required this.distance,
    required this.speed,
  });

  factory NextSpeedLimit.fromJson(final Map<String, dynamic> json) {
    return NextSpeedLimit(
      coords: Coordinates.fromJson(json['coords']),
      distance: json['distance'],
      speed: json['speed'],
    );
  }

  /// Coordinates where the next speed limit begins
  Coordinates coords;

  /// Distance where the next speed limit begins
  int distance;

  /// Next speed limit value
  double speed;

  /// The status of the availability of the next speed limit
  NextSpeedLimitStatus get status {
    if (speed == 0 && distance == 0) {
      return NextSpeedLimitStatus.noSpeedChange;
    }
    if (speed == 0 && distance != 0) {
      return NextSpeedLimitStatus.noData;
    }
    return NextSpeedLimitStatus.withSpeedChange;
  }

  @override
  bool operator ==(covariant final NextSpeedLimit other) {
    return coords == other.coords &&
        distance == other.distance &&
        speed == other.speed;
  }

  @override
  int get hashCode => coords.hashCode ^ distance.hashCode ^ speed.hashCode;
}
