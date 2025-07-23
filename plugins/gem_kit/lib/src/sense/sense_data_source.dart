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
import 'package:gem_kit/sense.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/sense/sense_data_impl.dart';

/// External position data
///
/// {@category Sensor Data Source}
@Deprecated('Use SenseDataFactory.positionFromExternalData() method instead.')
class ExternalPositionData {
  @Deprecated('Use SenseDataFactory.positionFromExternalData() method instead.')
  ExternalPositionData({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.heading,
    required this.speed,
  });

  @Deprecated('Use SenseDataFactory.positionFromExternalData() method instead.')
  factory ExternalPositionData.fromJson(final Map<String, dynamic> json) {
    return ExternalPositionData(
      timestamp: json['timestamp'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      altitude: json['altitude'],
      heading: json['heading'],
      speed: json['speed'],
    );
  }

  /// Timestamp in milliseconds
  final int timestamp;

  /// Latitude
  final double latitude;

  /// Longitude
  final double longitude;

  /// Altitude (m)
  final double altitude;

  /// Heading (degrees east of north)
  final double heading;

  /// Speed (m/s)
  final double speed;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'timestamp': timestamp,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'heading': heading,
      'speed': speed,
    };
  }

  @override
  bool operator ==(covariant final ExternalPositionData other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return timestamp == other.timestamp &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        altitude == other.altitude &&
        heading == other.heading &&
        speed == other.speed;
  }

  @override
  int get hashCode {
    return Object.hash(
      timestamp,
      latitude,
      longitude,
      altitude,
      heading,
      speed,
    );
  }
}

/// SensorDataSource
///
/// Through this interface data can be obtained from sensors, log files or any other means
///
/// {@category Sensor Data Source}
class DataSource extends GemAutoreleaseObject {
  // ignore: unused_element
  DataSource._() : _pointerId = -1;

  DataSource.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Create a new external data source
  ///
  /// **Parameters**
  ///
  /// * **IN** *dataTypes* List of available data types for this data source. It is mandatory to provide [DataType.position] within the [dataTypes] list.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static DataSource? createExternalDataSource(final List<DataType> dataTypes) {
    final List<int> intList =
        dataTypes.map((final DataType dataType) => dataType.id).toList();
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, Object>{
        'class': 'DataSourceContainer',
        'args': <String, Object>{
          'availableDataType': intList,
          'type': 'external',
        },
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);

    final int gemApiError = decodedVal['gemApiError'];

    if (GemErrorExtension.isErrorCode(gemApiError)) {
      return null;
    }

    final DataSource retVal = DataSource.init(decodedVal['result']);
    return retVal;
  }

  /// Create a new live data source
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static DataSource? createLiveDataSource() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, Object>{
        'class': 'DataSourceContainer',
        'args': <String, String>{'type': 'live'},
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);

    final int gemApiError = decodedVal['gemApiError'];

    if (GemErrorExtension.isErrorCode(gemApiError)) {
      return null;
    }

    final DataSource retVal = DataSource.init(decodedVal['result']);
    return retVal;
  }

  /// Create a new log data source based on a log file
  ///
  /// **Parameters**
  ///
  /// * **IN** *logPath* The log file path. The log file should not be a `.gm` file. Other formats such as `.gpx` are supported.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static DataSource? createLogDataSource(final String logPath) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, Object>{
        'class': 'DataSourceContainer',
        'args': <String, String>{'type': 'log', 'path': logPath},
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);

    final int gemApiError = decodedVal['gemApiError'];

    if (GemErrorExtension.isErrorCode(gemApiError)) {
      return null;
    }

    final DataSource retVal = DataSource.init(decodedVal['result']);
    return retVal;
  }

  /// Create a data source based on a route (a route simulation data source).
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route used for generating data source data.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static DataSource? createSimulationDataSource(final Route route) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, Object>{
        'class': 'DataSourceContainer',
        'args': <String, dynamic>{
          'type': 'simulation',
          'routeId': route.pointerId,
        },
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);

    final int gemApiError = decodedVal['gemApiError'];

    if (GemErrorExtension.isErrorCode(gemApiError)) {
      return null;
    }

    final DataSource retVal = DataSource.init(decodedVal['result']);
    return retVal;
  }

  /// Start the source
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * Other [GemError] values on failure
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError start() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'start',
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Stop the source
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * Other [GemError] values on failure
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError stop() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'stop',
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Check if source is paused
  ///
  /// **Returns**
  ///
  /// * True if stopped, false if not.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get isStopped {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'isStopped',
    );

    return resultString['result'];
  }

  /// The data source type. It can be live or playback.
  ///
  /// **Returns**
  ///
  /// * [DataSourceType] The data source type.
  ///
  /// Will return [DataSourceType.live] if the data source is live or external, [DataSourceType.playback] if the data source is playback or simulate.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  DataSourceType get dataSourceType {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'getDataSourceType',
    );

    return DataSourceTypeExtension.fromId(resultString['result']);
  }

  /// Test if a data type is provided by the data source.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* The data type.
  ///
  /// **Returns**
  ///
  /// * True if the data type is available, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool isDataTypeAvailable(final DataType dataType) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'isDataTypeAvailable',
      args: dataType.id,
    );

    return resultString['result'];
  }

  /// The data type description
  ///
  /// If data source produces such a data type then it returns a description, otherwise it returns an empty string.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* The data type for which the description is requested.
  ///
  /// **Returns**
  ///
  /// * [String] The description of the data type.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  String getDataTypeDescription(final DataType type) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'getDataTypeDescription',
      args: type.id,
    );

    return resultString['result'];
  }

  /// The available data types.
  ///
  /// **Returns**
  ///
  /// * [List<DataType>] The available data types.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  List<DataType> get availableDataTypes {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'getAvailableDataTypes',
    );

    final List<int> rawEnumValues = List<int>.from(resultString['result']);
    return rawEnumValues
        .map((final int id) => DataTypeExtension.fromId(id))
        .toList();
  }

  /// If data source produces such a data type then it returns a shared data pointer, otherwise it returns an empty shared pointer.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* The data type for which the data is requested.
  ///
  /// **Returns**
  ///
  /// * [SenseData] The latest produced data.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  SenseData? getLatestData(final DataType type) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'getLatestData',
      args: type.id,
    );

    final dynamic result = resultString['result'];
    if (result != null) {
      return senseFromJson(result);
    } else {
      return null;
    }
  }

  /// Update the configuration for the specified type.
  ///
  /// Only relevant for [DataType.position] data type for now.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* The data type for which the configuration will be set.
  /// * **IN** *config* The configuration to be applied.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError setConfiguration({
    final DataType type = DataType.position,
    required final PositionSensorConfiguration config,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'setConfiguration',
      args: <String, Object>{'type': type.id, 'config': config.toJson()},
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Provide access to the current configuration specified to that data type.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* The data type for which the configuration will be returned.
  ///
  /// **Returns**
  ///
  /// * The configuration as [SensorConfiguration].
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  PositionSensorConfiguration getConfiguration(final DataType type) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'getConfiguration',
      args: type.id,
    );

    final dynamic result = resultString['result'];

    final Map<String, String> configMap = <String, String>{};
    for (final dynamic entry in result.entries) {
      final dynamic key = entry.key;
      final dynamic value = entry.value;
      configMap[key] = value as String;
    }
    return PositionSensorConfiguration.fromJson(configMap);
  }

  /// Provide access to the current configuration specified to that data type.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* The data type for which the preferences will be returned.
  ///
  /// **Returns**
  ///
  /// * The configuration as [SearchableParameterList].
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  SearchableParameterList getPreferences(final DataType type) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'getPreferences',
      args: type.id,
    );

    return SearchableParameterList.init(resultString['result']);
  }

  /// The origin of the data source
  ///
  /// **Returns**
  ///
  /// * The origin of the data source
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  Origin get origin {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'getOrigin',
    );

    return OriginExtension.fromId(resultString['result']);
  }

  /// Get the playback interface
  ///
  /// **Returns**
  ///
  /// * The playback listener object if available
  /// * If the data source has no playback capabilities then null is returned.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  Playback? get playback {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'getPlayback',
    );

    if (GemErrorExtension.isErrorCode(resultString['result'])) {
      return null;
    }
    return Playback.init(resultString['result']);
  }

  /// Set mock position data
  ///
  /// Can be used to set custom data in a live data source. Not relevant for other types of data sources.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* The data type to be set
  /// * **IN** *senseData* The data type for which the data is requested.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.notSupported] if the data source does not support mock data (it is not live) or if *type* is not [DataType.position].
  /// * Other [GemError] values on failure
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError setMockData(final DataType type, final SenseData senseData) {
    if (senseData is! SenseDataImpl) {
      return GemError.invalidInput;
    }

    if (senseData.type != type) {
      return GemError.notSupported;
    }

    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'setMockData',
      args: <String, Object>{'type': type.id, 'data': senseData.toJson()},
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Check if mock data is enabled for the given type
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* Type of the data.
  ///
  /// **Returns**
  ///
  /// * True if the data is mocked, false otherwise.f
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool isMockData(final DataType type) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'isMockData',
      args: type.id,
    );

    return resultString['result'];
  }

  /// Test if this is an SDK instance
  ///
  /// **Returns**
  ///
  /// * True if the interface is an SDK instance, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get isSDKInstance {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'isSDKInstance',
    );

    return resultString['result'];
  }

  /// Push the data
  ///
  /// The data source might do some processing on the data.
  /// As a result, the data might be modified when the [getLatestData] method is called or
  /// when a listener callback is triggered.
  ///
  /// Calling this method in quick succession might ignore some calls.
  ///
  /// **Parameters**
  ///
  /// * **IN** *accelerationData* The external acceleration data
  /// * **IN** *positionData* The external position data
  ///
  /// **Returns**
  ///
  /// * True if the push data type is available, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool pushData(final SenseData senseData) {
    if (senseData is! SenseDataImpl) {
      return false;
    }
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'pushData',
      args: senseData.toJson(),
    );

    return resultString['result'];
  }

  /// Register a listener for the data source
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener* The listener to be registered
  /// * **IN** *dataType* The data type for which the listener will be registered
  /// * **IN** *parameters* Optional list of parameters
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, other [GemError] values on failure
  /// * [GemError.invalidInput] if data type is not available. See [isDataTypeAvailable] to check availability for the desired data type.
  ///
  /// While [DataType.improvedPosition] may not always be available, it is expected to function correctly when used.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError addListener({
    required final DataSourceListener listener,
    required final DataType dataType,
    final ParameterList? parameters,
  }) {
    GemKitPlatform.instance.registerEventHandler(listener.id, listener);
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'addListener',
      args: <String, dynamic>{
        'listener': listener.id,
        'datatype': dataType.id,
        if (parameters != null) 'preferences': parameters.pointerId,
      },
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Unregister a listener for the data source for a specific data type
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener* The listener to be unregistered
  /// * **IN** *dataType* The data type for which the listener will be unregistered
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, other [GemError] values on failure.
  /// * [GemError.invalidInput] if no listener was  previously added for the specified data type.
  /// * [GemError.notFound] if the listener was not previously for the specified data type.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError removeListener({
    required final DataSourceListener listener,
    required final DataType dataType,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'DataSourceContainer',
      'removeListener',
      args: <String, int>{'listener': listener.id, 'datatype': dataType.id},
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Unregister all listeners for the data source for all data types
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener* The listener to be unregistered
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void removeListenerAllDataTypes(final DataSourceListener listener) {
    GemKitPlatform.instance.unregisterEventHandler(listener.id);

    objectMethod(
      _pointerId,
      'DataSourceContainer',
      'removeListenerAll',
      args: listener.id,
    );
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, Object>{
        'class': 'DataSourceContainer',
        'id': _pointerId,
      }),
    );
  }
}

/// Represents the operations that can be performed on a
/// [DataSource] which has playback capabilities (e.g. log, route replay)
///
/// {@category Sensor Data Source}
class Playback extends GemAutoreleaseObject {
  // ignore: unused_element
  Playback._() : _pointerId = -1;

  Playback.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  /// Pause the playback.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.engineNotInitialized] if the datasource is not available
  /// * [GemError.upToDate] if the pause failed
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError pause() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PlaybackContainer',
      'pause',
    );
    final int retVal = resultString['result'];
    return GemErrorExtension.fromCode(retVal);
  }

  /// Resume the playback.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.engineNotInitialized] if the datasource is not available
  /// * [GemError.upToDate] if the resume failed
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError resume() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PlaybackContainer',
      'resume',
    );
    final int retVal = resultString['result'];
    return GemErrorExtension.fromCode(retVal);
  }

  /// Step to the next frame.
  ///
  /// Only available for data sources that contain video.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void step() {
    objectMethod(_pointerId, 'PlaybackContainer', 'step');
  }

  /// Return the playback state of this data source.
  ///
  /// **Returns**
  ///
  /// * [PlayingStatus] the status of the data source
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  PlayingStatus get state {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PlaybackContainer',
      'getState',
    );
    final int retVal = resultString['result'];
    return PlayingStatusExtension.fromId(retVal);
  }

  /// Get the speed multiplier.
  ///
  /// Relevant for route based data source
  ///
  /// **Returns**
  ///
  /// * The current speed multiplier
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  double get speedMultiplier {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PlaybackContainer',
      'getSpeedMultiplier',
    );
    return resultString['result'];
  }

  /// Sets the speed multiplier.
  ///
  /// Relevant for route based data source
  ///
  /// **Parameters**
  ///
  /// * **IN** *speedMultiplier* the new speed multiplier
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError setSpeedMultiplier(final double speedMultiplier) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PlaybackContainer',
      'setSpeedMultiplier',
      args: speedMultiplier,
    );
    final int retVal = resultString['result'];
    return GemErrorExtension.fromCode(retVal);
  }

  /// Gets the maximum speed multiplier.
  ///
  /// Relevant for route based data source
  ///
  /// **Returns**
  ///
  /// * The maximum speed multiplier
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  double get maxSpeedMultiplier {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PlaybackContainer',
      'getMaxSpeedMultiplier',
    );
    return resultString['result'];
  }

  /// Gets the minimum speed multiplier.
  ///
  /// Relevant for route based data source
  ///
  /// **Returns**
  ///
  /// * The minimum speed multiplier
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  double get minSpeedMultiplier {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PlaybackContainer',
      'getMinSpeedMultiplier',
    );
    return resultString['result'];
  }

  /// Return the current position (milliseconds from begin/departure/starting point).
  ///
  /// **Returns**
  ///
  /// * The playback position in milliseconds.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get currentPosition {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PlaybackContainer',
      'getCurrentPosition',
    );
    return resultString['result'];
  }

  /// Sets the current position (milliseconds from begin/departure/starting point).
  ///
  /// **Parameters**
  ///
  /// * **IN** *newPosition* The new position to be set
  ///
  /// **Returns**
  ///
  /// * The old playback position in milliseconds.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int setCurrentPosition(final int newPosition) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PlaybackContainer',
      'setCurrentPosition',
      args: newPosition,
    );
    return resultString['result'];
  }

  /// The duration of the playback in milliseconds.
  ///
  /// **Returns**
  ///
  /// * The duration of the playback in milliseconds.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get duration {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PlaybackContainer',
      'getDuration',
    );
    return resultString['result'];
  }

  /// Sets play log continuously.
  ///
  /// **Parameters**
  ///
  /// * **IN** *loopMode* The actual value to be set for loop mode.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError setLoopMode(final bool loopMode) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PlaybackContainer',
      'setLoopMode',
      args: loopMode,
    );
    final int retVal = resultString['result'];
    return GemErrorExtension.fromCode(retVal);
  }

  /// The latest data from the [DataSource].
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* The type for which to get the sense data
  ///
  /// **Returns**
  ///
  /// * The [SenseData] object if it exists, otherwise false.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  SenseData? getLatestData(final DataType type) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PlaybackContainer',
      'getLatestPlaybackData',
      args: type.id,
    );

    final dynamic result = resultString['result'];
    if (result != null) {
      return senseFromJson(result);
    } else {
      return null;
    }
  }

  /// Get the log path.
  ///
  /// **Returns**
  ///
  /// * The log path.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  String get logPath {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PlaybackContainer',
      'getLogPath',
    );
    return resultString['result'];
  }

  /// Get the route if it is a simulation data source.
  ///
  /// **Returns**
  ///
  /// * The route on which the navigation in running
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  Route? get route {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'PlaybackContainer',
      'getRoute',
    );
    final int retVal = resultString['result'];
    if (retVal == -1) {
      return null;
    }
    return Route.init(retVal);
  }
}
