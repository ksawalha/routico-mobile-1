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
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:logging/logging.dart';

/// Listener for events related to a route
///
/// {@category Places}
class RouteListener extends EventHandler {
  /// Constructor for a RouteListener
  ///
  /// **Parameters**
  ///
  /// * **IN** *onRouteTrafficEventsUpdated* Called when route traffic events are updated. See [RouteListener.registerOnRouteTrafficEventsUpdated] for more information about usage.
  /// * **IN** *onTrafficEventsAlongRouteChecked* Called when traffic events along route were verified. See [RouteListener.registerOnTrafficEventsAlongRouteChecked] for more information about usage.
  /// * **IN** *onRouteTrackTrimmed* Called when track was trimmed during navigation. See [RouteListener.registerOnRouteTrackTrimmed] for more information about usage.
  factory RouteListener({
    final void Function(int delayDiff)? onRouteTrafficEventsUpdated,
    final void Function()? onTrafficEventsAlongRouteChecked,
    final void Function()? onRouteTrackTrimmed,
  }) {
    final RouteListener listener = RouteListener._create();

    if (onRouteTrafficEventsUpdated != null) {
      listener._onRouteTrafficEventsUpdated = onRouteTrafficEventsUpdated;
    }
    if (onTrafficEventsAlongRouteChecked != null) {
      listener._onTrafficEventsAlongRouteChecked =
          onTrafficEventsAlongRouteChecked;
    }
    if (onRouteTrackTrimmed != null) {
      listener._onRouteTrackTrimmed = onRouteTrackTrimmed;
    }

    return listener;
  }

  RouteListener.init(this.id);
  void Function(int delayDiff)? _onRouteTrafficEventsUpdated;
  void Function()? _onTrafficEventsAlongRouteChecked;
  void Function()? _onRouteTrackTrimmed;

  dynamic id;

  static RouteListener _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, Object>{
        'class': 'RouteListener',
        'args': <dynamic, dynamic>{},
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return RouteListener.init(decodedVal['result']);
  }

  /// Called when route traffic events are updated.
  ///
  /// This notification is sent when there is a change in traffic affecting the route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *delayDiff	* Difference between new delay and old delay calculated only for the remaining travel distance in seconds
  void registerOnRouteTrafficEventsUpdated(
    final void Function(int delayDiff)? callback,
  ) {
    _onRouteTrafficEventsUpdated = callback;
  }

  /// Called when traffic events along route were verified.
  void registerOnTrafficEventsAlongRouteChecked(
    final void Function()? callback,
  ) {
    _onTrafficEventsAlongRouteChecked = callback;
  }

  /// Called when track was trimmed during navigation ( debug purposes )
  void registerOnRouteTrackTrimmed(final void Function()? callback) {
    _onRouteTrackTrimmed = callback;
  }

  @override
  FutureOr<void> dispose() {}

  @override
  void handleEvent(final Map<dynamic, dynamic> arguments) {
    final String eventSubtype = arguments['event_subtype'];

    switch (eventSubtype) {
      case 'onRouteTrafficEventsUpdated':
        if (_onRouteTrafficEventsUpdated != null) {
          _onRouteTrafficEventsUpdated!(arguments['delayDiff']);
        }

      case 'onTrafficEventsAlongRouteChecked':
        if (_onTrafficEventsAlongRouteChecked != null) {
          _onTrafficEventsAlongRouteChecked!();
        }

      case 'onRouteTrackTrimmed':
        if (_onRouteTrackTrimmed != null) {
          _onRouteTrackTrimmed!();
        }

      default:
        gemSdkLogger.log(
          Level.WARNING,
          'Unknown event subtype: $eventSubtype in RouteListener',
        );
    }
  }
}
