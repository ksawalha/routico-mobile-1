// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:gem_kit/core.dart';
import 'package:gem_kit/map.dart';
import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// Route display modes
///
/// {@category Maps & 3D Scene}
enum RouteDisplayMode {
  /// Full route display
  full,

  /// Zoom to the branched part of the route
  branches,
}

/// @nodoc
extension RouteDisplayModeExtension on RouteDisplayMode {
  int get id {
    switch (this) {
      case RouteDisplayMode.full:
        return 0;
      case RouteDisplayMode.branches:
        return 1;
    }
  }

  static RouteDisplayMode fromId(final int id) {
    switch (id) {
      case 0:
        return RouteDisplayMode.full;
      case 1:
        return RouteDisplayMode.branches;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Follow position state. Used in [IMapViewListener.onFollowPositionState] and [IMapViewListener.onTouchHandlerModifyFollowPosition]
///
/// {@category Maps & 3D Scene}
enum FollowPositionState {
  /// Enter following position
  entered,

  /// Exit following position
  exited,
}

/// Dictates when the [GemView] is rendered. Used in [GemView.renderingRule].
///
/// {@category Maps & 3D Scene}
@experimental
enum RenderRule {
  /// Map render is disabled ~ StopRendering
  noRender,

  /// Mode used for iOS
  automatic,

  /// Mode used for Android
  onDemand,
}

/// @nodoc
extension RenderRuleExtension on RenderRule {
  int get id {
    switch (this) {
      case RenderRule.noRender:
        return 0;
      case RenderRule.automatic:
        return 1;
      case RenderRule.onDemand:
        return 2;
    }
  }

  static RenderRule fromId(final int id) {
    switch (id) {
      case 0:
        return RenderRule.noRender;
      case 1:
        return RenderRule.automatic;
      case 2:
        return RenderRule.onDemand;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// @nodoc
abstract class IMapViewListener {
  void onViewportResized(final Rectangle<int> viewport);

  void onTouch(final Point<int> pos);

  void onPointerUp(final int pointerId, final Point<int> pos);

  void onPointerDown(final int pointerId, final Point<int> pos);

  void onPointerMove(final int pointerId, final Point<int> pos);

  void onFollowPositionState(final FollowPositionState followPositionState);

  void onTouchHandlerModifyFollowPosition(
    final FollowPositionState followPositionState,
  );

  void onMove(final Point<int> startPos, final Point<int> endPos);

  void onTouchMove(final Point<int> startPos, final Point<int> endPos);

  void onSwipe(final int distX, final int distY, final double speedMmPerSec);

  void onPinchSwipe(
    final Point<int> centerPosInPix,
    final double zoomingSpeedInMMPerSec,
    final double rotatingSpeedInMMPerSec,
  );

  void onPinch(
    final Point<int> start1,
    final Point<int> start2,
    final Point<int> end1,
    final Point<int> end2,
    final Point<int> center,
  );

  void onTouchPinch(
    final Point<int> start1,
    final Point<int> start2,
    final Point<int> end1,
    final Point<int> end2,
  );

  void onLongPress(final Point<int> pos);

  void onDoubleTouch(final Point<int> pos);

  void onTwoTouches(final Point<int> pos);

  void onTwoDoubleTouches(final Point<int> pos);

  void onMapAngleUpdate(final double angle);

  void onMarkerRender(final dynamic data);

  void onViewRendered(final dynamic data);

  void onRenderMapScale(
    final int scaleWidth,
    final int scaleValue,
    final String scaleUnits,
  );

  void onShove(
    final double pointersAngleDeg,
    final Point<int> initial,
    final Point<int> start,
    final Point<int> end,
  );

  void onCursorSelectionUpdatedLandmarks(final List<Landmark> landmarks);

  void onCursorSelectionUpdatedOverlayItems(
    final List<OverlayItem> overlayItems,
  );

  void onCursorSelectionUpdatedTrafficEvents(
    final List<TrafficEvent> trafficEvents,
  );

  void onCursorSelectionUpdatedRoutes(final List<Route> routes);

  void onCursorSelectionUpdatedMarkers(final List<MarkerMatch> markerMatches);

  void onCursorSelectionUpdatedPath(final Path path);

  void onCursorSelectionUpdatedMapSceneObject(
    final MapSceneObject mapSceneObject,
  );

  void onHoveredMapLabelHighlightedLandmark(final Landmark object);

  void onHoveredMapLabelHighlightedOverlayItem(final OverlayItem object);

  void onHoveredMapLabelHighlightedTrafficEvent(final TrafficEvent object);

  void onSetMapStyle(final int id, final String stylePath, final bool viaApi);
}

/// The map view class
///
/// This abstract class is implemented by [GemMapController]
///
/// GemView supports a wide range of operations like resize, zoom, rotate, animated fly to specific position or select map objects.
/// The map appearance is fully customizable. By using the attached [preferences] it is possible to specify for each map what map objects to be visible and when;
/// it is possible to change the colors, widths and other properties of the map objects or to specify which landmarks should be visible on map.
/// Multiple [GemView] objects can be created.
///
/// {@category Maps & 3D Scene}
abstract class GemView extends EventHandler implements IMapViewListener {
  ///@nodoc
  // ignore: unused_element
  GemView._()
      : _pointerId = -1,
        _mapId = -1;

  ///@nodoc
  @internal
  GemView.init(final int id, final int mapId)
      : _pointerId = id,
        _mapId = mapId;
  dynamic get pointerId => _pointerId;
  int get mapId => _mapId;

  final dynamic _pointerId;
  final int _mapId;
  Completer<Uint8List>? _captureAsImageCompleter;
  MapViewPreferences? _preferences;
  MapViewExtensions? _extensions;

  int _scaleWidthPrev = -1;
  int _scaleValuePrev = -1;
  String _scaleUnitsPrev = '';

  ///@nodoc
  @internal
  Future<void> releaseView() async {
    try {
      await GemKitPlatform.instance
          .getChannel(mapId: _mapId)
          .invokeMethod<String>(
            'releaseView',
            jsonEncode(<String, dynamic>{'viewId': _pointerId}),
          );
    } catch (e) {
      //return Future.error(e.toString());
    }
  }

  /// The current viewport of the map view.
  ///
  /// Fields [RectType.x] and [RectType.y] are 0 as they are measured from the top left corner of the map view.
  /// Fields [RectType.width] and [RectType.height] are the width and height of the map view in physical pixels.
  ///
  /// Use the [transformScreenToWgsRect] to get the associated [RectangleGeographicArea].
  ///
  /// **Returns**
  ///
  /// * The current viewport
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectType<int> get viewport {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getViewport',
    );

    return RectType<int>.fromJson(resultString['result']);
  }

  /// The current viewport in parent screen ratio.
  ///
  /// **Returns**
  ///
  /// * The current viewport
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectType<double> get viewportF {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getViewportF',
    );

    return RectType<double>.fromJson(resultString['result']);
  }

  /// Sets the cursor screen position to the default location (the center of viewport).
  ///
  /// This method needs to be awaited
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Future<void> resetMapSelection() async {
    await setCursorScreenPosition(
      Point<int>((viewport.width / 2).round(), (viewport.height / 2).round()),
    );
  }

  /// React to view events and call the listener functions.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  @override
  void handleEvent(final Map<dynamic, dynamic> arguments) {
    final String eventType = arguments['eventType'];

    if (eventType == 'mapViewResizedEvent') {
      final Rectangle<int> viewport = Rectangle<int>(
        arguments['rectLeft'],
        arguments['rectTop'],
        arguments['rectWidth'],
        arguments['rectHeight'],
      );
      onViewportResized(viewport);
    }
    if (eventType == 'mapViewOnTouch') {
      final int ptx = arguments['point']['ptX'];
      final int pty = arguments['point']['ptY'];
      onTouch(Point<int>(ptx, pty));
    } else if (eventType == 'mapViewFollowPositionEntered') {
      onFollowPositionState(FollowPositionState.entered);
    } else if (eventType == 'mapViewFollowPositionExited') {
      onFollowPositionState(FollowPositionState.exited);
    } else if (eventType == 'onEnterTouchHandlerModifyFollowingPosition') {
      onTouchHandlerModifyFollowPosition(FollowPositionState.entered);
    } else if (eventType == 'onExitTouchHandlerModifyFollowingPosition') {
      onTouchHandlerModifyFollowPosition(FollowPositionState.exited);
    } else if (eventType == 'onPointerUp') {
      final int ptx = arguments['ptX'];
      final int pty = arguments['ptY'];
      onPointerUp(arguments['pointerId'], Point<int>(ptx, pty));
    } else if (eventType == 'onPointerDown') {
      final int ptx = arguments['ptX'];
      final int pty = arguments['ptY'];
      onPointerDown(arguments['pointerId'], Point<int>(ptx, pty));
    } else if (eventType == 'onPointerMove') {
      final int ptx = arguments['ptX'];
      final int pty = arguments['ptY'];
      onPointerMove(arguments['pointerId'], Point<int>(ptx, pty));
    } else if (eventType == 'onMove') {
      final int ptx = arguments['startPoint']['ptX'];
      final int pty = arguments['startPoint']['ptY'];
      final int ptendx = arguments['endPoint']['ptX'];
      final int ptendy = arguments['endPoint']['ptY'];
      onMove(Point<int>(ptx, pty), Point<int>(ptendx, ptendy));
    } else if (eventType == 'onTouchMove') {
      final int ptx = arguments['startPoint']['ptX'];
      final int pty = arguments['startPoint']['ptY'];
      final int ptendx = arguments['endPoint']['ptX'];
      final int ptendy = arguments['endPoint']['ptY'];
      onTouchMove(Point<int>(ptx, pty), Point<int>(ptendx, ptendy));
    } else if (eventType == 'onSwipe') {
      final int distX = arguments['distX'];
      final int distY = arguments['distY'];
      final double speed = arguments['speed'];
      onSwipe(distX, distY, speed);
    } else if (eventType == 'onPinchSwipe') {
      final int centerPosInPixX = arguments['centerPosInPixX'];
      final int centerPosInPixY = arguments['centerPosInPixY'];
      final double zoomSpeed = arguments['zoomSpeed'];
      final double rotateSpeed = arguments['rotateSpeed'];
      onPinchSwipe(
        Point<int>(centerPosInPixX, centerPosInPixY),
        zoomSpeed,
        rotateSpeed,
      );
    } else if (eventType == 'onPinch') {
      final int start1X = arguments['start1X'];
      final int start1Y = arguments['start1Y'];
      final int start2X = arguments['start2X'];
      final int start2Y = arguments['start2Y'];
      final int end1X = arguments['end1X'];
      final int end1Y = arguments['end1Y'];
      final int end2X = arguments['end2X'];
      final int end2Y = arguments['end2Y'];
      final int centerX = arguments['centerX'];
      final int centerY = arguments['centerY'];
      onPinch(
        Point<int>(start1X, start1Y),
        Point<int>(start2X, start2Y),
        Point<int>(end1X, end1Y),
        Point<int>(end2X, end2Y),
        Point<int>(centerX, centerY),
      );
    } else if (eventType == 'onTouchPinch') {
      final int start1X = arguments['start1X'];
      final int start1Y = arguments['start1Y'];
      final int start2X = arguments['start2X'];
      final int start2Y = arguments['start2Y'];
      final int end1X = arguments['end1X'];
      final int end1Y = arguments['end1Y'];
      final int end2X = arguments['end2X'];
      final int end2Y = arguments['end2Y'];
      onTouchPinch(
        Point<int>(start1X, start1Y),
        Point<int>(start2X, start2Y),
        Point<int>(end1X, end1Y),
        Point<int>(end2X, end2Y),
      );
    } else if (eventType == 'mapViewOnLongDown') {
      final int ptx = arguments['ptX'];
      final int pty = arguments['ptY'];
      onLongPress(Point<int>(ptx, pty));
    } else if (eventType == 'onDoubleTouch') {
      final int ptx = arguments['ptX'];
      final int pty = arguments['ptY'];
      onDoubleTouch(Point<int>(ptx, pty));
    } else if (eventType == 'onTwoTouches') {
      final int ptx = arguments['ptX'];
      final int pty = arguments['ptY'];
      onTwoTouches(Point<int>(ptx, pty));
    } else if (eventType == 'onTwoDoubleTouches') {
      final int ptx = arguments['ptX'];
      final int pty = arguments['ptY'];
      onTwoDoubleTouches(Point<int>(ptx, pty));
    } else if (eventType == 'onMapAngleUpdate') {
      final double angle = arguments['angle'];
      onMapAngleUpdate(angle);
    } else if (eventType == 'onMarkerRender') {
      onMarkerRender(arguments);
    } else if (eventType == 'onViewRendered') {
      onViewRendered(arguments);
    } else if (eventType == 'onShove') {
      final double pointersAngleDeg = arguments['pointersAngleDeg'];
      final int initialX = arguments['initialX'];
      final int initialY = arguments['initialY'];
      final int startX = arguments['startX'];
      final int startY = arguments['startY'];
      final int endX = arguments['endX'];
      final int endY = arguments['endY'];

      onShove(
        pointersAngleDeg,
        Point<int>(initialX, initialY),
        Point<int>(startX, startY),
        Point<int>(endX, endY),
      );
    } else if (arguments['eventType'] == 'onMapCaptured') {
      _captureAsImageCompleter!.complete(
        Uint8List.fromList(base64Decode(arguments['buffer'])),
      );
      _captureAsImageCompleter = null;
    } else if (arguments['eventType'] == 'renderMapScale') {
      final int scaleWidth = arguments['scaleWidth'];
      final String scaleValueStr = arguments['scaleValue'];
      final int? scaleValue = int.tryParse(scaleValueStr);
      if (scaleValue == null) {
        return;
      }
      final String scaleUnits = arguments['scaleUnits'];

      if (_scaleWidthPrev == scaleWidth &&
          _scaleValuePrev == scaleValue &&
          _scaleUnitsPrev == scaleUnits) {
        return;
      }
      onRenderMapScale(scaleWidth, scaleValue, scaleUnits);
      _scaleWidthPrev = scaleWidth;
      _scaleValuePrev = scaleValue;
      _scaleUnitsPrev = scaleUnits;
    } else if (eventType == 'onCursorSelectionUpdatedLandmarks') {
      final int objectId = arguments['list'];
      final LandmarkList gemList = LandmarkList.init(objectId);
      final List<Landmark> list = gemList.toList();
      onCursorSelectionUpdatedLandmarks(list);
    } else if (eventType == 'onCursorSelectionUpdatedOverlayItems') {
      final int objectId = arguments['list'];
      final OverlayItemList gemList = OverlayItemList.init(objectId);
      final List<OverlayItem> list = gemList.toList();
      onCursorSelectionUpdatedOverlayItems(list);
    } else if (eventType == 'onCursorSelectionUpdatedTrafficEvents') {
      final int objectId = arguments['list'];
      final TrafficEventList gemList = TrafficEventList.init(objectId);
      final List<TrafficEvent> list = gemList.toList();
      onCursorSelectionUpdatedTrafficEvents(list);
    } else if (eventType == 'onCursorSelectionUpdatedRoutes') {
      final int objectId = arguments['list'];
      final RouteList gemList = RouteList.init(objectId);
      final List<Route> list = gemList.toList();
      onCursorSelectionUpdatedRoutes(list);
    } else if (eventType == 'onCursorSelectionMarkerMatches') {
      final int objectId = arguments['list'];
      final MarkerMatchList gemList = MarkerMatchList.init(objectId);
      final List<MarkerMatch> list = gemList.toList();
      onCursorSelectionUpdatedMarkers(list);
    } else if (eventType == 'onCursorSelectionPath') {
      final int objectId = arguments['list'];
      final Path path = Path.init(objectId);
      onCursorSelectionUpdatedPath(path);
    } else if (eventType == 'onCursorSelectionMapSceneObject') {
      onCursorSelectionUpdatedMapSceneObject(
        MapSceneObject.getDefPositionTracker(),
      );
    } else if (eventType == 'onHoveredMapLabelHighlightedLandmark') {
      final int objectId = arguments['obj'];
      final Landmark obj = Landmark.init(objectId);
      onHoveredMapLabelHighlightedLandmark(obj);
    } else if (eventType == 'onHoveredMapLabelHighlightedOverlayItem') {
      final int objectId = arguments['obj'];
      final OverlayItem obj = OverlayItem.init(objectId);
      onHoveredMapLabelHighlightedOverlayItem(obj);
    } else if (eventType == 'onHoveredMapLabelHighlightedTrafficEvent') {
      final int objectId = arguments['obj'];
      final TrafficEvent obj = TrafficEvent.init(objectId);
      onHoveredMapLabelHighlightedTrafficEvent(obj);
    } else if (eventType == 'onSetMapStyle') {
      final int id = arguments['id'];
      final String stylePath = arguments['stylePath'];
      final bool viaApi = arguments['viaApi'];
      onSetMapStyle(id, stylePath, viaApi);
    } else {
      gemSdkLogger.log(
        Level.WARNING,
        'Unknown event subtype: $eventType in GemView',
      );
    }
  }

  /// Get the camera
  ///
  /// **Returns**
  ///
  /// * [MapCamera]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MapCamera get camera {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getCamera',
    );

    return MapCamera.init(resultString['result'], _mapId);
  }

  /// Set the camera
  ///
  /// **Parameters**
  ///
  /// * [MapCamera] the camera onject
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set camera(MapCamera camera) {
    objectMethod(_pointerId, 'MapView', 'setCamera', args: camera.pointerId);
  }

  /// Stop the current animation
  ///
  /// The current animation is completed instantaneously.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void skipAnimation({final bool jumpToDestination = true}) {
    objectMethod(
      _pointerId,
      'MapView',
      'skipAnimation',
      args: jumpToDestination,
    );
  }

  /// Check if there is an animation in progress.
  ///
  /// **Returns**
  ///
  /// * True if there is an animation in progress, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isAnimationInProgress {
    final OperationResult val = objectMethod(
      _pointerId,
      'MapView',
      'isAnimationInProgress',
    );

    return val['result'];
  }

  /// Center the WGS coordinates on the screen coordinates.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* Coordinates
  /// * **IN** *zoomLevel* Zoom level (Use -1 for automatic selection)
  /// * **IN** *screenPosition* Screen position where the coordinates should project (default uses the specified cursor coordinates). The coordinates are relative to the parent view screen.
  /// * **IN** *animation* Specifies the animation to be used by the operation.
  /// * **IN** *mapAngle* Map rotation angle in the range **0.0 - 360.0** degrees (Use [double.infinity] for automatic selection).
  /// * **IN** *viewAngle* MapView angle in the range **-90.0 - 90.0** degrees (Use [double.infinity] for automatic selection).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void centerOnCoordinates(
    final Coordinates coords, {
    final int zoomLevel = -1,
    final Point<int>? screenPosition,
    final GemAnimation? animation,
    double? mapAngle,
    double? viewAngle,
    final double slippyZoomLevel = -1.0,
  }) {
    if (viewAngle != null && (viewAngle - viewAngle.toInt() == 0)) {
      viewAngle -= 0.0000000001;
    }
    if (mapAngle != null && (mapAngle - mapAngle.toInt() == 0)) {
      mapAngle -= 0.0000000001;
    }
    objectMethod(
      _pointerId,
      'MapView',
      'centerOnCoordinates',
      args: <String, Object>{
        'coords': coords,
        'zoomLevel': zoomLevel,
        'slippyZoomLevel': slippyZoomLevel,
        if (screenPosition != null) 'xy': XyType<int>.fromPoint(screenPosition),
        if (animation != null) 'animation': animation,
        if (mapAngle != null) 'mapAngle': mapAngle,
        if (viewAngle != null) 'viewAngle': viewAngle,
      },
    );
  }

  /// Center the view on the given WGS area
  ///
  /// **Parameters**
  ///
  /// * **IN** *area* Geographic area
  /// * **IN** *zoomLevel* Zoom level. When -1 is used, the zoom level is automatically selected so that the entire area is visible on the map.
  /// * **IN** *screenPosition* Screen position where the coordinates should project (default uses the specified cursor coordinates). The coordinates are relative to the parent view screen.
  /// * **IN** *animation* Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void centerOnArea(
    final RectangleGeographicArea area, {
    final int zoomLevel = -1,
    final Point<int>? screenPosition,
    final GemAnimation? animation,
  }) {
    objectMethod(
      _pointerId,
      'MapView',
      'centerOnArea',
      args: <String, Object?>{
        'area': area,
        'zoomLevel': zoomLevel,
        if (screenPosition != null) 'xy': XyType<int>.fromPoint(screenPosition),
        if (animation != null) 'animation': animation,
      },
    );
  }

  /// Center the on the given WGS area.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area* Geographic area
  /// * **IN** *zoomLevel* Zoom level. When -1 is used, the zoom level is automatically selected so that the entire area is visible on the map.
  /// * **IN** *viewRc* Screen rectangle where area should be centered. The coordinates are relative to view parent screen.
  /// * **IN** *animation* Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void centerOnAreaRect(
    final RectangleGeographicArea area, {
    required final RectType<int> viewRc,
    final int zoomLevel = -1,
    final GemAnimation? animation,
  }) {
    objectMethod(
      _pointerId,
      'MapView',
      'centerOnAreaRect',
      args: <String, Object?>{
        'area': area,
        'zoomLevel': zoomLevel,
        'viewRc': viewRc,
        if (animation != null) 'animation': animation,
      },
    );
  }

  /// Get the cursor screen position. The coordinates are relative to the parent view screen
  ///
  /// Use the [cursorWgsPosition] to get the cursor WGS position
  ///
  /// **Returns**
  ///
  /// * The current screen coordinates (Xy) of the cursor, relative to the view's parent screen.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Point<int> get cursorScreenPosition {
    final OperationResult val = objectMethod(
      _pointerId,
      'MapView',
      'getCursorScreenPosition',
    );
    final XyType<int> retVal = XyType<int>.fromJson(val['result']);
    return retVal.toPoint();
  }

  /// Get the cursor WGS position.
  ///
  /// Use the [cursorScreenPosition] to get the cursor screen position
  ///
  /// **Returns**
  ///
  /// * The current WGS coordinates of the cursor
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Coordinates get cursorWgsPosition {
    final OperationResult val = objectMethod(
      _pointerId,
      'MapView',
      'getCursorWgsPosition',
    );
    return Coordinates.fromJson(val['result']);
  }

  /// Scroll map.
  ///
  /// **Parameters**
  ///
  /// * **IN** *dx* Horizontal scroll offset
  /// * **IN** *dy* Vertical scroll offset
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void scroll({required final double dx, required final double dy}) {
    objectMethod(_pointerId, 'GemMapView', 'scroll');
  }

  /// Stop the camera from following the current real/simulated position.
  ///
  /// ** Parameters**
  ///
  /// * **IN** *restoreCameraMode* Restore default camera [zoomLevel] and [pitchInDegrees] in follow position mode
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void stopFollowingPosition({bool restoreCameraMode = false}) {
    objectMethod(
      _pointerId,
      'MapView',
      'stopFollowingPosition',
      args: restoreCameraMode,
    );
  }

  /// Returns true if the camera is following the current real/simulated position and false otherwise.
  ///
  /// **Returns**
  ///
  /// * True if the map is currently following the current position.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isFollowingPosition {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'isFollowingPosition',
    );

    return resultString['result'];
  }

  /// Returns true if the camera is following the current real/simulated position from a fixed relative position adjusted by user input and false otherwise.
  ///
  /// **Returns**
  ///
  /// * True if the follow position mode has been manually adjusted by the user, false if it remains in its default state.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool isFollowingPositionTouchHandlerModified() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'isFollowingPositionTouchHandlerModified',
    );

    return resultString['result'];
  }

  /// Returns true if the camera is following the current real/simulated position in default auto-zoom mode and false otherwise.
  ///
  /// **Returns**
  ///
  /// * True if the map is in the default auto-zoom follow position mode, false if it has been manually adjusted or is not in follow position mode.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool isDefaultFollowingPosition() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'isDefaultFollowingPosition',
    );

    return resultString['result'];
  }

  /// Set the cursor screen position.
  ///
  /// Use this function to trigger a map view selection (POI, landmark, overlay, route, path, marker) at the given screen coordinates.
  /// The current view selection can be queried via [cursorSelectionRoutes], [cursorSelectionLandmarks], [cursorSelectionStreets], [cursorSelectionOverlayItems], [cursorSelectionMarkers] methods.
  ///
  /// This method needs to be awaited.
  ///
  /// **Parameters**
  ///
  /// * **IN** *screenPosition*	position relative to the parent screen. The coordinates are relative to the parent view screen
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Future<void> setCursorScreenPosition(final Point<int> screenPosition) async {
    // This method needs to be async
    await GemKitPlatform.instance.getChannel(mapId: mapId).invokeMethod<String>(
          'callObjectMethod',
          jsonEncode(<String, dynamic>{
            'id': _pointerId,
            'class': 'MapView',
            'method': 'setCursorScreenPosition',
            'args': XyType<int>(x: screenPosition.x, y: screenPosition.y),
          }),
        );
  }

  /// Convert a screen(x, y) coordinate to a WGS(lon, lat) coordinate.
  ///
  /// **Parameters**
  ///
  /// * **IN** *screenCoordinates* Screen coordinate. The coordinates are relative to the parent view screen
  ///
  /// **Returns**
  ///
  /// * WGS 84 coordinates of the given screen coordinate
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Coordinates transformScreenToWgs(final Point<int> screenCoordinates) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'transformScreenToWgs',
      args: XyType<int>.fromPoint(screenCoordinates),
    );

    final Coordinates coords = Coordinates.fromJson(resultString['result']);
    if (coords.altitude != null &&
        coords.altitude! > -0.0001 &&
        coords.altitude! < 0.0001) {
      coords.altitude = 0;
    }

    return coords;
  }

  /// Converts a screen rectangle to WGS area
  ///
  /// If default empty provided, the whole [viewport] is transformed
  ///
  /// **Parameters**
  ///
  /// * **IN** *screenRect* Screen rectangle. The input rectangle will be clipped against viewport
  ///
  /// **Returns**
  ///
  /// * WGS area of the given screen rectangle
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea transformScreenToWgsRect({
    final RectType<int>? screenRect,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'transformScreenToWgsRect',
      args: screenRect,
    );

    return RectangleGeographicArea.fromJson(resultString['result']);
  }

  /// Convert a WGS84 coordinate to a screen coordinate.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* WGS Coordinates
  ///
  /// **Returns**
  ///
  /// * The screen coordinates relative to view parent screen
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Point<int> transformWgsToScreen(final Coordinates coords) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'transformWgsToScreen',
      args: coords,
    );

    return XyType<int>.fromJson(resultString['result']).toPoint();
  }

  /// Check if the given scene object visible in the given viewport.
  ///
  /// Does not take into account the object visibility.
  ///
  /// **Parameters**
  ///
  /// * **IN** *mapSceneObject* Map scene object to test
  /// * **IN** *rect* Viewport rectangle in screen coordinates. If no viewport is given, the whole screen is used
  ///
  /// **Returns**
  ///
  /// * True if the given scene object visible in the given viewport, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool checkObjectVisibility({
    MapSceneObject? mapSceneObject,
    RectType<int>? rect,
  }) {
    rect ??= RectType<int>(x: 0, y: 0, width: 0, height: 0);
    mapSceneObject ??= MapSceneObject.getDefPositionTracker();

    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'checkObjectVisibility',
      args: <String, dynamic>{'obj': mapSceneObject.pointerId, 'rc': rect},
    );

    return resultString['result'];
  }

  /// Check if view camera is moving.
  ///
  /// **Returns**
  ///
  /// * True if camera is moving, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isCameraMoving {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'isCameraMoving',
    );

    return resultString['result'];
  }

  /// Convert a list of WGS84 coordinates to screen coordinates.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* list of WGS Coordinates
  ///
  /// **Returns**
  ///
  /// The screen coordinates relative to view parent screen
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Point<int>> transformWgsListToScreen(final List<Coordinates> coords) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'transformWgsListToScreen',
      args: coords,
    );

    final List<dynamic> listJson = resultString['result'];
    final List<Point<int>> retList = listJson
        .map(
          (final dynamic categoryJson) =>
              XyType<int>.fromJson(categoryJson).toPoint(),
        )
        .toList();
    return retList;
  }

  /// Get access to this view's preferences.
  ///
  /// **Returns**
  ///
  /// [MapViewPreferences] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MapViewPreferences get preferences {
    if (_preferences == null) {
      final OperationResult resultString = objectMethod(
        _pointerId,
        'MapView',
        'preferences',
      );

      _preferences = MapViewPreferences.init(
        resultString['result'],
        _mapId,
        _pointerId,
      );
      return _preferences!;
    }
    return _preferences!;
  }

  ///	Set the map north-up oriented.
  ///
  /// **Parameters**
  ///
  /// * **IN** *animation* Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void alignNorthUp({final GemAnimation? animation}) {
    objectMethod(_pointerId, 'MapView', 'alignNorthUp', args: animation);
  }

  /// Get the maximum zoom level. Bigger zoom factor means closer to the map.
  ///
  /// **Returns**
  ///
  /// * The maximum zoom level configured for the map view.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get maxZoomLevel {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getMaxZoomLevel',
    );

    return resultString['result'];
  }

  /// Set the configured max zoom level.
  ///
  /// **Parameters**
  ///
  /// * **IN** *zoomLevel* The max zoom level
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set maxZoomLevel(final int zoomLevel) {
    objectMethod(_pointerId, 'MapView', 'setMaxZoomLevel', args: zoomLevel);
  }

  /// Get the minimum zoom level. Bigger zoom factor means closer to the map.
  ///
  /// **Returns**
  ///
  /// * The minimum zoom level configured for the map view.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get minZoomLevel {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getMinZoomLevel',
    );

    return resultString['result'];
  }

  /// Set the configured min zoom level.
  ///
  /// **Parameters**
  ///
  /// * **IN** *zoomLevel* The min zoom level
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set minZoomLevel(final int zoomLevel) {
    objectMethod(_pointerId, 'MapView', 'setMinZoomLevel', args: zoomLevel);
  }

  /// Get the maximum slippy zoom level. Bigger zoom factor means closer to the map.
  ///
  /// **Returns**
  ///
  /// * The maximum slippy zoom level configured for the map view.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get maxSlippyZoomLevel {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getMaxSlippyZoomLevel',
    );

    return resultString['result'];
  }

  /// Set a new zoom level centered on the specified screen position.
  ///
  /// This may be between [minZoomLevel] and [maxZoomLevel]
  ///
  /// **Parameters**
  ///
  /// * **IN** *zoomLevel* Zoom level
  /// * **IN** *duration* The animation duration in milliseconds (0 means no animation).
  /// * **IN** *screenPosition* Screen coordinates on which the map should stay centered. The coordinates are relative to the parent view screen.
  ///
  /// **Returns**
  ///
  /// * On success, the previous zoom level. On error, the error code (< 0).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int setZoomLevel(
    final int zoomLevel, {
    final int duration = 0,
    final Point<int>? screenPosition,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'setZoomLevel',
      args: <String, Object>{
        'zoomLevel': zoomLevel,
        'duration': duration,
        if (screenPosition != null) 'xy': XyType<int>.fromPoint(screenPosition),
      },
    );

    return resultString['result'];
  }

  bool canZoom(int zoomLevel, {Point<int>? screenPosition}) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'canZoom',
      args: <String, Object>{
        'zoomLevel': zoomLevel,
        if (screenPosition != null) 'xy': XyType<int>.fromPoint(screenPosition),
      },
    );

    return resultString['result'];
  }

  /// Set a new zoom level based on slippy tile level.
  /// When 'follow position' is active, the current position will be used as the reference point for the operation. Otherwise, the screen center will be used. The zoom level may be between 0 and *MaxSlippyZoomLevel*.
  ///
  /// **Parameters**
  ///
  /// * **IN** *zoomLevel* Zoom level
  /// * **IN** *duration* The animation duration in milliseconds (0 means no animation).
  /// * **IN** *screenPosition* Screen coordinates on which the map should stay centered. The coordinates are relative to the parent view screen.
  ///
  /// **Returns**
  ///
  /// The previous zoom level.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double setSlippyZoomLevel(
    final double zoomLevel, {
    final int duration = 0,
    final Point<int>? screenPosition,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'setSlippyZoomLevel',
      args: <String, Object>{
        'zoomLevel': zoomLevel,
        'duration': duration,
        if (screenPosition != null) 'xy': XyType<int>.fromPoint(screenPosition),
      },
    );

    return resultString['result'];
  }

  /// Get the zoom level.
  ///
  /// **Returns**
  ///
  /// The current zoom level.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get zoomLevel {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getZoomLevel',
    );

    return resultString['result'];
  }

  /// Get the slippy zoom level.
  ///
  /// **Returns**
  ///
  /// The current slippy zoom level.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get slippyZoomLevel {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getSlippyZoomLevel',
    );

    return resultString['result'];
  }

  /// Restore following position from a manually adjusted mode (camera position fixed relative to the current/simulated position) to default auto-zoom mode.
  ///
  /// **Parameters**
  ///
  /// * **IN** *animation*	Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void restoreFollowingPosition({final GemAnimation? animation}) {
    objectMethod(
      _pointerId,
      'MapView',
      'restoreFollowingPosition',
      args: (animation != null) ? animation : <String, dynamic>{},
    );
  }

  /// Disable highlighting.
  ///
  /// **Parameters**
  ///
  /// * **IN** *highlightId*	The highlighted collection id (optional).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void deactivateHighlight({final int? highlightId}) {
    objectMethod(
      _pointerId,
      'MapView',
      'deactivateHighlight',
      args: (highlightId != null) ? highlightId : <String, dynamic>{},
    );
  }

  /// Disable highlighting.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void deactivateAllHighlights() {
    objectMethod(_pointerId, 'MapView', 'deactivateAllHighlights');
  }

  /// Get highlighted geographic area.
  ///
  /// **Parameters**
  ///
  /// * **IN** *highlightId*	An identifier for the highlight whose area is to be retrieved, with a default value of 0.
  ///
  /// **Returns**
  ///
  /// * A RectangleGeographicArea object representing the geographic bounds of the highlighted area
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea? getHighlightArea({final int highlightId = 0}) {
    try {
      final OperationResult resultString = objectMethod(
        _pointerId,
        'MapView',
        'getHighlightArea',
        args: highlightId,
      );

      return RectangleGeographicArea.fromJson(resultString['result']);
    } catch (e) {
      return null;
    }
  }

  /// Activate highlight
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarks* The landmarks to be highlighted
  /// * **IN** *renderSettings*	Specifies the way the provided landmarks are displayed on the map
  /// * **IN** *highlightId* The highlighted collection id (optional). If a highlighted collection with this id already exists, it will be replaced
  ///
  /// Highlighted collections will be displayed in ascending order sorted by highlightId
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void activateHighlight(
    final List<Landmark> landmarks, {
    HighlightRenderSettings? renderSettings,
    final int highlightId = 0,
  }) {
    renderSettings ??= HighlightRenderSettings();
    final LandmarkList landmarkList = LandmarkList.fromList(landmarks);

    objectMethod(
      _pointerId,
      'MapView',
      'activateHighlight',
      args: <String, dynamic>{
        'landmarks': landmarkList.pointerId,
        'renderSettings': renderSettings.toJson(),
        'highlightId': highlightId,
      },
    );
  }

  /// Get highlighted landmarks.
  ///
  /// The highlights need to be activated using a [HighlightRenderSettings] containing [HighlightOptions.showLandmark].
  /// Otherwise the result wil be empty.
  ///
  /// **Parameters**
  ///
  /// * **IN** *heightlightId*	An identifier for the highlight.
  ///
  /// **Returns**
  ///
  /// * A list of landmarks
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> getHighlight(int heightlightId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getHighlight',
      args: heightlightId,
    );

    final LandmarkList landmarkList = LandmarkList.init(resultString['result']);

    return landmarkList.toList();
  }

  /// Activate highlight
  ///
  /// **Parameters**
  ///
  /// * **IN** *overlayItems* The overlay items to be highlighted
  /// * **IN** *renderSettings*	Specifies the way the provided items are displayed on the map
  /// * **IN** *highlightId* The highlighted collection id (optional). If a highlighted collection with this id already exists, it will be replaced
  ///
  /// Highlighted collections will be displayed in ascending order sorted by highlightId
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void activateHighlightOverlayItems(
    final List<OverlayItem> overlayItems, {
    final HighlightRenderSettings? renderSettings,
    final int highlightId = 0,
  }) {
    final OverlayItemList landmarkList = OverlayItemList.fromList(overlayItems);

    objectMethod(
      _pointerId,
      'MapView',
      'activateHighlightOverlayItems',
      args: <String, dynamic>{
        'landmarks': landmarkList.pointerId,
        if (renderSettings != null) 'renderSettings': renderSettings.toJson(),
        'highlightId': highlightId,
      },
    );
  }

  /// Center on the given route.
  ///
  /// The zoom level is automatically selected so that the entire route is visible on the map.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route*	[Route] to be shown.
  /// * **IN** *screenRect*	Screen rectangle where area should be centered. The coordinates are relative to view parent screen.
  /// * **IN** *animation*	Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void centerOnRoute(
    final Route route, {
    final RectType<int>? screenRect,
    final GemAnimation? animation,
  }) {
    objectMethod(
      _pointerId,
      'MapView',
      'centerOnRoute',
      args: <String, dynamic>{
        'route': route.pointerId,
        if (screenRect != null) 'rc': screenRect,
        if (animation != null) 'animation': animation,
      },
    );
  }

  /// Center on the given route part.
  ///
  /// The zoom level is automatically selected so that the entire route is visible on the map.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route*	[Route] to be shown.
  /// * **IN** *startDist*	Specifies the start distance from route begin.
  /// * **IN** *endDist*	Specifies the end distance from route begin.
  /// * **IN** *screenRect*	Screen rectangle where area should be centered. The coordinates are relative to view parent screen.
  /// * **IN** *animation*	Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void centerOnRoutePart(
    final Route route,
    final int startDist,
    final int endDist, {
    final RectType<int>? screenRect,
    final GemAnimation? animation,
  }) {
    objectMethod(
      _pointerId,
      'MapView',
      'centerOnRoutePart',
      args: <String, dynamic>{
        'route': route.pointerId,
        'startDist': startDist,
        'endDist': endDist,
        if (screenRect != null) 'viewRc': screenRect,
        if (animation != null) 'animation': animation,
      },
    );
  }

  /// Center on the given route instruction.
  ///
  /// The route instruction turn arrow will be visible on the map.
  ///
  /// **Parameters**
  ///
  /// * **IN** *routeInstruction*	Routing instruction
  /// * **IN** *zoomLevel*	Zoom level (Use -1 for automatic selection)
  /// * **IN** *screenPosition* Screen coordinate where area should be centered. The coordinates are relative to view parent screen.
  /// * **IN** *viewAngle*	Specifies the map pitch angle.
  /// * **IN** *animation*	Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void centerOnRouteInstruction(
    final RouteInstruction routeInstruction, {
    final double zoomLevel = -1,
    final Point<int> screenPosition = const Point<int>(0, 0),
    final double? viewAngle,
    final GemAnimation? animation,
  }) {
    objectMethod(
      _pointerId,
      'MapView',
      'centerOnRouteInstruction',
      args: <String, Object>{
        'instruction': routeInstruction.pointerId,
        'zoomLevel': zoomLevel,
        'xy': XyType<int>.fromPoint(screenPosition),
        if (viewAngle != null) 'viewAngle': viewAngle,
        if (animation != null) 'animation': animation,
      },
    );
  }

  /// Center on the given traffic event
  ///
  /// **Parameters**
  ///
  /// * **IN** *routeTrafficEvent*	[RouteTrafficEvent] to be shown.
  /// * **IN** *zoomLevel*	Zoom level (Use -1 for automatic selection)
  /// * **IN** *rectangle*	Screen rectangle where area should be centered. The coordinates are relative to view parent screen.
  /// * **IN** *viewAngle*	Specifies the map pitch angle.
  /// * **IN** *animation*	Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void centerOnRouteTrafficEvent(
    RouteTrafficEvent routeTrafficEvent, {
    final double zoomLevel = -1,
    final Rectangle<int> rectangle = const Rectangle<int>(0, 0, 0, 0),
    final double? viewAngle,
    final GemAnimation? animation,
  }) {
    objectMethod(
      _pointerId,
      'MapView',
      'centerOnRouteTrafficEvent',
      args: <String, Object>{
        'traffic': routeTrafficEvent.pointerId,
        'zoomLevel': zoomLevel,
        'rc': RectType<int>.fromRectangle(rectangle),
        if (viewAngle != null) 'viewAngle': viewAngle,
        if (animation != null) 'animation': animation,
      },
    );
  }

  /// Center on the given routes collection.
  ///
  /// All routes from the list will be visible on the map. The zoom level is automatically selected.
  ///
  /// **Parameters**
  ///
  /// * **IN** *routesList* [Route] list to be shown. If no routes are provided then centering is done on the visible routes from [MapViewRoutesCollection].
  /// * **IN** *displayMode* [Route] display mode.
  /// * **IN** *screenRect* Screen viewport rectangle where routes should be centered. The coordinates are relative to view parent screen.
  /// * **IN** *animation* Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void centerOnRoutes({
    final List<Route>? routes,
    final RouteDisplayMode displayMode = RouteDisplayMode.full,
    final RectType<int>? screenRect,
    final GemAnimation? animation,
  }) {
    objectMethod(
      _pointerId,
      'MapView',
      'centerOnRoutes',
      args: <String, dynamic>{
        'routesList':
            (routes != null) ? RouteList.fromList(routes).pointerId : -1,
        'displayMode': displayMode.id,
        if (screenRect != null) 'viewRc': screenRect,
        if (animation != null) 'animation': animation,
      },
    );
  }

  /// Sets the view clipping rectangle in parent screen ratio.
  ///
  /// To reset the clipping area to whole view area call `setClippingArea(viewportF)`
  ///
  /// **Parameters**
  ///
  /// * **IN** *area* The clipping rectangle to set, expressed as a fraction of the parent screen's size (for example, 0.5 for half the screen's width or height). This rectangle defines the visible portion of the MapView.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setClippingArea(RectType<double> area) {
    objectMethod(_pointerId, 'MapView', 'setClippingArea', args: area);
  }

  /// Gets the highlighted items optimal center viewport given the user custom input.
  ///
  /// The returned viewport is adjusted so all highlighted information will be visible
  ///
  /// The user can use this as the input to [centerOnArea]
  ///
  /// **Parameters**
  ///
  /// * **IN** *routes* [Route] list to be shown.
  /// * **IN** *screenRect* Screen viewport rectangle where routes should be centered. If empty, then the whole [viewport] will be used.
  ///
  /// **Returns**
  ///
  /// * The adjusted viewport. The coordinates are relative to view parent screen
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectType<int> getOptimalRoutesCenterViewport(
    final List<Route> routes, {
    final RectType<int>? screenRect,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getOptimalRoutesCenterViewport',
      args: <String, dynamic>{
        'routesList': RouteList.fromList(routes).pointerId,
        if (screenRect != null) 'viewRc': screenRect,
      },
    );

    return RectType<int>.fromJson(resultString['result']);
  }

  /// Get the clipped part of the given route as a record of  (startDistance, endDistance)
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The target route.
  /// * **IN** *screenRect* Clipping rectangle in screen coordinates. If no clip rectangle is given, the whole screen is used
  ///
  /// **Returns**
  ///
  /// * The clipped part of the route as a record of (startDistance, endDistance)
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  (int, int) getVisibleRouteInterval(
    final Route route, {
    final RectType<int>? screenRect,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getVisibleRouteInterval',
      args: <String, dynamic>{
        'route': route.pointerId,
        if (screenRect != null) 'clipRect': screenRect,
      },
    );

    return (
      resultString['result']['first'],
      resultString['result']['second'],
    );
  }

  /// Gets the optimal highlight center viewport given the user custom input.
  ///
  /// The returned viewport is adjusted so all highlight information will be visible
  ///
  /// The user can use this as the input to [centerOnArea]
  ///
  /// **Parameters**
  ///
  /// * **IN** *routes* [Route] list to be shown.
  /// * **IN** *screenRect* viewport rectangle where highlight should be centered. If empty, the whole [viewport] will be used.
  ///
  /// **Returns**
  ///
  /// * The adjusted viewport. The coordinates are relative to view parent screen
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectType<int> getOptimalHighlightCenterViewport({RectType<int>? screenRect}) {
    screenRect ??= RectType<int>(x: 0, y: 0, width: 0, height: 0);

    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getOptimalHighlightCenterViewport',
      args: screenRect,
    );

    return RectType<int>.fromJson(resultString['result']);
  }

  /// Center on the routes visible on the map.
  ///
  /// **Parameters**
  ///
  /// * **IN** *displayMode* [Route] display mode.
  /// * **IN** *screenRect* Screen viewport rectangle where routes should be centered. The coordinates are relative to view parent screen.
  /// * **IN** *animation* Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void centerOnMapRoutes({
    final RouteDisplayMode? displayMode,
    final RectType<int>? screenRect,
    final GemAnimation? animation,
  }) {
    objectMethod(
      _pointerId,
      'MapView',
      'centerOnRoutes',
      args: <String, Object>{
        'routesList': -1,
        if (displayMode != null) 'displayMode': displayMode.id,
        if (screenRect != null) 'viewRc': screenRect,
        if (animation != null) 'animation': animation,
      },
    );
  }

  /// Retrieve the list of routes under the cursor location.
  ///
  /// Use [setCursorScreenPosition] to set the cursor location.
  ///
  /// **Returns**
  ///
  /// * A list of Route objects under the cursor. If no routes are found, the list will be empty.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Route> cursorSelectionRoutes() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'cursorSelectionRoutes',
    );

    return RouteList.init(resultString['result']).toList();
  }

  /// Retrieve the list of landmarks under the cursor location.
  ///
  /// Use [setCursorScreenPosition] to set the cursor location.
  ///
  /// **Returns**
  ///
  /// * A list of Landmark objects under the cursor. If no landmarks are found, the list will be empty.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> cursorSelectionLandmarks() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'cursorSelectionLandmarks',
    );

    return LandmarkList.init(resultString['result']).toList();
  }

  /// Retrieve the list of streets under the cursor location.
  ///
  /// Use [setCursorScreenPosition] to set the cursor location.
  ///
  /// **Returns**
  ///
  /// A list of Street objects under the cursor. If no streets are found, the list will be empty.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> cursorSelectionStreets() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'cursorSelectionStreets',
    );

    return LandmarkList.init(resultString['result']).toList();
  }

  /// Retrieve the list of overlay items under the cursor location.
  ///
  /// Use [setCursorScreenPosition] to set the cursor location.
  ///
  /// **Returns**
  ///
  /// A list of OverlayItem objects under the cursor. If no overlay items are found, the list will be empty.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<OverlayItem> cursorSelectionOverlayItems() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'cursorSelectionOverlayItems',
    );

    return OverlayItemList.init(resultString['result']).toList();
  }

  /// Retrieve the list of overlay items under the cursor location.
  ///
  /// Use [setCursorScreenPosition] to set the cursor location.
  ///
  /// **Parameters**
  ///
  /// * **IN** *overlayId* The overlay id to filter the overlay items.
  ///
  /// **Returns**
  ///
  /// A list of OverlayItem objects under the cursor. If no overlay items are found, the list will be empty.
  List<OverlayItem> cursorSelectionOverlayItemsByType(
    CommonOverlayId overlayId,
  ) {
    return cursorSelectionOverlayItems().where((final OverlayItem item) {
      return item.isOfType(overlayId);
    }).toList();
  }

  /// Retrieves a reference to a list of markers under the current cursor location.
  ///
  /// Use [setCursorScreenPosition] to set the cursor location.
  ///
  /// **Returns**
  ///
  /// A list of [MarkerMatch] objects under the cursor. If no markers are found, the list will be empty.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<MarkerMatch> cursorSelectionMarkers() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'cursorSelectionMarkers',
    );

    return MarkerMatchList.init(resultString['result']).toList();
  }

  /// Retrieve the path under the cursor location.
  ///
  /// Use [setCursorScreenPosition] to set the cursor location.
  ///
  /// **Returns**
  ///
  /// A [Path] object under the cursor. If no path is found returns null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Path? cursorSelectionPath() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'cursorSelectionPath',
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return Path.init(resultString['result']);
  }

  /// Retrieve the list of traffic events under the cursor location.
  ///
  /// Traffic events can include incidents like accidents, roadworks, or traffic jams. This method is useful for applications
  /// that provide real-time traffic information and require user interaction with traffic events.
  ///
  /// Use [setCursorScreenPosition] to set the cursor location.
  ///
  /// **Returns**
  ///
  /// A [Path] object under the cursor. If no path is found returns null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<TrafficEvent> cursorSelectionTrafficEvents() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'cursorSelectionTrafficEvents',
    );

    return TrafficEventList.init(resultString['result']).toList();
  }

  /// Retrieves the scene object under the current cursor selection
  ///
  /// Scene objects can include 3D models, custom drawings, or other complex visual elements added to the map. This
  /// method determines which scene object, if any, is under the cursor, facilitating interactions like selection or manipulation.
  ///
  /// **Returns**
  ///
  /// * The [MapSceneObject] under the cursor. If no scene object is found, this will return null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MapSceneObject? cursorSelectionMapSceneObject() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'cursorSelectionSceneObject',
    );

    if (resultString['result'] == -1) {
      return null;
    }
    return MapSceneObject.init(resultString['result'], _mapId);
  }

  /// Start following the current position.
  ///
  /// Requires automatic map rendering. Disables the cursor if it is enabled.
  ///
  /// **Parameters**
  ///
  /// * **IN** *animation* Specifies the animation to be used by the operation.
  /// * **IN** *zoomLevel* Zoom level where the animation stops. (Use -1 for automatic selection)
  /// * **IN** *viewAngle* Map view angle. Default is `std::numeric_limits<double>::max()` meaning use default specified.
  /// * **IN** *positionObj* Navigation arrow scene object. If empty, a default SDK navigation arrow is used.
  /// * **IN** *trackMethod* The method is called by the camera every time a tracked object position changes (optional).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void startFollowingPosition({
    final GemAnimation? animation,
    final int zoomLevel = -1,
    final double? viewAngle,
    final MapSceneObject? positionObj,
  }) {
    objectMethod(
      _pointerId,
      'MapView',
      'startFollowingPosition',
      args: <String, Object>{
        if (animation != null) 'animation': animation,
        'zoomLevel': zoomLevel,
        if (viewAngle != null) 'viewAngle': viewAngle,
        if (positionObj != null) 'positionObj': positionObj,
      },
    );
  }

  /// Allows the user to draw markers on the map using touch gestures.
  ///
  /// Panning/zooming the map is deactivated.
  ///
  /// **Parameters**
  ///
  /// * **IN** *renderSettings* Render settings for the draw markers
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void enableDrawMarkersMode({MarkerCollectionRenderSettings? renderSettings}) {
    renderSettings ??= MarkerCollectionRenderSettings();

    objectMethod(
      _pointerId,
      'MapView',
      'enabledrawmarkersmode',
      args: renderSettings.toJson(),
    );
  }

  /// Disables the draw markers mode.
  ///
  /// **Returns**
  ///
  /// Landmarks generated during the draw markers mode.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> disableDrawMarkersMode() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'disabledrawmarkersmode',
    );

    return LandmarkList.init(resultString['result']).toList();
  }

  /// Retrieve the set of landmarks on the specified coordinates.
  ///
  /// This is a quick synchronous reverse geocoding method.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords*	Reference [Coordinates] for this operation.
  ///
  /// **Returns**
  ///
  /// A Landmark list containing the nearest locations to the specified coordinates. If no landmarks are found, the list will be empty.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> getNearestLocations(final Coordinates coords) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getNearestLocations',
      args: coords,
    );

    return LandmarkList.init(resultString['result']).toList();
  }

  /// Adds a GeoJSON data buffer as a marker collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *buffer* The GeoJSON data buffer to be added as a marker collection.
  /// * **IN** *name* The name of the marker collection.
  ///
  /// **Returns**
  ///
  /// * The created marker collections
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<MarkerCollection> addGeoJsonAsMarkerCollection(
    final String buffer,
    final String name,
  ) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'addGeoJsonAsMarkerCollection',
      args: <String, String>{'name': name, 'databuffer': buffer},
    );
    final List<MarkerCollection> pRet = List<MarkerCollection>.empty(
      growable: true,
    );

    for (final int markerCollectionId in resultString['result']) {
      pRet.add(MarkerCollection.init(markerCollectionId, 0));
    }
    return pRet;
  }

  Future<Uint8List> _captureAsImage({RectType<int>? rect}) async {
    try {
      if (_captureAsImageCompleter != null) {
        return _captureAsImageCompleter!.future; // Return the existing future
      }
      _captureAsImageCompleter = Completer<Uint8List>();
      rect ??= RectType<int>(x: -1, y: -1, width: -1, height: -1);
      objectMethod(_pointerId, 'MapView', 'captureAsImage', args: rect);
      return _captureAsImageCompleter!.future;
    } catch (e) {
      _captureAsImageCompleter = null;
      rethrow;
    }
  }

  Future<Uint8List?> _captureAsImageAsync() async {
    final Uint8List? resultVal = await GemKitPlatform.instance
        .getChannel(mapId: mapId)
        .invokeMethod('captureScreenshot');
    return resultVal;
  }

  /// Make a screen region capture of the current map in JPEG format.
  ///
  /// No cursor or on-screen information is included on iOS.
  /// On Android it includes the cursor and any on-screen information.
  ///
  /// **Returns**
  ///
  /// * An image of the map shown on the screen.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Future<Uint8List?> captureImage() async {
    if (GemKitPlatform.instance.androidVersion > -1) {
      return _captureAsImageAsync();
    } else {
      return _captureAsImage();
    }
  }

  /// Get the map view current scale ( meters for 1 mm )
  ///
  /// **Returns**
  ///
  /// The map view current scale ( meters for 1 mm )
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get scale {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getScale',
    );

    return resultString['result'];
  }

  /// Get the camera heading in degrees, with respect to Earth
  ///
  /// **Returns**
  ///
  /// * The heading angle of the camera in degrees, where 0 degrees indicates north.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  double get headingInDegrees {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getHeadingInDegrees',
    );

    return resultString['result'];
  }

  /// Get the camera pitch in degrees, with respect to Earth
  ///
  /// **Returns**
  ///
  /// * The pitch angle of the camera in degrees
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  double get pitchInDegrees {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getPitchInDegrees',
    );

    return resultString['result'];
  }

  /// Check if map view contains terrain topography information
  ///
  /// If true, [transformScreenToWgs] function returns coordinates with terrain altitude set
  ///
  /// The map view has terrain topography if the map style includes the terrain elevation layer and data is available on queried location
  /// Data is not available is the current zoom level is set to low.
  ///
  /// **Returns**
  ///
  /// * True if map view contains terrain topography, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get hasTerrainTopography {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'hasTerrainTopography',
    );

    return resultString['result'];
  }

  /// Get altitude at the given coordinates.
  ///
  /// Use [hasTerrainTopography] to check if the map view has the capability to return an altitude at coordinates
  ///
  /// **Parameters**
  ///
  /// * **IN** *coordinates* WGS Coordinates
  ///
  /// **Returns**
  ///
  /// * Altitude as meters from sea level if capability exist, otherwise returns 0
  double getAltitude(Coordinates coordinates) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getAltitude',
      args: coordinates,
    );

    return resultString['result'];
  }

  /// Get access to MapViewExtensions
  ///
  /// **Returns**
  ///
  /// A MapViewExtensions object, providing additional functionalities and extensions specific to the MapView.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MapViewExtensions get extensions {
    if (_extensions == null) {
      final OperationResult resultString = objectMethod(
        _pointerId,
        'MapView',
        'extensions',
      );

      _extensions = MapViewExtensions.init(resultString['result'], _mapId);
    }
    return _extensions!;
  }

  /// Highlight the hovered map label under the given screen coordinates.
  ///
  /// To turn off the hover highlight call the function with (0, 0) screen position
  ///
  /// A recommended implementation is to call `highlightHoveredMapLabel( ..., selectMapObjects = false)` in order to check if a label is hovered
  /// (and eventually update tracking device cursor shape etc) and if the cursor position is stationary for a reasonable time period  (e.g. 500 ms)
  /// `call highlightHoveredMapLabel( ..., selectMapObjects = true)` to retrieve the hovered map object data
  ///
  /// **Parameters**
  ///
  /// ** IN** *screenPosition* The hovered screen point
  /// ** IN** *selectMapObject* If true and a label is hovered, map objects attached to label are returned via IMapViewListener.onHoveredMapLabelHighlighted
  /// If false, no call to onHoveredMapLabelHighlighted is issued.
  ///
  /// ** Returns**
  ///
  /// * [GemError.success] if successful
  /// * [GemError.notFound] if no label was found
  /// * [GemError.activation] if the map is invalid
  /// * [GemError.noMemory] if memory could not be allocated for the highlighted object
  /// * [GemError.inUse] if another operation is in progress
  /// * [GemError] if other error codes are returned
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError highlightHoveredMapLabel(
    final Point<int> screenPosition, {
    final bool selectMapObject = false,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'highlightHoveredMapLabel',
      args: <String, Object>{
        'pt': XyType<int>.fromPoint(screenPosition),
        'selectMapObjects': selectMapObject,
      },
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Get data transfer statistics for this service.
  ///
  /// **Parameters**
  ///
  /// ** IN** *type* The type of service to get statistics for
  ///
  /// **Returns**
  ///
  /// * The transfer statistics
  TransferStatistics getTransferStatistics(ViewOnlineServiceType type) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getTransferStatistics',
      args: type.id,
    );

    return TransferStatistics.init(resultString['result']);
  }

  /// Get the current rendering rule
  ///
  /// **Returns**
  ///
  /// * The current rendering rule
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  @experimental
  RenderRule get renderingRule {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapView',
      'getRenderingRule',
    );

    return RenderRuleExtension.fromId(resultString['result']);
  }

  /// Set the current rendering rule
  ///
  /// Can be used to optimize the performance when the map view is not visible.
  /// By default the rendering rule is [RenderRule.automatic] on iOS and [RenderRule.onDemand] on Android.
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* The rendering rule to set
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  @experimental
  set renderingRule(RenderRule value) {
    if (GemKitPlatform.instance.androidVersion > -1) {
      unawaited(GemKitPlatform.instance
          .getChannel(mapId: mapId)
          .invokeMethod('pauseResumeSurface', value != RenderRule.noRender));
      objectMethod(_pointerId, 'MapView', 'setRenderingRule', args: value.id);
    } else {
      objectMethod(_pointerId, 'MapView', 'setRenderingRule', args: value.id);
    }
  }

  /// Render the map view manually.
  ///
  /// The [renderingRule] must be [RenderRule.onDemand] to use this method
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  @experimental
  void render() {
    objectMethod(_pointerId, 'MapView', 'render');
  }

  /// Mark with pending render request
  ///
  /// The [renderingRule] must be [RenderRule.onDemand] to use this method
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  @experimental
  void markNeedsRender() {
    objectMethod(_pointerId, 'MapView', 'needsRender');
  }

  /// Handle a touch event.
  ///
  /// **Parameters**
  ///
  /// ** IN** *pointerIndex* The pointer index of the touch event
  /// ** IN** *touchType* The type of the touch event. 0 = down, 1 = move, 2 = up, 3 = cancel
  /// ** IN** *x* The x coordinate of the touch event
  /// ** IN** *y* The y coordinate of the touch event
  ///
  /// **Returns**
  ///
  /// * [GemError.success] if successful
  /// * [GemError.activation] if the map is invalid
  /// * [GemError.inUse] if another operation is in progress
  /// * [GemError] if other error codes are returned
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError handleTouchEvent(
    final int pointerIndex,
    final int touchType,
    final int x,
    final int y,
  ) {
    if (GemKitPlatform.instance.androidVersion > -1) {
      unawaited(
        GemKitPlatform.instance.getChannel(mapId: mapId).invokeMethod(
              'handleTouchEvent',
              jsonEncode(<String, int>{
                'x': x,
                'y': y,
                'touchType': touchType,
                'pointerIndex': pointerIndex,
              }),
            ),
      );
      return GemError.success;
    }

    unawaited(
      GemKitPlatform.instance.getChannel(mapId: mapId).invokeMethod<String>(
            'callObjectMethod',
            jsonEncode(<String, dynamic>{
              'id': _pointerId,
              'class': 'MapView',
              'method': 'handleTouchEvent',
              'args': <String, dynamic>{
                'x': x,
                'y': y,
                'touchType': touchType,
                'pointerIndex': pointerIndex,
              },
            }),
          ),
    );
    return GemError.success;
    // final OperationResult resultString = objectMethod(
    //   _pointerId,
    //   'MapView',
    //   'handleTouchEvent',

    // );

    // return GemErrorExtension.fromCode(resultString['gemApiError']);
  }
}
