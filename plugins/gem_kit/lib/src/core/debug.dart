// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'dart:convert';

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/map/markers.dart';
import 'package:gem_kit/weather.dart';
import 'package:logging/logging.dart';

/// Navigation modifiers
///
/// {@category Navigation}
enum NavigationModifiers {
  /// Force invalid GPS location.
  invalidLocation,

  /// Force untrusted GPS location.
  untrustedLocation,

  /// Force no matched link.
  invalidMatchedLink,

  /// Force no matched route link.
  invalidMatchedRouteLink,

  /// Force unblocking UTurn strategy.
  unlockUTurn,

  /// Disable intermediate waypoints in navigation instruction.
  disableIntermediateWaypoints,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Navigation}
extension NavigationModifiersExtension on NavigationModifiers {
  int get id {
    switch (this) {
      case NavigationModifiers.invalidLocation:
        return 1;
      case NavigationModifiers.untrustedLocation:
        return 2;
      case NavigationModifiers.invalidMatchedLink:
        return 4;
      case NavigationModifiers.invalidMatchedRouteLink:
        return 8;
      case NavigationModifiers.unlockUTurn:
        return 16;
      case NavigationModifiers.disableIntermediateWaypoints:
        return 32;
    }
  }

  static NavigationModifiers fromId(int id) {
    switch (id) {
      case 1:
        return NavigationModifiers.invalidLocation;
      case 2:
        return NavigationModifiers.untrustedLocation;
      case 4:
        return NavigationModifiers.invalidMatchedLink;
      case 8:
        return NavigationModifiers.invalidMatchedRouteLink;
      case 16:
        return NavigationModifiers.unlockUTurn;
      case 32:
        return NavigationModifiers.disableIntermediateWaypoints;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

enum RoutingAlgoModifiers {
  /// Disable unified links
  disableUFLayer,

  /// Disable layering jump
  disableLayering,

  /// Disable A-star cost policy
  disableAStar,

  /// Disable offline calculation
  disableOfflineCalc,

  /// Disable routing fallbacks
  disableFallbacks,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routing}
extension RoutingAlgoModifiersExtension on RoutingAlgoModifiers {
  int get id {
    switch (this) {
      case RoutingAlgoModifiers.disableUFLayer:
        return 1;
      case RoutingAlgoModifiers.disableLayering:
        return 2;
      case RoutingAlgoModifiers.disableAStar:
        return 4;
      case RoutingAlgoModifiers.disableOfflineCalc:
        return 8;
      case RoutingAlgoModifiers.disableFallbacks:
        return 16;
    }
  }

  static RoutingAlgoModifiers fromId(int id) {
    switch (id) {
      case 1:
        return RoutingAlgoModifiers.disableUFLayer;
      case 2:
        return RoutingAlgoModifiers.disableLayering;
      case 4:
        return RoutingAlgoModifiers.disableAStar;
      case 8:
        return RoutingAlgoModifiers.disableOfflineCalc;
      case 16:
        return RoutingAlgoModifiers.disableFallbacks;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// The log level for SDK features
///
/// {@category Core}
enum GemLoggingLevel {
  /// Severe
  severe,

  /// Warning
  warning,

  /// Info
  info,

  /// Config
  config,

  /// Fine
  fine,

  /// Finer
  finer,

  /// Finest
  finest,

  /// All
  all,

  /// Off
  off,
}

class MountInfo {
  MountInfo({
    required this.path,
    required this.freeSpace,
    required this.totalSpace,
    required this.internalPath,
    required this.onlineCachePath,
  });

  factory MountInfo.fromJson(Map<String, dynamic> json) {
    return MountInfo(
      path: json['path'],
      freeSpace: json['freeSpace'],
      totalSpace: json['totalSpace'],
      internalPath: json['internalPath'],
      onlineCachePath: json['onlineCachePath'],
    );
  }
  String path;
  int freeSpace;
  int totalSpace;
  bool internalPath;
  bool onlineCachePath;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'path': path,
      'freeSpace': freeSpace,
      'totalSpace': totalSpace,
      'internalPath': internalPath,
      'onlineCachePath': onlineCachePath,
    };
  }
}

/// Debug object
///
/// {@category Core}
abstract class Debug {
  /// Print log via the SDK logging system.
  /// These logs are sent to the Magic Lane servers in case of crashes.
  ///
  /// **Parameters**
  ///
  /// * **level** The severity of the log
  /// * **module** The module from which the log is coming.
  /// * **pszFunction** The function from which the log is issued.
  /// * **pszFile** The file from which the log is issued.
  /// * **line** The line number in the file at which the log is issued.
  /// * **message** The message to be logged. Should not contain characters which can be interpreted as format specifiers.
  static void log({
    required GemDumpSdkLevel level,
    String module = 'Application',
    String function = '',
    String file = '',
    int line = 0,
    required String message,
  }) {
    staticMethod('Debug', 'log', args: <String, Object>{
      'level': level.id,
      'pszModule': module,
      'pszFunction': function,
      'pszFile': file,
      'line': line,
      'str': message,
    });
  }

  /// Return memory used by the engine.
  ///
  /// **Returns**
  ///
  /// * The used memory in bytes.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static int getUsedMemory() {
    final OperationResult resultString = staticMethod('Debug', 'getUsedMemory');
    return resultString['result'];
  }

  /// Return system total memory
  ///
  /// **Returns**
  ///
  /// * The total memory in bytes.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static int getTotalMemory() {
    final OperationResult resultString = staticMethod(
      'Debug',
      'getTotalMemory',
    );
    return resultString['result'];
  }

  /// Return system free memory (this will include swap and kernel cache memory)
  ///
  /// **Returns**
  ///
  /// * The free memory in bytes.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static int getFreeMemory() {
    final OperationResult resultString = staticMethod('Debug', 'getFreeMemory');
    return resultString['result'];
  }

  /// Return MaxUsedMemory.
  ///
  /// **Returns**
  ///
  /// * The maximum used memory in bytes.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static int getMaxUsedMemory() {
    final OperationResult resultString = staticMethod(
      'Debug',
      'getMaxUsedMemory',
    );
    return resultString['result'];
  }

  /// Returns the Android version of the device.
  ///
  /// **Returns**
  ///
  /// * The android version as an integer.
  static int getAndroidVersion() {
    return GemKitPlatform.instance.androidVersion;
  }

  /// Get app I/O info
  ///
  /// **Returns**
  ///
  /// * A list of MountInfo structures, each providing details about a different storage mount point used by the application.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static List<MountInfo> getAppIOInfo() {
    final OperationResult resultString = staticMethod('Debug', 'getAppIOInfo');
    final List<dynamic> retval = resultString['result'];
    return retval.map((dynamic e) => MountInfo.fromJson(e)).toList();
  }

  /// Get default URLs for the specified service.
  ///
  /// **Parameters:**
  ///
  /// * **IN** *svc* Service identifier for which URLs are requested.
  ///
  /// **Returns**
  ///
  /// * A list of URLs configured for the specified service.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static List<String> getDefUrls(ServiceGroupType svc) {
    final OperationResult resultString = staticMethod(
      'Debug',
      'getDefUrls',
      args: svc.id,
    );
    final List<dynamic> retval = resultString['result'];
    return List<String>.from(retval);
  }

  /// Get URLs for the style builder.
  ///
  /// **Returns**
  ///
  /// * A list of URLs configured for the style builder.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static List<String> getStyleBuilderUrls() {
    final OperationResult resultString = staticMethod(
      'Debug',
      'getStyleBuilderUrls',
    );
    final List<dynamic> retval = resultString['result'];
    return List<String>.from(retval);
  }

  /// Get default URLs for the specified service.
  ///
  /// **Parameters:**
  ///
  /// * **IN** *svc* Service identifier for which the URL is to be set.
  /// * **IN** *url* The URL to set for the service.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void setCustomUrl(int svc, String url) {
    staticMethod(
      'Debug',
      'setCustomUrl',
      args: <String, Object>{'first': svc, 'second': url},
    );
  }

  /// Set modifiers for the routing algorithm to alter its behavior.
  ///
  /// **Parameters:**
  ///
  /// * **IN** *modifiers* The modifiers to be used within the navigation. See [RoutingAlgoModifiers] for details.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static void setRoutingAlgoModifiers(Set<RoutingAlgoModifiers> modifiers) {
    int packed = 0;
    for (final RoutingAlgoModifiers modifier in modifiers) {
      packed |= modifier.id;
    }

    staticMethod('Debug', 'setRoutingAlgoModifiers', args: packed);
  }

  /// Retrieve current routing algorithm modifiers.
  ///
  /// **Returns**
  ///
  /// * Current set of modifiers of routing algorithm. See [RoutingAlgoModifiers] for details.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static Set<RoutingAlgoModifiers> getRoutingAlgoModifiers() {
    final OperationResult resultString = staticMethod(
      'Debug',
      'getRoutingAlgoModifiers',
    );

    final int packed = resultString['result'];
    return RoutingAlgoModifiers.values
        .where((RoutingAlgoModifiers modifier) => (packed & modifier.id) != 0)
        .toSet();
  }

  /// Retrieve connections for a given route as markers.
  ///
  /// **Parameters:**
  ///
  /// * **IN** *route* The route for which connections are to be retrieved.
  ///
  /// **Returns**
  ///
  /// * A collection of markers representing the connections of the route.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static MarkerCollection? getRouteConnections(Route route) {
    final OperationResult resultString = staticMethod(
      'Debug',
      'getRouteConnections',
      args: route.pointerId,
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return MarkerCollection.init(resultString['result'], 0);
  }

  /// Set modifiers for navigation locations.
  ///
  /// **Parameters:**
  ///
  /// * **IN** *modifiers* The modifiers to be used within the navigation.  See [NavigationModifiers] for details.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static void setNavigationModifiers(Set<NavigationModifiers> modifiers) {
    int packed = 0;
    for (final NavigationModifiers modifier in modifiers) {
      packed |= modifier.id;
    }

    staticMethod('Debug', 'setNavigationModifiers', args: packed);
  }

  /// Retrieve the current navigation location modifiers.
  ///
  /// **Returns**
  ///
  /// * Current set of navigation location modifiers. See [NavigationModifiers] for details.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static Set<NavigationModifiers> getNavigationModifiers() {
    final OperationResult resultString = staticMethod(
      'Debug',
      'getNavigationModifiers',
    );

    final int packed = resultString['result'];
    return NavigationModifiers.values
        .where((NavigationModifiers modifier) => (packed & modifier.id) != 0)
        .toSet();
  }

  /// Initiate a check for a better route.
  ///
  /// **Returns**
  ///
  /// * True if a better route is found, false otherwise.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static bool checkBetterRoute() {
    final OperationResult resultString = staticMethod(
      'Debug',
      'checkBetterRoute',
    );

    return resultString['result'] != 0;
  }

  /// Initiate a check for traffic conditions along all routes.
  ///
  /// **Returns**
  ///
  /// * True if traffic conditions suggest a change in the route, false otherwise.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static bool checkTrafficAlongRoutes() {
    final OperationResult resultString = staticMethod(
      'Debug',
      'checkTrafficAlongRoutes',
    );

    return resultString['result'] != 0;
  }

  /// Get the remaining time until the next check for a better route.
  ///
  /// **Returns**
  ///
  /// * Time in seconds until the next check for a better route.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static int timeToBetterRouteSec() {
    final OperationResult resultString = staticMethod(
      'Debug',
      'timeToBetterRouteSec',
    );
    return resultString['result'];
  }

  /// Get the remaining time until the next check for traffic conditions along all routes.
  ///
  /// **Returns**
  ///
  /// * Time in seconds until the next traffic check along all routes.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static int timeToCheckTrafficAlongRoutesSec() {
    final OperationResult resultString = staticMethod(
      'Debug',
      'timeToCheckTrafficAlongRoutesSec',
    );
    return resultString['result'];
  }

  /// Perform a many-to-many pedestrian routing calculation.
  ///
  /// **Parameters:**
  ///
  /// * **IN** *start* Coordinates of the start point.
  /// * **IN** *end* Coordinates of the end point.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static void manyToManyPedestrianCalculation(
    Coordinates start,
    Coordinates end,
  ) {
    staticMethod(
      'Debug',
      'manyToManyPedestrianCalculation',
      args: <String, Coordinates>{'first': start, 'second': end},
    );
  }

  /// Perform a one-to-one pedestrian routing calculation.
  ///
  /// **Parameters:**
  ///
  /// * **IN** *start* Coordinates of the start point.
  /// * **IN** *end* Coordinates of the end point.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static void oneToOnePedestrianCalculation(
    Coordinates start,
    Coordinates end,
  ) {
    staticMethod(
      'Debug',
      'oneToOnePedestrianCalculation',
      args: <String, Coordinates>{'first': start, 'second': end},
    );
  }

  /// Retrieve a list of service IDs used within the application.
  ///
  /// **Returns**
  ///
  /// * A list of integer IDs representing the services.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static List<int> getServicesIds() {
    final OperationResult resultString = staticMethod(
      'Debug',
      'getServicesIds',
    );

    return List<int>.from(resultString['result']);
  }

  /// Retrieve the name of a service given its ID.
  ///
  /// **Parameters:**
  ///
  /// * **IN** *id* The ID of the service.
  ///
  /// **Returns**
  ///
  /// * The name of the service corresponding to the provided ID.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static String getServiceName(int id) {
    final OperationResult resultString = staticMethod(
      'Debug',
      'getServiceName',
      args: id,
    );

    return resultString['result'];
  }

  /// Retrieve all weather conditions parsed from all available resources.
  ///
  /// **Returns**
  ///
  /// * A [LocationForecast] object containing all the parsed weather conditions.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static LocationForecast getAllWeatherConditions() {
    final OperationResult resultString = staticMethod(
      'Debug',
      'getAllWeatherConditions',
    );

    return LocationForecast.fromJson(resultString['result']);
  }

  /// Refresh the content store by loading external changes from disk.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static void refreshContentStore() {
    staticMethod('Debug', 'refreshContentStore');
  }

  /// Refresh the content store by loading external changes from disk.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static void cleanupSocialCache() {
    staticMethod('Debug', 'cleanupSocialCache');
  }

  /// Update maps to the latest version synchronously.
  ///
  /// **Parameters:**
  ///
  /// * **IN** *force* If true, allows partial updates due to space constraints.
  ///
  /// **Returns**
  ///
  /// * An error code indicating the success or failure of the operation. See [GemError] for details.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static GemError updateMaps(bool force) {
    final OperationResult resultString = staticMethod(
      'Debug',
      'updateMaps',
      args: force,
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Check if the current thread is the main thread.
  ///
  /// **Returns**
  ///
  /// * True if the current thread is the main thread, false otherwise.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static bool isMainThread() {
    final OperationResult resultString = staticMethod('Debug', 'isMainThread');
    return resultString['result'];
  }

  /// Replay a previously recorded stream activity log.
  ///
  /// **Parameters:**
  ///
  /// * **IN** *path*  The path to the log file to be replayed.
  ///
  /// **Returns**
  ///
  /// * An error code indicating the success or failure of the operation. See [GemError] for details.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static GemError replayStreamActivityLog(String path) {
    final OperationResult resultString = staticMethod(
      'Debug',
      'replayStreamActivityLog',
      args: path,
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Retrieve the maximum zoom ranges allowed on a MapView
  ///
  /// **Returns**
  ///
  /// * The maximum zoom ranges allowed on a MapView.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static int getMapViewMaxZoomRanges() {
    final OperationResult resultString = staticMethod(
      'Debug',
      'getMapViewMaxZoomRanges',
    );
    return resultString['result'];
  }

  /// Check if raw position tracker is enabled
  ///
  /// **Returns**
  ///
  /// * True if raw positioning tracker is enabled, false otherwise.
  ///
  /// **Throws:**
  ///
  /// * An exception if it fails.
  static bool isRawPositionTrackerEnabled() {
    final OperationResult resultString = staticMethod(
      'Debug',
      'isRawPositionTrackerEnabled',
    );
    return resultString['result'];
  }

  /// If enabled prints create object calls JSONs to the console
  static bool logCreateObject = false;

  /// If enabled prints method object calls JSONs to the console
  static bool logCallObjectMethod = false;

  /// If enabled prints listener messages JSONs to the console
  static bool logListenerMethod = false;

  /// In enabled checks if an object is alive before calling a method on it.
  static bool isObjectAliveCheckEnabled = false;

  static Level _getLevel(GemLoggingLevel loggingLevel) {
    switch (loggingLevel) {
      case GemLoggingLevel.severe:
        return Level.SEVERE;
      case GemLoggingLevel.warning:
        return Level.WARNING;
      case GemLoggingLevel.info:
        return Level.INFO;
      case GemLoggingLevel.config:
        return Level.CONFIG;
      case GemLoggingLevel.fine:
        return Level.FINE;
      case GemLoggingLevel.finer:
        return Level.FINER;
      case GemLoggingLevel.finest:
        return Level.FINEST;
      case GemLoggingLevel.all:
        return Level.ALL;
      case GemLoggingLevel.off:
        return Level.OFF;
    }
  }

  static GemLoggingLevel _getGemLevel(Level level) {
    if (level == Level.SEVERE) {
      return GemLoggingLevel.severe;
    } else if (level == Level.WARNING) {
      return GemLoggingLevel.warning;
    } else if (level == Level.INFO) {
      return GemLoggingLevel.info;
    } else if (level == Level.CONFIG) {
      return GemLoggingLevel.config;
    } else if (level == Level.FINE) {
      return GemLoggingLevel.fine;
    } else if (level == Level.FINER) {
      return GemLoggingLevel.finer;
    } else if (level == Level.FINEST) {
      return GemLoggingLevel.finest;
    } else if (level == Level.ALL) {
      return GemLoggingLevel.all;
    } else if (level == Level.OFF) {
      return GemLoggingLevel.off;
    } else {
      return GemLoggingLevel.off;
    }
  }

  /// Set log level
  static set logLevel(GemLoggingLevel loggingLevel) {
    Logger.root.level = _getLevel(loggingLevel);
  }

  /// Get log level
  static GemLoggingLevel get logLevel {
    return _getGemLevel(Logger.root.level);
  }

  /// Set the level for logs sent to Magic Lane in case of crashes
  ///
  /// On Android all [GemDumpSdkLevel] values are available.
  ///
  /// On iOS only [GemDumpSdkLevel.silent] and [GemDumpSdkLevel.verbose] are supported.
  /// If a value other than [GemDumpSdkLevel.silent] is provided then [GemDumpSdkLevel.verbose] will be set.
  static Future<void> setSdkDumpLevel(GemDumpSdkLevel level) async {
    await GemKitPlatform.instance.getChannel(mapId: -1).invokeMethod(
          'setLogLevel',
          jsonEncode(<String, dynamic>{'level': level.id}),
        );
  }
}

/// The level for logs sent to Magic Lane in case of crashes.
///
/// {@category Core}
enum GemDumpSdkLevel {
  /// No log
  silent,

  /// Low traffic log level, used by the engine ONLY to print errors which are fatal
  /// (the application can't continue or it will crash shortly) and WITHOUT any private information.
  /// Example: "Can't find icon database", "The engine was called from another thread, a crash is imminent", etc.
  fatal,

  /// Low traffic log level, used by the engine ONLY to print errors which are not fatal
  /// (the application can live with them) and WITHOUT any private information.
  /// Example: "Can't connect to offboard server, retrying in 30 seconds".
  error,

  /// Low traffic log level, used be the engine ONLY to print warnings and WITHOUT
  /// any private information e.g. "Network is down, can't perform online search", etc.
  warn,

  /// Low/moderate traffic log level, used by the engine to print useful information
  /// e.g. "Download started", "Connected to offboard", etc. These information will NOT contain any private
  /// information e.g. device IMEI, positions, search strings, etc.
  info,

  /// High/moderate traffic log level, used by the engine to print useful debugging information
  /// [verbose] and [debug] logging levels are available *ONLY* when the SDK is built for
  /// debugging and they will be stripped away when the SDK will be compiled for release mode
  debug,

  /// High traffic log level, used by the engine to print high verbose logs
  verbose,
}

/// @nodoc
extension GemDumpSdkLevelExtension on GemDumpSdkLevel {
  int get id {
    switch (this) {
      case GemDumpSdkLevel.silent:
        return 6;
      case GemDumpSdkLevel.fatal:
        return 5;
      case GemDumpSdkLevel.error:
        return 4;
      case GemDumpSdkLevel.warn:
        return 3;
      case GemDumpSdkLevel.info:
        return 2;
      case GemDumpSdkLevel.debug:
        return 1;
      case GemDumpSdkLevel.verbose:
        return 0;
    }
  }

  static GemDumpSdkLevel fromId(int id) {
    switch (id) {
      case 6:
        return GemDumpSdkLevel.silent;
      case 5:
        return GemDumpSdkLevel.fatal;
      case 4:
        return GemDumpSdkLevel.error;
      case 3:
        return GemDumpSdkLevel.warn;
      case 2:
        return GemDumpSdkLevel.info;
      case 1:
        return GemDumpSdkLevel.debug;
      case 0:
        return GemDumpSdkLevel.verbose;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}
