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

import 'package:gem_kit/sense.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:gem_kit/src/position/gem_position.dart';
import 'package:gem_kit/src/position/gem_position_listener.dart';
import 'package:gem_kit/src/sense/sense_data_impl.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// Gem Position Listener
///
/// {@category Sensor Data Source}
class GemPositionListener extends IGemPositionListener {
  /// Constructor for the Gem Position Listener
  ///
  /// **Parameters**
  ///
  /// * **IN** *onNewPositionCallback* The callback used for the position listener.
  /// * **IN** *onNewImprovedPositionCallback* The callback used for the improved position listener.
  GemPositionListener({
    this.onNewPositionCallback,
    this.onNewImprovedPositionCallback,
  });

  /// Callback called when a new position is emitted
  void Function(GemPosition position)? onNewPositionCallback;

  /// Callback called when a new improved position is emitted
  void Function(GemImprovedPosition position)? onNewImprovedPositionCallback;

  @override
  void onNewPosition(final GemPosition pos) {
    onNewPositionCallback?.call(pos);
  }

  @override
  void onNewImprovedPosition(final GemImprovedPosition pos) {
    onNewImprovedPositionCallback?.call(pos);
  }

  @internal
  @override
  void handleEvent(final Map<dynamic, dynamic> arguments) {
    if (arguments['eventType'] == 'positionEvent') {
      final Map<String, dynamic> positionJson = arguments['position'];
      final DataType type = DataTypeExtension.fromId(
        positionJson['senseDataType'],
      );
      if (type == DataType.position) {
        onNewPosition(GemPositionImpl.fromJson(positionJson));
      } else if (type == DataType.improvedPosition) {
        onNewImprovedPosition(GemImprovedPositionImpl.fromJson(positionJson));
      }
    } else {
      gemSdkLogger.log(
        Level.WARNING,
        'Unknown event subtype: ${arguments['eventType']} in GemPositionListener',
      );
    }
  }

  @override
  FutureOr<void> dispose() {}
}
