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

import 'package:flutter/material.dart';
import 'package:gem_kit/src/core/coordinates.dart';
import 'package:gem_kit/src/core/extensions.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/geographic_area.dart';
import 'package:gem_kit/src/core/landmark.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Path collection class
///
/// This class should not be instantiated directly. Instead, use the [MapViewPreferences.paths] getter to obtain an instance.
///
/// {@category Core}
class MapViewPathCollection extends GemAutoreleaseObject {
  // ignore: unused_element
  MapViewPathCollection._()
      : _pointerId = -1,
        _mapId = -1;

  @internal
  MapViewPathCollection.init(final int id, final int mapId)
      : _pointerId = id,
        _mapId = mapId {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  /// Add a path to the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *path* The path to be added.
  /// * **IN** *colorBorder* The border color of the path. By default the one from the current map view style is used.
  /// * **IN** *colorInner* The inner color of the path. By default the one from the current map view style is used.
  /// * **IN** *szBorder* The border size of the path in mm. If < 0 the one from the current map view style is used.
  /// * **IN** *szInner* The inner size of the path in mm. If < 0 the one from the current map view style is used.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void add(
    final Path path, {
    final Color colorBorder = const Color(0x00000000),
    final Color colorInner = const Color(0x00000000),
    final double szBorder = -1,
    final double szInner = -1,
  }) {
    objectMethod(
      _pointerId,
      'MapViewPathCollection',
      'add',
      args: <String, Object>{
        'path': path.pointerId,
        'colorBorder': colorBorder.toRgba(),
        'colorInner': colorInner.toRgba(),
        'szBorder': szBorder,
        'szInner': szInner,
      },
    );
  }

  /// Remove all paths from the collection.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void clear() {
    objectMethod(_pointerId, 'MapViewPathCollection', 'clear');
  }

  /// Get the border color for the path specified by index.
  ///
  /// If the result is [Colors.transparent], then the index does not exist in the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The path index
  ///
  /// **Returns**
  ///
  /// * The border color
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Color getBorderColorAt(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPathCollection',
      'getBorderColorAt',
      args: index,
    );

    return ColorExtension.fromJson(resultString['result']);
  }

  /// Get the border size for the path specified by index.
  ///
  /// If the result is -1, then the index does not exist in the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The path index
  ///
  /// **Returns**
  ///
  /// * The border size
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double getBorderSizeAt(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPathCollection',
      'getBorderSizeAt',
      args: index,
    );
    return resultString['result'];
  }

  /// Get the fill color for the path specified by index.
  ///
  /// If the result is [Colors.transparent], then the index does not exist in the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The path index
  ///
  /// **Returns**
  ///
  /// * The inner color
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Color getFillColorAt(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPathCollection',
      'getFillColorAt',
      args: index,
    );

    return ColorExtension.fromJson(resultString['result']);
  }

  /// Get the inner size for the path specified by index.
  ///
  /// If the result is -1, then the index does not exist in the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The path index
  ///
  /// **Returns**
  ///
  /// * The inner size
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double getInnerSizeAt(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPathCollection',
      'getInnerSizeAt',
      args: index,
    );

    return resultString['result'];
  }

  /// Get the path specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The path index
  ///
  /// **Returns**
  ///
  /// * The path
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Path? getPathAt(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPathCollection',
      'getPathAt',
      args: index,
    );

    if (resultString['result'] == -1) {
      return null;
    }
    return Path.init(resultString['result']);
  }

  /// Get the path specified by name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* The path name
  ///
  /// **Returns**
  ///
  /// * The path
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Path? getPathByName(final String name) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPathCollection',
      'getPathByName',
      args: name,
    );

    if (resultString['result'] == -1) {
      return null;
    }
    return Path.init(resultString['result']);
  }

  /// Get the number of paths in this collection.
  ///
  /// **Returns**
  ///
  /// * The number of paths
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get size {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPathCollection',
      'size',
    );

    return resultString['result'];
  }

  /// Remove the path from the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *path* The path to be removed
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void remove(final Path path) {
    objectMethod(
      _pointerId,
      'MapViewPathCollection',
      'remove',
      args: path.pointerId,
    );
  }

  /// Remove the path specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The path index
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void removeAt(final int index) {
    objectMethod(_pointerId, 'MapViewPathCollection', 'removeAt', args: index);
  }

  /// Hit test in path collection.
  ///
  /// Checks for paths within the given area.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area* The [RectangleGeographicArea] where to search for paths.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.s
  List<PathMatch> hitTest(final RectangleGeographicArea area) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewPathCollection',
      'hitTest',
      args: area,
    );

    return resultString['result']
        .map<PathMatch>((final dynamic e) => PathMatch.fromJson(e))
        .toList();
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, Object>{
          'class': 'MapViewPathCollection',
          'id': _pointerId,
        }),
      );
}

/// Path import supported formats.
///
/// {@category Core}
enum PathFileFormat {
  /// GPX
  gpx,

  /// KML
  kml,

  /// NMEA
  nmea,

  /// GeoJSON
  geoJson,

  /// Latitude, Longitude lines in txt file (debug purposes)
  latLonTxt,

  /// Longitude, Latitude lines in txt file (debug purposes)
  lonLatTxt,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Core}
extension PathFileFormatExtension on PathFileFormat {
  int get id {
    switch (this) {
      case PathFileFormat.gpx:
        return 0;
      case PathFileFormat.kml:
        return 1;
      case PathFileFormat.nmea:
        return 2;
      case PathFileFormat.geoJson:
        return 3;
      case PathFileFormat.latLonTxt:
        return 4;
      case PathFileFormat.lonLatTxt:
        return 5;
    }
  }

  static PathFileFormat fromId(final int id) {
    switch (id) {
      case 0:
        return PathFileFormat.gpx;
      case 1:
        return PathFileFormat.kml;
      case 2:
        return PathFileFormat.nmea;
      case 3:
        return PathFileFormat.geoJson;
      case 4:
        return PathFileFormat.latLonTxt;
      case 5:
        return PathFileFormat.lonLatTxt;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Path class
///
/// {@category Core}
class Path extends GemAutoreleaseObject {
  // ignore: unused_element
  Path._() : _pointerId = -1;

  @internal
  Path.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Clone reverse order path. Does not change the original path.
  ///
  /// **Returns**
  ///
  /// * The reversed path
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Path cloneReverse() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Path',
      'cloneReverse',
    );

    return Path.init(resultString['result']);
  }

  /// Clone path from the given coordinates.
  ///
  /// Set start = end to create a circuit track.
  ///
  /// **Parameters**
  ///
  /// * **IN** *start* The start coordinates
  /// * **IN** *end* Field coordinates
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Path cloneStartEnd(final Coordinates start, final Coordinates end) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Path',
      'cloneStartEnd',
      args: <String, Coordinates>{'first': start, 'second': end},
    );

    return Path.init(resultString['result']);
  }

  /// Export path coordinates in the requested data format.
  ///
  /// **Parameters**
  ///
  /// * **IN** *format* Data format, see [PathFileFormat].
  ///
  /// **Returns**
  ///
  /// * The string with the exported data.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String exportAs(final PathFileFormat pathFileFormat) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Path',
      'exportAs',
      args: pathFileFormat.id,
    );

    final String encodedResult = resultString['result'];
    final Uint8List resultAsUint8List = base64Decode(encodedResult);
    final String result = utf8.decode(resultAsUint8List);

    return result;
  }

  /// Get path rectangle.
  ///
  /// **Returns**
  ///
  /// * The path rectangle, [RectangleGeographicArea] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea get area {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Path',
      'getArea',
    );

    return RectangleGeographicArea.fromJson(resultString['result']);
  }

  /// Get read-only access to the internal coordinates list.
  ///
  /// **Returns**
  ///
  /// * The coordinates list
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Coordinates> get coordinates {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Path',
      'getCoordinates',
    );

    final List<dynamic> listJson = resultString['result'];
    final List<Coordinates> retList = listJson
        .map((final dynamic categoryJson) => Coordinates.fromJson(categoryJson))
        .toList();
    return retList;
  }

  /// Get a coordinate along the path given by a fraction of the path length between 0.0 (departure point) and 1.0 (destination).
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The path coordinates list.
  /// * **IN** *percent* The size percent (fraction) in the range {0, 1}, e.g. 0.5 will return the coordinates of the point in the middle of the path.
  ///
  /// **Returns**
  ///
  /// * The coordinates at the given percent
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static Coordinates getCoordinatesAtPercent(
    final List<Coordinates> coords,
    final double percent,
  ) {
    final OperationResult resultString = objectMethod(
      0,
      'Path',
      'getCoordinatesAtPercent',
      args: <String, Object>{'coords': coords, 'percent': percent},
    );

    return Coordinates.fromJson(resultString['result']);
  }

  /// Get path name.
  ///
  /// **Returns**
  ///
  /// * The path name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Path',
      'getName',
    );

    return resultString['result'];
  }

  /// Get read-only access to the internal waypoint list.
  ///
  /// **Returns**
  ///
  /// * The waypoint list
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<int> get wayPoints {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Path',
      'getWayPoints',
    );

    final List<int> listJson = (resultString['result'] as List<dynamic>)
        .map((final dynamic item) => item as int)
        .toList();
    return listJson;
  }

  /// Set path name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* The path name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set name(final String name) {
    objectMethod(_pointerId, 'Path', 'setName', args: name);
  }

  /// Create a path from a data buffer of a given format.
  ///
  /// **Parameters**
  /// * **IN** *data* The data buffer
  /// * **IN** *format* The data format
  static Path create({
    required final Uint8List data,
    final PathFileFormat format = PathFileFormat.gpx,
  }) {
    final dynamic nativeBuffer = GemKitPlatform.instance.toNativePointer(data);
    final dynamic resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, Object>{
        'class': 'Path',
        'args': <String, dynamic>{
          'data': nativeBuffer.address,
          'dataLength': data.length,
          'format': format.id,
        },
      }),
    );
    GemKitPlatform.instance.freeNativePointer(nativeBuffer);
    final dynamic decodedVal = jsonDecode(resultString);

    return Path.init(decodedVal['result']);
  }

  /// Create a path from a list of coordinates.
  ///
  /// **Parameters**
  /// * **IN** *coord* List of coordinates
  static Path fromCoordinates(final List<Coordinates> coords) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, Object>{
        'class': 'Path',
        'args': <String, dynamic>{'coords': coords},
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);

    return Path.init(decodedVal['result']);
  }

  /// Create a new landmark list from a path.
  ///
  /// **Returns**
  ///
  /// * The landmark list
  List<Landmark> toLandmarkList() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Path',
      'toLandmarkList',
    );

    return LandmarkList.init(resultString['result']).toList();
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, dynamic>{'class': 'Path', 'id': _pointerId}),
    );
  }
}

class PathMatch {
  PathMatch({
    required this.path,
    required this.coords,
    required this.distance,
    required this.segment,
  });

  factory PathMatch.fromJson(Map<String, dynamic> json) {
    return PathMatch(
      path: json['path'],
      coords: Coordinates.fromJson(json['coords']),
      distance: json['distance'],
      segment: json['segment'],
    );
  }

  /// Matched path index in the path collection.
  int path;

  /// Path matched position coordinates.
  Coordinates coords;

  /// Distance to matched position in meters.
  int distance;

  /// Path matched segment.
  int segment;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'path': path,
      'coords': coords.toJson(),
      'distance': distance,
      'segment': segment,
    };
  }

  @override
  bool operator ==(covariant PathMatch other) {
    if (identical(this, other)) {
      return true;
    }
    return path == other.path &&
        coords == other.coords &&
        distance == other.distance &&
        segment == other.segment;
  }

  @override
  int get hashCode =>
      path.hashCode ^ coords.hashCode ^ distance.hashCode ^ segment.hashCode;
}
