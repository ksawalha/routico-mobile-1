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
import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/core/traffic.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:logging/logging.dart';

/// Listener for events related to a route
///
/// {@category Places}
class PersistentRoadblockListener extends EventHandler {
  /// Constructor for a PersistentRoadblockListener
  ///
  /// **Parameters**
  ///
  /// * **IN** *onRoadblocksExpired* Called when some user roadblocks are expired. See [PersistentRoadblockListener.registerOnRoadblocksExpired] for more information about usage.
  /// * **IN** *onRoadblocksActivated* Calledwhen some user roadblocks are activated. See [PersistentRoadblockListener.registerOnRoadblocksActivated] for more information about usage.
  factory PersistentRoadblockListener({
    final void Function(List<TrafficEvent> eventList)? onRoadblocksExpired,
    final void Function(List<TrafficEvent> eventList)? onRoadblocksActivated,
  }) {
    final PersistentRoadblockListener listener =
        PersistentRoadblockListener._create();

    if (onRoadblocksExpired != null) {
      listener._onRoadblocksExpired = onRoadblocksExpired;
    }
    if (onRoadblocksActivated != null) {
      listener._onRoadblocksActivated = onRoadblocksActivated;
    }

    return listener;
  }

  PersistentRoadblockListener.init(this.id);
  void Function(List<TrafficEvent> eventList)? _onRoadblocksExpired;
  void Function(List<TrafficEvent> eventList)? _onRoadblocksActivated;

  dynamic id;

  static PersistentRoadblockListener _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, Object>{
        'class': 'PersistentRoadblockListener',
        'args': <dynamic, dynamic>{},
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return PersistentRoadblockListener.init(decodedVal['result']);
  }

  /// Notification called when some user roadblocks are expired.
  ///
  /// Expired means the [TrafficEvent.endTime] was in the future but it is now in the past
  ///
  /// **Parameters**
  ///
  /// * **IN** *eventList	* The list of expired roadblocks
  void registerOnRoadblocksExpired(
    final void Function(List<TrafficEvent> eventList)? onRoadblocksExpired,
  ) {
    _onRoadblocksExpired = onRoadblocksExpired;
  }

  /// Notification called when some user roadblocks are activated.
  ///
  /// Activated means the [TrafficEvent.startTime] was in the future but it is now in the past
  ///
  /// **Parameters**
  ///
  /// * **IN** *eventList	* The list of activated roadblocks
  void registerOnRoadblocksActivated(
    final void Function(List<TrafficEvent> eventList)? onRoadblocksActivated,
  ) {
    _onRoadblocksActivated = onRoadblocksActivated;
  }

  @override
  FutureOr<void> dispose() {}

  @override
  void handleEvent(final Map<dynamic, dynamic> arguments) {
    final String eventSubtype = arguments['event_subtype'];

    switch (eventSubtype) {
      case 'onRoadblocksExpired':
        if (_onRoadblocksExpired != null) {
          final TrafficEventList events = TrafficEventList.init(
            arguments['eventList'],
          );
          _onRoadblocksExpired!(events.toList());
          events.dispose();
        }

      case 'onRoadblocksActivated':
        if (_onRoadblocksActivated != null) {
          final TrafficEventList events = TrafficEventList.init(
            arguments['eventList'],
          );
          _onRoadblocksActivated!(events.toList());
          events.dispose();
        }
      default:
        gemSdkLogger.log(
          Level.WARNING,
          'Unknown event subtype: $eventSubtype in PersistentRoadblockListener',
        );
    }
  }
}
