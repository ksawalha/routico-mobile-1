// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'package:gem_kit/landmark_store.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/landmark_category.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Landmark store collection class
///
/// This class should not be instantiated directly. Instead, use the [MapViewPreferences.lmks] getter to obtain an instance.
///
/// {@category Places}
class LandmarkStoreCollection extends GemAutoreleaseObject {
  // ignore: unused_element
  LandmarkStoreCollection._() : _pointerId = -1;

  @internal
  LandmarkStoreCollection.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Add all categories from the specified store.
  ///
  /// **Parameters**
  ///
  /// * **IN** *lms* The store
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * Other [GemError] values if it fails.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError add(final LandmarkStore lms) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStoreCollection',
      'addAllStoreCategories',
      args: lms.id,
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Add all categories from the specified store ID.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.notFound] if the store with the given id can't be found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError addAllStoreCategories(final int storeId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStoreCollection',
      'addAllStoreCategories',
      args: storeId,
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Add a new category ID into the specified store list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  /// * **IN** *categoryId* The category ID
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.notFound] if the store with the given id can't be found or if the category with the given id can't be found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError addStoreCategoryId(final int storeId, final int categoryId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStoreCollection',
      'addStoreCategoryId',
      args: <String, int>{'storeId': storeId, 'categoryId': categoryId},
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Add a list of categories into the specified store list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  /// * **IN** *categories* The list of categories
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.notFound] if the store with the given id can't be found or if the category with the given id can't be found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError addStoreCategoryList(
    final int storeId,
    final List<LandmarkCategory> categories,
  ) {
    final LandmarkCategoryList categoryList = LandmarkCategoryList();
    categories.forEach(categoryList.add);

    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStoreCollection',
      'addStoreCategoryList',
      args: <String, dynamic>{
        'storeId': storeId,
        'categories': categoryList.pointerId,
      },
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Remove all stores and categories.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void clear() {
    objectMethod(_pointerId, 'LandmarkStoreCollection', 'clear');
  }

  /// Check if the specified category ID from the specified store ID was already added.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  /// * **IN** *categoryId* The category ID
  ///
  /// **Returns**
  ///
  /// * True if the category ID from the store ID was already added, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool contains(final int storeId, final int categoryId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStoreCollection',
      'contains',
      args: <String, int>{'storeId': storeId, 'categoryId': categoryId},
    );

    return resultString['result'];
  }

  /// Check if the specified store has any category in the list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *lms* The store
  ///
  /// **Returns**
  ///
  /// * True if the store has any category in the list, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool containsLandmarkStore(final LandmarkStore lms) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStoreCollection',
      'containsLandmarkStore',
      args: lms.pointerId,
    );

    return resultString['result'];
  }

  /// Check if the specified store ID has any category in the list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  ///
  /// **Returns**
  ///
  /// * True if the store has any category in the list, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool containsStoreId(final int storeId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStoreCollection',
      'containsStoreId',
      args: storeId,
    );

    return resultString['result'];
  }

  /// Get the number of categories enabled for the specified store.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  ///
  /// **Returns**
  ///
  /// * The number of categories if the store id exists in the collection
  /// * [GemError.notFound].code if the store does not exist in the collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int getCategoryCount(final int storeId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStoreCollection',
      'getCategoryCount',
      args: storeId,
    );

    return resultString['result'];
  }

  /// Get the specified category ID for the specified store.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  /// * **IN** *indexCategory* The index of the category
  ///
  /// **Returns**
  ///
  /// * The number of categories if the store id exists in the collection
  /// * [GemError.notFound].code if the store does not exist in the collection
  /// * [GemError.outOfRange].code if the index is invalid
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int getStoreCategoryId(final int storeId, final int indexCategory) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStoreCollection',
      'getStoreCategoryId',
      args: <String, int>{'storeId': storeId, 'indexCategory': indexCategory},
    );

    return resultString['result'];
  }

  /// Get the store ID for the specified index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index*	The index should be less than the value provided by [size].
  ///
  /// **Returns**
  ///
  /// * On success, returns the store ID greater than 0
  /// * [GemError.outOfRange].code if index is invalid
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int getStoreIdAt(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStoreCollection',
      'getStoreIdAt',
      args: index,
    );

    return resultString['result'];
  }

  /// Remove all categories of the specified store.
  ///
  /// **Parameters**
  ///
  /// * **IN** *lms* The store
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError remove(final LandmarkStore lms) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStoreCollection',
      'remove',
      args: lms.pointerId,
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Remove all categories of the specified store ID.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.notFound] if no store with the given ID has been found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError removeAllStoreCategories(final int storeId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStoreCollection',
      'removeAllStoreCategories',
      args: storeId,
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Remove category ID from the specified store list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  /// * **IN** *categoryId* The category ID
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.notFound] if no store with the given ID has been found or the category has not been found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError removeStoreCategoryId(final int storeId, final int categoryId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStoreCollection',
      'removeStoreCategoryId',
      args: <String, int>{'storeId': storeId, 'categoryId': categoryId},
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Get the number of stores in the list.
  ///
  /// **Returns**
  ///
  /// * The number of stores
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get size {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStoreCollection',
      'size',
    );

    return resultString['result'];
  }
}
