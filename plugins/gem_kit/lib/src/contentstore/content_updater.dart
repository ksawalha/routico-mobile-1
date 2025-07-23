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

import 'package:gem_kit/src/contentstore/content_store_item.dart';
import 'package:gem_kit/src/contentstore/content_types.dart';
import 'package:gem_kit/src/contentstore/content_updater_status.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/core/progress_listener.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Content updater class
///
/// This class should not be instantiated directly. Instead, use the [ContentStore.createContentUpdater] getter to obtain an instance.
///
/// {@category Content}
class ContentUpdater extends GemAutoreleaseObject {
  // ignore: unused_element
  ContentUpdater._()
      : _pointerId = -1,
        _mapId = -1;

  @internal
  ContentUpdater.init(final int id, final int mapId)
      : _pointerId = id,
        _mapId = mapId {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  /// Start / resume the update process.
  ///
  /// **Parameters**
  ///
  /// * **IN** *allowChargeNetwork*	Allow charging network
  /// * **IN** *onStatusUpdated* Callback that gets triggered when the status of the updater changes. Gets called with the associated [ContentUpdaterStatus].
  /// * **IN** *onProgressUpdated* Callback that gets triggered when the progress of the updater changes. Gets called with the associated progress.
  /// * **IN** *onCompleteCallback*  Callback that gets triggered when the update process is completed. Gets called with the associated [GemError]:
  ///    * [GemError.success] on success
  ///    * [GemError.inUse] if the update is already running
  ///    * [GemError.notSupported] if the update is not supported for the given [ContentType]
  ///    * [GemError.noDiskSpace] if there is not enough disk space on the device
  ///    * [GemError.io] if a file system error occurs
  ///    * Other [GemError] values for other errors
  ///
  /// **Returns**
  ///
  /// * Associated [ProgressListener] for this operation if the update can be started otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  ProgressListener? update(
    final bool allowChargeNetwork, {
    final void Function(ContentUpdaterStatus status)? onStatusUpdated,
    final void Function(int progress)? onProgressUpdated,
    final void Function(GemError error)? onCompleteCallback,
  }) {
    final EventDrivenProgressListener progressListener =
        EventDrivenProgressListener();

    if (onStatusUpdated != null) {
      progressListener.registerOnNotifyStatusChanged(
        (final int status) =>
            onStatusUpdated(ContentUpdaterStatusExtension.fromId(status)),
      );
    }

    if (onProgressUpdated != null) {
      progressListener.registerOnProgressCallback(
        (final int progress) => onProgressUpdated(progress),
      );
    }

    if (onCompleteCallback != null) {
      progressListener.registerOnCompleteWithDataCallback(
        (final int err, final String hint, final Map<dynamic, dynamic> json) =>
            onCompleteCallback(GemErrorExtension.fromCode(err)),
      );
    }

    GemKitPlatform.instance.registerEventHandler(
      progressListener.id,
      progressListener,
    );

    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentUpdater',
      'update',
      args: <String, dynamic>{
        'allowChargeNetwork': allowChargeNetwork,
        'listener': progressListener.id,
      },
    );

    final GemError errorCode = GemErrorExtension.fromCode(
      resultString['result'],
    );
    if (errorCode != GemError.success) {
      onCompleteCallback?.call(errorCode);
      return null;
    }

    return progressListener;
  }

  /// Get the content items list in update process.
  ///
  /// **Returns**
  ///
  /// * Content list
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<ContentStoreItem> get items {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentUpdater',
      'getItems',
    );

    return ContentStoreItemList.init(resultString['result']).toList();
  }

  /// Get content type in update process.
  ///
  /// **Returns**
  ///
  /// * Content type
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  ContentType get contentType {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentUpdater',
      'getContentType',
    );

    return ContentTypeExtension.fromId(resultString['result']);
  }

  /// Get update operation status.
  ///
  /// **Returns**
  ///
  /// * Content updater status
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  ContentUpdaterStatus get status {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentUpdater',
      'getStatus',
    );

    return ContentUpdaterStatusExtension.fromId(resultString['result']);
  }

  /// Get content type in update process.
  ///
  /// Progress values are calculated with respect to [ProgressListener.progressMultiplier]
  ///
  /// **Returns**
  ///
  /// * Progress value
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get progress {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentUpdater',
      'getProgress',
    );

    return resultString['result'];
  }

  /// Check if content update can be applied.
  ///
  /// **Returns**
  ///
  /// * True if content update can be applied, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get canApply {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentUpdater',
      'canApply',
    );

    return resultString['result'];
  }

  /// Apply content update
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.upToDate] if content has already been updated
  /// * [GemError.invalidated] if update operation hasn't been started
  /// * [GemError.io] if the update cannot be applied or an error related to files has occurred
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError apply() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentUpdater',
      'apply',
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Cancel content update.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void cancel() {
    objectMethod(_pointerId, 'ContentUpdater', 'cancel');
  }

  /// Check if content updater is started.
  ///
  /// **Returns**
  ///
  /// * True if content update can be applied, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isStarted {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentUpdater',
      'isStarted',
    );

    return resultString['result'];
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(
            <String, Object>{'class': 'ContentUpdater', 'id': _pointerId}),
      );
}
