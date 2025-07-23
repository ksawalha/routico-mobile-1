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
import 'dart:math';

import 'package:gem_kit/core.dart';
import 'package:gem_kit/map.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Controller for a single GemMap instance running on the host platform.
///
/// This class should not be instantiated directly. Instead, use the [GemMap._onMapCreated] callback to obtain an instance of this class.
///
/// {@category Maps & 3D Scene}
class GemMapController extends GemView {
  GemMapController._(super.vid, super.mId) : super.init();
  Timer? _delayedEvent;
  double? _pixelSize;
  bool _isCameraMoving = false;

  MoveCallback? _moveCallback;
  MoveCallback? _touchMoveCallback;
  SwipeCallback? _swipeCallback;
  PinchSwipeCallback? _pinchSwipeCallback;
  PinchCallback? _pinchCallback;
  TouchPinchCallback? _touchPinchCallback;
  TouchCallback? _touchCallback;
  TouchCallback? _touchLongPressCallback;
  TouchCallback? _touchDoubleCallback;
  TouchCallback? _touchTwoCallback;
  TouchCallback? _touchTwoDoubleCallback;

  // Register not exposed as methods are not working
  TouchPointerCallback? _pointerUpCallback;
  TouchPointerCallback? _pointerMoveCallback;
  TouchPointerCallback? _pointerDownCallback;

  FollowPositionStateCallback? _followPositionStateCallback;
  FollowPositionStateCallback? _touchHandlerModifyFollowPosition;
  MapAngleUpdateCallback? _mapAngleUpdateCallback;
  MapViewRenderedCallback? _mapViewRenderedCallback;
  MapViewMoveStateChangedCallback? _mapViewMoveStateChangedCallback;
  ViewportResizedCallback? _viewportResizedCallback;
  RenderMapScaleCallback? _renderMapScaleCallback;
  ShoveCallback? _shoveCallback;

  CursorSelectionCallback<List<Landmark>>? _cursorSelectionCallbackLandmarks;
  CursorSelectionCallback<List<OverlayItem>>?
      _cursorSelectionCallbackOverlayItems;
  CursorSelectionCallback<List<Route>>? _cursorSelectionCallbackRoutes;
  CursorSelectionCallback<List<MarkerMatch>>? _cursorSelectionCallbackMarkers;
  CursorSelectionCallback<List<TrafficEvent>>?
      _cursorSelectionCallbackTrafficEvents;
  CursorSelectionCallback<Path>? _cursorSelectionCallbackPath;
  CursorSelectionCallback<MapSceneObject>?
      _cursorSelectionCallbackMapSceneObject;

  HoveredMapLabelHighlightedLandmarkCallback?
      _hoveredMapLabelHighlightedLandmark;
  HoveredMapLabelHighlightedOverlayItemCallback?
      _hoveredMapLabelHighlightedOverlayItem;
  HoveredMapLabelHighlightedTrafficEventCallback?
      _hoveredMapLabelHighlightedTrafficEvent;

  SetMapStyleCallback? _setMapStyle;

  ///@nodoc
  @internal
  static Future<GemMapController> init(
    final int mapId,
    final GemMapState gemMapState, {
    final double? pixelSize = 1.0,
  }) async {
    final dynamic result = await GemKitPlatform.instance.init(mapId);
    final int viewId = result['viewId'];
    final GemMapController retVal = GemMapController._(viewId, mapId);
    retVal._pixelSize = pixelSize;
    return retVal;
  }

  ///@nodoc
  @internal
  void registerForEventsHandler() {
    GemKitPlatform.instance.registerEventHandler(pointerId, this);

    GemKitPlatform.instance.filterEvents(
        pointerId,
        <String>[
          'mapViewOnTouch',
          'onMove',
          'onTouchMove',
          'onSwipe',
          'onPinchSwipe',
          'onPinch',
          'onTouchPinch',
          'mapViewOnLongDown',
          'onDoubleTouch',
          'onTwoTouches',
          'onTwoDoubleTouches',
          'mapViewFollowPositionEntered',
          'mapViewFollowPositionExited',
          'onEnterTouchHandlerModifyFollowingPosition',
          'onExitTouchHandlerModifyFollowingPosition',
          'onMapAngleUpdate',
          'mapViewResizedEvent',
          'renderMapScale',
          'onShove',
          'onCursorSelectionUpdatedLandmarks',
          'onCursorSelectionUpdatedOverlayItems',
          'onCursorSelectionMarkerMatches',
          'onCursorSelectionUpdatedTrafficEvents',
          'onCursorSelectionUpdatedRoutes',
          'onCursorSelectionPath',
          'onCursorSelectionMapSceneObject',
          'onHoveredMapLabelHighlightedLandmark',
          'onHoveredMapLabelHighlightedOverlayItem',
          'onHoveredMapLabelHighlightedTrafficEvent',
          'onSetMapStyle',
        ],
        true);
  }

  /// Single pointer touch down event.
  ///
  /// A touch event is defined as a pointer down and up within a preset time in milliseconds, and pointer movement has to be less than a preset distance in millimeters.
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* is the position where the event occurred
  void registerTouchCallback(final TouchCallback? touchCallback) {
    _touchCallback = touchCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'mapViewOnTouch',
      touchCallback == null,
    );
  }

  /// Single pointer move event.
  ///
  /// A single pointer move event is defined as a pointer down, followed by a move, followed by a pointer up.
  ///
  /// **Parameters**
  ///
  /// * **IN** *startPos* is the start position involved in move action
  /// * **IN** *endPos* is the end position involved in move action
  void registerMoveCallback(final MoveCallback? moveCallback) {
    _moveCallback = moveCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onMove',
      moveCallback == null,
    );
  }

  /// Single pointer touch move event.
  ///
  /// Touch move mode is enabled by performing a pointer touch immediately followed by a pointer down in same screen area, and then move.
  ///
  /// **Parameters**
  ///
  /// * **IN** *start* is the start position involved in move action
  /// * **IN** *end* is the end position involved in move action
  void registerTouchMoveCallback(final MoveCallback? touchMoveCallback) {
    _touchMoveCallback = touchMoveCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onTouchMove',
      touchMoveCallback == null,
    );
  }

  /// Single pointer swipe (fling) event.
  ///
  /// A single pointer swipe event is defined as a pointer down, followed by a swipe/fast move with pointer going up.
  ///
  /// **Parameters**
  ///
  /// * **IN** *distX* is the difference in pixels on X axis between last two points involved in move action
  /// * **IN** *distY* is the difference in pixels on Y axis between last two points involved in move action
  /// * **IN** *speedMMPerSec* is the moving speed in mm / s
  void registerSwipeCallback(final SwipeCallback? swipeCallback) {
    _swipeCallback = swipeCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onSwipe',
      swipeCallback == null,
    );
  }

  /// Two pointer rotating and zooming, or just zooming, swipe event.
  ///
  /// **Parameters**
  ///
  /// A two pointer rotating and zooming, or just zooming, swipe event is defined as two pointers down, followed by a rotating or zooming pinch/fast move while pointers are lifted up.
  /// * **IN** *centerPosInPix* is the center position in pixels between the two points involved in move action
  /// * **IN** *zoomingSpeedInMMPerSec*  is the moving speed in mm / s of the faster of the 2 pointers; negative to zoom out (pointers moving toward each other) or positive to zoom in (pointers moving away from each other), set to 0 for rotating swipe only.
  /// * **IN** *rotatingSpeedInMMPerSec*  is the moving speed in mm / s of the faster of the 2 pointers; negative to rotate to the left/counterclockwise, positive to rotate to the right/clockwise, set to 0 for zooming swipe only.
  void registerPinchSwipeCallback(
    final PinchSwipeCallback? pinchSwipeCallback,
  ) {
    _pinchSwipeCallback = pinchSwipeCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onPinchSwipe',
      pinchSwipeCallback == null,
    );
  }

  /// Two pointers pinch event.
  ///
  /// **Parameters**
  ///
  /// A two pointers pinch event is defined as two pointers down, followed by any operation performed with them other than pointer up
  /// * **IN** *start1* is the start position for first pointer
  /// * **IN** *start2* is the start position for second pointer
  /// * **IN** *end1* is the end position for first pointer
  /// * **IN** *end2* is the end position for second pointer
  /// * **IN** *center* is the rotation center
  void registerPinchCallback(final PinchCallback? pinchCallback) {
    _pinchCallback = pinchCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onPinch',
      pinchCallback == null,
    );
  }

  /// Two pointers touch pinch event.
  ///
  /// Two fingers touch mode is enabled by performing a single pointer touch immediately followed by two pointers down, with one of the pointers close to the previous touch.
  ///
  /// **Parameters**
  ///
  /// * **IN** *start1* is the start position for first pointer
  /// * **IN** *start2* is the start position for second pointer
  /// * **IN** *end1* is the end position for first pointer
  /// * **IN** *end2* is the end position for second pointer
  /// * **IN** *center* is the rotation center
  void registerTouchPinchCallback(
    final TouchPinchCallback? touchPinchCallback,
  ) {
    _touchPinchCallback = touchPinchCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onTouchPinch',
      touchPinchCallback == null,
    );
  }

  /// Single pointer long touch event.
  ///
  /// A long touch event is defined as a pointer down longer than a preset time in milliseconds and then pointer up, and pointer movement has to be less than a preset distance in millimeters.
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* is the position where the event occurred
  void registerLongPressCallback(final TouchCallback? touchCallback) {
    _touchLongPressCallback = touchCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'mapViewOnLongDown',
      touchCallback == null,
    );
  }

  /// Single pointer double touch event.
  ///
  /// A double touch event is defined as two consecutive touches within a preset time duration in milliseconds, and distance between the two touches has to be less than a preset distance in millimeters.
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* is the position where the event occurred
  void registerDoubleTouchCallback(final TouchCallback? doubleTouchCallback) {
    _touchDoubleCallback = doubleTouchCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onDoubleTouch',
      doubleTouchCallback == null,
    );
  }

  /// Two pointers touch event.
  ///
  /// A two pointers touch event is defined as two simultaneous touches from which the pointer ups are within a preset time in milliseconds.
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* is the mid position of the segment determined by the two pointer positions
  void registerTwoTouchesCallback(final TouchCallback? twoTouchCallback) {
    _touchTwoCallback = twoTouchCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onTwoTouches',
      twoTouchCallback == null,
    );
  }

  /// Two pointers double touch event.
  ///
  /// A two pointers double touch event is defined as two consecutive two-pointer touches from which the pointer ups are within a preset time in milliseconds.
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* is the mid position of the segment determined by the two pointer positions
  void registerTwoDoubleTouchesCallback(
    final TouchCallback? twoDoubleTouchCallback,
  ) {
    _touchTwoDoubleCallback = twoDoubleTouchCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onTwoDoubleTouches',
      twoDoubleTouchCallback == null,
    );
  }

  /// This is called by the map view when it enters/exits the following position
  ///
  /// **Parameters**
  ///
  /// * **IN** *followPositionState* The state of the following position
  void registerFollowPositionStateCallback(
    final FollowPositionStateCallback? followPositionStateUpdatedCallback,
  ) {
    _followPositionStateCallback = followPositionStateUpdatedCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'mapViewFollowPositionEntered',
      followPositionStateUpdatedCallback == null,
    );
    GemKitPlatform.instance.filterEvent(
      pointerId,
      'mapViewFollowPositionExited',
      followPositionStateUpdatedCallback == null,
    );
  }

  /// This is called by the map view when camera entered/exited manually adjusted following position
  ///
  /// **Parameters**
  ///
  /// * **IN** *followPositionState* The state of the following position
  void registerTouchHandlerModifyFollowPositionCallback(
    final FollowPositionStateCallback? touchHandlerModifyFollowPositionCallback,
  ) {
    _touchHandlerModifyFollowPosition =
        touchHandlerModifyFollowPositionCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onEnterTouchHandlerModifyFollowingPosition',
      touchHandlerModifyFollowPositionCallback == null,
    );
    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onExitTouchHandlerModifyFollowingPosition',
      touchHandlerModifyFollowPositionCallback == null,
    );
  }

  /// This is called by the map view when the map angle is changed
  ///
  /// This happens when either the user rotates the map, or the GPS angle is changed while in tracking mode
  ///
  /// **Parameters**
  ///
  /// * **IN** *angle* New angle of the map view
  void registerMapAngleUpdateCallback(
    final MapAngleUpdateCallback? mapAngleUpdatedCallback,
  ) {
    _mapAngleUpdateCallback = mapAngleUpdatedCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onMapAngleUpdate',
      mapAngleUpdatedCallback == null,
    );
  }

  /// Register to receive move state events from Native side.
  ///
  /// This event is sent when the map starts or stops moving.
  void registerMapViewMoveStateChangedCallback(
    final MapViewMoveStateChangedCallback? onMapViewMoveStateChangedCallback,
  ) {
    _mapViewMoveStateChangedCallback = onMapViewMoveStateChangedCallback;
  }

  /// Register to receive view rendered events from Native side
  ///
  /// This event is sent when the map gets rendered
  void registerViewRenderedCallback(
    final MapViewRenderedCallback? onMapViewRenderedCallback,
  ) {
    _mapViewRenderedCallback = onMapViewRenderedCallback;
  }

  /// Notifies that canvas was resized because of the screen resize
  ///
  /// **Parameters**
  ///
  /// * **IN** *viewport* The new dimensions of the viewport
  void registerViewportResizedCallback(
    final ViewportResizedCallback? viewportResizedCallback,
  ) {
    _viewportResizedCallback = viewportResizedCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'mapViewResizedEvent',
      viewportResizedCallback == null,
    );
  }

  /// Called by the map view when map scale needs to be rendered
  ///
  /// The [MapViewPreferences.showMapScale] needs to be set to true in order for this callback to be called.
  /// In order to customize the range of domains for the [scaleWidth] use the [MapViewPreferences.mapScalePosition] setter
  ///
  /// **Parameters**
  ///
  /// * **IN** *scaleWidth* Width of the scale bar
  /// * **IN** *scaleValue* Value of the scale bar
  /// * **IN** *scaleUnits* Units of the scale bar
  void registerRenderMapScaleCallback(
    final RenderMapScaleCallback? scaleCallback,
  ) {
    _renderMapScaleCallback = scaleCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'renderMapScale',
      scaleCallback == null,
    );
  }

  /// Called by the map view when a two pointer shove event is triggered
  ///
  /// Two pointers move with distance between pointers and pointers angle remaining inside predefined thresholds.
  ///
  /// **Parameters**
  ///
  /// * **IN** *pointersAngleDeg* the angle in degrees determined by the two pointers involved in gesture
  /// * **IN** *initial* the mid point of the segment determined by the two pointers initial touch down positions
  /// * **IN** *start* the mid point of the segment determined by the two pointers previous positions
  /// * **IN** *end* the mid point of the segment determined by the two pointers current positions
  void registerShoveCallback(final ShoveCallback? shoveCallback) {
    _shoveCallback = shoveCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onShove',
      shoveCallback == null,
    );
  }

  /// This is called by the map view when the cursor is over a set of landmarks
  ///
  /// **Parameters**
  ///
  /// * **IN** *selectedItem* the list of landmarks selected
  void registerCursorSelectionUpdatedLandmarksCallback(
    final CursorSelectionCallback<List<Landmark>>?
        cursorSelectionLandmarksCallback,
  ) {
    _cursorSelectionCallbackLandmarks = cursorSelectionLandmarksCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onCursorSelectionUpdatedLandmarks',
      cursorSelectionLandmarksCallback == null,
    );
  }

  /// This is called by the map view when the cursor is over a set of traffic events
  ///
  /// **Parameters**
  ///
  /// * **IN** *selectedItem* the list of overlay items selected
  void registerCursorSelectionUpdatedOverlayItemsCallback(
    final CursorSelectionCallback<List<OverlayItem>>?
        cursorSelectionOverlayItemsCallback,
  ) {
    _cursorSelectionCallbackOverlayItems = cursorSelectionOverlayItemsCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onCursorSelectionUpdatedOverlayItems',
      cursorSelectionOverlayItemsCallback == null,
    );
  }

  /// This is called by the map view when the cursor is over a set of markers
  ///
  /// **Parameters**
  ///
  /// * **IN** *selectedItem* the list of markers selected
  void registerCursorSelectionUpdatedMarkersCallback(
    final CursorSelectionCallback<List<MarkerMatch>>?
        cursorSelectionMarkersCallback,
  ) {
    _cursorSelectionCallbackMarkers = cursorSelectionMarkersCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onCursorSelectionMarkerMatches',
      cursorSelectionMarkersCallback == null,
    );
  }

  /// This is called by the map view when the cursor is over a set of traffic events
  ///
  /// **Parameters**
  ///
  /// * **IN** *selectedItem* the list of traffic events selected
  void registerCursorSelectionUpdatedTrafficEventsCallback(
    final CursorSelectionCallback<List<TrafficEvent>>?
        cursorSelectionRouteTrafficCallback,
  ) {
    _cursorSelectionCallbackTrafficEvents = cursorSelectionRouteTrafficCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onCursorSelectionUpdatedTrafficEvents',
      cursorSelectionRouteTrafficCallback == null,
    );
  }

  /// This is called by the map view when the cursor is over a set of routes
  ///
  /// **Parameters**
  ///
  /// * **IN** *selectedItem* the list of routes selected
  void registerCursorSelectionUpdatedRoutesCallback(
    final CursorSelectionCallback<List<Route>>? cursorSelectionRoutesCallback,
  ) {
    _cursorSelectionCallbackRoutes = cursorSelectionRoutesCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onCursorSelectionUpdatedRoutes',
      cursorSelectionRoutesCallback == null,
    );
  }

  /// This is called by the map view when the cursor is over a path
  ///
  /// **Parameters**
  ///
  /// * **IN** *selectedItem* the path selected
  void registerCursorSelectionUpdatedPathCallback(
    final CursorSelectionCallback<Path>? cursorSelectionPathCallback,
  ) {
    _cursorSelectionCallbackPath = cursorSelectionPathCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onCursorSelectionPath',
      cursorSelectionPathCallback == null,
    );
  }

  /// This is called by the map view when the cursor is over the map scene object
  ///
  /// **Parameters**
  ///
  /// * **IN** *selectedItem* the map scene object selected
  void registerCursorSelectionUpdatedMapSceneObjectCallback(
    final CursorSelectionCallback<MapSceneObject>?
        cursorSelectionMapSceneObjectCallback,
  ) {
    _cursorSelectionCallbackMapSceneObject =
        cursorSelectionMapSceneObjectCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onCursorSelectionMapSceneObject',
      cursorSelectionMapSceneObjectCallback == null,
    );
  }

  /// This is called by the map view when a map label hovering was enabled
  ///
  /// Label hovering can be triggered via highlightHoveredMapLabel
  ///
  /// **Parameters**
  ///
  /// * **IN** *obj* The Landmark object that is being highlighted
  void registerHoveredMapLabelHighlightedLandmarkCallback(
    final HoveredMapLabelHighlightedLandmarkCallback?
        hoveredMapLabelHighlightedLandmarkCallback,
  ) {
    _hoveredMapLabelHighlightedLandmark =
        hoveredMapLabelHighlightedLandmarkCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onHoveredMapLabelHighlightedLandmark',
      hoveredMapLabelHighlightedLandmarkCallback == null,
    );
  }

  /// This is called by the map view when a map label hovering was enabled
  ///
  /// Label hovering can be triggered via highlightHoveredMapLabel
  ///
  /// **Parameters**
  ///
  /// * **IN** *obj* The OverlayItem object that is being highlighted
  void registerHoveredMapLabelHighlightedOverlayItemCallback(
    final HoveredMapLabelHighlightedOverlayItemCallback?
        hoveredMapLabelHighlightedOverlayItemCallback,
  ) {
    _hoveredMapLabelHighlightedOverlayItem =
        hoveredMapLabelHighlightedOverlayItemCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onHoveredMapLabelHighlightedOverlayItem',
      hoveredMapLabelHighlightedOverlayItemCallback == null,
    );
  }

  /// This is called by the map view when a map label hovering was enabled
  ///
  /// Label hovering can be triggered via highlightHoveredMapLabel
  ///
  /// **Parameters**
  ///
  /// * **IN** *obj* The TrafficEvent object that is being highlighted
  void registerHoveredMapLabelHighlightedTrafficEventCallback(
    final HoveredMapLabelHighlightedTrafficEventCallback?
        hoveredMapLabelHighlightedTrafficEventCallback,
  ) {
    _hoveredMapLabelHighlightedTrafficEvent =
        hoveredMapLabelHighlightedTrafficEventCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onHoveredMapLabelHighlightedTrafficEvent',
      hoveredMapLabelHighlightedTrafficEventCallback == null,
    );
  }

  /// Map style changed notification
  ///
  /// **Parameters**
  ///
  /// * **IN** *id* Style content store item id. See [ContentStoreItem.id]
  /// * **IN** *stylePath* Style local file path. See [ContentStoreItem.fileName]
  /// * **IN** *viaApi* True if the style was changed via a `setStyle...` method. False if a default style was applied internally.
  void registerSetMapStyleCallback(
    final SetMapStyleCallback? setMapStyleCallback,
  ) {
    _setMapStyle = setMapStyleCallback;

    GemKitPlatform.instance.filterEvent(
      pointerId,
      'onSetMapStyle',
      setMapStyleCallback == null,
    );
  }

  @override
  void onViewportResized(final Rectangle<int> viewportIn) {
    _viewportResizedCallback?.call(viewportIn);
  }

  @override
  void onTouch(final Point<int> pos) {
    _touchCallback?.call(pos);
  }

  @override
  void onLongPress(final Point<int> pos) {
    _touchLongPressCallback?.call(pos);
  }

  @override
  void onPointerUp(final int pointerId, final Point<num> pos) {
    _pointerUpCallback?.call(pointerId, pos);
  }

  @override
  void onPointerMove(final int pointerId, final Point<num> pos) {
    _pointerMoveCallback?.call(pointerId, pos);
  }

  @override
  void onPointerDown(final int pointerId, final Point<num> pos) {
    _pointerDownCallback?.call(pointerId, pos);
  }

  @override
  void onMove(final Point<num> startPoint, final Point<num> endPoint) {
    _moveCallback?.call(startPoint, endPoint);
  }

  @override
  void onPinch(
    final Point<int> start1,
    final Point<int> start2,
    final Point<int> end1,
    final Point<int> end2,
    final Point<int> center,
  ) {
    _pinchCallback?.call(start1, start2, end1, end2, center);
  }

  @override
  void onPinchSwipe(
    final Point<int> centerPosInPix,
    final double zoomingSpeedInMMPerSec,
    final double rotatingSpeedInMMPerSec,
  ) {
    _pinchSwipeCallback?.call(
      centerPosInPix,
      zoomingSpeedInMMPerSec,
      rotatingSpeedInMMPerSec,
    );
  }

  @override
  void onSwipe(final int distX, final int distY, final double speedMmPerSec) {
    _swipeCallback?.call(distX, distY, speedMmPerSec);
  }

  @override
  void onTouchMove(final Point<int> startPos, final Point<int> endPos) {
    _touchMoveCallback?.call(startPos, endPos);
  }

  @override
  void onTouchPinch(
    final Point<int> start1,
    final Point<int> start2,
    final Point<int> end1,
    final Point<int> end2,
  ) {
    _touchPinchCallback?.call(start1, start2, end1, end2);
  }

  @override
  void onFollowPositionState(final FollowPositionState followPositionState) {
    _followPositionStateCallback?.call(followPositionState);
  }

  @override
  void onTouchHandlerModifyFollowPosition(
    final FollowPositionState followPositionState,
  ) {
    _touchHandlerModifyFollowPosition?.call(followPositionState);
  }

  @override
  void onMapAngleUpdate(final double angle) {
    _mapAngleUpdateCallback?.call(angle);
  }

  /// External rendering for custom markers notification
  @override
  void onMarkerRender(final dynamic data) {
    preferences.markers.onMarkerRender(this, data);
  }

  @override
  void onRenderMapScale(
    final int scaleWidth,
    final int scaleValue,
    final String scaleUnits,
  ) {
    _renderMapScaleCallback?.call(scaleWidth, scaleValue, scaleUnits);
  }

  /// Called by the View after rendering is finished
  @override
  void onViewRendered(final dynamic data) {
    // if (data['markersIds']!.length > 0) {

    if (_mapViewMoveStateChangedCallback != null) {
      final bool cameraIsMoving = data['cameraStatus'] != 0;
      final Coordinates topLeft = Coordinates.fromLatLong(
        data['leftTopX'],
        data['leftTopY'],
      );
      final Coordinates rightBottom = Coordinates.fromLatLong(
        data['rightBottomX'],
        data['rightBottomY'],
      );

      //bool viewDataTransitionStatus = data['viewDataTransitionStatus'];
      final RectangleGeographicArea pArea = RectangleGeographicArea(
        topLeft: topLeft,
        bottomRight: rightBottom,
      );
      if (_isCameraMoving != cameraIsMoving) {
        //if(viewDataTransitionStatus == false) {
        _isCameraMoving = cameraIsMoving;
        if (_mapViewMoveStateChangedCallback != null) {
          if (_delayedEvent != null) {
            _delayedEvent!.cancel();
          }
          _delayedEvent = Timer(const Duration(milliseconds: 100), () {
            _mapViewMoveStateChangedCallback!(cameraIsMoving, pArea);
          });
        }
        //}
      }
    }
    preferences.markers.onViewRendered(data);
    if (_mapViewRenderedCallback != null) {
      _mapViewRenderedCallback!(MapViewRenderInfo.fromJson(data));
    }
    // }
  }

  @override
  void onShove(
    final double pointersAngleDeg,
    final Point<int> initial,
    final Point<int> start,
    final Point<int> end,
  ) {
    _shoveCallback?.call(pointersAngleDeg, initial, start, end);
  }

  @override
  void onCursorSelectionUpdatedLandmarks(final List<Landmark> landmarks) {
    _cursorSelectionCallbackLandmarks?.call(landmarks);
  }

  @override
  void onCursorSelectionUpdatedMarkers(final List<MarkerMatch> markerMatches) {
    _cursorSelectionCallbackMarkers?.call(markerMatches);
  }

  @override
  void onCursorSelectionUpdatedOverlayItems(
    final List<OverlayItem> overlayItems,
  ) {
    _cursorSelectionCallbackOverlayItems?.call(overlayItems);
  }

  @override
  void onCursorSelectionUpdatedPath(final Path path) {
    _cursorSelectionCallbackPath?.call(path);
  }

  @override
  void onCursorSelectionUpdatedRoutes(final List<Route> routes) {
    _cursorSelectionCallbackRoutes?.call(routes);
  }

  @override
  void onCursorSelectionUpdatedTrafficEvents(
    final List<TrafficEvent> trafficEvents,
  ) {
    _cursorSelectionCallbackTrafficEvents?.call(trafficEvents);
  }

  @override
  void onCursorSelectionUpdatedMapSceneObject(
    final MapSceneObject mapSceneObject,
  ) {
    _cursorSelectionCallbackMapSceneObject?.call(mapSceneObject);
  }

  @override
  void onHoveredMapLabelHighlightedLandmark(final Landmark object) {
    _hoveredMapLabelHighlightedLandmark?.call(object);
  }

  @override
  void onHoveredMapLabelHighlightedOverlayItem(final OverlayItem object) {
    _hoveredMapLabelHighlightedOverlayItem?.call(object);
  }

  @override
  void onHoveredMapLabelHighlightedTrafficEvent(final TrafficEvent object) {
    _hoveredMapLabelHighlightedTrafficEvent?.call(object);
  }

  @override
  void onDoubleTouch(final Point<int> pos) {
    _touchDoubleCallback?.call(pos);
  }

  @override
  void onTwoDoubleTouches(final Point<int> pos) {
    _touchTwoDoubleCallback?.call(pos);
  }

  @override
  void onTwoTouches(final Point<int> pos) {
    _touchTwoCallback?.call(pos);
  }

  @override
  void onSetMapStyle(final int id, final String stylePath, final bool viaApi) {
    _setMapStyle?.call(id, stylePath, viaApi);
  }

  /// The number of device pixels for each logical pixel.
  double get devicePixelSize => _pixelSize!;

  @override
  Future<void> dispose() async {
    await releaseView();
  }
}

/// Callback for touch events
typedef TouchCallback = void Function(Point<int> pos);

/// Callback for pointer up/move/down events
typedef TouchPointerCallback = void Function(int pointerId, Point<num> pos);

/// Callback for move events
typedef MoveCallback = void Function(Point<num> start, Point<num> end);

/// Callback for follow position state events
typedef FollowPositionStateCallback = void Function(FollowPositionState state);

/// Callback for map angle update events
typedef MapAngleUpdateCallback = void Function(double value);

/// Callback for map view move state events
typedef MapViewMoveStateChangedCallback = void Function(
    bool isCameraMoving, RectangleGeographicArea area);

/// Callback for map view rendered events
typedef MapViewRenderedCallback = void Function(MapViewRenderInfo data);

/// Callback for viewport resized events
typedef ViewportResizedCallback = void Function(Rectangle<int> viewport);

/// Callback for map scale events
typedef RenderMapScaleCallback = void Function(
    int scaleWidth, int scaleValue, String scaleUnits);

/// Callback for shove events
typedef ShoveCallback = void Function(
  double pointersAngleDeg,
  Point<num> initial,
  Point<num> start,
  Point<num> end,
);

/// Callback for cursor selection events
typedef CursorSelectionCallback<T> = void Function(T selectedItem);

/// Callback for swipe events
typedef SwipeCallback = void Function(
    int distX, int distY, double speedMMPerSec);

/// Callback for pinh and swipe events
typedef PinchSwipeCallback = void Function(
  Point<int> centerPosInPix,
  double zoomingSpeedInMMPerSec,
  double rotatingSpeedInMMPerSec,
);

/// Callback for pinch events
typedef PinchCallback = void Function(
  Point<int> start1,
  Point<int> start2,
  Point<int> end1,
  Point<int> end2,
  Point<int> center,
);

/// Callback for touch and pinch events
typedef TouchPinchCallback = void Function(
  Point<int> start1,
  Point<int> start2,
  Point<int> end1,
  Point<int> end2,
);

/// Callback for map label highlighted landmark event
typedef HoveredMapLabelHighlightedLandmarkCallback = void Function(
    Landmark object);

/// Callback for map label highlighted overlay item event
typedef HoveredMapLabelHighlightedOverlayItemCallback = void Function(
    OverlayItem object);

/// Callback for map label highlighted route traffic event
typedef HoveredMapLabelHighlightedTrafficEventCallback = void Function(
    TrafficEvent object);

/// Callback for set map style event
typedef SetMapStyleCallback = void Function(
    int id, String stylePath, bool viaApi);
