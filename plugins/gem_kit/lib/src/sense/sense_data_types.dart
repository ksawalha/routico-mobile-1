// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

/// Known sense data types
///
/// {@category Sensor Data Source}
enum DataType {
  /// Acceleration
  acceleration,

  /// Activity
  activity,

  /// Attitude
  attitude,

  /// Battery
  battery,

  /// Camera
  camera,

  /// Compass
  compass,

  /// MagneticField
  magneticField,

  /// Orientation
  orientation,

  /// Position
  position,

  /// ImprovedPosition
  improvedPosition,

  /// RotationRate
  rotationRate,

  /// Temperature
  temperature,

  /// Notification
  notification,

  /// MountInformation
  mountInformation,

  /// HeartRate
  heartRate,

  /// Nmea Chunk
  nmeaChunk,

  /// Unknown
  unknown,

  /// Same as rotationRate
  gyroscope,
}

/// @nodoc
///
/// {@category Sensor Data Source}
extension DataTypeExtension on DataType {
  int get id {
    switch (this) {
      case DataType.acceleration:
        return 1;
      case DataType.activity:
        return 2;
      case DataType.attitude:
        return 4;
      case DataType.battery:
        return 8;
      case DataType.camera:
        return 16;
      case DataType.compass:
        return 32;
      case DataType.magneticField:
        return 64;
      case DataType.orientation:
        return 128;
      case DataType.position:
        return 256;
      case DataType.improvedPosition:
        return 512;
      case DataType.rotationRate:
        return 1024;
      case DataType.temperature:
        return 2048;
      case DataType.notification:
        return 4096;
      case DataType.mountInformation:
        return 8192;
      case DataType.heartRate:
        return 16384;
      case DataType.nmeaChunk:
        return 32768;
      case DataType.unknown:
        return 65536;
      case DataType.gyroscope:
        return 1024;
    }
  }

  static DataType fromId(final int id) {
    switch (id) {
      case 1:
        return DataType.acceleration;
      case 2:
        return DataType.activity;
      case 4:
        return DataType.attitude;
      case 8:
        return DataType.battery;
      case 16:
        return DataType.camera;
      case 32:
        return DataType.compass;
      case 64:
        return DataType.magneticField;
      case 128:
        return DataType.orientation;
      case 256:
        return DataType.position;
      case 512:
        return DataType.improvedPosition;
      case 1024:
        return DataType.rotationRate;
      case 2048:
        return DataType.temperature;
      case 4096:
        return DataType.notification;
      case 8192:
        return DataType.mountInformation;
      case 16384:
        return DataType.heartRate;
      case 32768:
        return DataType.nmeaChunk;
      case 65536:
        return DataType.unknown;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

///  The data source type.
///
///  {@category Sensor Data Source}
enum DataSourceType {
  /// The type of data source is unknown.
  unknown,

  /// Data is obtained from sensors or any other live source.
  live,

  /// Data is obtained from playing a previously recorded log file or through simulation.
  playback,
}

/// @nodoc
///
/// {@category Sensor Data Source}
extension DataSourceTypeExtension on DataSourceType {
  int get id {
    switch (this) {
      case DataSourceType.unknown:
        return 0;
      case DataSourceType.live:
        return 1;
      case DataSourceType.playback:
        return 2;
    }
  }

  static DataSourceType fromId(final int id) {
    switch (id) {
      case 0:
        return DataSourceType.unknown;
      case 1:
        return DataSourceType.live;
      case 2:
        return DataSourceType.playback;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Display resolutions
///
/// {@category Sensor Data Source}
enum Resolution {
  /// No resolution.
  unknown,

  /// 640 * 480 resolution.
  sd480p,

  /// 1280 * 720 resolution.
  hd720p,

  /// 1920 * 1080 resolution.
  fullHD1080p,

  /// 2560 * 1440 resolution.
  wqhd1440p,

  /// 3840 * 2160 resolution.
  uhd4K2160p,

  /// 7680 * 4320 resolution.
  uhd8K4320p,
}

/// @nodoc
extension ResolutionExtension on Resolution {
  int get id {
    switch (this) {
      case Resolution.unknown:
        return 0;
      case Resolution.sd480p:
        return 1;
      case Resolution.hd720p:
        return 2;
      case Resolution.fullHD1080p:
        return 3;
      case Resolution.wqhd1440p:
        return 4;
      case Resolution.uhd4K2160p:
        return 5;
      case Resolution.uhd8K4320p:
        return 6;
    }
  }

  static Resolution fromId(final int id) {
    switch (id) {
      case 0:
        return Resolution.unknown;
      case 1:
        return Resolution.sd480p;
      case 2:
        return Resolution.hd720p;
      case 3:
        return Resolution.fullHD1080p;
      case 4:
        return Resolution.wqhd1440p;
      case 5:
        return Resolution.uhd4K2160p;
      case 6:
        return Resolution.uhd8K4320p;
      default:
        throw ArgumentError('Invalid id');
    }
  }

  String serialize() {
    switch (this) {
      case Resolution.unknown:
        return '0';
      case Resolution.sd480p:
        return '1';
      case Resolution.hd720p:
        return '2';
      case Resolution.fullHD1080p:
        return '3';
      case Resolution.wqhd1440p:
        return '4';
      case Resolution.uhd4K2160p:
        return '5';
      case Resolution.uhd8K4320p:
        return '6';
    }
  }

  static Resolution? fromString(final String? resolution) {
    if (resolution == null) {
      return null;
    }
    switch (resolution) {
      case '0':
        return Resolution.unknown;
      case '1':
        return Resolution.sd480p;
      case '2':
        return Resolution.hd720p;
      case '3':
        return Resolution.fullHD1080p;
      case '4':
        return Resolution.wqhd1440p;
      case '5':
        return Resolution.uhd4K2160p;
      case '6':
        return Resolution.uhd8K4320p;
      default:
        return null;
    }
  }
}

/// Keys for DataSource sensors configuration
///
/// {@category Sensor Data Source}
abstract class DSPrefKeys {
  /// Invalid value
  static const String invalidValue = '-1';

  /// Invalid value as int
  static const int invalidValueInt = -1;

  /// Sensor frequency
  static const String sensorFrequency = 'frequency';

  /// Timestamp
  static const String timestamp = 'timestamp';

  /// Value when no data
  static const String valueWhenNoData = 'valWhenNoData';
}

/// Keys for DataSource position sensors configuration
///
/// {@category Sensor Data Source}
abstract class DSPrefKeysPosition {
  /// Position distance
  static const String positionDistanceFilter = 'pos_distance';

  /// Position heading angle
  static const String positionHeadingAngleFilter = 'pos_heading_angle';

  /// Position accuracy
  static const String positionAccuracy = 'pos_accuracy';

  /// Position activity
  static const String positionActivity = 'pos_activity';

  /// Allows background location updates
  static const String allowsBackgroundLocationUpdates =
      'allowsBackgroundLocationUpdates';

  /// Pauses location updates automatically
  static const String pausesLocationUpdatesAutomatically =
      'pausesLocationUpdatesAutomatically';

  /// Improved position update frequency
  /// Higher frequency provides smoother positions but increases CPU and battery usage
  static const String improvedPositionUpdateFreq = 'improvedPositionUpdateFreq';

  /// Improved position default transport mode
  /// Values: "car", "truck", "bike/bicycle", "pedestrian, "auto"
  /// Default transport mode roads are preferred by the improved position engine
  /// If set to auto, the default transport mode is automatically detected
  static const String improvedPositionDefTransportMode =
      'improvedPositionDefTransportMode';

  /// Threshold for snapping to map link data (vehicle)
  /// Default 50 meters
  /// If position is close to a map link at a smaller distance than this value, the improved position will automatically snap to the map link
  /// 0 means never snap to map data
  static const String improvedPositionSnapToMapLinkThresholdVehicle =
      'snapToMapLinkThreshold_Vehicle';

  /// Threshold for snapping to map link data (bike)
  /// Default 50 meters
  /// If position is close to a map link at a smaller distance than this value, the improved position will automatically snap to the map link
  /// 0 means never snap to map data
  static const String improvedPositionSnapToMapLinkThresholdBike =
      'snapToMapLinkThreshold_Bike';

  /// Whether to snap to the route (instead of the most probable link)
  /// If "true", the arrow will always snap to the route (if the route exists, and the distance is within the "snapToMapLinkThreshold")
  /// If false, it will snap to the most probable map link, which is not necessarily the route link
  /// This is only for display; does not affect the matching and guidance algorithm
  static const String improvedPosPreferRouteSnap = 'preferRouteSnap';
}

/// Data origin.
///
/// {@category Sensor Data Source}
enum Origin {
  ///  The origin of the data is unknown.
  unknown,

  /// The data is sourced from an internal data source.
  gm,

  ///  The data is sourced from a custom data source defined by an external party.
  external,
}

/// @nodoc
extension OriginExtension on Origin {
  int get id {
    switch (this) {
      case Origin.unknown:
        return 0;
      case Origin.gm:
        return 1;
      case Origin.external:
        return 2;
    }
  }

  static Origin fromId(final int id) {
    switch (id) {
      case 0:
        return Origin.unknown;
      case 1:
        return Origin.gm;
      case 2:
        return Origin.external;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Sensor configuration base class
///
/// {@category Sensor Data Source}
class SensorConfiguration {
  SensorConfiguration();

  factory SensorConfiguration.fromJson(final Map<String, String> json) {
    final SensorConfiguration config = SensorConfiguration();
    config._config.addAll(json);
    return config;
  }
  final Map<String, String> _config = <String, String>{};

  Map<String, String> toJson() {
    return _config;
  }

  /// The sensor frequency
  int? get sensorFrequency {
    final String? number = _config[DSPrefKeys.sensorFrequency];

    if (number == null) {
      return null;
    }

    return int.tryParse(number);
  }

  /// The sensor frequency
  set sensorFrequency(final int? value) {
    if (value != null) {
      _config[DSPrefKeys.sensorFrequency] = value.toString();
    } else {
      _config.remove(DSPrefKeys.sensorFrequency);
    }
  }

  /// The timestamp
  int? get timestamp {
    final String? number = _config[DSPrefKeys.timestamp];

    if (number == null) {
      return null;
    }

    return int.tryParse(number);
  }

  /// The timestamp
  set timestamp(final int? value) {
    if (value != null) {
      _config[DSPrefKeys.timestamp] = value.toString();
    } else {
      _config.remove(DSPrefKeys.timestamp);
    }
  }
}

/// The position accuracy
///
/// {@category Sensor Data Source}
enum PositionAccuracy {
  /// Unknown accuracy
  unknown,

  /// Every second
  everySecond,

  /// Only when moving
  whenMoving,

  /// Nearest 10 meters
  nearestTenMeters,

  /// Nearest 1000 meters
  hundredMeters,

  /// Nearest kilometer
  kilometer,
}

/// @nodoc
extension PositionAccuracyExtension on PositionAccuracy {
  String serialize() {
    switch (this) {
      case PositionAccuracy.unknown:
        return '0';
      case PositionAccuracy.everySecond:
        return '1';
      case PositionAccuracy.whenMoving:
        return '2';
      case PositionAccuracy.nearestTenMeters:
        return '3';
      case PositionAccuracy.hundredMeters:
        return '4';
      case PositionAccuracy.kilometer:
        return '5';
    }
  }

  static PositionAccuracy? fromString(final String? accuracy) {
    if (accuracy == null) {
      return null;
    }
    switch (accuracy) {
      case '0':
        return PositionAccuracy.unknown;
      case '1':
        return PositionAccuracy.everySecond;
      case '2':
        return PositionAccuracy.whenMoving;
      case '3':
        return PositionAccuracy.nearestTenMeters;
      case '4':
        return PositionAccuracy.hundredMeters;
      case '5':
        return PositionAccuracy.kilometer;
      default:
        return null;
    }
  }
}

/// The position activity
///
/// {@category Sensor Data Source}
enum PositionActivity {
  /// Unknown activity
  unknown,

  /// Other activity
  other,

  /// Automotive activity
  automotive,

  /// Pedestrian activity
  pedestrian,

  /// Other navigation activity
  otherNavigation,
}

/// @nodoc
extension PositionActivityExtension on PositionActivity {
  String serialize() {
    switch (this) {
      case PositionActivity.unknown:
        return '0';
      case PositionActivity.other:
        return '1';
      case PositionActivity.automotive:
        return '2';
      case PositionActivity.pedestrian:
        return '3';
      case PositionActivity.otherNavigation:
        return '4';
    }
  }

  static PositionActivity? fromString(final String? activity) {
    if (activity == null) {
      return null;
    }
    switch (activity) {
      case '0':
        return PositionActivity.unknown;
      case '1':
        return PositionActivity.other;
      case '2':
        return PositionActivity.automotive;
      case '3':
        return PositionActivity.pedestrian;
      case '4':
        return PositionActivity.otherNavigation;
      default:
        return null;
    }
  }
}

/// Default transport mode for improved position
///
/// {@category Sensor Data Source}
enum ImprovedPositionDefTransportMode {
  /// Automatic
  auto,

  /// Car
  car,

  /// Pedestrian
  pedestrian,

  /// Bike
  bike,

  /// Truck
  truck,
}

/// @nodoc
extension ImprovedPositionDefTransportModeExtension
    on ImprovedPositionDefTransportMode {
  String serialize() {
    switch (this) {
      case ImprovedPositionDefTransportMode.auto:
        return 'auto';
      case ImprovedPositionDefTransportMode.car:
        return 'car';
      case ImprovedPositionDefTransportMode.pedestrian:
        return 'pedestrian';
      case ImprovedPositionDefTransportMode.bike:
        return 'bike';
      case ImprovedPositionDefTransportMode.truck:
        return 'truck';
    }
  }

  static ImprovedPositionDefTransportMode? fromString(final String? accuracy) {
    if (accuracy == null) {
      return null;
    }
    switch (accuracy.toLowerCase()) {
      case 'car':
        return ImprovedPositionDefTransportMode.car;
      case 'truck':
        return ImprovedPositionDefTransportMode.truck;
      case 'bike':
        return ImprovedPositionDefTransportMode.bike;
      case 'pedestrian':
        return ImprovedPositionDefTransportMode.pedestrian;
      case 'auto':
        return ImprovedPositionDefTransportMode.auto;
      default:
        return null;
    }
  }
}

/// Configuration class for position sensor
///
/// {@category Sensor Data Source}
class PositionSensorConfiguration extends SensorConfiguration {
  PositionSensorConfiguration();

  factory PositionSensorConfiguration.fromJson(final Map<String, String> json) {
    final PositionSensorConfiguration config = PositionSensorConfiguration();
    config._config.addAll(json);
    return config;
  }

  /// The position distance filter
  double? get positionDistanceFilter {
    final String? number = _config[DSPrefKeysPosition.positionDistanceFilter];

    if (number == null) {
      return null;
    }

    return double.tryParse(number);
  }

  /// The position distance filter
  set positionDistanceFilter(final double? value) {
    if (value != null) {
      _config[DSPrefKeysPosition.positionDistanceFilter] = value.toString();
    } else {
      _config.remove(DSPrefKeysPosition.positionDistanceFilter);
    }
  }

  /// The position heading angle
  int? get positionHeadingAngle {
    final String? number =
        _config[DSPrefKeysPosition.positionHeadingAngleFilter];

    if (number == null) {
      return null;
    }

    return int.tryParse(number);
  }

  /// The position heading angle
  set positionHeadingAngle(final int? value) {
    if (value != null) {
      _config[DSPrefKeysPosition.positionHeadingAngleFilter] = value.toString();
    } else {
      _config.remove(DSPrefKeysPosition.positionHeadingAngleFilter);
    }
  }

  /// The position accuracy
  PositionAccuracy? get positionAccuracy {
    return PositionAccuracyExtension.fromString(
      _config[DSPrefKeysPosition.positionAccuracy],
    );
  }

  /// The position accuracy
  set positionAccuracy(final PositionAccuracy? value) {
    if (value != null) {
      _config[DSPrefKeysPosition.positionAccuracy] = value.serialize();
    } else {
      _config.remove(DSPrefKeysPosition.positionAccuracy);
    }
  }

  /// The position activity
  PositionActivity? get positionActivity {
    return PositionActivityExtension.fromString(
      _config[DSPrefKeysPosition.positionActivity],
    );
  }

  /// The position activity
  set positionActivity(final PositionActivity? value) {
    if (value != null) {
      _config[DSPrefKeysPosition.positionActivity] = value.serialize();
    } else {
      _config.remove(DSPrefKeysPosition.positionActivity);
    }
  }

  /// Allows background location updates
  bool? get allowsBackgroundLocationUpdates {
    final String? response =
        _config[DSPrefKeysPosition.allowsBackgroundLocationUpdates];

    if (response == null) {
      return null;
    }

    if (response == '1') {
      return true;
    } else {
      return false;
    }
  }

  /// Allows background location updates
  set allowsBackgroundLocationUpdates(final bool? value) {
    if (value != null) {
      _config[DSPrefKeysPosition.allowsBackgroundLocationUpdates] =
          value ? '1' : '0';
    } else {
      _config.remove(DSPrefKeysPosition.allowsBackgroundLocationUpdates);
    }
  }

  /// Automatically pauses updates
  bool? get pausesLocationUpdatesAutomatically {
    final String? response =
        _config[DSPrefKeysPosition.pausesLocationUpdatesAutomatically];

    if (response == null) {
      return null;
    }

    if (response == '1') {
      return true;
    } else {
      return false;
    }
  }

  /// Automatically pauses updates
  set pausesLocationUpdatesAutomatically(final bool? value) {
    if (value != null) {
      _config[DSPrefKeysPosition.pausesLocationUpdatesAutomatically] =
          value ? '1' : '0';
    } else {
      _config.remove(DSPrefKeysPosition.pausesLocationUpdatesAutomatically);
    }
  }

  /// Improved position default transport mode
  ImprovedPositionDefTransportMode? get improvedPositionDefineTransportMode {
    return ImprovedPositionDefTransportModeExtension.fromString(
      _config[DSPrefKeysPosition.improvedPositionDefTransportMode],
    );
  }

  /// Improved position default transport mode
  set improvedPositionDefineTransportMode(
    final ImprovedPositionDefTransportMode? value,
  ) {
    if (value != null) {
      _config[DSPrefKeysPosition.improvedPositionDefTransportMode] =
          value.serialize();
    } else {
      _config.remove(DSPrefKeysPosition.improvedPositionDefTransportMode);
    }
  }

  /// Improved position update frequency
  int? get improvedPositionUpdateFrequency {
    final String? number =
        _config[DSPrefKeysPosition.improvedPositionUpdateFreq];

    if (number == null) {
      return null;
    }

    return int.tryParse(number);
  }

  /// Improved position update frequency
  set improvedPositionUpdateFrequency(final int? value) {
    if (value != null) {
      _config[DSPrefKeysPosition.improvedPositionUpdateFreq] = value.toString();
    } else {
      _config.remove(DSPrefKeysPosition.improvedPositionUpdateFreq);
    }
  }

  /// Improved position max snap to map link threshold for vehicle
  int? get improvedPositionSnapToMapLinkThresholdVehicle {
    final String? number = _config[
        DSPrefKeysPosition.improvedPositionSnapToMapLinkThresholdVehicle];

    if (number == null) {
      return null;
    }

    return int.tryParse(number);
  }

  /// Improved position max snap to map link threshold for vehicle
  set improvedPositionSnapToMapLinkThresholdVehicle(final int? value) {
    if (value != null) {
      _config[DSPrefKeysPosition
          .improvedPositionSnapToMapLinkThresholdVehicle] = value.toString();
    } else {
      _config.remove(
        DSPrefKeysPosition.improvedPositionSnapToMapLinkThresholdVehicle,
      );
    }
  }

  /// Improved position max snap to map link threshold for bike
  int? get improvedPositionSnapToMapLinkThresholdBike {
    final String? number =
        _config[DSPrefKeysPosition.improvedPositionSnapToMapLinkThresholdBike];

    if (number == null) {
      return null;
    }

    return int.tryParse(number);
  }

  /// Improved position max snap to map link threshold for bike
  set improvedPositionSnapToMapLinkThresholdBike(final int? value) {
    if (value != null) {
      _config[DSPrefKeysPosition.improvedPositionSnapToMapLinkThresholdBike] =
          value.toString();
    } else {
      _config.remove(
        DSPrefKeysPosition.improvedPositionSnapToMapLinkThresholdBike,
      );
    }
  }

  /// Prefer route snap for improved position
  bool? get improvedPositionPreferRouteSnap {
    final String? response =
        _config[DSPrefKeysPosition.improvedPosPreferRouteSnap];

    if (response == null) {
      return null;
    }

    if (response == '1') {
      return true;
    } else {
      return false;
    }
  }

  /// Prefer route snap for improved position
  set improvedPositionPreferRouteSnap(final bool? value) {
    if (value != null) {
      _config[DSPrefKeysPosition.improvedPosPreferRouteSnap] =
          value ? '1' : '0';
    } else {
      _config.remove(DSPrefKeysPosition.improvedPosPreferRouteSnap);
    }
  }
}

/// Represents the playing status of a data source.
///
/// {@category Sensor Data Source}
enum PlayingStatus {
  /// Unknown playing status
  unknown,

  /// Data source is stopped
  stopped,

  /// Data source is paused
  paused,

  /// Data source is playing
  playing,
}

/// @nodoc
extension PlayingStatusExtension on PlayingStatus {
  /// Maps the enum to an integer ID.
  int get id {
    switch (this) {
      case PlayingStatus.unknown:
        return 0;
      case PlayingStatus.stopped:
        return 1;
      case PlayingStatus.paused:
        return 2;
      case PlayingStatus.playing:
        return 3;
    }
  }

  static PlayingStatus fromId(final int id) {
    switch (id) {
      case 0:
        return PlayingStatus.unknown;
      case 1:
        return PlayingStatus.stopped;
      case 2:
        return PlayingStatus.paused;
      case 3:
        return PlayingStatus.playing;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Values that represent type of unit for acceleration data.
///
/// {@category Sensor Data Source}
enum UnitOfMeasurementAcceleration {
  // Gravitational force (g)
  g,

  // Meters per second squared (m/s²).
  metersPerSecondSquared,
}

/// @nodoc
extension UnitOfMeasurementAccelerationExtension
    on UnitOfMeasurementAcceleration {
  int get id {
    switch (this) {
      case UnitOfMeasurementAcceleration.g:
        return 0;
      case UnitOfMeasurementAcceleration.metersPerSecondSquared:
        return 1;
    }
  }

  static UnitOfMeasurementAcceleration fromId(final int id) {
    switch (id) {
      case 0:
        return UnitOfMeasurementAcceleration.g;
      case 1:
        return UnitOfMeasurementAcceleration.metersPerSecondSquared;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}
