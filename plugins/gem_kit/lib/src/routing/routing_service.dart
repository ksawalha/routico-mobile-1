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

import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/core/task_handler.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/routing/routing_preferences.dart';

/// Routing service class
///
/// {@category Routes & Navigation}
abstract class RoutingService {
  /// Calculate a route between the specified waypoints.
  ///
  /// **Parameters**
  ///
  /// * **IN** *waypoints* The list of waypoints for the route
  /// * **IN** *routePreferences* The preferences for the route calculation
  /// * **IN** *onCompleteCallback* Will be invoked when the search operation is completed, providing the search results and an error code.
  ///   * Will be called with [GemError.success] error and non-empty routes upon success.
  ///   * Will be called with [GemError.notSupported]  if the provided routing preferences contain an unsupported configuration
  ///   * Will be called with [GemError.invalidInput] if the calculation input contains invalid data, e.g. [waypoints].length < 1 < 2 for path result or [waypoints].length < 1 for range result type
  ///   * Will be called with [GemError.cancel] if the route calculation was canceled by the user
  ///   * Will be called with [GemError.waypointAccess] if a route couldn't be found using the provided routing preferences
  ///   * Will be called with [GemError.connectionRequired] if the routing preferences [RoutePreferences.allowOnlineCalculation] = false and the calculation cannot be done on client side due to missing necessary data
  ///   * Will be called with [GemError.expired] if the calculation cannot be done on client side due to missing necessary data and the client world map data version is no longer supported by the online routing service
  ///   * Will be called with [GemError.routeTooLong] if the routing was executed on the online service and the operation took too much time to complete ( usually more than 1 min, depending on the server overload state )
  ///   * Will be called with [GemError.invalidated] if the offline map data changed ( offline map downloaded, erased, updated ) during the calculation
  ///   * Will be called with [GemError.noMemory] if the routing engine couldn't allocate the necessary memory for the calculation
  ///
  /// **Returns**
  ///
  /// * The [TaskHandler] associated with the route calculation if it can be started otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler? calculateRoute(
    final List<Landmark> waypoints,
    final RoutePreferences routePreferences,
    final void Function(GemError err, List<Route> routes) onCompleteCallback,
  ) {
    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
    final RouteList results = RouteList();

    final LandmarkList waypointsList = LandmarkList.fromList(waypoints);

    progListener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);

      if (err == GemError.success.code) {
        onCompleteCallback(GemErrorExtension.fromCode(err), results.toList());
      } else {
        onCompleteCallback(GemErrorExtension.fromCode(err), <Route>[]);
      }
    });

    final OperationResult result = staticMethod(
      'RoutingService',
      'calculateRoute',
      args: <String, dynamic>{
        'results': results.pointerId,
        'listener': progListener.id,
        'waypoints': waypointsList.pointerId,
        'routePreferences': routePreferences,
      },
    );

    final GemError errorCode = GemErrorExtension.fromCode(result['result']);

    if (errorCode != GemError.success) {
      onCompleteCallback(errorCode, <Route>[]);
      return null;
    }

    return TaskHandlerImpl(progListener.id);
  }

  /// Cancel the route calculation associated with the specified listener.
  ///
  /// **Parameters**
  ///
  /// * **IN** *taskHandler* The listener associated with the route calculation to be canceled.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void cancelRoute(final TaskHandler taskHandler) {
    taskHandler as TaskHandlerImpl;

    staticMethod('RoutingService', 'cancelRoute', args: taskHandler.id);
  }

  /// Set a user road block from the provided route instruction.
  ///
  /// **Parameters**
  ///
  /// * **IN** *instruction* 	The route instruction containing the road block information.
  ///
  /// **Returns**
  ///
  /// * 0 on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static GemError setRouteRoadBlock(final RouteInstructionBase instruction) {
    final OperationResult result = staticMethod(
      'RoutingService',
      'setRouteRoadBlock',
      args: instruction.pointerId,
    );

    return GemErrorExtension.fromCode(result['result']);
  }

  /// Reset the user road blocks.
  ///
  /// This will remove all the user road blocks set by the user.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void resetRouteRoadBlocks() {
    objectMethod(0, 'RoutingService', 'resetRouteRoadBlocks');
  }

  /// Check if there is route calculation in progress associated with the specified task handler.
  ///
  /// **Parameters**
  ///
  /// * **IN** *taskHandler* The task handler associated with the route calculation to be canceled.
  ///
  /// **Returns**
  ///
  /// * true if the route calculation is in progress, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static bool isCalculationRunning(final TaskHandler taskHandler) {
    taskHandler as TaskHandlerImpl;

    final OperationResult result = staticMethod(
      'RoutingService',
      'isCalculationRunning',
      args: taskHandler.id,
    );
    return result['result'];
  }

  /// Get the status for the route monitored by the given task handler.
  ///
  /// **Parameters**
  ///
  /// * **IN** *taskHandler* The task handler associated with the route calculation to be canceled.
  ///
  /// **Returns**
  ///
  /// * The status of the route calculation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static RouteStatus getRouteStatus(final TaskHandler taskHandler) {
    taskHandler as TaskHandlerImpl;

    final OperationResult result = staticMethod(
      'RoutingService',
      'getRouteStatus',
      args: taskHandler.id,
    );
    return RouteStatusExtension.fromId(result['result']);
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
      'RoutingService',
      'getTransferStatistics',
    );

    return TransferStatistics.init(resultString['result']);
  }
}
