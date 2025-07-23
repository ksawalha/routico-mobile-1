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
import 'dart:math';
import 'dart:typed_data';

import 'package:gem_kit/routing.dart';
import 'package:gem_kit/src/contentstore/content_store_item.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/path.dart';
import 'package:gem_kit/src/core/types.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/gem_kit_view.dart';
import 'package:gem_kit/src/landmarkstore/landmark_store_collection.dart';
import 'package:gem_kit/src/map/map_scene.dart';
import 'package:gem_kit/src/map/markers.dart';
import 'package:meta/meta.dart';

/// OverlayCollection for a MapView object.
///
/// This class should not be instantiated directly. Instead, use the [MapViewPreferences.overlays] getter to obtain an instance.
///
/// {@category Maps & 3D Scene}
class MapViewOverlayCollection {
  // ignore: unused_element
  MapViewOverlayCollection._()
      : _pointerId = -1,
        _mapId = -1;

  @internal
  MapViewOverlayCollection.init(final int id, final int mapId)
      : _pointerId = id,
        _mapId = mapId;
  final int _pointerId;
  final int _mapId;
  int get pointerId => _pointerId;
  int get mapId => _mapId;
}

/// The type of animation.
///
/// {@category Maps & 3D Scene}
enum AnimationType {
  /// No animation
  none,

  /// Linear animation
  linear,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension AnimationTypeExtension on AnimationType {
  int get id {
    switch (this) {
      case AnimationType.none:
        return 0;
      case AnimationType.linear:
        return 1;
    }
  }

  static AnimationType fromId(final int id) {
    switch (id) {
      case 0:
        return AnimationType.none;
      case 1:
        return AnimationType.linear;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Perspectives in which the map is viewed
///
/// {@category Maps & 3D Scene}
enum MapViewPerspective {
  /// Two dimensional
  twoDimensional,

  /// Three dimensional
  threeDimensional,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension MapViewPerspectiveExtension on MapViewPerspective {
  int get id {
    switch (this) {
      case MapViewPerspective.twoDimensional:
        return 0;
      case MapViewPerspective.threeDimensional:
        return 1;
    }
  }

  static MapViewPerspective fromId(final int id) {
    switch (id) {
      case 0:
        return MapViewPerspective.twoDimensional;
      case 1:
        return MapViewPerspective.threeDimensional;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Map details quality levels
///
/// {@category Maps & 3D Scene}
enum MapDetailsQualityLevel {
  /// Low quality details
  low,

  /// Medium quality details
  medium,

  /// High quality details (default)
  high,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension MapDetailsQualityLevelExtension on MapDetailsQualityLevel {
  int get id {
    switch (this) {
      case MapDetailsQualityLevel.low:
        return 0;
      case MapDetailsQualityLevel.medium:
        return 1;
      case MapDetailsQualityLevel.high:
        return 2;
    }
  }

  static MapDetailsQualityLevel fromId(final int id) {
    switch (id) {
      case 0:
        return MapDetailsQualityLevel.low;
      case 1:
        return MapDetailsQualityLevel.medium;
      case 2:
        return MapDetailsQualityLevel.high;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Follow position map rotation mode
///
/// {@category Maps & 3D Scene}
enum FollowPositionMapRotationMode {
  /// Use position sensor heading for map rotation
  positionHeading,

  /// Use compass sensor for map rotation
  compass,

  /// Use fixed map rotation angle
  fixed,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension FollowPositionMapRotationModeExtension
    on FollowPositionMapRotationMode {
  int get id {
    switch (this) {
      case FollowPositionMapRotationMode.positionHeading:
        return 0;
      case FollowPositionMapRotationMode.compass:
        return 1;
      case FollowPositionMapRotationMode.fixed:
        return 2;
    }
  }

  static FollowPositionMapRotationMode fromId(final int id) {
    switch (id) {
      case 0:
        return FollowPositionMapRotationMode.positionHeading;
      case 1:
        return FollowPositionMapRotationMode.compass;
      case 2:
        return FollowPositionMapRotationMode.fixed;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Touch gestures list
///
/// {@category Maps & 3D Scene}
enum TouchGestures {
  /// Single pointer touch event (down and up with negligible move) - not used - could be used for selection.
  onTouch,

  /// Single pointer long touch event - put a marker on the map.
  onLongDown,

  /// Single pointer double touch event - zoom in.
  onDoubleTouch,

  /// Two pointers single touch event - zoom out.
  onTwoPointersTouch,

  /// Two pointers double touch event - autocenter the globe.
  onTwoPointersDoubleTouch,

  /// Single pointer move event - pan.
  onMove,

  /// Single pointer touch event followed immediately by a vertical move/pan event = single pointer zoom in/out.
  onTouchMove,

  /// Single pointer linear swipe event - move/pan with pointer moving when lifted, in the dXInPix, dYInPix direction.
  onSwipe,

  /// Two pointer zooming swipe event - one or both pointers moving when lifted during pinch zoom, causing motion to continue for a while.
  onPinchSwipe,

  /// Two pointers pinch (pointers moving toward or away from each other) event - can include zoom and shove (2-pointer pan) but no rotate.
  onPinch,

  /// Two pointers rotate event - can include zoom and shove (distance between 2 pointers remains constant while line connecting them moves or rotates).
  onRotate,

  /// Two pointers shove event(2-pointer pan - pointers moving in the same direction the same distance) - can include rotate and zoom.
  onShove,

  /// Two pointers touch event followed immediately by a pinch event - not used.
  onTouchPinch,

  /// Two pointers touch event followed immediately by a rotate event - not used.
  onTouchRotate,

  /// Two pointers touch event followed immediately by a shove event - not used.
  onTouchShove,

  /// Two pointer rotating swipe event - one or both pointers moving when lifted during pinch rotate, causing motion to continue for a while.
  onRotatingSwipe,

  /// Allow internal event processing - if disabled, only send notifications to external listeners (UI)
  internalProcessing,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension TouchGesturesExtension on TouchGestures {
  int get id {
    switch (this) {
      case TouchGestures.onTouch:
        return 256;
      case TouchGestures.onLongDown:
        return 512;
      case TouchGestures.onDoubleTouch:
        return 1024;
      case TouchGestures.onTwoPointersTouch:
        return 2048;
      case TouchGestures.onTwoPointersDoubleTouch:
        return 4096;
      case TouchGestures.onMove:
        return 8192;
      case TouchGestures.onTouchMove:
        return 16384;
      case TouchGestures.onSwipe:
        return 32768;
      case TouchGestures.onPinchSwipe:
        return 65536;
      case TouchGestures.onPinch:
        return 131072;
      case TouchGestures.onRotate:
        return 262144;
      case TouchGestures.onShove:
        return 524288;
      case TouchGestures.onTouchPinch:
        return 1048576;
      case TouchGestures.onTouchRotate:
        return 2097152;
      case TouchGestures.onTouchShove:
        return 4194304;
      case TouchGestures.onRotatingSwipe:
        return 8388608;
      case TouchGestures.internalProcessing:
        return 2147483648;
    }
  }

  static TouchGestures fromId(final int id) {
    switch (id) {
      case 256:
        return TouchGestures.onTouch;
      case 512:
        return TouchGestures.onLongDown;
      case 1024:
        return TouchGestures.onDoubleTouch;
      case 2048:
        return TouchGestures.onTwoPointersTouch;
      case 4096:
        return TouchGestures.onTwoPointersDoubleTouch;
      case 8192:
        return TouchGestures.onMove;
      case 16384:
        return TouchGestures.onTouchMove;
      case 32768:
        return TouchGestures.onSwipe;
      case 65536:
        return TouchGestures.onPinchSwipe;
      case 131072:
        return TouchGestures.onPinch;
      case 262144:
        return TouchGestures.onRotate;
      case 524288:
        return TouchGestures.onShove;
      case 1048576:
        return TouchGestures.onTouchPinch;
      case 2097152:
        return TouchGestures.onTouchRotate;
      case 4194304:
        return TouchGestures.onTouchShove;
      case 8388608:
        return TouchGestures.onRotatingSwipe;
      case 2147483648:
        return TouchGestures.internalProcessing;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Buildings visibility modes
///
/// {@category Maps & 3D Scene}
enum BuildingsVisibility {
  /// Use default visibility settings
  defaultVisibility,

  /// Hide
  hide,

  /// Show 2D (flat)
  twoDimensional,

  /// Show 3D
  threeDimensional,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension BuildingsVisibilityExtension on BuildingsVisibility {
  int get id {
    switch (this) {
      case BuildingsVisibility.defaultVisibility:
        return 0;
      case BuildingsVisibility.hide:
        return 1;
      case BuildingsVisibility.twoDimensional:
        return 2;
      case BuildingsVisibility.threeDimensional:
        return 3;
    }
  }

  static BuildingsVisibility fromId(final int id) {
    switch (id) {
      case 0:
        return BuildingsVisibility.defaultVisibility;
      case 1:
        return BuildingsVisibility.hide;
      case 2:
        return BuildingsVisibility.twoDimensional;
      case 3:
        return BuildingsVisibility.threeDimensional;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Follow position preferences class
///
/// This class should not be instantiated directly. Instead, use the [MapViewPreferences.followPositionPreferences] getter to obtain an instance.
///
/// {@category Maps & 3D Scene}
class FollowPositionPreferences extends GemAutoreleaseObject {
  // ignore: unused_element
  FollowPositionPreferences._()
      : _pointerId = -1,
        _mapId = -1;

  @internal
  FollowPositionPreferences.init(final int id, final int mapId)
      : _pointerId = id,
        _mapId = mapId {
    super.registerAutoReleaseObject(id);
  }
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  /// Get the follow position camera focus in viewport coordinates ( between 0.f = left / top and 1.f = right / bottom )
  ///
  /// **Returns**
  ///
  /// * The camera focus position
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Point<double> get cameraFocus {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'getCameraFocus',
    );

    return XyType<double>.fromJson(resultString['result']).toPoint();
  }

  /// Get the map view perspective in follow position mode.
  ///
  /// **Returns**
  ///
  /// * The map perspective
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MapViewPerspective get perspective {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'getPerspective',
    );

    return MapViewPerspectiveExtension.fromId(resultString['result']);
  }

  /// Get the time interval before starting a turn presentation.
  ///
  /// **Returns**
  ///
  /// * The time interval in seconds.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get timeBeforeTurnPresentation {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'getTimeBeforeTurnPresentation',
    );

    return resultString['result'];
  }

  /// Check whether manually exiting follow position via touch handler events is enabled.
  ///
  /// Default value is true.
  ///
  /// **Returns**
  ///
  /// * True if exiting follow position is allowed, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get touchHandlerExitAllow {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'getTouchHandlerExitAllow',
    );

    return resultString['result'];
  }

  /// Test whether manually adjusted follow position changes (via touch handler) are persistent.
  ///
  /// **Returns**
  ///
  /// * True if changes are persistent, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get touchHandlerModifyPersistent {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'getTouchHandlerModifyPersistent',
    );

    return resultString['result'];
  }

  /// Get touch handler horizontal angle adjust limits. Empty { 0., 0. } means that value adjustment is forbidden.
  ///
  /// Returns { 0., 0. } by default, meaning adjustment is forbidden.
  ///
  /// **Returns**
  ///
  /// * The horizontal angle adjust limits.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  (double, double) get touchHandlerModifyHorizontalAngleLimits {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'getTouchHandlerModifyHorizontalAngleLimits',
    );

    final Map<String, dynamic> result =
        resultString['result'] as Map<String, dynamic>;
    final double first = result['first'];
    final double second = result['second'];

    return (first, second);
  }

  /// Get touch handler vertical angle adjust limits. Empty { 0., 0. } means value adjustment is forbidden.
  ///
  /// Returns { 0., 0. } by default, meaning adjustment is forbidden.
  ///
  /// **Returns**
  ///
  /// * The vertical angle adjust limits.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  (double, double) get touchHandlerModifyVerticalAngleLimits {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'getTouchHandlerModifyVerticalAngleLimits',
    );

    final Map<String, dynamic> result =
        resultString['result'] as Map<String, dynamic>;
    final double first = result['first'];
    final double second = result['second'];

    return (first, second);
  }

  /// Get touch handler distance to object adjust limits.
  ///
  /// Returns { 50, double.infinity } by default, meaning no limits in max distance to tracked object.
  ///
  /// **Returns**
  ///
  /// * The distance adjust limits.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  (double, double) get touchHandlerModifyDistanceLimits {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'getTouchHandlerModifyDistanceLimits',
    );

    final Map<String, dynamic> result =
        resultString['result'] as Map<String, dynamic>;
    final double first = result['first'];
    final double second = result['second'];

    return (first, second);
  }

  /// Get the vertical angle.
  ///
  /// **Returns**
  ///
  /// * The view angle
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get viewAngle {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'getViewAngle',
    );

    return resultString['result'];
  }

  /// Get a zoom level in follow position mode.
  ///
  /// -1 means auto-zooming is enabled.
  ///
  /// **Returns**
  ///
  /// * The current zoom level.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get zoomLevel {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'getZoomLevel',
    );

    return resultString['result'];
  }

  /// Check if accuracy circle is visible.
  ///
  /// **Returns**
  ///
  /// * True if the accuracy circle is visible, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get accuracyCircleVisibility {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'isAccuracyCircleVisible',
    );

    return resultString['result'];
  }

  /// Check if position tracking object rotation follows map rotation.
  ///
  /// **Returns**
  ///
  /// * True if the position tracking object rotation follows map rotation, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isTrackObjectFollowingMapRotation {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'isTrackObjectFollowingMapRotation',
    );

    return resultString['result'];
  }

  /// Set accuracy circle visibility.
  ///
  /// The circle color can be customized using the methods provided by the [MapSceneObject] class.
  ///
  /// **Parameters**
  ///
  /// * **IN** *isVisible* True to show the accuracy circle
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.notFound] if the map object does not exist
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError setAccuracyCircleVisibility(final bool isVisible) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'setAccuracyCircleVisibility',
      args: isVisible,
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Set the follow position camera focus in viewport coordinates ( between 0.f = left / top and 1.f = right / bottom )
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* The camera focus point
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.invalidInput] if the input is invalid
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError setCameraFocus(final Point<double> pos) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'setCameraFocus',
      args: XyType<double>.fromPoint(pos),
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Set map rotation mode in follow position.
  ///
  /// **Parameters**
  ///
  /// * **IN** *mode* Map rotation mode.
  /// * **IN** *angle* The fixed rotation angle for [FollowPositionMapRotationMode.fixed].
  /// * **IN** *objectFollowMap* The position tracker object orientation will follow map view rotation.
  ///
  /// If the position tracker object orientation will follow map view rotation, all views using the same tracking object will see the object update.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setMapRotationMode(
    final FollowPositionMapRotationMode mode, {
    final double angle = 0,
    final bool objectFollowMap = true,
  }) {
    objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'setMapRotationMode',
      args: <String, Object>{
        'mode': mode.id,
        'angle': angle,
        'objectFollowMap': objectFollowMap,
      },
    );
  }

  /// Get map rotation mode in follow position
  ///
  /// **Returns**
  ///
  /// * The map rotation mode
  /// * The fixed rotation angle
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  (FollowPositionMapRotationMode, double) get mapRotationMode {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'getMapRotationMode',
    );

    return (
      FollowPositionMapRotationMode
          .values[((resultString['result']['first']) as double).toInt()],
      resultString['result']['second'],
    );
  }

  /// Set the map view perspective in follow position mode.
  ///
  /// **Parameters**
  ///
  /// * **IN** *perspective* The map perspective.
  /// * **IN** *animation* The operation animation type. By default it is none.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setPerspective(
    final MapViewPerspective perspective, {
    final GemAnimation? animation,
  }) {
    objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'setPerspective',
      args: <String, Object>{
        'perspective': perspective.id,
        if (animation != null) 'animation': animation,
      },
    );
  }

  /// Set the time interval before starting a turn presentation.
  ///
  /// **Parameters**
  ///
  /// * **IN** *val* The time interval in seconds. -1 means using SDK default value.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set timeBeforeTurnPresentation(final int val) {
    objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'setTimeBeforeTurnPresentation',
      args: val,
    );
  }

  /// Set whether to allow manually exiting follow position via touch handler events.
  ///
  /// Default value is true.
  ///
  /// **Parameters**
  ///
  /// * **IN** *allowExit* True to allow exiting follow position
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set touchHandlerExitAllow(final bool allowExit) {
    objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'setTouchHandlerExitAllow',
      args: allowExit,
    );
  }

  /// Set manually adjusted follow position changes (via touch handler) persistent from one follow position session to another.
  ///
  /// Default value is false
  ///
  /// **Parameters**
  ///
  /// * **IN** *isPersistent* True to make changes persistent
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set touchHandlerModifyPersistent(final bool isPersistent) {
    objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'setTouchHandlerModifyPersistent',
      args: isPersistent,
    );
  }

  /// Set touch handler horizontal angle adjust limits.
  ///
  /// Empty { 0., 0. } interval can be provided to forbid manually adjusting horizontal angle. Default values are { 0., 0. }
  ///
  /// **Parameters**
  ///
  /// * **IN** *angles* True to make changes persistent
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set touchHandlerModifyHorizontalAngleLimits(
    final (double, double) angles,
  ) {
    objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'setTouchHandlerModifyHorizontalAngleLimits',
      args: Pair<double, double>(angles.$1, angles.$2).toJson(),
    );
  }

  /// Set touch handler vertical angle adjust limits.
  ///
  /// Empty { 0., 0. } interval can be provided to forbid manually adjusting vertical angle. Default values are { 0., 0. }
  ///
  /// **Parameters**
  ///
  /// * **IN** *angles* True to make changes persistent
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set touchHandlerModifyVerticalAngleLimits(
    final (double, double) angles,
  ) {
    objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'setTouchHandlerModifyVerticalAngleLimits',
      args: Pair<double, double>(angles.$1, angles.$2).toJson(),
    );
  }

  /// Set touch handler distance to object adjust limits.
  ///
  /// Empty { 0., 0. } interval can be provided to forbid manually adjusting distance to object. Default values are { 50, double.infinity }
  ///
  /// **Parameters**
  ///
  /// * **IN** *angles* Values must be in { 0, double.infinity } range
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set touchHandlerModifyDistanceLimits(final (double, double) angles) {
    objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'setTouchHandlerModifyDistanceLimits',
      args: Pair<double, double>(angles.$1, angles.$2).toJson(),
    );
  }

  /// Set vertical angle in follow position mode.
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* The view angle.
  /// * **IN** *animation* Enable/ disable the animation. By default it is false.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setViewAngle(final double viewAngle, {final bool animated = false}) {
    objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'setViewAngle',
      args: <String, Object>{'value': viewAngle, 'animated': animated},
    );
  }

  /// Set a zoom level in follow position mode.
  ///
  /// **Parameters**
  ///
  /// * **IN** *zoomLevel* Zoom level, may be between 0 and max zoom level.
  /// * **IN** *duration* The animation duration in milliseconds (0 means no animation)
  ///
  /// **Returns**
  ///
  /// * The previous zoom level
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int setZoomLevel(final int zoomLevel, {final int duration = 0}) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'FollowPositionPreferences',
      'setZoomLevel',
      args: <String, int>{'zoomLevel': zoomLevel, 'duration': duration},
    );

    return resultString['result'];
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, Object>{
          'class': 'FollowPositionPreferences',
          'id': _pointerId,
        }),
      );
}

/// Mapview preferences
///
/// This class should not be instantiated directly. Instead, use the [GemView.preferences] getter to obtain an instance.
///
/// {@category Maps & 3D Scene}
class MapViewPreferences {
  MapViewPreferences()
      : _pointerId = -1,
        _mapId = -1,
        _mapPointerId = -1;

  @internal
  MapViewPreferences.init(
    final int id,
    final int mapId,
    final dynamic mapPointerId,
  )   : _pointerId = id,
        _mapId = mapId,
        _mapPointerId = mapPointerId;
  final dynamic _pointerId;
  final int _mapId;
  final dynamic _mapPointerId;
  dynamic get pointerId => _pointerId;
  int get mapId => _mapId;

  MapViewRoutesCollection? _routes;
  MapViewPathCollection? _paths;
  LandmarkStoreCollection? _lmks;
  MapViewMarkerCollections? _markers;
  FollowPositionPreferences? _followPositionPreferences;

  /// Enable / disable touch gestures.
  ///
  /// **Parameters**
  ///
  /// * **IN** *gestures* List of [TouchGestures] to enable/disable.
  /// * **IN** *enable* True to enable, false to disable
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void enableTouchGestures(
    final List<TouchGestures> gestures,
    final bool enable,
  ) {
    final int gesturesValue = gestures.fold(
      0,
      (final int previousValue, final TouchGestures gesture) =>
          previousValue | gesture.id,
    );
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'enableTouchGestures',
      args: <String, Object>{'gestures': gesturesValue, 'enable': enable},
    );
  }

  /// Get follow position preferences.
  ///
  /// **Returns**
  ///
  /// * The current follow position preferences
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  FollowPositionPreferences get followPositionPreferences {
    if (_followPositionPreferences == null) {
      final OperationResult resultString = objectMethod(
        _pointerId,
        'MapViewPreferences',
        'followPositionPreferences',
      );

      _followPositionPreferences = FollowPositionPreferences.init(
        resultString['result'],
        _mapId,
      );
    }
    return _followPositionPreferences!;
  }

  /// Get buildings visibility option.
  ///
  /// **Returns**
  ///
  /// * The buildings visibility option
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  BuildingsVisibility get buildingsVisibility {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'getBuildingsVisibility',
    );

    return BuildingsVisibilityExtension.fromId(resultString['result']);
  }

  /// Get frames per second draw state.
  ///
  /// **Returns**
  ///
  /// * True if frames per second draw is enabled, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get drawFPS {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'getDrawFPS',
    );

    return resultString['result'];
  }

  /// Get the map view focus viewport.
  ///
  /// The focus viewport is the view screen part containing the maximum map details. The coordinates are relative to view parent screen.
  ///
  /// The default value is the view whole viewport.
  ///
  /// **Returns**
  ///
  /// * The focus viewport
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectType<int> get focusViewport {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'getFocusViewport',
    );

    return RectType<int>.fromJson(resultString['result']);
  }

  /// Get map details quality level.
  ///
  /// **Returns**
  ///
  /// * The map details quality level
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MapDetailsQualityLevel get mapDetailsQualityLevel {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'getMapDetailsQualityLevel',
    );

    return MapDetailsQualityLevelExtension.fromId(resultString['result']);
  }

  /// Get the current view style content id. See [ContentStoreItem.id].
  ///
  /// If no style is set the function returns 0.
  ///
  /// **Returns**
  ///
  /// * The current view style content id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get mapStyleId {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'getMapStyleId',
    );

    return resultString['result'];
  }

  /// Get the current map view style
  ///
  /// **Returns**
  ///
  /// * The current map view style path
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get mapStylePath {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'getMapStylePath',
    );

    return resultString['result'];
  }

  /// Get the map view perspective.
  ///
  /// **Returns**
  ///
  /// * The map perspective
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MapViewPerspective get mapViewPerspective {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'getMapViewPerspective',
    );

    return MapViewPerspectiveExtension.fromId(resultString['result']);
  }

  /// Get the maximum viewing angle.
  ///
  /// Maximum view angle is when the camera is looking directly toward the horizon.
  ///
  /// **Returns**
  ///
  /// * The maximum view angle
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get maxViewAngle {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'getMaxViewAngle',
    );

    return resultString['result'];
  }

  /// Get the minimum viewing angle.
  ///
  /// Minimum view angle is when the camera is looking directly downward at the map.
  ///
  /// **Returns**
  ///
  /// * The minimum view angle
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get minViewAngle {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'getMinViewAngle',
    );

    return resultString['result'];
  }

  /// Get the value of the NorthFixed flag.
  ///
  /// **Returns**
  ///
  /// * The NorthFixed flag value
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get northFixedFlag {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'getNorthFixedFlag',
    );

    return resultString['result'];
  }

  /// Get map rotation angle in degrees relative to north-south axis.
  ///
  /// The value of 0 corresponds to north-up alignment.
  ///
  /// **Returns**
  ///
  /// * The rotation angle
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get rotationAngle {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'getRotationAngle',
    );

    return resultString['result'];
  }

  /// Get tilt angle in degrees.
  ///
  /// The tilt angle is 90 - [viewAngle].
  ///
  /// **Returns**
  ///
  /// * The tilt angle
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get tiltAngle {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'getTiltAngle',
    );

    return resultString['result'];
  }

  /// Get enabled touch gestures packed.
  ///
  /// **Returns**
  ///
  /// * Packed [TouchGestures]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get touchGesturesStates {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'getTouchGesturesStates',
    );

    return resultString['result'];
  }

  /// Get traffic visibility.
  ///
  /// By default it is true if current map style contains the traffic layer.
  ///
  /// **Returns**
  ///
  /// * True if traffic is visible, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get trafficVisibility {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'getTrafficVisibility',
    );

    return resultString['result'];
  }

  /// Get the viewing angle.
  ///
  /// **Returns**
  ///
  /// * The view angle
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get viewAngle {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'getViewAngle',
    );

    return resultString['result'];
  }

  /// Check if cursor is enabled.
  ///
  /// By default it is false.
  ///
  /// **Returns**
  ///
  /// * True if the cursor is enabled, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get cursorEnabled {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'isCursorEnabled',
    );

    return resultString['result'];
  }

  /// Check if cursor render is enabled.
  ///
  /// By default it is false.
  ///
  /// **Returns**
  ///
  /// * True if the cursor rendering is enabled, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get cursorRenderEnabled {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'isCursorRenderEnabled',
    );

    return resultString['result'];
  }

  /// Get the given map scene object visibility in current view.
  ///
  /// **Parameters**
  ///
  /// * **IN** *obj* The [MapSceneObject]
  ///
  /// **Returns**
  ///
  /// * True if the object is visible, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool isMapSceneObjectVisible(final MapSceneObject obj) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'isMapSceneObjectVisible',
      args: obj,
    );

    return resultString['result'];
  }

  /// Check if touch gesture is enabled.
  ///
  /// **Parameters**
  ///
  /// * **IN** *obj* The [TouchGestures] to check
  ///
  /// **Returns**
  ///
  /// * True if the touch gesture is enabled
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool isTouchGestureEnabled(final TouchGestures gesture) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'isTouchGestureEnabled',
      args: gesture.id,
    );

    return resultString['result'];
  }

  /// Get access to the settings for the visible landmark stores.
  ///
  /// **Returns**
  ///
  /// * The landmark store collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  LandmarkStoreCollection get lmks {
    if (_lmks == null) {
      final OperationResult resultString = objectMethod(
        _pointerId,
        'MapViewPreferences',
        'lmks',
      );

      _lmks = LandmarkStoreCollection.init(resultString['result']);
    }
    return _lmks!;
  }

  /// Get access to the collections of visible markers.
  ///
  /// **Returns**
  ///
  /// * The markers collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MapViewMarkerCollections get markers {
    if (_markers == null) {
      final OperationResult resultString = objectMethod(
        _pointerId,
        'MapViewPreferences',
        'markers',
      );

      _markers = MapViewMarkerCollections.init(
        resultString['result'],
        _mapId,
        _mapPointerId,
      );
    }
    return _markers!;
  }

  /// Get access to the collection of visible overlays.
  ///
  /// **Returns**
  ///
  /// * The overlays collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MapViewOverlayCollection get overlays {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'overlays',
    );

    return MapViewOverlayCollection.init(resultString['result'], _mapId);
  }

  /// Get access to the collection of visible paths.
  ///
  /// **Returns**
  ///
  /// * The paths collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MapViewPathCollection get paths {
    if (_paths == null) {
      final OperationResult resultString = objectMethod(
        _pointerId,
        'MapViewPreferences',
        'paths',
      );

      _paths = MapViewPathCollection.init(resultString['result'], _mapId);
    }
    return _paths!;
  }

  /// Get access to the collection of visible routes.
  ///
  /// **Returns**
  ///
  /// * The routes collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MapViewRoutesCollection get routes {
    if (_routes == null) {
      final OperationResult resultString = objectMethod(
        _pointerId,
        'MapViewPreferences',
        'routes',
      );

      _routes = MapViewRoutesCollection.init(resultString['result']);
    }
    return _routes!;
  }

  /// Set buildings visibility to specified option.
  ///
  /// **Parameters**
  ///
  /// * **IN** *option* The buildings visibility option
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set buildingsVisibility(final BuildingsVisibility option) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setBuildingsVisibility',
      args: option.id,
    );
  }

  /// Set car model by path.
  ///
  /// **Parameters**
  ///
  /// * **IN** *filePath* The path to the car model
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set carModelByPath(final String filePath) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setCarModelByPath',
      args: filePath,
    );
  }

  /// Enable/disable frames per second draw.
  ///
  /// **Parameters**
  ///
  /// * **IN** *isEnabled* True to enable frames per second draw
  /// * **IN** *pos* 	The position of the frames per second draw
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setDrawFPS(final bool isEnabled, final Point<int> pos) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setDrawFPS',
      args: <String, Object>{
        'bEnable': isEnabled,
        'pos': XyType<int>.fromPoint(pos),
      },
    );
  }

  /// Set the map view focus viewport.
  ///
  /// If view is an empty viewport the focus will be reset to whole view.
  ///
  /// **Parameters**
  ///
  /// * **IN** *view* The focus viewport
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set focusViewport(final RectType<int> view) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setFocusViewport',
      args: view,
    );
  }

  /// Set map details quality level.
  ///
  /// **Parameters**
  ///
  /// * **IN** *level* Map details quality level, see [MapDetailsQualityLevel]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set mapDetailsQualityLevel(final MapDetailsQualityLevel level) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setMapDetailsQualityLevel',
      args: level.id,
    );
  }

  /// Set the given map scene object visibility in current view.
  ///
  /// **Parameters**
  ///
  /// * **IN** *obj* The [MapSceneObject]
  /// * **IN** *visible* True to show the object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setMapSceneObjectVisibility(
    final MapSceneObject obj,
    final bool visible,
  ) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setMapSceneObjectVisibility',
      args: <String, Object>{'obj': obj, 'visible': visible},
    );
  }

  /// Set map view details by content.
  ///
  /// **Parameters**
  ///
  /// * **IN** *style* Style content.
  /// * **IN** *smoothTransition* Enables a smooth transition between old and new style.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void setMapStyle(
    final ContentStoreItem style, {
    final bool smoothTransition = false,
  }) {
    setMapStyleById(style.id, smoothTransition: smoothTransition);
  }

  /// Set map view details by content id.
  ///
  /// **Parameters**
  ///
  /// * **IN** *id* Content id. See [ContentStoreItem.id].
  /// * **IN** *smoothTransition* Enables a smooth transition between old and new style.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void setMapStyleById(final int id, {final bool smoothTransition = false}) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setMapStyleById',
      args: <String, Object>{'id': id, 'smoothTransition': smoothTransition},
    );
  }

  /// Set map view style by content path
  ///
  /// **Parameters**
  ///
  /// * **IN** *path* Content path. See [ContentStoreItem.fileName].
  /// * **IN** *smoothTransition* Enables a smooth transition between old and new style.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void setMapStyleByPath(
    final String path, {
    final bool smoothTransition = false,
  }) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setMapStyleByPath',
      args: <String, Object>{
        'path': path,
        'smoothTransition': smoothTransition,
      },
    );
  }

  /// Set map view style by content buffer
  ///
  /// **Parameters**
  ///
  /// * **IN** *buffer* Content buffer.
  /// * **IN** *smoothTransition* Enables a smooth transition between old and new style.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void setMapStyleByBuffer(
    final Uint8List buffer, {
    final bool smoothTransition = false,
  }) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setMapStyleByBuffer',
      args: <String, Object>{
        'content': buffer,
        'smoothTransition': smoothTransition,
      },
    );
  }

  /// Set the map view perspective.
  ///
  /// **Parameters**
  ///
  /// * **IN** *perspective* The map perspective.
  /// * **IN** *animation* The operation animation type. By default it is [AnimationType.none].
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void setMapViewPerspective(
    final MapViewPerspective perspective, {
    final GemAnimation? animation,
  }) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setMapViewPerspective',
      args: <String, Object>{
        'perspective': perspective.id,
        if (animation != null) 'animation': animation,
      },
    );
  }

  /// Set the value of the NorthFixed flag.
  ///
  /// **Parameters**
  ///
  /// * **IN** *isNorthFixed* The NorthFixed flag value
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  @Deprecated('Use northFixedFlag instead')
  set setNorthFixedFlag(final bool isNorthFixed) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setNorthFixedFlag',
      args: isNorthFixed,
    );
  }

  /// Set the value of the NorthFixed flag.
  ///
  /// **Parameters**
  ///
  /// * **IN** *isNorthFixed* The NorthFixed flag value
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  set northFixedFlag(final bool isNorthFixed) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setNorthFixedFlag',
      args: isNorthFixed,
    );
  }

  /// Set the map rotation angle in degrees relative to north-south axis.
  ///
  /// **Parameters**
  ///
  /// * **IN** *angle* The rotation angle in degrees.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  set rotationAngle(final double rotationAngle) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setRotationAngle',
      args: rotationAngle,
    );
  }

  /// Set tilt angle in degrees.
  ///
  /// The tilt angle is 90 - [viewAngle].
  ///
  /// **Parameters**
  ///
  /// * **IN** *angleDegrees* The tilt angle in degrees.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  set tiltAngle(final double tiltAngle) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setTiltAngle',
      args: tiltAngle,
    );
  }

  /// Set enabled touch gestures packed.
  ///
  /// **Parameters**
  ///
  /// * **IN** *enabledTouchGesturesBitfield* Packed [TouchGestures]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  set touchGesturesStates(final int enabledTouchGesturesBitfield) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setTouchGesturesStates',
      args: enabledTouchGesturesBitfield,
    );
  }

  /// Set traffic visibility.
  ///
  /// **Parameters**
  ///
  /// * **IN** *isVisible* True to show traffic
  ///
  /// **Returns**
  ///
  /// * [GemError.success] if operation is successful
  /// * [GemError.notFound] if current map style doesn't contain the traffic layer.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError setTrafficVisibility(final bool isVisible) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setTrafficVisibility',
      args: isVisible,
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Set the viewing angle.
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* The view angle.
  /// * **IN** *animated* The animation flag
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void setViewAngle(final double viewAngle, {final bool animated = false}) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setViewAngle',
      args: <String, Object>{'value': viewAngle, 'animated': animated},
    );
  }

  /// Enable/Disable the cursor mode When the cursor is enabled map selection can be activated by calling setCursorScreenPosition The cursor is automatically disabled by [GemView.startFollowingPosition].
  ///
  /// **Parameters**
  ///
  /// * **IN** *isEnabled* True to enable the cursor
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set enableCursor(final bool isEnabled) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'enableCursor',
      args: isEnabled,
    );
  }

  /// Enable/Disable the cursor rendering.
  ///
  /// **Parameters**
  ///
  /// * **IN** *isEnabled* True to enable cursor rendering
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set enableCursorRender(final bool value) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'enableCursorRender',
      args: value,
    );
  }

  /// Check if map scale is shown
  ///
  ///
  /// **Returns**
  ///
  /// * True if map scale is shown, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get showMapScale {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'isMapScaleShown',
    );

    return resultString['result'];
  }

  /// Check if map scale is shown
  ///
  /// Controlling whether the map scale is drawn by the SDK automatically or not can be done via the [areMapScalesDrawnByUser] setter.
  ///
  /// **Returns**
  ///
  /// * True if map scale is shown, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set showMapScale(final bool value) {
    objectMethod(_pointerId, 'MapViewPreferences', 'showMapScale', args: value);
  }

  /// Set if the map scales are drawn by the user or by the SDK
  ///
  /// Only applicable if the [MapViewPreferences.showMapScale] is set to true.
  /// The instructions on how to draw the scale are provided by [IMapViewListener.onRenderMapScale] callback.
  ///
  /// This options applies to all the map views in the application. Drawing the scale can be enabled/disabled for each map view separately via the [MapViewPreferences.showMapScale] method.
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* True if the scale should be drawn by the user, false if it should be drawn by the SDK
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set areMapScalesDrawnByUser(final bool value) {
    objectMethod(0, 'MapView', 'setAreMapScalesDrawnByUser', args: value);
  }

  /// Get if the map scales are drawn by the user or by the SDK
  ///
  /// **Returns**
  ///
  /// * True if the scale should be drawn by the user, false if it should be drawn by the SDK
  bool get areMapScalesDrawnByUser {
    final OperationResult resultString = objectMethod(
      0,
      'MapView',
      'getAreMapScalesDrawnByUser',
    );

    return resultString['result'];
  }

  /// Sets the map position.
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* The map position
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set mapScalePosition(final RectType<int> value) {
    objectMethod(
      _pointerId,
      'MapViewPreferences',
      'setMapScalePosition',
      args: value,
    );
  }

  /// Get the map scale position.
  ///
  /// **Returns**
  ///
  /// * The map position
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectType<int> get mapScalePosition {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPreferences',
      'getMapScalePosition',
    );

    return RectType<int>.fromJson(resultString['result']);
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, dynamic>{
        'class': 'MapViewPreferences',
        'id': _pointerId,
      }),
    );
  }
}

/// Animation helper class.
///
/// {@category Maps & 3D Scene}
class GemAnimation {
  /// Constructor for the animation class.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* the animation type. By default it is [AnimationType.none]
  /// * **IN** *duration* the animation duration. The value 0 means a default duration set internally by the SDK
  /// * **IN** *onCompleted* the callback which is triggered when animation is completed
  GemAnimation({
    this.type = AnimationType.none,
    this.duration = 0,
    this.onCompleted,
  }) {
    _progressListener = EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(
      _progressListener.id,
      _progressListener,
    );

    _progressListener.registerOnCompleteWithDataCallback((_, __, ___) {
      if (onCompleted != null) {
        onCompleted!();
      }
    });
  }

  /// No animation constructor
  GemAnimation.none() : this(type: AnimationType.none);

  /// Linear animation constructor
  ///
  /// **Parameters**
  ///
  /// * **IN** *duration* the animation duration. The value null means a default duration set internally by the SDK
  /// * **IN** *onCompleted* the callback which is triggered when animation is completed
  GemAnimation.linear({Duration? duration, void Function()? onCompleted})
      : this(
          type: AnimationType.linear,
          duration: duration == null ? 0 : duration.inMilliseconds,
          onCompleted: onCompleted,
        );

  GemAnimation._(
    this.type,
    this.duration,
    final EventDrivenProgressListener progressListener,
  ) : _progressListener = progressListener;

  factory GemAnimation.fromJson(final Map<String, dynamic> json) {
    return GemAnimation._(
      json['type'],
      json['duration'],
      EventDrivenProgressListener.init(json['progress']),
    );
  }

  /// The type of animation.
  AnimationType type;

  /// The duration of animation in milliseconds (0 means no animation)
  int duration;

  /// The callback when animation is completed.
  void Function()? onCompleted;

  late EventDrivenProgressListener _progressListener;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['type'] = type.id;
    json['progress'] = _progressListener.id;
    json['duration'] = duration;

    return json;
  }
}
