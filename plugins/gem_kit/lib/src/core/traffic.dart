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
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/routing/routing_preferences.dart';
import 'package:meta/meta.dart';

/// Traffic events class
///
/// This class should not be instantiated directly. Instead, use the [GemMapController.registerCursorSelectionUpdatedOverlayItemsCallback] method to register a listener to obtain a list of instances.
/// Otherwise use the [RouteBase.trafficEvents] getter to get a list of instances from a route.
///
/// {@category Routes & Navigation}
class TrafficEvent extends GemAutoreleaseObject {
  @internal
  TrafficEvent() : _pointerId = -1;

  @internal
  TrafficEvent.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(id);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Checks if this traffic event is a roadblock.
  ///
  /// **Returns**
  ///
  /// * True if the traffic event is a roadblock.
  bool get isRoadblock {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'isRoadblock',
    );

    return resultString['result'];
  }

  /// Gets the estimated delay in seconds caused by the traffic event.
  ///
  /// **Returns**
  ///
  /// * The delay in seconds. Returns -1 if the delay is unknown.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get delay {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'getDelay',
    );

    return resultString['result'];
  }

  /// Gets the length in meters of the road segment affected by the traffic event.
  ///
  /// **Returns**
  ///
  /// * The length in meters. Returns -1 if the length is unknown.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get length {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'getLength',
    );

    return resultString['result'];
  }

  /// Gets the traffic event impact zone
  ///
  /// **Returns**
  ///
  /// * The impact zone type
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TrafficEventImpactZone get impactZone {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'getImpactZone',
    );

    return TrafficEventImpactZoneExtension.fromId(resultString['result']);
  }

  /// Gets the traffic event reference point
  ///
  /// **Returns**
  ///
  /// * The reference point. Returns (0,0) if the event is a [TrafficEventImpactZone.area].
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Coordinates get referencePoint {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'getReferencePoint',
    );

    return Coordinates.fromJson(resultString['result']);
  }

  /// Gets the bounding box of the traffic event.
  ///
  /// **Returns**
  ///
  /// * The bounding box
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea get boundingBox {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'getBoundingBox',
    );

    return RectangleGeographicArea.fromJson(resultString['result']);
  }

  /// Gets the traffic event description
  ///
  /// **Returns**
  ///
  /// * The description
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get description {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'getDescription',
    );

    return resultString['result'];
  }

  /// Gets the traffic event class
  ///
  /// **Returns**
  ///
  /// * The event class
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TrafficEventClass get eventClass {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'getEventClass',
    );

    return TrafficEventClassExtension.fromId(resultString['result']);
  }

  /// Gets the traffic event severity
  ///
  /// **Returns**
  ///
  /// * The event severity
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TrafficEventSeverity get eventSeverity {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'getEventSeverity',
    );

    return TrafficEventSeverityExtension.fromId(resultString['result']);
  }

  /// Gets the traffic event image
  ///
  /// **Returns**
  ///
  /// * The traffic event image
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Uint8List? getImage({final Size? size, final ImageFileFormat? format}) {
    return GemKitPlatform.instance.callGetImage(
      _pointerId,
      'TrafficEvent',
      size?.width.toInt() ?? -1,
      size?.height.toInt() ?? -1,
      format?.id ?? -1,
    );
  }

  /// Get the traffic event image
  ///
  /// **Returns**
  ///
  /// * Traffic event image. The user is responsible to check if the image is valid
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Img get img {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'getImg',
    );

    return Img.init(resultString['result']);
  }

  /// Gets the traffic event preview URL
  ///
  /// **Returns**
  ///
  /// * The preview URL
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get previewUrl {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'getPreviewUrl',
    );

    return resultString['result'];
  }

  /// Return true if the traffic event is a user roadblock
  ///
  /// **Returns**
  ///
  /// * True if the traffic event is a user roadblock, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isUserRoadblock {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'isUserRoadblock',
    );

    return resultString['result'];
  }

  /// Gets affected transport modes
  ///
  /// **Returns**
  ///
  /// * The affected transport modes
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RouteTransportMode get affectedTransportModes {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'getAffectedTransportMode',
    );

    final int res = resultString['result'];
    return RouteTransportModeExtension.fromId(res);
  }

  /// Gets start time ( UTC )
  ///
  /// **Returns**
  ///
  /// * The start time if it exists, otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DateTime? get startTime {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'getStartTime',
    );

    final int milliseconds = resultString['result'];
    if (milliseconds == 0) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
  }

  /// Gets end time ( UTC )
  ///
  /// **Returns**
  ///
  /// * The end time if it is available, otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DateTime? get endTime {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'getEndTime',
    );

    final int milliseconds = resultString['result'];
    if (milliseconds == 0) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
  }

  /// Checks if event has a sibling on opposite direction
  ///
  /// **Returns**
  ///
  /// * True if the event has a sibling on opposite direction, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get hasOppositeSibling {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'hasOppositeSibling',
    );

    return resultString['result'];
  }

  /// Get the traffic preview data as a list of parameters
  ///
  /// **Parameters**
  ///
  /// * **IN** *onComplete* Will be invoked when the operation is completed, providing the results and an error code.
  ///   * Will call with error code [GemError.success] and non-null results on success
  ///   * Will call with error code [GemError.notSupported] and non-null results if the operation is not supported for this object
  ///   * Will call with error code [GemError.noConnection] and non-null results if internet connection is not available
  ///   * Will call with error code [GemError.notFound] and non-null results if no preview data is available for this event
  ///   * Will call with error code [GemError.general] and non-null results if the request failed
  ///   * Will call with other error codes and null results on failure
  ///
  /// **Returns**
  ///
  /// * The ProgressListener associated to the request if it could be started, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  ProgressListener? getPreviewData(
    void Function(GemError error, SearchableParameterList? parameters) onResult,
  ) {
    final EventDrivenProgressListener listener = EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(listener.id, listener);
    final SearchableParameterList parameterList = SearchableParameterList();

    listener.registerOnCompleteWithDataCallback((int code, _, __) {
      final GemError error = GemErrorExtension.fromCode(code);
      GemKitPlatform.instance.unregisterEventHandler(listener.id);
      if (error != GemError.success) {
        onResult(error, null);
      } else {
        onResult(error, parameterList);
      }
    });

    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficEvent',
      'getPreviewData',
      args: <String, dynamic>{
        'first': parameterList.pointerId,
        'second': listener.id,
      },
    );

    if (resultString['result'] != 0) {
      GemKitPlatform.instance.unregisterEventHandler(listener.id);
      onResult(GemErrorExtension.fromCode(resultString['result']), null);
      return null;
    }

    return listener;
  }

  /// Cancel a previous call of [getPreviewData]
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener* [ProgressListener] to cancel
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void cancelGetPreviewData(ProgressListener listener) {
    objectMethod(
      _pointerId,
      'TrafficEvent',
      'cancelGetPreviewData',
      args: listener.id,
    );
  }
}

/// Route traffic events class
///
/// Use the [RouteBase.trafficEvents] getter to get a list of instances from a route.
///
/// {@category Routes & Navigation}
class RouteTrafficEvent extends TrafficEvent {
  // ignore: unused_element
  RouteTrafficEvent._();

  @internal
  RouteTrafficEvent.init(super.id) : super.init();

  /// Get the distance in meters from starting point on current route of the traffic event to the destination.
  ///
  /// **Returns**
  ///
  /// * The distance in meters if a route is available, otherwise 0.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get distanceToDestination {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTrafficEvent',
      'getDistanceToDestination',
    );

    return resultString['result'];
  }

  /// Get the route traffic event start point.
  ///
  /// **Returns**
  ///
  /// * The start point, [Coordinates] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Coordinates get from {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTrafficEvent',
      'getFrom',
    );

    return Coordinates.fromJson(resultString['result']);
  }

  /// Get the route traffic event end point.
  ///
  /// **Returns**
  ///
  /// * The end point, [Coordinates] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Coordinates get to {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTrafficEvent',
      'getTo',
    );

    return Coordinates.fromJson(resultString['result']);
  }

  /// Gets the traffic event start point as landmark.
  ///
  /// **Returns**
  ///
  /// * The record of `(Landmark, data locally cached flag)`. If the landmark has no local data cached the description and address info is empty.
  /// A call to asyncUpdateToFromData must be done in order gather information from server.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  (Landmark, bool) get fromLandmark {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTrafficEvent',
      'getFromLandmark',
    );

    return (
      Landmark.init(resultString['result']['first']),
      resultString['result']['second'],
    );
  }

  /// Gets the traffic event end point as landmark.
  ///
  /// **Returns**
  ///
  /// * The record of `(Landmark, data locally cached flag)`. If the landmark has no local data cached the description and address info is empty.
  /// A call to asyncUpdateToFromData must be done in order gather information from server.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  (Landmark, bool) get toLandmark {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTrafficEvent',
      'getToLandmark',
    );

    return (
      Landmark.init(resultString['result']['first']),
      resultString['result']['second'],
    );
  }

  /// Update the local data needed for 'from' and 'to' landmarks address and description.
  ///
  /// **Parameters**
  ///
  /// * **IN** *onCompleteCallback*	The callback that completes with the result of the operation:
  ///   * [GemError.success] if the operation suceeded
  ///   * [GemError.invalidInput] if the operation is not available for the current event or if an update has already been completed
  ///   * [GemError.inUse] if the operation is already in progress
  ///   * Other errors if the operation failed
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void asyncUpdateToFromData(
    final void Function(GemError err) onCompleteCallback,
  ) {
    final EventDrivenProgressListener listener = EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(listener.id, listener);

    listener.registerOnCompleteWithDataCallback((
      final int err,
      final _,
      final __,
    ) {
      onCompleteCallback(GemErrorExtension.fromCode(err));
    });

    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteTrafficEvent',
      'asyncUpdateToFromData',
      args: listener.id,
    );

    final int error = resultString['gemApiError'];
    if (error != 0) {
      onCompleteCallback(GemErrorExtension.fromCode(error));
    }
  }

  /// Cancel the update request.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void cancelUpdate() {
    objectMethod(_pointerId, 'RouteTrafficEvent', 'cancelUpdate');
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, Object>{
          'class': 'RouteTrafficEvent',
          'id': _pointerId,
        }),
      );
}

/// Affected transport modes for traffic events
///
/// Do not confuse with [RouteTransportMode].
///
/// {@category Routes & Navigation}
enum TrafficTransportMode {
  /// No affected transport mode
  none,

  /// Transport mode - on foot
  pedestrian,

  /// Transport mode - bicycle
  bicycle,

  /// Transport mode - car
  car,

  /// Transport mode - lorry/truck
  truck,
}

/// @nodoc
extension TrafficTransportModeExtension on TrafficTransportMode {
  int get id {
    switch (this) {
      case TrafficTransportMode.none:
        return 0;
      case TrafficTransportMode.pedestrian:
        return 1;
      case TrafficTransportMode.bicycle:
        return 2;
      case TrafficTransportMode.car:
        return 4;
      case TrafficTransportMode.truck:
        return 8;
    }
  }

  static TrafficTransportMode fromId(final int id) {
    switch (id) {
      case 0:
        return TrafficTransportMode.none;
      case 1:
        return TrafficTransportMode.pedestrian;
      case 2:
        return TrafficTransportMode.bicycle;
      case 4:
        return TrafficTransportMode.car;
      case 8:
        return TrafficTransportMode.truck;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Traffic event shape
///
/// {@category Routes & Navigation}
enum TrafficEventImpactZone {
  /// path as a collection of roads impact zone
  path,

  /// geographic area impact zone
  area,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension TrafficEventImpactZoneExtension on TrafficEventImpactZone {
  /// Id of ETrafficEventImpactZone
  int get id {
    switch (this) {
      case TrafficEventImpactZone.path:
        return 0;
      case TrafficEventImpactZone.area:
        return 1;
    }
  }

  /// From id
  static TrafficEventImpactZone fromId(final int id) {
    switch (id) {
      case 0:
        return TrafficEventImpactZone.path;
      case 1:
        return TrafficEventImpactZone.area;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Traffic events classes
///
/// {@category Routes & Navigation}
enum TrafficEventClass {
  /// other
  other,

  /// congestion
  levelOfService,

  /// attention
  expectedLevelOfService,

  /// accident
  accidents,

  /// accident
  incidents,

  /// no entry
  closuresAndLaneRestrictions,

  /// no entry
  carriagewayRestrictions,

  /// no entry
  exitRestrictions,

  /// no entry
  entryRestrictions,

  /// info
  trafficRestrictions,

  /// info
  carpoolInfo,

  /// roadworks
  roadworks,

  /// slippery road
  obstructionHazards,

  /// mandatory
  dangerousSituations,

  /// slippery road
  roadConditions,

  /// temperatures
  temperatures,

  /// precipitation and visibility
  precipitationAndVisibility,

  /// wind and air quality
  windAndAirQuality,

  /// activities
  activities,

  /// security alerts
  securityAlerts,

  /// info
  delays,

  /// restrictions removal
  cancellations,

  /// warning
  travelTimeInfo,

  /// dangerous vehicles
  dangerousVehicles,

  /// exceptional loads or vehicles
  exceptionalLoadsOrVehicles,

  /// traffic equipment status
  trafficEquipmentStatus,

  /// circulation closed
  sizeAndWeightLimits,

  /// parking restrictions
  parkingRestrictions,

  /// parking
  parking,

  /// info
  referenceToAudioBroadcast,

  /// info
  serviceMessages,

  /// info
  specialMessages,

  /// user events above this value
  userEventsBase,

  /// user-defined roadblock.
  userRoadblock,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension TrafficEventClassExtension on TrafficEventClass {
  int get id {
    switch (this) {
      case TrafficEventClass.other:
        return 0;
      case TrafficEventClass.levelOfService:
        return 1;
      case TrafficEventClass.expectedLevelOfService:
        return 2;
      case TrafficEventClass.accidents:
        return 3;
      case TrafficEventClass.incidents:
        return 4;
      case TrafficEventClass.closuresAndLaneRestrictions:
        return 5;
      case TrafficEventClass.carriagewayRestrictions:
        return 6;
      case TrafficEventClass.exitRestrictions:
        return 7;
      case TrafficEventClass.entryRestrictions:
        return 8;
      case TrafficEventClass.trafficRestrictions:
        return 9;
      case TrafficEventClass.carpoolInfo:
        return 10;
      case TrafficEventClass.roadworks:
        return 11;
      case TrafficEventClass.obstructionHazards:
        return 12;
      case TrafficEventClass.dangerousSituations:
        return 13;
      case TrafficEventClass.roadConditions:
        return 14;
      case TrafficEventClass.temperatures:
        return 15;
      case TrafficEventClass.precipitationAndVisibility:
        return 16;
      case TrafficEventClass.windAndAirQuality:
        return 17;
      case TrafficEventClass.activities:
        return 18;
      case TrafficEventClass.securityAlerts:
        return 19;
      case TrafficEventClass.delays:
        return 20;
      case TrafficEventClass.cancellations:
        return 21;
      case TrafficEventClass.travelTimeInfo:
        return 22;
      case TrafficEventClass.dangerousVehicles:
        return 23;
      case TrafficEventClass.exceptionalLoadsOrVehicles:
        return 24;
      case TrafficEventClass.trafficEquipmentStatus:
        return 25;
      case TrafficEventClass.sizeAndWeightLimits:
        return 26;
      case TrafficEventClass.parkingRestrictions:
        return 27;
      case TrafficEventClass.parking:
        return 28;
      case TrafficEventClass.referenceToAudioBroadcast:
        return 29;
      case TrafficEventClass.serviceMessages:
        return 30;
      case TrafficEventClass.specialMessages:
        return 31;
      case TrafficEventClass.userEventsBase:
        return 100;
      case TrafficEventClass.userRoadblock:
        return 100;
    }
  }

  static TrafficEventClass fromId(final int id) {
    switch (id) {
      case 0:
        return TrafficEventClass.other;
      case 1:
        return TrafficEventClass.levelOfService;
      case 2:
        return TrafficEventClass.expectedLevelOfService;
      case 3:
        return TrafficEventClass.accidents;
      case 4:
        return TrafficEventClass.incidents;
      case 5:
        return TrafficEventClass.closuresAndLaneRestrictions;
      case 6:
        return TrafficEventClass.carriagewayRestrictions;
      case 7:
        return TrafficEventClass.exitRestrictions;
      case 8:
        return TrafficEventClass.entryRestrictions;
      case 9:
        return TrafficEventClass.trafficRestrictions;
      case 10:
        return TrafficEventClass.carpoolInfo;
      case 11:
        return TrafficEventClass.roadworks;
      case 12:
        return TrafficEventClass.obstructionHazards;
      case 13:
        return TrafficEventClass.dangerousSituations;
      case 14:
        return TrafficEventClass.roadConditions;
      case 15:
        return TrafficEventClass.temperatures;
      case 16:
        return TrafficEventClass.precipitationAndVisibility;
      case 17:
        return TrafficEventClass.windAndAirQuality;
      case 18:
        return TrafficEventClass.activities;
      case 19:
        return TrafficEventClass.securityAlerts;
      case 20:
        return TrafficEventClass.delays;
      case 21:
        return TrafficEventClass.cancellations;
      case 22:
        return TrafficEventClass.travelTimeInfo;
      case 23:
        return TrafficEventClass.dangerousVehicles;
      case 24:
        return TrafficEventClass.exceptionalLoadsOrVehicles;
      case 25:
        return TrafficEventClass.trafficEquipmentStatus;
      case 26:
        return TrafficEventClass.sizeAndWeightLimits;
      case 27:
        return TrafficEventClass.parkingRestrictions;
      case 28:
        return TrafficEventClass.parking;
      case 29:
        return TrafficEventClass.referenceToAudioBroadcast;
      case 30:
        return TrafficEventClass.serviceMessages;
      case 31:
        return TrafficEventClass.specialMessages;
      case 100:
        return TrafficEventClass.userRoadblock;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Traffic event severity enum.
///
/// {@category Routes & Navigation}
enum TrafficEventSeverity {
  /// Stationary
  stationary,

  /// Queuing
  queuing,

  /// Slow traffic
  slowTraffic,

  /// Possible delay
  possibleDelay,

  /// Unknown
  unknown,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension TrafficEventSeverityExtension on TrafficEventSeverity {
  int get id {
    switch (this) {
      case TrafficEventSeverity.stationary:
        return 0;
      case TrafficEventSeverity.queuing:
        return 1;
      case TrafficEventSeverity.slowTraffic:
        return 2;
      case TrafficEventSeverity.possibleDelay:
        return 3;
      case TrafficEventSeverity.unknown:
        return 4;
    }
  }

  static TrafficEventSeverity fromId(final int id) {
    switch (id) {
      case 0:
        return TrafficEventSeverity.stationary;
      case 1:
        return TrafficEventSeverity.queuing;
      case 2:
        return TrafficEventSeverity.slowTraffic;
      case 3:
        return TrafficEventSeverity.possibleDelay;
      case 4:
        return TrafficEventSeverity.unknown;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Traffic usage type
///
/// Define how traffic service will be used
///
/// {@category Routes & Navigation}
enum TrafficUsage {
  /// No traffic
  none,

  /// Online and offline ( default )
  online,

  /// Offline only
  offline,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension TrafficUsageExtension on TrafficUsage {
  int get id {
    switch (this) {
      case TrafficUsage.none:
        return 0;
      case TrafficUsage.online:
        return 1;
      case TrafficUsage.offline:
        return 2;
    }
  }

  static TrafficUsage fromId(final int id) {
    switch (id) {
      case 0:
        return TrafficUsage.none;
      case 1:
        return TrafficUsage.online;
      case 2:
        return TrafficUsage.offline;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Restrictions which prevent online service functionality
///
/// {@category Routes & Navigation}
enum TrafficOnlineRestrictions {
  /// No restrictions
  none,

  /// Service is disabled from settings
  settings,

  /// No internet connection
  connection,

  /// Restricted by network type
  networkType,

  /// Missing provider data
  providerData,

  /// Outdated world map version
  worldMapVersion,

  /// Not enough disk space to store data
  diskSpace,

  /// Failed to initialize
  initFail,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension TrafficOnlineRestrictionsExtension on TrafficOnlineRestrictions {
  int get id {
    switch (this) {
      case TrafficOnlineRestrictions.none:
        return 0;
      case TrafficOnlineRestrictions.settings:
        return 1;
      case TrafficOnlineRestrictions.connection:
        return 2;
      case TrafficOnlineRestrictions.networkType:
        return 4;
      case TrafficOnlineRestrictions.providerData:
        return 8;
      case TrafficOnlineRestrictions.worldMapVersion:
        return 16;
      case TrafficOnlineRestrictions.diskSpace:
        return 32;
      case TrafficOnlineRestrictions.initFail:
        return 64;
    }
  }

  static TrafficOnlineRestrictions fromId(final int id) {
    switch (id) {
      case 0:
        return TrafficOnlineRestrictions.none;
      case 1:
        return TrafficOnlineRestrictions.settings;
      case 2:
        return TrafficOnlineRestrictions.connection;
      case 4:
        return TrafficOnlineRestrictions.networkType;
      case 8:
        return TrafficOnlineRestrictions.providerData;
      case 16:
        return TrafficOnlineRestrictions.worldMapVersion;
      case 32:
        return TrafficOnlineRestrictions.diskSpace;
      case 64:
        return TrafficOnlineRestrictions.initFail;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Traffic Preferences
///
/// This class should not be instantiated directly.
/// Use the [TrafficService.preferences] getter to get an instance.
///
/// {@category Routes & Navigation}
class TrafficPreferences extends GemAutoreleaseObject {
  // ignore: unused_element
  TrafficPreferences._() : _pointerId = -1;

  @internal
  TrafficPreferences.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(id);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Get the type of traffic service that is used.
  ///
  /// **Returns**
  ///
  /// * The traffic service usage type
  TrafficUsage get useTraffic {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TrafficPreferences',
      'getUseTraffic',
    );

    return TrafficUsageExtension.fromId(resultString['result']);
  }

  /// Enable/disable traffic service
  ///
  /// Default is UseOnline
  ///
  /// **Parameters**
  ///
  /// * **IN** *useTraffic* The traffic service usage type
  set useTraffic(final TrafficUsage useTraffic) {
    objectMethod(
      _pointerId,
      'TrafficPreferences',
      'setUseTraffic',
      args: useTraffic.id,
    );
  }
}

/// User roadblock path preview match info
///
/// Used for [TrafficService.getPersistentRoadblockPathPreview].
///
/// {@category Routes & Navigation}
class UserRoadblockPathPreviewCoordinate {
  UserRoadblockPathPreviewCoordinate._({
    required this.coordinates,
    required int matchLink,
    required double matchRatio,
  })  : _matchRatio = matchRatio,
        _matchLink = matchLink;

  /// Create a UserRoadblockPathPreviewCoordinate from a Coordinates
  factory UserRoadblockPathPreviewCoordinate.fromCoordinates(
    Coordinates coords,
  ) {
    return UserRoadblockPathPreviewCoordinate._(
      coordinates: coords,
      matchLink: 0,
      matchRatio: 0,
    );
  }

  factory UserRoadblockPathPreviewCoordinate.fromJson(
    Map<String, dynamic> json,
  ) =>
      UserRoadblockPathPreviewCoordinate._(
        coordinates: Coordinates.fromJson(json['coord']),
        matchLink: json['matchLink'],
        matchRatio: json['matchRatio'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'coord': coordinates,
        'matchLink': _matchLink,
        'matchRatio': _matchRatio,
      };

  /// Coordinates
  Coordinates coordinates;

  /// Match link index.
  ///
  /// Used internally and should be ignored by the user.
  int _matchLink;

  /// Match ratio
  ///
  /// Used internally and should be ignored by the user.
  double _matchRatio;

  @override
  bool operator ==(covariant UserRoadblockPathPreviewCoordinate other) {
    return coordinates == other.coordinates &&
        _matchLink == other._matchLink &&
        _matchRatio == other._matchRatio;
  }

  @override
  int get hashCode => Object.hash(coordinates, _matchLink, _matchRatio);
}

/// Traffic service. Adds support to update traffic information.
///
/// {@category Routes & Navigation}
abstract class TrafficService {
  /// Gets access to the traffic service preferences.
  ///
  /// **Returns**
  ///
  /// * The traffic service preferences
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static TrafficPreferences get preferences {
    final OperationResult resultString = staticMethod(
      'TrafficService',
      'preferences',
    );

    return TrafficPreferences.init(resultString['result']);
  }

  /// Gets the online traffic service restrictions for the given position
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The position
  ///
  /// **Returns**
  ///
  /// * The online traffic service restrictions
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static TrafficOnlineRestrictions getOnlineServiceRestrictions(
    Coordinates coords,
  ) {
    final OperationResult resultString = staticMethod(
      'TrafficService',
      'getOnlineServiceRestrictions',
      args: coords,
    );

    return TrafficOnlineRestrictionsExtension.fromId(resultString['result']);
  }

  /// Gets data transfer statistics for this service.
  ///
  /// **Returns**
  ///
  /// * The data transfer statistics
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static TransferStatistics get transferStatistics {
    final OperationResult resultString = objectMethod(
      0,
      'TrafficService',
      'getTransferStatistics',
    );

    return TransferStatistics.init(resultString['result']);
  }

  /// Add an user persistent roadblock to collection ( path impact zone type )
  ///
  /// If coords size == 1, a point located roadblock is defined - this may result in 2 real roadblocks for matched road both ways.
  /// If coords size > 1, a path located roadblock is defined - this will result in 1 map roadblock in start -> end way
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The roadblock coordinates list
  /// * **IN** *startTime* The roadblock start time
  /// * **IN** *expireTime* The roadblock expire time
  /// * **IN** *transportMode* The transport mode for which the roadblock applies
  /// * **IN** *id* The user roadblock id. Can be used to get / delete a defined roadblock
  ///
  /// **Returns**
  ///
  /// * The [TrafficEvent] object and [GemError.success] if successful
  /// * Null together with the error code if failed:
  ///   * [GemError.activation] means roadblocks are disabled from preferences
  ///   * [GemError.exist] means the roadblock already exist
  ///   * [GemError.invalidInput] means the given parameters are invalid
  ///   * [GemError.notFound] means a suitable street has not been found or that map data is not loaded for the given coordinates
  ///   * [GemError.inUse] means the roadblock id is already in use
  ///   * [GemError.noRoute] means the roadblock cannot be defined using the input coordinates
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static (TrafficEvent?, GemError) addPersistentRoadblockByCoordinates({
    required List<Coordinates> coords,
    required DateTime startTime,
    required DateTime expireTime,
    required RouteTransportMode transportMode,
    required String id,
  }) {
    final OperationResult resultString = staticMethod(
      'TrafficService',
      'addPersistentRoadblockCoords',
      args: <String, dynamic>{
        'coord': coords,
        'startUTC': startTime.millisecondsSinceEpoch,
        'expireUTC': expireTime.millisecondsSinceEpoch,
        'transportMode': transportMode.id,
        'id': id,
      },
    );

    final GemError error = GemErrorExtension.fromCode(
      resultString['result']['second'],
    );
    if (error != GemError.success) {
      return (null, error);
    }

    return (
      TrafficEvent.init(resultString['result']['first']),
      error,
    );
  }

  /// Add an user persistent roadblock to collection ( area impact zone type )
  ///
  ///
  /// **Parameters**
  ///
  /// * **IN** *area* The geographic area affected by the roadblock
  /// * **IN** *startTime* The roadblock start time
  /// * **IN** *expireTime* The roadblock expire time
  /// * **IN** *transportMode* The transport mode for which the roadblock applies
  /// * **IN** *id* The user roadblock id. Can be used to get / delete a defined roadblock
  ///
  /// **Returns**
  ///
  /// * The [TrafficEvent] object and [GemError.success] if successful
  /// * Null together with the error code if failed:
  ///   * [GemError.activation] means roadblocks are disabled from preferences
  ///   * [GemError.invalidInput] means the given parameters are invalid
  ///   * [GemError.exist] means the roadblock already exist
  ///   * [GemError.inUse] means the roadblock id is already in use
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static (TrafficEvent?, GemError) addPersistentRoadblockByArea({
    required GeographicArea area,
    required DateTime startTime,
    required DateTime expireTime,
    required RouteTransportMode transportMode,
    required String id,
  }) {
    final OperationResult resultString = staticMethod(
      'TrafficService',
      'addPersistentRoadblockArea',
      args: <String, dynamic>{
        'area': area,
        'startUTC': startTime.millisecondsSinceEpoch,
        'expireUTC': expireTime.millisecondsSinceEpoch,
        'transportMode': transportMode.id,
        'id': id,
      },
    );

    final GemError error = GemErrorExtension.fromCode(
      resultString['result']['second'],
    );
    if (error != GemError.success) {
      return (null, error);
    }

    return (
      TrafficEvent.init(resultString['result']['first']),
      error,
    );
  }

  /// Add an user persistent anti-area roadblock to collection
  ///
  /// **Parameters**
  ///
  /// * **IN** *area* The geographic area not affected by the roadblock, i.e. the anti-area ( world wide - area ) is the roadblock
  /// * **IN** *startTime* The roadblock start time
  /// * **IN** *expireTime* The roadblock expire time
  /// * **IN** *transportMode* The transport mode for which the roadblock applies
  /// * **IN** *id* The user roadblock id. Can be used to get / delete a defined roadblock
  ///
  /// **Returns**
  ///
  /// * The [TrafficEvent] object and [GemError.success] if successful
  /// * Null together with the error code if failed:
  ///   * [GemError.activation] means roadblocks are disabled from preferences
  ///   * [GemError.invalidInput] means the given parameters are invalid
  ///   * [GemError.exist] means the roadblock already exist
  ///   * [GemError.inUse] means the roadblock id is already in use
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static (TrafficEvent?, GemError) addAntiPersistentRoadblockByArea({
    required GeographicArea area,
    required DateTime startTime,
    required DateTime expireTime,
    required RouteTransportMode transportMode,
    required String id,
  }) {
    final OperationResult resultString = staticMethod(
      'TrafficService',
      'addPersistentAntiRoadblockArea',
      args: <String, dynamic>{
        'area': area,
        'startUTC': startTime.millisecondsSinceEpoch,
        'expireUTC': expireTime.millisecondsSinceEpoch,
        'transportMode': transportMode.id,
        'id': id,
      },
    );

    final GemError error = GemErrorExtension.fromCode(
      resultString['result']['second'],
    );
    if (error != GemError.success) {
      return (null, error);
    }

    return (
      TrafficEvent.init(resultString['result']['first']),
      error,
    );
  }

  /// Remove an user persistent roadblock identified by id
  ///
  /// **Parameters**
  ///
  /// * **IN** *id* The roadblock id as it was provided in addPersistentRoadblock function
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.notFound] if the roadblock does not exist
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static GemError removePersistentRoadblockById(String id) {
    final OperationResult resultString = staticMethod(
      'TrafficService',
      'removePersistentRoadblockById',
      args: id,
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Remove an user persistent roadblock identified by a reference coordinate ( for path impact zone type )
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The roadblock start coordinates. Must be equal with first coordinate in coords list provided when the roadblock was defined
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.notFound] if the roadblock does not exist
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static GemError removePersistentRoadblockByCoordinates(Coordinates coords) {
    final OperationResult resultString = staticMethod(
      'TrafficService',
      'removePersistentRoadblock',
      args: coords,
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Remove all user persistent roadblock
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static void removeAllPersistentRoadblocks() {
    staticMethod(
      'TrafficService',
      'removeAllPersistentRoadblocks',
    );
  }

  /// Get an user persistent roadblock identified by id
  ///
  /// **Parameters**
  ///
  /// * **IN** *id* The roadblock id as it was provided in addPersistentRoadblock function
  ///
  /// **Returns**
  ///
  /// * The roadblock if found, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static TrafficEvent? getPersistentRoadblock(String id) {
    final OperationResult resultString = staticMethod(
      'TrafficService',
      'getPersistentRoadblock',
      args: id,
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return TrafficEvent.init(resultString['result']);
  }

  /// Get all persistent user roadblocks
  ///
  /// **Returns**
  ///
  /// * The list of persistent user roadblocks
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static List<TrafficEvent> get persistentRoadblocks {
    final OperationResult resultString = staticMethod(
      'TrafficService',
      'getPersistentRoadblocks',
    );

    final TrafficEventList eventsList = TrafficEventList.init(
      resultString['result'],
    );
    return eventsList.toList();
  }

  /// Remove an user roadblock ( persistent or non-persistent )
  ///
  /// **Parameters**
  ///
  /// * **IN** *event* The roadblock to be removed
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static void removeUserRoadblock(TrafficEvent event) {
    staticMethod(
      'TrafficService',
      'removeUserRoadblock',
      args: event.pointerId,
    );
  }

  /// Get persistent roadblock path preview
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The previous defined coordinates in roadblock path from where to start the preview
  /// * **IN** *to* The movable coordinate in roadblock path to where the preview ends
  /// * **IN** *to* The transport mode
  ///
  /// **Returns**
  ///
  /// * The coordinates list preview of the roadblock path in from -> last order
  /// * The next roadblock point match suggestion
  /// * The error code. See the [addPersistentRoadblockByCoordinates] method for possible error codes for more details.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static (List<Coordinates>, UserRoadblockPathPreviewCoordinate, GemError)
      getPersistentRoadblockPathPreview({
    required UserRoadblockPathPreviewCoordinate from,
    required Coordinates to,
    required RouteTransportMode transportMode,
  }) {
    final OperationResult resultString = staticMethod(
      'TrafficService',
      'getPersistentRoadblockPathPreview',
      args: <String, dynamic>{
        'from': from,
        'to': to,
        'transportMode': transportMode.id,
      },
    );

    final List<Coordinates> coordinates =
        (resultString['result']['coords'] as List<dynamic>)
            .map((dynamic e) => Coordinates.fromJson(e))
            .toList();
    final UserRoadblockPathPreviewCoordinate previewCoordinate =
        UserRoadblockPathPreviewCoordinate.fromJson(
      resultString['result']['preview'],
    );
    final GemError error = GemErrorExtension.fromCode(
      resultString['result']['error'],
    );

    return (coordinates, previewCoordinate, error);
  }

  /// Set persistent roadblocks listener
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener* The listener to be set
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static set persistentRoadblockListener(PersistentRoadblockListener listener) {
    GemKitPlatform.instance.registerEventHandler(listener.id, listener);

    staticMethod(
      'TrafficService',
      'setPersistentRoadblockListener',
      args: listener.id,
    );
  }
}
