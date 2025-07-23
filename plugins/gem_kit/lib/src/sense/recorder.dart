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

import 'package:gem_kit/sense.dart';
import 'package:gem_kit/src/core/coordinates.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/routing/routing_preferences.dart';

/// Structure describing recorder configuration properties.
///
/// {@category Sensor Data Source}
class RecorderConfiguration {
  RecorderConfiguration({
    required this.dataSource,
    this.logsDir = '',
    @Deprecated('Use hardwareSpecifications instead.') String deviceModel = '',
    Map<HardwareSpecification, String>? hardwareSpecifications,
    this.recordedTypes = const <DataType>[],
    this.minDurationSeconds = 30,
    this.videoQuality = Resolution.unknown,
    this.chunkDurationSeconds = 600,
    this.continuousRecording = true,
    this.enableAudio = false,
    this.maxDiskSpaceUsed = 0,
    this.keepMinSeconds = 0,
    this.deleteOlderThanKeepMin = false,
    this.transportMode = RecordingTransportMode.unknown,
  }) {
    this.hardwareSpecifications =
        hardwareSpecifications ?? <HardwareSpecification, String>{};
    if (deviceModel.isNotEmpty) {
      this.hardwareSpecifications[HardwareSpecification.deviceModel] =
          deviceModel;
    }
  }

  factory RecorderConfiguration.fromJson(final Map<String, dynamic> json) {
    final Map<String, dynamic> hardwareSpecificationsAsString =
        jsonDecode(json['hardwareSpecifications']) ?? <String, dynamic>{};

    final Map<HardwareSpecification, String> hardwareSpecifications =
        <HardwareSpecification, String>{};
    for (final HardwareSpecification spec in HardwareSpecification.values) {
      if (!hardwareSpecificationsAsString.containsKey(spec.id.toString())) {
        continue;
      }
      hardwareSpecifications[spec] =
          hardwareSpecificationsAsString[spec.id.toString()] ?? '';
    }

    return RecorderConfiguration(
      logsDir: json['logsDir'] ?? '',
      dataSource: DataSource.init(json['dataSource']),
      hardwareSpecifications: hardwareSpecifications,
      recordedTypes: json['recordedTypes'] != null
          ? (json['recordedTypes'] as List<dynamic>)
              .map(
                (final dynamic item) => DataType.values.firstWhere(
                  (final DataType e) => e.id == item,
                ),
              )
              .toList()
          : <DataType>[],
      minDurationSeconds: json['minDurationSeconds'] ?? 30,
      videoQuality: ResolutionExtension.fromId(
        json['videoQuality'] ?? Resolution.unknown.id,
      ),
      chunkDurationSeconds: json['chunkDurationSeconds'] ?? 3600,
      continuousRecording: json['bContinuousRecording'] ?? true,
      enableAudio: json['bEnableAudio'] ?? false,
      maxDiskSpaceUsed: json['maxDiskSpaceUsed'] ?? 0,
      keepMinSeconds: json['keepMinSeconds'] ?? 0,
      deleteOlderThanKeepMin: json['deleteOlderThanKeepMin'] ?? false,
      transportMode: json['transportMode'] != null
          ? RecordingTransportMode.values.firstWhere(
              (final RecordingTransportMode e) => e.id == json['transportMode'],
            )
          : RecordingTransportMode.unknown,
    );
  }

  /// The data source used for recording.
  ///
  /// This defines the source providing the data to be recorded.
  DataSource dataSource;

  /// The directory used to keep the logs.
  ///
  /// This is an absolute path.
  String logsDir;

  /// The device model
  ///
  /// Provides metadata about the hardware used for the recording.
  @Deprecated('Use hardwareSpecifications instead.')
  String get deviceModel =>
      hardwareSpecifications[HardwareSpecification.deviceModel] ?? '';

  /// The device model
  ///
  /// Provides metadata about the hardware used for the recording.
  @Deprecated('Use hardwareSpecifications instead.')
  set deviceModel(String model) =>
      hardwareSpecifications[HardwareSpecification.deviceModel] = model;

  /// The device hardware specifications
  ///
  /// This map stores key-value pairs representing hardware-related metadata
  /// collected at the time of the recording. These details are useful for
  /// debugging, performance analysis, and device compatibility tracking.
  /// Keys are defined by the [HardwareSpecification] enum.
  late Map<HardwareSpecification, String> hardwareSpecifications;

  /// The types that are recorded.
  ///
  /// If one or more of the specified types are not produced by the data source, the recording will not start.
  List<DataType> recordedTypes;

  /// The chunk duration time in seconds
  ///
  /// Default value is `0`. If set to 0, the recording will not be split into chunks.
  ///
  ///  When the duration is reached, the recording stops. If [continuousRecording] is set to `true`, a new recording starts automatically.
  int chunkDurationSeconds;

  /// The minimum recording duration for it to be saved.
  ///
  /// The default value is `30` seconds.  If the recording is shorter than this duration it will be discarded.
  int minDurationSeconds;

  ///  The video quality of the recording.
  ///
  ///  Determines the resolution of recorded video (e.g., SD, HD, FullHD). If set to [Resolution.unknown] and [DataType.camera] is requested, video recording will not proceed.
  Resolution videoQuality;

  /// Whether the recording should continue automatically after reaching the chunk duration.
  ///
  /// If `true`, a new recording will start automatically when the current chunk ends.
  bool continuousRecording;

  /// Flag indicating whether audio should be recorded.
  ///
  /// If `true`, an audio track is created during the recording setup. Audio recording can then be controlled using:
  /// - `StartAudioRecording()`: Starts recording audio segments.
  /// - `StopAudioRecording()`: Suspends audio recording if a recording session is active and audio is enabled.
  ///
  /// This allows flexibility in recording audio in specific portions of the recording session.
  bool enableAudio;

  /// Maximum disk space that recordings can occupy.
  ///
  /// Specifies the maximum total size (in bytes) that all recordings can occupy on disk. When this limit is reached, recording stops to prevent exceeding the specified space.
  ///
  /// Ex: 100 * 1024*1024 = 100 MB. All logs will not occupy more than this.
  ///
  /// **Special Behavior**
  ///
  /// If set to `0`, no disk space checks are performed, and recordings will continue without considering available disk space.
  ///
  /// The default value is `0` (ignore disk limit).
  int maxDiskSpaceUsed;

  /// Minimum seconds of recordings to retain on disk.
  ///
  /// After the threshold is reached the oldest recording will be deleted if there is no space left on the device.
  ///
  /// To force deletion regardless of space, set [deleteOlderThanKeepMin] to `true`.
  ///
  /// The default value is `0` (keep all recordings).
  int keepMinSeconds;

  /// Flag to delete older logs exceeding the [keepMinSeconds] threshold.
  ///
  ///  If `true`, older logs will be deleted even if there is sufficient disk space.
  ///
  /// The default value is `false`.
  bool deleteOlderThanKeepMin;

  /// The transport mode used at the time the log was recorded.
  ///
  /// The default value is [RecordingTransportMode.unknown] indicating that the transport mode was not set.
  RecordingTransportMode transportMode;

  Map<String, dynamic> toJson() {
    final Map<String, String> hardwareSpecificationsAsString =
        <String, String>{};
    for (final HardwareSpecification spec in hardwareSpecifications.keys) {
      hardwareSpecificationsAsString[spec.id.toString()] =
          hardwareSpecifications[spec] ?? '';
    }

    final Map<String, dynamic> json = <String, dynamic>{};
    json['logsDir'] = logsDir;
    json['dataSource'] = dataSource.pointerId;
    json['hardwareSpecifications'] = jsonEncode(hardwareSpecificationsAsString);
    json['recordedTypes'] =
        recordedTypes.map((final DataType type) => type.id).toList();
    json['minDurationSeconds'] = minDurationSeconds;
    json['videoQuality'] = videoQuality.id;
    json['chunkDurationSeconds'] = chunkDurationSeconds;
    json['bContinuousRecording'] = continuousRecording;
    json['bEnableAudio'] = enableAudio;
    json['maxDiskSpaceUsed'] = maxDiskSpaceUsed;
    json['keepMinSeconds'] = keepMinSeconds;
    json['deleteOlderThanKeepMin'] = deleteOlderThanKeepMin;
    json['transportMode'] = transportMode.id;
    return json;
  }
}

/// Recorder class
///
/// This class should not be instantiated directly. Instead, use the [create] method to obtain an instance.
///
/// {@category Sensor Data Source}
class Recorder extends GemAutoreleaseObject {
  // ignore: unused_element
  Recorder._() : _pointerId = -1;

  Recorder.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Creates a new instance of the [Recorder].
  ///
  /// This method initializes a recorder instance using the provided [config].
  ///
  /// **Record while in background mode**
  ///
  /// If using permission package, ensure that the location permission is granted using await Permission.locationAlways
  /// If the recorder needs to function while the app is in the background,
  /// ensure that background location updates are enabled as follows:
  ///
  /// ```dart
  /// final posSensor = dataSource!.getConfiguration(DataType.position);
  /// posSensor.allowsBackgroundLocationUpdates = true;
  /// dataSource.setConfiguration(type: DataType.position, config: posSensor);
  /// ```
  ///
  /// Also make sure the `Info.plist` and the `AndroidManifest.xml` files are updated accordingly.
  ///
  /// **Parameters**
  ///
  /// - **IN** **config**: The recorder configuration.
  ///
  /// **Returns**
  ///
  /// - A new instance of [Recorder].
  ///
  /// **Throws**
  ///
  /// An exception if the recorder instance cannot be created.
  static Recorder create(final RecorderConfiguration config) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, Object>{'class': 'Recorder', 'args': config}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return Recorder.init(decodedVal['result']);
  }

  /// Starts the recording.
  ///
  /// Initiates the recording process and transitions the recorder status to [RecorderStatus.starting] first.
  /// If the start is successful, the status will change to [RecorderStatus.recording]. A notification is issued upon successful start.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] Successfully transitioned to the [RecorderStatus.recording] state.
  /// * [GemError.busy] The recorder could not transition to [RecorderStatus.starting] because it is busy with another operation.
  /// * [GemError.invalidInput] The recorder configuration is invalid.
  /// * [GemError.noDiskSpace] Insufficient disk space available to start the recording.
  /// * [GemError.overheated] The device temperature is too high to start the recording.
  /// * [GemError.general] A general error occurred while attempting to stop the recording.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Future<GemError> startRecording() async {
    final String? resultString = await GemKitPlatform.instance
        .getChannel(mapId: -1)
        .invokeMethod<String>(
          'callObjectMethod',
          jsonEncode(<String, Object>{
            'id': _pointerId,
            'class': 'Recorder',
            'method': 'startRecording',
            'args': <dynamic, dynamic>{},
          }),
        );
    return GemErrorExtension.fromCode(jsonDecode(resultString!)['result']);
  }

  /// Stops the recording.
  ///
  /// Stops the recording process and transitions the recorder status to [RecorderStatus.stopping] first. If the stop is successful (i.e., the recording duration meets the [RecorderConfiguration.minDurationSeconds]), the status will change to [RecorderStatus.stopped]. A notification is issued upon successful stop.
  ///
  /// If [RecorderConfiguration.continuousRecording] is set to `true` and the recording reaches the chunk duration,
  /// the status will transition to [RecorderStatus.restarting] instead of [RecorderStatus.stopped], and a new recording session will begin automatically.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] Successfully transitioned to the [RecorderStatus.stopped] or [RecorderStatus.restarting] state.
  /// * [GemError.recordedLogTooShort] If the recorded log duration is shorter than the [RecorderConfiguration.minDurationSeconds] set in recorder configuration.
  /// * [GemError.busy] The recorder could not transition to [RecorderStatus.stopping] because it is busy with another operation.
  /// * [GemError.general] A general error occurred while attempting to stop the recording.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  Future<GemError> stopRecording() async {
    final String? resultString = await GemKitPlatform.instance
        .getChannel(mapId: -1)
        .invokeMethod<String>(
          'callObjectMethod',
          jsonEncode(<String, Object>{
            'id': _pointerId,
            'class': 'Recorder',
            'method': 'stopRecording',
            'args': <dynamic, dynamic>{},
          }),
        );
    return GemErrorExtension.fromCode(jsonDecode(resultString!)['result']);
  }

  /// Pauses the recording.
  ///
  /// Initiates the process of pausing the recording and transitions the recorder status to [RecorderStatus.pausing] first.
  /// If the pause operation is successful, the status will change to [RecorderStatus.paused]. A notification is issued upon successful pause.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] If successfully moved to [RecorderStatus.paused] status.
  /// * [GemError.busy] The recorder could not transition to [RecorderStatus.pausing] because it is busy with another operation.
  /// * [GemError.general] A general error occurred while attempting to pause the recording.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError pauseRecording() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Recorder',
      'pauseRecording',
    );
    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Resumes the recording.
  ///
  /// Initiates the process of resuming the recording and transitions the recorder status to [RecorderStatus.resuming] first.
  /// If the resume operation is successful, the status will change back to [RecorderStatus.recording]. A notification is issued upon successful resume.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] Successfully transitioned to the [RecorderStatus.recording] state.
  /// * [GemError.busy] The recorder could not transition to [RecorderStatus.resuming] because it is busy with another operation.
  /// * [GemError.general]  A general error occurred while attempting to resume the recording.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError resumeRecording() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Recorder',
      'resumeRecording',
    );
    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Starts audio recording.
  ///
  /// Resumes audio recording only if a recording is currently active and audio recording is enabled, [RecorderConfiguration.enableAudio] in the recorder configuration.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void startAudioRecording() {
    objectMethod(_pointerId, 'Recorder', 'startAudioRecording');
  }

  /// Stops audio recording.
  ///
  /// Suspends audio recording only if a recording is currently active and audio recording is enabled, [RecorderConfiguration.enableAudio] in the recorder configuration.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void stopAudioRecording() {
    objectMethod(_pointerId, 'Recorder', 'stopAudioRecording');
  }

  /// Checks if audio recording is in progress.
  ///
  /// **Returns**
  ///
  /// * True if audio recording is in progress, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool isAudioRecording() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Recorder',
      'isAudioRecording',
    );
    return resultString['result'];
  }

  /// Retrieves the current configuration of the recorder.
  ///
  /// **Returns**
  ///
  /// *  A [RecorderConfiguration] containing the current configuration settings of the recorder.
  ///
  /// This method provides access to the current configuration used by the recorder. The returned configuration reflects the parameters set during initialization or any subsequent modifications made via recorderConfiguration setter. This can be useful for verifying the recorder's setup or for debugging purposes.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  RecorderConfiguration get recorderConfiguration {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Recorder',
      'getConfiguration',
    );

    return RecorderConfiguration.fromJson(resultString['result']);
  }

  /// Updates the recorder settings.
  ///
  /// If it is started, first stops the recorder, updates its settings and restarts it.
  ///
  /// **Parameters**
  ///
  /// * **IN** *config* The recorder configuration
  ///
  /// **Returns**
  ///
  /// * [GemError.success] Successfully updated the configuration.
  /// * [GemError.busy]  Could not update the configuration because the recorder was active.
  /// * [GemError.general] A general error occurred during configuration update.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError setRecorderConfiguration(final RecorderConfiguration config) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Recorder',
      'setConfiguration',
      args: config,
    );
    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Retrieves the current recorder status.
  ///
  /// **Returns**
  ///
  /// * The current status as an [RecorderStatus] value
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  RecorderStatus get recorderStatus {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Recorder',
      'getStatus',
    );
    return RecorderStatusExtension.fromId(resultString['result']);
  }

  /// Gets the path to the current log file.
  ///
  /// **Returns**
  ///
  /// * The path to the current log file.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  String get currentRecordPath {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Recorder',
      'getCurrentRecordPath',
    );
    return resultString['result'];
  }

  /// Gets the disk space used per second, in bytes.
  ///
  /// **Returns**
  ///
  /// * The disk space, in bytes, used for 1 second.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get diskSpaceUsedPerSecond {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Recorder',
      'diskSpaceUsedPerSecond',
    );
    return resultString['result'];
  }

  /// Sets the details of the recorded activity.
  ///
  /// Call this method before stopping the record.
  ///
  /// **Parameters**
  ///
  /// * **IN** *activityRecord* An [ActivityRecord] object containing the details of the activity to be set.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  @Deprecated('Use activityRecord setter instead')
  void setActivityRecord(final ActivityRecord activityRecord) {
    objectMethod(
      _pointerId,
      'Recorder',
      'setActivityRecord',
      args: activityRecord,
    );
  }

  /// Sets the details of the recorded activity.
  ///
  /// Call this method before stopping the record.
  ///
  /// **Parameters**
  ///
  /// * **IN** *activityRecord* An [ActivityRecord] object containing the details of the activity to be set.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  set activityRecord(final ActivityRecord activityRecord) {
    objectMethod(
      _pointerId,
      'Recorder',
      'setActivityRecord',
      args: activityRecord,
    );
  }

  /// Adds a textual annotation (text mark) at the current position in the log.
  ///
  /// Call this method before stopping the record.
  ///
  /// **Parameters**
  ///
  /// * **IN** *text* The text content of the annotation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void addTextMark(final String text) {
    objectMethod(
      _pointerId,
      'Recorder',
      'addTextMark',
      args: text,
    );
  }

  /// Saves custom metadata in the log.
  ///
  /// This method allows adding a user-defined key-value pair to the log metadata. The key is a string identifier, and the value is a buffer ([Uint8List] value) containing the associated data. This method must be called before stopping the recording to ensure the metadata is saved in the final log.
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* The key of the user metadata.
  /// * **IN** *userMetata* The buffer to be recorded.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void addUserMetadata(final String key, final Uint8List userMetadata) {
    final dynamic dataBufferPointer =
        GemKitPlatform.instance.toNativePointer(userMetadata);
    objectMethod(
      _pointerId,
      'Recorder',
      'addUserMetadata',
      args: <String, dynamic>{
        'key': key,
        'dataBuffer': dataBufferPointer.address,
        'dataBufferSize': userMetadata.length,
      },
    );

    GemKitPlatform.instance.freeNativePointer(dataBufferPointer);
  }

  /// Adds a listener to monitor recording progress.
  ///
  /// **Parameters**
  ///
  /// * **IN** *onComplete* The listener to register.
  ///
  /// **Returns**
  ///
  /// * The operation handler if the operation could be started, null otherwise
  EventHandler? addListener({
    final void Function(GemError error)? onComplete,
    final void Function(RecorderStatus status)? onStatusChanged,
  }) {
    EventDrivenProgressListener? listener;
    if (onComplete != null || onStatusChanged != null) {
      listener = EventDrivenProgressListener();

      if (onComplete != null) {
        listener.registerOnCompleteWithDataCallback((
          final int err,
          final String hint,
          final Map<dynamic, dynamic> json,
        ) {
          GemKitPlatform.instance.unregisterEventHandler(listener!.id);
          onComplete(GemErrorExtension.fromCode(err));
        });
      }

      if (onStatusChanged != null) {
        listener.registerOnNotifyStatusChanged((final int status) {
          onStatusChanged(RecorderStatusExtension.fromId(status));
        });
      }

      GemKitPlatform.instance.registerEventHandler(listener.id, listener);
    }

    final OperationResult resultString = objectMethod(
      _pointerId,
      'Recorder',
      'addListener',
      args: (listener != null) ? listener.id : 0,
    );

    final GemError result = GemErrorExtension.fromCode(resultString['result']);

    if (result != GemError.success) {
      return null;
    }

    return listener;
  }

  /// Removes a registered listener.
  ///
  /// **Parameters**
  ///
  /// * **IN** *onComplete* The listener to removed.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] Successfully registered the listener.
  /// * [GemError.notFound] The listener was not previously registered.
  GemError removeListener(
    EventHandler onComplete,
  ) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Recorder',
      'removeListener',
      args: (onComplete as EventDrivenProgressListener).id,
    );

    final GemError result = GemErrorExtension.fromCode(resultString['result']);

    return result;
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, Object>{'class': 'Recorder', 'id': _pointerId}),
    );
  }
}

/// Recorder bookmarks class
///
/// This class should not be instantiated directly. Instead, use the [create] method to obtain an instance.
///
/// {@category Sensor Data Source}
class RecorderBookmarks extends GemAutoreleaseObject {
  // ignore: unused_element
  RecorderBookmarks._() : _pointerId = -1;

  RecorderBookmarks.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;
  int get pointerId => _pointerId;

  /// Creates a recorder bookmarks instance.
  ///
  /// **Parameters**
  ///
  /// * **IN** *path* The path to the log folder
  ///
  /// **Returns**
  ///
  /// * The recorder bookmarks instance
  ///
  ///   **Throws**
  ///
  /// * An exception if it fails
  static RecorderBookmarks? create(final String path) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'RecorderBookmarks', 'args': path}),
    );
    final dynamic decodedVal = jsonDecode(resultString);

    if (decodedVal['gemApiError'] != 0) {
      return null;
    }
    return RecorderBookmarks.init(decodedVal['result']);
  }

  /// Gets the metadata for a file.
  ///
  /// **Parameters**
  ///
  /// * **IN** *logPath* 	The path to the file for which we get the metadata.
  ///
  /// **Returns**
  ///
  /// * The log file metadata, or null if the file does not exist.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  LogMetadata? getLogMetadata(final String logPath) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RecorderBookmarks',
      'getMetadata',
      args: logPath,
    );

    final int id = resultString['result'];

    if (id == -1) {
      return null;
    }

    return LogMetadata(resultString['result']);
  }

  /// Gets a list of all the protected logs.
  ///
  /// This method retrieves all the logs that are marked as protected, meaning they cannot be deleted automatically by the system.
  ///
  /// **Returns**
  ///
  /// * The list of protected logs.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  List<String> get protectedLogsList {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RecorderBookmarks',
      'getProtectedLogsList',
    );
    return resultString['result'].cast<String>();
  }

  /// Gets a list of all gm and mp4 logs sorted based on the provided sort order and sort type.
  ///
  /// The default sort order is ascending and the default sort type is date.
  ///
  /// **Returns**
  ///
  /// * The list of logs.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  List<String> getLogsList({
    final FileSortOrder sortOrder = FileSortOrder.asc,
    final FileSortType sortType = FileSortType.date,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RecorderBookmarks',
      'getLogsList',
      args: <String, int>{'sortOrder': sortOrder.id, 'sortType': sortType.id},
    );
    return resultString['result'].cast<String>();
  }

  /// Marks a gm log as protected.
  ///
  /// This method prevents the specified log from being deleted automatically when the system reaches its maximum disk space or the configured retention time is met.
  ///
  /// This only works with logs of type GM.
  ///
  /// **Parameters**
  ///
  /// * **IN** *logPath* 	The path to the file to be marked as protected.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] If operation succeeds.
  /// * [GemError.general] If operation fails.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError markLogProtected(final String logPath) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RecorderBookmarks',
      'markLogProtected',
      args: logPath,
    );
    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Marks a gm log as uploaded.
  ///
  /// This method marks a log as uploaded, which signifies that the log has been successfully transferred to the server.
  ///
  /// This only works with logs of type GM.
  ///
  /// **Parameters**
  ///
  /// * **IN** *logPath* 	The path to the file to be marked as protected.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] If operation succeeds.
  /// * [GemError.general] If operation fails.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError markLogUploaded(final String logPath) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RecorderBookmarks',
      'markLogUploaded',
      args: logPath,
    );
    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Deletes the specified log file.
  ///
  /// **Parameters**
  ///
  /// * **IN** *logPath* 	The path to the file to be marked as protected.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] If operation succeeds.
  /// * [GemError.general] If operation fails.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError deleteLog(final String logPath) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RecorderBookmarks',
      'deleteLog',
      args: logPath,
    );
    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Retrieves the duration of a mp4 log file.
  ///
  /// **Parameters**
  ///
  /// * **IN** *logPath* 	The path to the mp4 file.
  ///
  /// **Returns**
  ///
  /// * The log duration in seconds.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int getLogDurationInSeconds(final String logPath) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RecorderBookmarks',
      'getLogDurationInSeconds',
      args: logPath,
    );

    return resultString['result'];
  }

  /// Export log file in a different format.
  ///
  /// If the name of the exported file is not specified, then the log name will be used.
  ///
  /// **Parameters**
  ///
  /// * **IN** *logPath* The path for the file to be exported.
  /// * **IN** *type* The type of the exported file.
  /// * **IN** *exportedFileName* The exported file name.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] If operation succeeds.
  /// * [GemError.exist] If the exported file already exists in the folder.
  /// * [GemError.general] If operation fails.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError exportLog(
    final String logPath,
    final FileType type, {
    final String? exportedFileName,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RecorderBookmarks',
      'exportLog',
      args: <String, Object?>{
        'logPath': logPath,
        'type': type.id,
        'exportedFileName': exportedFileName,
      },
    );
    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Import a log file in GM format.
  ///
  /// Supported file formats include: GPX, NMEA, KML. If the name of the exported file is not specified, the log name will be used.
  ///
  /// **Parameters**
  ///
  /// * **IN** *logPath* 	The path for the file to be imported.
  /// * **IN** *importedFileName* The imported file name.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] If operation succeeds.
  /// * [GemError.exist] If the imported file already exists in the folder.
  /// * [GemError.notSupported] If the file format is not supported.
  /// * [GemError.general] If the operation fails.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError importLog(final String logPath, {final String? importedFileName}) {
    final String resultString = GemKitPlatform.instance.callObjectMethod(
      jsonEncode(<String, Object>{
        'id': _pointerId,
        'class': 'RecorderBookmarks',
        'method': 'importLog',
        'args': <String, String?>{
          'logPath': logPath,
          'importedFileName': importedFileName,
        },
      }),
    );
    return GemErrorExtension.fromCode(jsonDecode(resultString)['result']);
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, Object>{
        'class': 'RecorderBookmarks',
        'id': _pointerId,
      }),
    );
  }
}

/// LogMetadata class
///
/// This class should not be instantiated directly. Instead, use the [RecorderBookmarks.getLogMetadata] method to obtain an instance.
///
/// {@category Sensor Data Source}
class LogMetadata extends GemAutoreleaseObject {
  LogMetadata(this._pointerId) {
    super.registerAutoReleaseObject(_pointerId);
  }

  // ignore: unused_element
  LogMetadata._() : _pointerId = -1;
  final int _pointerId;

  /// The timestamp of the first sensor data.
  ///
  /// **Returns**
  ///
  /// * Timestamp of the first sensor data.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get startTimestampInMillis {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'getStartTimestampInMillis',
    );
    return resultString['result'];
  }

  /// Get timestamp of the last sensor data.
  ///
  /// **Returns**
  ///
  /// * Timestamp of the last sensor data
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get endTimestampInMillis {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'getEndTimestampInMillis',
    );
    return resultString['result'];
  }

  /// Get the log duration.
  ///
  /// **Returns**
  ///
  /// * Log duration.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get durationMillis {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'getDurationMillis',
    );
    return resultString['result'];
  }

  /// Retrieves the first recorded GPS position.
  ///
  /// If the recorded log contains GPS data, this method returns the first valid sensor position.
  ///
  /// If no GPS data is recorded, it returns an invalid coordinate `(0, 0)`.
  ///
  /// **Returns**
  ///
  /// * The first sensor recorded position or `(0, 0)` if no GPS data is available.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  Coordinates get startPosition {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'getStartPosition',
    );

    return Coordinates.fromJson(resultString['result']);
  }

  /// Retrieves the last recorded GPS position.
  ///
  /// If the recorded log contains GPS data, this method returns the last valid sensor position.
  ///
  /// If no GPS data is recorded, it returns an invalid coordinate `(0, 0)`.
  ///
  /// **Returns**
  ///
  /// * The last sensor recorded position or `(0, 0)` if no GPS data is available.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  Coordinates get endPosition {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'getEndPosition',
    );

    return Coordinates.fromJson(resultString['result']);
  }

  /// The transport mode used when the log was recorded.
  ///
  /// **Returns**
  ///
  /// * The transport mode used when the log was recorded
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  RecordingTransportMode get transportMode {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'getTransportMode',
    );

    return RecordingTransportModeExtension.fromId(resultString['result']);
  }

  /// Retrieves the recorded activity details.
  ///
  /// **Returns**
  ///
  /// * The recorded activity details
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  ActivityRecord get activityRecord {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'getActivityRecord',
    );

    return ActivityRecord.fromJson(resultString['result']);
  }

  /// Retrieves the log metrics.
  ///
  /// **Returns**
  ///
  /// * The log metrics
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  LogMetrics get logMetrics {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'getMetrics',
    );
    return LogMetrics.fromJson(resultString['result']);
  }

  /// Retrieves a shortened version of the recorded route.
  ///
  /// This method returns a concise list of GPS coordinates sampled from the recorded log.
  ///
  /// The positions are selected if either:
  /// * The position is at least 20 meters away from the previous position, or
  /// * 3 seconds have passed since the last recorded position, but only if the distance
  ///    between the two positions is at least 20 meters.
  ///
  /// **Returns**
  ///
  /// * A list of intermediary coordinates of the log.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  List<Coordinates> get route {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'getRoute',
    );

    return resultString['result']
        .map<Coordinates>((final dynamic e) => Coordinates.fromJson(e))
        .toList();
  }

  /// Retrieves a detailed description of the recorded route.
  ///
  /// This method returns the full list of GPS coordinates recorded during the log, including all available positions. It provides a precise and comprehensive representation of the route.
  ///
  /// **Returns**
  ///
  /// * A list of all coordinates of the log.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  List<Coordinates> get preciseRoute {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'getPreciseRoute',
    );

    final List<dynamic> rawList = resultString['result'];

    return rawList
        .map((dynamic e) => Coordinates.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Retrieves a list of recorded sound marks.
  ///
  /// **Returns**
  ///
  /// * A list of recorded sound marks.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  List<SoundMark> get soundMarks {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'getSoundMarks',
    );
    final List<dynamic> retval = resultString['result'];
    return retval.map((final dynamic e) => SoundMark.fromJson(e)).toList();
  }

  List<TextMark> get textMarks {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'getTextMarks',
    );
    final List<dynamic> retval = resultString['result'];
    return retval.map((final dynamic e) => TextMark.fromJson(e)).toList();
  }

  /// Verify if a data type is recorded in the log file.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* The type to verify if available.
  ///
  /// **Returns**
  ///
  /// * True if data type is available, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool isDataTypeAvailable(final DataType type) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'isDataTypeAvailable',
      args: type.id,
    );
    return resultString['result'];
  }

  /// Get a list of the available data types.
  ///
  /// This method helps in identifying all the types of data that are accessible in the log.
  ///
  /// **Returns**
  ///
  /// * A list of data types that have been recorded in the log file
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  List<DataType> get availableDataTypes {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'getAvailableDataTypes',
    );
    final List<dynamic> res = resultString['result'];
    return res.map((final dynamic e) => DataTypeExtension.fromId(e)).toList();
  }

  /// Check if a log file was uploaded to the server.
  ///
  /// This method verifies whether the log file has been successfully uploaded to the server.
  ///
  /// A log is considered as 'uploaded' when it has been successfully transferred and stored on the server for further processing or storage.
  ///
  /// **Returns**
  ///
  /// * True if the file is available.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get isUploaded {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'isUploaded',
    );
    return resultString['result'];
  }

  /// Check if a log file is protected.
  ///
  /// This method verifies whether the log file is marked as protected. A protected log file cannot be automatically deleted by the system, even if the maximum disk space usage is reached or the minimum retention time (in seconds) has passed. This ensures that the log file is preserved for further use or investigation.
  ///
  /// **Returns**
  ///
  /// * True if the file is protected.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get isProtected {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'isProtected',
    );
    return resultString['result'];
  }

  /// Get the log size.
  ///
  /// This method returns the size of the log file in bytes. The size is calculated based on the entire log content, including sensor data, metadata, and any additional recorded information.
  ///
  /// **Returns**
  ///
  /// * The log size in bytes
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get logSize {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'getLogSize',
    );
    return resultString['result'];
  }

  /// Retrieve metadata associated with a specific key from the customer buffer.
  ///
  /// This method returns the metadata that was previously added using the [addUserMetadata] method.
  ///
  /// **Parameters**
  ///
  /// * **IN** *key*	The key associated with the metadata to be retrieved.
  ///
  /// **Returns**
  ///
  /// * The metadata associated with the provided key as [Uint8List]
  /// * If no metadata is found for the key, a null value or an empty buffer might be returned.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  Uint8List? getUserMetadata(final String key) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogMetadata',
      'getUserMetadata',
      args: key,
    );
    final String result = resultString['result'];

    if (result == '') {
      return null;
    }
    return base64Decode(result);
  }

  /// Add or overwrite metadata associated with a specific key.
  ///
  /// This method stores the provided data buffer as metadata associated with the given key.
  ///
  /// If the key already exists, the previous metadata will be overwritten with this new data.
  ///
  /// If metadata already exists for the key, it will be overwritten with the new data.
  ///
  /// **Parameters**
  ///
  /// * **IN** *key*	The key used to identify the metadata entry.
  /// * **IN** *userMetadata*	The buffer containing the metadata to be stored.
  ///
  /// **Returns**
  ///
  /// * Returns true if the metadata is successfully added or overwritten, false if the data buffer is null or the operation fails.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  Future<bool> addUserMetadata(
    final String key,
    final Uint8List userMetadata,
  ) async {
    final dynamic dataBufferPointer =
        GemKitPlatform.instance.toNativePointer(userMetadata);

    final String? resultString = await GemKitPlatform.instance
        .getChannel(mapId: -1)
        .invokeMethod<String>(
          'callObjectMethod',
          jsonEncode(<String, Object>{
            'id': _pointerId,
            'class': 'LogMetadata',
            'method': 'addUserMetadata',
            'args': <String, dynamic>{
              'key': key,
              'dataBuffer': dataBufferPointer.address,
              'dataBufferSize': userMetadata.length,
            },
          }),
        );
    GemKitPlatform.instance.freeNativePointer(dataBufferPointer);
    return jsonDecode(resultString!)['result'] as bool;
  }
}

/// Represents a time interval in the log where sound was recorded.
///
/// {@category Sensor Data Source}
class SoundMark {
  SoundMark(this.start, this.end, this.coordinates);

  factory SoundMark.fromJson(final Map<String, dynamic> json) {
    return SoundMark(
      json['startOffsetMillis'],
      json['endOffsetMillis'],
      Coordinates.fromJson(json['coordinates']),
    );
  }

  /// Start offset in milliseconds (between 0 and log length)
  int start;

  /// End offset in milliseconds (between 0 and log length)
  int end;

  /// Coordinates where sound was recorded
  Coordinates coordinates;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'startOffsetMillis': start,
      'endOffsetMillis': end,
      'coordinates': coordinates.toJson(),
    };
  }
}

/// Represents a textual annotation at a specific moment in the log.
///
/// {@category Sensor Data Source}
class TextMark {
  TextMark(this.offset, this.coordinates, this.report);

  factory TextMark.fromJson(final Map<String, dynamic> json) {
    return TextMark(
      json['offsetMillis'],
      Coordinates.fromJson(json['coordinates']),
      json['report'],
    );
  }

  /// The timestamp of the text mark within the log.
  int offset;

  /// The geographical coordinates where the text mark was recorded.
  Coordinates coordinates;

  ///  A textual note or annotation associated with the mark.
  String report;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'offsetMillis': offset,
      'coordinates': coordinates.toJson(),
      'report': report,
    };
  }
}

/// Represents an activity being recorded, including  descriptions, type of sport, effort level,
/// associated bicycle profile (if applicable), and visibility preferences.
///
/// {@category Sensor Data Source}
class ActivityRecord {
  ActivityRecord({
    this.shortDescription = '',
    this.longDescription = '',
    this.sportType = SportType.unknown,
    this.effortType = EffortType.easy,
    this.bikeProfile,
    this.visibility = ActivityVisibility.everyone,
  });

  /// Creates an instance from a JSON object.
  factory ActivityRecord.fromJson(final Map<String, dynamic> json) {
    return ActivityRecord(
      shortDescription: json['shortDescription'],
      longDescription: json['longDescription'],
      sportType: SportTypeExtension.fromId(json['sportType']),
      effortType: EffortTypeExtension.fromId(json['effortType']),
      bikeProfile: BikeProfileElectricBikeProfile.fromJson(json['bikeProfile']),
      visibility: ActivityVisibilityExtension.fromId(json['visibility']),
    );
  }

  /// A short description of the activity.
  ///
  /// This is a brief summary or title for the activity, providing a quick overview.
  String shortDescription;

  /// A detailed description of the activity.
  ///
  /// This is a more comprehensive description, allowing for notes or details specific to the activity.
  String longDescription;

  /// The type of sport for this activity.
  ///
  /// Specifies the activity category, such as running, cycling, swimming, etc., using the [SportType] enumeration.
  SportType sportType;

  /// The effort level for this activity.
  ///
  /// Indicates the intensity or perceived effort of the activity, based on the [EffortType] enumeration.
  EffortType effortType;

  /// The bicycle profile, if the activity involves cycling.
  ///
  /// Contains bicycle-specific information, such as bike type or electric specifications. This field is only relevant if [sportType] is set to one of the cycling types (e.g., ride, mountainBike, eBikeRide, etc.).
  BikeProfileElectricBikeProfile? bikeProfile;

  /// The visibility settings for the activity.
  ///
  /// Defines who can view the activity, based on the `Visibility` enumeration. Options include public, followers-only, or private visibility.
  ActivityVisibility visibility;

  /// Converts the instance to a JSON object.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['shortDescription'] = shortDescription;
    json['longDescription'] = longDescription;
    json['sportType'] = sportType.id;
    json['effortType'] = effortType.id;
    json['bikeProfile'] = bikeProfile ?? BikeProfileElectricBikeProfile();
    json['visibility'] = visibility.id;

    return json;
  }
}

/// Object which provides metrics about a log
///
/// {@category Sensor Data Source}
class LogMetrics {
  LogMetrics({
    required this.distanceMeters,
    required this.elevationGainMeters,
    required this.avgSpeedMps,
  });

  factory LogMetrics.fromJson(final Map<String, dynamic> json) {
    return LogMetrics(
      distanceMeters: json['distanceMeters'],
      elevationGainMeters: json['elevationGainMeters'],
      avgSpeedMps: json['avgSpeedMps'],
    );
  }

  /// The total distance traveled in meters
  final double distanceMeters;

  /// The total elevation gain in meters
  final double elevationGainMeters;

  /// The average speed in meters per second
  final double avgSpeedMps;

  @override
  bool operator ==(covariant LogMetrics other) {
    if (identical(this, other)) {
      return true;
    }

    return other.distanceMeters == distanceMeters &&
        other.elevationGainMeters == elevationGainMeters &&
        other.avgSpeedMps == avgSpeedMps;
  }

  @override
  int get hashCode {
    return distanceMeters.hashCode ^
        elevationGainMeters.hashCode ^
        avgSpeedMps.hashCode;
  }
}
