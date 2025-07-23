// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'dart:core';
import 'dart:typed_data';
import 'dart:ui';

import 'package:gem_kit/src/core/coordinates.dart';
import 'package:gem_kit/src/core/geographic_area.dart';
import 'package:gem_kit/src/core/images.dart';
import 'package:gem_kit/src/core/types.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

/// Map coverage
///
/// {@category Maps & 3D Scene}
enum MapCoverage {
  /// Data covered by an offline map available on the device. No connection required.
  coverageOffline,

  /// Data covered by the online cache available on the device. No connection required.
  ///
  /// Data is volatile and may be erased after a cache cleanup operation
  coverageOnlineTile,

  /// Data coverage exists, but it is not available on the device. Server connection required.
  coverageOnlineNoData,

  /// There is no map coverage available on the device, and it is not possible to determine if coverage is available on the server.
  coverageUnknown,
}

/// This class will not be documented
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension MapCoverageExtension on MapCoverage {
  int get id {
    switch (this) {
      case MapCoverage.coverageOffline:
        return 0;
      case MapCoverage.coverageOnlineTile:
        return 1;
      case MapCoverage.coverageOnlineNoData:
        return 2;
      case MapCoverage.coverageUnknown:
        return 3;
    }
  }

  static MapCoverage fromId(final int id) {
    switch (id) {
      case 0:
        return MapCoverage.coverageOffline;
      case 1:
        return MapCoverage.coverageOnlineTile;
      case 2:
        return MapCoverage.coverageOnlineNoData;
      case 3:
        return MapCoverage.coverageUnknown;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Map providers enumeration.
///
/// {@category Maps & 3D Scene}
enum MapProviderId {
  route66,
  navteq,
  teleatlas,
  nav2,
  navturk,
  navuri,
  transnavicom,
  suncart,
  mapmyindia,
  sensis,
  micropartes,
  genesys,
  osm,
  kingway,
  vietmap,
  last,
}

/// This class will not be documented
///
/// @nodoc
extension MapProviderIdExtension on MapProviderId {
  int get id {
    switch (this) {
      case MapProviderId.route66:
        return 0;
      case MapProviderId.navteq:
        return 1;
      case MapProviderId.teleatlas:
        return 2;
      case MapProviderId.nav2:
        return 3;
      case MapProviderId.navturk:
        return 4;
      case MapProviderId.navuri:
        return 5;
      case MapProviderId.transnavicom:
        return 6;
      case MapProviderId.suncart:
        return 7;
      case MapProviderId.mapmyindia:
        return 8;
      case MapProviderId.sensis:
        return 9;
      case MapProviderId.micropartes:
        return 10;
      case MapProviderId.genesys:
        return 11;
      case MapProviderId.osm:
        return 12;
      case MapProviderId.kingway:
        return 13;
      case MapProviderId.vietmap:
        return 14;
      case MapProviderId.last:
        return 15;
    }
  }

  static MapProviderId fromId(final int id) {
    switch (id) {
      case 0:
        return MapProviderId.route66;
      case 1:
        return MapProviderId.navteq;
      case 2:
        return MapProviderId.teleatlas;
      case 3:
        return MapProviderId.nav2;
      case 4:
        return MapProviderId.navturk;
      case 5:
        return MapProviderId.navuri;
      case 6:
        return MapProviderId.transnavicom;
      case 7:
        return MapProviderId.suncart;
      case 8:
        return MapProviderId.mapmyindia;
      case 9:
        return MapProviderId.sensis;
      case 10:
        return MapProviderId.micropartes;
      case 11:
        return MapProviderId.genesys;
      case 12:
        return MapProviderId.osm;
      case 13:
        return MapProviderId.kingway;
      case 14:
        return MapProviderId.vietmap;
      case 15:
        return MapProviderId.last;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Extended Map Capability
///
/// {@category Maps & 3D Scene}
enum MapExtendedCapability {
  /// Avoid unpaved roads.
  avoidUnpavedRoads,

  /// Avoid carpool lanes.
  avoidCarpoolLanes,

  /// Elevation profile and flags.
  elvProfileAndFlags,

  /// Search developments.
  searchDevelopments,

  /// 64 Bit search offsets.
  searchOffsets64Bit,

  /// Ordered admin index.
  orderedAdminIndex,

  /// Alternative admin index.
  alternativeAdminIndex,

  /// Search index split into multiple sections.
  splitIndexData,

  /// Compatibility flag for using Sphere maps in a commercial app.
  upperLevelData,

  /// Extended routing speeds, extra info fields in nodes, changes to map header format.
  speedsExtraAndIncremental,

  /// Header contains only one map level & tile-ISO resource is only for the lowest map level.
  trimmedHeader,

  /// Sharper geometry & changes to encoding for buildings.
  highPrecisionBuildings,

  /// Links modified to support the storage of more properties and flags.
  extendedRoutingAttributes,
}

/// This class will not be documented
///
/// @nodoc
extension MapExtendedCapabilityExtension on MapExtendedCapability {
  int get id {
    switch (this) {
      case MapExtendedCapability.avoidUnpavedRoads:
        return 1;
      case MapExtendedCapability.avoidCarpoolLanes:
        return 2;
      case MapExtendedCapability.elvProfileAndFlags:
        return 4;
      case MapExtendedCapability.searchDevelopments:
        return 8;
      case MapExtendedCapability.searchOffsets64Bit:
        return 16;
      case MapExtendedCapability.orderedAdminIndex:
        return 32;
      case MapExtendedCapability.alternativeAdminIndex:
        return 64;
      case MapExtendedCapability.splitIndexData:
        return 128;
      case MapExtendedCapability.upperLevelData:
        return 256;
      case MapExtendedCapability.speedsExtraAndIncremental:
        return 512;
      case MapExtendedCapability.trimmedHeader:
        return 1024;
      case MapExtendedCapability.highPrecisionBuildings:
        return 2048;
      case MapExtendedCapability.extendedRoutingAttributes:
        return 4096;
    }
  }

  static MapExtendedCapability fromId(final int id) {
    switch (id) {
      case 1:
        return MapExtendedCapability.avoidUnpavedRoads;
      case 2:
        return MapExtendedCapability.avoidCarpoolLanes;
      case 4:
        return MapExtendedCapability.elvProfileAndFlags;
      case 8:
        return MapExtendedCapability.searchDevelopments;
      case 16:
        return MapExtendedCapability.searchOffsets64Bit;
      case 32:
        return MapExtendedCapability.orderedAdminIndex;
      case 64:
        return MapExtendedCapability.alternativeAdminIndex;
      case 128:
        return MapExtendedCapability.splitIndexData;
      case 256:
        return MapExtendedCapability.upperLevelData;
      case 512:
        return MapExtendedCapability.speedsExtraAndIncremental;
      case 1024:
        return MapExtendedCapability.trimmedHeader;
      case 2048:
        return MapExtendedCapability.highPrecisionBuildings;
      case 4096:
        return MapExtendedCapability.extendedRoutingAttributes;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Map details class
///
/// {@category Maps & 3D Scene}
abstract class MapDetails {
  /// Get the map coverage for the region specified by WGS84 coordinates.
  ///
  /// This function checks the map coverage status using only the information available on the device. No server connection is performed. This check is performed quickly.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The list of coordinates
  ///
  /// **Returns**
  ///
  /// * [MapCoverage.coverageOffline] - Entire map is available on the device.
  /// * [MapCoverage.coverageOnlineNoData] - Map is available but not all tiles are on the device.
  /// * [MapCoverage.coverageOnlineTile] - Data covered by the online cache available on the device. No connection required.
  /// * [MapCoverage.coverageUnknown] - No map coverage available on device and cannot determine if there exists content on the server.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static MapCoverage getMapCoverage(final List<Coordinates> coords) {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getMapCoverage',
      args: coords,
    );

    return MapCoverageExtension.fromId(resultString['result']);
  }

  /// Get the map coverage for the country specified by ISO 3166-1 alpha-3 country code.
  ///
  /// This function checks the map coverage status using only the information available on the device. No server connection is performed. This check is performed fast
  ///
  /// **Parameters**
  ///
  /// * **IN** *code* ISO 3166-1 alpha-3 country code
  ///
  /// **Returns**
  ///
  /// * [MapCoverage.coverageOffline] - Entire country map is available on the device.
  /// * [MapCoverage.coverageOnlineNoData] - Country map is available but not all tiles are on the device.
  /// * [MapCoverage.coverageOnlineTile] - Data covered by the online cache available on the device. No connection required.
  /// * [MapCoverage.coverageUnknown] - No map coverage available on device and cannot determine if there exists content on the server.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static MapCoverage getCountryMapCoverage(final String code) {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getCountryMapCoverage',
      args: code,
    );

    return MapCoverageExtension.fromId(resultString['result']);
  }

  /// Get the country name for the specified coordinates (WGS).
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The coordinates
  ///
  /// **Returns**
  ///
  /// * Country name as string
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static String getCountryName(final Coordinates coords) {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getCountryName',
      args: coords,
    );

    return resultString['result'];
  }

  /// Get the country name for the specified index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The country index
  ///
  /// **Returns**
  ///
  /// * Country name as string
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static String getCountryNameByIndex(final int index) {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getCountryNameByIndex',
      args: index,
    );

    return resultString['result'];
  }

  /// Get the country name for the specified ISO code.
  ///
  /// **Parameters**
  ///
  /// * **IN** *code* The country code
  ///
  /// **Returns**
  ///
  /// * Country name as string
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static String getCountryNameByISO(final String code) {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getCountryNameByISO',
      args: code,
    );

    return resultString['result'];
  }

  /// Get the language codes for the specified index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The country index
  ///
  /// **Returns**
  ///
  /// * Language codes as a [List] of [String]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static List<String> getLanguageCodeByIndex(final int index) {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getLanguageCodesByIndex',
      args: index,
    );

    return (resultString['result'] as List<dynamic>).cast<String>();
  }

  /// Get the language codes for the specified coordinates.
  ///
  /// Empty list means no coordinates match.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The coordinates
  ///
  /// **Returns**
  ///
  /// * Language codes as a [List] of [String]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static List<String> getLanguageCode(final Coordinates coords) {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getLanguageCodes',
      args: coords,
    );

    return (resultString['result'] as List<dynamic>).cast<String>();
  }

  /// Get the ISO 3166-1 alpha-3 country code for the specified WGS.
  ///
  /// Empty string means no country. See: http://en.wikipedia.org/wiki/ISO_3166-1 for the list of codes.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The coordinates
  ///
  /// **Returns**
  ///
  /// * The country code as [String]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static String getCountryCode(final Coordinates coords) {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getCountryCode',
      args: coords,
    );

    return resultString['result'];
  }

  /// Get the ISO 3166-1 alpha-3 country code for the specified index.
  ///
  /// Empty string means no country. See: http://en.wikipedia.org/wiki/ISO_3166-1 for the list of codes.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The country index
  ///
  /// **Returns**
  ///
  /// * The country code as [String]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static String getCountryCodeByIndex(final int index) {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getCountryCodeByIndex',
      args: index,
    );

    return resultString['result'];
  }

  /// Get the country flag for the specified index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The country index
  /// * **IN** *size* [Size] of the image
  /// * **IN** *format* [ImageFileFormat] of the image.
  ///
  /// **Returns**
  ///
  /// * Country flag image
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Uint8List? getCountryFlagByIndex({
    required final int index,
    final Size? size,
    final ImageFileFormat? format,
  }) {
    return GemKitPlatform.instance.callGetImage(
      0,
      'MapDetailsgetCountryIcon',
      size?.width.toInt() ?? -1,
      size?.height.toInt() ?? -1,
      format?.id ?? -1,
      arg: index.toString(),
    );
  }

  /// Get the country flag for the specified index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The country index
  ///
  /// **Returns**
  ///
  /// * Country flag image if the index is valid, null othersise. The user is responsible to check if the image is valid
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Img? getCountryFlagImgByIndex({required final int index}) {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getCountryFlagImgByIndex',
      args: index,
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return Img.init(resultString['result']);
  }

  /// Get the country flag for the isoCode.
  ///
  /// **Parameters**
  ///
  /// * **IN** *countryCode* ISO 3166-1 alpha-3 country code
  /// * **IN** *size* [Size] of the image
  /// * **IN** *format* [ImageFileFormat] of the image.
  ///
  /// **Returns**
  ///
  /// * Country flag image
  ///
  /// If invalid input, a default question mark image will be returned
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Uint8List? getCountryFlag({
    required final String countryCode,
    final Size? size,
    final ImageFileFormat? format,
  }) {
    return GemKitPlatform.instance.callGetImage(
      0,
      'MapDetailsgetCountryFlag',
      size?.width.toInt() ?? -1,
      size?.height.toInt() ?? -1,
      format?.id ?? -1,
      arg: countryCode,
    );
  }

  /// Get the country flag for the specified country.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The country ISO 3166-1 alpha-3 code
  ///
  /// **Returns**
  ///
  /// * Country flag image if the code is valid, null othersise. The user is responsible to check if the image is valid.
  ///
  /// If invalid input, a default question mark image will be returned
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Img? getCountryFlagImg(final String countryCode) {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getCountryFlagImg',
      args: countryCode,
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return Img.init(resultString['result']);
  }

  /// Get the country bounding rectangle for the isoCode.
  ///
  /// **Parameters**
  ///
  /// * **IN** *code* ISO 3166-1 alpha-3 country code.
  ///
  /// **Returns**
  ///
  /// * Country bounding rectangle as [RectangleGeographicArea]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static RectangleGeographicArea getCountryBoundingRectangle(
    final String code,
  ) {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getCountryBoundingRectangle',
      args: code,
    );

    return RectangleGeographicArea.fromJson(resultString['result']);
  }

  /// Get the sunrise & sunset for the specified reference date and WGS position.
  ///
  /// If no time is provided then the device time is used.
  ///
  /// The sunset may happen next day or even later (close to poles). Returned value is UTC.
  /// The sunrise may happen in the same day or before (close to poles). Returned value is UTC.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* WGS Coordinates as [Coordinates]
  /// * **IN** *time* Reference time as [DateTime]
  ///
  /// **Returns**
  ///
  /// * A record with sunrise and sunset, first is sunrise, second is sunset, both as [DateTime]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static (DateTime, DateTime) getSunriseAndSunset(
    final Coordinates coords,
    final DateTime time,
  ) {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getSunriseAndSunset',
      args: <String, Object>{
        'coords': coords,
        'refTime': time.millisecondsSinceEpoch,
      },
    );

    final Map<String, dynamic> result =
        resultString['result'] as Map<String, dynamic>;
    final int first = result['first'];
    final int second = result['second'];

    return (
      DateTime.fromMillisecondsSinceEpoch(first, isUtc: true),
      DateTime.fromMillisecondsSinceEpoch(second, isUtc: true),
    );
  }

  /// Check if it is night at the specified coordinates and time.
  ///
  /// If no time is provided then the device time is used.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* WGS Coordinates as [Coordinates]
  /// * **IN** *time* Reference time as [DateTime]
  ///
  /// **Returns**
  ///
  /// * True if it is night at the specified coordinated and time, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static bool isNight(final Coordinates coords, final DateTime time) {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'isNight',
      args: <String, Object>{
        'coords': coords,
        'refTime': time.millisecondsSinceEpoch,
      },
    );

    return resultString['result'];
  }

  /// Get the map provider IDs list.
  ///
  /// The function returns the list of map provider IDs. It may be empty if no map data is available on the device.
  ///
  /// **Returns**
  ///
  /// * The map provider IDs list. The values will be in range of [MapProviderId].
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static List<int> getMapProviderIds() {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getMapProviderIds',
    );

    return (resultString['result'] as List<dynamic>).cast<int>();
  }

  /// Get the name of the specified provider.
  ///
  /// **Parameters**
  ///
  /// * **IN** *id* The provider ID as [MapProviderId]
  ///
  /// **Returns**
  ///
  /// * The name of the specified provider.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static String getProviderName(final MapProviderId id) {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getProviderName',
      args: id.id,
    );

    return resultString['result'];
  }

  /// Get the copyright statement for the specified provider.
  ///
  /// **Parameters**
  ///
  /// * **IN** *id* The provider ID as [MapProviderId]
  ///
  /// **Returns**
  ///
  /// * Get the provider's copyright statement.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static String getProviderSentence(final MapProviderId id) {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getProviderSentence',
      args: id.id,
    );

    return resultString['result'];
  }

  /// Get map extended capabilities.
  ///
  /// Check [MapExtendedCapability] for possible return values.
  ///
  /// **Returns**
  ///
  /// * Map extended capabilities as int.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Set<MapExtendedCapability> getMapExtendedCapabilities() {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getMapExtendedCapabilities',
    );

    final int res = resultString['result'];
    final Set<MapExtendedCapability> result = <MapExtendedCapability>{};

    for (final MapExtendedCapability mode in MapExtendedCapability.values) {
      if (mode.id & res != 0) {
        result.add(mode);
      }
    }
    return result;
  }

  /// Get country data count.
  ///
  /// **Returns**
  ///
  /// *Country data count.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static int getCountryDataCount() {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getCountryDataCount',
    );

    return resultString['result'];
  }

  /// Get the map version.
  ///
  /// **Returns**
  ///
  /// * The map version
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Version get mapVersion {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getMapVersion',
    );

    return Version.fromJson(resultString['result']);
  }

  /// Get latest online map version.
  ///
  /// **Returns**
  ///
  /// * Latest online map version
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Version get latestOnlineMapVersion {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getLatestOnlineMapVersion',
    );

    return Version.fromJson(resultString['result']);
  }

  /// Get map release date
  ///
  /// **Returns**
  ///
  /// * Map release date
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static DateTime getMapReleaseInfo() {
    final OperationResult resultString = objectMethod(
      0,
      'MapDetails',
      'getMapReleaseInfo',
    );

    final Map<String, dynamic> result =
        resultString['result'] as Map<String, dynamic>;
    final int first = result['first'];

    return DateTime.fromMillisecondsSinceEpoch(first, isUtc: true);
  }
}
