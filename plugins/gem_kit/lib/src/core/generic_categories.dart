// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'package:gem_kit/src/core/generic_categories_ids.dart';
import 'package:gem_kit/src/core/landmark_category.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

/// Generic categories class
///
/// {@category Core}
abstract class GenericCategories {
  /// Get generic categories list.
  ///
  /// **Returns**
  ///
  /// * The list of generic categories
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static List<LandmarkCategory> get categories {
    final OperationResult resultString = staticMethod(
      'GenericCategories',
      'getCategories',
    );

    if (resultString['result'] == -1) {
      return <LandmarkCategory>[];
    }

    return LandmarkCategoryList.init(resultString['result']).toList();
  }

  /// Get generic category by id.
  ///
  /// See the [GenericCategoriesId] enum for some possible values.
  ///
  /// **Parameters**
  ///
  /// * **IN** *id*	Generic category id, see [GenericCategoriesId].id.
  ///
  /// **Returns**
  ///
  /// * The generic category if found, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static LandmarkCategory? getCategory(final int id) {
    final OperationResult resultString = staticMethod(
      'GenericCategories',
      'getCategory',
      args: id,
    );

    if (resultString['result'] == -1) {
      return null;
    }
    return LandmarkCategory.init(resultString['result']);
  }

  /// Get the generic category for the given POI category retrieved via the [getPoiCategories] method or from the landmarks retrieved via the search methods.
  ///
  /// **Parameters**
  ///
  /// * **IN** *poiCategory* POI category
  ///
  /// **Returns**
  ///
  /// * Generic category id, see [GenericCategoriesId].id.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static LandmarkCategory? getGenericCategory(final int poiCategory) {
    final OperationResult resultString = staticMethod(
      'GenericCategories',
      'getGenericCategory',
      args: poiCategory,
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return LandmarkCategory.init(resultString['result']);
  }

  /// Get the generic categories landmark store id.
  ///
  /// **Returns**
  ///
  /// * The landmark store id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static int get landmarkStoreId {
    final OperationResult resultString = staticMethod(
      'GenericCategories',
      'getLandmarkStoreId',
    );

    return resultString['result'];
  }

  /// Get the list of POI categories for the given generic category.
  ///
  /// **Parameters**
  ///
  /// * **IN** *genericCategory* Generic category id, see [GenericCategoriesId].
  ///
  /// **Returns**
  ///
  /// * The list of POI categories
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static List<LandmarkCategory> getPoiCategories(final int genericCategory) {
    final OperationResult resultString = staticMethod(
      'GenericCategories',
      'getPoiCategories',
      args: genericCategory,
    );

    if (resultString['result'] == -1) {
      return <LandmarkCategory>[];
    }

    return LandmarkCategoryList.init(resultString['result']).toList();
  }
}
