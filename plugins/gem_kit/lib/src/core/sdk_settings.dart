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
import 'dart:typed_data';
import 'dart:ui';

import 'package:gem_kit/content_store.dart';
import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Represents the size and format of an image
///
/// {@category Core}
class SizeAndFormat {
  /// The constructor for the [SizeAndFormat] class
  SizeAndFormat({required this.size, required this.format});

  /// The size of the image
  final Size size;

  /// The format of the image
  final ImageFileFormat format;

  @override
  bool operator ==(covariant SizeAndFormat other) {
    if (identical(this, other)) {
      return true;
    }

    return other.size == size && other.format == format;
  }

  @override
  int get hashCode => size.hashCode ^ format.hashCode;
}

/// Network access customization.
///
/// {@category Core}
abstract class NetworkProvider {
  /// Checks if the device is connected to any network.
  static Future<bool> isConnected() async {
    final bool? result =
        await GemKitPlatform.instance.getChannel(mapId: -1).invokeMethod<bool>(
              'networkProviderCall',
              jsonEncode(<String, String>{'action': 'isConnected'}),
            );
    return result!;
  }

  /// Checks if the device is connected to a WiFi network.
  static Future<bool> isWifiConnected() async {
    final bool? result =
        await GemKitPlatform.instance.getChannel(mapId: -1).invokeMethod<bool>(
              'networkProviderCall',
              jsonEncode(<String, String>{'action': 'isWifiConnected'}),
            );
    return result!;
  }

  /// Checks if the device is connected to a mobile data network.
  static Future<bool> isMobileDataConnected() async {
    final bool? result =
        await GemKitPlatform.instance.getChannel(mapId: -1).invokeMethod(
              'networkProviderCall',
              jsonEncode(<String, String>{'action': 'isMobileDataConnected'}),
            );
    return result!;
  }

  static Future<void> refreshNetwork() async {
    await GemKitPlatform.instance.getChannel(mapId: -1).invokeMethod(
          'networkProviderCall',
          jsonEncode(<String, String>{'action': 'refreshNetwork'}),
        );
  }
}

/// Unit system
///
/// {@category Core}
enum UnitSystem {
  /// Metric
  metric,

  /// Imperial UK - miles and yards
  imperialUK,

  /// Imperial US - feet and inches
  imperialUS,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Core}
extension UnitSystemExtension on UnitSystem {
  int get id {
    switch (this) {
      case UnitSystem.metric:
        return 0;
      case UnitSystem.imperialUK:
        return 1;
      case UnitSystem.imperialUS:
        return 2;
    }
  }

  static UnitSystem fromId(int id) {
    switch (id) {
      case 0:
        return UnitSystem.metric;
      case 1:
        return UnitSystem.imperialUK;
      case 2:
        return UnitSystem.imperialUS;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Available options for map language selection.
///
/// {@category Core}
enum MapLanguage {
  /// The map language is automatically selected based on the API language.
  automaticLanguage,

  /// The native language is used on map objects.
  nativeLanguage,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Core}
extension MapLanguageExtension on MapLanguage {
  int get id {
    switch (this) {
      case MapLanguage.automaticLanguage:
        return 0;
      case MapLanguage.nativeLanguage:
        return 1;
    }
  }

  static MapLanguage fromId(int id) {
    switch (id) {
      case 0:
        return MapLanguage.automaticLanguage;
      case 1:
        return MapLanguage.nativeLanguage;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// The application theme
///
/// {@category Core}
enum AppTheme {
  /// Automatic theme selection
  automatic,

  /// Dark theme
  dark,

  /// Light theme
  light,
}

/// @nodoc
extension AppThemeExtension on AppTheme {
  int get id {
    switch (this) {
      case AppTheme.automatic:
        return 0;
      case AppTheme.dark:
        return 1;
      case AppTheme.light:
        return 2;
    }
  }

  static AppTheme fromId(int id) {
    switch (id) {
      case 0:
        return AppTheme.automatic;
      case 1:
        return AppTheme.dark;
      case 2:
        return AppTheme.light;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// SDK settings class
///
/// {@category Core}
abstract class SdkSettings {
  /// Get the unit system used by the SDK.
  ///
  /// **Returns**
  ///
  /// * The unit system
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static UnitSystem get unitSystem {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getUnitSystem',
    );

    return UnitSystemExtension.fromId(resultString['result']);
  }

  /// Set the unit system to be used by the SDK.
  ///
  /// This setting will affect the text of the route / navigation instructions and the voice instructions.
  ///
  /// **Parameters**
  ///
  /// * **IN** *unitSystem* The unit system to be used
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static set unitSystem(UnitSystem unitSystem) {
    objectMethod(0, 'SdkSettings', 'setUnitSystem', args: unitSystem.id);
  }

  /// Get the current decimal separator.
  ///
  /// **Returns**
  ///
  /// * The unit system
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static String get decimalSeparator {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getDecimalSeparator',
    );

    return resultString['result'];
  }

  /// Set a custom decimal separator.
  ///
  /// **Parameters**
  ///
  /// * **IN** *sepatator* The decimal separator
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static set decimalSeparator(String sepatator) {
    objectMethod(0, 'SdkSettings', 'setDecimalSeparator', args: sepatator);
  }

  /// Get the current digit group separator.
  ///
  /// **Returns**
  ///
  /// * The digit group separator
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static String get digitGroupSeparator {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getDigitGroupSeparator',
    );

    return resultString['result'];
  }

  /// Set a custom digit group separator.
  ///
  /// **Parameters**
  ///
  /// * **IN** *sepatator* The digit group separator
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static set digitGroupSeparator(String sepatator) {
    objectMethod(0, 'SdkSettings', 'setDigitGroupSeparator', args: sepatator);
  }

  /// Set if the connection is allowed or not.
  ///
  /// **Returns**
  ///
  /// * True if the connection is allowed, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static bool get allowConnection {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getAllowConnection',
    );

    return resultString['result'];
  }

  /// Allow/deny internet connection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *allowInternetConnection* Set if the SDK can connect to the internet
  /// * **IN** *canDoAutoUpdateResources* Set if the SDK can auto-update resources (icons, translations, etc.)
  /// * **IN** *onConnectionStatusUpdatedCallback* Callback which is triggered when the connection status is updated. Provides the internet connection status
  /// * **IN** *onConnectionStatusUpdated2Callback* Callback which is triggered when the connection status is updated for each type of service group. Provides the internet connection status and the group
  /// * **IN** *onTopicNotificationsStatusUpdatedCallback* Callback which is triggered when the topic notification connection status is updated. Provides the internet connection status
  /// * **IN** *onWorldwideRoadMapSupportDisabledCallback* Callback that notifies that the worldwide road map support is disabled. Provides the reason
  /// * **IN** *onWorldwideRoadMapSupportStatusCallback* Callback that notifies that the worldwide road map support is updated. Provides the reason
  /// * **IN** *onWorldwideRoadMapSupportEnabledCallback* Callback that notifies that the worldwide road map support is enabled
  /// * **IN** *onResourcesReadyToDeployCallback* Callback that triggers when the resources (icons, translations, etc.) are ready to be deployed after the update.
  /// * **IN** *onOnlineCacheSizeChangeCallback* Callback that notifies that offboard cache changed size.
  /// * **IN** *onWorldwideRoadMapVersionUpdatedCallback* Callback that notifies that the worldwide road map version was updated.
  /// * **IN** *onAvailableContentUpdateCallback* Callback that notifies about existing content update. Provides information about the content type and the status.
  /// * **IN** *onWorldwideRoadMapUnsupportedCapabilitiesCallback* Callback that notifies that current SDK doesn't support all worldwide road map capabilities.
  /// * **IN** *onApiTokenRejectedCallback* Callback that notifies that current API token was rejected.
  /// * **IN** *onApiTokenUpdatedCallback* Callback that notifies that current API token was updated.
  /// * **IN** *onLoginStatusUpdatedCallback* Callback that notifies that social login state changed.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  @Deprecated('Use setAllowInternetConnection instead')
  static void setAllowConnection(
    bool allowInternetConnection, {
    bool canDoAutoUpdateResources = true,
    void Function(bool isConnected)? onConnectionStatusUpdatedCallback,
    void Function(ServiceGroupType serviceType, bool isConnected)?
        onConnectionStatusUpdated2Callback,
    void Function(bool isAvailable)? onTopicNotificationsStatusUpdatedCallback,
    void Function(Reason reason)? onWorldwideRoadMapSupportDisabledCallback,
    void Function(MapStatus status)? onWorldwideRoadMapSupportStatusCallback,
    void Function()? onWorldwideRoadMapSupportEnabledCallback,
    void Function()? onResourcesReadyToDeployCallback,
    void Function(int size)? onOnlineCacheSizeChangeCallback,
    void Function()? onWorldwideRoadMapVersionUpdatedCallback,
    void Function(ContentType type, MapStatus status)?
        onAvailableContentUpdateCallback,
    void Function()? onWorldwideRoadMapUnsupportedCapabilitiesCallback,
    void Function()? onApiTokenRejectedCallback,
    void Function()? onApiTokenUpdatedCallback,
    void Function(bool isLoggedIn)? onLoginStatusUpdatedCallback,
  }) {
    offBoardListener.isAutoUpdateForResourcesEnabled = canDoAutoUpdateResources;
    offBoardListener.registerOnConnectionStatusUpdated(
      onConnectionStatusUpdatedCallback,
    );
    offBoardListener.registerOnConnectionStatusUpdated2(
      onConnectionStatusUpdated2Callback,
    );
    offBoardListener.registerOnTopicNotificationsStatusUpdated(
      onTopicNotificationsStatusUpdatedCallback,
    );
    offBoardListener.registerOnWorldwideRoadMapSupportDisabled(
      onWorldwideRoadMapSupportDisabledCallback,
    );
    offBoardListener.registerOnWorldwideRoadMapSupportStatus(
      onWorldwideRoadMapSupportStatusCallback,
    );
    offBoardListener.registerOnWorldwideRoadMapSupportEnabled(
      onWorldwideRoadMapSupportEnabledCallback,
    );
    offBoardListener.registerOnResourcesReadyToDeploy(
      onResourcesReadyToDeployCallback,
    );
    offBoardListener.registerOnOnlineCacheSizeChange(
      onOnlineCacheSizeChangeCallback,
    );
    offBoardListener.registerOnWorldwideRoadMapVersionUpdated(
      onWorldwideRoadMapVersionUpdatedCallback,
    );
    offBoardListener.registerOnAvailableContentUpdate(
      onAvailableContentUpdateCallback != null
          ? (ContentType type, MapStatus status) =>
              onAvailableContentUpdateCallback(type, status)
          : null,
    );
    offBoardListener.registerOnApiTokenRejected(onApiTokenRejectedCallback);
    offBoardListener.registerOnApiTokenUpdated(onApiTokenUpdatedCallback);
    offBoardListener.registerOnLoginStatusUpdated(onLoginStatusUpdatedCallback);

    GemKitPlatform.instance.registerEventHandler(
      offBoardListener.id,
      offBoardListener,
    );

    staticMethod(
      'SdkSettings',
      'setAllowConnection',
      args: <String, dynamic>{
        'allow': allowInternetConnection,
        'listener': offBoardListener.id,
      },
    );
    if (allowInternetConnection) {
      unawaited(NetworkProvider.refreshNetwork());
    }
  }

  static OffBoardListener? _offBoardListener;

  /// Get the offboard listener
  ///
  /// **Returns**
  ///
  /// * The offboard listener
  static OffBoardListener get offBoardListener {
    _offBoardListener ??= OffBoardListener(true);
    return _offBoardListener!;
  }

  /// Allow/deny internet connection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *allowInternetConnection* Set if the SDK can connect to the internet
  static void setAllowInternetConnection(bool allowInternetConnection) {
    GemKitPlatform.instance.registerEventHandler(
      offBoardListener.id,
      offBoardListener,
    );

    staticMethod(
      'SdkSettings',
      'setAllowConnection',
      args: <String, dynamic>{
        'allow': allowInternetConnection,
        'listener': offBoardListener.id,
      },
    );

    _offBoardListener = offBoardListener;
    if (allowInternetConnection) {
      unawaited(NetworkProvider.refreshNetwork());
    }
  }

  /// Forces auto update in respect to the configured [AutoUpdateSettings].
  ///
  /// Might also trigger the [OffBoardListener.registerOnWorldwideRoadMapVersionUpdated]/[OffBoardListener.registerOnAvailableContentUpdate] callbacks
  ///
  /// **Returns**
  ///
  /// * [GemError.success] if the operation could be started
  /// * [GemError.connectionRequired] if the device has no internet connection.
  static GemError autoUpdate() {
    if (offBoardListener.isAutoUpdateForRoadMapEnabled) {
      final GemError err = ContentStore.checkForUpdate(ContentType.roadMap);
      if (err != GemError.success) {
        return err;
      }
    }

    if (offBoardListener.isAutoUpdateForViewStyleHighResEnabled) {
      final GemError err = ContentStore.checkForUpdate(
        ContentType.viewStyleHighRes,
      );
      if (err != GemError.success) {
        return err;
      }
    }

    if (offBoardListener.isAutoUpdateForViewStyleLowResEnabled) {
      final GemError err = ContentStore.checkForUpdate(
        ContentType.viewStyleLowRes,
      );
      if (err != GemError.success) {
        return err;
      }
    }

    if (offBoardListener.isAutoUpdateForHumanVoiceEnabled) {
      final GemError err = ContentStore.checkForUpdate(ContentType.humanVoice);
      if (err != GemError.success) {
        return err;
      }
    }

    if (offBoardListener.isAutoUpdateForComputerVoiceEnabled) {
      final GemError err = ContentStore.checkForUpdate(
        ContentType.computerVoice,
      );
      if (err != GemError.success) {
        return err;
      }
    }

    if (offBoardListener.isAutoUpdateForCarModelEnabled) {
      final GemError err = ContentStore.checkForUpdate(ContentType.carModel);
      if (err != GemError.success) {
        return err;
      }
    }

    return GemError.success;
  }

  /// @nodoc
  ///
  /// The API user should not call this method
  @internal
  static void reset() {
    _offBoardListener = null;
  }

  /// Check if the given service type is allowed on the extra charged network.
  ///
  /// **Parameters**
  ///
  /// * **IN** *serviceType* The service type, [ServiceGroupType] object
  ///
  /// **Returns**
  ///
  /// * True if the service is allowed on the extra charged network, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static bool getAllowOffboardServiceOnExtraChargedNetwork(
    ServiceGroupType serviceType,
  ) {
    final OperationResult resultString = objectMethod(
      0,
      'SdkSettings',
      'getAllowOffboardServiceOnExtraChargedNetwork',
      args: serviceType.id,
    );

    return resultString['result'];
  }

  /// Allow the given service type on the extra charged network type. By default all are allowed.
  ///
  /// **Parameters**
  ///
  /// * **IN** *serviceType* [ServiceGroupType] object containing the service type
  /// * **IN** *allow* Allow/deny value, [bool] type
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void setAllowOffboardServiceOnExtraChargedNetwork(
    ServiceGroupType serviceType,
    bool allow,
  ) {
    objectMethod(
      0,
      'SdkSettings',
      'setAllowOffboardServiceOnExtraChargedNetwork',
      args: <String, Object>{'serviceType': serviceType.id, 'allow': allow},
    );
  }

  /// Get online service restrictions.
  ///
  /// **Parameters**
  ///
  /// * **IN** *serviceType* The service group id, [ServiceGroupType] object
  ///
  /// **Returns**
  ///
  /// * The [OnlineRestrictions] set
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Set<OnlineRestrictions> getOnlineServiceRestriction(
    ServiceGroupType serviceType,
  ) {
    final OperationResult resultString = objectMethod(
      0,
      'SdkSettings',
      'getOnlineServiceRestriction',
      args: serviceType.id,
    );

    final int packed = resultString['result'];

    return OnlineRestrictions.values
        .where(
          (OnlineRestrictions element) => (packed & element.id) != 0,
        )
        .toSet();
  }

  /// Get topic notifications service restrictions.
  ///
  /// **Parameters**
  ///
  /// * **IN** *serviceType* The service group id, [ServiceGroupType] object
  ///
  /// **Returns**
  ///
  /// * The [OnlineRestrictions] set
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Set<OnlineRestrictions> getTopicNotificationsServiceRestriction(
    ServiceGroupType serviceType,
  ) {
    final OperationResult resultString = objectMethod(
      0,
      'SdkSettings',
      'getTopicNotificationsServiceRestriction',
      args: serviceType.id,
    );

    final int packed = resultString['result'];

    return OnlineRestrictions.values
        .where(
          (OnlineRestrictions element) => (packed & element.id) != 0,
        )
        .toSet();
  }

  /// Get the API language.
  ///
  /// **Returns**
  ///
  /// * [Language] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Language get language {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getLanguage',
    );

    return Language.fromJson(resultString['result']);
  }

  /// Find the best language match for the provided input(language code, region code, variant and script code).
  ///
  /// **Parameters**
  ///
  /// * **IN** *languageCode* ISO 639-3 three-letter language code.
  /// * **IN** *regionCode* ISO 3166-1_3 three-letter region code, can be empty.
  /// * **IN** *scriptCode* ISO 15924 four-letter script code, can be empty.
  /// * **IN** *variant* script variant
  ///
  /// **Returns**
  ///
  /// * [Language] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Language getBestLanguageMatch(
    String languageCode,
    String regionCode,
    String scriptCode,
    int variant,
  ) {
    final OperationResult resultString = objectMethod(
      0,
      'SdkSettings',
      'getBestLanguageMatch',
      args: <String, Object>{
        'languageCode': languageCode,
        'regionCode': regionCode,
        'scriptCode': scriptCode,
        'variant': variant,
      },
    );

    return Language.fromJson(resultString['result']);
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
      'SdkSettings',
      'getTransferStatistics',
    );

    return TransferStatistics.init(resultString['result']);
  }

  /// Get the API language list.
  ///
  /// **Returns**
  ///
  /// * The languages list
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static List<Language> get languageList {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getLanguageList',
    );

    final List<dynamic> categoriesJson = resultString['result'];
    final List<Language> categories = categoriesJson
        .map((dynamic categoryJson) => Language.fromJson(categoryJson))
        .toList();
    return categories;
  }

  /// Set the API language.
  ///
  /// **Parameters**
  ///
  /// * **IN** *language* The selected language from the SDK list
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static set language(Language language) {
    objectMethod(0, 'SdkSettings', 'setLanguage', args: language);
  }

  /// Get the current setting for the map language selection.
  ///
  /// **Returns**
  ///
  /// * The map language selection method
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static MapLanguage get mapLanguage {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getMapLanguage',
    );

    return MapLanguageExtension.fromId(resultString['result']);
  }

  /// Set the map language selection method.
  ///
  /// **Parameters**
  ///
  /// * **IN** *mapLanguage* [MapLanguage] type
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static set mapLanguage(MapLanguage mapLanguage) {
    objectMethod(0, 'SdkSettings', 'setMapLanguage', args: mapLanguage.id);
  }

  /// Set maximum cache size/storage space to use for downloaded tiles in kilobytes (Kb).
  ///
  /// **Parameters**
  ///
  /// * **IN** *maxSpace* Size in Kb. If maxSpace is 0 there are no restrictions for tiles space.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static set tilesMaxSpace(int maxSpace) {
    objectMethod(0, 'SdkSettings', 'setTilesMaxSpace', args: maxSpace);
  }

  /// Get maximum storage space/cache size to use for downloaded tiles in kilobytes (Kb).
  ///
  /// **Returns**
  ///
  /// * Size in Kb
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static int get tilesMaxSpace {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getTilesMaxSpace',
    );

    return resultString['result'];
  }

  /// Set application name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* The application name.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static set applicationName(String name) {
    objectMethod(0, 'SdkSettings', 'setApplicationName', args: name);
  }

  /// Get application name.
  ///
  /// **Returns**
  ///
  /// * The application name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static String get applicationName {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getApplicationName',
    );

    return resultString['result'];
  }

  /// Set the SDK version
  ///
  /// **Parameters**
  ///
  /// * **IN** *version* The application version
  /// * **IN** *subVersion* The application sub version
  /// * **IN** *revision* The application revision
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void setSdkVersion(int version, int subVersion, int revision) {
    objectMethod(
      0,
      'SdkSettings',
      'setApplicationVersion',
      args: <String, int>{
        'first': version,
        'second': subVersion,
        'third': revision,
      },
    );
  }

  /// Get SKD version
  ///
  /// '0.1.2' 0 -> version, 1 -> subVersion, 2 -> revision
  ///
  /// The revision is unsigned hexadecimal
  ///
  /// **Returns**
  ///
  /// * The sdk version as String
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static String get sdkVersion {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getApplicationVersion',
    );

    final dynamic resultMap = resultString['result'];
    final int first = resultMap['first'];
    final int second = resultMap['second'];

    final int third = resultMap['third'];
    final int unsignedValue = third & 0xFFFFFFFF;
    final String hexValue = unsignedValue.toRadixString(16).toUpperCase();

    return '$first.$second.$hexValue';
  }

  /// Set device name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* The device name.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static set deviceName(String name) {
    objectMethod(0, 'SdkSettings', 'setDeviceName', args: name);
  }

  /// Get device name.
  ///
  /// **Returns**
  ///
  /// * The device name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static String get deviceName {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getDeviceName',
    );

    return resultString['result'];
  }

  /// Set device model.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* The device model.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static set deviceModel(String model) {
    objectMethod(0, 'SdkSettings', 'setDeviceModel', args: model);
  }

  /// Get device model.
  ///
  /// **Returns**
  ///
  /// * The device model
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static String get deviceModel {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getDeviceModel',
    );

    return resultString['result'];
  }

  /// Set the current TTS (computer) voice used for text-to-speech instructions.
  ///
  /// The best voice is selected based on the provided language.
  ///
  /// **Parameters**
  ///
  /// * **IN** *language* The voice language.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  @Deprecated('Use setTTSVoiceByLanguage instead')
  static GemError setTTSLanguage(Language language) {
    final OperationResult resultString = objectMethod(
      0,
      'SdkSettings',
      'setVoice',
      args: <String, String>{
        'languageCode': language.languagecode,
        'regionCode': language.regioncode,
      },
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Set the current TTS (computer) voice used for text-to-speech instructions.
  ///
  /// The best voice is selected based on the provided language.
  ///
  /// **Parameters**
  ///
  /// * **IN** *language* The voice language.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static GemError setTTSVoiceByLanguage(Language language) {
    final OperationResult resultString = objectMethod(
      0,
      'SdkSettings',
      'setVoice',
      args: <String, String>{
        'languageCode': language.languagecode,
        'regionCode': language.regioncode,
      },
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Set the current voice by specifying the absolute path to the voice file.
  ///
  /// **Parameters**
  ///
  /// * **IN** *path* The absolute path to the voice file.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static GemError setVoiceByPath(String path) {
    final OperationResult resultString = objectMethod(
      0,
      'SdkSettings',
      'setVoiceByPath',
      args: <String, String>{'filePath': path},
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Get the current voice.
  ///
  /// **Returns**
  ///
  /// * The voice
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Voice getVoice() {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getVoice',
    );

    return Voice.init(resultString['result']);
  }

  /// Allow the given service type on the extra charged network type. By default all are allowed.
  ///
  /// **Parameters**
  ///
  /// * **IN** *token* The API token
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static set appAuthorization(String token) {
    if (isSDkInitialized) {
      objectMethod(0, 'SdkSettings', 'setAppAuthorization', args: token);
    } else {
      throw GemKitUninitializedException();
    }
  }

  /// Get the application authorization API token.
  ///
  /// Returns empty if no valid authorization API token is used.
  ///
  /// **Returns**
  ///
  /// * The token
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static String get appAuthorization {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getAppAuthorization',
    );

    return resultString['result'];
  }

  /// Verifies an app token.
  ///
  /// Validates the provided token and reports progress through the specified listener.
  ///
  /// **Parameters**
  /// * **IN** *token* The token to be verified. Must be a valid JWT token.
  /// * **IN** *callback* An operation progress listener that handles the validation process.
  ///   * *GemError.invalidInput* Triggered if the token format is invalid (e.g., not a JWT token).
  ///   * *GemError.expired* Triggered if the token is expired.
  ///   * *GemError.accessDenied* Triggered if the token is blacklisted (e.g., the token's `jti` or `aud` is blacklisted).
  ///   * Other error codes may be related to the validation process and are not directly related to token validity.
  ///
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void verifyAppAuthorization(
    String token,
    void Function(GemError err) callback,
  ) {
    final EventDrivenProgressListener listener = EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(listener.id, listener);
    listener.registerOnCompleteWithDataCallback((
      int err,
      String hint,
      Map<dynamic, dynamic> json,
    ) {
      callback(GemErrorExtension.fromCode(err));
      GemKitPlatform.instance.unregisterEventHandler(listener.id);
    });
    objectMethod(
      0,
      'SdkSettings',
      'verifyAppAuthorization',
      args: <String, dynamic>{'token': token, 'listener': listener.id},
    );
  }

  /// Get the images & texts render theme
  ///
  /// Default theme is automatic
  ///
  /// **Returns**
  ///
  /// * The app theme, [AppTheme] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static AppTheme get appTheme {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getTheme',
    );

    return AppThemeExtension.fromId(resultString['result']);
  }

  /// Get the actual images & texts render theme
  ///
  /// This will return the actual used theme ( dark /light ) when SDK theme was set to automatic
  ///
  /// **Returns**
  ///
  /// * The app theme, [AppTheme] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static AppTheme get actualAppTheme {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getActualTheme',
    );

    return AppThemeExtension.fromId(resultString['result']);
  }

  /// Set images & texts render theme
  ///
  /// **Parameters**
  ///
  /// * **IN** *theme* The app theme
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static set appTheme(AppTheme theme) {
    objectMethod(0, 'SdkSettings', 'setTheme', args: theme.id);
  }

  /// Get the image by its ID
  ///
  /// **Parameters**
  ///
  /// * **IN** *id* The image id
  /// * **IN** *size* [Size] of the image
  /// * **IN** *format* [ImageFileFormat] of the image.
  ///
  /// **Returns**
  ///
  /// * The image if it exists, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Uint8List? getImageById({
    required int id,
    Size? size,
    ImageFileFormat? format,
  }) {
    return GemKitPlatform.instance.callGetImage(
      id,
      'SdkSettingsgetImageById',
      size?.width.toInt() ?? -1,
      size?.height.toInt() ?? -1,
      format?.id ?? -1,
      imageId: id,
    );
  }

  /// Get the image by its ID
  ///
  /// **Returns**
  ///
  /// * The image with the given ID. The user is responsible to check if the image is valid. Returns null if no image with the given ID exists
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Img? getImgById(int id) {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'getImgById',
      args: id,
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return Img.init(resultString['result']);
  }

  /// Check if the SDK has initialized
  ///
  /// **Returns**
  ///
  /// * True if the SDK has been initialized, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static bool get isSDkInitialized {
    return GemKitPlatform.instance.isSdkInitialized();
  }

  // static set networkProvider(NetworkProvider networkProvider) {
  //   GemKitPlatform.instance
  //       .registerEventHandler(networkProvider.id, networkProvider);
  //   GemKitPlatform.instance.callObjectMethod(jsonEncode({
  //     'id': 0,
  //     'SdkSettings',
  //     'setNetworkProvider',
  //     'args': networkProvider.id
  //   );
  // }

  /// Set the default width, height and format for the image used in automatically returned images.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The size of the image
  /// * **IN** *format* The format of the image
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void setDefaultWidthHeightImageFormat(
    Size size, {
    ImageFileFormat format = ImageFileFormat.png,
  }) {
    objectMethod(
      0,
      'DefaultWidthHeightImageFormat',
      'set',
      args: <String, num>{
        'width': size.width,
        'height': size.height,
        'format': format.id,
      },
    );
  }

  /// Get the default width, height and format for the image used in automatically returned images.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static SizeAndFormat getDefaultWidthHeightImageFormat() {
    final OperationResult resultString = staticMethod(
      'DefaultWidthHeightImageFormat',
      'get',
    );

    return SizeAndFormat(
      size: Size(
        resultString['width'].toDouble(),
        resultString['height'].toDouble(),
      ),
      format: ImageFileFormatExtension.fromId(resultString['format']),
    );
  }

  /// Check if the current thread is the main thread.
  ///
  /// **Returns**
  ///
  /// * *true* if the current thread is the main thread
  /// * *false* if the current thread is not the main thread
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static bool get isCurrentThreadMainThread {
    final OperationResult resultString = staticMethod(
      'SdkSettings',
      'isCurrentThreadMainThread',
    );

    return resultString['result'];
  }
}

/// Enumerates the voice types
///
/// {@category Core}
enum VoiceType {
  /// Human voice.
  human,

  /// Computer voice.
  computer,
}

/// This class will not be documented,
///
/// @nodoc
extension VoiceTypeExtension on VoiceType {
  int get id {
    switch (this) {
      case VoiceType.human:
        return 0;
      case VoiceType.computer:
        return 1;
    }
  }

  static VoiceType fromId(int id) {
    switch (id) {
      case 0:
        return VoiceType.human;
      case 1:
        return VoiceType.computer;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Voice object
///
/// {@category Core}
class Voice extends GemAutoreleaseObject {
  // ignore: unused_element
  Voice._() : _pointerId = -1;

  @internal
  Voice.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Get the voice name.
  ///
  /// **Returns**
  ///
  /// * The voice name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    final OperationResult result = objectMethod(_pointerId, 'Voice', 'getName');
    return result['result'];
  }

  /// Get the voice language.
  ///
  /// **Returns**
  ///
  /// * The voice language
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Language get language {
    final OperationResult result = objectMethod(
      _pointerId,
      'Voice',
      'getLanguage',
    );
    return Language.fromJson(result['result']);
  }

  /// Get the voice file name.
  ///
  /// This contains the whole path to the voice file.
  ///
  /// **Returns**
  ///
  /// * The voice file name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get fileName {
    final OperationResult result = objectMethod(
      _pointerId,
      'Voice',
      'getFileName',
    );
    return result['result'];
  }

  /// Get the voice type.
  ///
  /// **Returns**
  ///
  /// * The voice type
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  VoiceType get type {
    final OperationResult result = objectMethod(_pointerId, 'Voice', 'getType');
    return VoiceTypeExtension.fromId(result['result']);
  }

  /// Get the voice id.
  ///
  /// **Returns**
  ///
  /// * The voice id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get id {
    final OperationResult result = objectMethod(_pointerId, 'Voice', 'getId');
    return result['result'];
  }
}
