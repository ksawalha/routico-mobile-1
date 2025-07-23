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
import 'package:gem_kit/landmark_store.dart';
import 'package:gem_kit/position.dart';
import 'package:gem_kit/sense.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/map/overlays.dart';
import 'package:gem_kit/src/sense/sense_data_impl.dart';
import 'package:meta/meta.dart';

/// Alarm service class
///
/// {@category Routes & Navigation}
class AlarmService extends GemAutoreleaseObject {
  /// Creates a new instance of the [AlarmService] class.
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener* [AlarmListener] that gets notified of the alarm events.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  factory AlarmService(final AlarmListener listener) {
    return AlarmService._create(listener);
  }

  @internal
  AlarmService.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  dynamic get pointerId => _pointerId;

  /// Sets the alarm listener.
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener* [AlarmListener] that gets notified of the alarm events.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set alarmListener(final AlarmListener listener) {
    GemKitPlatform.instance.registerEventHandler(listener.id, listener);

    objectMethod(
      _pointerId,
      'AlarmService',
      'setAlarmListener',
      args: listener.id,
    );
  }

  /// Gets the distance in meters for alarming.
  ///
  /// **Returns**
  ///
  /// * Distance in meters
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get alarmDistance {
    final OperationResult result = objectMethod(
      _pointerId,
      'AlarmService',
      'getAlarmDistance',
    );

    return result['result'];
  }

  /// Sets the distance in meters for alarming.
  ///
  /// **Parameters**
  ///
  /// * **IN** *distance* Distance in meters
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set alarmDistance(final double distance) {
    objectMethod(
      _pointerId,
      'AlarmService',
      'setAlarmDistance',
      args: distance,
    );
  }

  /// Gets the status of the "alarming without route" flag.
  ///
  /// **Returns**
  ///
  /// * True if monitoring without route is enabled, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get monitorWithoutRoute {
    final OperationResult result = objectMethod(
      _pointerId,
      'AlarmService',
      'getMonitorWithoutRoute',
    );

    return result['result'];
  }

  /// Select if alarms should be provided when navigating without route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* Enable or disable monitoring without route.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set monitorWithoutRoute(final bool value) {
    objectMethod(
      _pointerId,
      'AlarmService',
      'setMonitorWithoutRoute',
      args: value,
    );
  }

  /// Provides the list of active overlay item alarms.
  ///
  /// When all alarms become inactive the list of overlay item alarms is empty([OverlayItemAlarmsList.size] == 0).
  ///
  /// **Returns**
  ///
  /// * The list of overlay item alarms
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  OverlayItemAlarmsList get overlayItemAlarms {
    final OperationResult result = objectMethod(
      _pointerId,
      'AlarmService',
      'getOverlayItemAlarms',
    );

    return OverlayItemAlarmsList.init(result['result']);
  }

  /// Provides the list of passed over overlay item alarms.
  ///
  /// **Returns**
  ///
  /// * The list of passed over overlay item alarms.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  OverlayItemAlarmsList get overlayItemAlarmsPassedOver {
    final OperationResult result = objectMethod(
      _pointerId,
      'AlarmService',
      'getOverlayItemAlarmsPassedOver',
    );

    return OverlayItemAlarmsList.init(result['result']);
  }

  /// Provides the list of active landmark alarms.
  ///
  /// When all alarms become inactive the list of overlay item alarms is empty([LandmarkAlarmsList.size] == 0).
  ///
  /// **Returns**
  ///
  /// * The list of landmark alarms
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  LandmarkAlarmsList get landmarkAlarms {
    final OperationResult result = objectMethod(
      _pointerId,
      'AlarmService',
      'getLandmarkAlarms',
    );

    return LandmarkAlarmsList.init(result['result']);
  }

  /// Provides the list of passed over landmark alarms.
  ///
  /// **Returns**
  ///
  /// * The list of passed over landmark alarms
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  LandmarkAlarmsList get landmarkAlarmsPassedOver {
    final OperationResult result = objectMethod(
      _pointerId,
      'AlarmService',
      'getLandmarkAlarmsPassedOver',
    );

    return LandmarkAlarmsList.init(result['result']);
  }

  /// Set the alarm overspeed threshold value, in meters per second.
  ///
  /// **Parameters**
  ///
  /// * **IN** *threshold* The overspeed threshold value, in meters per second.
  /// * **IN** *insideCityArea* Specify whether the given threshold is for inside city area or for outside city area.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setOverSpeedThreshold({
    required final double threshold,
    required final bool insideCityArea,
  }) {
    objectMethod(
      _pointerId,
      'AlarmService',
      'setOverSpeedThreshold',
      args: <String, Object>{
        'threshold': threshold,
        'insideCityArea': insideCityArea,
      },
    );
  }

  /// Get the alarm overspeed threshold value, in meters per second.
  ///
  /// **Parameters**
  ///
  /// * **IN** *insideCityArea* Specify whether the given threshold is for inside city area or for outside city area.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double getOverSpeedThreshold(final bool insideCityArea) {
    final OperationResult result = objectMethod(
      _pointerId,
      'AlarmService',
      'getOverSpeedThreshold',
      args: insideCityArea,
    );

    return result['result'];
  }

  /// Gets alarm current reference position.
  ///
  /// **Returns**
  ///
  /// * The reference position
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemPosition? get referencePosition {
    final OperationResult retVal = objectMethod(
      _pointerId,
      'AlarmService',
      'getReferencePosition',
      args: DataType.position.id,
    );
    final GemError gemApiError = GemErrorExtension.fromCode(
      retVal['gemApiError'],
    );

    if (gemApiError != GemError.success) {
      return null;
    }

    final dynamic res = retVal['result'];
    if (res != null) {
      return GemPositionImpl.fromJson(res);
    }
    return null;
  }

  /// Gets access to the alarm settings for the landmark stores.
  ///
  /// **Returns**
  ///
  /// * The landmark store collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  LandmarkStoreCollection get landmarks {
    final OperationResult result = objectMethod(
      _pointerId,
      'AlarmService',
      'lmks',
    );

    return LandmarkStoreCollection.init(result['result']);
  }

  /// Gets access to the collection of overlays to use for alarm.
  ///
  /// **Returns**
  ///
  /// * The overlay collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  OverlayMutableCollection get overlays {
    final OperationResult result = objectMethod(
      _pointerId,
      'AlarmService',
      'overlays',
    );

    return OverlayMutableCollection.init(result['result']);
  }

  /// Add new geographic area to monitor.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area* The geographic area to monitor.
  /// * **IN** *id* An unique identifier for the area
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void monitorArea(final GeographicArea area, {final String id = ''}) {
    objectMethod(
      _pointerId,
      'AlarmService',
      'monitorArea',
      args: <String, dynamic>{'area': area, 'id': id},
    );
  }

  /// Remove the given geographic area from monitor.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area* The geographic area to monitor.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void unmonitorArea(final GeographicArea area) {
    objectMethod(
      _pointerId,
      'AlarmService',
      'unmonitorArea',
      args: area.toJson(),
    );
  }

  /// Remove the given geographic areas ids from monitor.
  ///
  /// **Parameters**
  ///
  /// * **IN** *ids* The ids of the areas to monitor.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void unmonitorAreasByIds(List<String> ids) {
    objectMethod(_pointerId, 'AlarmService', 'unmonitorAreasByIds', args: ids);
  }

  /// Remove the all geographic areas from monitor.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void unmonitorAllAreas() {
    objectMethod(_pointerId, 'AlarmService', 'unmonitorAllAreas');
  }

  /// Get all monitored areas
  ///
  /// **Returns**
  ///
  /// * List of [AlarmMonitoredArea] objects.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<AlarmMonitoredArea> get monitoredAreas {
    final OperationResult result = objectMethod(
      _pointerId,
      'AlarmService',
      'getMonitoredAreas',
    );

    final List<dynamic> res = result['result'];
    return res
        .map((final dynamic item) => AlarmMonitoredArea.fromJson(item))
        .toList();
  }

  /// Gets areas containing current referenced position
  ///
  /// **Returns**
  ///
  /// * List of [AlarmMonitoredArea] objects.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<AlarmMonitoredArea> get insideAreas {
    final OperationResult result = objectMethod(
      _pointerId,
      'AlarmService',
      'getInsideAreas',
    );

    final List<dynamic> res = result['result'];
    return res
        .map((final dynamic item) => AlarmMonitoredArea.fromJson(item))
        .toList();
  }

  /// Gets areas not containing current referenced position
  ///
  /// **Returns**
  ///
  /// * List of [AlarmMonitoredArea] objects.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<AlarmMonitoredArea> get outsideAreas {
    final OperationResult result = objectMethod(
      _pointerId,
      'AlarmService',
      'getOutsideAreas',
    );

    final List<dynamic> res = result['result'];
    return res
        .map((final dynamic item) => AlarmMonitoredArea.fromJson(item))
        .toList();
  }

  /// Gets the tracking position source.
  ///
  /// **Returns**
  ///
  /// * The [DataSource].
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DataSource get trackedPositionSource {
    final OperationResult result = objectMethod(
      _pointerId,
      'AlarmService',
      'getTrackedPositionSource',
    );

    return DataSource.init(result['result']);
  }

  /// Enables the safety camera overlay.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, [GemError.notFound] if the overlay is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static GemError enableSafetyCamera() {
    return OverlayService.enableOverlay(CommonOverlayId.safety.id);
  }

  /// Disables the safety camera overlay.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, [GemError.notFound] if the overlay is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static GemError disableSafetyCamera() {
    return OverlayService.disableOverlay(CommonOverlayId.safety.id);
  }

  /// Check if the safety camera overlay is enabled.
  ///
  /// **Returns**
  ///
  /// * True if the safety camera overlay is enabled, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static bool get isSafetyCameraEnabled {
    return OverlayService.isOverlayEnabled(CommonOverlayId.safety.id);
  }

  /// Enables the social reports overlay.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, [GemError.notFound] if the overlay is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static GemError enableSocialReports() {
    return OverlayService.enableOverlay(CommonOverlayId.socialReports.id);
  }

  /// Disables the social reports overlay.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, [GemError.notFound] if the overlay is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static GemError disableSocialReports() {
    return OverlayService.disableOverlay(CommonOverlayId.socialReports.id);
  }

  /// Check if the social reports overlay is enabled.
  ///
  /// **Returns**
  ///
  /// * True if the social reports overlay is enabled, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static bool get isSocialReportsEnabled {
    return OverlayService.isOverlayEnabled(CommonOverlayId.socialReports.id);
  }

  /// Enables the social reports overlay for a specified category.
  ///
  /// **Parameters**
  ///
  /// * **IN** *categoryId* The overlay category id
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, [GemError.notFound] if the overlay is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static GemError enableSocialReportsWithCategory(int categoryId) {
    return OverlayService.enableOverlay(
      CommonOverlayId.socialReports.id,
      categUid: categoryId,
    );
  }

  /// Disables the social reports overlay for a specified category.
  ///
  /// **Parameters**
  ///
  /// * **IN** *categoryId* The overlay category id
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, [GemError.notFound] if the overlay is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static GemError disableSocialReportsWithCategory(int categoryId) {
    return OverlayService.disableOverlay(
      CommonOverlayId.socialReports.id,
      categUid: categoryId,
    );
  }

  /// Check if the social reports overlay for a specified category is enabled.
  ///
  /// **Parameters**
  ///
  /// * **IN** *categoryId* The overlay category id
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, [GemError.notFound] if the overlay is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static bool isSocialReportsEnabledWithCategory(int categoryId) {
    return OverlayService.isOverlayEnabled(
      CommonOverlayId.socialReports.id,
      categUid: categoryId,
    );
  }

  static AlarmService _create(final AlarmListener listener) {
    GemKitPlatform.instance.registerEventHandler(listener.id, listener);

    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, dynamic>{
        'class': 'AlarmService',
        'args': listener.id,
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    final AlarmService retVal = AlarmService.init(decodedVal['result']);
    return retVal;
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, dynamic>{'class': 'AlarmService', 'id': _pointerId}),
    );
  }
}

/// Alarm monitored area consisting of a [GeographicArea] and an id.
///
/// {@category Routes & Navigation}
class AlarmMonitoredArea {
  /// Constructor for creating an AlarmMonitoredArea object.
  AlarmMonitoredArea({required this.area, required this.id});

  // Factory constructor for creating an instance from a JSON map
  factory AlarmMonitoredArea.fromJson(final Map<String, dynamic> json) {
    return AlarmMonitoredArea(
      area: GeographicArea.fromJson(json['area']),
      id: json['id'],
    );
  }

  /// The geographic area
  final GeographicArea area;

  /// The area ID
  final String id;

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'area': area.toJson(), 'id': id};
  }
}
