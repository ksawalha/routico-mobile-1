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
import 'dart:typed_data';

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/landmarkstore/landmark_browse_session.dart';
import 'package:meta/meta.dart';

/// Landmark store class
///
/// This class should not be instantiated directly. Instead, use the related methods from [LandmarkStoreService] to obtain an instance.
///
/// {@category Places}
class LandmarkStore extends GemAutoreleaseObject {
  // ignore: unused_element
  LandmarkStore._()
      : _pointerId = -1,
        _mapId = -1;

  @internal
  LandmarkStore.init(final int id, final int mapId)
      : _pointerId = id,
        _mapId = mapId {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;
  final int _mapId;
  static const int uncategorizedLandmarkCategId = -1;
  static const int invalidLandmarkCategId = -2;
  int get pointerId => _pointerId;
  int get mapId => _mapId;

  /// Add a new category to the store.
  ///
  /// After this method call, the category object that is passed as a parameter belongs to this landmark store. The category must have a name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *category* The category to be added
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void addCategory(final LandmarkCategory category) {
    objectMethod(
      _pointerId,
      'LandmarkStore',
      'addCategory',
      args: category.pointerId,
    );
  }

  /// Add a landmark to the specified category in the landmark store.
  ///
  /// If the landmark already exists in the landmark store, only the category info is updated.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmark*	The landmark to be added to the landmark store in the specified category.
  /// * **IN** *categoryId*	The ID of the category where the landmark will be added.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void addLandmark(
    final Landmark landmark, {
    final int categoryId = LandmarkStore.uncategorizedLandmarkCategId,
  }) {
    objectMethod(
      _pointerId,
      'LandmarkStore',
      'addLandmark',
      args: <String, dynamic>{
        'landmark': landmark.pointerId,
        'categoryId': categoryId,
      },
    );
  }

  /// Get the specified landmark.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkId*	The landmark id.
  ///
  /// **Returns**
  ///
  /// * The Landmark object if found, null otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Landmark? getLandmark(final int landmarkId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'getLandmark',
      args: landmarkId,
    );

    if (resultString['gemApiError'] == -11) {
      return null;
    }

    return Landmark.init(resultString['result']);
  }

  /// Update the information about a landmark.
  ///
  /// This updates only the information about a landmark and does not modify the categories the landmark belongs to.
  /// The landmark instance passed in as the parameter must be an instance that belongs to this landmark store.
  /// Calling this method updates the timestamp of the landmark.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmark* The landmark to be updated.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void updateLandmark(final Landmark landmark) {
    objectMethod(
      _pointerId,
      'LandmarkStore',
      'updateLandmark',
      args: landmark.pointerId,
    );
  }

  /// Checks if the landmark store contains the landmark ID
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkId* The id of the landmark looked for
  ///
  /// **Returns**
  ///
  /// * True if the landmark is in the landmark store, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool containsLandmark(final int landmarkId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'containsLandmark',
      args: landmarkId,
    );

    return resultString['result'];
  }

  /// Get the list of all categories.
  ///
  /// **Returns**
  ///
  /// * The list of categories
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<LandmarkCategory> get categories {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'getCategories',
    );

    return LandmarkCategoryList.init(resultString['result']).toList();
  }

  /// Get the list of categories for the specified landmark.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkId* The id of the landmark.
  ///
  /// **Returns**
  ///
  /// * The list of categories
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<LandmarkCategory> getCategoriesFromLandmark(int landmarkId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'getCategoriesFromLandmark',
      args: landmarkId,
    );

    return LandmarkCategoryList.init(resultString['result']).toList();
  }

  /// Get the category by ID.
  ///
  /// **Parameters**
  ///
  /// * **IN** *categoryId* The category ID
  ///
  /// **Returns**
  ///
  /// * The category if found, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  LandmarkCategory? getCategoryById(final int categoryId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'getCategoryById',
      args: categoryId,
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return LandmarkCategory.init(resultString['result']);
  }

  /// Get the ID of the landmark store.
  ///
  /// **Returns**
  ///
  /// * The landmark store ID
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get id {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'getId',
    );

    return resultString['result'];
  }

  /// Get the landmarks within the specified category.
  ///
  /// **Parameters**
  ///
  /// * **IN** *categoryId*	The category id for which landmarks are retrieved (default LandmarkCategory.invalidLandmarkCategId, meaning all categories).
  ///
  /// If the category ID is LandmarkCategory.uncategorizedLandmarkCategId, all uncategorized landmarks are retrieved.
  /// If the category ID is LandmarkCategory.invalidLandmarkCategId, all landmarks are retrieved.
  ///
  /// **Returns**
  ///
  /// * The landmark list.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> getLandmarks({
    final int categoryId = LandmarkStore.invalidLandmarkCategId,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'getLandmarks',
      args: categoryId,
    );

    return LandmarkList.init(resultString['result']).toList();
  }

  /// Get the landmarks within the specified area.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area*	The geographic area queried for landmarks.
  /// * **IN** *categoryId*	The category id for which landmarks are retrieved (default LandmarkCategory.invalidLandmarkCategId, meaning all categories).
  ///
  /// If the category ID is [uncategorizedLandmarkCategId], all uncategorized landmarks are retrieved.
  /// If the category ID is [invalidLandmarkCategId], all landmarks are retrieved.
  ///
  /// **Returns**
  ///
  /// * The landmark list corresponding to given criteria.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> getLandmarksInArea({
    final GeographicArea? area,
    final int categoryId = LandmarkStore.invalidLandmarkCategId,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'getLandmarksInArea',
      args: <String, dynamic>{
        'area': area ??
            RectangleGeographicArea(
                topLeft: Coordinates(), bottomRight: Coordinates()),
        'categoryId': categoryId
      },
    );

    return LandmarkList.init(resultString['result']).toList();
  }

  /// Create a landmarks browse session with the specified settings
  ///
  /// Shows only the landmarks added before the [LandmarkBrowseSession] was created
  ///
  /// **Parameters**
  ///
  /// * **IN** *settings* The settings for the landmarks browse session. If not specified, the default settings are used
  ///
  /// **Returns**
  ///
  /// * The landmarks browse session
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  LandmarkBrowseSession createLandmarkBrowseSession(
      {LandmarkBrowseSessionSettings? settings}) {
    settings ??= LandmarkBrowseSessionSettings();

    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'createLandmarkBrowseSession',
      args: settings,
    );

    return LandmarkBrowseSession.init(resultString['result']);
  }

  /// Get the landmark store name.
  ///
  /// **Returns**
  ///
  /// * The landmark store name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'getName',
    );

    return resultString['result'];
  }

  /// Get the type of the landmark store.
  ///
  /// **Returns**
  ///
  /// * The landmark store type
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  LandmarkStoreType get type {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'getType',
    );

    return LandmarkStoreTypeExtension.fromId(resultString['result']);
  }

  /// Remove the specified category.
  ///
  /// **Parameters**
  ///
  /// * **IN** *categoryId*	The category ID.
  /// * **IN** *removeLmkContent*	Request to remove all landmarks belonging to the category.
  ///
  /// If removeLmkContent is false, the landmarks belonging to the category are marked uncategorized.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void removeCategory(
    final int categoryId, {
    final bool removeLmkContent = false,
  }) {
    objectMethod(
      _pointerId,
      'LandmarkStore',
      'removeCategory',
      args: <String, Object>{
        'categoryId': categoryId,
        'removeLmkContent': removeLmkContent,
      },
    );
  }

  /// Remove the specified landmark.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmark* The landmark to be removed
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void removeLandmark(final Landmark landmark) {
    objectMethod(
      _pointerId,
      'LandmarkStore',
      'removeLandmark',
      args: landmark.pointerId,
    );
  }

  /// Get the number of all landmarks within the specified category.
  ///
  /// If the category ID is [uncategorizedLandmarkCategId], the uncategorized landmarks count is returned.
  ///
  /// If the category ID is [invalidLandmarkCategId], the total landmarks count is returned.
  ///
  /// **Parameters**
  ///
  /// * **IN** *categoryId* The category ID
  ///
  /// **Returns**
  ///
  /// * The number of landmarks
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int getLandmarkCount(
      {int categoryId = LandmarkStore.invalidLandmarkCategId}) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'getLandmarkCount',
      args: categoryId,
    );

    return resultString['result'];
  }

  /// Update the specified category.
  ///
  /// The category object must belong to this landmark store. No fields of the parameter will be updated by this call.
  ///
  /// **Parameters**
  ///
  /// * **IN** *category* The category to be updated
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void updateCategory(final LandmarkCategory category) {
    objectMethod(
      _pointerId,
      'LandmarkStore',
      'updateCategory',
      args: category.pointerId,
    );
  }

  /// Set landmark category id
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkId* The landmark ID
  /// * **IN** *categoryId* The category ID
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setLandmarkCategory(final Landmark landmark, final int categoryId) {
    objectMethod(
      _pointerId,
      'LandmarkStore',
      'setLandmarkCategory',
      args: <String, int>{'first': landmark.pointerId, 'second': categoryId},
    );
  }

  /// Asynchronously import landmarks from given file format
  ///
  /// **Parameters**
  ///
  /// * **IN** *filePath* The file path
  /// * **IN** *format*	The file format, see [LandmarkFileFormat].
  /// * **IN** *image* The landmark map image. If left empty, a default image is assigned
  /// * **IN** *onProgressUpdated* Callback that gets triggered with the associated progress when the update process is in progress.
  /// * **IN** *onCompleteCallback*	Callback that gets triggered with the associated [GemError] when the update process is completed.
  ///   * Is called with [GemError.success] if the operation suceeded
  ///   * Is called with [GemError.inUse] if an import is already in progress
  ///   * Is called with [GemError.notFound] if the file could not be opened or it the landmark store category id is invalid
  ///   * Is called with [GemError.cancel] if the operation was canceled
  ///   * Is called with [GemError.invalidInput] if the provided data could not be parsed
  /// * **IN** *categoryId*	The category for the new imported landmarks. The category must exist or use [uncategorizedLandmarkCategId] to set the landmark as uncategorized
  ///
  /// **Returns**
  ///
  /// * The associated [ProgressListener] if the request can be started, null otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  ProgressListener? importLandmarks({
    required String filePath,
    required LandmarkFileFormat format,
    required Img image,
    final void Function(GemError error)? onCompleteCallback,
    final void Function(int progress)? onProgressUpdated,
    int categoryId = uncategorizedLandmarkCategId,
  }) {
    final EventDrivenProgressListener progressListener =
        EventDrivenProgressListener();

    if (onCompleteCallback != null) {
      progressListener.registerOnCompleteWithDataCallback(
        (final int err, final String hint, final Map<dynamic, dynamic> json) =>
            onCompleteCallback(GemErrorExtension.fromCode(err)),
      );
    }

    if (onProgressUpdated != null) {
      progressListener.registerOnProgressCallback(onProgressUpdated);
    }

    GemKitPlatform.instance.registerEventHandler(
      progressListener.id,
      progressListener,
    );

    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'importLandmarks',
      args: <String, dynamic>{
        'path': filePath,
        'fileFormat': format.id,
        'image': image.pointerId,
        'categoryId': categoryId,
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

  /// Asynchronously import landmarks from given buffer format
  ///
  /// **Parameters**
  ///
  /// * **IN** *buffer* The data buffer.
  /// * **IN** *format*	The file format, see [LandmarkFileFormat].
  /// * **IN** *image* The landmark map image. If left empty, a default image is assigned
  /// * **IN** *onProgressUpdated* Callback that gets triggered with the associated progress when the update process is in progress.
  /// * **IN** *onCompleteCallback*	Callback that gets triggered with the associated [GemError] when the update process is completed.
  ///   * Is called with [GemError.success] if the operation suceeded
  ///   * Is called with [GemError.inUse] if an import is already in progress
  ///   * Is called with [GemError.notFound] if the landmark store category id is invalid
  ///   * Is called with [GemError.cancel] if the operation was canceled
  ///   * Is called with [GemError.invalidInput] if the provided data could not be parsed
  /// * **IN** *categoryId*	The category for the new imported landmarks. The category must exist or use [uncategorizedLandmarkCategId] to set the landmark as uncategorized
  ///
  /// **Returns**
  ///
  /// * The associated [ProgressListener] if the request can be started, null otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails to initialize.
  ProgressListener? importLandmarksWithDataBuffer({
    required Uint8List buffer,
    required LandmarkFileFormat format,
    required Img image,
    final void Function(GemError error)? onCompleteCallback,
    final void Function(int progress)? onProgressUpdated,
    int categoryId = uncategorizedLandmarkCategId,
  }) {
    final EventDrivenProgressListener progressListener =
        EventDrivenProgressListener();

    if (onCompleteCallback != null) {
      progressListener.registerOnCompleteWithDataCallback(
        (final int err, final String hint, final Map<dynamic, dynamic> json) =>
            onCompleteCallback(GemErrorExtension.fromCode(err)),
      );
    }

    if (onProgressUpdated != null) {
      progressListener.registerOnProgressCallback(onProgressUpdated);
    }

    GemKitPlatform.instance.registerEventHandler(
      progressListener.id,
      progressListener,
    );
    final dynamic dataBufferPointer =
        GemKitPlatform.instance.toNativePointer(buffer);
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'importLandmarksWithDataBuffer',
      args: <String, dynamic>{
        'dataBuffer': dataBufferPointer.address,
        'dataBufferSize': buffer.length,
        'fileFormat': format.id,
        'image': image.pointerId,
        'categoryId': categoryId,
        'listener': progressListener.id,
      },
    );
    GemKitPlatform.instance.freeNativePointer(dataBufferPointer);
    final GemError errorCode = GemErrorExtension.fromCode(
      resultString['result'],
    );

    if (errorCode != GemError.success) {
      onCompleteCallback?.call(errorCode);
      return null;
    }

    return progressListener;
  }

  /// Cancel async import landmarks operation
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void cancelImportLandmarks() {
    objectMethod(_pointerId, 'LandmarkStore', 'cancelImportLandmarks');
  }

  /// Get landmark store path.
  ///
  /// **Returns**
  ///
  /// * The landmark store path.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String getFilePath() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'getFilePath',
    );

    return resultString['result'];
  }

  /// Start landmark store fast update mode
  ///
  /// Fast update mode - allow fast insert, delete and update operations. This mode should be used with caution because if a power failure or process crash interrupts it, the database will likely be corrupted and will be deleted at next startup.
  ///
  /// This is intended for fast import of external landmarks into application format
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void startFastUpdateMode() {
    objectMethod(_pointerId, 'LandmarkStore', 'startFastUpdateMode');
  }

  /// Stop landmark store fast update mode.
  ///
  /// **Parameters**
  ///
  /// * **IN** *discard*  Discard fast update mode session changes. Default is false.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void stopFastUpdateMode({bool discard = false}) {
    objectMethod(
      _pointerId,
      'LandmarkStore',
      'stopFastUpdateMode',
      args: discard,
    );
  }

  /// Get fast update mode state.
  ///
  /// **Returns**
  ///
  /// * True if fast update mode is active, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool isFastUpdateMode() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'isFastUpdateMode',
    );

    return resultString['result'];
  }

  /// Get the landmark store image.
  ///
  /// **Returns**
  ///
  /// * The image of the landmark. The user is responsible to check if the image is valid.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Img get image {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'getImage',
    );

    return Img.init(resultString['result']);
  }

  /// Set the landmark store image.
  ///
  /// **Parameters**
  ///
  /// * **IN** *image*  The landmark store image.
  ///
  /// Setting a valid landmark store image will override individual items images, see [Landmark.getImage]
  ///
  /// Setting an empty landmark store image will restore individual items images, see [Landmark.getImage]
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError setImage(Img image) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkStore',
      'setImage',
      args: image.pointerId,
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Remove all landmarks from store.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void removeAllLandmarks() {
    objectMethod(_pointerId, 'LandmarkStore', 'removeAllLandmarks');
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(
          <String, dynamic>{'class': 'LandmarkStore', 'id': _pointerId},
        ),
      );
}

/// Landmark import supported formats
enum LandmarkFileFormat {
  /// Unknown format
  unknown,

  /// KML
  kml,

  /// GeoJson
  geoJson,
}

/// This class will not be documented.
///
/// @nodoc
extension LandmarkFileFormatExtension on LandmarkFileFormat {
  int get id {
    switch (this) {
      case LandmarkFileFormat.unknown:
        return 0;
      case LandmarkFileFormat.kml:
        return 1;
      case LandmarkFileFormat.geoJson:
        return 2;
    }
  }

  static LandmarkFileFormat fromId(final int id) {
    switch (id) {
      case 0:
        return LandmarkFileFormat.unknown;
      case 1:
        return LandmarkFileFormat.kml;
      case 2:
        return LandmarkFileFormat.geoJson;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Landmark store types
///
/// {@category Places}
enum LandmarkStoreType {
  /// No landmark store type.
  none,

  /// Plain landmark store.
  defaultType,

  /// Map address database (not listed as landmark store).
  ///
  /// This type is returned by a cursor selection in a MapView or by a search result
  /// Can be added to a landmark store collection ( e.g. MapViewPreferences, SearchPreferences, AlarmService )
  mapAddress,

  /// Map POIs landmark store
  mapPoi,

  /// Map cities database (not listed as landmark store)
  /// This type is returned by a cursor selection in a MapView or by a search result
  /// Can be added to a landmark store collection ( e.g. MapViewPreferences, SearchPreferences, AlarmService )
  mapCity,

  /// Map highway exits (not listed as landmark store)
  ///
  /// This type is returned by a cursor selection in a MapView or by a search result
  /// Can be added to a landmark store collection ( e.g. MapViewPreferences, SearchPreferences, AlarmService )
  mapHighwayExit,

  /// Map countries database (not listed as landmark store)
  /// This type is returned by a cursor selection in a MapView or by a search result
  /// Can be added to a landmark store collection ( e.g. MapViewPreferences, SearchPreferences, AlarmService )
  mapCountry,
}

/// @nodoc
///
/// {@category Places}
extension LandmarkStoreTypeExtension on LandmarkStoreType {
  int get id {
    switch (this) {
      case LandmarkStoreType.none:
        return 0;
      case LandmarkStoreType.defaultType:
        return 1;
      case LandmarkStoreType.mapAddress:
        return 2;
      case LandmarkStoreType.mapPoi:
        return 3;
      case LandmarkStoreType.mapCity:
        return 4;
      case LandmarkStoreType.mapHighwayExit:
        return 5;
      case LandmarkStoreType.mapCountry:
        return 6;
    }
  }

  static LandmarkStoreType fromId(final int id) {
    switch (id) {
      case 0:
        return LandmarkStoreType.none;
      case 1:
        return LandmarkStoreType.defaultType;
      case 2:
        return LandmarkStoreType.mapAddress;
      case 3:
        return LandmarkStoreType.mapPoi;
      case 4:
        return LandmarkStoreType.mapCity;
      case 5:
        return LandmarkStoreType.mapHighwayExit;
      case 6:
        return LandmarkStoreType.mapCountry;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}
