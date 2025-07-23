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

import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/landmarkstore/landmark_store_collection.dart';
import 'package:gem_kit/src/map/overlays.dart';
import 'package:meta/meta.dart';

/// Search preferences
///
/// {@category Places}
class SearchPreferences extends GemAutoreleaseObject {
  factory SearchPreferences({
    final bool allowFuzzyResults = true,
    final bool estimateMissingHouseNumbers = true,
    final bool exactMatch = false,
    final int maxMatches = 40,
    final bool searchAddresses = true,
    final bool searchMapPOIs = true,
    final bool searchOnlyOnboard = false,
    final int thresholdDistance = 2147483647,
    final bool easyAccessOnlyResults = false,
  }) {
    final SearchPreferences result = SearchPreferences._create();
    result.allowFuzzyResults = allowFuzzyResults;
    result.estimateMissingHouseNumbers = estimateMissingHouseNumbers;
    result.exactMatch = exactMatch;
    result.maxMatches = maxMatches;
    result.searchAddresses = searchAddresses;
    result.searchMapPOIs = searchMapPOIs;
    result.searchOnlyOnboard = searchOnlyOnboard;
    result.thresholdDistance = thresholdDistance;
    result.easyAccessOnlyResults = easyAccessOnlyResults;
    return result;
  }

  @internal
  SearchPreferences.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Test if fuzzy search results are allowed
  ///
  /// Default is true
  ///
  /// **Returns**
  ///
  /// * True if fuzzy search results are allowed, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get allowFuzzyResults {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SearchPreferences',
      'getallowfuzzyresults',
    );

    return resultString['result'];
  }

  /// Enable or disable the inclusion of fuzzy search results
  ///
  /// Default is true
  ///
  /// **Parameters**
  ///
  /// * **IN** *value*	True if fuzzy search results are allowed, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  set allowFuzzyResults(final bool value) {
    objectMethod(
      _pointerId,
      'SearchPreferences',
      'setallowfuzzyresults',
      args: value,
    );
  }

  /// Test if estimating house numbers not present in map data is allowed
  ///
  /// Default is true
  ///
  /// **Returns**
  ///
  /// * True if estimating house numbers not present in map data is allowed, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get estimateMissingHouseNumbers {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SearchPreferences',
      'getestimatemissinghousenumbers',
    );

    return resultString['result'];
  }

  /// Enable or disable the estimation of house number results not found in map data
  ///
  /// Default is true
  ///
  /// **Parameters**
  ///
  /// * **IN** *value*	True if estimating house numbers not present in map data is allowed, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  set estimateMissingHouseNumbers(final bool value) {
    objectMethod(
      _pointerId,
      'SearchPreferences',
      'setestimatemissinghousenumbers',
      args: value,
    );
  }

  /// Test if exact match is used.
  ///
  /// Default is false.
  ///
  /// **Returns**
  ///
  /// * True if exact match is used, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get exactMatch {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SearchPreferences',
      'getexactmatch',
    );

    return resultString['result'];
  }

  /// Set/unset the exact match.
  ///
  /// If set to true, only an exact match of free text search token is returned as result
  ///
  /// Default is false.
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* True if exact match is used, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  set exactMatch(final bool value) {
    objectMethod(_pointerId, 'SearchPreferences', 'setexactmatch', args: value);
  }

  /// Get the max number of matches.
  ///
  /// Default is 40
  ///
  /// **Returns**
  ///
  /// * Max number of matches
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get maxMatches {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SearchPreferences',
      'getmaxmatches',
    );

    return resultString['result'];
  }

  /// Set the max number of matches.
  ///
  /// Default is 40
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* Max number of matches
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  set maxMatches(final int value) {
    objectMethod(_pointerId, 'SearchPreferences', 'setmaxmatches', args: value);
  }

  /// Check if search through addresses is enabled.
  ///
  /// Default is true.
  ///
  /// **Returns**
  ///
  /// * True if search through addresses is enabled, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get searchAddresses {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SearchPreferences',
      'getsearchaddresses',
    );

    return resultString['result'];
  }

  /// Enable or disable search through addresses.
  ///
  /// Default is true
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* True if search through addresses is enabled, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  set searchAddresses(final bool value) {
    objectMethod(
      _pointerId,
      'SearchPreferences',
      'setsearchaddresses',
      args: value,
    );
  }

  /// Check if search through addresses is enabled.
  ///
  /// Default is true
  ///
  /// **Returns**
  ///
  /// * True if search through map POIs is enabled, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get searchMapPOIs {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SearchPreferences',
      'getsearchmappois',
    );

    return resultString['result'];
  }

  /// Enable or disable search through map POIs.
  ///
  /// Default is true
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* True if search through map POIs is enabled, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  set searchMapPOIs(final bool value) {
    objectMethod(
      _pointerId,
      'SearchPreferences',
      'setsearchmappois',
      args: value,
    );
  }

  /// Get the flag for onboard search.
  ///
  /// Default is false
  ///
  /// **Returns**
  ///
  /// * True if the search will be done using only onboard data, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get searchOnlyOnboard {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SearchPreferences',
      'getsearchonlyonboard',
    );

    return resultString['result'];
  }

  /// Set the flag for onboard search.
  ///
  /// If this flag is true then the search will be done using only onboard data.
  /// Default is false
  set searchOnlyOnboard(final bool value) {
    objectMethod(
      _pointerId,
      'SearchPreferences',
      'setsearchonlyonboard',
      args: value,
    );
  }

  /// Get the threshold distance for the request.
  ///
  /// Default is the maximum value of int
  ///
  /// **Returns**
  ///
  /// * The threshold distance for the request
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get thresholdDistance {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SearchPreferences',
      'getthresholddistance',
    );

    return resultString['result'];
  }

  /// Set the threshold distance for the operation.
  ///
  /// This may be used to control the reverse geocoding and search along route lookup area.
  /// When searching along route, the threshold is the result maximum distance from the target route
  /// When searching around position, the threshold is the result maximum distance from the reference point
  /// Default is the maximum value of int
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* The threshold distance for the request
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  set thresholdDistance(final int value) {
    objectMethod(
      _pointerId,
      'SearchPreferences',
      'setthresholddistance',
      args: value,
    );
  }

  /// Test if easy access filter is enabled
  ///
  /// Default is false
  ///
  /// **Returns**
  ///
  /// * True if easy access filter is enabled, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get easyAccessOnlyResults {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SearchPreferences',
      'geteasyaccessonlyresults',
    );

    return resultString['result'];
  }

  /// Enable or disable the easy access filter for results
  ///
  /// Default is false
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* True if easy access filter is enabled, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  set easyAccessOnlyResults(final bool value) {
    objectMethod(
      _pointerId,
      'SearchPreferences',
      'seteasyaccessonlyresults',
      args: value,
    );
  }

  /// Get access to the search target landmark stores collection
  ///
  /// **Returns**
  ///
  /// * The landmark stores collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  LandmarkStoreCollection get landmarks {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SearchPreferences',
      'landmarks',
    );

    return LandmarkStoreCollection.init(resultString['result']);
  }

  /// Get access to the search target overlays collection
  ///
  /// **Returns**
  ///
  /// * The overlays collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  OverlayMutableCollection get overlays {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SearchPreferences',
      'overlays',
    );

    return OverlayMutableCollection.init(resultString['result']);
  }

  static SearchPreferences _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'SearchPreferences'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return SearchPreferences.init(decodedVal['result']);
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, Object>{
          'class': 'SearchPreferences',
          'id': _pointerId,
        }),
      );
}
