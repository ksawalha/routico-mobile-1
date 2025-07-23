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

import 'package:gem_kit/content_store.dart';
import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// Error reason type
///
/// {@category Core}
enum Reason {
  /// There is not enough space on disk.
  ///
  /// Resolution: run a cleanup procedure in order to free more disk space
  noDiskSpace,

  /// There is not enough space on disk.
  ///
  /// Resolution: run a cleanup procedure in order to free more disk space
  expiredSDK,
}

/// @nodoc
///
/// {@category Core}
extension ReasonExtension on Reason {
  int get id {
    switch (this) {
      case Reason.noDiskSpace:
        return 0;
      case Reason.expiredSDK:
        return 1;
    }
  }

  static Reason fromId(final int id) {
    switch (id) {
      case 0:
        return Reason.noDiskSpace;
      case 1:
        return Reason.expiredSDK;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Worldwide road map support status
///
/// {@category Core}
@Deprecated('Use MapStatus instead')
typedef Status = MapStatus;

/// Worldwide road map support status
///
/// {@category Core}
enum MapStatus {
  /// Notifies that the existing worldwide road map data is old, which implies that the SDK worldwide road map still has
  /// support but will not use the latest worldwide road map data.
  oldData,

  /// Notifies that the existing worldwide road map data is expired, which implies that the SDK worldwide road map does
  /// not have support anymore.
  expiredData,

  /// Notifies that the worldwide road map data is up to date This notification is sent only as a result of a
  /// [ContentStore.checkForUpdate] request.
  upToDate,
}

/// @nodoc
///
/// {@category Core}
extension MapStatusExtension on MapStatus {
  int get id {
    switch (this) {
      case MapStatus.oldData:
        return 0;
      case MapStatus.expiredData:
        return 1;
      case MapStatus.upToDate:
        return 2;
    }
  }

  static MapStatus fromId(final int id) {
    switch (id) {
      case 0:
        return MapStatus.oldData;
      case 1:
        return MapStatus.expiredData;
      case 2:
        return MapStatus.upToDate;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Service group enum, including map tiles, traffic, terrain.
///
/// {@category Core}
enum ServiceGroupType {
  /// All map data related services: map tiles, overlays, searching, routing.
  mapDataService,

  /// Traffic related services: live traffic flow, congestion, detours, closed roads.
  trafficService,

  /// Terrain/satellite/external WMTS services.
  terrainService,

  /// Content download service
  contentService,
}

/// @nodoc
///
/// {@category Core}
extension ServiceGroupTypeExtension on ServiceGroupType {
  int get id {
    switch (this) {
      case ServiceGroupType.mapDataService:
        return 0;
      case ServiceGroupType.trafficService:
        return 1;
      case ServiceGroupType.terrainService:
        return 2;
      case ServiceGroupType.contentService:
        return 3;
    }
  }

  static ServiceGroupType fromId(final int id) {
    switch (id) {
      case 0:
        return ServiceGroupType.mapDataService;
      case 1:
        return ServiceGroupType.trafficService;
      case 2:
        return ServiceGroupType.terrainService;
      case 3:
        return ServiceGroupType.contentService;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Represents online restrictions using bitwise flags.
///
/// {@category Core}
enum OnlineRestrictions {
  /// No internet connection
  connection,

  /// Restricted by network type (e.g., mobile network restrictions)
  networkType,

  /// Restricted due to rate limiting (too many requests)
  rateLimit,

  /// Restricted due to outdated service version
  outdated,

  /// Restricted due to authorization issues (e.g., no access rights)
  authorization,
}

/// This class will not be documented.
///
/// @nodoc
extension OnlineRestrictionsExtension on OnlineRestrictions {
  int get id {
    switch (this) {
      case OnlineRestrictions.connection:
        return 1;
      case OnlineRestrictions.networkType:
        return 2;
      case OnlineRestrictions.rateLimit:
        return 4;
      case OnlineRestrictions.outdated:
        return 8;
      case OnlineRestrictions.authorization:
        return 16;
    }
  }

  static OnlineRestrictions fromId(final int id) {
    switch (id) {
      case 1:
        return OnlineRestrictions.connection;
      case 2:
        return OnlineRestrictions.networkType;
      case 4:
        return OnlineRestrictions.rateLimit;
      case 8:
        return OnlineRestrictions.outdated;
      case 16:
        return OnlineRestrictions.authorization;
      default:
        throw ArgumentError('Invalid id: $id');
    }
  }
}

/// OffBoard Listener
///
/// {@category Core}
class OffBoardListener extends EventHandler {
  @internal
  factory OffBoardListener(final bool canDoAutoUpdate) =>
      OffBoardListener._create(canDoAutoUpdate);

  @internal
  OffBoardListener.init(this.id);

  void Function(bool isConnected)? _onConnectionStatusUpdatedCallback;
  void Function(ServiceGroupType type, bool isConnected)?
      _onConnectionStatusUpdated2Callback;
  void Function(bool isTopicNotificationsEnabled)?
      _onTopicNotificationsStatusUpdatedCallback;
  void Function(Reason reason)? _onWorldwideRoadMapSupportDisabledCallback;
  void Function(MapStatus state)? _onWorldwideRoadMapSupportStatusCallback;
  void Function()? _onWorldwideRoadMapSupportEnabledCallback;
  void Function()? _onResourcesReadyToDeployCallback;
  void Function(int size)? _onOnlineCacheSizeChangeCallback;
  void Function()? _onWorldwideRoadMapVersionUpdatedCallback;
  void Function(ContentType contentType, MapStatus statusCode)?
      _onAvailableContentUpdateCallback;
  void Function()? _onWorldwideRoadMapUnsupportedCapabilitiesCallback;
  void Function()? _onApiTokenRejectedCallback;
  void Function()? _onApiTokenUpdatedCallback;
  void Function(bool loggedIn)? _onLoginStatusUpdatedCallback;

  dynamic id;

  static OffBoardListener _create(final bool canDoAutoUpdateResources) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, dynamic>{
        'class': 'OffBoardListener',
        'args': canDoAutoUpdateResources,
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return OffBoardListener.init(decodedVal['result']);
  }

  /// Notifies that the connection status changed.
  ///
  /// **Parameters**
  ///
  /// * **IN** *isConnected* Tells if the connection to the online services is established.
  void registerOnConnectionStatusUpdated(
    final void Function(bool isConnected)? callback,
  ) {
    _onConnectionStatusUpdatedCallback = callback;
  }

  /// Notifies that the connection status changed for the given service group
  ///
  /// **Parameters**
  ///
  /// * **IN** *serviceGroupType* The service group type
  /// * **IN** *isConnected* Tells if the connection is available.
  void registerOnConnectionStatusUpdated2(
    final void Function(ServiceGroupType serviceType, bool isConnected)?
        callback,
  ) {
    _onConnectionStatusUpdated2Callback = callback;
  }

  /// Notifies that the topic notifications service status changed.
  ///
  /// **Parameters**
  ///
  /// * **IN** *isTopicNotificationsEnabled* Tells that the topic notifications service is available
  void registerOnTopicNotificationsStatusUpdated(
    final void Function(bool isNotifying)? callback,
  ) {
    _onTopicNotificationsStatusUpdatedCallback = callback;
  }

  /// Notifies that the worldwide road map support is disabled
  /// Worldwide road map data, routing and traffic support is disabled
  ///
  /// **Parameters**
  ///
  /// * **IN** *reason* The reason why the worldwide road map support was disabled
  ///   - If reason is [Reason.expiredSDK] then the user is required to update the application to a version containing the SDK which supports all capabilities.
  ///   - If reason is [Reason.noDiskSpace] then the user is required to clear some space on their device
  void registerOnWorldwideRoadMapSupportDisabled(
    final void Function(Reason reason)? callback,
  ) {
    _onWorldwideRoadMapSupportDisabledCallback = callback;
  }

  /// Notifies about worldwide road map data state
  ///
  /// **Parameters**
  ///
  /// * **IN** *state* The worldwide road map support status
  void registerOnWorldwideRoadMapSupportStatus(
    final void Function(MapStatus status)? callback,
  ) {
    _onWorldwideRoadMapSupportStatusCallback = callback;
  }

  /// Notifies that the worldwide road map support is enabled
  ///
  /// Worldwide road map data, routing and traffic support is enabled
  void registerOnWorldwideRoadMapSupportEnabled(
    final void Function()? callback,
  ) {
    _onWorldwideRoadMapSupportEnabledCallback = callback;
  }

  /// Notifies that the application resources are ready to be deployed
  void registerOnResourcesReadyToDeploy(final void Function()? callback) {
    _onResourcesReadyToDeployCallback = callback;
  }

  /// Notifies that offboard cache changed size.
  /// Cache size is given in KB
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The new cache size in KB
  void registerOnOnlineCacheSizeChange(
    final void Function(int size)? callback,
  ) {
    _onOnlineCacheSizeChangeCallback = callback;
  }

  /// Notifies that the worldwide road map version was updated
  void registerOnWorldwideRoadMapVersionUpdated(
    final void Function()? callback,
  ) {
    _onWorldwideRoadMapVersionUpdatedCallback = callback;
  }

  /// Notifies about existing content update
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* Content type
  /// * **IN** *state* Content status code
  void registerOnAvailableContentUpdate(
    final void Function(ContentType type, MapStatus status)? callback,
  ) {
    _onAvailableContentUpdateCallback = callback;
  }

  /// Notifies that current SDK doesn't support all worldwide road map capabilities.
  ///
  /// SDK can use the latest worldwide road map version but the new map capabilities are disabled
  void registerOnWorldwideRoadMapUnsupportedCapabilities(
    final void Function()? callback,
  ) {
    _onWorldwideRoadMapUnsupportedCapabilitiesCallback = callback;
  }

  /// Notifies that current API token was rejected
  ///
  /// Please check the API token availability or contact MagicLane support
  void registerOnApiTokenRejected(final void Function()? callback) {
    _onApiTokenRejectedCallback = callback;
  }

  /// Notifies that current API token was updated
  ///
  /// This notification will be available only for tokens updated internally via MagicEarth services
  void registerOnApiTokenUpdated(final void Function()? callback) {
    _onApiTokenUpdatedCallback = callback;
  }

  /// Notifies that social login state changed
  ///
  /// **Parameters**
  ///
  /// * **IN** *loggedIn* True if the user is logged in, false otherwise
  void registerOnLoginStatusUpdated(
    final void Function(bool isLoggedIn)? callback,
  ) {
    _onLoginStatusUpdatedCallback = callback;
  }

  @override
  FutureOr<void> dispose() {}

  @override
  void handleEvent(final Map<dynamic, dynamic> arguments) {
    final String eventSubtype = arguments['event_subtype'];

    switch (eventSubtype) {
      case 'onConnectionStatusUpdated':
        if (_onConnectionStatusUpdatedCallback != null) {
          _onConnectionStatusUpdatedCallback!(arguments['connected']);
        }

      case 'onConnectionStatusUpdated2':
        if (_onConnectionStatusUpdated2Callback != null) {
          _onConnectionStatusUpdated2Callback!(
            ServiceGroupType.values[arguments['svc']],
            arguments['connected'],
          );
        }

      case 'onTopicNotificationsStatusUpdated':
        if (_onTopicNotificationsStatusUpdatedCallback != null) {
          _onTopicNotificationsStatusUpdatedCallback!(arguments['available']);
        }

      case 'onWorldwideRoadMapSupportDisabled':
        if (_onWorldwideRoadMapSupportDisabledCallback != null) {
          _onWorldwideRoadMapSupportDisabledCallback!(
            Reason.values[arguments['reason']],
          );
        }

      case 'onWorldwideRoadMapSupportStatus':
        if (_onWorldwideRoadMapSupportStatusCallback != null) {
          _onWorldwideRoadMapSupportStatusCallback!(
            MapStatus.values[arguments['state']],
          );
        }
        _onWorldwideRoadMapSupportStatusCallbackAutoUpdate(
          MapStatus.values[arguments['state']],
        );

      case 'onWorldwideRoadMapSupportEnabled':
        if (_onWorldwideRoadMapSupportEnabledCallback != null) {
          _onWorldwideRoadMapSupportEnabledCallback!();
        }

      case 'onResourcesReadyToDeploy':
        if (_onResourcesReadyToDeployCallback != null) {
          _onResourcesReadyToDeployCallback!();
        }

      case 'onOnlineCacheSizeChange':
        if (_onOnlineCacheSizeChangeCallback != null) {
          _onOnlineCacheSizeChangeCallback!(arguments['size']);
        }

      case 'onWorldwideRoadMapVersionUpdated':
        if (_onWorldwideRoadMapVersionUpdatedCallback != null) {
          _onWorldwideRoadMapVersionUpdatedCallback!();
        }

      case 'onAvailableContentUpdate':
        if (_onAvailableContentUpdateCallback != null) {
          _onAvailableContentUpdateCallback!(
            ContentTypeExtension.fromId(arguments['type']),
            MapStatus.values[arguments['state']],
          );
        }
        _onAvailableContentUpdateCallbackAutoUpdate(
          ContentTypeExtension.fromId(arguments['type']),
          MapStatus.values[arguments['state']],
        );

      case 'onWorldwideRoadMapUnsupportedCapabilities':
        if (_onWorldwideRoadMapUnsupportedCapabilitiesCallback != null) {
          _onWorldwideRoadMapUnsupportedCapabilitiesCallback!();
        }

      case 'onApiTokenRejected':
        if (_onApiTokenRejectedCallback != null) {
          _onApiTokenRejectedCallback!();
        }

      case 'onApiTokenUpdated':
        if (_onApiTokenUpdatedCallback != null) {
          _onApiTokenUpdatedCallback!();
        }

      case 'onLoginStatusUpdated':
        if (_onLoginStatusUpdatedCallback != null) {
          _onLoginStatusUpdatedCallback!(arguments['loggedIn']);
        }

      default:
        gemSdkLogger.log(
          Level.WARNING,
          'Unknown event subtype: $eventSubtype in OffboardListener',
        );
    }
  }

  /// Verifies that application resources update is allowed. Returning true will allow the SDK to download and prepare the latest resources
  ///
  /// Returns true if the resources update is allowed, false otherwise
  bool get isAutoUpdateForResourcesEnabled {
    final OperationResult resultString = objectMethod(
      id,
      'OffboardListener',
      'isResourcesUpdateAllowed',
    );

    return resultString['result'];
  }

  /// Sets the resources update allowed flag
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* True if the resources update is allowed, false otherwise
  set isAutoUpdateForResourcesEnabled(bool value) {
    objectMethod(
      id,
      'OffboardListener',
      'setIsResourcesUpdateAllowed',
      args: value,
    );
  }

  /// Whether the update for the road maps is enabled
  bool isAutoUpdateForRoadMapEnabled = true;

  /// Whether the update for the map styles high resolution is enabled
  bool isAutoUpdateForViewStyleHighResEnabled = true;

  /// Whether the update for the map styles low resolution is enabled
  bool isAutoUpdateForViewStyleLowResEnabled = true;

  /// Whether the update for the human voices is enabled
  bool isAutoUpdateForHumanVoiceEnabled = false;

  /// Whether the update for the computer voices is enabled
  bool isAutoUpdateForComputerVoiceEnabled = false;

  /// Whether the update for the car models is enabled
  bool isAutoUpdateForCarModelEnabled = false;

  void Function(ContentType type, GemError error)? _onAutoUpdateComplete;

  /// Sets the callback for auto update complete
  void registerOnAutoUpdateComplete(
    void Function(ContentType type, GemError error)? onAutoUpdateComplete,
  ) {
    _onAutoUpdateComplete = onAutoUpdateComplete;
  }

  /// Sets the auto update settings
  ///
  /// **Parameters**
  ///
  /// * **IN** *autoUpdateSettings* Auto update settings
  set autoUpdateSettings(AutoUpdateSettings autoUpdateSettings) {
    isAutoUpdateForResourcesEnabled =
        autoUpdateSettings.isAutoUpdateForResourcesEnabled;
    isAutoUpdateForRoadMapEnabled =
        autoUpdateSettings.isAutoUpdateForRoadMapEnabled;
    isAutoUpdateForViewStyleHighResEnabled =
        autoUpdateSettings.isAutoUpdateForViewStyleHighResEnabled;
    isAutoUpdateForViewStyleLowResEnabled =
        autoUpdateSettings.isAutoUpdateForViewStyleLowResEnabled;
    isAutoUpdateForHumanVoiceEnabled =
        autoUpdateSettings.isAutoUpdateForHumanVoiceEnabled;
    isAutoUpdateForComputerVoiceEnabled =
        autoUpdateSettings.isAutoUpdateForComputerVoiceEnabled;
    isAutoUpdateForCarModelEnabled =
        autoUpdateSettings.isAutoUpdateForCarModelEnabled;
    _onAutoUpdateComplete = autoUpdateSettings.onAutoUpdateComplete;
  }

  void _onAvailableContentUpdateCallbackAutoUpdate(
    final ContentType type,
    final MapStatus status,
  ) {
    gemSdkLogger.finest(
      '[SdkDebug][LoadNativeAutoUpdate] Got update status $status for $type',
    );
    if (status == MapStatus.upToDate) {
      gemSdkLogger.info(
        '[SdkDebug][LoadNativeAutoUpdate] No update for type $type.',
      );
      return;
    }
    if (!_isUpdateAllowedForType(type)) {
      gemSdkLogger.info(
        '[SdkDebug][LoadNativeAutoUpdate] Update available and disabled for type $type.',
      );
      return;
    }

    final (ContentUpdater, GemError) result =
        ContentStore.createContentUpdater(type);
    final GemError createError = result.$2;
    final ContentUpdater otherContentUpdater = result.$1;

    if (createError != GemError.success && createError != GemError.exist) {
      gemSdkLogger.severe(
        '[SdkDebug][LoadNativeAutoUpdate] Create updater for type $type failed with erorr code $createError.',
      );
      return;
    }

    otherContentUpdater.update(
      true,
      onStatusUpdated: (final ContentUpdaterStatus status) {
        gemSdkLogger.finest(
          '[SdkDebug][LoadNativeAutoUpdate] On status updated for type $type changed with status $status.',
        );

        if (status == ContentUpdaterStatus.fullyReady ||
            status == ContentUpdaterStatus.partiallyReady) {
          otherContentUpdater.apply();
        }
      },
      onCompleteCallback: (final GemError error) {
        gemSdkLogger.info(
          '[SdkDebug][LoadNativeAutoUpdate] Updated completed for $type with error $error.',
        );
        _onAutoUpdateComplete?.call(type, error);
      },
    );
  }

  void _onWorldwideRoadMapSupportStatusCallbackAutoUpdate(
    final MapStatus status,
  ) {
    gemSdkLogger.info(
      '[SdkDebug][LoadNativeAutoUpdate] Got update status $status for roadMap',
    );
    if (status == MapStatus.upToDate) {
      gemSdkLogger.info(
        '[SdkDebug][LoadNativeAutoUpdate] No update for type roadMap.',
      );
      return;
    }
    if (!_isUpdateAllowedForType(ContentType.roadMap)) {
      gemSdkLogger.info(
        '[SdkDebug][LoadNativeAutoUpdate] Update available and disabled for type roadMap.',
      );
      return;
    }

    final (ContentUpdater, GemError) result =
        ContentStore.createContentUpdater(ContentType.roadMap);
    final GemError createError = result.$2;
    final ContentUpdater roadMapUpdater = result.$1;

    if (createError != GemError.success && createError != GemError.exist) {
      gemSdkLogger.info(
        '[SdkDebug][LoadNativeAutoUpdate] Create updater for type roadMap failed with erorr code $createError.',
      );
      return;
    }

    roadMapUpdater.update(
      true,
      onStatusUpdated: (final ContentUpdaterStatus status) {
        gemSdkLogger.info(
          '[SdkDebug][LoadNativeAutoUpdate] On status updated for type roadMap changed with status $status.',
        );
        if (status == ContentUpdaterStatus.fullyReady ||
            status == ContentUpdaterStatus.partiallyReady) {
          roadMapUpdater.apply();
        }
      },
      onCompleteCallback: (final GemError error) {
        gemSdkLogger.info(
          '[SdkDebug][LoadNativeAutoUpdate] Updated completed for roadMap with error $error.',
        );
        _onAutoUpdateComplete?.call(ContentType.roadMap, error);
      },
    );
  }

  bool _isUpdateAllowedForType(final ContentType type) {
    switch (type) {
      case ContentType.roadMap:
        return isAutoUpdateForRoadMapEnabled;
      case ContentType.viewStyleHighRes:
        return isAutoUpdateForViewStyleHighResEnabled;
      case ContentType.viewStyleLowRes:
        return isAutoUpdateForViewStyleLowResEnabled;
      case ContentType.humanVoice:
        return isAutoUpdateForHumanVoiceEnabled;
      case ContentType.computerVoice:
        return isAutoUpdateForComputerVoiceEnabled;
      case ContentType.carModel:
        return isAutoUpdateForCarModelEnabled;
      case ContentType.unknown:
        return false;
    }
  }
}
