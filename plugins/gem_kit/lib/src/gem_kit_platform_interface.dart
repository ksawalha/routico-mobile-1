// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

/// @nodoc
library;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gem_kit/content_store.dart';
import 'package:gem_kit/core.dart';
import 'package:gem_kit/map.dart';
import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/core/gem_object_interface.dart';
import 'package:gem_kit/src/gem_kit_native.dart'
    if (dart.library.html) 'package:gem_kit/src/gem_kit_native_web.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _CacheEntry {
  _CacheEntry(this.image, this.timestamp);

  final Uint8List image;
  DateTime timestamp;
}

/// Platform initialization.
class GemKitPlatform extends PlatformInterface {
  GemKitPlatform() : super(token: gemToken) {
    _startPeriodicCleanup();
  }

  final Map<String, _CacheEntry> _cache = HashMap<String, _CacheEntry>();
  final Duration _cacheDuration = const Duration(minutes: 1);
  // ignore: unused_field, use_late_for_private_fields_and_variables
  Timer? _cleanupTimer;

  /// Constructs a GemMapsPlatform.
  static final Object gemToken = Object();

  GemSdkNative gemKit = GemSdkNative();

  static GemKitPlatform? _gemInstance;

  /// The default instance of [GemKitPlatform] to use.
  static GemKitPlatform get instance {
    _gemInstance ??= GemKitPlatform();
    return _gemInstance!;
  }

  static Future<void> disposeGemSdk() async {
    SdkSettings.reset();
    SoundPlayingService.reset();

    final Map<dynamic, EventHandler> mapCopy = <dynamic, EventHandler>{
      ...instance.eventHandlerMap,
    };
    for (final MapEntry<dynamic, EventHandler> entry in mapCopy.entries) {
      final int? idAsInt = int.tryParse(entry.key);
      if (idAsInt == null) {
        continue;
      }
      final bool isAlive = instance.gemKit.isObjectAlive(idAsInt);
      if (!isAlive) {
        continue;
      }
      await entry.value.dispose();
    }
    instance.eventHandlerMap.clear();
    instance._cache.clear();
    await GemKitPlatform.instance.getChannel(mapId: -1).invokeMethod(
        'releaseEngine',
        jsonEncode(<String, dynamic>{'dummyKey': 'dummyValue'}));
    _gemInstance?.gemKit.release();
    _gemInstance = null;
  }

  /// Platform-specific implementations should set this with their own platform-specific class that extends [GemKitPlatform] when they register themselves.
  static set instance(final GemKitPlatform instance) {
    PlatformInterface.verifyToken(instance, gemToken);
    _gemInstance = instance;
  }

  /// Initializes the platform interface with [mapId].
  ///
  /// This method is called when the plugin is first initialized.
  Future<dynamic> init(final int mapId) async {
    final MethodChannel channel = ensureChannelInitialized(mapId);
    final String? result = await channel.invokeMethod<String>('waitForViewId');
    final dynamic viewId = jsonDecode(result!);
    return viewId;
  }

  // Keep a collection of id -> channel
  // Every method call passes the int mapId
  final Map<int, MethodChannel> _channels = <int, MethodChannel>{};

  /// Returns the channel for [mapId], creating it if it doesn't already exist.
  @visibleForTesting
  MethodChannel ensureChannelInitialized(final int mapId) {
    MethodChannel? channel = _channels[mapId];
    if (channel == null) {
      if (mapId == -1) {
        channel = const MethodChannel('plugins.flutter.dev/gem_engine');
      } else {
        channel = MethodChannel('plugins.flutter.dev/gem_maps_$mapId');
      }
      channel.setMethodCallHandler(
        (final MethodCall call) => _handleMethodCall(call, mapId),
      );
      _channels[mapId] = channel;
    }
    return channel;
  }

  Future<dynamic> _handleMethodCall(
    final MethodCall call,
    final int mapId,
  ) async {
    if (call.method == 'networkEvent') {
      await handleNetworkEvent(call);
    } else {
      await gemEventsMethodHandler(call);
    }
  }

  /// Map with viewId and EventHandler
  Map<dynamic, EventHandler> eventHandlerMap = <dynamic, EventHandler>{};

  void registerEventHandler(final dynamic listenerId, final EventHandler ptr) {
    eventHandlerMap[listenerId.toString()] = ptr;
  }

  void unregisterEventHandler(final dynamic listenerId) {
    eventHandlerMap.remove(listenerId.toString());
  }

  void filterEvent(
    final dynamic listenerId,
    final String eventName,
    final bool blacklist,
  ) {
    callObjectMethod(
      jsonEncode(<String, Object>{
        'id': 0,
        'class': 'EventHandlerFilter',
        'method': 'filterEvent',
        'args': <String, dynamic>{
          'listener': listenerId,
          'event': eventName,
          'isBlacklist': blacklist,
        },
      }),
    );
  }

  void filterEvents(
    final dynamic listenerId,
    final List<String> eventNames,
    final bool blacklist,
  ) {
    callObjectMethod(
      jsonEncode(<String, Object>{
        'id': 0,
        'class': 'EventHandlerFilter',
        'method': 'filterEvents',
        'args': <String, dynamic>{
          'listener': listenerId,
          'events': eventNames,
          'isBlacklist': blacklist,
        },
      }),
    );
  }

  EventHandler? getEventHandler(final dynamic listenerId) {
    return eventHandlerMap[listenerId.toString()];
  }

  void gemEventsMethodHandlerAndroid(final MethodCall methodCall) {
    final dynamic decodedJson = jsonDecode(methodCall.arguments);
    for (final dynamic iter in decodedJson) {
      dynamic name;
      final BigInt? parsedBigInt = BigInt.tryParse(iter['eventName']);
      if (parsedBigInt != null) {
        name = parsedBigInt.toSigned(64);
      } else {
        final int? parsedInt = int.tryParse(iter['eventName']);
        if (parsedInt != null) {
          name = parsedInt;
        } else {
          // Handle the case where the conversion failed
          // or assign a default value if desired.
        }
      }
      final Map<dynamic, dynamic> decodedArgs = jsonDecode(iter['arguments']);
      eventHandlerMap[name.toString()]?.handleEvent(decodedArgs);
    }
  }

  void nativeMethodHandler(final dynamic iter) {
    dynamic name;
    final BigInt? parsedBigInt = BigInt.tryParse(iter['eventName']);
    if (parsedBigInt != null) {
      name = parsedBigInt.toSigned(64);
    } else {
      final int? parsedInt = int.tryParse(iter['eventName']);
      if (parsedInt != null) {
        name = parsedInt;
      } else {
        // Handle the case where the conversion failed
        // or assign a default value if desired.
      }
    }
    eventHandlerMap[name.toString()]?.handleEvent(iter['arguments']);
  }

  Future<dynamic> gemEventsMethodHandler(final MethodCall methodCall) async {
    dynamic name;
    if (methodCall.method == 'notifyEvents') {
      gemEventsMethodHandlerAndroid(methodCall);
    } else {
      final BigInt? parsedBigInt = BigInt.tryParse(methodCall.method);
      if (parsedBigInt != null) {
        name = parsedBigInt.toSigned(64);
      } else {
        final int? parsedInt = int.tryParse(methodCall.method);
        if (parsedInt != null) {
          name = parsedInt;
        } else {
          // Handle the case where the conversion failed
          // or assign a default value if desired.
        }
      }
      eventHandlerMap[name.toString()]?.handleEvent(
        jsonDecode(methodCall.arguments),
      );
    }
  }

  MethodChannel getChannel({final int mapId = 0}) {
    return ensureChannelInitialized(mapId);
  }

  String callObjectMethod(final String jsonCommand) {
    final String result = gemKit.callObjectMethod(jsonCommand);

    try {
      final dynamic json = jsonDecode(result);
      final int? error = json['gemApiError'];

      ApiErrorServiceImpl.apiErrorAsInt = error is int ? error : 0;
    } catch (e) {
      ApiErrorServiceImpl.apiErrorAsInt = 0;
    }

    return result;
  }

  int callBitmapConstructor(final int width, final int height) {
    return gemKit.callCreateBitmap(width, height);
  }

  Uint8List callGetBitmapBuffer(
    final int id,
    final int width,
    final int height,
  ) {
    return gemKit.callGetBitmap(id, width, height);
  }

  String callCreateObject(final String json) {
    return gemKit.callCreateObject(json);
  }

  void callDeleteObject(final String json) {
    gemKit.callDeleteObject(json);
  }

  GemObject registerWeakRelease(
    final Object obj,
    final dynamic nativeObjectId,
    final int timestamp,
  ) {
    return gemKit.registerWeakRelease(obj, nativeObjectId, timestamp);
  }

  void registerCallbackPointer() {
    //gemKit.registerCallbackPointer();
  }

  Future<void> loadNative({
    final String? appAuthorization,
    final bool allowInternetConnection = true,
    final AutoUpdateSettings autoUpdateSettings = const AutoUpdateSettings(),
  }) async {
    if (!gemKit.initHasBeenDone && !gemKit.loadNativeCalled) {
      ensureChannelInitialized(-1);
      await GemKitPlatform.instance.getChannel(mapId: -1).invokeMethod(
          'initializeGemSdk',
          jsonEncode(<String, dynamic>{'initializeGemSdk': 'dummyValue'}));
      await gemKit.loadNative();

      if (appAuthorization != null) {
        SdkSettings.appAuthorization = appAuthorization;
      }

      gemSdkLogger.finest(
        '[SdkDebug][LoadNative] Setting allow connection (allowInternetConnection: $allowInternetConnection) (canDoAutoUpdateResources: ${autoUpdateSettings.isAutoUpdateForResourcesEnabled})',
      );
      SdkSettings.offBoardListener.autoUpdateSettings = autoUpdateSettings;
      SdkSettings.setAllowInternetConnection(allowInternetConnection);
      ContentStore.refresh();
    }
  }

  bool isObjectAlive(final dynamic id) {
    return gemKit.isObjectAlive(id);
  }

  int get androidVersion {
    return gemKit.getAndroidVersion();
  }

  void setLibLoaded() {
    gemKit.setLibLoaded();
  }

  RenderableImg? callGetFlutterImg(
    final int pointerId,
    final int width,
    final int height,
    final int imageType, {
    final String? arg,
    final int? imageId,
    required final bool allowResize,
  }) {
    return gemKit.callGetFlutterImg(
      pointerId,
      width,
      height,
      imageType,
      arg,
      allowResize,
    );
  }

  Uint8List? callGetImage(
    final int pointerId,
    final String className,
    final int width,
    final int height,
    final int imageType, {
    final String? arg,
    final int? imageId,
  }) {
    final DateTime now = DateTime.now(); // Store current time in a variable

    if (imageId != null) {
      final String cacheKey = _generateCacheKey(imageId, width, height);
      final _CacheEntry? cacheEntry = _cache[cacheKey];
      if (cacheEntry != null &&
          now.difference(cacheEntry.timestamp) < _cacheDuration) {
        // Return cached image if it is still valid
        cacheEntry.timestamp = now; // Update timestamp
        return cacheEntry.image;
      }
    }
    // Get new image and update cache
    final Uint8List? image = gemKit.callGetImage(
      className,
      pointerId,
      width,
      height,
      imageType,
      arg: arg,
    );
    if (image == null) {
      return null;
    }
    if (imageId != null) {
      final String cacheKey = _generateCacheKey(imageId, width, height);
      _cache[cacheKey] = _CacheEntry(image, now); // Use the stored current time
    }

    return image;
  }

  void _clearStaleCacheEntries([
    final int? imageId,
    final int? width,
    final int? height,
  ]) {
    final DateTime now = DateTime.now();
    final List<String> keysToRemove = <String>[];
    _cache.forEach((final String key, final _CacheEntry entry) {
      if (now.difference(entry.timestamp) >= _cacheDuration ||
          (imageId != null &&
              key.startsWith('$imageId-') &&
              !key.endsWith('-$width-$height'))) {
        keysToRemove.add(key);
      }
    });

    keysToRemove.forEach(_cache.remove);
  }

  void _startPeriodicCleanup() {
    _cleanupTimer = Timer.periodic(_cacheDuration, (final Timer timer) {
      _clearStaleCacheEntries();
    });
  }

  Future<void> get initializationDone async {
    return gemKit.initializationDone;
  }

  dynamic createGemImage(final Uint8List data, final int imageType) {
    return gemKit.createGemImage(data, imageType);
  }

  void deleteCPointer(final dynamic pointer) {
    gemKit.deleteCPointer(pointer);
  }

  String _generateCacheKey(
    final int imageId,
    final int width,
    final int height,
  ) {
    return '$imageId-$width-$height';
  }

  Future<dynamic> addList({
    required final MapViewMarkerCollections object,
    required final List<MarkerWithRenderSettings> list,
    required final MarkerCollectionRenderSettings settings,
    required final String name,
    required final dynamic parentMapId,
    final MarkerType markerType = MarkerType.point,
  }) async {
    return gemKit.addList(
      object: object,
      list: list,
      settings: settings,
      name: name,
      parentMapId: parentMapId,
      markerType: markerType,
    );
  }

  dynamic toNativePointer(final Uint8List data) {
    return gemKit.toNativePointer(data);
  }

  void freeNativePointer(final dynamic pointer) {
    gemKit.freeNativePointer(pointer);
  }

  void setMouseInFocus(final bool mouseInFocus, final int viewId) {
    gemKit.setMouseInFocus(mouseInFocus, viewId);
  }

  Future<bool> askForLocationPermission() async {
    return gemKit.askForLocationPermission();
  }

  bool is32BitSystem() {
    return gemKit.is32BitSystem();
  }

  /// Handles network events from the native side.
  Future<void> handleNetworkEvent(MethodCall call) async {
    final String event = call.arguments['event'];

    switch (event) {
      case 'onConnectFinished':
        final int result = call.arguments['result'];
        final String networkType = call.arguments['networkType'];
        final String https = call.arguments['https'];
        final String http = call.arguments['http'];
        // Handle the onConnectFinished event
        debugPrint(
          'onConnectFinished: result=$result, networkType=$networkType, https=$https, http=$http',
        );

      case 'onNetworkFailed':
        final int errorCode = call.arguments['errorCode'];
        // Handle the onNetworkFailed event
        debugPrint('onNetworkFailed: errorCode=$errorCode');

      case 'onMobileCountryCodeChanged':
        final int mcc = call.arguments['mcc'];
        // Handle the onMobileCountryCodeChanged event
        debugPrint('onMobileCountryCodeChanged: mcc=$mcc');

      default:
        debugPrint('Unknown network event: $event');
    }
  }

  bool isSdkInitialized() {
    return gemKit.isSdkInitialized();
  }
}

class ApiErrorServiceImpl {
  static GemError _error = GemError.success;
  static void Function(GemError error)? _onErrorUpdate;

  // Private setter
  static set apiErrorAsInt(final int errorCode) {
    _error = GemErrorExtension.fromCode(errorCode);
    _onErrorUpdate?.call(GemErrorExtension.fromCode(errorCode));
  }

  static GemError get apiError => _error;

  static void registerOnErrorUpdate(
    final void Function(GemError error)? callback,
  ) {
    _onErrorUpdate = callback;
  }
}

class OperationResult {
  OperationResult(this.data);
  final Map<String, dynamic> data;

  dynamic operator [](final String key) {
    return data[key];
  }

  bool containsKey(final String key) {
    return data.containsKey(key);
  }

  // GemError get errorCode => GemErrorExtension.fromCode(data['result']);

  // bool get isSuccess => errorCode == GemError.success;
  // bool get isNotSuccess => errorCode != GemError.success;

  @override
  String toString() {
    return data.toString();
  }
}

OperationResult staticMethod(
  final String className,
  final String method, {
  final Object? args,
}) {
  return objectMethod(0, className, method, args: args);
}

OperationResult objectMethod(
  final int id,
  final String className,
  final String method, {
  final Object? args,
}) {
  final String json = jsonEncode(<String, Object>{
    'id': id,
    'class': className,
    'method': method,
    'args': args ?? <String, dynamic>{},
  });

  final String resultStr = GemKitPlatform.instance.callObjectMethod(json);

  return OperationResult(jsonDecode(resultStr));
}
