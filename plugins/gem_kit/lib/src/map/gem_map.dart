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
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart' show Factory, kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gem_kit/core.dart';
import 'package:gem_kit/map.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:gem_kit/src/map/gem_map_linux.dart';
import 'package:logging/logging.dart';

/// Handler for mouse and pointer events
///
/// {@category Maps & 3D Scene}
class PointerEventHandler {
  void Function(PointerEnterEvent)? _mouseEnteredCallback;
  void Function(PointerExitEvent)? _mouseExitedCallback;
  void Function(PointerHoverEvent)? _pointerHoverEventCallback;
  void Function(PointerDownEvent)? _pointerDownEventCallback;
  void Function(PointerMoveEvent)? _pointerMoveEventCallback;
  void Function(PointerUpEvent)? _pointerUpEventCallback;
  void Function(PointerCancelEvent)? _pointerCancelEventCallback;

  void registerOnMouseEnterEvent(final void Function(PointerEnterEvent) pFunc) {
    _mouseEnteredCallback = pFunc;
  }

  void registerOnMouseExitEvent(final void Function(PointerExitEvent) pFunc) {
    _mouseExitedCallback = pFunc;
  }

  void registerOnPointerHoverEvent(
    final void Function(PointerHoverEvent) pFunc,
  ) {
    _pointerHoverEventCallback = pFunc;
  }

  void onMouseEnter(final PointerEnterEvent event) {
    _mouseEnteredCallback?.call(event);
  }

  void onMouseExit(final PointerExitEvent event) {
    _mouseExitedCallback?.call(event);
  }

  void onPointerHover(final PointerHoverEvent event) {
    _pointerHoverEventCallback?.call(event);
  }

  void registerOnPointerDownEvent(final void Function(PointerDownEvent) pFunc) {
    _pointerDownEventCallback = pFunc;
  }

  void registerOnPointerMoveEvent(final void Function(PointerMoveEvent) pFunc) {
    _pointerMoveEventCallback = pFunc;
  }

  void registerOnPointerUpEvent(final void Function(PointerUpEvent) pFunc) {
    _pointerUpEventCallback = pFunc;
  }

  void registerOnPointerCancelEvent(
    final void Function(PointerCancelEvent) pFunc,
  ) {
    _pointerCancelEventCallback = pFunc;
  }

  void onPointerDown(final PointerDownEvent event) {
    _pointerDownEventCallback?.call(event);
  }

  void onPointerMove(final PointerMoveEvent event) {
    _pointerMoveEventCallback?.call(event);
  }

  void onPointerUp(final PointerUpEvent event) {
    _pointerUpEventCallback?.call(event);
  }

  void onPointerCancel(final PointerCancelEvent event) {
    _pointerCancelEventCallback?.call(event);
  }
}

/// Mode of hosting native Android view in Flutter
///
/// {@category Maps & 3D Scene}
enum AndroidViewMode {
  /// auto - checking against the version of Android and selecting the best mode
  auto,

  /// hybridComposition - Is slower on Android versions prior to Android 10.
  hybridComposition,

  /// virtualDisplay - can cause problems on Android 12
  virtualDisplay,
}

/// Callback method for when the map is ready to be used.
///
/// Pass to [GemMap._onMapCreated] to receive a [GemMapController] when the map is created.
typedef MapCreatedCallback = void Function(GemMapController controller);

/// GemMap Widget
///
/// Displays the map on the screen. The map can be controlled using the [GemMapController] provided by the [_onMapCreated] callback.
///
/// {@category Maps & 3D Scene}
class GemMap extends StatefulWidget {
  /// Creates a [GemMap] widget.
  ///
  /// **Parameters**
  ///
  /// * **IN** *onMapCreated* Callback method for when the map is ready to be used.
  ///
  ///
  /// * **IN** *androidViewMode* Mode of hosting native Android view in Flutter. Defaults to [AndroidViewMode.auto].
  ///
  ///
  /// * **IN** *coordinates* Initial coordinates of the center of the map
  ///
  ///
  /// * **IN** *area* Initial area to center the map on
  ///
  ///
  /// * **IN** *zoomLevel* Initial zoom level to center the map on
  ///
  ///
  /// * **IN** *appAuthorization* Application token that enables the SDK. Required for evaluation SDKs. Not taken into account if the SDK has already been initialized.
  ///
  ///
  /// * **IN** *initialMapStyleAsset* A field that holds the asset path for the initial map style.
  ///
  ///   This field represents the path to a map style file (.style extension)
  ///   that is stored in the Flutter project's asset directory. The map style will
  ///   be applied to the map when it is first created.
  ///   The asset path must be relative to the root of the `assets` directory, as declared
  ///   in the `pubspec.yaml` file.
  ///
  ///   **Example:**
  ///
  ///   'assets/map_styles/my_map_style.style',
  ///
  /// * **IN** *autoUpdateSettings* Auto update settings. Not taken into account if the SDK has already been initialized.
  ///
  ///   **Related Documentation:**
  ///
  ///   For more details on how to create your own map styles see [Studio Documentation](https://developer.magiclane.com/documentation/OnlineStudio/index.php).
  const GemMap({
    super.key,
    final void Function(GemMapController)? onMapCreated,
    final AndroidViewMode androidViewMode = AndroidViewMode.auto,
    final Coordinates? coordinates,
    final RectangleGeographicArea? area,
    final int? zoomLevel,
    final String? appAuthorization,
    final String? initialMapStyleAsset,
    final bool allowInternetConnection = true,
    final AutoUpdateSettings? autoUpdateSettings,
  })  : _initialMapStyleAsset = initialMapStyleAsset,
        _appAuthorization = appAuthorization,
        _zoomLevel = zoomLevel,
        _area = area,
        _coordinates = coordinates,
        _androidViewMode = androidViewMode,
        _onMapCreated = onMapCreated,
        _autoUpdateSettings = autoUpdateSettings,
        _allowInternetConnection = allowInternetConnection;

  final MapCreatedCallback? _onMapCreated;
  final AndroidViewMode _androidViewMode;
  final Coordinates? _coordinates;
  final RectangleGeographicArea? _area;
  final int? _zoomLevel;
  final String? _appAuthorization;
  final String? _initialMapStyleAsset;
  final AutoUpdateSettings? _autoUpdateSettings;
  final bool _allowInternetConnection;

  @override
  State createState() => GemMapState();
}

/// GemMap State
///
/// {@category Maps & 3D Scene}
class GemMapState extends State<GemMap> {
  final Completer<GemMapController> _controller = Completer<GemMapController>();
  double? _pixelSize;
  PointerEventHandler? _pointerEventHandler;
  final Map<String, dynamic> creationParams = <String, dynamic>{};
  Point<int>? _lastHoverPosition;
  Timer? _hoverTimer;
  @override
  void initState() {
    unawaited(
      GemKitPlatform.instance
          .loadNative(
        autoUpdateSettings:
            widget._autoUpdateSettings ?? const AutoUpdateSettings(),
        allowInternetConnection: widget._allowInternetConnection,
      )
          .then((final _) {
        if (widget._appAuthorization != null &&
            widget._appAuthorization!.isNotEmpty) {
          SdkSettings.appAuthorization = widget._appAuthorization!;
        }
      }),
    );

    creationParams['mapStyleAssetPath'] = widget._initialMapStyleAsset;

    super.initState();
  }

  Widget _buildMouseRegion(final Widget child) {
    _pointerEventHandler ??= PointerEventHandler();

    return MouseRegion(
      onEnter: _pointerEventHandler!.onMouseEnter,
      onExit: _pointerEventHandler!.onMouseExit,
      onHover: _pointerEventHandler!.onPointerHover,
      child: Listener(
        onPointerDown: _pointerEventHandler!.onPointerDown,
        onPointerUp: _pointerEventHandler!.onPointerUp,
        onPointerMove: _pointerEventHandler!.onPointerMove,
        onPointerCancel: _pointerEventHandler!.onPointerCancel,
        child: AbsorbPointer(child: child),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    _pixelSize = mediaQuery.devicePixelRatio;
    if (kIsWeb) {
      return _buildMouseRegion(
        HtmlElementView(
          viewType: 'canvasView',
          onPlatformViewCreated: _onPlatformViewCreated,
        ),
      );
    } else if (Platform.isIOS) {
      return _buildMouseRegion(_buildNativeView(_onPlatformViewCreated));
    } else if (Platform.isAndroid) {
      return _buildMouseRegion(_buildNativeAndroidView(_onPlatformViewCreated));
    } else if (Platform.isLinux) {
      return GemTextureView(onPlatformViewCreated: _onPlatformViewCreatedLinux);
    }
    return Container();
  }

  Widget _buildNativeAndroidView(
    final PlatformViewCreatedCallback onPlatformViewCreated,
  ) {
    // This is used in the platform side to register the view.
    const String viewType = 'plugins.flutter.dev/gem_maps';
    // Pass parameters to the platform side.
    AndroidViewMode viewMode = widget._androidViewMode;
    if (widget._androidViewMode == AndroidViewMode.auto) {
      if (GemKitPlatform.instance.androidVersion != -1 &&
          GemKitPlatform.instance.androidVersion >= 29) {
        viewMode = AndroidViewMode.hybridComposition;
        gemSdkLogger.log(
          Level.FINEST,
          'Auto selected ViewMode. AndroidViewMode.hybridComposition',
        );
      } else {
        viewMode = AndroidViewMode.virtualDisplay;
        gemSdkLogger.log(
          Level.FINEST,
          'Auto selected ViewMode. AndroidViewMode.virtualDisplay',
        );
      }
    }

    if (viewMode == AndroidViewMode.hybridComposition) {
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory: (
          final BuildContext context,
          final PlatformViewController controller,
        ) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (final PlatformViewCreationParams params) {
          final AndroidViewController controller =
              PlatformViewsService.initExpensiveAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () => params.onFocusChanged(true),
          );
          controller.addOnPlatformViewCreatedListener(
            params.onPlatformViewCreated,
          );
          controller.addOnPlatformViewCreatedListener(onPlatformViewCreated);
          unawaited(controller.create());
          return controller;
        },
      );
    }

    return PlatformViewLink(
      viewType: viewType,
      surfaceFactory: (
        final BuildContext context,
        final PlatformViewController controller,
      ) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (final PlatformViewCreationParams params) {
        final AndroidViewController controller =
            PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () => params.onFocusChanged(true),
        );
        controller.addOnPlatformViewCreatedListener(
          params.onPlatformViewCreated,
        );
        controller.addOnPlatformViewCreatedListener(onPlatformViewCreated);
        unawaited(controller.create());
        return controller;
      },
    );
  }

  Widget _buildNativeView(
    final PlatformViewCreatedCallback onPlatformViewCreated,
  ) {
    // This is used in the platform side to register the view.
    const String viewType = 'plugins.flutter.dev/gem_maps';

    return UiKitView(
      viewType: viewType,
      onPlatformViewCreated: onPlatformViewCreated,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  // ignore: unused_element
  Future<void> _onPlatformViewCreatedLinux(
    final int id,
    final Rectangle<int> viewport,
  ) async {
    await GemKitPlatform.instance.initializationDone;

    final GemMapController controller = await GemMapController.init(
      id,
      this,
      pixelSize: _pixelSize,
    );
    controller.registerForEventsHandler();
    _controller.complete(controller);
    final MapCreatedCallback? onMapCreated = widget._onMapCreated;
    final Coordinates? coordinates = widget._coordinates;
    final RectangleGeographicArea? area = widget._area;
    final int zoomLevel = widget._zoomLevel ?? 16;
    if (coordinates != null) {
      final GemAnimation animation = GemAnimation.none();
      controller.centerOnCoordinates(
        coordinates,
        animation: animation,
        zoomLevel: zoomLevel,
      );
    }
    if (area != null) {
      final GemAnimation animation = GemAnimation.none();
      controller.centerOnArea(area, animation: animation);
    }
    if (onMapCreated != null) {
      onMapCreated(controller);
    }
  }

  Future<void> _onPlatformViewCreated(final int id) async {
    await GemKitPlatform.instance.initializationDone;
    final GemMapController controller = await GemMapController.init(
      id,
      this,
      pixelSize: _pixelSize,
    );

    if (_pointerEventHandler != null) {
      _pointerEventHandler!.registerOnMouseEnterEvent((
        final PointerEnterEvent event,
      ) {
        GemKitPlatform.instance.setMouseInFocus(true, id);
      });
      _pointerEventHandler!.registerOnMouseExitEvent((
        final PointerExitEvent event,
      ) {
        GemKitPlatform.instance.setMouseInFocus(false, id);
      });
      _pointerEventHandler!.registerOnPointerMoveEvent((
        final PointerMoveEvent event,
      ) {
        controller.handleTouchEvent(
          event.device,
          1,
          (event.localPosition.dx * _pixelSize!).toInt(),
          (event.localPosition.dy * _pixelSize!).toInt(),
        );
      });
      _pointerEventHandler!.registerOnPointerDownEvent((
        final PointerDownEvent event,
      ) {
        controller.handleTouchEvent(
          event.device,
          0,
          (event.localPosition.dx * _pixelSize!).toInt(),
          (event.localPosition.dy * _pixelSize!).toInt(),
        );
      });
      _pointerEventHandler!.registerOnPointerUpEvent((
        final PointerUpEvent event,
      ) {
        controller.handleTouchEvent(
          event.device,
          2,
          (event.localPosition.dx * _pixelSize!).toInt(),
          (event.localPosition.dy * _pixelSize!).toInt(),
        );
      });
      _pointerEventHandler!.registerOnPointerCancelEvent((
        final PointerCancelEvent event,
      ) {
        controller.handleTouchEvent(
          event.device,
          3,
          (event.localPosition.dx * _pixelSize!).toInt(),
          (event.localPosition.dy * _pixelSize!).toInt(),
        );
      });
      _pointerEventHandler!.registerOnPointerHoverEvent((
        final PointerHoverEvent event,
      ) {
        final Point<int> currentPosition = Point<int>(
          (event.localPosition.dx * _pixelSize!).toInt(),
          (event.localPosition.dy * _pixelSize!).toInt(),
        );
        if (_lastHoverPosition != currentPosition) {
          _lastHoverPosition = currentPosition;
          _handleHover(currentPosition, controller);
        }
      });
    }
    controller.registerForEventsHandler();
    _controller.complete(controller);
    final MapCreatedCallback? onMapCreated = widget._onMapCreated;
    final Coordinates? coordinates = widget._coordinates;
    final RectangleGeographicArea? area = widget._area;
    final int zoomLevel = widget._zoomLevel ?? 16;
    if (coordinates != null) {
      final GemAnimation animation = GemAnimation.none();
      controller.centerOnCoordinates(
        coordinates,
        animation: animation,
        zoomLevel: zoomLevel,
      );
    }
    if (area != null) {
      final GemAnimation animation = GemAnimation.none();
      controller.centerOnArea(area, animation: animation);
    }
    if (kIsWeb) {
      controller.preferences.mapDetailsQualityLevel =
          MapDetailsQualityLevel.low;
    }
    if (onMapCreated != null) {
      try {
        onMapCreated(controller);
      } catch (e) {
        gemSdkLogger.log(Level.SEVERE, 'Error in onMapCreated: $e');
      }
    }
  }

  @override
  void didUpdateWidget(final GemMap oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    unawaited(_disposeController());
    super.dispose();
  }

  Future<void> _disposeController() async {
    final GemMapController controller = await _controller.future;
    final bool isAlive = GemKitPlatform.instance.gemKit.isObjectAlive(
      controller.pointerId,
    );
    if (!isAlive) {
      return;
    }
    await controller.dispose();
  }

  void _handleHover(Point<int> position, GemMapController controller) {
    // Cancel any previous timer
    _hoverTimer?.cancel();

    // Start a new 1-second timer
    _hoverTimer = Timer(const Duration(seconds: 1), () {
      controller.highlightHoveredMapLabel(position, selectMapObject: true);
    });

    // Immediate feedback while hovering
    controller.highlightHoveredMapLabel(position);
  }
}
