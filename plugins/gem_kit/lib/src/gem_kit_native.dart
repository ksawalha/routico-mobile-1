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
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:gem_kit/core.dart';
import 'package:gem_kit/map.dart';
import 'package:gem_kit/src/_ffi/generated_binding.dart' as native_bindings;
import 'package:gem_kit/src/core/gem_object_interface.dart';
import 'package:gem_kit/src/core/gem_object_other.dart';
import 'package:gem_kit/src/gem_kit_native_utils.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:logging/logging.dart';

Pointer<Uint8> passBinaryDataToC(final Uint8List binaryData) {
  // Allocate memory for the binary data
  final Pointer<Uint8> dataPointer = malloc.allocate<Uint8>(binaryData.length);

  // Copy the Uint8List data to the allocated memory
  for (int i = 0; i < binaryData.length; i++) {
    dataPointer[i] = binaryData[i];
  }
  return dataPointer;
}

typedef DeletePointerC = Void Function(Pointer<Void> pointerVal);
typedef DeletePointerDart = void Function(Pointer<Void> pointerVal);

typedef GetBytesC = Pointer<Uint8> Function(Pointer<Void> pointerVal);
typedef GetBytesDart = Pointer<Uint8> Function(Pointer<Void> pointerVal);

typedef GetImageBufferC = Pointer<Void> Function(
  Int64 pointerId,
  Pointer<Utf8> className,
  Int32 width,
  Int32 height,
  Int32 imgType,
  Pointer<Utf8> arg,
  Int32 argLen,
  Int32 classNameLen,
);
typedef GetImageBufferDart = Pointer<Void> Function(
  int pointerId,
  Pointer<Utf8> className,
  int width,
  int height,
  int imgType,
  Pointer<Utf8> arg,
  int arglen,
  int classNameLen,
);

sealed class FlutterImgInfo extends Struct {
  @Int32()
  external int width;

  @Int32()
  external int height;

  external Pointer<Void> ptr;
}

typedef CreateImgInfoC = FlutterImgInfo Function(
  Int64 pointerId,
  Int32 width,
  Int32 height,
  Int32 imgType,
  Pointer<Utf8> arg,
  Int32 arglen,
  Bool allowResize,
);
typedef CreateImgInfoDart = FlutterImgInfo Function(
  int pointerId,
  int width,
  int height,
  int imgType,
  Pointer<Utf8> arg,
  int arglen,
  bool allowResize,
);

final DynamicLibrary libToLoad = Platform.isWindows
    ? DynamicLibrary.open('GEMWebRTC.dll')
    : Platform.isLinux
        ? DynamicLibrary.open('libGEM.so')
        : Platform.isAndroid
            ? DynamicLibrary.open('libGEM.so')
            : DynamicLibrary.process();

class GemSdkNative {
  static int? cookie;
  bool initHasBeenDone = false;
  bool loadNativeCalled = false;
  dynamic handleDartObject;
  dynamic _callGetOsVersion;
  dynamic _callCreateBitmap;
  dynamic _callGetBitmapBuffer;
  dynamic _callGetFlutterImg;
  dynamic _callIsObjectAlive;
  dynamic _callDeletePointer;
  dynamic _callGetBytes;
  dynamic _callGetSizeOfBytes;
  dynamic _callGetImageBuffer;
  dynamic _callCreateGemImage;
  dynamic _callIsSdkInitialized;
  native_bindings.GEMKitFFigen? gemWebRTCNative;
  static int androidVersion = -1;
  int getAndroidVersion() {
    return androidVersion;
  }

  Completer<void> initializationCompleter = Completer<void>();
  Future<void> get initializationDone => initializationCompleter.future;
  Future<void> loadNative() async {
    setupLogging();
    if (loadNativeCalled) {
      return;
    }

    loadNativeCalled = true;
    if (gemWebRTCNative == null) {
      final Pointer<T> Function<T extends NativeType>(String symbolName)
          lookUp = libToLoad.lookup;
      gemWebRTCNative = native_bindings.GEMKitFFigen.fromLookup(lookUp);
      handleDartObject = libToLoad.lookupFunction<
          Void Function(Handle, Int64, Int64),
          void Function(Object, int, int)>('HandleDartObject');

      _callGetOsVersion = libToLoad
          .lookupFunction<Int Function(), int Function()>('getOSVersionNumber');
      _callCreateBitmap = libToLoad
          .lookupFunction<Int64 Function(Int, Int), int Function(int, int)>(
        'createBitmapObject',
      );
      _callGetBitmapBuffer = libToLoad.lookupFunction<
          Pointer<Uint8> Function(Int64),
          Pointer<Uint8> Function(int)>('getBitmapBuffer');
      _callIsObjectAlive =
          libToLoad.lookupFunction<Bool Function(Int64), bool Function(int)>(
        'IsObjectAlive',
      );

      _callGetFlutterImg = libToLoad
          .lookupFunction<CreateImgInfoC, CreateImgInfoDart>('getFlutterImg');

      _callDeletePointer = libToLoad
          .lookupFunction<DeletePointerC, DeletePointerDart>('deletePointer');
      _callGetBytes = libToLoad.lookupFunction<GetBytesC, GetBytesDart>(
        'getBytes',
      );
      _callGetImageBuffer =
          libToLoad.lookupFunction<GetImageBufferC, GetImageBufferDart>(
        'getImageBuffer',
      );
      _callGetSizeOfBytes = libToLoad.lookupFunction<
          Int Function(Pointer<Void>),
          int Function(Pointer<Void>)>('getBytesSize');
      _callCreateGemImage = libToLoad.lookupFunction<
          Int64 Function(Pointer<Uint8>, Int64, Int32),
          int Function(Pointer<Uint8>, int, int)>('createGemImage');
      _callIsSdkInitialized = libToLoad
          .lookupFunction<Bool Function(), bool Function()>('isSdkInitialized');

      //if(Platform.isAndroid)
      {
        cookie = gemWebRTCNative!.Dart_InitializeApiDLFunc(
          NativeApi.initializeApiDLData,
        );
        final ReceivePort pub = ReceivePort()
          ..listen((final dynamic message) {
            if (message.toString() == 'initCompleted') {
              if (!initHasBeenDone) {
                initHasBeenDone = true;
                gemSdkLogger.fine('GEM SDK initialized');
                initializationCompleter.complete();
              }
            } else {
              if (Debug.logListenerMethod) {
                gemSdkLogger.finest(
                  '[SdkDebug][ListenerMethod] Received: $message',
                );
              }
              final dynamic decodedMessage = jsonDecode(message);
              GemKitPlatform.instance.nativeMethodHandler(decodedMessage);
            }
          });

        gemWebRTCNative!.set_dart_port(pub.sendPort.nativePort);
        androidVersion = _callGetOsVersion();
        await initializationCompleter.future;

        //
      }
    }
  }

  void setupLogging() {
    // Set up the log handler (output to console and file, for example)
    Logger.root.onRecord.listen((final LogRecord rec) {
      // Format the timestamp to display only Date, Hour, Minute, and Second
      final DateTime time = rec.time;
      final String formattedTime =
          '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} '
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';

      final String logMessage =
          '${rec.level.name}: $formattedTime: ${rec.message}';

      // Output to console
      // ignore: avoid_print
      print(logMessage);
    });
  }

  void loadNativeD() {}
  void isolateEntryPoint(final SendPort sendPort) {
    // This function runs in a separate isolate
    final ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    // Wait for messages from the main isolate
    receivePort.listen((final dynamic message) {
      if (message is Function) {
        // Register the isolate callback with the main isolate
        //final OnNotifyEventDart callback = onNotifyEventIsolate;
        //message(callback);
      }
    });
  }

  void registerCallbackPointer() {
    // final receivePort = ReceivePort();
    //Isolate.spawn(_sentryIsolate, _SentryIsolateMessage(receivePort.sendPort, isolateId, nativeLibraryPath));
    //_callbackStream = receivePort.listen((dynamic _) { _libraryExecuteCallbacks(isolateId); });
    final native_bindings.Dart_onNotifyEvent pointer = Pointer.fromFunction(
      onNotifyEvent,
    );
    gemWebRTCNative!.native_register_callback(pointer);
  }

  static void onNotifyEvent(final Pointer<Char> pChar) {
    if (pChar != nullptr) {
      // final response = pChar.cast<Utf8>().toDartString();
      // final decodeId = jsonDecode(response);
    }
  }

  void assertObjectAlive(final String jsonStr) {
    final dynamic json = jsonDecode(jsonStr);
    final dynamic id = json['id'];

    if (id == 0 || id == null) {
      return;
    }

    final bool isObjAlive = isObjectAlive(id);
    if (!isObjAlive) {
      throw ObjectNotAliveException(id: id, json: jsonStr);
    }
  }

  Future<dynamic> addList({
    required final MapViewMarkerCollections object,
    required final List<MarkerWithRenderSettings> list,
    required final MarkerCollectionRenderSettings settings,
    required final String name,
    required final dynamic parentMapId,
    final MarkerType markerType = MarkerType.point,
  }) async {
    final Map<int, Pointer<Utf8>> markersImagePointers = <int, Pointer<Utf8>>{};
    for (final MarkerWithRenderSettings marker in list) {
      if (marker.settings.image != null) {
        Pointer<Utf8> imagePointer;
        if (markersImagePointers.containsKey(marker.settings.image!.hashCode)) {
          imagePointer = markersImagePointers[marker.settings.image!.hashCode]!;
        } else {
          imagePointer = jsonEncode(marker.settings.image).toNativeUtf8();
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
    final Pointer<Uint8> toSend = passBinaryDataToC(pList);
    String? retVal;
    if (Platform.isAndroid) {
      retVal = await GemKitPlatform.instance.getChannel().invokeMethod<String>(
            'callObjectMethod',
            jsonEncode(<String, dynamic>{
              'id': object.pointerId,
              'class': 'MapViewMarkerCollections',
              'method': 'addList',
              'args': <String, dynamic>{
                'settings': settings,
                'collectionType': markerType.id,
                'name': name,
                'binarylist': toSend.address,
                'binarylistSize': pList.length,
                'parentMapId': parentMapId,
              },
            }),
          );
    } else {
      {
        retVal = callObjectMethod(
          jsonEncode(<String, Object>{
            'id': object.pointerId,
            'class': 'MapViewMarkerCollections',
            'method': 'addList',
            'args': <String, dynamic>{
              'settings': settings,
              'collectionType': markerType.id,
              'name': name,
              'binarylist': toSend.address,
              'binarylistSize': pList.length,
              'parentMapId': parentMapId,
            },
          }),
        );
      }
    }
    for (final MapEntry<int, Pointer<Utf8>> imagePointer
        in markersImagePointers.entries) {
      malloc.free(imagePointer.value);
    }
    malloc.free(toSend);
    return retVal!;
  }

  dynamic callCreateBitmap(final int width, final int height) {
    if (!initHasBeenDone) {
      throw GemKitUninitializedException();
    }
    final int result = _callCreateBitmap(width, height);
    return result;
  }

  dynamic callGetBitmap(final int bitmapId, final int width, final int height) {
    if (!initHasBeenDone) {
      throw GemKitUninitializedException();
    }
    final Pointer<Uint8> result = _callGetBitmapBuffer(bitmapId);
    return result.asTypedList(width * height * 4);
  }

  RenderableImg? callGetFlutterImg(
    final int objectId,
    final int width,
    final int height,
    final int imageType,
    String? arg,
    bool allowResize,
  ) {
    if (!initHasBeenDone) {
      throw GemKitUninitializedException();
    }

    arg ??= '';
    final Pointer<Utf8> pArg = arg.toNativeUtf8();

    final dynamic result = _callGetFlutterImg(
      objectId,
      width,
      height,
      imageType,
      pArg,
      pArg.length,
      allowResize,
    );

    if (result.ptr == nullptr) {
      malloc.free(result.ptr);
      malloc.free(pArg);
      return null;
    }

    final Pointer<Uint8> imgBuffer = _callGetBytes(result.ptr);
    final int imgBufferSize = _callGetSizeOfBytes(result.ptr);

    final Uint8List retVal = imgBuffer.asTypedList(imgBufferSize);
    malloc.free(pArg);
    _callDeletePointer(result.ptr);

    final RenderableImg bitmap = RenderableImg(
      result.width,
      result.height,
      retVal,
    );
    return bitmap;
  }

  Uint8List? callGetImage(
    final String className,
    final int objectId,
    final int width,
    final int height,
    final int imageType, {
    String? arg,
  }) {
    if (!initHasBeenDone) {
      throw GemKitUninitializedException();
    }
    arg ??= '';
    final Pointer<Utf8> clsName = className.toNativeUtf8();
    final Pointer<Utf8> pArg = arg.toNativeUtf8();
    final Pointer<Utf8> buffer = _callGetImageBuffer(
      objectId,
      clsName,
      width,
      height,
      imageType,
      pArg,
      pArg.length,
      clsName.length,
    );
    if (buffer == nullptr) {
      malloc.free(clsName);
      malloc.free(pArg);
      return null;
    }
    final Pointer<Uint8> imgBuffer = _callGetBytes(buffer);
    final int imgBufferSize = _callGetSizeOfBytes(buffer);
    final Uint8List retVal = imgBuffer.asTypedList(imgBufferSize);
    malloc.free(clsName);
    malloc.free(pArg);
    _callDeletePointer(buffer);
    return retVal;
  }

  String callObjectMethod(final String json) {
    if (!initHasBeenDone) {
      throw GemKitUninitializedException();
    }
    if (Debug.logCallObjectMethod) {
      gemSdkLogger.finest('[SdkDebug][CallObject] Request: $json');
    }
    if (Debug.isObjectAliveCheckEnabled) {
      assertObjectAlive(json);
    }
    final Pointer<Utf8> dataNative = json.toNativeUtf8();
    final Pointer<Char> result = gemWebRTCNative!.native_call(
      dataNative.cast<Char>(),
      dataNative.length,
    );
    malloc.free(dataNative);
    if (result == nullptr) {
      throw Exception('Failed to call object method: $json');
    }

    final String response = result.cast<Utf8>().toDartString();
    if (Debug.logCallObjectMethod) {
      gemSdkLogger.finest('[SdkDebug][CallObject] Result: $response');
    }

    malloc.free(result);
    return response;
  }

  String callCreateObject(final String json) {
    if (cookie == null) {
      throw GemKitUninitializedException();
    }
    if (Debug.logCreateObject) {
      gemSdkLogger.finest('[SdkDebug][CreateObject] Request: $json');
    }

    final Pointer<Utf8> dataNative = json.toNativeUtf8();
    final Pointer<Char> result = gemWebRTCNative!.native_call_createObject(
      dataNative.cast<Char>(),
      dataNative.length,
    );
    malloc.free(dataNative);
    if (result == nullptr) {
      throw Exception('Failed to create object: $json');
    }

    final String response = result.cast<Utf8>().toDartString();
    if (Debug.logCreateObject) {
      gemSdkLogger.finest('[SdkDebug][CreateObject] Result: $json');
    }

    malloc.free(result);
    return response;
  }

  void callDeleteObject(final String json) {
    final Pointer<Char> dataNative = json.toNativeUtf8().cast<Char>();
    gemWebRTCNative!.native_deleteObject(dataNative, json.length);
    malloc.free(dataNative);
  }

  bool isObjectAlive(final dynamic objectId) {
    return _callIsObjectAlive(objectId);
  }

  GemObject registerWeakRelease(
    final Object obj,
    final dynamic nativePointerId,
    final int timestamp,
  ) {
    if (cookie == null) {
      throw GemKitUninitializedException();
    }
    handleDartObject(obj, nativePointerId, timestamp);
    final GemObjectImpl retVal = GemObjectImpl();
    //retVal.initBase(nativePointerId);
    return retVal;
  }

  dynamic createGemImage(final Uint8List buffer, final int imgType) {
    final Pointer<Uint8> bufferPtr = malloc.allocate<Uint8>(buffer.length);
    bufferPtr.asTypedList(buffer.length).setAll(0, buffer);
    final dynamic result = _callCreateGemImage(
      bufferPtr,
      buffer.length,
      imgType,
    );
    malloc.free(bufferPtr);
    return result;
  }

  void deleteCPointer(final dynamic address) {
    final Pointer<Utf8> pointer = Pointer<Utf8>.fromAddress(address);
    _callDeletePointer(pointer);
  }

  void release() {
    //_callReleaseNative();
    initHasBeenDone = false;
    loadNativeCalled = false;
    gemSdkLogger.fine('GEM SDK released');

    Logger.root.clearListeners();
  }

  void setLibLoaded() {}

  dynamic toNativePointer(final Uint8List data) {
    return passBinaryDataToC(data);
  }

  void freeNativePointer(final dynamic pointer) {
    malloc.free(pointer);
  }

  void setMouseInFocus(final bool mouseInFocus, final int viewId) {
    //Not needed for Android/IOS
  }

  //Not needed for Android/IOS
  Future<bool> askForLocationPermission() async {
    throw UnimplementedError('Not implemented for Android/IOS');
  }

  bool is32BitSystem() {
    if (sizeOf<IntPtr>() == 4) {
      return true;
    }
    return false;
  }

  bool isSdkInitialized() {
    return _callIsSdkInitialized();
  }
}
