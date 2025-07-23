import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:logging/logging.dart';

const MethodChannel _channel = MethodChannel('plugins.flutter.dev/gem_maps_0');

class PlayerValue {
  PlayerValue({required this.isInitialized});
  PlayerValue.uninitialized() : this(isInitialized: false);

  final bool isInitialized;

  PlayerValue copyWith({bool? isInitialized}) {
    return PlayerValue(isInitialized: isInitialized ?? this.isInitialized);
  }
}

class TextureController extends ValueNotifier<PlayerValue> {
  TextureController() : super(PlayerValue.uninitialized());
  late Completer<void> _creatingCompleter;
  int _textureId = 0;
  bool _isDisposed = false;
  final List<Map<String, dynamic>> _eventQueue = <Map<String, dynamic>>[];
  Timer? _eventTimer;

  Future<void> initialize() async {
    if (_isDisposed) {
      return Future<void>.value();
    }
    try {
      _creatingCompleter = Completer<void>();

      final Map<String, dynamic>? reply =
          await _channel.invokeMapMethod<String, dynamic>('initialize');

      if (reply != null) {
        _textureId = reply['textureId'];
        value = value.copyWith(isInitialized: true);
      }
    } on PlatformException catch (_) {
      // Handle exception
    }

    _creatingCompleter.complete();

    // Start a timer to send events periodically
    _eventTimer = Timer.periodic(const Duration(milliseconds: 16), (
      Timer timer,
    ) {
      _sendBatchedEvents();
    });

    return _creatingCompleter.future;
  }

  @override
  Future<void> dispose() async {
    _isDisposed = true;
    _eventTimer?.cancel();
    super.dispose();
  }

  void _queueEvent(Map<String, dynamic> event) {
    if (!_isDisposed && value.isInitialized) {
      _eventQueue.add(event);
    }
  }

  Future<void> _sendBatchedEvents() async {
    if (_eventQueue.isNotEmpty) {
      try {
        await _channel.invokeMethod('pointerEvents', _eventQueue);
        _eventQueue.clear();
      } on PlatformException catch (_) {
        // Handle exception
      }
    }
  }
}

class GemTextureView extends StatefulWidget {
  const GemTextureView({super.key, required this.onPlatformViewCreated});

  final Future<void> Function(int, Rectangle<int>) onPlatformViewCreated;

  @override
  GemTextureViewState createState() => GemTextureViewState();
}

class GemTextureViewState extends State<GemTextureView> {
  late TextureController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextureController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int width = constraints.maxWidth.toInt();
        final int height = constraints.maxHeight.toInt();
        final Rectangle<int> viewport = Rectangle<int>(0, 0, width, height);

        _controller.initialize().then((_) {
          widget.onPlatformViewCreated(_controller._textureId, viewport);
        });

        return ValueListenableBuilder<PlayerValue>(
          valueListenable: _controller,
          builder: (BuildContext context, PlayerValue value, Widget? child) {
            return value.isInitialized
                ? Listener(
                    onPointerDown: (PointerDownEvent event) {
                      gemSdkLogger.log(
                        Level.FINEST,
                        'PointerDown - dx: ${event.localPosition.dx}, dy: ${event.localPosition.dy}, id: ${event.pointer}',
                      );
                      _controller._queueEvent(<String, dynamic>{
                        'type': 'pointerDown',
                        'dx': event.localPosition.dx,
                        'dy': event.localPosition.dy,
                        'id': event.pointer,
                      });
                    },
                    onPointerMove: (PointerMoveEvent event) {
                      _controller._queueEvent(<String, dynamic>{
                        'type': 'pointerMove',
                        'dx': event.localPosition.dx,
                        'dy': event.localPosition.dy,
                        'id': event.pointer,
                      });
                    },
                    onPointerUp: (PointerUpEvent event) {
                      _controller._queueEvent(<String, dynamic>{
                        'type': 'pointerUp',
                        'id': event.pointer,
                      });
                    },
                    onPointerCancel: (PointerCancelEvent event) {
                      _controller._queueEvent(<String, dynamic>{
                        'type': 'pointerCancel',
                        'id': event.pointer,
                      });
                    },
                    child: Texture(textureId: _controller._textureId),
                  )
                : Container();
          },
        );
      },
    );
  }
}
