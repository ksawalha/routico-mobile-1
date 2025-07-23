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

import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:logging/logging.dart';

/// Log uploader state
///
/// {@category Core}
enum LogUploaderState {
  /// Log upload in progress
  progress,

  /// Log upload ready
  ready,
}

/// @nodoc
extension LogUploaderStateExtension on LogUploaderState {
  int get id {
    switch (this) {
      case LogUploaderState.progress:
        return 0;
      case LogUploaderState.ready:
        return 1;
    }
  }

  static LogUploaderState fromId(final int id) {
    switch (id) {
      case 0:
        return LogUploaderState.progress;
      case 1:
        return LogUploaderState.ready;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// @nodoc
class LogUploadPointer extends GemAutoreleaseObject {
  LogUploadPointer() : _pointerId = 0 {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'LogUploadListener'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    _pointerId = decodedVal['result'];
    super.registerAutoReleaseObject(_pointerId);
  }
  int _pointerId;
  int get pointerId => _pointerId;
}

/// @nodoc
class LogUploadListener extends EventHandler {
  LogUploadListener({required this.onLogStatusChangedCallback});
  dynamic logUploadListener;
  final LogUploadPointer _pointer = LogUploadPointer();

  void Function(String logPath, int status, int progress)
      onLogStatusChangedCallback;

  @override
  FutureOr<void> dispose() {}

  @override
  void handleEvent(final Map<dynamic, dynamic> arguments) {
    if (arguments['event_subtype'] == 'onLogStatusChanged') {
      final String logPath = arguments['logPath'];
      final int status = arguments['status'];
      final int progress = arguments['progress'];

      onLogStatusChangedCallback(logPath, status, progress);
    } else {
      gemSdkLogger.log(
        Level.WARNING,
        'Unknown event subtype: ${arguments['eventType']} in LogUploadListener',
      );
    }
  }

  int get pointerId => _pointer.pointerId;
}
