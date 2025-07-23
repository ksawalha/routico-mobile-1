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

import 'package:gem_kit/src/core/coordinates.dart';
import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/types.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// {@category Maps & 3D Scene}
///
/// This class should not be instantiated directly. Instead, use the [GemView.camera] getter to obtain an instance.
///
/// Map Camera class
class MapCamera {
  // ignore: unused_element
  MapCamera._()
      : _pointerId = -1,
        _mapId = -1;

  @internal
  MapCamera.init(final int id, final int mapId)
      : _pointerId = id,
        _mapId = mapId;
  final int _pointerId;
  final int _mapId;
  int get pointerId => _pointerId;
  int get mapId => _mapId;

  /// Saves the current state of the camera into a binary format.
  ///
  /// **Returns**
  ///
  /// * The binary representation of the camera's current state.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Uint8List get cameraState {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapCamera',
      'saveCameraState',
    );

    return base64Decode(resultString['result']);
  }

  /// Retrieves the current orientation of the camera.
  ///
  /// **Returns**
  ///
  /// * A [Point4d] representing the current (x,y,z,w) orientation of the camera.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Point4d get orientation {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapCamera',
      'getOrientation',
    );

    return Point4d.fromJson(resultString['result']);
  }

  /// Retrieves the current position of the camera.
  ///
  /// **Returns**
  ///
  /// * A [Point3d] representing the current (x,y,z) position of the camera.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Point3d get position {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapCamera',
      'getPosition',
    );

    return Point3d.fromJson(resultString['result']);
  }

  /// Restores the camera's state from a previously saved binary format.
  ///
  /// **Parameters**
  ///
  /// * **IN** *state* The binary representation of the camera's current state.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set cameraState(final Uint8List state) {
    objectMethod(
      _pointerId,
      'MapCamera',
      'restoreCameraState',
      args: base64Encode(state),
    );
  }

  /// Sets the camera's orientation using quaternion values.
  ///
  /// **Parameters**
  ///
  /// * **IN** *orient* A [Point4d] representing the new (x,y,z,w) orientation of the camera.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set orientation(final Point4d orient) {
    objectMethod(_pointerId, 'MapCamera', 'setOrientation', args: orient);
  }

  /// Sets the camera's position in a 3D space.
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* A [Point3d] representing the new (x,y,z) position of the camera.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set position(final Point3d pos) {
    objectMethod(_pointerId, 'MapCamera', 'setPosition', args: pos);
  }

  /// Set camera longitude, latitude position in degrees, with respect to surface of focused sphere, altitude in meters above sphere (sea level), oriented toward the center of the sphere, north up.
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* [Coordinates] representing the desired longitude, latitude and altitude of the camera.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set cameraPosition(final Coordinates pos) {
    objectMethod(_pointerId, 'MapCamera', 'setCameraPosition', args: pos);
  }

  /// Set camera orientation, with respect to surface of focused sphere, and current camera position, using heading in degrees (0=N, 90=E, 180=S, 270=W).
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* [Point3d] representing the desired heading, pitch and roll.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set cameraOrientation(final Point3d pos) {
    objectMethod(_pointerId, 'MapCamera', 'setCameraOrientation', args: pos);
  }

  /// Set camera looking toward a target position, all in the coordinate system of the focused sphere.
  ///
  /// Target coordinates are longitude, latitude position in degrees, with respect to the focused sphere surface, altitude in meters above the sphere (sea level).
  ///
  /// The camera is centered on the target, at the specified distance in meters from the target, heading (0=N, 90=E, 180=S, 270=W) with respect to the focused sphere, and pitch (0=looking toward the target center from above the target, 90=looking at the target center from the horizontal plane/equator of the target, which is the plane containing the target forward and right vectors). The roll is always 0, so the horizon is level.
  ///
  /// See [generatePositionAndOrientationTargetCentered].
  ///
  /// **Parameters**
  ///
  /// * **IN** *targetCoords* [Coordinates] representing the desired latitude, longitude and altitude.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setCameraTargetCentered(final Coordinates coords, final Point3d pos) {
    objectMethod(
      _pointerId,
      'MapCamera',
      'setCameraTargetCentered',
      args: <String, Object>{'coordinates': coords, 'tuple3D': pos},
    );
  }

  /// Set camera looking toward a target position, all in the coordinate system of the focused target.
  ///
  /// Target coordinates are lon, lat position in degrees, with respect to the focused sphere surface, altitude in meters above the sphere.
  ///
  /// The camera is centered on the target, at the specified distance in meters from the target, heading (0=looking at the target from behind it, in the direction of the target's heading, 90=looking at the target from its right/starboard side, 180=looking at the target from the front, 270=looking at the target from its left/port side) with respect to the focused target, and pitch (0=looking toward the target center from above the target, 90=looking at the target center from the horizontal plane/equator of the target, which is the plane containing the target forward and right vectors, 180=looking at the target from below). The roll is always 0, so the horizon is level.
  ///
  /// See [generatePositionAndOrientationRelativeToCenteredTarget].
  ///
  /// **Parameters**
  ///
  /// * **IN** *targetCoords* [Coordinates] representing the desired latitude, longitude and altitude.
  /// * **IN** *targetHeadingPitchRollDeg* [Point3d] representing the desired latitude, longitude and altitude.
  /// * **IN** *cameraHeadingPitchDegDistanceMeters* [Point3d] representing the desired latitude, longitude and altitude.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setCameraRelativeToCenteredTarget(
    final Coordinates targetCoords,
    final Point3d targetHeadingPitchRollDeg,
    final Point3d cameraHeadingPitchDegDistanceMeters,
  ) {
    objectMethod(
      _pointerId,
      'MapCamera',
      'setCameraRelativeToCenteredTarget',
      args: <String, Object>{
        'coordinates': targetCoords,
        'tuple3D1': targetHeadingPitchRollDeg,
        'tuple3D2': cameraHeadingPitchDegDistanceMeters,
      },
    );
  }

  /// Set camera relative to a target position, looking in any direction relative to the direction toward the target, all in the coordinate system of the focused target.
  ///
  /// This function is the same as [setCameraRelativeToCenteredTarget], except the camera can be oriented in a direction other than centered on the target.
  ///
  /// The camera is centered on the target when the 4th parameter, the camera/observer heading, pitch, roll = 0, 0, 0. A nonzero heading, in degrees, specifies a rotation about the observer/camera up axis, going through the observer/camera position. A nonzero pitch, in degrees, specifies a rotation about the observer/camera right axis, going through the observer/camera position. A nonzero roll, in degrees, specifies a rotation about the observer/camera forward vector.
  ///
  /// See [generatePositionAndOrientationRelativeToTarget].
  ///
  /// **Parameters**
  ///
  /// * **IN** *targetCoords* [Coordinates] representing the desired latitude, longitude and altitude.
  /// * **IN** *targetHeadingPitchRollDeg* [Point3d] representing the desired latitude, longitude and altitude.
  /// * **IN** *cameraHeadingPitchDegDistanceMeters* [Point3d] representing the desired latitude, longitude and altitude.
  /// * **IN** *cameraHeadingPitchRollDeg* [Point3d] representing the desired latitude, longitude and altitude.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setCameraRelativeToTarget(
    final Coordinates targetCoords,
    final Point3d targetHeadingPitchRollDeg,
    final Point3d cameraHeadingPitchDegDistanceMeters,
    final Point3d cameraHeadingPitchRollDeg,
  ) {
    objectMethod(
      _pointerId,
      'MapCamera',
      'setCameraRelativeToTarget',
      args: <String, Object>{
        'coordinates': targetCoords,
        'tuple3D1': targetHeadingPitchRollDeg,
        'tuple3D2': cameraHeadingPitchDegDistanceMeters,
        'tuple3D3': cameraHeadingPitchRollDeg,
      },
    );
  }

  /// Generate a position at longitude, latitude in degrees, with respect to surface of focused sphere, altitude in meters above sphere (sea level), oriented toward the center of the sphere, north up.
  ///
  /// The camera position and orientation are unchanged. The camera or any other object can then be set at the resulting position and with the resulting orientation.
  ///
  /// **Parameters**
  ///
  /// * **IN** *targetCoords* [Coordinates] representing the desired latitude, longitude and altitude.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  /// * The computed position and orientation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  (GemError, PositionOrientation) generatePositionAndOrientation(
    final Coordinates targetCoords,
  ) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapCamera',
      'generatePositionAndOrientation',
      args: targetCoords,
    );

    return (
      GemErrorExtension.fromCode(resultString['result']['errorCode']),
      PositionOrientation(
        position: Point3d.fromJson(resultString['result']['tuple3D']),
        orientation: Point4d.fromJson(resultString['result']['tuple4D']),
      ),
    );
  }

  /// Generate a position at longitude, latitude in degrees, with respect to surface of focused sphere, altitude in meters above sphere (sea level), oriented toward the specified heading, pitch and roll.
  ///
  /// The heading is 0 deg=North with respect to the focused sphere, 90 deg=East, 180 deg=South, 270 deg or -90 deg=west.
  ///
  /// Pitch is 0 deg=the object (or camera) forward vector looking toward the center of the focused sphere, 90 deg=looking at horizon.
  ///
  /// Roll is a rotation about the forward vector, positive deg to the left and negative deg to the right.
  ///
  /// The camera position and orientation are unchanged. The camera or any other object can then be set at the resulting position and with the resulting orientation.
  ///
  /// **Parameters**
  ///
  /// * **IN** *targetCoords* [Coordinates] representing the desired latitude, longitude and altitude.
  /// * **IN** *headingPitchRollDeg* [Point3d] representing the desired heading, pitch and roll.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  /// * The computed position and orientation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  (GemError, PositionOrientation) generatePositionAndOrientationHPR(
    final Coordinates targetCoords,
    final Point3d headingPitchRollDeg,
  ) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapCamera',
      'generatePositionAndOrientation',
      args: <String, Object>{
        'coordinates': targetCoords,
        'tuple3D': headingPitchRollDeg,
      },
    );

    return (
      GemErrorExtension.fromCode(resultString['result']['errorCode']),
      PositionOrientation(
        position: Point3d.fromJson(resultString['result']['tuple3D']),
        orientation: Point4d.fromJson(resultString['result']['tuple4D']),
      ),
    );
  }

  /// Generate a position and orientation relative to, and oriented toward/centered on, a target position which is relative to the focused sphere (orientation relative to sphere).
  ///
  /// The specified target position is at lon,lat in degrees, with respect to surface of the focused sphere, altitude in meters above sphere (sea level).
  ///
  /// The target position does not have an orientation, so it can be considered a point.
  ///
  /// The generated orientation is toward the target position, where heading in degrees (0=N, 90=E, 180=S, 270=W) is with respect to the surface of the focused sphere, so heading 0 is looking at the target toward the north, from a position south of the target (the generated position is at 180 degrees as seen from the target).
  ///
  /// Pitch in degrees (0=looking toward the target center from above the target, 90=looking at the target center from the horizontal plane/equator of the target, which is the plane containing the target forward and right vectors). The roll is always 0, so the horizon is level.
  ///
  /// The generated position is at the specified distance in meters from the target center.
  ///
  /// The camera position and orientation are unchanged. The camera or any other object can then be set at the resulting position and with the resulting orientation.
  ///
  /// **Parameters**
  ///
  /// * **IN** *targetCoords* [Coordinates] representing the desired latitude, longitude and altitude.
  /// * **IN** *cameraHeadingPitchDegDistanceMeters* [Point3d] desired heading pitch and distance for camera.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  /// * The computed position and orientation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  (GemError, PositionOrientation) generatePositionAndOrientationTargetCentered(
    final Coordinates targetCoords,
    final Point3d cameraHeadingPitchDegDistanceMeters,
  ) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapCamera',
      'generatePositionAndOrientationTargetCentered',
      args: <String, Object>{
        'coordinates': targetCoords,
        'tuple3D': cameraHeadingPitchDegDistanceMeters,
      },
    );

    return (
      GemErrorExtension.fromCode(resultString['result']['errorCode']),
      PositionOrientation(
        position: Point3d.fromJson(resultString['result']['tuple3D']),
        orientation: Point4d.fromJson(resultString['result']['tuple4D']),
      ),
    );
  }

  /// Generate a position and orientation relative to, and oriented toward/centered on, a target position which is relative to the focused sphere (orientation relative to target).
  ///
  /// The target has the specified orientation where heading in degrees (0=N, 90=E, 180=S, 270=W) is with respect to the surface of the focused sphere, pitch in degrees (0=the target forward vector is oriented to the center of the focused sphere, 90=the target forward vector is oriented toward the horizon), and roll in degrees about the target forward vector, positive to the left and negative to the right.
  ///
  /// The generated orientation is toward, and with respect to, the target position, where heading in degrees (0=in the direction of the target heading, 90=looking at the target from its right/starboard side, 180=looking at the target from the front, 270=looking at the target from its left/port side).
  ///
  /// Pitch in degrees (0=looking toward the target center from above the target, 90=looking at the target center from the horizontal plane/equator of the target, which is the plane containing the target forward and right vectors, 180=looking at the target from below). The roll is always 0, so the horizon is level.
  ///
  /// The generated position is at the specified distance in meters from the target center.
  /// The camera position and orientation are unchanged. The camera or any other object can then be set at the resulting position and with the resulting orientation.
  ///
  /// **Parameters**
  ///
  /// * **IN** *targetCoords* [Coordinates] representing the desired latitude, longitude and altitude.
  /// * **IN** *targetHeadingPitchRollDeg* [Point3d] representing the desired heading, pitch and roll.
  /// * **IN** *cameraHeadingPitchDegDistanceMeters* [Point3d] desired heading pitch and distance for camera.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  /// * The computed position and orientation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  (GemError, PositionOrientation)
      generatePositionAndOrientationRelativeToCenteredTarget(
    final Coordinates targetCoords,
    final Point3d targetHeadingPitchRollDeg,
    final Point3d cameraHeadingPitchDegDistanceMeters,
  ) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapCamera',
      'generatePositionAndOrientationRelativeToCenteredTarget',
      args: <String, Object>{
        'coordinates': targetCoords,
        'tuple3D1': targetHeadingPitchRollDeg,
        'tuple3D2': cameraHeadingPitchDegDistanceMeters,
      },
    );

    return (
      GemErrorExtension.fromCode(resultString['result']['errorCode']),
      PositionOrientation(
        position: Point3d.fromJson(resultString['result']['tuple3D']),
        orientation: Point4d.fromJson(resultString['result']['tuple4D']),
      ),
    );
  }

  /// Generate a position and orientation relative to a target position, looking in any direction relative to the direction toward the target, all in the coordinate system of the focused target.
  ///
  /// This function is the same as GeneratePositionAndOrientationRelativeToCenteredTarget, except the orientation can be in a direction other than centered on the target.
  /// The orientation is centered on the target when the 4th parameter, the camera/observer heading, pitch, roll = 0, 0, 0. A nonzero heading, in degrees, specifies a rotation about the observer/camera up axis, going through the observer/camera position. A nonzero pitch, in degrees, specifies a rotation about the observer/camera right axis, going through the observer/camera position. A nonzero roll, in degrees, specifies a rotation about the observer/camera forward vector.
  ///
  /// See [generatePositionAndOrientationRelativeToCenteredTarget].
  ///
  /// **Parameters**
  ///
  /// * **IN** *targetCoords* [Coordinates] representing the desired latitude, longitude and altitude.
  /// * **IN** *targetHeadingPitchRollDeg* [Point3d] representing the desired heading, pitch and roll.
  /// * **IN** *cameraHeadingPitchDegDistanceMeters* [Point3d] desired heading pitch and distance for camera.
  /// * **IN** *cameraHeadingPitchRollDeg* [Point3d] desired heading pitch and roll for camera.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  /// * The computed position and orientation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  (GemError, PositionOrientation)
      generatePositionAndOrientationRelativeToTarget(
    final Coordinates targetCoords,
    final Point3d targetHeadingPitchRollDeg,
    final Point3d cameraHeadingPitchDegDistanceMeters,
    final Point3d cameraHeadingPitchRollDeg,
  ) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapCamera',
      'generatePositionAndOrientationRelativeToTarget',
      args: <String, Object>{
        'coordinates': targetCoords,
        'tuple3D1': targetHeadingPitchRollDeg,
        'tuple3D2': cameraHeadingPitchDegDistanceMeters,
        'tuple3D3': cameraHeadingPitchRollDeg,
      },
    );

    return (
      GemErrorExtension.fromCode(resultString['result']['errorCode']),
      PositionOrientation(
        position: Point3d.fromJson(resultString['result']['tuple3D']),
        orientation: Point4d.fromJson(resultString['result']['tuple4D']),
      ),
    );
  }
}
