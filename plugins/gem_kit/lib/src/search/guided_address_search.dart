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
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/core/task_handler.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Address level of detail.
///
/// {@category Places}
enum AddressDetailLevel {
  /// No address details available.
  noDetail,

  /// Country.
  country,

  /// State or province.
  state,

  /// County, which is an intermediate entity between a state and a city.
  county,

  /// Municipal district.
  district,

  /// Town or city.
  city,

  /// Settlement.
  settlement,

  /// Zip or postal code.
  postalCode,

  /// Street/road name.
  street,

  /// Street section subdivision.
  streetSection,

  /// Street lane subdivision.
  streetLane,

  /// Street alley subdivision.
  streetAlley,

  /// Address field denoting house number.
  houseNumber,

  /// Address field denoting a street in a crossing.
  crossing,
}

/// @nodoc
///
/// {@category Places}
extension AddressDetailLevelExtension on AddressDetailLevel {
  int get id {
    switch (this) {
      case AddressDetailLevel.noDetail:
        return 0;
      case AddressDetailLevel.country:
        return 1;
      case AddressDetailLevel.state:
        return 2;
      case AddressDetailLevel.county:
        return 3;
      case AddressDetailLevel.district:
        return 4;
      case AddressDetailLevel.city:
        return 5;
      case AddressDetailLevel.settlement:
        return 6;
      case AddressDetailLevel.postalCode:
        return 7;
      case AddressDetailLevel.street:
        return 8;
      case AddressDetailLevel.streetSection:
        return 9;
      case AddressDetailLevel.streetLane:
        return 10;
      case AddressDetailLevel.streetAlley:
        return 11;
      case AddressDetailLevel.houseNumber:
        return 12;
      case AddressDetailLevel.crossing:
        return 13;
    }
  }

  static AddressDetailLevel fromId(final int id) {
    switch (id) {
      case 0:
        return AddressDetailLevel.noDetail;
      case 1:
        return AddressDetailLevel.country;
      case 2:
        return AddressDetailLevel.state;
      case 3:
        return AddressDetailLevel.county;
      case 4:
        return AddressDetailLevel.district;
      case 5:
        return AddressDetailLevel.city;
      case 6:
        return AddressDetailLevel.settlement;
      case 7:
        return AddressDetailLevel.postalCode;
      case 8:
        return AddressDetailLevel.street;
      case 9:
        return AddressDetailLevel.streetSection;
      case 10:
        return AddressDetailLevel.streetLane;
      case 11:
        return AddressDetailLevel.streetAlley;
      case 12:
        return AddressDetailLevel.houseNumber;
      case 13:
        return AddressDetailLevel.crossing;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// GuidedAddressSearchPreferences object.
///
/// This class should not be instantiated directly. Instead, use the [GuidedAddressSearchService.preferences] getter to obtain an instance.
///
/// {@category Places}
class GuidedAddressSearchPreferences extends GemAutoreleaseObject {
  // ignore: unused_element
  GuidedAddressSearchPreferences._() : _pointerId = 0;

  @internal
  GuidedAddressSearchPreferences.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(id);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Test if fuzzy search results are allowed.
  ///
  /// **Returns**
  ///
  /// * True if fuzzy search results are allowed, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get allowFuzzyResults {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'GuidedAddressSearchPreferences',
      'getAllowFuzzyResults',
    );

    return resultString['result'];
  }

  /// Enable or disable the inclusion of fuzzy search results.
  ///
  /// **Note**
  ///
  /// * Default is true.
  ///
  /// **Parameters**
  ///
  /// * **IN** *bAllow*	True to allow fuzzy search results
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set allowFuzzyResults(final bool bAllow) {
    objectMethod(
      _pointerId,
      'GuidedAddressSearchPreferences',
      'setAllowFuzzyResults',
      args: bAllow,
    );
  }

  /// Get the automatic level skip flag.
  ///
  /// **Returns**
  ///
  /// * True if the engine will automatically skip levels, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get automaticLevelSkip {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'GuidedAddressSearchPreferences',
      'getAutomaticLevelSkip',
    );

    return resultString['result'];
  }

  /// Set the flag for automatic level skip
  ///
  /// When there is only one result at a specific level and there is only one possible next level to search then the engine will automatically skip that level if this flag is set to true.
  ///
  /// **Parameters**
  ///
  /// * **IN** *enableAutomaticLevelSkip*	True for automatic level skip
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set automaticLevelSkip(final bool enableAutomaticLevelSkip) {
    objectMethod(
      _pointerId,
      'GuidedAddressSearchPreferences',
      'setAutomaticLevelSkip',
      args: enableAutomaticLevelSkip,
    );
  }

  /// Get the maximum number of matches.
  ///
  /// **Note**
  ///
  /// * Default is 40.
  ///
  /// **Returns**
  ///
  /// * Maximum number of matches
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get maximumMatches {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'GuidedAddressSearchPreferences',
      'getMaximumMatches',
    );

    return resultString['result'];
  }

  /// Set the maximum number of matches.
  ///
  /// **Parameters**
  ///
  /// * **IN** *matches*	Maximum number of matches
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set maximumMatches(final int matches) {
    objectMethod(
      _pointerId,
      'GuidedAddressSearchPreferences',
      'setMaximumMatches',
      args: matches,
    );
  }

  /// Set the flag for onboard search
  ///
  /// If this flag is true then the search will be done using only local data. By default it is false.
  ///
  /// **Parameters**
  ///
  /// * **IN** *searchOnlyOnboard* Flag for onboard search.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set searchOnlyOnboard(final bool searchOnlyOnboard) {
    objectMethod(
      _pointerId,
      'GuidedAddressSearchPreferences',
      'setSearchOnlyOnboard',
      args: searchOnlyOnboard,
    );
  }

  /// Get the flag for onboard search.
  ///
  /// **Returns**
  ///
  /// * True if the search is done using only onboard data, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get searchOnlyOnboard {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'GuidedAddressSearchPreferences',
      'getSearchOnlyOnboard',
    );

    return resultString['result'];
  }

  /// Reset all preferences to their default values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void reset() {
    objectMethod(_pointerId, 'GuidedAddressSearchPreferences', 'reset');
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, Object>{
          'class': 'GuidedAddressSearchPreferences',
          'id': _pointerId,
        }),
      );
}

/// Class representing a guided address search service session.
///
/// {@category Places}
abstract class GuidedAddressSearchService {
  static GuidedAddressSearchPreferences? _prefs;

  /// Search for more details starting at the selected parent landmark.
  ///
  /// Starting at the selected parent landmark the engine will search the required detail level using the provided filter.
  ///
  /// **Parameters**
  ///
  /// * **IN** *parent*	The starting point for the search. If it is default then the only detail level that can be searched is [AddressDetailLevel.country].
  /// If the landmark address detail level is [AddressDetailLevel.street] then the next details that can be searched may be [AddressDetailLevel.houseNumber] or [AddressDetailLevel.crossing] (for example).
  /// It is also allowed to 'decrease' the search level and use [AddressDetailLevel.city] (for example).
  /// * **IN** *filter*	The filter to use when searching for the required detail level. If it is empty then all items are returned (limited to the maximum number of matches from preferences).
  /// * **IN** *detailLevel*	The address detail level to search.
  /// * **IN** *onCompleteCallback* Will be invoked when the search operation is completed, providing the search results and an error code.
  ///
  /// **Returns**
  ///
  /// * Associated [TaskHandler] for this operation if the search can be started otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler? search(
    final String filter,
    final Landmark parent,
    final AddressDetailLevel detailLevel,
    final void Function(GemError err, List<Landmark> landmarks)
        onCompleteCallback,
  ) {
    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
    final LandmarkList results = LandmarkList();

    progListener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);

      if (err == GemError.success.code || err == GemError.reducedResult.code) {
        onCompleteCallback(GemErrorExtension.fromCode(err), results.toList());
      } else {
        onCompleteCallback(GemErrorExtension.fromCode(err), <Landmark>[]);
      }
    });

    final OperationResult resultString = staticMethod(
      'GuidedAddressSearchService',
      'search',
      args: <String, dynamic>{
        'results': results.pointerId,
        'parent': parent.pointerId,
        'filter': filter,
        'detailToSearch': detailLevel.id,
        'progress': progListener.id,
      },
    );

    final int errorCode = resultString['result'];

    if (errorCode != GemError.success.code) {
      onCompleteCallback(GemErrorExtension.fromCode(errorCode), <Landmark>[]);
      return null;
    }

    return TaskHandlerImpl(progListener.id);
  }

  /// Search for countries using a query string.
  ///
  /// This method performs a top-level address search, restricted to country-level results.
  ///
  /// **Parameters**
  ///
  /// * **IN** *filter* The filter string to apply to the country names. If empty, all countries are returned (subject to engine limits).
  /// * **IN** *onCompleteCallback* Will be invoked when the search operation is completed, providing the search results and an error code.
  ///
  /// **Returns**
  ///
  /// * Associated [TaskHandler] for this operation if the search can be started; otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initiate.
  static TaskHandler? searchCountries(
    final String filter,
    final void Function(GemError err, List<Landmark> landmarks)
        onCompleteCallback,
  ) {
    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
    final LandmarkList results = LandmarkList();
    final Landmark emptyParent = Landmark();

    progListener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);

      if (err == GemError.success.code || err == GemError.reducedResult.code) {
        onCompleteCallback(GemErrorExtension.fromCode(err), results.toList());
      } else {
        onCompleteCallback(GemErrorExtension.fromCode(err), <Landmark>[]);
      }
    });

    final OperationResult resultString = staticMethod(
      'GuidedAddressSearchService',
      'search',
      args: <String, dynamic>{
        'results': results.pointerId,
        'parent': emptyParent.pointerId,
        'filter': filter,
        'detailToSearch': AddressDetailLevel.country.id,
        'progress': progListener.id,
      },
    );

    final int errorCode = resultString['result'];

    if (errorCode != GemError.success.code) {
      onCompleteCallback(GemErrorExtension.fromCode(errorCode), <Landmark>[]);
      return null;
    }

    return TaskHandlerImpl(progListener.id);
  }

  /// Cancel currently active search command.
  ///
  /// **Parameters**
  ///
  /// * **IN** *progress*	Progress listener for the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void cancelSearch(final TaskHandler taskHandler) {
    taskHandler as TaskHandlerImpl;

    objectMethod(
      0,
      'GuidedAddressSearchService',
      'cancelSearch',
      args: taskHandler.id,
    );
  }

  /// Get the address detail level for a landmark
  ///
  /// When there is only one result at a specific level and there is only one possible next level to search then the engine will automatically skip that level if this flag is set to true.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmark*	The landmark for which to get the address detail level.
  ///
  /// **Returns**
  ///
  /// * [AddressDetailLevel.noDetail] If landmark is not obtained via a previous call to [GuidedAddressSearchService.search] method.
  ///
  /// * Address detail level for the landmark in range of [AddressDetailLevel].
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static AddressDetailLevel getAddressDetailLevel(final Landmark landmark) {
    final OperationResult resultString = objectMethod(
      0,
      'GuidedAddressSearchService',
      'getAddressDetailLevel',
      args: landmark.pointerId,
    );

    return AddressDetailLevelExtension.fromId(resultString['result']);
  }

  /// Get the country level item for specific country iso code that can be used by guided address search.
  ///
  /// **Parameters**
  ///
  /// * **IN** *countryIsoCode*	The country iso code for which to get the country level item.
  ///
  /// **Returns**
  ///
  /// * Valid [Landmark] if the countryIsoCode is valid.
  /// * Null if the countryIsoCode is not valid
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Landmark? getCountryLevelItem(final String countryIsoCode) {
    final OperationResult resultString = objectMethod(
      0,
      'GuidedAddressSearchService',
      'getCountryLevelItem',
      args: countryIsoCode,
    );

    final Landmark result = Landmark.init(resultString['result']);

    if (result.name.isEmpty) {
      return null;
    }
    return result;
  }

  /// Get the list of next possible address detail levels that can be searched for a landmark.
  ///
  /// It is country dependent.
  ///
  /// For example, for a street it may be possible to get [AddressDetailLevel.crossing] and [AddressDetailLevel.houseNumber] in some countries but in others to get [AddressDetailLevel.streetSection]
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmark*	The landmark for which to get the next possible address detail levels to search. If the landmark is default only [AddressDetailLevel.country] will be in the list. If there are no more address detail levels available then an empty list is returned.
  ///
  /// **Returns**
  ///
  /// * [List] next possible address detail levels. Items of the list are in range of [AddressDetailLevel] enum.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static List<AddressDetailLevel> getNextAddressDetailLevel(
    final Landmark landmark,
  ) {
    final OperationResult resultString = objectMethod(
      0,
      'GuidedAddressSearchService',
      'getNextAddressDetailLevel',
      args: landmark.pointerId,
    );

    final List<int> retList = resultString['result'].whereType<int>().toList();
    return retList
        .map((final int id) => AddressDetailLevelExtension.fromId(id))
        .toList();
  }

  /// Get access to [GuidedAddressSearchPreferences] (for this session).
  ///
  /// **Returns**
  ///
  /// * [GuidedAddressSearchPreferences] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static GuidedAddressSearchPreferences get preferences {
    if (_prefs == null) {
      _retrievePreferences();
    } else {
      final bool isObjectAlive = GemKitPlatform.instance.isObjectAlive(
        _prefs!.pointerId,
      );
      if (!isObjectAlive) {
        _retrievePreferences();
      }
    }
    return _prefs!;
  }

  static void _retrievePreferences() {
    final OperationResult resultString = objectMethod(
      0,
      'GuidedAddressSearchService',
      'preferences',
    );

    _prefs = GuidedAddressSearchPreferences.init(resultString['result']);
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
      'GuidedAddressSearchService',
      'getTransferStatistics',
    );

    return TransferStatistics.init(resultString['result']);
  }
}
