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

import 'package:gem_kit/sense.dart';
import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:gem_kit/src/sense/sense_data_impl.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// Data interruption reason
///
/// {@category Sensor Data Source}
enum DataInterruptionReason {
  /// The reason for the data interruption is unknown.
  unknown,

  /// The sensor that generates the data has stopped operating.
  sensorStopped,

  /// The application has been sent to the background, interrupting data collection.
  appSentToBackground,

  /// The position data source has changed (e.g., from GPS to Network).
  locationProvidersChanged,

  /// The configuration of the sensor has changed.
  sensorConfigurationChanged,

  /// The device orientation has changed, affecting sensor data.
  deviceOrientationChanged,

  /// The sensor is currently in use by another client.
  inUseByAnotherClient,

  /// Data collection is not available due to multiple foreground applications.
  notAvailableWithMultipleForegroundApps,

  /// Data is not available due to system resource pressure.
  notAvailableDueToSystemPressure,

  /// Data collection is not available while the application is in the background.
  notAvailableInBackground,

  /// The audio device is currently in use by another client.
  audioDeviceInUseByAnotherClient,

  /// The video device is currently in use by another client.
  videoDeviceInUseByAnotherClient,
}

/// @nodoc
extension DataInterruptionReasonExtension on DataInterruptionReason {
  static DataInterruptionReason fromId(final int id) {
    switch (id) {
      case 0:
        return DataInterruptionReason.unknown;
      case 1:
        return DataInterruptionReason.sensorStopped;
      case 2:
        return DataInterruptionReason.appSentToBackground;
      case 3:
        return DataInterruptionReason.locationProvidersChanged;
      case 4:
        return DataInterruptionReason.sensorConfigurationChanged;
      case 5:
        return DataInterruptionReason.deviceOrientationChanged;
      case 6:
        return DataInterruptionReason.inUseByAnotherClient;
      case 7:
        return DataInterruptionReason.notAvailableWithMultipleForegroundApps;
      case 8:
        return DataInterruptionReason.notAvailableDueToSystemPressure;
      case 9:
        return DataInterruptionReason.notAvailableInBackground;
      case 10:
        return DataInterruptionReason.audioDeviceInUseByAnotherClient;
      case 11:
        return DataInterruptionReason.videoDeviceInUseByAnotherClient;
      default:
        throw ArgumentError('Invalid id');
    }
  }

  int get id {
    switch (this) {
      case DataInterruptionReason.unknown:
        return 0;
      case DataInterruptionReason.sensorStopped:
        return 1;
      case DataInterruptionReason.appSentToBackground:
        return 2;
      case DataInterruptionReason.locationProvidersChanged:
        return 3;
      case DataInterruptionReason.sensorConfigurationChanged:
        return 4;
      case DataInterruptionReason.deviceOrientationChanged:
        return 5;
      case DataInterruptionReason.inUseByAnotherClient:
        return 6;
      case DataInterruptionReason.notAvailableWithMultipleForegroundApps:
        return 7;
      case DataInterruptionReason.notAvailableDueToSystemPressure:
        return 8;
      case DataInterruptionReason.notAvailableInBackground:
        return 9;
      case DataInterruptionReason.audioDeviceInUseByAnotherClient:
        return 10;
      case DataInterruptionReason.videoDeviceInUseByAnotherClient:
        return 11;
    }
  }
}

/// A listener that receives data from a data source.
///
/// {@category Sensor Data Source}
class DataSourceListener extends EventHandler {
  /// Create a new instance of the [DataSourceListener] instance with the given callbacks.
  ///
  /// **Parameters**
  ///
  /// * **IN** *onPlayingStatusChanged* See [registerOnPlayingStatusChanged] for more information.
  /// * **IN** *onDataInterruptionEvent* See [registerOnDataInterruptionEvent] for more information.
  /// * **IN** *onNewData* See [registerOnNewData] for more information.
  /// * **IN** *onProgressChanged* See [registerOnProgressChanged] for more information.
  factory DataSourceListener({
    final void Function(DataType dataType, PlayingStatus status)?
        onPlayingStatusChanged,
    final void Function(
      DataType dataType,
      DataInterruptionReason reason,
      bool ended,
    )? onDataInterruptionEvent,
    final void Function(SenseData data)? onNewData,
    final void Function(int)? onProgressChanged,
  }) {
    final DataSourceListener listener = DataSourceListener._create();
    if (onPlayingStatusChanged != null) {
      listener.registerOnPlayingStatusChanged(onPlayingStatusChanged);
    }
    if (onDataInterruptionEvent != null) {
      listener.registerOnDataInterruptionEvent(onDataInterruptionEvent);
    }
    if (onNewData != null) {
      listener.registerOnNewData(onNewData);
    }
    if (onProgressChanged != null) {
      listener.registerOnProgressChanged(onProgressChanged);
    }
    return listener;
  }

  @internal
  DataSourceListener.init(this.id);
  void Function(DataType dataType, PlayingStatus status)?
      _onPlayingStatusChanged;
  void Function(DataType dataType, DataInterruptionReason reason, bool ended)?
      _onDataInterruptionEvent;
  void Function(SenseData data)? _onNewData;
  void Function(int)? _onProgressChanged;

  int id;

  /// Register a callback that is called when the playing status of the data source changes.
  ///
  /// **Parameters**
  ///
  /// * **IN** *dataType* The data type.
  /// * **IN** *status* The new playing status.
  void registerOnPlayingStatusChanged(
    final void Function(DataType dataType, PlayingStatus status)
        onPlayingStatusChanged,
  ) {
    _onPlayingStatusChanged = onPlayingStatusChanged;
  }

  /// Register a callback that is called when data is no longer available.
  ///
  /// **Parameters**
  ///
  /// * **IN** *dataType* The data type.
  /// * **IN** *reason* The reason for the data interruption.
  /// * **IN** *ended* Whether the data interruption has ended.
  void registerOnDataInterruptionEvent(
    final void Function(
      DataType dataType,
      DataInterruptionReason reason,
      bool ended,
    ) onDataInterruptionEvent,
  ) {
    _onDataInterruptionEvent = onDataInterruptionEvent;
  }

  /// Register a callback that is called when new data is available.
  ///
  /// **Parameters**
  ///
  /// * **IN** *data* The new data.
  void registerOnNewData(final void Function(SenseData data) onNewData) {
    _onNewData = onNewData;
  }

  /// Register a callback that is called when the progress of the data source changes.
  ///
  /// **Parameters**
  ///
  /// * **IN** *progress* The new progress.
  void registerOnProgressChanged(
    final void Function(int progress) onProgressChanged,
  ) {
    _onProgressChanged = onProgressChanged;
  }

  static DataSourceListener _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, Object>{
        'class': 'DataSourceListener',
        'args': <String, dynamic>{},
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return DataSourceListener.init(decodedVal['result']);
  }

  @override
  void dispose() {
    GemKitPlatform.instance.callObjectMethod(
      jsonEncode(<String, Object>{
        'id': 0,
        'class': 'LandmarkStoreService',
        'method': 'removeListener',
        'args': id,
      }),
    );
  }

  @override
  void handleEvent(final Map<dynamic, dynamic> arguments) {
    final String eventSubtype = arguments['event_subtype'];

    switch (eventSubtype) {
      case 'onPlayingStatusChanged':
        if (_onPlayingStatusChanged != null) {
          _onPlayingStatusChanged!(
            DataTypeExtension.fromId(arguments['type']),
            PlayingStatus.values[arguments['status']],
          );
        }
      case 'onDataInterruptionEvent':
        if (_onDataInterruptionEvent != null) {
          _onDataInterruptionEvent!(
            DataTypeExtension.fromId(arguments['type']),
            DataInterruptionReasonExtension.fromId(arguments['reason']),
            arguments['ended'],
          );
        }
      case 'onNewData':
        if (_onNewData != null) {
          _onNewData!(senseFromJson(arguments['data']));
        }
      case 'onProgressChanged':
        if (_onProgressChanged != null) {
          _onProgressChanged!(arguments['progress']);
        }
      default:
        gemSdkLogger.log(
          Level.WARNING,
          'Unknown event subtype: ${arguments['eventType']} in DataSourceListener',
        );
    }
  }
}
