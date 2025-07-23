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
import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

/// Landmark store service class
///
/// {@category Places}
abstract class LandmarkStoreService {
  /// Create a new landmark store. The landmark store type for all stores created with this function is [LandmarkStoreType.defaultType]
  ///
  /// **Parameters**
  ///
  /// * **IN** *name*	The name of the landmark store. The name must be unique otherwise will return [GemError.exist].
  /// * **IN** *zoom*	The max zoom step at which the landmark store will be visible. If -1, a default optimal zoom level is selected.
  /// * **IN** *folder*	Folder path where the landmark store will be created. If empty, the landmark store will be created in the SDK default location.
  ///
  /// If a landmark store with the given name already exists, it is returned.
  ///
  /// **Returns**
  ///
  /// * LandmarkStore object. If a landmark store already exists, it is returned.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static LandmarkStore createLandmarkStore(
    final String name, {
    final int zoom = -1,
    final String folder = '',
  }) {
    final OperationResult resultString = objectMethod(
      0,
      'LandmarkStoreService',
      'createLandmarkStore',
      args: <String, Object>{'name': name, 'zoom': zoom, 'folder': folder},
    );

    final LandmarkStore retVal = LandmarkStore.init(resultString['result'], 0);
    return retVal;
  }

  /// Get landmark store by ID.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkStoreId*	The ID of the landmark store
  ///
  /// **Returns**
  ///
  /// * [LandmarkStore] object if it exists, otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static LandmarkStore? getLandmarkStoreById(final int landmarkStoreId) {
    final OperationResult resultString = objectMethod(
      0,
      'LandmarkStoreService',
      'getLandmarkStoreById',
      args: landmarkStoreId,
    );

    if (resultString['result'] == -1) {
      return null;
    }

    final LandmarkStore retVal = LandmarkStore.init(resultString['result'], 0);
    return retVal;
  }

  /// Get landmark store by name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name*	The name of the landmark store
  ///
  /// **Returns**
  ///
  /// * [LandmarkStore] object if it exists, otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static LandmarkStore? getLandmarkStoreByName(final String name) {
    final OperationResult resultString = objectMethod(
      0,
      'LandmarkStoreService',
      'getLandmarkStoreByName',
      args: name,
    );

    if (resultString['result'] == -1) {
      return null;
    }

    final LandmarkStore retVal = LandmarkStore.init(resultString['result'], 0);
    return retVal;
  }

  /// Get Map POIs landmarkstore id.
  ///
  /// **Returns**
  ///
  /// * Map POI landmark store id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static int get mapPoisLandmarkStoreId {
    final OperationResult resultString = objectMethod(
      0,
      'LandmarkStoreService',
      'getMapPoisLandmarkStoreId',
    );

    final int res = resultString['result'];
    return res;
  }

  /// Get Map Address landmarkstore id attached to map address database information.
  ///
  /// The result Id cannot be used with [getLandmarkStoreById]
  ///
  /// **Returns**
  ///
  /// * Map Address landmarkstore id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static int get mapAddressLandmarkStoreId {
    final OperationResult resultString = objectMethod(
      0,
      'LandmarkStoreService',
      'getMapAddressLandmarkStoreId',
    );

    return resultString['result'];
  }

  /// Get LandmarkStore id attached to map roads database information.
  ///
  /// The result Id cannot be used with [getLandmarkStoreById]
  ///
  /// **Returns**
  ///
  /// * Landmark store ID
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static int get mapRoadsLandmarkStoreId {
    final OperationResult resultString = objectMethod(
      0,
      'LandmarkStoreService',
      'getMapRoadsLandmarkStoreId',
    );

    return resultString['result'];
  }

  /// Get LandmarkStore id attached to overlays database.
  ///
  /// The result Id cannot be used with [getLandmarkStoreById]
  ///
  /// **Returns**
  ///
  /// * Landmark store ID
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static int get overlaysLandmarkStoreId {
    final OperationResult resultString = objectMethod(
      0,
      'LandmarkStoreService',
      'getOverlaysLandmarkStoreId',
    );

    return resultString['result'];
  }

  /// Get LandmarkStore id attached to geofence database.
  ///
  /// The result Id cannot be used with [getLandmarkStoreById]
  ///
  /// **Returns**
  ///
  /// * Landmark store ID
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static int get geofenceLandmarkStoreId {
    final OperationResult resultString = objectMethod(
      0,
      'LandmarkStoreService',
      'getGeofenceLandmarkStoreId',
    );

    return resultString['result'];
  }

  /// Get Map Cities landmarkstore id attached to map address database information.
  ///
  /// The result Id cannot be used with [getLandmarkStoreById]
  ///
  /// **Returns**
  ///
  /// * Map Cities landmarkstore id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static int get mapCitiesLandmarkStoreId {
    final OperationResult resultString = objectMethod(
      0,
      'LandmarkStoreService',
      'getMapCitiesLandmarkStoreId',
    );

    final int res = resultString['result'];
    return res;
  }

  /// Remove the landmark store specified by ID.
  ///
  /// The landmark store should be disposed before calling this method. Dispose the landmark store using [LandmarkStore.dispose].
  /// The landmarks store will not be removed unless the object is disposed.
  ///
  /// The method does not work if the landmark store is in use.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkStoreId* The landmark store ID
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static void removeLandmarkStore(final int landmarkStoreId) {
    objectMethod(
      0,
      'LandmarkStoreService',
      'removeLandmarkStore',
      args: landmarkStoreId,
    );
  }

  /// Get the type of the landmark store
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkStoreId*	The ID of the landmark store.
  ///
  /// **Returns**
  ///
  /// * The landmark store type as [LandmarkStoreType]. If landmarkStoreId is invalid, it returns [LandmarkStoreType.none]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static LandmarkStoreType getLandmarkStoreType(int landmarkStoreId) {
    final OperationResult resultString = objectMethod(
      0,
      'LandmarkStoreService',
      'getLandmarkStoreType',
      args: landmarkStoreId,
    );

    if (resultString['result'] == -1) {
      return LandmarkStoreType.none;
    }

    return LandmarkStoreType.values[resultString['result']];
  }

  /// Register an already existing landmark store.
  ///
  /// The name parameter will override the landmark store internal creation name. This allows registering landmark stores in order to import data from them
  ///
  /// **Parameters**
  ///
  /// * **IN** *name*	The landmark store name. Must be unique, otherwise [GemError.exist].code is returned
  /// * **IN** *path*	The landmark store path
  ///
  /// **Returns**
  ///
  /// * On success the landmark store ID (greater than zero) is returned
  /// * [GemError.exist].code if the name already exists
  /// * [GemError.notFound].code if the landmark store cannot be found
  /// * [GemError.invalidInput].code if the path is not a valid landmark store
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static int registerLandmarkStore({
    required final String name,
    required final String path,
  }) {
    final OperationResult resultString = objectMethod(
      0,
      'LandmarkStoreService',
      'registerLandmarkStore',
      args: <String, String>{'name': name, 'path': path},
    );

    final int res = resultString['result'];
    return res;
  }

  /// Get all landmark stores.
  ///
  /// **Returns**
  ///
  /// * List of [LandmarkStore] objects
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static List<LandmarkStore> get landmarkStores {
    final OperationResult resultString = objectMethod(
      0,
      'LandmarkStoreService',
      'getLandmarkStores',
    );

    final List<dynamic> res = resultString['result'];
    return res.map((final dynamic e) => LandmarkStore.init(e, 0)).toList();
  }

  /// Add new listener for landmark store events.
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener* The listener to be added
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static void addListener(final LandmarkStoreListener listener) {
    GemKitPlatform.instance.registerEventHandler(listener.id, listener);

    objectMethod(0, 'LandmarkStoreService', 'addListener', args: listener.id);
  }

  /// Remove listener for landmark store events.
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener* The listener to be removed
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static void removeListener(final LandmarkStoreListener listener) {
    objectMethod(
      0,
      'LandmarkStoreService',
      'removeListener',
      args: listener.id,
    );

    GemKitPlatform.instance.unregisterEventHandler(listener.id);
  }
}
