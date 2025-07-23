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

import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// Listener class for a specific landmark store.
///
/// Should be used with [LandmarkStoreService.addListener] in order to receive events
///
/// {@category Places}
class LandmarkStoreListener extends EventHandler {
  /// Creates a new [LandmarkStoreListener] instance with the given callbacks.
  ///
  /// **Parameters**
  ///
  /// * **IN** *onLandmarkCreated* See [registerOnLandmarkCreated] for more information.
  /// * **IN** *onLandmarkUpdated* See [registerOnLandmarkUpdated] for more information.
  /// * **IN** *onLandmarksUpdated* See [registerOnLandmarksUpdated] for more information.
  /// * **IN** *onLandmarkRemoved* See [registerOnLandmarkRemoved] for more information.
  /// * **IN** *onLandmarksRemoved* See [registerOnLandmarksRemoved] for more information.
  /// * **IN** *onCategoryCreated* See [registerOnCategoryCreated] for more information.
  /// * **IN** *onCategoryUpdated* See [registerOnCategoryUpdated] for more information.
  /// * **IN** *onCategoryRemoved* See [registerOnCategoryRemoved] for more information.
  /// * **IN** *onLandmarkStoreCreated* See [registerOnLandmarkStoreCreated] for more information.
  /// * **IN** *onLandmarkStoreRegistered* See [registerOnLandmarkStoreRegistered] for more information.
  /// * **IN** *onLandmarkStoreRemoved* See [registerOnLandmarkStoreRemoved] for more information.
  factory LandmarkStoreListener({
    final void Function(int landmarkStoreId, int landmarkId)? onLandmarkCreated,
    final void Function(int landmarkStoreId, int landmarkId)? onLandmarkUpdated,
    final void Function(int landmarkStoreId, List<int> landmarksId)?
        onLandmarksUpdated,
    final void Function(int landmarkStoreId, int landmarkId)? onLandmarkRemoved,
    final void Function(int landmarkStoreId, List<int> landmarkIds)?
        onLandmarksRemoved,
    final void Function(int landmarkStoreId, int categoryId)? onCategoryCreated,
    final void Function(int landmarkStoreId, int categoryId)? onCategoryUpdated,
    final void Function(int landmarkStoreId, int categoryId)? onCategoryRemoved,
    final void Function(int landmarkStoreId)? onLandmarkStoreCreated,
    final void Function(int landmarkStoreId)? onLandmarkStoreRegistered,
    final void Function(int landmarkStoreId)? onLandmarkStoreRemoved,
  }) {
    final LandmarkStoreListener listener = LandmarkStoreListener._create();

    if (onLandmarkCreated != null) {
      listener.registerOnLandmarkCreated(onLandmarkCreated);
    }
    if (onLandmarkUpdated != null) {
      listener.registerOnLandmarkUpdated(onLandmarkUpdated);
    }
    if (onLandmarksUpdated != null) {
      listener.registerOnLandmarksUpdated(onLandmarksUpdated);
    }
    if (onLandmarkRemoved != null) {
      listener.registerOnLandmarkRemoved(onLandmarkRemoved);
    }
    if (onLandmarksRemoved != null) {
      listener.registerOnLandmarksRemoved(onLandmarksRemoved);
    }
    if (onCategoryCreated != null) {
      listener.registerOnCategoryCreated(onCategoryCreated);
    }
    if (onCategoryUpdated != null) {
      listener.registerOnCategoryUpdated(onCategoryUpdated);
    }
    if (onCategoryRemoved != null) {
      listener.registerOnCategoryRemoved(onCategoryRemoved);
    }
    if (onLandmarkStoreCreated != null) {
      listener.registerOnLandmarkStoreCreated(onLandmarkStoreCreated);
    }
    if (onLandmarkStoreRegistered != null) {
      listener.registerOnLandmarkStoreRegistered(onLandmarkStoreRegistered);
    }
    if (onLandmarkStoreRemoved != null) {
      listener.registerOnLandmarkStoreRemoved(onLandmarkStoreRemoved);
    }

    return listener;
  }

  @internal
  LandmarkStoreListener.init(this.id);
  void Function(int landmarkStoreId, int landmarkId)?
      _onLandmarkCreatedCallback;
  void Function(int landmarkStoreId, int landmarkId)?
      _onLandmarkUpdatedCallback;
  void Function(int landmarkStoreId, List<int> landmarksId)?
      _onLandmarksUpdatedCallback;
  void Function(int landmarkStoreId, int landmarkId)?
      _onLandmarkRemovedCallback;
  void Function(int landmarkStoreId, List<int> landmarkIds)?
      _onLandmarksRemovedCallback;
  void Function(int landmarkStoreId, int categoryId)?
      _onCategoryCreatedCallback;
  void Function(int landmarkStoreId, int categoryId)?
      _onCategoryUpdatedCallback;
  void Function(int landmarkStoreId, int categoryId)?
      _onCategoryRemovedCallback;
  void Function(int landmarkStoreId)? _onLandmarkStoreCreatedCallback;
  void Function(int landmarkStoreId)? _onLandmarkStoreRegisteredCallback;
  void Function(int landmarkStoreId)? _onLandmarkStoreRemovedCallback;
  // void Function(int landmarkStoreId, int sessionId)? onBrowseSessionInvalidatedCallback;

  dynamic id;

  static LandmarkStoreListener _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, dynamic>{
        'class': 'LandmarkStoreListener',
        'args': <String, dynamic>{},
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return LandmarkStoreListener.init(decodedVal['result']);
  }

  /// Called when a landmark is added to the store.
  ///
  /// Only available for existing markers (e.g. markers provided by search / map selection / etc.).
  /// Not triggered when user created landmarks are added.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkStoreId* The ID of the landmark store.
  /// * **IN** *landmarkId* The ID of the created landmark.
  void registerOnLandmarkCreated(
    final void Function(int landmarkStoreId, int landmarkId)? callback,
  ) {
    _onLandmarkCreatedCallback = callback;
  }

  /// Called when a landmark is updated.
  ///
  /// Only available for existing markers (e.g. markers provided by search / map selection / etc.).
  /// Not triggered when user created landmarks are modified.
  ///
  /// Triggered after the [LandmarkStore.updateLandmark] method is called with a landmark already existing
  /// in the store that suffered modifications.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkStoreId* The ID of the landmark store.
  /// * **IN** *landmarkId* The ID of the updated landmark.
  void registerOnLandmarkUpdated(
    final void Function(int landmarkStoreId, int landmarkId)? callback,
  ) {
    _onLandmarkUpdatedCallback = callback;
  }

  /// Called when a list of landmarks is updated.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkStoreId* The ID of the landmark store.
  /// * **IN** *landmarksId* A list of IDs of the updated landmarks.
  void registerOnLandmarksUpdated(
    final void Function(int landmarkStoreId, List<int> landmarksId)? callback,
  ) {
    _onLandmarksUpdatedCallback = callback;
  }

  /// Called when a landmark is removed.
  ///
  /// Only available for existing markers (e.g. markers provided by search / map selection / etc.).
  /// Not triggered when user created landmarks are removed.
  ///
  /// Triggered after the [LandmarkStore.removeLandmark] method is called with a landmark already existing
  /// in the store.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkStoreId* The ID of the landmark store.
  /// * **IN** *landmarkId* The ID of the removed landmark.
  void registerOnLandmarkRemoved(
    final void Function(int landmarkStoreId, int landmarkId)? callback,
  ) {
    _onLandmarkRemovedCallback = callback;
  }

  /// Called when a list of landmarks is removed.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkStoreId* The ID of the landmark store.
  /// * **IN** *landmarkIds* A list of IDs of the removed landmarks.
  void registerOnLandmarksRemoved(
    final void Function(int landmarkStoreId, List<int> landmarkIds)? callback,
  ) {
    _onLandmarksRemovedCallback = callback;
  }

  /// Called when a landmark category is created.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkStoreId* The ID of the landmark store.
  /// * **IN** *categoryId* The ID of the created category.
  void registerOnCategoryCreated(
    final void Function(int landmarkStoreId, int categoryId)? callback,
  ) {
    _onCategoryCreatedCallback = callback;
  }

  /// Called when a landmark category is updated.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkStoreId* The ID of the landmark store.
  /// * **IN** *categoryId* The ID of the updated category.
  void registerOnCategoryUpdated(
    final void Function(int landmarkStoreId, int categoryId)? callback,
  ) {
    _onCategoryUpdatedCallback = callback;
  }

  /// Called when a landmark category is removed.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkStoreId* The ID of the landmark store.
  /// * **IN** *categoryId* The ID of the removed category.
  void registerOnCategoryRemoved(
    final void Function(int landmarkStoreId, int categoryId)? callback,
  ) {
    _onCategoryRemovedCallback = callback;
  }

  /// Called when a new landmark store is created.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkStoreId* The ID of the newly created landmark store.
  void registerOnLandmarkStoreCreated(
    final void Function(int landmarkStoreId)? callback,
  ) {
    _onLandmarkStoreCreatedCallback = callback;
  }

  /// Called when a new landmark store is registered.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkStoreId* The ID of the registered landmark store.
  void registerOnLandmarkStoreRegistered(
    final void Function(int landmarkStoreId)? callback,
  ) {
    _onLandmarkStoreRegisteredCallback = callback;
  }

  /// Called when a landmark store is removed.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkStoreId* The ID of the removed landmark store.
  void registerOnLandmarkStoreRemoved(
    final void Function(int landmarkStoreId)? callback,
  ) {
    _onLandmarkStoreRemovedCallback = callback;
  }

  @override
  void dispose() {
    staticMethod('LandmarkStoreService', 'removeListener', args: id);
  }

  @override
  void handleEvent(final Map<dynamic, dynamic> arguments) {
    final String eventSubtype = arguments['event_subtype'];

    switch (eventSubtype) {
      case 'onLandmarkCreated':
        if (_onLandmarkCreatedCallback != null) {
          _onLandmarkCreatedCallback!(
            arguments['landmarkStoreId'],
            arguments['landmarkId'],
          );
        }

      case 'onLandmarkUpdated':
        if (_onLandmarkUpdatedCallback != null) {
          _onLandmarkUpdatedCallback!(
            arguments['landmarkStoreId'],
            arguments['landmarkId'],
          );
        }

      case 'onLandmarksUpdated':
        if (_onLandmarksUpdatedCallback != null) {
          _onLandmarksUpdatedCallback!(
            arguments['landmarkStoreId'],
            arguments['landmarksId'].cast<int>(),
          );
        }

      case 'onLandmarkRemoved':
        if (_onLandmarkRemovedCallback != null) {
          _onLandmarkRemovedCallback!(
            arguments['landmarkStoreId'],
            arguments['landmarkId'],
          );
        }

      case 'onLandmarksRemoved':
        if (_onLandmarksRemovedCallback != null) {
          _onLandmarksRemovedCallback!(
            arguments['landmarkStoreId'],
            arguments['landmarksId'].cast<int>(),
          );
        }

      case 'onCategoryCreated':
        if (_onCategoryCreatedCallback != null) {
          _onCategoryCreatedCallback!(
            arguments['landmarkStoreId'],
            arguments['categoryId'],
          );
        }

      case 'onCategoryUpdated':
        if (_onCategoryUpdatedCallback != null) {
          _onCategoryUpdatedCallback!(
            arguments['landmarkStoreId'],
            arguments['categoryId'],
          );
        }

      case 'onCategoryRemoved':
        if (_onCategoryRemovedCallback != null) {
          _onCategoryRemovedCallback!(
            arguments['landmarkStoreId'],
            arguments['categoryId'],
          );
        }

      case 'onLandmarkStoreCreated':
        if (_onLandmarkStoreCreatedCallback != null) {
          _onLandmarkStoreCreatedCallback!(arguments['landmarkStoreId']);
        }

      case 'onLandmarkStoreRegistered':
        if (_onLandmarkStoreRegisteredCallback != null) {
          _onLandmarkStoreRegisteredCallback!(arguments['landmarkStoreId']);
        }

      case 'onLandmarkStoreRemoved':
        if (_onLandmarkStoreRemovedCallback != null) {
          _onLandmarkStoreRemovedCallback!(arguments['landmarkStoreId']);
        }

      case 'onBrowseSessionInvalidated':
      // if (onBrowseSessionInvalidatedCallback != null) {
      //   onBrowseSessionInvalidatedCallback!(json['landmarkStoreId'], json['sessionId']);
      // }
      // break;

      default:
        gemSdkLogger.log(
          Level.WARNING,
          'Unknown event subtype: $eventSubtype in LandmarkStoreListener',
        );
    }
  }
}
