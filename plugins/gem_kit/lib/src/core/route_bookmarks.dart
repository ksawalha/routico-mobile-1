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
import 'package:gem_kit/routing.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Route bookmarks class
///
/// Create an instance using [RouteBookmarks.create] method
///
/// {@category Routes & Navigation}
class RouteBookmarks extends GemAutoreleaseObject {
  // ignore: unused_element
  RouteBookmarks._() : _pointerId = -1;

  @internal
  RouteBookmarks.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Add a new route / update existing.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* The new route name, must be unique. If a route with this name already exists, [GemError.exist] is returned.
  /// * **IN** *waypoints* [Route] waypoints list.
  /// * **IN** *preferences* [Route] preferences.
  /// * **IN** *overwrite* Overwrite route if name already exists.
  ///
  /// If a route with given name already exists and overwrite = true, the existing route is updated.
  ///
  /// Only route relevant preferences are saved: transport mode + avoid preferences.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void add(
    final String name,
    final List<Landmark> waypoints, {
    final RoutePreferences? preferences,
    final bool overwrite = false,
  }) {
    final LandmarkList landmarkList = LandmarkList.fromList(waypoints);

    objectMethod(
      _pointerId,
      'RouteBookmarks',
      'add',
      args: <String, dynamic>{
        'name': name,
        'waypoints': landmarkList.pointerId,
        if (preferences != null) 'preferences': preferences,
        'overwrite': overwrite,
      },
    );
  }

  /// Add trips from the given filename.
  ///
  /// **Parameters**
  ///
  /// * **IN** *filename* The imported bookmarks file path.
  ///
  /// **Returns**
  ///
  /// * The number of imported routes on success.
  /// * [GemError.invalidInput].code if the import failed
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int addTrips(final String filename) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBookmarks',
      'addTrips',
      args: filename,
    );

    return resultString['result'];
  }

  /// Clear all routes bookmarks.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void clear() {
    objectMethod(_pointerId, 'RouteBookmarks', 'clear');
  }

  /// Export the route to the given file.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The route index to be exported.
  /// * **IN** *path* The file path where the route will be exported
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.notFound] if the route is not found
  /// * [GemError.io] if the file cannot be created
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError exportToFile(final int index, final String path) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBookmarks',
      'exportToFile',
      args: <String, Object>{'index': index, 'path': path},
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Find a trip by name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* The route name.
  ///
  /// **Returns**
  ///
  /// * On success - the route index in current sort order (non negative).
  /// * [GemError.internalAbort].code if query failed
  /// * [GemError.notFound].code if the route is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int find(final String name) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBookmarks',
      'find',
      args: name,
    );

    return resultString['result'];
  }

  /// Get auto delete mode.
  ///
  /// If auto delete mode is true, the database if automatically deleted when object is destroyed.
  ///
  /// Default is false.
  ///
  /// **Returns**
  ///
  /// * The auto delete mode
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get autoDeleteMode {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBookmarks',
      'getAutoDeleteMode',
    );

    return resultString['result'];
  }

  /// Get bookmarks collection path.
  ///
  /// **Returns**
  ///
  /// * The path of the bookmarks collection.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get filePath {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBookmarks',
      'getFilePath',
    );

    return resultString['result'];
  }

  /// Get name of the route specified by index.
  ///
  /// [Route] name is the unique identifier of a route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The index of the route in the current sort order.
  ///
  /// **Returns**
  ///
  /// * The route name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  String getName(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBookmarks',
      'getName',
      args: index,
    );

    return resultString['result'];
  }

  /// Get preferences of the route specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The index of the route in the current sort order.
  ///
  /// **Returns**
  ///
  /// * The route preferences
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RoutePreferences? getPreferences(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBookmarks',
      'getPreferences',
      args: index,
    );

    if (resultString['result']['isValid'] == false) {
      return null;
    }

    return RoutePreferences.fromJson(resultString['result']);
  }

  /// Get number of routes.
  ///
  /// **Returns**
  ///
  /// * The number of routes in the collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get size {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBookmarks',
      'size',
    );

    return resultString['result'];
  }

  /// Get timestamp of the route specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The index of the route in the current sort order.
  ///
  /// **Returns**
  ///
  /// * The route timestamp
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DateTime getTimestamp(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBookmarks',
      'getTimestamp',
      args: index,
    );

    return DateTime.fromMillisecondsSinceEpoch(
      resultString['result'],
      isUtc: true,
    );
  }

  /// Get waypoints of the route specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The index of the route in the current sort order.
  ///
  /// **Returns**
  ///
  /// * The route waypoints
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> getWaypoints(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'RouteBookmarks',
      'getWaypoints',
      args: index,
    );

    return LandmarkList.init(resultString['result']).toList();
  }

  /// Remove the item at the specified index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The route index to be removed.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void remove(final int index) {
    objectMethod(_pointerId, 'RouteBookmarks', 'remove', args: index);
  }

  /// Set auto delete mode.
  ///
  /// **Parameters**
  ///
  /// * **IN** *mode* The Auto-delete mode.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set autoDeleteMode(final bool mode) {
    objectMethod(_pointerId, 'RouteBookmarks', 'setAutoDeleteMode', args: mode);
  }

  /// Change the sort order of the routes.
  ///
  /// Default order is [RouteBookmarksSortOrder.sortByDate]. UI needs to refresh the list.
  ///
  /// Needs to be set after routes have been added in order to sort accordingly
  ///
  /// **Parameters**
  ///
  /// * **IN** *order* The new sort order
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set sortOrder(final RouteBookmarksSortOrder order) {
    objectMethod(_pointerId, 'RouteBookmarks', 'setSortOrder', args: order.id);
  }

  /// Update a route
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The index of the route in the current sort order.
  /// * **IN** *name* The new route name, must be unique. If a route with this name already exists the update fails.
  /// * **IN** *waypoints* [Route] waypoints list.
  /// * **IN** *preferences* [Route] preferences.
  ///
  /// Only route relevant preferences are saved: transport mode + avoid preferences.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void update(
    final int index, {
    final String? name,
    final List<Landmark>? waypoints,
    final RoutePreferences? preferences,
  }) {
    final LandmarkList landmarkList =
        waypoints == null ? LandmarkList() : LandmarkList.fromList(waypoints);

    objectMethod(
      _pointerId,
      'RouteBookmarks',
      'update',
      args: <String, dynamic>{
        'index': index,
        if (name != null) 'name': name,
        'waypoints': landmarkList.pointerId,
        if (preferences != null) 'preferences': preferences,
      },
    );
  }

  /// Creates a new [RouteBookmarks] object based on a path
  static RouteBookmarks create(final String name) {
    final String encodedVal = jsonEncode(<String, String>{
      'class': 'RouteBookmarks',
      'args': name,
    });
    final String resultString = GemKitPlatform.instance.callCreateObject(
      encodedVal,
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return RouteBookmarks.init(decodedVal['result']);
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(
            <String, Object>{'class': 'RouteBookmarks', 'id': _pointerId}),
      );
}

/// Enumeration used to specify the sort order of the routes
///
/// {@category Routes & Navigation}
enum RouteBookmarksSortOrder {
  /// Sort descending by update time (most recent at top).
  sortByDate,

  /// Sort ascending by name.
  sortByName,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension RouteBookmarksSortOrderExtension on RouteBookmarksSortOrder {
  int get id {
    switch (this) {
      case RouteBookmarksSortOrder.sortByDate:
        return 0;
      case RouteBookmarksSortOrder.sortByName:
        return 1;
    }
  }

  static RouteBookmarksSortOrder fromId(final int id) {
    switch (id) {
      case 0:
        return RouteBookmarksSortOrder.sortByDate;
      case 1:
        return RouteBookmarksSortOrder.sortByName;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}
