// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'dart:ui' show Color;

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/extensions.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// File format of the scene object
///
/// {@category Maps & 3D Scene}
enum SceneObjectFileFormat {
  /// Wavefront obj
  obj,

  /// Wavefront material
  mat,

  /// Wavefront texture
  tex,

  /// glTF format
  gltf,
}

/// @nodoc
extension SceneObjectFileFormatExtension on SceneObjectFileFormat {
  int get id {
    switch (this) {
      case SceneObjectFileFormat.obj:
        return 0;
      case SceneObjectFileFormat.mat:
        return 1;
      case SceneObjectFileFormat.tex:
        return 2;
      case SceneObjectFileFormat.gltf:
        return 3;
    }
  }

  static SceneObjectFileFormat fromId(final int id) {
    switch (id) {
      case 0:
        return SceneObjectFileFormat.obj;
      case 1:
        return SceneObjectFileFormat.mat;
      case 2:
        return SceneObjectFileFormat.tex;
      case 3:
        return SceneObjectFileFormat.gltf;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Maps scene object
///
/// This class should not be instantiated directly. Instead, use the [getDefPositionTracker] method to obtain an instance.
///
/// {@category Maps & 3D Scene}
class MapSceneObject {
  // ignore: unused_element
  MapSceneObject._()
      : _pointerId = -1,
        _mapId = -1;

  @internal
  MapSceneObject.init(final int id, final int mapId)
      : _pointerId = id,
        _mapId = mapId;
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  /// Customize default SDK position tracking object.
  ///
  /// To apply a flat texture to the position tracking object, provide only data in the [SceneObjectFileFormat.tex] format as input.
  ///
  /// **Parameters**
  ///
  /// * **IN** *buffer* The object data. Provide empty list to load default SDK resource
  /// * **IN** *format* The format of the object data
  ///
  /// **Returns**
  ///
  /// * The error code
  static GemError customizeDefPositionTracker(
    final List<int> buffer,
    final SceneObjectFileFormat format,
  ) {
    final OperationResult resultString = objectMethod(
      0,
      'MapSceneObject',
      'customizeDefPositionTracker',
      args: <String, Object>{'buffer': buffer, 'format': format.id},
    );

    final int gemApiError = resultString['gemApiError'];

    return GemErrorExtension.fromCode(gemApiError);
  }

  /// Get default SDK position tracked object
  ///
  /// The SDK automatically creates a position tracker object after receiving at least one location update.
  ///
  /// The default position tracker automatically updates from current sense data source from PositionService
  ///
  /// By default it is visible, can be hidden by a call to setVisibility( false )
  static MapSceneObject getDefPositionTracker() {
    final OperationResult resultString = objectMethod(
      0,
      'MapSceneObject',
      'getDefPositionTracker',
    );

    return MapSceneObject.init(resultString['result'], 0);
  }

  /// Set SDK position tracking accuracy circle color
  ///
  /// **Parameters**
  ///
  /// * **IN** *color* The accuracy circle custom color
  ///
  /// **Returns**
  ///
  /// * The error code
  static GemError setDefPositionTrackerAccuracyCircleColor(final Color color) {
    final OperationResult resultString = objectMethod(
      0,
      'MapSceneObject',
      'setDefPositionTrackerAccuracyCircleColor',
      args: <String, int>{
        'a': (color.a * 255).toInt(),
        'r': (color.r * 255).toInt(),
        'g': (color.g * 255).toInt(),
        'b': (color.b * 255).toInt(),
      },
    );

    final int gemApiError = resultString['gemApiError'];
    return GemErrorExtension.fromCode(gemApiError);
  }

  /// Reset the default SDK position tracked object to the default color
  ///
  /// **Returns**
  ///
  /// * The error code
  static GemError resetDefPositionTrackerAccuracyCircleColor() {
    return setDefPositionTrackerAccuracyCircleColor(
      const Color.fromARGB(255, 51, 153, 255),
    );
  }

  /// Get SDK position tracking accuracy circle color
  ///
  /// **Returns**
  ///
  /// * The accuracy circle custom color
  static Color getDefPositionTrackerAccuracyCircleColor() {
    final OperationResult resultString = objectMethod(
      0,
      'MapSceneObject',
      'getDefPositionTrackerAccuracyCircleColor',
    );

    final dynamic result = resultString['result'];
    return ColorExtension.fromJson(result);
  }

  /// Object coordinates in main object coordinate system
  Coordinates get coordinates {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapSceneObject',
      'getCoordinates',
    );

    return Coordinates.fromJson(resultString['result']);
  }

  /// Object scale factor
  set scale(final double scale) {
    objectMethod(_pointerId, 'MapSceneObject', 'setScaleFactor', args: scale);
  }

  /// Object scale factor
  double get scale {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapSceneObject',
      'getScaleFactor',
    );

    return resultString['result'];
  }

  /// Max scale factor
  double get maxScale {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapSceneObject',
      'getMaxScaleFactor',
    );

    return resultString['result'];
  }

  /// Object orientation
  Point4d get orientation {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapSceneObject',
      'getOrientation',
    );

    return Point4d.fromJson(resultString['result']);
  }

  /// Object visibility
  set visibility(final bool vis) {
    objectMethod(_pointerId, 'MapSceneObject', 'setVisibility', args: vis);
  }

  /// Object visibility
  bool get visibility {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapSceneObject',
      'getVisibility',
    );

    return resultString['result'];
  }
}
