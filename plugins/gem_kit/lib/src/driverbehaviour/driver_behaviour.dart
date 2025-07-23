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

import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/sense/sense_data_source.dart';
import 'package:meta/meta.dart';

/// Describes various driving-related events.
///
/// {@category Driver Behaviour}
enum DrivingEvent {
  /// No event
  noEvent,

  /// Starting a trip
  startingTrip,

  /// Finishing a trip
  finishingTrip,

  /// Resting
  resting,

  /// Harsh acceleration
  harshAcceleration,

  /// Harsh braking
  harshBraking,

  /// Cornering
  cornering,

  /// Swerving
  swerving,

  /// Tailgating
  tailgating,

  /// Ignoring signs
  ignoringSigns,
}

/// This class will not be documented.
///
/// @nodoc
extension DrivingEventExtension on DrivingEvent {
  int get id {
    switch (this) {
      case DrivingEvent.noEvent:
        return 0;
      case DrivingEvent.startingTrip:
        return 1;
      case DrivingEvent.finishingTrip:
        return 2;
      case DrivingEvent.resting:
        return 3;
      case DrivingEvent.harshAcceleration:
        return 4;
      case DrivingEvent.harshBraking:
        return 5;
      case DrivingEvent.cornering:
        return 6;
      case DrivingEvent.swerving:
        return 7;
      case DrivingEvent.tailgating:
        return 8;
      case DrivingEvent.ignoringSigns:
        return 9;
    }
  }

  static DrivingEvent fromId(final int id) {
    switch (id) {
      case 0:
        return DrivingEvent.noEvent;
      case 1:
        return DrivingEvent.startingTrip;
      case 2:
        return DrivingEvent.finishingTrip;
      case 3:
        return DrivingEvent.resting;
      case 4:
        return DrivingEvent.harshAcceleration;
      case 5:
        return DrivingEvent.harshBraking;
      case 6:
        return DrivingEvent.cornering;
      case 7:
        return DrivingEvent.swerving;
      case 8:
        return DrivingEvent.tailgating;
      case 9:
        return DrivingEvent.ignoringSigns;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// A mapped driving event.
///
/// Provides information about a driving event.
///
/// This class should not be instantiated directly. Instead, use the [DriverBehaviourAnalysis.drivingEvents] getter to obtain a list of instances.
///
/// {@category Driver Behaviour}
class MappedDrivingEvent extends GemAutoreleaseObject {
  // ignore: unused_element
  MappedDrivingEvent._() : _pointerId = -1;

  @internal
  MappedDrivingEvent.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }

  final int _pointerId;

  int get pointerId => _pointerId;

  /// Get the time of the event in milliseconds since epoch.
  ///
  /// **Returns**
  ///
  /// The time of the event in milliseconds since epoch.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get time {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MappedDrivingEvent',
      'getTime',
    );

    return resultString['result'];
  }

  /// Get the latitude coordinates of the event.
  ///
  /// **Returns**
  ///
  /// The latitude coordinates of the event.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get latitudeDeg {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MappedDrivingEvent',
      'getLatitudeDeg',
    );

    return resultString['result'];
  }

  /// Get the longitude coordinates of the event.
  ///
  /// **Returns**
  ///
  /// The longitude coordinates of the event.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get longitudeDeg {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MappedDrivingEvent',
      'getLongitudeDeg',
    );

    return resultString['result'];
  }

  /// Get the detected event type.
  ///
  /// **Returns**
  ///
  /// The detected event type. See [DrivingEvent].
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DrivingEvent get eventType {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MappedDrivingEvent',
      'getEventType',
    );

    return DrivingEventExtension.fromId(resultString['result']);
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, Object>{
          'class': 'MappedDrivingEvent',
          'id': _pointerId,
        }),
      );
}

/// Driving scores.
///
/// Provides information about driving scores.
///
/// This class should not be instantiated directly. Instead, use the [DriverBehaviourAnalysis.drivingScores] getter to obtain a list of instances.
///
/// {@category Driver Behaviour}
class DrivingScores extends GemAutoreleaseObject {
  // ignore: unused_element
  DrivingScores._() : _pointerId = -1;

  @internal
  DrivingScores.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }

  final int _pointerId;

  int get pointerId => _pointerId;

  /// Get the actual average speed risk score.
  ///
  /// A score is between 0 and 100, with 0 = unsafe, 50 = neutral, 100 = safe.
  ///
  /// A score of -1 means invalid (not available)
  ///
  /// **Returns**
  ///
  /// The average speed risk score.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get speedAverageRiskScore {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DrivingScores',
      'getSpeedAverageRiskScore',
    );

    return resultString['result'];
  }

  /// Get the actual speed variation risk score.
  ///
  /// A score is between 0 and 100, with 0 = unsafe, 50 = neutral, 100 = safe.
  ///
  /// A score of -1 means invalid (not available)
  ///
  /// **Returns**
  ///
  /// The speed variation risk score.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get speedVariableRiskScore {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DrivingScores',
      'getSpeedVariableRiskScore',
    );

    return resultString['result'];
  }

  /// Get the actual harsh acceleration risk score.
  ///
  /// A score is between 0 and 100, with 0 = unsafe, 50 = neutral, 100 = safe.
  ///
  /// A score of -1 means invalid (not available)
  ///
  /// **Returns**
  ///
  /// The harsh acceleration risk score.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get harshAccelerationScore {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DrivingScores',
      'getHarshAccelerationScore',
    );

    return resultString['result'];
  }

  /// Get the actual harsh breaking risk score.
  ///
  /// A score is between 0 and 100, with 0 = unsafe, 50 = neutral, 100 = safe.
  ///
  /// A score of -1 means invalid (not available)
  ///
  /// **Returns**
  ///
  /// The harsh breaking risk score.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get harshBrakingScore {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DrivingScores',
      'getHarshBrakingScore',
    );

    return resultString['result'];
  }

  /// Get the actual swerving risk score.
  ///
  /// A score is between 0 and 100, with 0 = unsafe, 50 = neutral, 100 = safe.
  ///
  /// A score of -1 means invalid (not available)
  ///
  /// **Returns**
  ///
  /// The swerving risk score.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get swervingScore {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DrivingScores',
      'getSwervingScore',
    );

    return resultString['result'];
  }

  /// Get the actual cornering risk score.
  ///
  /// A score is between 0 and 100, with 0 = unsafe, 50 = neutral, 100 = safe.
  ///
  /// A score of -1 means invalid (not available)
  ///
  /// **Returns**
  ///
  /// The cornering risk score.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get corneringScore {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DrivingScores',
      'getCorneringScore',
    );

    return resultString['result'];
  }

  /// Get the actual tailgating risk score.
  ///
  /// A score is between 0 and 100, with 0 = unsafe, 50 = neutral, 100 = safe.
  ///
  /// A score of -1 means invalid (not available)
  ///
  /// **Returns**
  ///
  /// The tailgating risk score.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  @experimental
  double get tailgatingScore {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DrivingScores',
      'getTailgatingScore',
    );

    return resultString['result'];
  }

  /// Get the actual ignored stop signs risk score.
  ///
  /// A score is between 0 and 100, with 0 = unsafe, 50 = neutral, 100 = safe.
  ///
  /// A score of -1 means invalid (not available)
  ///
  /// **Returns**
  ///
  /// The ignored stop signs risk score.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get ignoredStopSignsScore {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DrivingScores',
      'getIgnoredStopSignsScore',
    );

    return resultString['result'];
  }

  /// Get the actual fatigue risk score.
  ///
  /// A score is between 0 and 100, with 0 = unsafe, 50 = neutral, 100 = safe.
  ///
  /// A score of -1 means invalid (not available)
  ///
  /// **Returns**
  ///
  /// The fatigue risk score.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get fatigueScore {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DrivingScores',
      'getFatigueScore',
    );

    return resultString['result'];
  }

  /// Get the aggregate risk score.
  ///
  /// A score is between 0 and 100, with 0 = unsafe, 50 = neutral, 100 = safe.
  ///
  /// A score of -1 means invalid (not available)
  ///
  /// **Returns**
  ///
  /// The aggregate risk score.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get aggregateScore {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DrivingScores',
      'getAggregateScore',
    );

    return resultString['result'];
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(
            <String, Object>{'class': 'DrivingScores', 'id': _pointerId}),
      );
}

/// A driver behaviour analysis.
///
/// Provides methods for getting driver behaviour analysis data.
///
/// This class should not be instantiated directly. Instead, use the methods provided by the [DriverBehaviour] class.
///
/// {@category Driver Behaviour}
class DriverBehaviourAnalysis extends GemAutoreleaseObject {
  // ignore: unused_element
  DriverBehaviourAnalysis._() : _pointerId = -1;

  @internal
  DriverBehaviourAnalysis.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }

  final int _pointerId;

  int get pointerId => _pointerId;

  /// Get the start time of the session in milliseconds since epoch.
  ///
  /// **Returns**
  ///
  /// The start time of the session in milliseconds since epoch.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get startTime {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getStartTime',
    );

    return resultString['result'];
  }

  /// Get the finsih time of the session in milliseconds since epoch.
  ///
  /// **Returns**
  ///
  /// The finish time of the session in milliseconds since epoch.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get finishTime {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getFinishTime',
    );

    return resultString['result'];
  }

  /// Get the driven kilometers.
  ///
  /// Part of session statistics.
  ///
  /// **Returns**
  ///
  /// The driven kilometers.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get kilometersDriven {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getKilometersDriven',
    );

    return resultString['result'];
  }

  /// Get the number of minutes driven.
  ///
  /// Part of session statistics.
  ///
  /// **Returns**
  ///
  /// The minutes driven.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get minutesDriven {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getMinutesDriven',
    );

    return resultString['result'];
  }

  /// Get the total number of elapsed minutes.
  ///
  /// Part of session statistics.
  ///
  /// **Returns**
  ///
  /// The total number of elapsed minutes.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get minutesTotalElapsed {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getMinutesTotalElapsed',
    );

    return resultString['result'];
  }

  /// Returns the total number of minutes the driver was speeding.
  ///
  /// Part of session statistics.
  ///
  /// **Returns**
  ///
  /// The total number of minutes spent speeding.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get minutesSpeeding {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getMinutesSpeeding',
    );

    return resultString['result'];
  }

  /// Returns the total number of minutes the driver was tailgating.
  ///
  /// Part of session statistics.
  ///
  /// **Returns**
  ///
  /// The total number of minutes spent tailgating.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get minutesTailgating {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getMinutesTailgating',
    );

    return resultString['result'];
  }

  /// Increase of accident probability over a nominal chance (percentage).
  ///
  /// **Returns**
  ///
  /// The risk related to mean speed.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get riskRelatedToMeanSpeed {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getRiskRelatedToMeanSpeed',
    );

    return resultString['result'];
  }

  /// Increase of accident probability over a nominal chance (percentage).
  ///
  /// **Returns**
  ///
  /// The risk related to speed variation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get riskRelatedToSpeedVariation {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getRiskRelatedToSpeedVariation',
    );

    return resultString['result'];
  }

  /// Number of harsh acceleration events detected
  ///
  /// **Returns**
  ///
  /// The number of harsh accelerations detected.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get numberOfHarshAccelerationEvents {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getNumberOfHarshAccelerationEvents',
    );

    return resultString['result'];
  }

  /// Number of harsh breaking events detected
  ///
  /// **Returns**
  ///
  /// The number of harsh breakings detected.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get numberOfHarshBrakingEvents {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getNumberOfHarshBrakingEvents',
    );

    return resultString['result'];
  }

  /// Number of cornering events detected
  ///
  /// **Returns**
  ///
  /// The number of cornerings detected.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get numberOfCorneringEvents {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getNumberOfCorneringEvents',
    );

    return resultString['result'];
  }

  /// Number of swerving events detected
  ///
  /// **Returns**
  ///
  /// The number of swervings detected.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get numberOfSwervingEvents {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getNumberOfSwervingEvents',
    );

    return resultString['result'];
  }

  /// Number of ignored stop signs events detected
  ///
  /// **Returns**
  ///
  /// The number of ignored stop signs events detected.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get numberOfIgnoredStopSigns {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getNumberOfIgnoredStopSigns',
    );

    return resultString['result'];
  }

  /// Number of stop signs detected
  ///
  /// **Returns**
  ///
  /// The number of encountered stop signs detected.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get numberOfEncounteredStopSigns {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getNumberOfEncounteredStopSigns',
    );

    return resultString['result'];
  }

  /// Get flag telling whether the analysis is valid.
  ///
  /// **Returns**
  ///
  /// True if the analysis is valid, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isValid {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'isValid',
    );

    return resultString['result'];
  }

  /// Get scores for this session (partial and aggregate)
  ///
  /// **Returns**
  ///
  /// The scores for this session (partial and aggregate).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DrivingScores? get drivingScores {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getDrivingScores',
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return DrivingScores.init(resultString['result']);
  }

  /// Get all mapped driving events.
  ///
  /// **Returns**
  ///
  /// The list of mapped driving events.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<MappedDrivingEvent> get drivingEvents {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviourAnalysis',
      'getDrivingEvents',
    );

    final List<dynamic> listJson = resultString['result'];
    final List<MappedDrivingEvent> retList = listJson
        .map((final dynamic eventId) => MappedDrivingEvent.init(eventId))
        .toList();
    return retList;
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, Object>{
          'class': 'DriverBehaviourAnalysis',
          'id': _pointerId,
        }),
      );
}

/// The driver behaviour class.
///
/// Provides methods for starting, stopping, managing and getting driver behaviour analysis.
///
/// {@category Driver Behaviour}
class DriverBehaviour extends GemAutoreleaseObject {
  /// Create a new driver behaviour instance.
  ///
  /// **Parameters**
  ///
  /// * [dataSource] The data source to use.
  /// * [useMapMatch] Whether to use map match or not.
  factory DriverBehaviour({
    required final DataSource dataSource,
    required final bool useMapMatch,
  }) {
    return DriverBehaviour._create(dataSource, useMapMatch);
  }
  // ignore: unused_element
  DriverBehaviour._() : _pointerId = -1;

  @internal
  DriverBehaviour.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Start a new analysis.
  ///
  /// **Returns**
  ///
  /// True if the analysis was started successfully, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool startAnalysis() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviour',
      'startAnalysis',
    );

    return resultString['result'];
  }

  /// Stop the current analysis and get its result.
  ///
  /// **Returns**
  ///
  /// The analysis result if the analysis was stopped successfully, null otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DriverBehaviourAnalysis? stopAnalysis() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviour',
      'stopAnalysis',
    );

    if (resultString['result'] == -1 || resultString['gemApiError'] != 0) {
      return null;
    }

    return DriverBehaviourAnalysis.init(resultString['result']);
  }

  /// Get the ongoing analysis.
  ///
  /// **Returns**
  ///
  /// The ongoing analysis. Use [DriverBehaviourAnalysis.isValid] to check if the analysis is valid.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DriverBehaviourAnalysis? getOngoingAnalysis() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviour',
      'getOngoingAnalysis',
    );

    if (resultString['result'] == -1 || resultString['gemApiError'] != 0) {
      return null;
    }

    return DriverBehaviourAnalysis.init(resultString['result']);
  }

  /// Get the last analysis (most recent created).
  ///
  /// **Returns**
  ///
  /// The last analysis. Use [DriverBehaviourAnalysis.isValid] to check if the analysis is valid.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DriverBehaviourAnalysis? getLastAnalysis() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviour',
      'getLastAnalysis',
    );

    if (resultString['result'] == -1 || resultString['gemApiError'] != 0) {
      return null;
    }

    return DriverBehaviourAnalysis.init(resultString['result']);
  }

  /// Get the instantaneous scores (related to the ongoing analysis).
  ///
  /// **Returns**
  ///
  /// The instantaneous scores.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DrivingScores? getInstantaneousScores() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviour',
      'getInstantaneousScores',
    );

    if (resultString['result'] == -1 || resultString['gemApiError'] != 0) {
      return null;
    }

    return DrivingScores.init(resultString['result']);
  }

  /// Get all driver behavior analysis.
  ///
  /// **Returns**
  ///
  /// A list of all driver behavior analysis.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<DriverBehaviourAnalysis> getAllDriverBehaviourAnalyses() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviour',
      'getAllDriverBehaviourAnalyses',
    );

    final List<dynamic> listJson = resultString['result'];
    final List<DriverBehaviourAnalysis> retList = listJson
        .map(
          (final dynamic behaviourAnalysis) =>
              DriverBehaviourAnalysis.init(behaviourAnalysis),
        )
        .toList();
    return retList;
  }

  /// Get an analysis constructed from all analysis from the specified time period.
  ///
  /// **Parameters**
  ///
  /// * **IN** *startTime* The start time of the period.
  /// * **IN** *endTime* The end time of the period.
  ///
  /// **Returns**
  ///
  /// The combined analysis. Use [DriverBehaviourAnalysis.isValid] to check if the analysis is valid.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DriverBehaviourAnalysis? getCombinedAnalysis(
    DateTime startTime,
    DateTime endTime,
  ) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DriverBehaviour',
      'getCombinedAnalysis',
      args: <String, dynamic>{
        'first': startTime.millisecondsSinceEpoch,
        'second': endTime.millisecondsSinceEpoch,
      },
    );

    if (resultString['result'] == -1 || resultString['gemApiError'] != 0) {
      return null;
    }

    return DriverBehaviourAnalysis.init(resultString['result']);
  }

  /// Erase analysis older than the specified time.
  ///
  /// **Parameters**
  ///
  /// * **IN** *time* The reference time.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void eraseAnalysesOlderThan(DateTime time) {
    objectMethod(
      _pointerId,
      'DriverBehaviour',
      'eraseAnalysesOlderThan',
      args: time.millisecondsSinceEpoch,
    );
  }

  static DriverBehaviour _create(
    final DataSource dataSource,
    final bool useMapMatch,
  ) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, Object>{
        'class': 'DriverBehaviour',
        'dataSource': dataSource.pointerId,
        'useMapMatch': useMapMatch,
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return DriverBehaviour.init(decodedVal['result']);
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, Object>{
        'class': 'DriverBehaviour',
        'id': _pointerId,
      }),
    );
  }
}
