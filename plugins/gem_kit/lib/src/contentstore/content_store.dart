// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/contentstore/content_store_item.dart';
import 'package:gem_kit/src/contentstore/content_types.dart';
import 'package:gem_kit/src/contentstore/content_updater.dart';
import 'package:gem_kit/src/contentstore/content_updater_status.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

/// Content store object
///
/// This behaves like a singleton, i.e. all instances are sharing behind the same API interface
///
/// {@category Content}
abstract class ContentStore {
  ContentStore._();

  /// Gets access to the **installed** content list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type*	Content list type (see [ContentType])
  ///
  /// **Returns**
  ///
  /// * List of content store items
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static List<ContentStoreItem> getLocalContentList(final ContentType type) {
    final OperationResult resultString = objectMethod(
      0,
      'ContentStore',
      'getLocalContentList',
      args: type.id,
    );

    return ContentStoreItemList.init(resultString['result']).toList();
  }

  /// Gets access to the store cached content list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type*	Content list type (see [ContentType])
  ///
  /// **Returns**
  ///
  /// * Record of `(Content list, locally cached flag)`. If the list is not cached locally (locally cached flag is false) a call to [asyncGetStoreContentList] must be performed in order to request it from store.
  static (List<ContentStoreItem>, bool) getStoreContentList(
    final ContentType type,
  ) {
    final OperationResult contentStoreListString = staticMethod(
      'ContentStore',
      'getStoreContentList',
      args: type.id,
    );

    final int listId = contentStoreListString['result']['contentStoreListId'];
    final bool isCached = contentStoreListString['result']['isCached'];
    return (
      ContentStoreItemList.init(listId).toList(),
      isCached,
    );
  }

  /// Gets access to the last requested filtered list.
  ///
  /// Filtered list should be requested via a call to asyncGetStoreFilteredList
  ///
  /// **Returns**
  ///
  /// * Content list
  static List<ContentStoreItem> getStoreFilteredList() {
    final OperationResult contentStoreListString = staticMethod(
      'ContentStore',
      'getStoreFilteredList',
    );

    final int listId = contentStoreListString['result'];
    return ContentStoreItemList.init(listId).toList();
  }

  /// Asynchronously search the online store content with given filters
  ///
  /// **Parameters**
  ///
  /// * **IN** *type*	Content list type (see [ContentType])
  /// * **IN** *countries*	List (ISO 3166-3) to search in, null for all countries
  /// * **IN** *area*	Geographic area to search in, nullptr for all world
  /// * **IN** *onCompleteCallback*	The listener object that implements the notification events associated with this operation.
  ///   * **IN** *err*	[GemError.success] on success, otherwise see [GemError] for other values
  ///   * **IN** *items*	List of content store items on success. Null on error
  ///
  /// **Returns**
  ///
  /// * The associated [ProgressListener] if the request can be started, null otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static ProgressListener? asyncGetStoreFilteredList({
    required ContentType type,
    List<String>? countries,
    GeographicArea? area,
    required void Function(
      GemError err,
      List<ContentStoreItem>? items,
    ) onCompleteCallback,
  }) {
    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    final OperationResult resultString = staticMethod(
      'ContentStore',
      'asyncGetStoreFilteredList',
      args: <String, dynamic>{
        'type': type.id,
        if (countries != null) 'countries': countries,
        'area': area ??
            RectangleGeographicArea(
                topLeft: Coordinates(), bottomRight: Coordinates()),
        'listener': progListener.id
      },
    );

    if (resultString is Map && resultString.containsKey('gemApiError')) {
      final int errorCode = resultString['gemApiError'] as int;
      final GemError error = GemErrorExtension.fromCode(errorCode);
      if (error != GemError.success) {
        onCompleteCallback(error, null);
        return null;
      }
    }

    progListener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      if (err == 0) {
        final OperationResult contentStoreListString = staticMethod(
          'ContentStore',
          'getStoreFilteredList',
        );
        final int listId = contentStoreListString['result'];
        onCompleteCallback(
          GemErrorExtension.fromCode(0),
          ContentStoreItemList.init(listId).toList(),
        );
        //onCompleteCallback(err, result.getJson());
      } else {
        onCompleteCallback(GemErrorExtension.fromCode(err), null);
      }
    });
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
    return progListener;
  }

  /// Asynchronously gets an online store content list.
  ///
  /// Should not be used if the user is offline or has expired local content, otherwise will trigger
  /// the [onCompleteCallback] with a [GemError] different from [GemError.success].
  ///
  /// **Parameters**
  ///
  /// * **IN** *type*	Content list type (see [ContentType])
  /// * **IN** *onCompleteCallback*	The listener object that implements the notification events associated with this operation.
  ///   * **IN** *err*	[GemError.success] on success, otherwise see [GemError] for other values
  ///   * **IN** *items*	List of content store items on success. Null on error
  ///   * **IN** *isCached*	True if the list is cached locally. False otherwise. Null on error.
  ///
  /// **Returns**
  ///
  /// * The associated [ProgressListener] if the request can be started, null otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static ProgressListener? asyncGetStoreContentList(
    final ContentType type,
    final void Function(
      GemError err,
      List<ContentStoreItem>? items,
      bool? isCached,
    ) onCompleteCallback,
  ) {
    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    final OperationResult resultString = staticMethod(
      'ContentStore',
      'asyncGetStoreContentList',
      args: <String, dynamic>{'type': type.id, 'listener': progListener.id},
    );

    if (resultString is Map && resultString.containsKey('gemApiError')) {
      final int errorCode = resultString['gemApiError'] as int;
      final GemError error = GemErrorExtension.fromCode(errorCode);
      if (error != GemError.success) {
        onCompleteCallback(error, null, null);
        return null;
      }
    }

    progListener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      if (err == 0) {
        final OperationResult contentStoreListString = staticMethod(
          'ContentStore',
          'getStoreContentList',
          args: type.id,
        );
        final int listId =
            contentStoreListString['result']['contentStoreListId'];
        final bool isCached = contentStoreListString['result']['isCached'];
        onCompleteCallback(
          GemErrorExtension.fromCode(0),
          ContentStoreItemList.init(listId).toList(),
          isCached,
        );
        //onCompleteCallback(err, result.getJson());
      } else {
        onCompleteCallback(GemErrorExtension.fromCode(err), null, null);
      }
    });
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
    return progListener;
  }

  /// Cancels an asynchronous operation.
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener*	The progress listener of the operation requested to be canceled.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void cancel(final ProgressListener listener) {
    objectMethod(0, 'ContentStore', 'cancel', args: listener.id);
  }

  /// Creates a content updater for the given content type.
  ///
  /// After creation, the content updater must be started by calling the [ContentUpdater.update]
  /// The content updater supports operation resume between SDK running sessions.
  ///
  /// To check if there is a pending update operation started in a previous SDK session, user must do the following steps:
  ///
  /// * create an updater with [createContentUpdater]
  /// * check if [ContentUpdater.status], if status != [ContentUpdaterStatus.idle] there is a pending update which can be resumed by calling [ContentUpdater.update]
  ///
  /// **Parameters**
  ///
  /// * **IN** *type*	Content list type (see [ContentType])
  ///
  /// **Returns**
  ///
  /// * Record composed of the [ContentUpdater] object and the [GemError]. If a content updater already exists, it is returned together with [GemError.exist].
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  static (ContentUpdater, GemError) createContentUpdater(
    final ContentType type,
  ) {
    final OperationResult resultString = objectMethod(
      0,
      'ContentStore',
      'createContentUpdater',
      args: type.id,
    );

    final dynamic result = resultString['result'];
    return (
      ContentUpdater.init(result['first'], 0),
      GemErrorExtension.fromCode(result['second']),
    );
  }

  /// Check for update on the given content type.
  ///
  /// On success it will provide the result on the [OffBoardListener]'s `onWorldwideRoadMapVersionUpdatedCallback` callback if the type is [ContentType.roadMap].
  /// On success it will provide the result on the [OffBoardListener]'s `onAvailableContentUpdateCallback` callback if the type is other value.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type*	Content list type (see [ContentType])
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.connectionRequired] if the device has no internet connection.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static GemError checkForUpdate(final ContentType type) {
    final OperationResult resultString = objectMethod(
      0,
      'ContentStore',
      'checkForUpdate',
      args: type.id,
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Gets the extras item having the specified ID.
  ///
  /// **Parameters**
  ///
  /// * **IN** *id*	The item id, see [ContentStoreItem.id]
  ///
  /// **Returns**
  ///
  /// * The [ContentStoreItem] with the given id if it exists, null otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static ContentStoreItem? getItemById(final int id) {
    final OperationResult resultString = objectMethod(
      0,
      'ContentStore',
      'getItemById',
      args: id,
    );

    final int resultId = resultString['result'];
    if (resultId == -1) {
      return null;
    }
    return ContentStoreItem.init(resultId);
  }

  /// Refresh the content store by loading external changes from disk.
  ///
  /// If an asset of type [ContentStoreItem] is manually added, then this method must be called in order to see the changes in the result of [getLocalContentList].
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  @Deprecated('Use refresh instead.')
  static void refreshContentStore() {
    refresh();
  }

  /// Refresh the content store by loading external changes from disk.
  ///
  /// If an asset of type [ContentStoreItem] is manually added, then this method must be called in order to see the changes in the result of [getLocalContentList].
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void refresh() {
    objectMethod(0, 'ContentStore', 'refreshContentStore');
  }

  /// Set parallel downloads count.
  ///
  /// The default value is 3.
  ///
  /// **Parameters**
  ///
  /// * **IN** *count* The number of parallel downloads
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void setParallelDownloadsLimit(final int count) {
    objectMethod(0, 'ContentStore', 'setParallelDownloadsLimit', args: count);
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
      'ContentStore',
      'getTransferStatistics',
    );

    return TransferStatistics.init(resultString['result']);
  }
}
