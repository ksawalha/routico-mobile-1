// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

// ignore_for_file: deprecated_member_use
// ignore_for_file: avoid_print

/// @nodoc
library;

import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:html' as html;
import 'dart:js';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:gem_kit/core.dart';
import 'package:gem_kit/map.dart';
import 'package:gem_kit/src/core/gem_object_interface.dart';
import 'package:gem_kit/src/core/gem_object_web.dart';
import 'package:gem_kit/src/gem_kit_native_utils.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:logging/logging.dart';

class WeakRefManager {
  static void register(final Object dartObject, final String name) {
    final JsFunction finalizationRegistryConstructor =
        context['FinalizationRegistry'];

    // Create an instance of FinalizationRegistry
    final JsObject registry =
        JsObject(finalizationRegistryConstructor, <dynamic>[
      allowInterop((final Object heldValue) {
        gemSdkLogger.log(
          Level.SEVERE,
          'Object $heldValue is being garbage-collected!',
        );
      }),
    ]);

    // Register the object with FinalizationRegistry
    registry.callMethod('register', <dynamic>[dartObject, name]);
  }
}

class GemSdkNative {
  Completer<void> initializationCompleter = Completer<void>();
  static int androidVersion = -1;
  bool initHasBeenDone = false;
  bool loadNativeCalled = false;
  final List<List<int>> _touchEventBatch = <List<int>>[];
  Timer? _batchTimer;
  Future<void> get initializationDone => initializationCompleter.future;
  dynamic _pointerFunc;
  int getAndroidVersion() {
    return androidVersion;
  }

  Future<void> loadNative() async {
    if (loadNativeCalled) {
      return;
    }
    loadNativeCalled = true;
    await initializationCompleter.future;
    registerCallbackPointer();
  }

  static void callbackHandler(final int messageChar) {
    final JsObject pWebRTCModule = context['Module'];
    final String message = pWebRTCModule.callMethod('UTF8ToString', <int>[
      messageChar,
    ]);
    final dynamic decodedMessage = jsonDecode(message);
    GemKitPlatform.instance.nativeMethodHandler(decodedMessage);
  }

  void registerCallbackPointer() {
    final JsObject pWebRTCModule = context['Module'];
    _pointerFunc = pWebRTCModule.callMethod('addFunction', <dynamic>[
      callbackHandler,
      'vi',
    ]);
    pWebRTCModule.callMethod('_native_register_callback', <dynamic>[
      _pointerFunc,
    ]);
  }

  static void onNotifyEvent() {}

  dynamic callObjectMethod(final String json) {
    final JsObject pWebRTCModule = context['Module'];
    final dynamic argumentsNative = pWebRTCModule.callMethod(
      'allocateUTF8',
      <String>[json],
    );
    final dynamic argumentsLength = pWebRTCModule.callMethod(
      'lengthBytesUTF8',
      <String>[json],
    );
    try {
      final dynamic result = pWebRTCModule.callMethod('_native_call', <dynamic>[
        argumentsNative,
        argumentsLength,
      ]);
      final String resultConverted = pWebRTCModule.callMethod(
        'UTF8ToString',
        <dynamic>[result],
      );
      pWebRTCModule.callMethod('_gemFree', <dynamic>[argumentsNative]);
      pWebRTCModule.callMethod('_gemFree', <dynamic>[result]);
      return resultConverted;
    } catch (e) {
      gemSdkLogger.log(Level.SEVERE, e.toString());
    }
    return null;
  }

  dynamic callCreateObject(final String json) {
    final JsObject pWebRTCModule = context['Module'];
    final dynamic argumentsNative = pWebRTCModule.callMethod(
      'allocateUTF8',
      <String>[json],
    );
    final dynamic argumentsLength = pWebRTCModule.callMethod(
      'lengthBytesUTF8',
      <String>[json],
    );

    try {
      final dynamic result = pWebRTCModule.callMethod(
        '_native_call_createObject',
        <dynamic>[argumentsNative, argumentsLength],
      );
      final String resultConverted = pWebRTCModule.callMethod(
        'UTF8ToString',
        <dynamic>[result],
      );
      pWebRTCModule.callMethod('_gemFree', <dynamic>[argumentsNative]);
      pWebRTCModule.callMethod('_gemFree', <dynamic>[result]);
      return resultConverted;
    } catch (e) {
      gemSdkLogger.log(Level.SEVERE, e.toString());
    }
    return null;
  }

  void callDeleteObject(final String json) {
    final JsObject pWebRTCModule = context['Module'];
    final dynamic argumentsNative = pWebRTCModule.callMethod(
      'allocateUTF8',
      <String>[json],
    );
    final dynamic argumentsLength = pWebRTCModule.callMethod(
      'lengthBytesUTF8',
      <String>[json],
    );
    try {
      pWebRTCModule.callMethod('_native_deleteObject', <dynamic>[
        argumentsNative,
        argumentsLength,
      ]);
      pWebRTCModule.callMethod('_gemFree', <dynamic>[argumentsNative]);
    } catch (e) {
      gemSdkLogger.log(Level.SEVERE, e.toString());
    }
  }

  GemObject registerWeakRelease(
    final Object obj,
    final dynamic nativePointerId,
    final int timestamp,
  ) {
    final GemObjectImpl retVal = GemObjectImpl();
    final dynamic jsObj = context.callMethod('registerWeakPtr', <dynamic>[
      nativePointerId,
    ]);
    retVal.initJsObject(jsObj);
    return retVal;
  }

  dynamic callObjectMethodWithWeak(final Object object, final String json) {
    return callObjectMethod(json);
  }

  dynamic callCreateBitmap(final int width, final int height) {
    final dynamic pWebRTCModule = context['Module'];
    return pWebRTCModule.callMethod('_createBitmapObject', <int>[
      width,
      height,
    ]);
  }

  dynamic callGetBitmap(final int bitmapId, final int width, final int height) {
    final JsObject pWebRTCModule = context['Module'];
    final dynamic result = pWebRTCModule.callMethod('_getBitmapBuffer', <int>[
      bitmapId,
      width,
      height,
    ]);
    return result;
  }

  Future<void> _loadDefaultNavigationArrow() async {
    final ByteData fileData = await rootBundle.load(
      'packages/gem_kit/assets/navarrow.glb',
    );
    final Uint8List imageData = fileData.buffer.asUint8List();
    try {
      MapSceneObject.customizeDefPositionTracker(
        imageData,
        SceneObjectFileFormat.gltf,
      );
    } catch (e) {
      rethrow;
    }
  }

  void setLibLoaded() {
    final JsFunction finalizationRegistryConstructor =
        context['FinalizationRegistry'] as JsFunction;

    // Create an instance of FinalizationRegistry using JsObject
    final JsObject registry =
        JsObject(finalizationRegistryConstructor, <dynamic>[
      allowInterop((final Object heldValue) {
        gemSdkLogger.log(
          Level.FINE,
          'Object is about to be garbage-collected: $heldValue',
        );
        // Perform cleanup or any necessary actions
      }),
    ]);

    // Create an object
    final Map<String, String> myObject = <String, String>{'key': 'value'};

    // Register the object with the FinalizationRegistry
    registry.callMethod('register', <dynamic>[myObject, 'CustomHandle']);

    // Register the object with the FinalizationRegistry
    // registry.callMethod('register', [myObject, "CustomHandle"]);
    // final finalizationRegistry = FinalizationRegistry((handle) {
    //   print("Object is about to be garbage-collected: $handle");
    //   // Perform cleanup or any necessary actions
    // });

    // // Create an object
    // final myObject = {"key": "value"};

    // // Register the object with the FinalizationRegistry
    // finalizationRegistry.register(myObject, "CustomHandle");

    // Loading the navigation arrow for the web
    unawaited(_loadDefaultNavigationArrow());
    initializationCompleter.complete();
    initHasBeenDone = true;
    //startBatchTimer();
  }

  dynamic safecallObjectMethodWithWeak(
    final Object object,
    final String json,
    final bool forceSafeThreadSync,
  ) {
    // WeakRefManager.register(object,markerId, () {
    //print("Object was garbage collected!");
    //});

    return callObjectMethod(json);
  }

  dynamic createGemImage(final Uint8List buffer, final int imgType) {
    final JsObject jsTypedArray = JsObject.jsify(buffer);

    // Call the JavaScript function to send data to WebAssembly
    final dynamic jsResult = context.callMethod('callCreateImage', <dynamic>[
      jsTypedArray,
      imgType,
    ]);
    return jsResult;
  }

  void deleteCPointer(final dynamic address) {
    final JsObject pWebRTCModule = context['Module'];
    pWebRTCModule.callMethod('_deletePointer', <dynamic>[address]);
  }

  void release() {
    stopBatchTimer();
    final JsObject pWebRTCModule = context['Module'];
    // ignore: inference_failure_on_collection_literal
    pWebRTCModule.callMethod('_releaseNative', <dynamic>[]);

    // _callReleaseNative();
  }

  bool isObjectAlive(final dynamic objectId) {
    return false;
  }

  dynamic toNativePointer(final Uint8List data) {
    //return passBinaryDataToC(data);]
    final JsObject jsArray = JsObject.jsify(data);
    final dynamic toSend = context.callMethod(
      'passBinaryDataToWasm',
      <JsObject>[jsArray],
    );
    return NativeObject(toSend, data.length);
  }

  void freeNativePointer(final dynamic pointer) {
    final JsObject pWebRTCModule = context['Module'];
    pWebRTCModule.callMethod('_deletePointer', <dynamic>[pointer]);
  }

  int getObjectWeakPtrCount(final dynamic objectId) {
    return 1;
  }

  Uint8List? callGetImage(
    final String className,
    final int objectId,
    final int width,
    final int height,
    final int imageType, {
    String? arg,
  }) {
    arg ??= '';

    final JsObject pWebRTCModule = context['Module'];

    // Allocate UTF8 string for className and arg
    final dynamic clsNamePtr = pWebRTCModule.callMethod(
      'allocateUTF8',
      <String>[className],
    );
    final dynamic clsNameLength = pWebRTCModule.callMethod(
      'lengthBytesUTF8',
      <String>[className],
    );
    final dynamic argPtr = pWebRTCModule.callMethod('allocateUTF8', <String>[
      arg,
    ]);

    // Call the WebAssembly function to get the image buffer
    final dynamic bufferPtr = pWebRTCModule.callMethod(
      '_getImageBuffer',
      <dynamic>[
        objectId,
        clsNamePtr,
        width,
        height,
        imageType,
        argPtr,
        arg.length,
        clsNameLength,
      ],
    );

    // Check if buffer is null
    if (bufferPtr == 0) {
      pWebRTCModule.callMethod('_gemFree', <dynamic>[clsNamePtr]);
      pWebRTCModule.callMethod('_gemFree', <dynamic>[argPtr]);
      return null;
    }

    // Get the image bytes and size
    final dynamic imgBufferPtr = pWebRTCModule.callMethod(
      '_getBytes',
      <dynamic>[bufferPtr],
    );
    final dynamic imgBufferSize = pWebRTCModule.callMethod(
      '_getBytesSize',
      <dynamic>[bufferPtr],
    );

    // Convert to Uint8List
    //final retVal = Uint8List.fromList(pWebRTCModule.callMethod("_getImageBuffer", [imgBufferPtr, imgBufferSize]));
    allowInterop(
      (final int start, final int end) =>
          pWebRTCModule['HEAPU8'].callMethod('subarray', <int>[start, end]),
    );
    final dynamic jsResult = context.callMethod('callHeapU8Subarray', <dynamic>[
      imgBufferPtr,
      imgBufferSize,
    ]);
    Uint8List retVal = Uint8List(0);
    if (jsResult != null) {
      // Convert the JavaScript typed array into a Dart Uint8List
      retVal = Uint8List.fromList(jsResult);
    }

    // Clean up
    pWebRTCModule.callMethod('_gemFree', <dynamic>[clsNamePtr]);
    pWebRTCModule.callMethod('_gemFree', <dynamic>[argPtr]);
    pWebRTCModule.callMethod('_deletePointer', <dynamic>[bufferPtr]);

    return retVal;
  }

  dynamic addList({
    required final MapViewMarkerCollections object,
    required final List<MarkerWithRenderSettings> list,
    required final MarkerCollectionRenderSettings settings,
    required final String name,
    required final dynamic parentMapId,
    final MarkerType markerType = MarkerType.point,
  }) {
    final JsObject pWebRTCModule = context['Module'];

    // Call the JavaScript function to pass data to WebAssembly
    final Map<int, NativeObject> markersImagePointers = <int, NativeObject>{};
    for (final MarkerWithRenderSettings marker in list) {
      if (marker.settings.image != null) {
        NativeObject imagePointer;
        if (markersImagePointers.containsKey(marker.settings.image!.hashCode)) {
          imagePointer = markersImagePointers[marker.settings.image!.hashCode]!;
        } else {
          final String json = jsonEncode(marker.settings.image);
          final dynamic jsonPtr = pWebRTCModule.callMethod(
            'allocateUTF8',
            <String>[json],
          );
          final dynamic jsonLen = pWebRTCModule.callMethod(
            'lengthBytesUTF8',
            <String>[json],
          );
          imagePointer = NativeObject(jsonPtr, jsonLen);
          markersImagePointers[marker.settings.image!.hashCode] = imagePointer;
        }
        MarkerInfoSpecialAccess.updateImagePointerSizeRenderSettings(
          marker.settings,
          imagePointer.length,
        );
        MarkerInfoSpecialAccess.updateImagePointerValueRenderSettings(
          marker.settings,
          imagePointer.address,
        );
      }
    }
    final Uint8List pList = serializeListOfMarkers(list);
    final JsObject jsArray = JsObject.jsify(pList);
    final dynamic toSend = context.callMethod(
      'passBinaryDataToWasm',
      <JsObject>[jsArray],
    );
    //print("Binary value for list is ${pList.length}");
    final dynamic retVal = callObjectMethod(
      jsonEncode(<String, Object>{
        'id': object.pointerId,
        'class': 'MapViewMarkerCollections',
        'method': 'addList',
        'args': <String, dynamic>{
          'settings': settings,
          'collectionType': markerType.id,
          'name': name,
          'binarylist': toSend,
          'binarylistSize': pList.length,
          'parentMapId': parentMapId,
        },
      }),
    );
    for (final MapEntry<int, NativeObject> imagePointer
        in markersImagePointers.entries) {
      pWebRTCModule.callMethod('_gemFree', <dynamic>[imagePointer.value]);
    }
    pWebRTCModule.callMethod('_gemFree', <dynamic>[toSend]);
    return retVal;
  }

  void setMouseInFocus(final bool mouseInFocus, final int viewId) {
    final JsObject pWebRTCModule = context['Module'];
    final String stringCanvasId = 'canvas$viewId';
    final dynamic canvasPtr = pWebRTCModule.callMethod('allocateUTF8', <String>[
      stringCanvasId,
    ]);
    pWebRTCModule.callMethod('_setMouseInFocus', <dynamic>[
      mouseInFocus,
      canvasPtr,
    ]);
    pWebRTCModule.callMethod('_gemFree', <dynamic>[canvasPtr]);
  }

  Uint8List _convertToBinary(final List<List<int>> events) {
    // Allocate the required size for the binary data
    final int size =
        events.length * 5 * 4; // 5 integers per event, 4 bytes each
    final ByteData buffer = ByteData(size);

    for (int i = 0; i < events.length; i++) {
      final List<int> event = events[i];
      buffer.setInt32(i * 20, event[0], Endian.little); // viewId
      buffer.setInt32(i * 20 + 4, event[1], Endian.little); // eventType
      buffer.setInt32(i * 20 + 8, event[2], Endian.little); // pointerIndex
      buffer.setInt32(i * 20 + 12, event[3], Endian.little); // x
      buffer.setInt32(i * 20 + 16, event[4], Endian.little); // y
    }

    return buffer.buffer.asUint8List();
  }

  Future<void> _sendBatchedEvents() async {
    if (_touchEventBatch.isNotEmpty) {
      final Uint8List binaryData = _convertToBinary(_touchEventBatch);
      _touchEventBatch.clear();
      final JsObject pWebRTCModule = context['Module'];
      final JsObject jsArray = JsObject.jsify(binaryData);
      final JsObject toSend = context.callMethod(
        'passBinaryDataToWasm',
        <dynamic>[jsArray],
      );
      pWebRTCModule.callMethod('_sendBatchedEvents', <dynamic>[
        toSend,
        binaryData.length,
      ]);
      pWebRTCModule.callMethod('_gemFree', <dynamic>[toSend]);
    }
  }

  void startBatchTimer() {
    _batchTimer = Timer.periodic(const Duration(milliseconds: 16), (
      final Timer timer,
    ) {
      if (_touchEventBatch.isNotEmpty) {
        unawaited(_sendBatchedEvents());
      }
    });
  }

  void stopBatchTimer() {
    _batchTimer?.cancel();
  }

  Future<bool> askForLocationPermission() async {
    try {
      // ignore: unused_local_variable
      final html.Geoposition mCurrentPosition =
          await html.window.navigator.geolocation.getCurrentPosition();
      return true;
    } catch (e) {
      return false;
    }
  }

  RenderableImg? callGetFlutterImg(
    final int objectId,
    final int width,
    final int height,
    final int imageType,
    String? arg,
    bool allowResize,
  ) {
    return null;
  }

  bool is32BitSystem() {
    return true;
  }
}
