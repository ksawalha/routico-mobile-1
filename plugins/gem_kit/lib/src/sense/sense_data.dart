// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'package:gem_kit/core.dart';
import 'package:gem_kit/position.dart';
import 'package:gem_kit/sense.dart';
import 'package:gem_kit/src/sense/sense_data_impl.dart';

/// Base data class for sense.
///
/// It contains data type and acquisition time.
///
/// {@category Sensor Data Source}
abstract class SenseData {
  /// Get data type.
  DataType get type;

  /// Acquisition time
  DateTime get acquisitionTime;
}

/// Acceleration class
///
/// {@category Sensor Data Source}
abstract class Acceleration extends SenseData {
  /// Get the acceleration on the X axis
  double get x;

  /// Get the acceleration on the Y axis
  double get y;

  /// Get the acceleration on the Z axis
  double get z;

  /// Get the unit of acceleration
  UnitOfMeasurementAcceleration get unit;
}

/// Values that represent the accuracy of the compass.
///
/// {@category Sensor Data Source}
enum CompassAccuracy {
  /// The compass accuracy is unknown.
  unknown,

  /// Low accuracy; the direction may be unreliable.
  low,

  /// Medium accuracy; the direction is moderately reliable, but not highly precise.
  medium,

  /// High accuracy; the direction is very reliable and precise.
  high,
}

/// @nodoc
extension CompassAccuracyExtension on CompassAccuracy {
  static CompassAccuracy fromId(final int value) {
    switch (value) {
      case 0:
        return CompassAccuracy.unknown;
      case 1:
        return CompassAccuracy.low;
      case 2:
        return CompassAccuracy.medium;
      case 3:
        return CompassAccuracy.high;
      default:
        throw ArgumentError('Invalid id');
    }
  }

  int get id {
    switch (this) {
      case CompassAccuracy.unknown:
        return 0;
      case CompassAccuracy.low:
        return 1;
      case CompassAccuracy.medium:
        return 2;
      case CompassAccuracy.high:
        return 3;
    }
  }
}

/// Compass class
///
/// {@category Sensor Data Source}
abstract class Compass extends SenseData {
  /// Get the heading of the compass
  double get heading;

  /// Get the accuracy of the compass
  CompassAccuracy get accuracy;
}

/// Rotation rate class
///
/// {@category Sensor Data Source}
abstract class RotationRate extends SenseData {
  /// Rotation rate around the x axis of the device, measured in radians per second (rad/s).
  double get x;

  /// Rotation rate around the y axis of the device, measured in radians per second (rad/s).
  double get y;

  /// Rotation rate around the z axis of the device, measured in radians per second (rad/s).
  double get z;
}

/// Attitude class
///
/// {@category Sensor Data Source}
abstract class Attitude extends SenseData {
  /// Device roll, in degrees
  double get roll;

  /// Device pitch, in degrees
  double get pitch;

  /// Device yaw, in degrees
  double get yaw;

  /// Variance of device roll, in degrees squared
  double get rollNoise;

  /// Variance of device pitch, in degrees squared
  double get pitchNoise;

  /// Variance of device yaw, in degrees squared
  double get yawNoise;

  /// Whether the device roll is noisy
  bool get hasRollNoise;

  /// Whether the device pitch is noisy
  bool get hasPitchNoise;

  /// Whether the device yaw is noisy
  bool get hasYawNoise;
}

/// Battery class
///
/// {@category Sensor Data Source}
enum BatteryState {
  /// The battery state is unknown.
  unknown,

  /// The battery is charging.
  charging,

  /// The battery is discharging (i.e., in use and not plugged in for charging).
  discharging,

  /// The battery is not charging but is plugged in (may be maintaining a certain charge level).
  notCharging,

  /// The battery is fully charged.
  full,
}

/// @nodoc
extension BatteryStateExtension on BatteryState {
  static BatteryState fromId(final int value) {
    switch (value) {
      case 0:
        return BatteryState.unknown;
      case 1:
        return BatteryState.charging;
      case 2:
        return BatteryState.discharging;
      case 3:
        return BatteryState.notCharging;
      case 4:
        return BatteryState.full;
      default:
        throw ArgumentError('Invalid id');
    }
  }

  int get id {
    switch (this) {
      case BatteryState.unknown:
        return 0;
      case BatteryState.charging:
        return 1;
      case BatteryState.discharging:
        return 2;
      case BatteryState.notCharging:
        return 3;
      case BatteryState.full:
        return 4;
    }
  }
}

/// Battery class
///
/// {@category Sensor Data Source}
enum PluggedType {
  /// The device is not plugged in.
  unplugged,

  /// The device is plugged in to an AC power source.
  ac,

  /// The device is plugged in to a USB power source.
  usb,

  /// The device is plugged in to a wireless power source.
  wireless,
}

/// @nodoc
extension PluggedTypeExtension on PluggedType {
  static PluggedType fromId(final int value) {
    switch (value) {
      case 0:
        return PluggedType.unplugged;
      case 1:
        return PluggedType.ac;
      case 2:
        return PluggedType.usb;
      case 3:
        return PluggedType.wireless;
      default:
        throw ArgumentError('Invalid id');
    }
  }

  int get id {
    switch (this) {
      case PluggedType.unplugged:
        return 0;
      case PluggedType.ac:
        return 1;
      case PluggedType.usb:
        return 2;
      case PluggedType.wireless:
        return 3;
    }
  }
}

/// Values that represent the health status of the battery.
///
/// {@category Sensor Data Source}
enum BatteryHealth {
  /// The battery health is unknown.
  unknown,

  /// The battery is in good condition.
  good,

  /// The battery is overheating.
  overheat,

  /// The battery is no longer functional (dead).
  dead,

  /// The battery is experiencing over voltage, which may indicate improper charging.
  overVoltage,

  /// The battery health status is unspecified or not determined.
  unspecifiedFailure,

  /// The battery is cold.
  cold,
}

/// @nodoc
extension BatteryHealthExtension on BatteryHealth {
  static BatteryHealth fromId(final int value) {
    switch (value) {
      case 0:
        return BatteryHealth.unknown;
      case 1:
        return BatteryHealth.good;
      case 2:
        return BatteryHealth.overheat;
      case 3:
        return BatteryHealth.dead;
      case 4:
        return BatteryHealth.overVoltage;
      case 5:
        return BatteryHealth.unspecifiedFailure;
      case 6:
        return BatteryHealth.cold;
      default:
        throw ArgumentError('Invalid id');
    }
  }

  int get id {
    switch (this) {
      case BatteryHealth.unknown:
        return 0;
      case BatteryHealth.good:
        return 1;
      case BatteryHealth.overheat:
        return 2;
      case BatteryHealth.dead:
        return 3;
      case BatteryHealth.overVoltage:
        return 4;
      case BatteryHealth.unspecifiedFailure:
        return 5;
      case BatteryHealth.cold:
        return 6;
    }
  }
}

/// Battery class
///
/// {@category Sensor Data Source}
abstract class Battery extends SenseData {
  /// Get battery level percentage
  int get level;

  /// Get battery state.
  BatteryState get state;

  /// Get battery health.
  BatteryHealth get health;

  /// Check if a low battery warning has been noticed.
  bool get lowBatteryNoticed;

  /// Get plugged type.
  PluggedType get pluggedType;

  /// Get battery voltage in millivolts.
  int get voltage;

  /// Get battery temperature.
  int get temperature;
}

/// Magnetic field class
///
/// {@category Sensor Data Source}
abstract class MagneticField extends SenseData {
  /// Magnetic field strength along the x axis, in microteslas.
  double get x;

  /// Magnetic field strength along the y axis, in microteslas.
  double get y;

  /// Magnetic field strength along the z axis, in microteslas.
  double get z;
}

/// Values that represent user interface orientation types
///
/// {@category Sensor Data Source}
enum OrientationType {
  /// The orientation is unknown.
  unknown,

  /// The orientation is portrait.
  portrait,

  /// The orientation is portrait upside down.
  portraitUpsideDown,

  /// The orientation is landscape left.
  landscapeLeft,

  /// The orientation is landscape right.
  landscapeRight,
}

/// @nodoc
extension OrientationTypeExtension on OrientationType {
  static OrientationType fromId(final int value) {
    switch (value) {
      case 0:
        return OrientationType.unknown;
      case 1:
        return OrientationType.portrait;
      case 2:
        return OrientationType.portraitUpsideDown;
      case 3:
        return OrientationType.landscapeLeft;
      case 4:
        return OrientationType.landscapeRight;
      default:
        throw ArgumentError('Invalid id');
    }
  }

  int get id {
    switch (this) {
      case OrientationType.unknown:
        return 0;
      case OrientationType.portrait:
        return 1;
      case OrientationType.portraitUpsideDown:
        return 2;
      case OrientationType.landscapeLeft:
        return 3;
      case OrientationType.landscapeRight:
        return 4;
    }
  }
}

/// Values that represent device orientation types.
///
/// {@category Sensor Data Source}
enum FaceType {
  /// The face type is unknown.
  unknown,

  /// The face is up.
  faceUp,

  /// The face is down.
  faceDown,
}

/// @nodoc
extension FaceTypeExtension on FaceType {
  static FaceType fromId(final int value) {
    switch (value) {
      case 0:
        return FaceType.unknown;
      case 1:
        return FaceType.faceUp;
      case 2:
        return FaceType.faceDown;
      default:
        throw ArgumentError('Invalid id');
    }
  }

  int get id {
    switch (this) {
      case FaceType.unknown:
        return 0;
      case FaceType.faceUp:
        return 1;
      case FaceType.faceDown:
        return 2;
    }
  }
}

/// Orientation class
///
/// {@category Sensor Data Source}
abstract class Orientation extends SenseData {
  /// Get the orientation type.
  OrientationType get orientation;

  /// Get the face type.
  FaceType get face;
}

/// Values that represent temperature levels.
///
/// This enum defines different levels of temperature, indicating how hot
/// or cold a system or environment is. Each level is associated with a specific
/// range of temperature values.
///
/// {@category Sensor Data Source}
enum TemperatureLevel {
  /// The temperature level is unknown.
  unknown,

  /// The temperature level is normal.
  normal,

  /// Fair temperature level; degrees are greater than 35 and less than or equal to 45.
  fair,

  /// Serious temperature level; degrees are greater than 45 and less than or equal to 55.
  serious,

  /// Critical temperature level; degrees are greater than 55 and less than or equal to 65.
  critical,

  /// Shutting down due to high temperature; degrees are greater than 65.
  shuttingDown,
}

/// @nodoc
extension TemperatureLevelExtension on TemperatureLevel {
  static TemperatureLevel fromId(final int value) {
    switch (value) {
      case 0:
        return TemperatureLevel.unknown;
      case 1:
        return TemperatureLevel.normal;
      case 2:
        return TemperatureLevel.fair;
      case 3:
        return TemperatureLevel.serious;
      case 4:
        return TemperatureLevel.critical;
      case 5:
        return TemperatureLevel.shuttingDown;
      default:
        throw ArgumentError('Invalid id');
    }
  }

  int get id {
    switch (this) {
      case TemperatureLevel.unknown:
        return 0;
      case TemperatureLevel.normal:
        return 1;
      case TemperatureLevel.fair:
        return 2;
      case TemperatureLevel.serious:
        return 3;
      case TemperatureLevel.critical:
        return 4;
      case TemperatureLevel.shuttingDown:
        return 5;
    }
  }
}

/// Temperature class
///
/// {@category Sensor Data Source}
abstract class Temperature extends SenseData {
  /// Get the temperature level in Celsius.
  double get temperature;

  /// Get the temperature level.
  TemperatureLevel get level;
}

/// NMEA chunk class
///
/// {@category Sensor Data Source}
abstract class NmeaChunk extends SenseData {
  /// Get the NMEA chunk as a string
  String get nmeaChunk;
}

/// The heart rate class
///
/// {@category Sensor Data Source}
abstract class HeartRate extends SenseData {
  /// Get the heart rate in beats per minute.
  int get heartRate;
}

/// The mount information class
///
/// {@category Sensor Data Source}
abstract class MountInformation extends SenseData {
  /// Tells if device is mounted for camera use (in a fixed vertical mount, in a car).
  bool get isMountedForCameraUse;

  /// Tells if the device is mounted in portrait orientation.
  bool get isPortraitMode;
}

/// Values that represent the confidence level of detected user activities.
///
/// {@category Sensor Data Source}
enum ActivityType {
  /// Unknown activity type.
  unknown,

  /// User is in a vehicle.
  inVehicle,

  /// User is on a bicycle.
  onBicycle,

  /// User is on foot (general category for walking, running, etc.).
  onFoot,

  /// Device is stationary or not moving.
  still,

  /// Device is tilting, possibly indicating a change in orientation.
  tilting,

  /// User is walking.
  walking,

  /// User is running.
  running,

  /// Vehicle is stationary.
  automotiveStationary,
}

/// @nodoc
extension ActivityTypeExtension on ActivityType {
  static ActivityType fromId(final int value) {
    switch (value) {
      case 0:
        return ActivityType.unknown;
      case 1:
        return ActivityType.inVehicle;
      case 2:
        return ActivityType.onBicycle;
      case 3:
        return ActivityType.onFoot;
      case 4:
        return ActivityType.still;
      case 5:
        return ActivityType.tilting;
      case 6:
        return ActivityType.walking;
      case 7:
        return ActivityType.running;
      case 8:
        return ActivityType.automotiveStationary;
      default:
        throw ArgumentError('Invalid id');
    }
  }

  int get id {
    switch (this) {
      case ActivityType.unknown:
        return 0;
      case ActivityType.inVehicle:
        return 1;
      case ActivityType.onBicycle:
        return 2;
      case ActivityType.onFoot:
        return 3;
      case ActivityType.still:
        return 4;
      case ActivityType.tilting:
        return 5;
      case ActivityType.walking:
        return 6;
      case ActivityType.running:
        return 7;
      case ActivityType.automotiveStationary:
        return 8;
    }
  }
}

/// Values that represent the confidence level of detected user activities.
///
/// {@category Sensor Data Source}
enum ActivityConfidence {
  /// Confidence level is unknown.
  unknown,

  /// Low confidence in the detected activity.
  low,

  /// Medium confidence in the detected activity.
  medium,

  /// High confidence in the detected activity.
  high,
}

/// @nodoc
extension ActivityConfidenceExtension on ActivityConfidence {
  static ActivityConfidence fromId(final int value) {
    switch (value) {
      case 0:
        return ActivityConfidence.unknown;
      case 1:
        return ActivityConfidence.low;
      case 2:
        return ActivityConfidence.medium;
      case 3:
        return ActivityConfidence.high;
      default:
        throw ArgumentError('Invalid id');
    }
  }

  int get id {
    switch (this) {
      case ActivityConfidence.unknown:
        return 0;
      case ActivityConfidence.low:
        return 1;
      case ActivityConfidence.medium:
        return 2;
      case ActivityConfidence.high:
        return 3;
    }
  }
}

/// Activity class
///
/// {@category Sensor Data Source}
abstract class Activity extends SenseData {
  /// Get the activity type.
  ActivityType get activityType;

  /// Get the confidence level of the activity.
  ActivityConfidence get confidence;
}

/// Sense data factory
///
/// {@category Sensor Data Source}
abstract class SenseDataFactory {
  /// Produces a new [GemPosition] from provided parameters
  static GemPosition producePosition({
    final DateTime? acquisitionTime,
    final DateTime? satelliteTime,
    final Provider provider = Provider.unknown,
    final PositionQuality fixQuality = PositionQuality.high,
    final double latitude = 0.0,
    final double longitude = 0.0,
    final double altitude = 0.0,
    final double speed = 0.0,
    final double speedAccuracy = -1.0,
    final double course = 0.0,
    final double courseAccuracy = -1.0,
    final double accuracyH = -1.0,
    final double accuracyV = -1.0,
    final bool hasCoordinates = true,
    final bool hasAltitude = true,
    final bool hasSpeed = true,
    final bool hasSpeedAccuracy = false,
    final bool hasCourse = true,
    final bool hasCourseAccuracy = false,
    final bool hasHorizontalAccuracy = false,
    final bool hasVerticalAccuracy = false,
  }) {
    return GemPositionImpl(
      type: DataType.position,
      acquisitionTime: acquisitionTime ?? DateTime.now(),
      satelliteTime: satelliteTime ?? DateTime.now(),
      provider: provider,
      fixQuality: fixQuality,
      latitude: latitude,
      longitude: longitude,
      altitude: altitude,
      speed: speed,
      speedAccuracy: speedAccuracy,
      course: course,
      courseAccuracy: courseAccuracy,
      accuracyH: accuracyH,
      accuracyV: accuracyV,
      hasCoordinates: hasCoordinates,
      hasAltitude: hasAltitude,
      hasSpeed: hasSpeed,
      hasSpeedAccuracy: hasSpeedAccuracy,
      hasCourse: hasCourse,
      hasCourseAccuracy: hasCourseAccuracy,
      hasHorizontalAccuracy: hasHorizontalAccuracy,
      hasVerticalAccuracy: hasVerticalAccuracy,
    );
  }

  /// Converts [ExternalPositionData] to [GemPosition]
  @Deprecated('Use producePosition instead')
  static GemPosition positionFromExternalData(final ExternalPositionData data) {
    return GemPositionImpl(
      type: DataType.position,
      acquisitionTime: DateTime.fromMillisecondsSinceEpoch(
        data.timestamp,
        isUtc: true,
      ),
      satelliteTime: DateTime.fromMillisecondsSinceEpoch(
        data.timestamp,
        isUtc: true,
      ),
      provider: Provider.gps,
      fixQuality: PositionQuality.high,
      latitude: data.latitude,
      longitude: data.longitude,
      altitude: data.altitude,
      speed: data.speed,
      speedAccuracy: -1.0,
      course: data.heading,
      courseAccuracy: -1.0,
      accuracyH: -1.0,
      accuracyV: -1.0,
      hasCoordinates: true,
      hasAltitude: true,
      hasSpeed: true,
      hasSpeedAccuracy: false,
      hasCourse: true,
      hasCourseAccuracy: false,
      hasHorizontalAccuracy: false,
      hasVerticalAccuracy: false,
    );
  }

  /// Produces a new [Acceleration] from provided parameters
  static Acceleration produceAcceleration({
    final DateTime? acquisitionTime,
    final double x = 0.0,
    final double y = 0.0,
    final double z = 0.0,
    final UnitOfMeasurementAcceleration unit = UnitOfMeasurementAcceleration.g,
  }) {
    return AccelerationImpl(
      type: DataType.acceleration,
      acquisitionTime: acquisitionTime ?? DateTime.now(),
      x: x,
      y: y,
      z: z,
      unit: unit,
    );
  }

  /// Produces a new [Compass] from provided parameters
  static Compass produceCompass({
    final DateTime? acquisitionTime,
    final double heading = 0.0,
    final CompassAccuracy accuracy = CompassAccuracy.unknown,
  }) {
    return CompassImpl(
      type: DataType.compass,
      acquisitionTime: acquisitionTime ?? DateTime.now(),
      heading: heading,
      accuracy: accuracy,
    );
  }

  /// Produces a new [Activity] from provided parameters
  static Activity produceActivity({
    final DateTime? acquisitionTime,
    final ActivityType activityType = ActivityType.unknown,
    final ActivityConfidence confidence = ActivityConfidence.unknown,
  }) {
    return ActivityImpl(
      type: DataType.activity,
      acquisitionTime: acquisitionTime ?? DateTime.now(),
      activityType: activityType,
      confidence: confidence,
    );
  }

  /// Produces a new [Attitude] from provided parameters
  static Attitude produceAttitude({
    final DateTime? acquisitionTime,
    final double roll = 0.0,
    final double pitch = 0.0,
    final double yaw = 0.0,
    final double rollNoise = 0.0,
    final double pitchNoise = 0.0,
    final double yawNoise = 0.0,
    final bool hasRollNoise = false,
    final bool hasPitchNoise = false,
    final bool hasYawNoise = false,
  }) {
    return AttitudeImpl(
      type: DataType.attitude,
      acquisitionTime: acquisitionTime ?? DateTime.now(),
      roll: roll,
      pitch: pitch,
      yaw: yaw,
      rollNoise: rollNoise,
      pitchNoise: pitchNoise,
      yawNoise: yawNoise,
      hasRollNoise: hasRollNoise,
      hasPitchNoise: hasPitchNoise,
      hasYawNoise: hasYawNoise,
    );
  }

  /// Produces a new [Battery] from provided parameters
  static Battery produceBattery({
    final DateTime? acquisitionTime,
    final int level = 0,
    final BatteryState state = BatteryState.unknown,
    final BatteryHealth health = BatteryHealth.unknown,
    final bool lowBatteryNoticed = false,
    final PluggedType pluggedType = PluggedType.unplugged,
    final int voltage = 0,
    final int temperature = 0,
  }) {
    return BatteryImpl(
      type: DataType.battery,
      acquisitionTime: acquisitionTime ?? DateTime.now(),
      level: level,
      state: state,
      health: health,
      lowBatteryNoticed: lowBatteryNoticed,
      pluggedType: pluggedType,
      voltage: voltage,
      temperature: temperature,
    );
  }

  /// Produces a new [MagneticField] from provided parameters
  static MagneticField produceMagneticField({
    final DateTime? acquisitionTime,
    final double x = 0.0,
    final double y = 0.0,
    final double z = 0.0,
  }) {
    return MagneticFieldImpl(
      type: DataType.magneticField,
      acquisitionTime: acquisitionTime ?? DateTime.now(),
      x: x,
      y: y,
      z: z,
    );
  }

  /// Produces a new [Orientation] from provided parameters
  static Orientation produceOrientation({
    final DateTime? acquisitionTime,
    final OrientationType orientation = OrientationType.unknown,
    final FaceType face = FaceType.unknown,
  }) {
    return OrientationImpl(
      type: DataType.orientation,
      acquisitionTime: acquisitionTime ?? DateTime.now(),
      orientation: orientation,
      face: face,
    );
  }

  /// Produces a new [RotationRate] from provided parameters
  static RotationRate produceRotationRate({
    final DateTime? acquisitionTime,
    final double x = 0.0,
    final double y = 0.0,
    final double z = 0.0,
  }) {
    return RotationRateImpl(
      type: DataType.rotationRate,
      acquisitionTime: acquisitionTime ?? DateTime.now(),
      x: x,
      y: y,
      z: z,
    );
  }

  /// Produces a new [Temperature] from provided parameters
  static Temperature produceTemperature({
    final DateTime? acquisitionTime,
    final double temperature = 0.0,
    final TemperatureLevel level = TemperatureLevel.unknown,
  }) {
    return TemperatureImpl(
      type: DataType.temperature,
      acquisitionTime: acquisitionTime ?? DateTime.now(),
      temperature: temperature,
      level: level,
    );
  }

  /// Produces a new [MountInformation] from provided parameters
  static MountInformation produceMountInformation({
    final DateTime? acquisitionTime,
    final bool isMountedForCameraUse = false,
    final bool isPortraitMode = false,
  }) {
    return MountInformationImpl(
      type: DataType.mountInformation,
      acquisitionTime: acquisitionTime ?? DateTime.now(),
      isMountedForCameraUse: isMountedForCameraUse,
      isPortraitMode: isPortraitMode,
    );
  }

  /// Produces a new [HeartRate] from provided parameters
  static HeartRate produceHeartRate({
    final DateTime? acquisitionTime,
    final int heartRate = 0,
  }) {
    return HeartRateImpl(
      type: DataType.heartRate,
      acquisitionTime: acquisitionTime ?? DateTime.now(),
      heartRate: heartRate,
    );
  }

  /// Produces a new [NmeaChunk] from provided parameters
  static NmeaChunk produceNmeaChunk({
    final DateTime? acquisitionTime,
    required final String nmeaChunk,
  }) {
    return NmeaChunkImpl(
      type: DataType.nmeaChunk,
      acquisitionTime: acquisitionTime ?? DateTime.now(),
      nmeaChunk: nmeaChunk,
    );
  }
}
