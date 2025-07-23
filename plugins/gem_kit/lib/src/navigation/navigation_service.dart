// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/navigation_listener.dart';
import 'package:gem_kit/src/core/task_handler.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/navigation/navigation_instruction.dart';

/// Navigation instruction event types
///
///
/// {@category Routes & Navigation}
@Deprecated(
  'Use specialized startNavigation/startSimulation callbacks instead. Will be removed in a future version.',
)
enum NavigationEventType {
  /// Signal that the navigation request finished with error.
  @Deprecated(
    'Use onError startNavigation/startSimulation callback instead. Will be removed in a future version.',
  )
  error,

  /// Notification received when the destination has been reached.
  ///
  /// This is the moment when the navigation request finished with success.
  @Deprecated(
    'Use onDestinationReached startNavigation/startSimulation callback instead. Will be removed in a future version.',
  )
  destinationReached,

  /// Notification called when the navigation instruction is updated.
  ///
  /// This method is called periodically, usually at 1 second intervals, to update the navigation information for the UI.
  @Deprecated(
    'Use onNavigationInstruction startNavigation/startSimulation callback instead. Will be removed in a future version.',
  )
  navigationInstructionUpdate,
}

/// Navigation service class
///
/// {@category Routes & Navigation}
abstract class NavigationService {
  /// Cancel the active navigation.
  ///
  /// This method cancels the active navigation. If a route calculation is in progress then the provided callback will be triggered first with [GemError.cancel].
  ///
  /// **Parameters**
  ///
  /// * **IN** *navigationListener* Navigation listener used to identify the navigation session. If no listener is provided then the active navigation session will be cancelled.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void cancelNavigation([final TaskHandler? taskHandler]) {
    if (taskHandler != null) {
      taskHandler as TaskHandlerImpl;

      staticMethod('NavigationService', 'stopNavigation', args: taskHandler.id);
    } else {
      staticMethod('NavigationService', 'stopNavigation');
    }
  }

  /// Get better route time-distance until it forks the navigation route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *navigationListener* Navigation listener used to identify the navigation session.
  ///
  /// **Returns**
  ///
  /// * [TimeDistance] object containing the time in seconds and distance in meters to the next fork
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static TimeDistance getBetterRouteTimeDistanceToFork({
    final TaskHandler? taskHandler,
  }) {
    final OperationResult result = staticMethod(
      'NavigationService',
      'getBetterRouteTimeDistanceToFork',
      args: taskHandler ?? <dynamic, dynamic>{},
    );

    return TimeDistance.fromJson(result['result']);
  }

  /// Get the current navigation instruction.
  ///
  /// **Parameters**
  ///
  /// * **IN** *navigationListener* Navigation listener used to identify the navigation session.
  ///
  /// **Returns**
  ///
  /// * [NavigationInstruction] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static NavigationInstruction? getNavigationInstruction({
    final TaskHandler? taskHandler,
  }) {
    final OperationResult result = staticMethod(
      'NavigationService',
      'getNavigationInstruction',
      args: taskHandler ?? <dynamic, dynamic>{},
    );

    if (result['result'] == -1) {
      return null;
    }

    return NavigationInstruction.init(result['result']);
  }

  /// Get the current route used for navigation.
  ///
  /// **Parameters**
  ///
  /// * **IN** *navigationListener* Navigation listener used to identify the navigation session.
  ///
  /// **Returns**
  ///
  /// * Target route for the navigation session
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Route getNavigationRoute({final TaskHandler? taskHandler}) {
    final OperationResult result = staticMethod(
      'NavigationService',
      'getNavigationRoute',
      args: taskHandler ?? <dynamic, dynamic>{},
    );
    return Route.init(result['result']);
  }

  /// Get the maximum simulation speed multiplier.
  ///
  /// **Returns**
  ///
  /// * The maximum simulation speed multiplier
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static double get simulationMaxSpeedMultiplier {
    final OperationResult result = staticMethod(
      'NavigationService',
      'getSimulationMaxSpeedMultiplier',
    );
    return result['result'];
  }

  /// Get the minimum simulation speed multiplier.
  ///
  /// **Returns**
  ///
  /// * The minimum simulation speed multiplier
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static double get simulationMinSpeedMultiplier {
    final OperationResult result = staticMethod(
      'NavigationService',
      'getSimulationMinSpeedMultiplier',
    );
    return result['result'];
  }

  /// Check if there is an active navigation in progress.
  ///
  /// **Parameters**
  ///
  /// * **IN** *navigationListener* Navigation listener used to identify the navigation session.
  ///
  /// **Returns**
  ///
  /// * True if there is an active navigation in progress, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static bool isNavigationActive({final TaskHandler? taskHandler}) {
    final OperationResult result = staticMethod(
      'NavigationService',
      'isNavigationActive',
      args: taskHandler ?? <dynamic, dynamic>{},
    );
    return result['result'];
  }

  /// Check if there is an active simulation in progress.
  ///
  /// **Parameters**
  ///
  /// * **IN** *navigationListener* Navigation listener used to identify the simulation instance.
  ///
  /// **Returns**
  ///
  /// * True if there is an active simulation in progress, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static bool isSimulationActive({final TaskHandler? taskHandler}) {
    final OperationResult result = staticMethod(
      'NavigationService',
      'isSimulationActive',
      args: taskHandler ?? <dynamic, dynamic>{},
    );
    return result['result'];
  }

  /// Check if there is an active trip ( navigation or simulation ) in progress.
  ///
  /// **Parameters**
  ///
  /// * **IN** *navigationListener* Navigation listener used to identify the navigation session.
  ///
  /// **Returns**
  ///
  /// * True if there is an active trip in progress, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static bool isTripActive({final TaskHandler? taskHandler}) {
    final OperationResult result = staticMethod(
      'NavigationService',
      'isTripActive',
      args: taskHandler ?? <dynamic, dynamic>{},
    );
    return result['result'];
  }

  /// Set a roadblock on the current route having the length specified in meters starting from the current GPS position.
  ///
  /// **Parameters**
  ///
  /// * **IN** *length* The length specified in meters.
  /// * **IN** *startDistance* The distance from start where the roadblock begins, defaults to -1 meaning the current navigation position.
  /// * **IN** *navigationListener* Navigation listener used to identify the navigation session. If no values is given then the current active navigation will be used.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void setNavigationRoadBlock(
    final int length, {
    final int startDistance = -1,
    final TaskHandler? taskHandler,
  }) {
    taskHandler as TaskHandlerImpl?;

    staticMethod(
      'NavigationService',
      'setNavigationRoadBlock',
      args: <String, dynamic>{
        'length': length,
        'startDistance': startDistance,
        'navigationListener': taskHandler?.id ?? 0,
      },
    );
  }

  /// Start a new navigation
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* [Route] to use for the navigation.
  ///
  /// * **IN** *onNavigationInstructionUpdate* Callback for navigation-specific events.
  ///   * **eventType** [NavigationEventType] The type of navigation event.
  ///   * **instruction** [NavigationInstruction?] The navigation instruction, if any.
  ///
  /// * **IN** *onNavigationInstruction* Callback called when the navigation instruction is updated. This callback also sends turn update events.
  ///   * **instruction** [NavigationInstruction] The updated navigation instruction
  ///   * **events** [Set<NavigationInstructionUpdateEvents>] The events that triggered the update
  ///
  /// * **IN** *onTextToSpeechInstruction* Callback called when a sound needs to be played.
  ///   * **textInstruction** [String] The instruction text to be spoken.
  ///
  /// * **IN** *onWaypointReached* Callback called when a waypoint on the route has been reached. This callback is not called when the destination of the route has been reached. That is notified through [onDestinationReached] notification.
  ///   * **landmark** [Landmark] The landmark that was reached.
  ///
  /// * **IN** *onDestinationReached* Callback called when the destination has been reached. This is the moment when the navigation request finished with success.
  ///   * **landmark** [Landmark] The landmark that was reached.
  ///
  /// * **IN** *onRouteUpdated* Callback called when route was updated.
  ///   * **route** [Route] The updated route.
  ///
  /// * **IN** *onBetterRouteDetected* Better route was detected.
  /// The previous better route ( if it exists ) must be considered automatically invalidated. This callback is called when a route is calculated with 'avoid traffic' flag set to 'true' ([RoutePreferences.avoidTraffic]) and the engine detects a better route.
  ///   * **route** [Route] The newly detected better route.
  ///   * **travelTime** [int] The travel time of the new route in seconds.
  ///   * **delay** [int] Better route delay in seconds
  ///   * **timeGain** [int] Time gain from the existing route in seconds. `-1` means the original route has roadblocks and time gain cannot be calculated.
  ///
  /// * **IN** *onBetterRouteRejected* Better route rejected with given error code ( debug purposes )
  ///   * **errorCode** [GemError] Rejection reason
  ///
  /// * **IN** *onBetterRouteInvalidated* Previously detected better route became invalid. This callback is called when current position is no longer on the previously calculated better route
  ///
  /// * **IN** *onError* Callback called when an error occurs.
  ///   * **error** [GemError] The error code.
  ///
  /// * **IN** *onNotifyStatusChange* Callback to notify UI if the navigation status has changed.
  ///   * **status** [NavigationStatus] The navigation status.
  ///
  /// * **IN** *onSkipNextIntermediateDestinationDetected* Next intermediate destination skip intention detected. This notification is sent the navigation engine detects user intention to skip the next intermediate destination
  ///
  /// * **IN** *onTurnAround* Turn around callback. This callback is called after a navigation route recalculation, if the new route is heading on the opposite user travel direction
  ///
  /// * **IN** *onNavigationStarted* Navigation started callback. This callback is called when first valid position for navigation arrives
  ///
  /// * **IN** *autoPlaySound* Flag to indicate if sound should be played automatically when new TTS instruction are received
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler? startNavigation(
    final Route route,
    @Deprecated(
      'Use onNavigationInstruction, onDestinationReached and onError instead',
    )
    final void Function(
      NavigationEventType eventType,
      NavigationInstruction? instruction,
    )? onNavigationInstructionUpdate, {
    final void Function(
      NavigationInstruction instruction,
      Set<NavigationInstructionUpdateEvents> events,
    )? onNavigationInstruction,
    final void Function()? onNavigationStarted,
    final void Function(String textInstruction)? onTextToSpeechInstruction,
    final void Function(Landmark landmark)? onWaypointReached,
    final void Function(Landmark landmark)? onDestinationReached,
    final void Function(Route route)? onRouteUpdated,
    final void Function(Route route, int travelTime, int delay, int timeGain)?
        onBetterRouteDetected,
    final void Function(GemError reason)? onBetterRouteRejected,
    final void Function()? onBetterRouteInvalidated,
    final void Function()? onSkipNextIntermediateDestinationDetected,
    final void Function()? onTurnAround,
    final void Function(GemError error)? onError,
    final void Function(NavigationStatus status)? onNotifyStatusChange,
    @Deprecated(
      'Use SoundPlayingService.canPlaySounds instead',
    )
    final bool? autoPlaySound,
  }) {
    final OperationResult result = staticMethod(
      'NavigationService',
      'startNavigation',
      args: <String, dynamic>{'route': route.pointerId, 'simulation': false},
    );

    final int gemApiError = result['gemApiError'];

    if (GemErrorExtension.isErrorCode(gemApiError)) {
      final GemError errorCode = GemErrorExtension.fromCode(gemApiError);
      onError?.call(errorCode);
      return null;
    }

    if (autoPlaySound != null) {
      SoundPlayingService.canPlaySounds = autoPlaySound;
    }

    final int listenerId = result['result'];

    final NavigationListener listener = NavigationListener.init(listenerId);

    listener.registerAll(
        onNavigationStarted: onNavigationStarted,
        onNavigationInstructionUpdated: (
          final NavigationInstruction instruction,
          final Set<NavigationInstructionUpdateEvents> events,
        ) {
          onNavigationInstructionUpdate?.call(
            NavigationEventType.navigationInstructionUpdate,
            instruction,
          );
          onNavigationInstruction?.call(instruction, events);
        },
        onWaypointReached: onWaypointReached,
        onDestinationReached: (final Landmark destination) {
          onNavigationInstructionUpdate?.call(
            NavigationEventType.destinationReached,
            null,
          );
          onDestinationReached?.call(destination);
        },
        onNavigationError: (final GemError error) {
          GemKitPlatform.instance.unregisterEventHandler(listener.id);
          onNavigationInstructionUpdate?.call(NavigationEventType.error, null);
          onError?.call(error);
        },
        onRouteUpdated: onRouteUpdated,
        onNavigationSound: onTextToSpeechInstruction,
        onNotifyStatusChange: onNotifyStatusChange,
        onBetterRouteDetected: onBetterRouteDetected,
        onBetterRouteRejected: onBetterRouteRejected,
        onBetterRouteInvalidated: onBetterRouteInvalidated,
        onSkipNextIntermediateDestinationDetected:
            onSkipNextIntermediateDestinationDetected,
        onTurnAround: onTurnAround);

    GemKitPlatform.instance.registerEventHandler(listener.id, listener);
    return TaskHandlerImpl(listener.id);
  }

  /// Start a new simulation
  ///
  /// **Parameters**
  ///
  /// * **IN** *onNavigationInstructionUpdate* Callback for navigation-specific events.
  ///   * **eventType** [NavigationEventType] The type of navigation event.
  ///   * **instruction** [NavigationInstruction?] The navigation instruction, if any.
  ///
  /// * **IN** *onNavigationInstruction* Callback called when the navigation instruction is updated. This callback also sends turn update events.
  ///   * **instruction** [NavigationInstruction] The updated navigation instruction
  ///   * **events** [Set<NavigationInstructionUpdateEvents>] The events that triggered the update
  ///
  /// * **IN** *onTextToSpeechInstruction* Callback called when a sound needs to be played.
  ///   * **textInstruction** [String] The instruction text to be spoken.
  ///
  /// * **IN** *onWaypointReached* Callback called when a waypoint on the route has been reached. This callback is not called when the destination of the route has been reached. That is notified through [onDestinationReached] notification.
  ///   * **landmark** [Landmark] The landmark that was reached.
  ///
  /// * **IN** *onDestinationReached* Callback called when the destination has been reached. This is the moment when the navigation request finished with success.
  ///   * **landmark** [Landmark] The landmark that was reached.
  ///
  /// * **IN** *onRouteUpdated* Callback called when route was updated.
  ///   * **route** [Route] The updated route.
  ///
  /// * **IN** *onBetterRouteDetected* Better route was detected.
  /// The previous better route ( if it exists ) must be considered automatically invalidated. This callback is called when a route is calculated with 'avoid traffic' flag set to 'true' ([RoutePreferences.avoidTraffic]) and the engine detects a better route.
  ///   * **route** [Route] The newly detected better route.
  ///   * **travelTime** [int] The travel time of the new route in seconds.
  ///   * **delay** [int] Better route delay in seconds
  ///   * **timeGain** [int] Time gain from the existing route in seconds. `-1` means the original route has roadblocks and time gain cannot be calculated.
  ///
  /// * **IN** *onBetterRouteRejected* Better route rejected with given error code ( debug purposes )
  ///   * **errorCode** [GemError] Rejection reason
  ///
  /// * **IN** *onBetterRouteInvalidated* Previously detected better route became invalid. This callback is called when current position is no longer on the previously calculated better route
  ///
  /// * **IN** *onError* Callback called when an error occurs.
  ///   * **error** [GemError] The error code.
  ///
  /// * **IN** *onNotifyStatusChange* Callback to notify UI if the navigation status has changed.
  ///   * **status** [NavigationStatus] The navigation status.
  ///
  /// * **IN** *onSkipNextIntermediateDestinationDetected* Next intermediate destination skip intention detected. This notification is sent the navigation engine detects user intention to skip the next intermediate destination
  ///
  /// * **IN** *onTurnAround* Turn around callback. This callback is called after a navigation route recalculation, if the new route is heading on the opposite user travel direction
  ///
  /// * **IN** *onNavigationStarted* Navigation started callback. This callback is called when first valid position for navigation arrives
  ///
  /// * **IN** *autoPlaySound* Flag to indicate if sound should be played automatically when new TTS instruction are received
  ///
  /// * **IN** *speedMultiplier* Speed multiplier. The route simulation speed multiplier. Accepted values are in the interval [simulationMinSpeedMultiplier] - [simulationMaxSpeedMultiplier]. If set to 1.f the simulation speed is the speed limit of the traveled links
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler? startSimulation(
    final Route route,
    @Deprecated(
      'Use onNavigationInstruction, onDestinationReached and onError instead',
    )
    final void Function(
      NavigationEventType eventType,
      NavigationInstruction? instruction,
    )? onNavigationInstructionUpdate, {
    final void Function(
      NavigationInstruction instruction,
      Set<NavigationInstructionUpdateEvents> events,
    )? onNavigationInstruction,
    final void Function()? onNavigationStarted,
    final void Function(String textInstruction)? onTextToSpeechInstruction,
    final void Function(Landmark landmark)? onWaypointReached,
    final void Function(Landmark landmark)? onDestinationReached,
    final void Function(Route route)? onRouteUpdated,
    final void Function(Route route, int travelTime, int delay, int timeGain)?
        onBetterRouteDetected,
    final void Function(GemError reason)? onBetterRouteRejected,
    final void Function()? onBetterRouteInvalidated,
    final void Function()? onSkipNextIntermediateDestinationDetected,
    final void Function()? onTurnAround,
    final void Function(GemError error)? onError,
    final void Function(NavigationStatus status)? onNotifyStatusChange,
    @Deprecated(
      'Use SoundPlayingService.canPlaySounds instead',
    )
    final bool? autoPlaySound,
    final double speedMultiplier = 1.0,
  }) {
    final OperationResult result = staticMethod(
      'NavigationService',
      'startNavigation',
      args: <String, dynamic>{
        'route': route.pointerId,
        'simulation': true,
        'speedMultiplier': speedMultiplier,
      },
    );

    final int gemApiError = result['gemApiError'];

    if (GemErrorExtension.isErrorCode(gemApiError)) {
      final GemError errorCode = GemErrorExtension.fromCode(gemApiError);
      onError?.call(errorCode);
      return null;
    }

    if (autoPlaySound != null) {
      SoundPlayingService.canPlaySounds = autoPlaySound;
    }

    final int listenerId = result['result'];

    final NavigationListener listener = NavigationListener.init(listenerId);
    listener.registerAll(
      onNavigationStarted: onNavigationStarted,
      onNavigationInstructionUpdated: (
        final NavigationInstruction instruction,
        final Set<NavigationInstructionUpdateEvents> events,
      ) {
        onNavigationInstructionUpdate?.call(
          NavigationEventType.navigationInstructionUpdate,
          instruction,
        );
        onNavigationInstruction?.call(instruction, events);
      },
      onWaypointReached: onWaypointReached,
      onDestinationReached: (final Landmark destination) {
        onNavigationInstructionUpdate?.call(
          NavigationEventType.destinationReached,
          null,
        );
        onDestinationReached?.call(destination);
      },
      onNavigationError: (final GemError error) {
        GemKitPlatform.instance.unregisterEventHandler(listener.id);
        onNavigationInstructionUpdate?.call(NavigationEventType.error, null);
        onError?.call(error);
      },
      onRouteUpdated: onRouteUpdated,
      onNavigationSound: onTextToSpeechInstruction,
      onNotifyStatusChange: onNotifyStatusChange,
      onBetterRouteDetected: onBetterRouteDetected,
      onBetterRouteRejected: onBetterRouteRejected,
      onBetterRouteInvalidated: onBetterRouteInvalidated,
      onSkipNextIntermediateDestinationDetected:
          onSkipNextIntermediateDestinationDetected,
      onTurnAround: onTurnAround,
    );

    GemKitPlatform.instance.registerEventHandler(listener.id, listener);
    return TaskHandlerImpl(listener.id);
  }

  /// Get navigation parameters.
  ///
  /// **Returns**
  ///
  /// * Parameters list
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static ParameterList getNavigationParameters() {
    final OperationResult result = staticMethod(
      'NavigationService',
      'getNavigationParameters',
    );

    return ParameterList.init(result['result']);
  }

  /// Get intermediate waypoint drop recommended parameters.
  ///
  /// **Returns**
  ///
  /// * Parameters list
  ///
  ///   * **OUT** *waypoint_drop_radius* Large integer - radius in which the waypoint may be considered for a dropping attempt, in meters.
  ///   * **OUT** *waypoint_drop_distance_threshold* Double - factor by which the last dropping attempt distance to waypoint should be multiplied in order to set the next dropping attempt distance, i.e. next_drop_attempt_distance = next_drop_attempt_distance * "waypoint_drop_distance_threshold"
  ///   * **OUT** *waypoint_drop_min_distance_m* Large integer - minimum distance at which a waypoint may be target to a drop attempt
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static ParameterList getIntermediateWaypointDropParameters() {
    final OperationResult result = staticMethod(
      'NavigationService',
      'getIntermediateWaypointDropParameters',
    );

    return ParameterList.init(result['result']);
  }

  /// Skip next intermediate destination on the navigation route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *navigationListener* Navigation listener used to identify the navigation session.
  ///
  /// The route will be recalculated and an `onRouteUpdated` notification will be emitted
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.notFound] if there are no more intermediate waypoints on the route
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static GemError skipNextIntermediateDestination({
    final TaskHandler? taskHandler,
  }) {
    final OperationResult result = staticMethod(
      'NavigationService',
      'skipNextIntermediateDestination',
      args: taskHandler ?? <dynamic, dynamic>{},
    );

    return GemErrorExtension.fromCode(result['result']);
  }

  /// Get the transfer statistics
  ///
  /// **Returns**
  ///
  /// * The transfer statistics
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static TransferStatistics get transferStatistics {
    final OperationResult resultString = objectMethod(
      0,
      'NavigationService',
      'getTransferStatistics',
    );

    return TransferStatistics.init(resultString['result']);
  }
}

/// Navigation instruction update events
///
/// {@category Routes & Navigation}
enum NavigationInstructionUpdateEvents {
  /// Next route turn updated
  nextTurnUpdated,

  /// Turn image updated
  nextTurnImageUpdated,

  /// Lane image updated
  laneInfoUpdated,
}

/// @nodoc
extension NavigationInstructionUpdateEventsExtension
    on NavigationInstructionUpdateEvents {
  int get id {
    switch (this) {
      case NavigationInstructionUpdateEvents.nextTurnUpdated:
        return 1;
      case NavigationInstructionUpdateEvents.nextTurnImageUpdated:
        return 2;
      case NavigationInstructionUpdateEvents.laneInfoUpdated:
        return 4;
    }
  }

  static NavigationInstructionUpdateEvents fromId(final int id) {
    switch (id) {
      case 1:
        return NavigationInstructionUpdateEvents.nextTurnUpdated;
      case 2:
        return NavigationInstructionUpdateEvents.nextTurnImageUpdated;
      case 4:
        return NavigationInstructionUpdateEvents.laneInfoUpdated;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}
