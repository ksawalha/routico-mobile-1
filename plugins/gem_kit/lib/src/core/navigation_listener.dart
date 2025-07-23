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

import 'package:gem_kit/core.dart';
import 'package:gem_kit/navigation.dart';
import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// @nodoc
@internal
class NavigationListener extends EventHandler {
  @internal
  NavigationListener.init(this.id);
  dynamic id;

  void Function()? _onNavigationStarted;
  void Function(
    NavigationInstruction instruction,
    Set<NavigationInstructionUpdateEvents> events,
  )? _onNavigationInstructionUpdated;
  void Function(Landmark waypoint)? _onWaypointReached;
  void Function(Landmark destination)? _onDestinationReached;
  void Function(GemError error)? _onNavigationError;
  void Function(Route route)? _onRouteUpdated;
  void Function(String ttsInstruction)? _onNavigationSound;
  void Function(NavigationStatus status)? _onNotifyStatusChange;
  void Function(Route route, int travelTime, int delay, int timeGain)?
      _onBetterRouteDetected;
  void Function(GemError reason)? _onBetterRouteRejected;
  void Function()? _onBetterRouteInvalidated;
  void Function()? _onSkipNextIntermediateDestinationDetected;
  void Function()? _onTurnAround;

  void registerOnNavigationStarted(final void Function()? callback) {
    _onNavigationStarted = callback;
  }

  void registerOnNavigationInstructionUpdated(
    final void Function(
      NavigationInstruction instruction,
      Set<NavigationInstructionUpdateEvents> events,
    )? callback,
  ) {
    _onNavigationInstructionUpdated = callback;
  }

  void registerOnWaypointReached(
    final void Function(Landmark waypoint)? callback,
  ) {
    _onWaypointReached = callback;
  }

  void registerOnDestinationReached(
    final void Function(Landmark destination)? callback,
  ) {
    _onDestinationReached = callback;
  }

  void registerOnNavigationError(
    final void Function(GemError error)? callback,
  ) {
    _onNavigationError = callback;
  }

  void registerOnRouteUpdated(final void Function(Route route)? callback) {
    _onRouteUpdated = callback;
  }

  void registerOnNavigationSound(
    final void Function(String ttsInstruction)? callback,
  ) {
    _onNavigationSound = callback;
  }

  void registerOnNotifyStatusChange(
    final void Function(NavigationStatus status)? callback,
  ) {
    _onNotifyStatusChange = callback;
  }

  void registerOnBetterRouteDetected(
    final void Function(Route route, int travelTime, int delay, int timeGain)?
        callback,
  ) {
    _onBetterRouteDetected = callback;
  }

  void registerOnBetterRouteRejected(
    final void Function(GemError reason)? callback,
  ) {
    _onBetterRouteRejected = callback;
  }

  void registerOnBetterRouteInvalidated(final void Function()? callback) {
    _onBetterRouteInvalidated = callback;
  }

  void registerOnSkipNextIntermediateDestinationDetected(
    final void Function()? callback,
  ) {
    _onSkipNextIntermediateDestinationDetected = callback;
  }

  void registerOnTurnAround(final void Function()? callback) {
    _onTurnAround = callback;
  }

  void registerAll({
    required final void Function()? onNavigationStarted,
    required final void Function(
      NavigationInstruction instruction,
      Set<NavigationInstructionUpdateEvents> events,
    )? onNavigationInstructionUpdated,
    required final void Function(Landmark waypoint)? onWaypointReached,
    required final void Function(Landmark destination)? onDestinationReached,
    required final void Function(GemError error)? onNavigationError,
    required final void Function(Route route)? onRouteUpdated,
    required final void Function(String ttsInstruction)? onNavigationSound,
    required final void Function(NavigationStatus status)? onNotifyStatusChange,
    required final void Function(
      Route route,
      int travelTime,
      int delay,
      int timeGain,
    )? onBetterRouteDetected,
    required final void Function(GemError reason)? onBetterRouteRejected,
    required final void Function()? onBetterRouteInvalidated,
    required final void Function()? onSkipNextIntermediateDestinationDetected,
    required final void Function()? onTurnAround,
  }) {
    _onNavigationStarted = onNavigationStarted;
    _onNavigationInstructionUpdated = onNavigationInstructionUpdated;
    _onWaypointReached = onWaypointReached;
    _onDestinationReached = onDestinationReached;
    _onNavigationError = onNavigationError;
    _onRouteUpdated = onRouteUpdated;
    _onNavigationSound = onNavigationSound;
    _onNotifyStatusChange = onNotifyStatusChange;
    _onBetterRouteDetected = onBetterRouteDetected;
    _onBetterRouteRejected = onBetterRouteRejected;
    _onBetterRouteInvalidated = onBetterRouteInvalidated;
    _onSkipNextIntermediateDestinationDetected =
        onSkipNextIntermediateDestinationDetected;
    _onTurnAround = onTurnAround;
  }

  @override
  FutureOr<void> dispose() {}

  @override
  void handleEvent(final Map<dynamic, dynamic> arguments) {
    final String eventType = arguments['eventType'];

    switch (eventType) {
      case 'navStarted':
        if (_onNavigationStarted != null) {
          _onNavigationStarted!();
        }
      case 'navInstructionUpdated':
        if (_onNavigationInstructionUpdated != null) {
          final int eventsInt = arguments['events'];
          final Set<NavigationInstructionUpdateEvents> events =
              <NavigationInstructionUpdateEvents>{};

          for (final NavigationInstructionUpdateEvents event
              in NavigationInstructionUpdateEvents.values) {
            if (event.id & eventsInt != 0) {
              events.add(event);
            }
          }

          final NavigationInstruction instruction = NavigationInstruction.init(
            arguments['instruction'],
          );
          _onNavigationInstructionUpdated!(instruction, events);
        }
      case 'navigationDstEvent':
        if (_onDestinationReached != null) {
          _onDestinationReached!(Landmark.init(arguments['landmark']));
        }
      case 'navigationWptEvent':
        if (_onWaypointReached != null) {
          _onWaypointReached!(Landmark.init(arguments['landmark']));
        }
      case 'navigationErrorEvent':
        if (_onNavigationError != null) {
          _onNavigationError!(GemErrorExtension.fromCode(arguments['errCode']));
        }
      case 'onRouteUpdated':
        if (_onRouteUpdated != null) {
          final Route route = Route.init(arguments['route']);
          _onRouteUpdated!(route);
        }
      case 'navSound':
        if (_onNavigationSound != null) {
          _onNavigationSound!(arguments['ttsString']);
        }
      case 'navStatusChange':
        if (_onNotifyStatusChange != null) {
          _onNotifyStatusChange!(
            NavigationStatusExtension.fromId(arguments['status']),
          );
        }
      case 'onBetterRouteDetected':
        if (_onBetterRouteDetected != null) {
          final Route route = Route.init(arguments['route']);
          _onBetterRouteDetected!(
            route,
            arguments['travelTime'],
            arguments['delay'],
            arguments['timeGain'],
          );
        }
      case 'onBetterRouteRejected':
        if (_onBetterRouteRejected != null) {
          _onBetterRouteRejected!(
            GemErrorExtension.fromCode(arguments['reason']),
          );
        }
      case 'onBetterRouteInvalidated':
        if (_onBetterRouteInvalidated != null) {
          _onBetterRouteInvalidated!();
        }
      case 'onSkipNextIntermediateDestinationDetected':
        if (_onSkipNextIntermediateDestinationDetected != null) {
          _onSkipNextIntermediateDestinationDetected!();
        }
      case 'onTurnAround':
        if (_onTurnAround != null) {
          _onTurnAround!();
        }
      default:
        gemSdkLogger.log(
          Level.WARNING,
          'Unknown event subtype: $eventType in NavigationListener',
        );
    }
  }
}
