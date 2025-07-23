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

import 'package:flutter/services.dart';
import 'package:gem_kit/src/contentstore/content_store_item_status.dart';
import 'package:gem_kit/src/contentstore/content_types.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/images.dart';
import 'package:gem_kit/src/core/language.dart';
import 'package:gem_kit/src/core/offboard_listener.dart';
import 'package:gem_kit/src/core/parameters.dart';
import 'package:gem_kit/src/core/progress_listener.dart';
import 'package:gem_kit/src/core/sdk_settings.dart';
import 'package:gem_kit/src/core/types.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/map/map_details.dart';
import 'package:meta/meta.dart';

/// Content download thread priority
///
/// {@category Content}
enum ContentDownloadThreadPriority {
  /// Default priority, following the OS default value
  defaultPriority,

  /// Low priority for download threads
  lowPriority,

  /// High priority for download threads
  highPriority,
}

/// @nodoc
///
/// {@category Content}
extension ContentDownloadThreadPriorityExtension
    on ContentDownloadThreadPriority {
  int get id {
    switch (this) {
      case ContentDownloadThreadPriority.defaultPriority:
        return 0;
      case ContentDownloadThreadPriority.lowPriority:
        return 1;
      case ContentDownloadThreadPriority.highPriority:
        return 2;
    }
  }

  static ContentDownloadThreadPriority fromId(final int id) {
    switch (id) {
      case 0:
        return ContentDownloadThreadPriority.defaultPriority;
      case 1:
        return ContentDownloadThreadPriority.lowPriority;
      case 2:
        return ContentDownloadThreadPriority.highPriority;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Data save policy
///
/// {@category Content}
enum DataSavePolicy {
  /// Save new data only on internal storage.
  useInternalOnly,

  /// Save new data only on external storage.
  useExternalOnly,

  /// Save new data on both storages but prefer on internal storage.
  useBothPreferInternal,

  /// Save new data on both storages but prefer on external storage.
  useBothPreferExternal,

  /// Use the default saving policy.
  useDefault,
}

/// @nodoc
///
/// {@category Content}
extension DataSavePolicyExtension on DataSavePolicy {
  int get id {
    switch (this) {
      case DataSavePolicy.useInternalOnly:
        return 0;
      case DataSavePolicy.useExternalOnly:
        return 1;
      case DataSavePolicy.useBothPreferInternal:
        return 2;
      case DataSavePolicy.useBothPreferExternal:
        return 3;
      case DataSavePolicy.useDefault:
        return 4;
    }
  }

  static DataSavePolicy fromId(final int id) {
    switch (id) {
      case 0:
        return DataSavePolicy.useInternalOnly;
      case 1:
        return DataSavePolicy.useExternalOnly;
      case 2:
        return DataSavePolicy.useBothPreferInternal;
      case 3:
        return DataSavePolicy.useBothPreferExternal;
      case 4:
        return DataSavePolicy.useDefault;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Content store item class
///
/// This class should not be instantiated directly. Instead, use the methods provided by the [ContentStore] class
///
/// {@category Content}
class ContentStoreItem extends GemAutoreleaseObject {
  // ignore: unused_element
  ContentStoreItem._() : _pointerId = -1;

  @internal
  ContentStoreItem.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;
  int get pointerId => _pointerId;

  /// Get the name of the associated product.
  ///
  /// The name is automatically translated based on the interface language.
  ///
  /// **Returns**
  ///
  /// * The name of the product
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getName',
    );

    return resultString['result'];
  }

  /// Get the unique id of the item in the content store.
  ///
  /// **Returns**
  ///
  /// * The content store item id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get id {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getId',
    );

    return resultString['result'];
  }

  /// Get the product chapter name translated to interface language.
  ///
  /// Relevant for [ContentType.roadMap] items, as large countries are split in multiple items.
  /// All the items from a country have the same [chapterName].
  /// It is empty if the country is not split into multiple items or if the item is not a road map item.
  ///
  /// Items with same chapter name are considered to be part of the same group.
  ///
  /// **Returns**
  ///
  /// * The chapter name of the product
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get chapterName {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getChapterName',
    );

    return resultString['result'];
  }

  /// Get the country code (ISO 3166-1 alpha-3) list of the product as text.
  ///
  /// Country code list can be empty if the product is not a road map item.
  ///
  /// This information can be used to render a country flag using [MapDetails.getCountryFlag] method.
  ///
  /// **Returns**
  ///
  /// * Country code(ISO 3166-1 alpha-3) of the product as text (empty for none).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<String> get countryCodes {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getCountryCodes',
    );
    return resultString['result'].cast<String>();
  }

  /// Get the full language code for the product.
  ///
  /// The [Language] can have empty field if no language is available for this type of products.
  ///
  /// **Returns**
  ///
  /// * Full language code of the product (empty for none).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Language get language {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getLanguage',
    );

    return Language.fromJson(resultString['result']);
  }

  /// Get the type of the product as a [ContentType] value.
  ///
  /// **Returns**
  ///
  /// * The type of the product
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  ContentType get type {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getType',
    );

    return ContentTypeExtension.fromId(resultString['result']);
  }

  /// Get the full path to the content data file when available.
  ///
  /// **Returns**
  ///
  /// * The full path to the content data file if the item is available on the device or empty otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get fileName {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getFileName',
    );

    return resultString['result'];
  }

  /// Get the client version of the content.
  ///
  /// Requires the content available size greater than zero.
  ///
  /// **Returns**
  ///
  /// * The local downloaded version of the content.
  /// If available, [Version.isValid] returns true; otherwise, it returns false.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Version get clientVersion {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getClientVersion',
    );

    return Version.fromJson(resultString['result']);
  }

  /// Get the size of the content in bytes.
  ///
  /// **Returns**
  ///
  /// * The real size of the content. If the content is not available then it returns 0.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get totalSize {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getTotalSize',
    );

    return resultString['result'];
  }

  /// Get the available size of the content in bytes.
  ///
  /// **Returns**
  ///
  /// * The size of the downloaded content. This may or may not be equal with [totalSize].
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get availableSize {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getAvailableSize',
    );

    return resultString['result'];
  }

  /// Check if the item is completely downloaded.
  ///
  /// **Returns**
  ///
  /// * True if the download is completed, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isCompleted {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'isCompleted',
    );

    return resultString['result'];
  }

  /// Gets current item status.
  ///
  /// **Returns**
  ///
  /// * [ContentStoreItemStatus] value
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  ContentStoreItemStatus get status {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getStatus',
    );

    return ContentStoreItemStatusExtension.fromId(resultString['result']);
  }

  /// Pause a previous download operation.
  ///
  /// User will receive a notification on the [asyncDownload]'s onComplete callback with a [GemError.suspended] error.
  ///
  /// **Parameters**
  ///
  /// * **IN** *onComplete*	Object that implements notification event associated with operation completion. Returns [GemError.success] on success, otherwise [GemError.general].
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError pauseDownload({void Function(GemError)? onComplete}) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'pauseDownload',
    );

    final GemError err = GemErrorExtension.fromCode(resultString['result']);

    if (err == GemError.success && onComplete != null) {
      _tryNotifyComplete(onComplete: onComplete);
    }

    if (err != GemError.success) {
      onComplete?.call(err);
    }

    return err;
  }

  Future<void> _tryNotifyComplete({
    void Function(GemError)? onComplete,
    Duration duration = const Duration(milliseconds: 2000),
  }) async {
    const Duration step = Duration(milliseconds: 50);

    if (status == ContentStoreItemStatus.paused || duration <= step) {
      final GemError result = status == ContentStoreItemStatus.paused
          ? GemError.success
          : GemError.general;
      onComplete?.call(result);
    } else {
      await Future<void>.delayed(step, () {});
      _tryNotifyComplete(onComplete: onComplete, duration: duration - step);
    }
  }

  /// Cancel a previous download operation.
  ///
  /// The partially downloaded content is deleted.
  ///
  /// The operation is executed immediately, and no notifications are triggered.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError cancelDownload() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'cancelDownload',
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Get current download progress.
  ///
  /// **Returns**
  ///
  /// * Current download progress.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get downloadProgress {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getDownloadProgress',
    );

    return resultString['result'];
  }

  /// Check if associated content can be deleted.
  ///
  /// Content can be deleted if it has partially or complete local data and is not marked as SDK resource.
  ///
  /// **Returns**
  ///
  /// * True if the content can be deleted, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get canDeleteContent {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'canDeleteContent',
    );

    return resultString['result'];
  }

  /// Delete the associated content.
  ///
  /// Operation is executed immediately. No notifications are triggered.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.accessDenied] if the content is a SDK resource
  /// * [GemError.notFound] if the content item does not exist
  /// * [GemError.inUse] if the item is currently in use
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError deleteContent() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'deleteContent',
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Check if there is an image preview available on the client.
  ///
  /// **Returns**
  ///
  /// * True if an image preview is available, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isImagePreviewAvailable {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'isImagePreviewAvailable',
    );

    return resultString['result'];
  }

  /// Get the preview if available.
  ///
  /// Available only if [isImagePreviewAvailable] returns true.
  ///
  /// **Returns**
  ///
  /// * The resulting image if available, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Uint8List? getImagePreview({
    final Size? size,
    final ImageFileFormat? format,
  }) {
    return GemKitPlatform.instance.callGetImage(
      pointerId,
      'ContentStoreItemGetImagePreview',
      size?.width.toInt() ?? -1,
      size?.height.toInt() ?? -1,
      format?.id ?? -1,
    );
  }

  /// Get the item image
  ///
  /// **Returns**
  ///
  /// * Item image. The user is responsible to check if the image is valid
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Img get imgPreview {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getImgPreview',
    );

    return Img.init(resultString['result']);
  }

  /// Get additional parameters for the content.
  ///
  /// This is not available for all content types.
  ///
  /// **Returns**
  ///
  /// * The additional parameters for the content.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  SearchableParameterList get contentParameters {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getContentParameters',
    );

    return SearchableParameterList.init(resultString['result']);
  }

  /// Get corresponding update item.
  ///
  /// Function will return a valid item only if an update is in progress for that item.
  ///
  /// **Returns**
  ///
  /// * The update item if an update is in progress for the given element, null otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  ContentStoreItem? get updateItem {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getUpdateItem',
    );

    final int id = resultString['result'];
    if (id == -1) {
      return null;
    }
    return ContentStoreItem.init(id);
  }

  /// Check if item is updatable, i.e. it has a newer version available.
  ///
  /// **Returns**
  ///
  /// * True if the item is updatable, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isUpdatable {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'isUpdatable',
    );

    return resultString['result'];
  }

  /// Get update size (if an update is available for this item).
  ///
  /// Function will return a valid size (!= 0) only if the item has a newer version in store.
  ///
  /// This function doesn't request an update to be started for the item.
  ///
  /// **Returns**
  ///
  /// * The update size
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get updateSize {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getUpdateSize',
    );

    return resultString['result'];
  }

  /// Get update version (if an update is available for this item).
  ///
  /// Function will return a valid version (!= 0) only if the item has a newer version in store.
  ///
  /// This function doesn't request an update to be started for the item.
  ///
  /// **Returns**
  ///
  /// * The update version
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Version get updateVersion {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'getUpdateVersion',
    );

    return Version.fromJson(resultString['result']);
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, Object>{
        'class': 'ContentStoreItem',
        'id': _pointerId,
      }),
    );
  }

  /// Asynchronous start/resume the download of the content store product content.
  ///
  /// Requires automatic map rendering. Disables the cursor if enabled.
  ///
  /// **Parameters**
  ///
  /// * **IN** *onCompleteCallback*	Object that implements notification event associated with operation completion. Cannot be empty. Returns [GemError.success] on success, otherwise see [GemError] for other values.
  /// * **IN** *onProgressCallback*	Object that implements notification event associated with operation progress.
  /// * **IN** *allowChargedNetworks*	Flag whether to allow charged networks. If true, it will override [SdkSettings.setAllowOffboardServiceOnExtraChargedNetwork] ( [ServiceGroupType.contentService, false ).
  /// * **IN** *savePolicy*	Specify where the download will be made (optional).
  ///
  /// **Returns**
  ///
  /// * The associated [ProgressListener]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  ProgressListener asyncDownload(
    final void Function(GemError err) onCompleteCallback, {
    final void Function(int progress)? onProgressCallback,
    final bool allowChargedNetworks = false,
    final DataSavePolicy savePolicy = DataSavePolicy.useDefault,
    final ContentDownloadThreadPriority priority =
        ContentDownloadThreadPriority.defaultPriority,
  }) {
    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ContentStoreItem',
      'asyncDownload',
      args: <String, dynamic>{
        'listener': progListener.id,
        'allowChargedNetworks': allowChargedNetworks,
        'savePolicy': savePolicy.id,
        'priority': priority.id,
      },
    );

    if (resultString is Map && resultString.containsKey('error')) {
      onCompleteCallback(GemErrorExtension.fromCode(resultString['error']));
      return EventDrivenProgressListener.init(0);
    }
    if (onProgressCallback != null) {
      progListener.registerOnProgressCallback((final int p0) {
        onProgressCallback(p0);
      });
    }
    progListener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      if (err == 0) {
        onCompleteCallback(GemErrorExtension.fromCode(0));
        //onCompleteCallback(err, result.getJson());
      } else {
        onCompleteCallback(GemErrorExtension.fromCode(err));
      }
    });
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
    return progListener;
  }
}
