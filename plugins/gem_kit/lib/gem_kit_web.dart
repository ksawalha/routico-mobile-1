// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

/// @nodoc
library;

import 'dart:async';
// ignore: deprecated_member_use
import 'dart:html' as html;
// ignore: deprecated_member_use
import 'dart:js';
import 'dart:ui_web' show platformViewRegistry;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
// ignore_for_file: avoid_print

import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:logging/logging.dart';

const String assetsPath = 'assets/packages/gem_kit/assets/';

final Completer<void> _completer = Completer<void>();
final Map<int, MethodChannel> _channels = <int, MethodChannel>{};
final Map<int, Completer<void>> _completersCanvasInit =
    <int, Completer<void>>{};
Future<void> createScreen(final String canvasId) async {
  await _completer.future;
  final JsObject pWebRTCModule = context['Module'];
  final dynamic canvasNameNative = pWebRTCModule.callMethod(
    'allocateUTF8',
    <String>[canvasId],
  );
  pWebRTCModule.callMethod('_createScreen', <dynamic>[canvasNameNative]);
  pWebRTCModule.callMethod('_gemFree', <dynamic>[canvasNameNative]);
}

html.DivElement createCanvas(final int viewId) {
  final html.DivElement wrapper = html.DivElement()
    ..style.width = '100%'
    ..style.height = '100%'
    ..style.position = 'absolute'
    ..tabIndex = 0
    ..id = 'canvasWrapper$viewId'
    ..onContextMenu.listen(
      (final html.MouseEvent event) => event.preventDefault(),
    );

  final String canvasName = 'canvas$viewId';

  final html.CanvasElement canvas = html.CanvasElement()
    ..style.width = '100%'
    ..style.height = '100%'
    ..className = 'emscripten'
    ..tabIndex = 0
    ..id = canvasName;

  wrapper.children.add(canvas);
  _completersCanvasInit[viewId] = Completer<void>();
  // Ensure WebGL is ready before calling createScreen
  Future<dynamic>.delayed(Duration.zero, () async {
    final html.Element? element = html.document.getElementById(canvasName);
    if (element != null) {
      await createScreen(canvasName);
      _completersCanvasInit[viewId]?.complete();
    } else {
      gemSdkLogger.log(Level.FINE, 'Canvas not found in DOM, retrying...');
      Future<dynamic>.delayed(const Duration(milliseconds: 10), () async {
        await createScreen(canvasName);
        _completersCanvasInit[viewId]?.complete();
      });
    }
  });

  // Create communication channel
  GemKitWeb.createChannelWithId(viewId);

  return wrapper;
}

void loadWasmModule() {
  //document.body = BodyElement();
  if (html.document.head == null) {
    html.document.body?.insertAdjacentElement(
      'beforebegin',
      html.HeadElement(),
    );
  }
  final html.StyleElement style = html.StyleElement();
  style.innerHtml = '''
  .emscripten {
    position: relative;
    top: 0px;
    left: 0px;
    margin: 0px;
    border: 0;
    width: 100%;
    height: 100%;
    overflow: hidden;
    display: block;
    image-rendering: optimizeSpeed;
    image-rendering: -moz-crisp-edges;
    image-rendering: -o-crisp-edges;
    image-rendering: -webkit-optimize-contrast;
    image-rendering: optimize-contrast;
    image-rendering: crisp-edges;
    image-rendering: pixelated;
    -ms-interpolation-mode: nearest-neighbor;
  }
''';
  html.document.head?.append(style);
  final html.ScriptElement script = html.ScriptElement();
  script.src = '${assetsPath}gemkitloader.js';
  script.type = 'text/javascript';
  script.onLoad.listen((final _) {
    context.callMethod('initApp', <dynamic>[]);
  });
  html.document.body?.children.add(script);
  //html.document.body?.children.add(wrapper);
  platformViewRegistry.registerViewFactory(
    'canvasView',
    (final int viewId) => createCanvas(viewId),
  );
}

void finishedLoadWasm() {
  GemMethodListener.initCallbackFunctions();
  GemKitWeb.initCallbackFunctions();
  GemKitPlatform.instance.setLibLoaded();

  // var pWebRTCModule = context["Module"];
  // String appToken = "YourAPPToken";
  // final appTokenNative = pWebRTCModule.callMethod("allocateUTF8", [appToken]);
  // pWebRTCModule.callMethod("_setAppAuthorization", [appTokenNative]);
  // pWebRTCModule.callMethod("_free", [appTokenNative]);
  try {
    _completer.complete();
  } catch (e) {
    gemSdkLogger.log(Level.SEVERE, e.toString());
  }
}

typedef CallbackMethodListener = void Function(String);

class GemMethodListener {
  GemMethodListener(final CallbackMethodListener pCallbackMethod) {
    _pCallbackMethod = pCallbackMethod;
    final JsObject pWebRTCModule = context['Module'];
    _pVoidPointer = pWebRTCModule.callMethod('_CreateMethodListener', <dynamic>[
      pointerFunc,
    ]);
  }
  static void initCallbackFunctions() {
    final JsObject pWebRTCModule = context['Module'];
    pointerFunc = pWebRTCModule.callMethod('addFunction', <Object>[
      callbackHandler,
      'viii',
    ]);
  }

  static GemMethodListener produce(
    final CallbackMethodListener pCallbackMethod,
  ) {
    final GemMethodListener gemMethodListener = GemMethodListener(
      pCallbackMethod,
    );
    instanceList[gemMethodListener.getNativePointer()] = gemMethodListener;
    return gemMethodListener;
  }

  static void callbackHandler(
    final int pVoidPointer,
    final int messageType,
    final int messageChar,
  ) {
    final dynamic pGemMethodListener = instanceList[pVoidPointer];
    if (messageType == 0) {
      final JsObject pWebRTCModule = context['Module'];
      final String pCharConverted = pWebRTCModule.callMethod(
        'UTF8ToString',
        <int>[messageChar],
      );
      pGemMethodListener._pCallbackMethod(pCharConverted);
    } else if (messageType == 1) {
      final JsObject pWebRTCModule = context['Module'];
      pWebRTCModule.callMethod('_DeleteMethodListener', <int>[pVoidPointer]);
      instanceList.remove(pVoidPointer);
    }
  }

  int getNativePointer() {
    return _pVoidPointer;
  }

  static Map<dynamic, dynamic> instanceList = <dynamic, dynamic>{};
  int _pVoidPointer = 0;
  static dynamic pointerFunc;
  late CallbackMethodListener _pCallbackMethod;
}

void handleMessage(
  final String methodName,
  final String arguments,
  final String canvasId,
  final CallbackMethodListener pFuncCallback,
) {
  final GemMethodListener gemMethodListener = GemMethodListener.produce(
    pFuncCallback,
  );
  final JsObject pWebRTCModule = context['Module'];
  final dynamic methodNameNative = pWebRTCModule.callMethod(
    'allocateUTF8',
    <String>[methodName],
  );
  final dynamic argumentsNative = pWebRTCModule.callMethod(
    'allocateUTF8',
    <String>[arguments],
  );
  final dynamic canvasIdNative = pWebRTCModule.callMethod(
    'allocateUTF8',
    <String>[canvasId],
  );
  try {
    pWebRTCModule.callMethod('_HandleMessage', <dynamic>[
      methodNameNative,
      gemMethodListener.getNativePointer(),
      argumentsNative,
      canvasIdNative,
    ]);
  } catch (e) {
    gemSdkLogger.log(Level.SEVERE, e.toString());
  }
  pWebRTCModule.callMethod('_gemFree', <dynamic>[methodNameNative]);
  pWebRTCModule.callMethod('_gemFree', <dynamic>[argumentsNative]);
  pWebRTCModule.callMethod('_gemFree', <dynamic>[canvasIdNative]);
}

/// A web implementation of the GemKitPlatform of the GemKit plugin.
///
/// {@category Core}
class GemKitWeb extends GemKitPlatform {
  /// Constructs a GemKitWeb
  GemKitWeb() {
    context['finishedLoadWasm'] = JsFunction.withThis((final _) {
      finishedLoadWasm();
    });
  }
  static void initCallbackFunctions() {
    final JsObject pWebRTCModule = context['Module'];
    pointerFunc = pWebRTCModule.callMethod('addFunction', <Object>[
      invokeMethod,
      'vii',
    ]);
    pWebRTCModule.callMethod('_registerChannelMethod', <dynamic>[pointerFunc]);
  }

  static void invokeMethod(
    final int methodNativeString,
    final int argumentsString,
  ) {
    final JsObject pWebRTCModule = context['Module'];
    final String methodName = pWebRTCModule.callMethod('UTF8ToString', <int>[
      methodNativeString,
    ]);
    final String arguments = pWebRTCModule.callMethod('UTF8ToString', <int>[
      argumentsString,
    ]);
    _channels[0]!.invokeMethod(methodName, arguments);
  }

  static void createChannelWithId(final int id) {
    _channels[id] = MethodChannel(
      'plugins.flutter.dev/gem_maps_$id',
      const StandardMethodCodec(),
      binaryMessenger,
    );
    _channels[id]!.setMethodCallHandler((final MethodCall call) async {
      await _completer.future;
      await _completersCanvasInit[id]?.future;
      switch (call.method) {
        default:
          {
            final Completer<void> pCompleter = Completer<void>();
            String returnMessage = '{}';
            final String arg = call.arguments ?? '';
            final String canvasId = 'canvas$id';
            handleMessage(call.method, arg, canvasId, (final String retVal) {
              returnMessage = retVal;
              pCompleter.complete();
            });
            await pCompleter.future;
            return Future<String>.value(returnMessage);
          }
      }
    });
  }

  static dynamic pointerFunc;
  static void registerWith(final Registrar registrar) {
    loadWasmModule();
    binaryMessenger = registrar;
    GemKitPlatform.instance = GemKitWeb();
    //createChannelWithId(0);
  }

  static BinaryMessenger? binaryMessenger;

  /// Returns a [String] containing the version of the platform.
  Future<String?> getPlatformVersion() async {
    final String version = html.window.navigator.userAgent;
    return version;
  }
}
