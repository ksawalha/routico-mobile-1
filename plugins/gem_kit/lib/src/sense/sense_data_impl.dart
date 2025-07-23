// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'package:flutter/foundation.dart';
import 'package:gem_kit/core.dart';
import 'package:gem_kit/position.dart';
import 'package:gem_kit/sense.dart';

/// @nodoc
class SenseDataImpl implements SenseData {
  SenseDataImpl({required this.type, required this.acquisitionTime});

  factory SenseDataImpl.fromJson(final Map<String, dynamic> json) {
    return SenseDataImpl(
      type: DataTypeExtension.fromId(json['senseDataType']),
      acquisitionTime: DateTime.fromMillisecondsSinceEpoch(
        json['acquisitionTimestamp'],
        isUtc: true,
      ),
    );
  }

  @override
  DateTime acquisitionTime;

  @override
  DataType type;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'acquisitionTimestamp': acquisitionTime.millisecondsSinceEpoch,
      'senseDataType': type.id,
    };
  }
}

/// @nodoc
class GemPositionImpl extends SenseDataImpl implements GemPosition {
  GemPositionImpl({
    required super.type,
    required super.acquisitionTime,
    required this.satelliteTime,
    required this.provider,
    required this.fixQuality,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.speed,
    required this.speedAccuracy,
    required this.course,
    required this.courseAccuracy,
    required this.accuracyH,
    required this.accuracyV,
    required this.hasCoordinates,
    required this.hasAltitude,
    required this.hasSpeed,
    required this.hasSpeedAccuracy,
    required this.hasCourse,
    required this.hasCourseAccuracy,
    required this.hasHorizontalAccuracy,
    required this.hasVerticalAccuracy,
  });

  factory GemPositionImpl.fromJson(final Map<String, dynamic> json) {
    return GemPositionImpl(
      type: DataTypeExtension.fromId(json['senseDataType']),
      acquisitionTime: DateTime.fromMillisecondsSinceEpoch(
        json['acquisitionTimestamp'],
        isUtc: true,
      ),
      satelliteTime: DateTime.fromMillisecondsSinceEpoch(
        json['timestamp'],
        isUtc: true,
      ),
      provider: ProviderExtension.fromId(json['provider']),
      fixQuality: PositionQualityExtension.fromId(json['fix']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      altitude: json['alt'],
      speed: json['speed'],
      speedAccuracy: json['speedAccuracy'],
      course: json['course'],
      courseAccuracy: json['courseAccuracy'],
      accuracyH: json['accuracyH'],
      accuracyV: json['accuracyV'],
      hasCoordinates: json['hasCoordinates'],
      hasAltitude: json['hasAltitude'],
      hasSpeed: json['hasSpeed'],
      hasSpeedAccuracy: json['hasSpeedAccuracy'],
      hasCourse: json['hasCourse'],
      hasCourseAccuracy: json['hasCourseAccuracy'],
      hasHorizontalAccuracy: json['hasHorizontalAccuracy'],
      hasVerticalAccuracy: json['hasVerticalAccuracy'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['senseDataType'] = type.id;
    json['acquisitionTimestamp'] = acquisitionTime.millisecondsSinceEpoch;

    json['timestamp'] = satelliteTime.millisecondsSinceEpoch;
    json['provider'] = provider.id;
    json['fix'] = fixQuality.id;
    json['latitude'] = latitude;
    json['longitude'] = longitude;
    json['alt'] = altitude;
    json['speed'] = speed;
    json['speedAccuracy'] = speedAccuracy;
    json['course'] = course;
    json['courseAccuracy'] = courseAccuracy;
    json['accuracyH'] = accuracyH;
    json['accuracyV'] = accuracyV;
    json['hasCoordinates'] = hasCoordinates;
    json['hasAltitude'] = hasAltitude;
    json['hasSpeed'] = hasSpeed;
    json['hasSpeedAccuracy'] = hasSpeedAccuracy;
    json['hasCourse'] = hasCourse;
    json['hasCourseAccuracy'] = hasCourseAccuracy;
    json['hasHorizontalAccuracy'] = hasHorizontalAccuracy;
    json['hasVerticalAccuracy'] = hasVerticalAccuracy;

    return json;
  }

  @override
  double accuracyH;

  @override
  double accuracyV;

  @override
  double altitude;

  @override
  double course;

  @override
  double courseAccuracy;

  @override
  bool hasAltitude;

  @override
  bool hasCoordinates;

  @override
  bool hasCourse;

  @override
  bool hasCourseAccuracy;

  @override
  bool hasHorizontalAccuracy;

  @override
  bool hasSpeed;

  @override
  bool hasSpeedAccuracy;

  @override
  bool hasVerticalAccuracy;

  @override
  double latitude;

  @override
  double longitude;

  @override
  Provider provider;

  @override
  PositionQuality fixQuality;

  @override
  DateTime satelliteTime;

  @override
  double speed;

  @override
  double speedAccuracy;

  @override
  DateTime get timestamp => satelliteTime;

  @override
  Coordinates get coordinates =>
      Coordinates(latitude: latitude, longitude: longitude, altitude: altitude);

  @override
  bool operator ==(covariant final GemPosition other) {
    return latitude == other.latitude &&
        longitude == other.longitude &&
        altitude == other.altitude &&
        speed == other.speed &&
        speedAccuracy == other.speedAccuracy &&
        course == other.course &&
        courseAccuracy == other.courseAccuracy &&
        accuracyH == other.accuracyH &&
        accuracyV == other.accuracyV &&
        hasCoordinates == other.hasCoordinates &&
        hasAltitude == other.hasAltitude &&
        hasSpeed == other.hasSpeed &&
        hasSpeedAccuracy == other.hasSpeedAccuracy &&
        hasCourse == other.hasCourse &&
        hasCourseAccuracy == other.hasCourseAccuracy &&
        hasHorizontalAccuracy == other.hasHorizontalAccuracy &&
        hasVerticalAccuracy == other.hasVerticalAccuracy &&
        provider == other.provider &&
        fixQuality == other.fixQuality &&
        satelliteTime.millisecondsSinceEpoch ==
            other.satelliteTime.millisecondsSinceEpoch &&
        acquisitionTime.millisecondsSinceEpoch ==
            other.acquisitionTime.millisecondsSinceEpoch;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^
        longitude.hashCode ^
        altitude.hashCode ^
        speed.hashCode ^
        speedAccuracy.hashCode ^
        course.hashCode ^
        courseAccuracy.hashCode ^
        accuracyH.hashCode ^
        accuracyV.hashCode ^
        hasCoordinates.hashCode ^
        hasAltitude.hashCode ^
        hasSpeed.hashCode ^
        hasSpeedAccuracy.hashCode ^
        hasCourse.hashCode ^
        hasCourseAccuracy.hashCode ^
        hasHorizontalAccuracy.hashCode ^
        hasVerticalAccuracy.hashCode ^
        provider.hashCode ^
        fixQuality.hashCode ^
        satelliteTime.millisecondsSinceEpoch.hashCode ^
        acquisitionTime.millisecondsSinceEpoch.hashCode;
  }
}

/// @nodoc
class GemImprovedPositionImpl extends GemPositionImpl
    implements GemImprovedPosition {
  GemImprovedPositionImpl({
    required super.type,
    required super.acquisitionTime,
    required super.satelliteTime,
    required super.provider,
    required super.fixQuality,
    required super.latitude,
    required super.longitude,
    required super.altitude,
    required super.speed,
    required super.speedAccuracy,
    required super.course,
    required super.courseAccuracy,
    required super.accuracyH,
    required super.accuracyV,
    required super.hasCoordinates,
    required super.hasAltitude,
    required super.hasSpeed,
    required super.hasSpeedAccuracy,
    required super.hasCourse,
    required super.hasCourseAccuracy,
    required super.hasHorizontalAccuracy,
    required super.hasVerticalAccuracy,
    required this.addressMap,
    required this.roadModifiers,
    required this.speedLimit,
    required this.hasRoadLocalization,
    required this.hasTerrainData,
    required this.terrainAltitude,
    required this.terrainSlope,
  });

  factory GemImprovedPositionImpl.fromJson(final Map<String, dynamic> json) {
    final int packedRoadModifier = json['roadModifier'];
    final Set<RoadModifier> roadModifiersSet = <RoadModifier>{};
    for (final RoadModifier modifier in RoadModifier.values) {
      if (modifier.id & packedRoadModifier != 0) {
        roadModifiersSet.add(modifier);
      }
    }

    final Map<String, String> addressMap = <String, String>{};
    for (final dynamic entry in json['addr'].entries) {
      final String key = entry.key;
      final String value = entry.value;
      addressMap[key] = value;
    }

    return GemImprovedPositionImpl(
      type: DataTypeExtension.fromId(json['senseDataType']),
      acquisitionTime: DateTime.fromMillisecondsSinceEpoch(
        json['acquisitionTimestamp'],
        isUtc: true,
      ),
      satelliteTime: DateTime.fromMillisecondsSinceEpoch(
        json['timestamp'],
        isUtc: true,
      ),
      provider: ProviderExtension.fromId(json['provider']),
      fixQuality: PositionQualityExtension.fromId(json['fix']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      altitude: json['alt'],
      speed: json['speed'],
      speedAccuracy: json['speedAccuracy'],
      course: json['course'],
      courseAccuracy: json['courseAccuracy'],
      accuracyH: json['accuracyH'],
      accuracyV: json['accuracyV'],
      hasCoordinates: json['hasCoordinates'],
      hasAltitude: json['hasAltitude'],
      hasSpeed: json['hasSpeed'],
      hasSpeedAccuracy: json['hasSpeedAccuracy'],
      hasCourse: json['hasCourse'],
      hasCourseAccuracy: json['hasCourseAccuracy'],
      hasHorizontalAccuracy: json['hasHorizontalAccuracy'],
      hasVerticalAccuracy: json['hasVerticalAccuracy'],
      addressMap: addressMap,
      roadModifiers: roadModifiersSet,
      speedLimit: json['roadSpeedLimit'],
      hasRoadLocalization: json['hasRoadLocalization'],
      hasTerrainData: json['hasTerrainData'],
      terrainAltitude: json['terrainAltitude'],
      terrainSlope: json['terrainSlope'],
    );
  }
  @override
  AddressInfo get address => AddressInfo.fromJson(addressMap);

  @override
  bool hasRoadLocalization;

  @override
  bool hasTerrainData;

  @override
  Set<RoadModifier> roadModifiers;

  @override
  double speedLimit;

  @override
  double terrainAltitude;

  @override
  double terrainSlope;

  Map<String, String> addressMap;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['senseDataType'] = type.id;
    json['acquisitionTimestamp'] = acquisitionTime.millisecondsSinceEpoch;
    json['timestamp'] = satelliteTime.millisecondsSinceEpoch;
    json['provider'] = provider.id;
    json['fix'] = fixQuality.id;
    json['latitude'] = latitude;
    json['longitude'] = longitude;
    json['alt'] = altitude;
    json['speed'] = speed;
    json['speedAccuracy'] = speedAccuracy;
    json['course'] = course;
    json['courseAccuracy'] = courseAccuracy;
    json['accuracyH'] = accuracyH;
    json['accuracyV'] = accuracyV;
    json['hasCoordinates'] = hasCoordinates;
    json['hasAltitude'] = hasAltitude;
    json['hasSpeed'] = hasSpeed;
    json['hasSpeedAccuracy'] = hasSpeedAccuracy;
    json['hasCourse'] = hasCourse;
    json['hasCourseAccuracy'] = hasCourseAccuracy;
    json['hasHorizontalAccuracy'] = hasHorizontalAccuracy;
    json['hasVerticalAccuracy'] = hasVerticalAccuracy;
    json['addr'] = addressMap;
    json['roadModifier'] = roadModifiers
        .map((final RoadModifier modifier) => modifier.id)
        .reduce((final int a, final int b) => a | b);
    json['roadSpeedLimit'] = speedLimit;
    json['hasRoadLocalization'] = hasRoadLocalization;
    json['hasTerrainData'] = hasTerrainData;
    json['terrainAltitude'] = terrainAltitude;
    json['terrainSlope'] = terrainSlope;

    return json;
  }

  @override
  bool operator ==(covariant final GemImprovedPositionImpl other) {
    return super == other &&
        roadModifiers.containsAll(other.roadModifiers) &&
        other.roadModifiers.containsAll(roadModifiers) &&
        speedLimit == other.speedLimit &&
        hasRoadLocalization == other.hasRoadLocalization &&
        hasTerrainData == other.hasTerrainData &&
        terrainAltitude == other.terrainAltitude &&
        terrainSlope == other.terrainSlope &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        altitude == other.altitude &&
        speed == other.speed &&
        speedAccuracy == other.speedAccuracy &&
        course == other.course &&
        courseAccuracy == other.courseAccuracy &&
        accuracyH == other.accuracyH &&
        accuracyV == other.accuracyV &&
        hasCoordinates == other.hasCoordinates &&
        hasAltitude == other.hasAltitude &&
        hasSpeed == other.hasSpeed &&
        hasSpeedAccuracy == other.hasSpeedAccuracy &&
        hasCourse == other.hasCourse &&
        hasCourseAccuracy == other.hasCourseAccuracy &&
        hasHorizontalAccuracy == other.hasHorizontalAccuracy &&
        hasVerticalAccuracy == other.hasVerticalAccuracy &&
        mapEquals(addressMap, other.addressMap) &&
        provider == other.provider &&
        fixQuality == other.fixQuality &&
        satelliteTime.millisecondsSinceEpoch ==
            other.satelliteTime.millisecondsSinceEpoch &&
        acquisitionTime.millisecondsSinceEpoch ==
            other.acquisitionTime.millisecondsSinceEpoch;
  }

  @override
  int get hashCode {
    return super.hashCode ^
        roadModifiers.toString().hashCode ^
        speedLimit.hashCode ^
        hasRoadLocalization.hashCode ^
        hasTerrainData.hashCode ^
        terrainAltitude.hashCode ^
        terrainSlope.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        altitude.hashCode ^
        speed.hashCode ^
        speedAccuracy.hashCode ^
        course.hashCode ^
        courseAccuracy.hashCode ^
        accuracyH.hashCode ^
        accuracyV.hashCode ^
        hasCoordinates.hashCode ^
        hasAltitude.hashCode ^
        hasSpeed.hashCode ^
        hasSpeedAccuracy.hashCode ^
        hasCourse.hashCode ^
        hasCourseAccuracy.hashCode ^
        hasHorizontalAccuracy.hashCode ^
        hasVerticalAccuracy.hashCode ^
        addressMap.toString().hashCode ^
        provider.hashCode ^
        fixQuality.hashCode ^
        satelliteTime.hashCode ^
        acquisitionTime.hashCode;
  }
}

/// @nodoc
class AccelerationImpl extends SenseDataImpl implements Acceleration {
  AccelerationImpl({
    required super.type,
    required super.acquisitionTime,
    required this.x,
    required this.y,
    required this.z,
    required this.unit,
  });

  factory AccelerationImpl.fromJson(final Map<String, dynamic> json) {
    return AccelerationImpl(
      type: DataTypeExtension.fromId(json['senseDataType']),
      acquisitionTime: DateTime.fromMillisecondsSinceEpoch(
        json['acquisitionTimestamp'],
        isUtc: true,
      ),
      x: json['x'],
      y: json['y'],
      z: json['z'],
      unit: UnitOfMeasurementAccelerationExtension.fromId(json['unit']),
    );
  }
  @override
  UnitOfMeasurementAcceleration unit;

  @override
  double x;

  @override
  double y;

  @override
  double z;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['senseDataType'] = type.id;
    json['acquisitionTimestamp'] = acquisitionTime.millisecondsSinceEpoch;

    json['x'] = x;
    json['y'] = y;
    json['z'] = z;
    json['unit'] = unit.id;

    return json;
  }

  @override
  bool operator ==(covariant final Acceleration other) {
    return x == other.x &&
        y == other.y &&
        z == other.z &&
        unit == other.unit &&
        acquisitionTime.millisecondsSinceEpoch ==
            other.acquisitionTime.millisecondsSinceEpoch;
  }

  @override
  int get hashCode {
    return x.hashCode ^
        y.hashCode ^
        z.hashCode ^
        unit.hashCode ^
        acquisitionTime.hashCode;
  }
}

/// @nodoc
class CompassImpl extends SenseDataImpl implements Compass {
  CompassImpl({
    required super.type,
    required super.acquisitionTime,
    required this.heading,
    required this.accuracy,
  });

  factory CompassImpl.fromJson(final Map<String, dynamic> json) {
    return CompassImpl(
      type: DataTypeExtension.fromId(json['senseDataType']),
      acquisitionTime: DateTime.fromMillisecondsSinceEpoch(
        json['acquisitionTimestamp'],
        isUtc: true,
      ),
      heading: json['heading'],
      accuracy: CompassAccuracyExtension.fromId(json['accuracy']),
    );
  }
  @override
  double heading;

  @override
  CompassAccuracy accuracy;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['senseDataType'] = type.id;
    json['acquisitionTimestamp'] = acquisitionTime.millisecondsSinceEpoch;

    json['heading'] = heading;
    json['accuracy'] = accuracy.id;

    return json;
  }

  @override
  bool operator ==(covariant final Compass other) {
    return heading == other.heading &&
        accuracy == other.accuracy &&
        acquisitionTime.millisecondsSinceEpoch ==
            other.acquisitionTime.millisecondsSinceEpoch;
  }

  @override
  int get hashCode {
    return heading.hashCode ^ accuracy.hashCode ^ acquisitionTime.hashCode;
  }
}

/// @nodoc
class RotationRateImpl extends SenseDataImpl implements RotationRate {
  RotationRateImpl({
    required super.type,
    required super.acquisitionTime,
    required this.x,
    required this.y,
    required this.z,
  });

  factory RotationRateImpl.fromJson(final Map<String, dynamic> json) {
    return RotationRateImpl(
      type: DataTypeExtension.fromId(json['senseDataType']),
      acquisitionTime: DateTime.fromMillisecondsSinceEpoch(
        json['acquisitionTimestamp'],
        isUtc: true,
      ),
      x: json['x'],
      y: json['y'],
      z: json['z'],
    );
  }

  @override
  double x;

  @override
  double y;

  @override
  double z;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['senseDataType'] = type.id;
    json['acquisitionTimestamp'] = acquisitionTime.millisecondsSinceEpoch;

    json['x'] = x;
    json['y'] = y;
    json['z'] = z;

    return json;
  }

  @override
  bool operator ==(covariant final RotationRate other) {
    return x == other.x &&
        y == other.y &&
        z == other.z &&
        acquisitionTime.millisecondsSinceEpoch ==
            other.acquisitionTime.millisecondsSinceEpoch;
  }

  @override
  int get hashCode {
    return x.hashCode ^ y.hashCode ^ z.hashCode ^ acquisitionTime.hashCode;
  }
}

/// @nodoc
class AttitudeImpl extends SenseDataImpl implements Attitude {
  AttitudeImpl({
    required super.type,
    required super.acquisitionTime,
    required this.roll,
    required this.pitch,
    required this.yaw,
    required this.rollNoise,
    required this.hasPitchNoise,
    required this.hasRollNoise,
    required this.hasYawNoise,
    required this.pitchNoise,
    required this.yawNoise,
  });

  factory AttitudeImpl.fromJson(final Map<String, dynamic> json) {
    return AttitudeImpl(
      type: DataTypeExtension.fromId(json['senseDataType']),
      acquisitionTime: DateTime.fromMillisecondsSinceEpoch(
        json['acquisitionTimestamp'],
        isUtc: true,
      ),
      roll: json['roll'],
      pitch: json['pitch'],
      yaw: json['yaw'],
      rollNoise: json['rollNoise'],
      pitchNoise: json['pitchNoise'],
      yawNoise: json['yawNoise'],
      hasPitchNoise: json['hasPitchNoise'],
      hasRollNoise: json['hasRollNoise'],
      hasYawNoise: json['hasYawNoise'],
    );
  }

  @override
  double roll;

  @override
  double pitch;

  @override
  double yaw;

  @override
  double rollNoise;

  @override
  double pitchNoise;

  @override
  double yawNoise;

  @override
  bool hasPitchNoise;

  @override
  bool hasRollNoise;

  @override
  bool hasYawNoise;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['senseDataType'] = type.id;
    json['acquisitionTimestamp'] = acquisitionTime.millisecondsSinceEpoch;

    json['roll'] = roll;
    json['pitch'] = pitch;
    json['yaw'] = yaw;
    json['rollNoise'] = rollNoise;
    json['pitchNoise'] = pitchNoise;
    json['yawNoise'] = yawNoise;
    json['hasPitchNoise'] = hasPitchNoise;
    json['hasRollNoise'] = hasRollNoise;
    json['hasYawNoise'] = hasYawNoise;

    return json;
  }

  @override
  bool operator ==(covariant final Attitude other) {
    return roll == other.roll &&
        pitch == other.pitch &&
        yaw == other.yaw &&
        rollNoise == other.rollNoise &&
        pitchNoise == other.pitchNoise &&
        yawNoise == other.yawNoise &&
        hasPitchNoise == other.hasPitchNoise &&
        hasRollNoise == other.hasRollNoise &&
        hasYawNoise == other.hasYawNoise &&
        acquisitionTime.millisecondsSinceEpoch ==
            other.acquisitionTime.millisecondsSinceEpoch;
  }

  @override
  int get hashCode {
    return roll.hashCode ^
        pitch.hashCode ^
        yaw.hashCode ^
        rollNoise.hashCode ^
        pitchNoise.hashCode ^
        yawNoise.hashCode ^
        hasPitchNoise.hashCode ^
        hasRollNoise.hashCode ^
        hasYawNoise.hashCode ^
        acquisitionTime.hashCode;
  }
}

/// @nodoc
class BatteryImpl extends SenseDataImpl implements Battery {
  BatteryImpl({
    required super.type,
    required super.acquisitionTime,
    required this.health,
    required this.level,
    required this.lowBatteryNoticed,
    required this.pluggedType,
    required this.state,
    required this.temperature,
    required this.voltage,
  });

  factory BatteryImpl.fromJson(final Map<String, dynamic> json) {
    return BatteryImpl(
      type: DataTypeExtension.fromId(json['senseDataType']),
      acquisitionTime: DateTime.fromMillisecondsSinceEpoch(
        json['acquisitionTimestamp'],
        isUtc: true,
      ),
      health: BatteryHealthExtension.fromId(json['health']),
      level: json['level'],
      lowBatteryNoticed: json['lowBattery'],
      pluggedType: PluggedTypeExtension.fromId(json['pluggedType']),
      state: BatteryStateExtension.fromId(json['state']),
      temperature: json['temperature'],
      voltage: json['voltage'],
    );
  }

  @override
  BatteryHealth health;

  @override
  int level;

  @override
  bool lowBatteryNoticed;

  @override
  PluggedType pluggedType;

  @override
  BatteryState state;

  @override
  int temperature;

  @override
  int voltage;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['senseDataType'] = type.id;
    json['acquisitionTimestamp'] = acquisitionTime.millisecondsSinceEpoch;

    json['health'] = health.id;
    json['level'] = level;
    json['lowBattery'] = lowBatteryNoticed;
    json['pluggedType'] = pluggedType.id;
    json['state'] = state.id;
    json['temperature'] = temperature;
    json['voltage'] = voltage;

    return json;
  }

  @override
  bool operator ==(covariant final Battery other) {
    return health == other.health &&
        level == other.level &&
        lowBatteryNoticed == other.lowBatteryNoticed &&
        pluggedType == other.pluggedType &&
        state == other.state &&
        temperature == other.temperature &&
        voltage == other.voltage &&
        acquisitionTime.millisecondsSinceEpoch ==
            other.acquisitionTime.millisecondsSinceEpoch;
  }

  @override
  int get hashCode {
    return health.hashCode ^
        level.hashCode ^
        lowBatteryNoticed.hashCode ^
        pluggedType.hashCode ^
        state.hashCode ^
        temperature.hashCode ^
        voltage.hashCode ^
        acquisitionTime.hashCode;
  }
}

/// @nodoc
class MagneticFieldImpl extends SenseDataImpl implements MagneticField {
  MagneticFieldImpl({
    required super.type,
    required super.acquisitionTime,
    required this.x,
    required this.y,
    required this.z,
  });

  factory MagneticFieldImpl.fromJson(final Map<String, dynamic> json) {
    return MagneticFieldImpl(
      type: DataTypeExtension.fromId(json['senseDataType']),
      acquisitionTime: DateTime.fromMillisecondsSinceEpoch(
        json['acquisitionTimestamp'],
        isUtc: true,
      ),
      x: json['x'],
      y: json['y'],
      z: json['z'],
    );
  }
  @override
  double x;

  @override
  double y;

  @override
  double z;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['senseDataType'] = type.id;
    json['acquisitionTimestamp'] = acquisitionTime.millisecondsSinceEpoch;

    json['x'] = x;
    json['y'] = y;
    json['z'] = z;

    return json;
  }

  @override
  bool operator ==(covariant final MagneticField other) {
    return x == other.x &&
        y == other.y &&
        z == other.z &&
        acquisitionTime.millisecondsSinceEpoch ==
            other.acquisitionTime.millisecondsSinceEpoch;
  }

  @override
  int get hashCode {
    return x.hashCode ^ y.hashCode ^ z.hashCode ^ acquisitionTime.hashCode;
  }
}

/// @nodoc
class OrientationImpl extends SenseDataImpl implements Orientation {
  OrientationImpl({
    required super.type,
    required super.acquisitionTime,
    required this.face,
    required this.orientation,
  });

  factory OrientationImpl.fromJson(final Map<String, dynamic> json) {
    return OrientationImpl(
      type: DataTypeExtension.fromId(json['senseDataType']),
      acquisitionTime: DateTime.fromMillisecondsSinceEpoch(
        json['acquisitionTimestamp'],
        isUtc: true,
      ),
      face: FaceTypeExtension.fromId(json['faceType']),
      orientation: OrientationTypeExtension.fromId(json['orientation']),
    );
  }

  @override
  FaceType face;

  @override
  OrientationType orientation;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['senseDataType'] = type.id;
    json['acquisitionTimestamp'] = acquisitionTime.millisecondsSinceEpoch;

    json['faceType'] = face.id;
    json['orientation'] = orientation.id;

    return json;
  }

  @override
  bool operator ==(covariant final Orientation other) {
    return face == other.face &&
        orientation == other.orientation &&
        acquisitionTime.millisecondsSinceEpoch ==
            other.acquisitionTime.millisecondsSinceEpoch;
  }

  @override
  int get hashCode {
    return face.hashCode ^ orientation.hashCode ^ acquisitionTime.hashCode;
  }
}

/// @nodoc
class TemperatureImpl extends SenseDataImpl implements Temperature {
  TemperatureImpl({
    required super.type,
    required super.acquisitionTime,
    required this.level,
    required this.temperature,
  });

  factory TemperatureImpl.fromJson(final Map<String, dynamic> json) {
    return TemperatureImpl(
      type: DataTypeExtension.fromId(json['senseDataType']),
      acquisitionTime: DateTime.fromMillisecondsSinceEpoch(
        json['acquisitionTimestamp'],
        isUtc: true,
      ),
      level: TemperatureLevelExtension.fromId(json['temperatureLevel']),
      temperature: json['temperatureDegrees'],
    );
  }

  @override
  TemperatureLevel level;

  @override
  double temperature;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['senseDataType'] = type.id;
    json['acquisitionTimestamp'] = acquisitionTime.millisecondsSinceEpoch;

    json['temperatureLevel'] = level.id;
    json['temperatureDegrees'] = temperature;

    return json;
  }

  @override
  bool operator ==(covariant final Temperature other) {
    return level == other.level &&
        temperature == other.temperature &&
        acquisitionTime.millisecondsSinceEpoch ==
            other.acquisitionTime.millisecondsSinceEpoch;
  }

  @override
  int get hashCode {
    return level.hashCode ^ temperature.hashCode ^ acquisitionTime.hashCode;
  }
}

/// @nodoc
class HeartRateImpl extends SenseDataImpl implements HeartRate {
  HeartRateImpl({
    required super.type,
    required super.acquisitionTime,
    required this.heartRate,
  });

  factory HeartRateImpl.fromJson(final Map<String, dynamic> json) {
    return HeartRateImpl(
      type: DataTypeExtension.fromId(json['senseDataType']),
      acquisitionTime: DateTime.fromMillisecondsSinceEpoch(
        json['acquisitionTimestamp'],
        isUtc: true,
      ),
      heartRate: json['heartRate'],
    );
  }

  @override
  int heartRate;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['senseDataType'] = type.id;
    json['acquisitionTimestamp'] = acquisitionTime.millisecondsSinceEpoch;

    json['heartRate'] = heartRate;

    return json;
  }

  @override
  bool operator ==(covariant final HeartRate other) {
    return heartRate == other.heartRate &&
        acquisitionTime.millisecondsSinceEpoch ==
            other.acquisitionTime.millisecondsSinceEpoch;
  }

  @override
  int get hashCode {
    return heartRate.hashCode ^ acquisitionTime.hashCode;
  }
}

/// @nodoc
class MountInformationImpl extends SenseDataImpl implements MountInformation {
  MountInformationImpl({
    required super.type,
    required super.acquisitionTime,
    required this.isMountedForCameraUse,
    required this.isPortraitMode,
  });

  factory MountInformationImpl.fromJson(final Map<String, dynamic> json) {
    return MountInformationImpl(
      type: DataTypeExtension.fromId(json['senseDataType']),
      acquisitionTime: DateTime.fromMillisecondsSinceEpoch(
        json['acquisitionTimestamp'],
        isUtc: true,
      ),
      isMountedForCameraUse: json['mountedForCameraUse'],
      isPortraitMode: json['isPortraitMode'],
    );
  }

  @override
  bool isMountedForCameraUse;

  @override
  bool isPortraitMode;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['senseDataType'] = type.id;
    json['acquisitionTimestamp'] = acquisitionTime.millisecondsSinceEpoch;

    json['mountedForCameraUse'] = isMountedForCameraUse;
    json['isPortraitMode'] = isPortraitMode;

    return json;
  }

  @override
  bool operator ==(covariant final MountInformation other) {
    return isMountedForCameraUse == other.isMountedForCameraUse &&
        isPortraitMode == other.isPortraitMode &&
        acquisitionTime.millisecondsSinceEpoch ==
            other.acquisitionTime.millisecondsSinceEpoch;
  }

  @override
  int get hashCode {
    return isMountedForCameraUse.hashCode ^
        isPortraitMode.hashCode ^
        acquisitionTime.hashCode;
  }
}

class NmeaChunkImpl extends SenseDataImpl implements NmeaChunk {
  NmeaChunkImpl({
    required super.type,
    required super.acquisitionTime,
    required this.nmeaChunk,
  });

  factory NmeaChunkImpl.fromJson(final Map<String, dynamic> json) {
    return NmeaChunkImpl(
      type: DataTypeExtension.fromId(json['senseDataType']),
      acquisitionTime: DateTime.fromMillisecondsSinceEpoch(
        json['acquisitionTimestamp'],
        isUtc: true,
      ),
      nmeaChunk: json['nmeaChunk'],
    );
  }

  @override
  String nmeaChunk;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['senseDataType'] = type.id;
    json['acquisitionTimestamp'] = acquisitionTime.millisecondsSinceEpoch;

    json['nmeaChunk'] = nmeaChunk;

    return json;
  }

  @override
  bool operator ==(covariant final NmeaChunk other) {
    return nmeaChunk == other.nmeaChunk &&
        acquisitionTime.millisecondsSinceEpoch ==
            other.acquisitionTime.millisecondsSinceEpoch;
  }

  @override
  int get hashCode {
    return nmeaChunk.hashCode ^ acquisitionTime.hashCode;
  }
}

/// @nodoc
class ActivityImpl extends SenseDataImpl implements Activity {
  ActivityImpl({
    required super.type,
    required super.acquisitionTime,
    required this.activityType,
    required this.confidence,
  });

  factory ActivityImpl.fromJson(final Map<String, dynamic> json) {
    return ActivityImpl(
      type: DataTypeExtension.fromId(json['senseDataType']),
      acquisitionTime: DateTime.fromMillisecondsSinceEpoch(
        json['acquisitionTimestamp'],
        isUtc: true,
      ),
      activityType: ActivityTypeExtension.fromId(json['activity']),
      confidence: ActivityConfidenceExtension.fromId(json['confidence']),
    );
  }

  @override
  ActivityType activityType;

  @override
  ActivityConfidence confidence;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['senseDataType'] = type.id;
    json['acquisitionTimestamp'] = acquisitionTime.millisecondsSinceEpoch;

    json['activity'] = activityType.id;
    json['confidence'] = confidence.id;

    return json;
  }

  @override
  bool operator ==(covariant final Activity other) {
    return activityType == other.activityType &&
        confidence == other.confidence &&
        acquisitionTime.millisecondsSinceEpoch ==
            other.acquisitionTime.millisecondsSinceEpoch;
  }

  @override
  int get hashCode {
    return activityType.hashCode ^
        confidence.hashCode ^
        acquisitionTime.hashCode;
  }
}

/// @nodoc
SenseData senseFromJson(final Map<String, dynamic> json) {
  final DataType type = DataTypeExtension.fromId(json['senseDataType']);

  switch (type) {
    case DataType.acceleration:
      return AccelerationImpl.fromJson(json);
    case DataType.activity:
      return ActivityImpl.fromJson(json);
    case DataType.attitude:
      return AttitudeImpl.fromJson(json);
    case DataType.battery:
      return BatteryImpl.fromJson(json);
    case DataType.camera:
      throw UnimplementedError();
    //return CameraImpl.fromJson(json);
    case DataType.compass:
      return CompassImpl.fromJson(json);
    case DataType.magneticField:
      return MagneticFieldImpl.fromJson(json);
    case DataType.orientation:
      return OrientationImpl.fromJson(json);
    case DataType.position:
      return GemPositionImpl.fromJson(json);
    case DataType.improvedPosition:
      return GemImprovedPositionImpl.fromJson(json);
    case DataType.rotationRate:
      return RotationRateImpl.fromJson(json);
    case DataType.temperature:
      return TemperatureImpl.fromJson(json);
    case DataType.notification:
      throw UnimplementedError();
    //return NotificationImpl.fromJson(json);
    case DataType.mountInformation:
      return MountInformationImpl.fromJson(json);
    case DataType.heartRate:
      return HeartRateImpl.fromJson(json);
    case DataType.nmeaChunk:
      return NmeaChunkImpl.fromJson(json);
    case DataType.unknown:
      return SenseDataImpl.fromJson(json);
    case DataType.gyroscope:
      return RotationRateImpl.fromJson(json);
  }
}
