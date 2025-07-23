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
import 'package:gem_kit/map.dart';
import 'package:gem_kit/src/core/coordinates.dart';
import 'package:gem_kit/src/core/extensions.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/geographic_area.dart';
import 'package:gem_kit/src/core/images.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/core/types.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Marker labeling mode
///
/// {@category Maps & 3D Scene}
enum MarkerLabelingMode {
  /// None
  none,

  /// Label each marker item
  itemLabelVisible,

  /// Label marker groups
  groupLabelVisible,

  /// Text centered on the icon
  textCentered,

  /// Group label is centered on image
  groupCenter,

  /// Label fits the image
  fitImage,

  /// Icon is placed above the coordinates of the marker
  iconBottomCenter,

  /// Text above the icon
  textAbove,

  ///Text below the icon
  textBelow,
}

/// @nodoc
///
/// {@category Maps & 3D Scene}
extension MarkerLabelingModeExtension on MarkerLabelingMode {
  int get id {
    switch (this) {
      case MarkerLabelingMode.none:
        return 0;
      case MarkerLabelingMode.itemLabelVisible:
        return 1;
      case MarkerLabelingMode.groupLabelVisible:
        return 2;
      case MarkerLabelingMode.textCentered:
        return 4;
      case MarkerLabelingMode.groupCenter:
        return 8;
      case MarkerLabelingMode.fitImage:
        return 16;
      case MarkerLabelingMode.iconBottomCenter:
        return 32;
      case MarkerLabelingMode.textAbove:
        return 64;
      case MarkerLabelingMode.textBelow:
        return 128;
    }
  }

  static MarkerLabelingMode fromId(final int id) {
    switch (id) {
      case 0:
        return MarkerLabelingMode.none;
      case 1:
        return MarkerLabelingMode.itemLabelVisible;
      case 2:
        return MarkerLabelingMode.groupLabelVisible;
      case 4:
        return MarkerLabelingMode.textCentered;
      case 8:
        return MarkerLabelingMode.groupCenter;
      case 16:
        return MarkerLabelingMode.fitImage;
      case 32:
        return MarkerLabelingMode.iconBottomCenter;
      case 64:
        return MarkerLabelingMode.textAbove;
      case 128:
        return MarkerLabelingMode.textBelow;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Marker collection render settings
///
/// {@category Maps & 3D Scene}
class MarkerCollectionRenderSettings extends MarkerRenderSettings {
  MarkerCollectionRenderSettings({
    this.pointsGroupingZoomLevel = MarkerRenderSettings.defaultMembersValue,
    this.lowDensityPointsGroupImage,
    this.mediumDensityPointsGroupImage,
    this.highDensityPointsGroupImage,
    this.polylineTexture,
    this.polygonTexture,
    this.lowDensityPointsGroupMaxCount = defaultLowGCount,
    this.mediumDensityPointsGroupMaxCount = defaultMedGCount,
    this.labelGroupTextColor = MarkerRenderSettings.defaultColor,
    this.labelGroupTextSize = 2,
    this.buildPointsGroupConfig = false,
    super.image,
    super.imageSize = -1.0,
    super.labelingMode,
    super.labelTextSize = MarkerRenderSettings.defaultLabelTextSize,
    super.labelTextColor = const Color.fromARGB(0, 84, 71, 71),
    super.polylineInnerColor = MarkerRenderSettings.defaultColor,
    super.polylineOuterColor = MarkerRenderSettings.defaultColor,
    super.polygonFillColor = MarkerRenderSettings.defaultColor,
    super.polylineInnerSize = MarkerRenderSettings.defaultPolylineInnerSize,
    super.polylineOuterSize = MarkerRenderSettings.defaultPolylineOuterSize,
  }) {
    lowDensityPointsGroupImage ??= GemImage(
      imageId: MarkerRenderSettings.defaultMembersValue,
    );
    mediumDensityPointsGroupImage ??= GemImage(
      imageId: MarkerRenderSettings.defaultMembersValue,
    );
    highDensityPointsGroupImage ??= GemImage(
      imageId: MarkerRenderSettings.defaultMembersValue,
    );
    polygonTexture ??= GemImage(
      imageId: MarkerRenderSettings.defaultMembersValue,
    );
    polylineTexture ??= GemImage(
      imageId: MarkerRenderSettings.defaultMembersValue,
    );
    image ??= GemImage(imageId: MarkerRenderSettings.defaultMembersValue);
  }

  /// The zoom level at which points grouping is enabled.
  int pointsGroupingZoomLevel;

  /// The image for rendering low density points groups
  GemImage? lowDensityPointsGroupImage = GemImage(
    imageId: MarkerRenderSettings.defaultMembersValue,
  );

  /// The maximum number of items in a low density points group.
  ///
  /// If the group items are less than or equal to this value, the lowDensityPointsGroupImage is used for displaying the group.
  int lowDensityPointsGroupMaxCount;

  /// The image for rendering medium density points groups
  GemImage? mediumDensityPointsGroupImage = GemImage(
    imageId: MarkerRenderSettings.defaultMembersValue,
  );

  /// The maximum number of items in a medium density points group.
  ///
  /// If the group items are less than or equal to this value, the mediumDensityPointsGroupImage is used for displaying the group.
  int mediumDensityPointsGroupMaxCount;

  /// The image for rendering high density points groups
  GemImage? highDensityPointsGroupImage = GemImage(
    imageId: MarkerRenderSettings.defaultMembersValue,
  );

  /// The text color for group labels.
  ///
  /// Default value is obtained from the current style
  Color labelGroupTextColor;

  /// The text size for group labels in mm.
  ///
  /// Default value is kDefGroupTextSize.
  double labelGroupTextSize;

  /// Flag indicating whether to build points group configuration. Default value is false.
  ///
  /// If enabled, the user can access the marker -> points group relation, i.e. identify the points group head marker for every marker in the collection.
  bool buildPointsGroupConfig;

  /// The texture for polylines. Default value is none.
  ///
  /// The polyline texture will be blended with the polylineInnerColor value. User must set polylineInnerColor to Rgba::white() in order to preserve original texture colors.
  GemImage? polylineTexture = GemImage(
    imageId: MarkerRenderSettings.defaultMembersValue,
  );

  /// The texture for polygons. Default value is none.
  ///
  /// The polygon texture will be blended with the polygonFillColor value. User must set polygonFillColor to Rgba::white() in order to preserve original texture colors.
  GemImage? polygonTexture = GemImage(
    imageId: MarkerRenderSettings.defaultMembersValue,
  );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['groupingLevel'] = pointsGroupingZoomLevel;
    if (lowDensityPointsGroupImage != null) {
      json['lowDensityGroupImage'] = lowDensityPointsGroupImage;
    }
    json['lowGroupMaxCount'] = lowDensityPointsGroupMaxCount;
    if (mediumDensityPointsGroupImage != null) {
      json['mediumDensityGroupImage'] = mediumDensityPointsGroupImage;
    }
    json['mediumGroupMaxCount'] = mediumDensityPointsGroupMaxCount;
    if (highDensityPointsGroupImage != null) {
      json['highDensityGroupImage'] = highDensityPointsGroupImage;
    }
    json['groupLabelTextColor'] = labelGroupTextColor.toRgba();
    json['groupLabelTextSize'] = labelGroupTextSize;
    json['buildGroupConfig'] = buildPointsGroupConfig;
    if (polylineTexture != null) {
      json['polylineTexture'] = polylineTexture;
    }
    if (polygonTexture != null) {
      json['polygonTexture'] = polygonTexture;
    }
    if (image != null) {
      json['image'] = image;
    }
    json['polylineInnerColor'] = polylineInnerColor.toRgba();
    json['polylineOuterColor'] = polylineOuterColor.toRgba();
    json['polygonFillColor'] = polygonFillColor.toRgba();
    json['labelTextColor'] = labelTextColor.toRgba();
    if (imagePointer != null) {
      json['imagePointer'] = imagePointer;
    }
    if (imagePointerSize != null) {
      json['imagePointerSize'] = imagePointerSize;
    }

    json['imageSize'] = imageSize;
    json['labelingMode'] = packedLabelingMode;
    json['labelTextSize'] = labelTextSize;
    json['labelTextColor'] = labelTextColor.toRgba();
    json['hashCode'] = json.hashCode;
    json['polylineInnerSize'] = polylineInnerSize;
    json['polylineOuterSize'] = polylineOuterSize;
    return json;
  }

  /// The default maximum number of items in a low density points group.
  static const int defaultLowGCount = 50;

  /// The default maximum number of items in a medium density points group.
  static const int defaultMedGCount = 300;
}

/// Marker custom rendering information
///
/// {@category Maps & 3D Scene}
class MarkerCustomRenderData {
  MarkerCustomRenderData({this.pointsGroupCount});

  factory MarkerCustomRenderData.fromJson(final Map<String, dynamic> json) {
    return MarkerCustomRenderData(pointsGroupCount: json['pointsGroupCount']);
  }

  /// Grouped markers count
  ///
  /// A value > 1 means that the marker is the header of a points group containing pointsGroupCount markers
  int? pointsGroupCount;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    if (pointsGroupCount != null) {
      json['pointsGroupCount'] = pointsGroupCount;
    }
    return json;
  }
}

/// Marker type
///
/// {@category Maps & 3D Scene}
enum MarkerType {
  /// Multi-point marker
  point,

  /// Polyline marker
  polyline,

  /// Polygon marker
  polygon,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension MarkerTypeExtension on MarkerType {
  int get id {
    switch (this) {
      case MarkerType.point:
        return 0;
      case MarkerType.polyline:
        return 1;
      case MarkerType.polygon:
        return 2;
    }
  }

  static MarkerType fromId(final int id) {
    switch (id) {
      case 0:
        return MarkerType.point;
      case 1:
        return MarkerType.polyline;
      case 2:
        return MarkerType.polygon;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Marker match type
///
/// {@category Maps & 3D Scene}
enum MarkerMatchType {
  /// None
  none,

  /// Match on a coordinate
  coordinate,

  /// Match on a coordinate group
  coordinateGroup,

  /// Match on marker contour ( for polyline and polygon types )
  contour,

  /// Match inside marker ( for polygon types )
  inside,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension MarkerMatchTypeExtension on MarkerMatchType {
  int get id {
    switch (this) {
      case MarkerMatchType.none:
        return 0;
      case MarkerMatchType.coordinate:
        return 1;
      case MarkerMatchType.coordinateGroup:
        return 2;
      case MarkerMatchType.contour:
        return 3;
      case MarkerMatchType.inside:
        return 4;
    }
  }

  static MarkerMatchType fromId(final int id) {
    switch (id) {
      case 0:
        return MarkerMatchType.none;
      case 1:
        return MarkerMatchType.coordinate;
      case 2:
        return MarkerMatchType.coordinateGroup;
      case 3:
        return MarkerMatchType.contour;
      case 4:
        return MarkerMatchType.inside;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Marker
///
/// {@category Maps & 3D Scene}
class Marker extends GemAutoreleaseObject {
  factory Marker() {
    return Marker._create(0);
  }

  @internal
  Marker.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(id);
  }

  final dynamic _pointerId;

  dynamic get pointerId => _pointerId;

  /// Add a new coordinate to the marker.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The coordinate to be added.
  /// * **IN** *index* The position where the coordinate is added, default -1 (append at the end).
  /// * **IN** *part* The marker part index to which the function applies, default 0 (first part).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void add(
    final Coordinates coord, {
    final int index = -1,
    final int part = 0,
  }) {
    objectMethod(
      _pointerId,
      'Marker',
      'add',
      args: <String, Object>{'coord': coord, 'index': index, 'part': part},
    );
  }

  /// Delete a coordinate from the marker.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index*	The position of the deleted coordinate
  /// * **IN** *part*	The marker part index to which the function applies, default 0 (first part).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void delete(final int index, {final int part = 0}) {
    objectMethod(
      _pointerId,
      'Marker',
      'del',
      args: <String, int>{'index': index, 'part': part},
    );
  }

  /// Delete a part from marker.
  ///
  /// **Parameters**
  ///
  /// * **IN** *part*	The marker part index to be deleted.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void deletePart(final int part) {
    objectMethod(_pointerId, 'Marker', 'delPart', args: part);
  }

  /// Get marker enclosing area.
  ///
  /// **Returns**
  ///
  /// * [RectangleGeographicArea] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea get area {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Marker',
      'getArea',
    );

    return RectangleGeographicArea.fromJson(resultString['result']);
  }

  /// Get marker coordinates list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *part*	The marker part index to which the function applies, default 0 (first part).
  ///
  /// **Returns**
  ///
  /// * [Coordinates] list
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Coordinates> getCoordinates({final int part = 0}) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Marker',
      'getCoordinates',
      args: part,
    );

    final List<dynamic> listJson = resultString['result'];
    final List<Coordinates> retList = listJson
        .map((final dynamic categoryJson) => Coordinates.fromJson(categoryJson))
        .toList();
    return retList;
  }

  /// Get marker unique id.
  ///
  /// **Returns**
  ///
  /// * marker id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get id {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Marker',
      'getId',
    );

    return resultString['result'];
  }

  /// Get marker name.
  ///
  /// **Returns**
  ///
  /// * marker name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Marker',
      'getName',
    );

    return resultString['result'];
  }

  /// Get marker part enclosing area.
  ///
  /// **Parameters**
  ///
  /// * **IN** *part*	The marker part index to which the function applies.
  ///
  /// **Returns**
  ///
  /// * [RectangleGeographicArea] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea getPartArea(final int part) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Marker',
      'getPartArea',
      args: part,
    );

    return RectangleGeographicArea.fromJson(resultString['result']);
  }

  /// Get marker parts count.
  ///
  /// **Returns**
  ///
  /// * marker parts count
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get partCount {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Marker',
      'getPartCount',
    );

    return resultString['result'];
  }

  /// Set marker part coordinates.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords*	The coordinates list to be set as marker part.
  /// * **IN** *part*	The marker part index to which the function applies, default 0 (first part).
  ///
  /// If part == [partCount], a new part is automatically added to the marker and the coordinate is assigned to it.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setCoordinates(final List<Coordinates> coords, {final int? part}) {
    objectMethod(
      _pointerId,
      'Marker',
      'setCoordinates',
      args: <String, Object>{'coords': coords, if (part != null) 'part': part},
    );
  }

  /// Set marker name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* The name.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set name(final String name) {
    objectMethod(_pointerId, 'Marker', 'setName', args: name);
  }

  /// Update a coordinate in the marker.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords*	The new coordinate value.
  /// * **IN** *index*	The position of the updated coordinate.
  /// * **IN** *part*	The marker part index to which the function applies, default 0 (first part).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void update(final Coordinates coord, final int index, {final int? part}) {
    objectMethod(
      _pointerId,
      'Marker',
      'update',
      args: <String, Object>{
        'coord': coord,
        'index': index,
        if (part != null) 'part': part,
      },
    );
  }

  static Marker _create(final int mapId) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'Marker'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return Marker.init(decodedVal['result']);
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, dynamic>{'class': 'Marker', 'id': _pointerId}),
    );
  }
}

/// Marker collection class
///
/// {@category Maps & 3D Scene}
class MarkerCollection extends GemAutoreleaseObject {
  factory MarkerCollection({
    required final MarkerType markerType,
    required final String name,
  }) {
    return MarkerCollection._create(0, markerType, name);
  }

  @internal
  MarkerCollection.init(final int id, final int mapId)
      : _pointerId = id,
        _mapId = mapId {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  /// Delete all markers.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void clear() {
    objectMethod(_pointerId, 'MarkerCollection', 'clear');
  }

  /// Add a new marker to collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *marker*	The marker added to the collection.
  /// * **IN** *index*	The new marker position in collection. -1 means at the collection end (topmost).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void add(final Marker marker, {final int index = -1}) {
    objectMethod(_pointerId, 'MarkerCollection', 'add', args: marker.pointerId);
  }

  /// Get the index of the given marker.
  ///
  /// **Parameters**
  ///
  /// * **IN** *marker*	The marker.
  ///
  /// **Returns**
  ///
  /// * The index of the given marker if the marker is in the collection
  /// * -1 if the marker is not in the collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int indexOf(final Marker marker) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MarkerCollection',
      'indexOf',
      args: marker.pointerId,
    );

    return resultString['result'];
  }

  /// Delete a marker by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index*	The index of the marker to be deleted.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void delete(final int index) {
    objectMethod(_pointerId, 'MarkerCollection', 'del', args: index);
  }

  /// Get whole collection enclosing area.
  ///
  /// **Returns**
  ///
  /// * [RectangleGeographicArea] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea get area {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MarkerCollection',
      'getArea',
    );

    return RectangleGeographicArea.fromJson(resultString['result']);
  }

  /// Get collection id.
  ///
  /// **Returns**
  ///
  /// * collection id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get id {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MarkerCollection',
      'getId',
    );

    return resultString['result'];
  }

  /// Get the marker at the given index.
  ///
  /// Return empty if index is not valid.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index*	The marker index.
  ///
  /// **Returns**
  ///
  /// * [Marker] object. If the index is not valid then empty Marker is returned.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Marker? getMarkerAt(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MarkerCollection',
      'getMarkerAt',
      args: index,
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return Marker.init(resultString['result']);
  }

  /// Get the marker with the given id.
  ///
  /// **Parameters**
  ///
  /// * **IN** *id*	The marker id.
  ///
  /// **Returns**
  ///
  /// * [Marker] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Marker? getMarkerById(final int id) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MarkerCollection',
      'getMarkerById',
      args: id,
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return Marker.init(resultString['result']);
  }

  /// Gets the points group head for the given marker id.
  ///
  /// This requires the collection to be added to a map view collection with [MarkerCollectionRenderSettings.buildPointsGroupConfig] set to true
  ///
  /// If points group head info is not available the function will return a reference to the queried marker and will set the API error accordingly
  ///
  /// If markerId is already a points group head the function will return a reference to the queried marker and will set the API error accordingly
  ///
  /// **Parameters**
  ///
  /// * **IN** *id*	The group id.
  ///
  /// **Returns**
  ///
  /// * Points group head marker
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Marker? getPointsGroupHead(final int id) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MarkerCollection',
      'getPointsGroupHead',
      args: id,
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return Marker.init(resultString['result']);
  }

  /// Gets the points group components.
  ///
  /// This requires the collection to be added to a map view collection with [MarkerCollectionRenderSettings.buildPointsGroupConfig] set to true
  ///
  /// If points group head info is not available the function will return a default list and will set the API error accordingly
  ///
  /// **Parameters**
  ///
  /// * **IN** *id*	The group id.
  ///
  /// **Returns**
  ///
  /// * Points group components list
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Marker> getPointsGroupComponents(final int id) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MarkerCollection',
      'getPointsGroupComponents',
      args: id,
    );

    return MarkerList.init(resultString['result']).toList();
  }

  /// Get collection name.
  ///
  /// **Returns**
  ///
  /// * Collection name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MarkerCollection',
      'getName',
    );

    return resultString['result'];
  }

  /// Get marker count.
  ///
  /// **Returns**
  ///
  /// * Collection size
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get size {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MarkerCollection',
      'size',
    );

    return resultString['result'];
  }

  /// Get collection type.
  ///
  /// **Returns**
  ///
  /// * Collection type
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MarkerType get type {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MarkerCollection',
      'getType',
    );

    return MarkerTypeExtension.fromId(resultString['result']);
  }

  /// Set collection name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* Collection name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set name(final String name) {
    objectMethod(_pointerId, 'MarkerCollection', 'setName', args: name);
  }

  static MarkerCollection _create(
    final int mapId,
    final MarkerType markerType,
    final String name,
  ) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, Object>{
        'class': 'MarkerCollection',
        'type': markerType.id,
        'name': name,
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return MarkerCollection.init(decodedVal['result'], mapId);
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, Object>{
        'class': 'MarkerCollection',
        'id': _pointerId,
      }),
    );
  }
}

/// Marker match
///
/// {@category Maps & 3D Scene}
class MarkerMatch extends GemAutoreleaseObject {
  MarkerMatch() : _pointerId = -1;

  @internal
  MarkerMatch.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;
  int get pointerId => _pointerId;

  /// Get matched marker.
  ///
  /// **Returns**
  ///
  /// * [Marker] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Marker getMarker() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MarkerMatch',
      'getMarker',
    );

    return Marker.init(resultString['result']);
  }
}

/// Mapview marker collections class
///
/// This class should not be instantiated directly. Instead, use the [MapViewPreferences.markers] getter to obtain an instance.
///
/// {@category Maps & 3D Scene}
class MapViewMarkerCollections extends GemAutoreleaseObject {
  // ignore: unused_element
  MapViewMarkerCollections._()
      : _pointerId = -1,
        _mapId = -1,
        _mapPointerId = -1;

  @internal
  MapViewMarkerCollections.init(
    final int id,
    final int mapId,
    final dynamic mapPointerId,
  )   : _pointerId = id,
        _mapId = mapId,
        _mapPointerId = mapPointerId {
    super.registerAutoReleaseObject(pointerId);
  }
  final int _pointerId;
  final int _mapId;
  final dynamic _mapPointerId;
  int get pointerId => _pointerId;
  int get mapId => _mapId;
  Map<int, ExternalRendererMarkers> externalRenderers =
      <int, ExternalRendererMarkers>{};

  /// Add collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *col*	The markers collection to be added
  /// * **IN** *settings*	The markers collection render settings
  /// * **IN** *externalRender*	The render
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void add(
    final MarkerCollection col, {
    MarkerCollectionRenderSettings? settings,
    final ExternalRendererMarkers? externalRender,
  }) {
    settings ??= MarkerCollectionRenderSettings();
    if (externalRender != null) {
      externalRenderers[col.id] = externalRender;
    }
    final bool hasExternalRender = externalRender != null;
    objectMethod(
      _pointerId,
      'MapViewMarkerCollections',
      'add',
      args: <String, Object>{
        'col': col.pointerId,
        'settings': settings,
        if (externalRender != null) 'externalRender': hasExternalRender,
        'maxzoomlevel': 10,
      },
    );
  }

  /// Adds a list of markers and corresponding render settings
  ///
  /// **Parameters**
  ///
  /// * **IN** *list* The list of markers with corresponding render settings
  /// * **IN** *settings* The render settings for the marker collection
  /// * **IN** *name* The name of the collection
  /// * **IN** *markerType* The type of marker
  ///
  /// **Returns**
  ///
  /// * The ids of the added markers.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Future<List<int>> addList({
    required final List<MarkerWithRenderSettings> list,
    required final MarkerCollectionRenderSettings settings,
    required final String name,
    final MarkerType markerType = MarkerType.point,
  }) async {
    final dynamic jsonResponse = await GemKitPlatform.instance.addList(
      object: this,
      list: list,
      settings: settings,
      name: name,
      parentMapId: _mapPointerId,
      markerType: markerType,
    );
    final Map<String, dynamic> parsedResponse = jsonDecode(jsonResponse);
    final List<int> resultList = List<int>.from(parsedResponse['result']);
    return resultList;
  }

  /// Check if the specified marker collection exists in this collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *col* The markers collection to be searched.
  ///
  /// **Returns**
  ///
  /// * True if the collection is in the collection, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool contains(final MarkerCollection col) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewMarkerCollections',
      'contains',
      args: col._pointerId,
    );

    return resultString['result'];
  }

  /// Get collection at index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The collection index
  ///
  /// **Returns**
  ///
  /// * The [MarkerCollection] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MarkerCollection getCollectionAt(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewMarkerCollections',
      'getCollectionAt',
      args: index,
    );

    return MarkerCollection.init(resultString['result'], _mapId);
  }

  /// Perform a hit test across all marker collections.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area*	The geographic area to be tested
  ///
  /// **Returns**
  ///
  /// * The list of marker matches
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<MarkerMatch> hitTest(final RectangleGeographicArea area) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewMarkerCollections',
      'hitTest',
      args: <String, RectangleGeographicArea>{'area': area},
    );

    return MarkerMatchList.init(resultString['result']).toList();
  }

  /// Get the index of the given collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *col* The markers collection to be searched
  ///
  /// **Returns**
  ///
  /// * The collection index on success, [GemError.notFound] on error
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int indexOf(final MarkerCollection col) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewMarkerCollections',
      'indexOf',
      args: col._pointerId,
    );

    return resultString['result'];
  }

  /// Check if the given collection is a sketches collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coll*	The collection to be checked
  ///
  /// **Returns**
  ///
  /// * True if the collection is a sketches collection, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool isSketches(final MarkerCollection coll) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewMarkerCollections',
      'isSketches',
      args: coll._pointerId,
    );

    return resultString['result'];
  }

  void onMarkerRender(
    final GemMapController mapController,
    final dynamic data,
  ) =>
      externalRenderers[data['sourceId']]!.processData(mapController, data);

  void onViewRendered(final dynamic data) {
    if (data['markersIds']!.length > 0) {
      final List<dynamic> markersIds = data['markersIds'];
      final List<dynamic> sourcesIds = data['sourcesIds'];
      for (int i = 0; i < markersIds.length; ++i) {
        externalRenderers[sourcesIds.elementAt(i)]!.removeData(markersIds[i]);
      }
    }
    externalRenderers[data['sourceId']]?.onNotifyCustom!(2);
  }

  /// Remove collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The collection index
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void removeAt(final int index) {
    objectMethod(_pointerId, 'MapViewMarkerCollections', 'remove', args: index);
  }

  /// Sets collection render settings.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The collection index
  /// * **IN** *settings* [MarkerCollectionRenderSettings]
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError setRenderSettings(
    final int index,
    final MarkerCollectionRenderSettings settings,
  ) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewMarkerCollections',
      'setRenderSettings',
      args: <String, Object>{'index': index, 'settings': settings},
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Get collection size.
  ///
  /// **Returns**
  ///
  /// * The number of collections
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get size {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewMarkerCollections',
      'size',
    );

    return resultString['result'];
  }

  /// Remove all collections.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Future<void> clear() async {
    await GemKitPlatform.instance
        .getChannel(mapId: _mapId)
        .invokeMethod<String>(
          'callObjectMethod',
          jsonEncode(<String, dynamic>{
            'id': _pointerId,
            'class': 'MapViewMarkerCollections',
            'method': 'clear',
            'args': <String, dynamic>{},
          }),
        );
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, Object>{
          'class': 'MapViewMarkerCollections',
          'id': _pointerId,
        }),
      );
}

/// Marker render settings
///
/// {@category Maps & 3D Scene}
class MarkerRenderSettings {
  MarkerRenderSettings({
    this.image,
    this.polylineInnerColor = defaultColor,
    this.polylineOuterColor = defaultColor,
    this.polygonFillColor = defaultColor,
    this.labelTextColor = defaultColor,
    this.polylineInnerSize = defaultPolylineInnerSize,
    this.polylineOuterSize = defaultPolylineOuterSize,
    this.labelTextSize = defaultLabelTextSize,
    this.imageSize = defaultImageSize,
    this.labelingMode = const <MarkerLabelingMode>{
      MarkerLabelingMode.itemLabelVisible,
      MarkerLabelingMode.groupLabelVisible,
      MarkerLabelingMode.iconBottomCenter,
      MarkerLabelingMode.textAbove,
    },
  });

  /// The image
  GemImage? image = GemImage(imageId: defaultMembersValue);

  /// The polyline inner color
  Color polylineInnerColor;

  /// The polyline outer colors
  Color polylineOuterColor;

  /// The polygon fill color
  Color polygonFillColor;

  /// The label text color
  Color labelTextColor;

  /// The polyline inner size
  double polylineInnerSize;

  /// The polyline outer size
  double polylineOuterSize;

  /// The label text size
  double labelTextSize;

  /// The image size
  double imageSize;

  /// The labeling mode
  Set<MarkerLabelingMode> labelingMode;

  @internal
  dynamic imagePointer;

  @internal
  dynamic imagePointerSize;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    if (image != null) {
      json['image'] = image;
    }
    json['polylineInnerColor'] = polylineInnerColor.toRgba();
    json['polylineOuterColor'] = polylineOuterColor.toRgba();
    json['polygonFillColor'] = polygonFillColor.toRgba();
    json['labelTextColor'] = labelTextColor.toRgba();
    json['polylineInnerSize'] = polylineInnerSize;
    json['polylineOuterSize'] = polylineOuterSize;
    json['labelTextSize'] = labelTextSize;
    json['imageSize'] = imageSize;
    int labelingModePacked = 0;
    for (final MarkerLabelingMode mode in labelingMode) {
      labelingModePacked |= mode.id;
    }
    json['labelingMode'] = labelingModePacked;
    if (imagePointer != null) {
      json['imagePointer'] = imagePointer;
    }
    if (imagePointerSize != null) {
      json['imagePointerSize'] = imagePointerSize;
    }
    json['hashCode'] = image.hashCode ^
        polylineInnerColor.hashCode ^
        polylineOuterColor.hashCode ^
        polygonFillColor.hashCode ^
        labelTextColor.hashCode ^
        polylineInnerSize.hashCode ^
        polylineOuterSize.hashCode ^
        labelTextSize.hashCode ^
        imageSize.hashCode ^
        labelingMode.hashCode ^
        imagePointer.hashCode ^
        imagePointerSize.hashCode;
    return json;
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is MarkerRenderSettings &&
        other.image == image &&
        other.polylineInnerColor == polylineInnerColor &&
        other.polylineOuterColor == polylineOuterColor &&
        other.polygonFillColor == polygonFillColor &&
        other.labelTextColor == labelTextColor &&
        other.polylineInnerSize == polylineInnerSize &&
        other.polylineOuterSize == polylineOuterSize &&
        other.labelTextSize == labelTextSize &&
        other.imageSize == imageSize &&
        other.labelingMode == labelingMode;
  }

  @override
  int get hashCode =>
      image.hashCode ^
      polylineInnerColor.hashCode ^
      polylineOuterColor.hashCode ^
      polygonFillColor.hashCode ^
      labelTextColor.hashCode ^
      polylineInnerSize.hashCode ^
      polylineOuterSize.hashCode ^
      labelTextSize.hashCode ^
      imageSize.hashCode ^
      labelingMode.hashCode ^
      imagePointer.hashCode;

  @internal
  int get packedLabelingMode {
    int labelingModePacked = 0;
    for (final MarkerLabelingMode mode in labelingMode) {
      labelingModePacked |= mode.id;
    }
    return labelingModePacked;
  }

  /// Default value of various members. Members assigned with this value will be changed internally to something more appropriate.
  static const int defaultMembersValue = 2147483647;

  /// Default color for various members. Members assigned with this value will be changed internally to something more appropriate.
  static const Color defaultColor = Colors.transparent;

  /// Default size for [polylineInnerSize].
  static const double defaultPolylineInnerSize = 1.5;

  /// Default size for [polylineOuterSize].
  static const double defaultPolylineOuterSize = 0.0;

  /// Default size for [imageSize].
  static const double defaultImageSize = 4.0;

  /// Default size for [labelTextSize].
  static const double defaultLabelTextSize = 1.0;
}

/// Marker info
///
/// {@category Maps & 3D Scene}
class MarkerInfo {
  MarkerInfo() {
    screenCoordinatesNotifier = ValueNotifier<XyType<double>>(
      XyType<double>(x: 0.0, y: 0.0),
    );
  }

  /// The marker coordinates
  late Coordinates coordinates;

  /// The marker screen coordinates
  late XyType<double> screenCoordinates;
  late GemMapController mapController;
  late ValueNotifier<XyType<double>> screenCoordinatesNotifier;

  /// Extra info
  dynamic info;
  //  MarkerInfo({
  //   required this.coordinates,
  //   required this.screenCoordinates,
  //   required this.mapController,
  //   this.info,
  // }) {
  //   // Initialize the positionNotifier with the initial screen coordinates
  //   positionNotifier = ValueNotifier(_calculateInitialOffset());
  // }

  /// Set coordinates
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* the new coordinates
  void setCoordinates(final Coordinates coords) {
    coordinates = coords;
  }

  @override
  bool operator ==(covariant final MarkerInfo other) {
    if (identical(this, other)) {
      return true;
    }
    return other.coordinates == coordinates &&
        other.screenCoordinates == screenCoordinates &&
        other.info == info;
  }

  @override
  int get hashCode =>
      coordinates.hashCode ^ screenCoordinates.hashCode ^ info.hashCode;
}

/// External renderer markers
///
/// {@category Maps & 3D Scene}
class ExternalRendererMarkers {
  Map<int, MarkerInfo> visiblePoints = <int, MarkerInfo>{};
  GemMapController? mapController;
  void Function(dynamic value)? onNotifyCustom;

  void processData(final GemMapController mapController, final dynamic data) {
    final List<dynamic> listJson = data['coordinates'];
    final List<Coordinates> retList = listJson
        .map((final dynamic categoryJson) => Coordinates.fromJson(categoryJson))
        .toList();

    final MarkerInfo markerInfo = MarkerInfo();
    markerInfo.setCoordinates(retList[0]);
    final XyType<double> theF = XyType<double>(
      x: data['screen_coordinates_x'],
      y: data['screen_coordinates_y'],
    );
    if (visiblePoints.containsKey(data['dataMarkerId'])) {
      visiblePoints[data['dataMarkerId']]!.screenCoordinates = theF;
      visiblePoints[data['dataMarkerId']]!.screenCoordinatesNotifier.value =
          XyType<double>(x: theF.x, y: theF.y);
      //visiblePoints[data['dataMarkerId']]!.screenCoordinates.x = visiblePoints[data['dataMarkerId']]!.screenCoordinates.x! * mapController.viewport.width!;
      //visiblePoints[data['dataMarkerId']]!.screenCoordinates.y = visiblePoints[data['dataMarkerId']]!.screenCoordinates.y! * mapController.viewport.height!;
    } else {
      markerInfo.screenCoordinates = theF;
      //  markerInfo.screenCoordinates.x = markerInfo.screenCoordinates.x! * mapController.viewport.width!;
      // markerInfo.screenCoordinates.y = markerInfo.screenCoordinates.y! * mapController.viewport.height!;
      markerInfo.info = jsonDecode(data['info']);
      markerInfo.mapController = mapController;
      // Add to the map
      visiblePoints[data['dataMarkerId']] = markerInfo;
    }
    if (onNotifyCustom != null) {
      onNotifyCustom!(2);
    }
  }

  void removeData(final dynamic markerId) {
    visiblePoints.remove(markerId);
    //visiblePoints.remove();
  }
}

/// Contains a marker and its render settings
///
/// {@category Maps & 3D Scene}
class MarkerWithRenderSettings {
  MarkerWithRenderSettings(this.marker, this.settings);

  /// The marker to be rendered
  MarkerJson marker;

  /// The marker render settings
  MarkerRenderSettings settings;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['marker'] = marker;
    json['settings'] = settings;
    return json;
  }

  Uint8List toBinary() {
    final int markerCoordsLength = marker.coords.length;

    // Calculate total bytes required
    int totalBytes = 0;
    totalBytes += 4; // Number of coordinates
    totalBytes += markerCoordsLength *
        16; // 8 bytes for each double (latitude, longitude)

    int nameLength = 0;
    if (marker.name != null) {
      final Uint8List nameBytes = utf8.encode(marker.name!);
      nameLength = nameBytes.length;
      totalBytes += 4; // Length of the name string
      totalBytes += nameLength; // Name string bytes
    } else {
      totalBytes += 4; // Length of the name string (0)
    }

    totalBytes += 8; // polylineInnerSize
    totalBytes += 8; // polylineOuterSize
    totalBytes += 8; // labelTextSize
    totalBytes += 8; // imageSize
    totalBytes += 4; // labelingMode
    if (GemKitPlatform.instance.is32BitSystem()) {
      totalBytes += 4;
      totalBytes += 4;
    } else {
      totalBytes += 8; // _imagePointer (assuming 64-bit pointer)
      totalBytes += 8; // _hashValue
    }
    totalBytes += 4; // _imagePointerSize

    // Adding 4 bytes for each color (RGBA)
    totalBytes += 4 *
        4; // polylineInnerColor, polylineOuterColor, polygonFillColor, labelTextColor

    final ByteData buffer = ByteData(totalBytes);
    int offset = 0;

    // Serialize MarkerJson
    buffer.setInt32(offset, markerCoordsLength, Endian.little);
    offset += 4;

    for (final Coordinates coord in marker.coords) {
      buffer.setFloat64(offset, coord.latitude, Endian.little);
      offset += 8;
      buffer.setFloat64(offset, coord.longitude, Endian.little);
      offset += 8;
    }

    // Serialize the name string
    buffer.setInt32(offset, nameLength, Endian.little);
    offset += 4;

    if (nameLength > 0) {
      final Uint8List nameBytes = utf8.encode(marker.name!);
      buffer.buffer.asUint8List().setAll(offset, nameBytes);
      offset += nameLength;
    }

    // Serialize MarkerRenderSettings
    buffer.setFloat64(offset, settings.polylineInnerSize, Endian.little);
    offset += 8;

    buffer.setFloat64(offset, settings.polylineOuterSize, Endian.little);
    offset += 8;

    buffer.setFloat64(offset, settings.labelTextSize, Endian.little);
    offset += 8;

    buffer.setFloat64(offset, settings.imageSize, Endian.little);
    offset += 8;

    buffer.setInt32(offset, settings.packedLabelingMode, Endian.little);
    offset += 4;
    if (!GemKitPlatform.instance.is32BitSystem()) {
      buffer.setInt64(offset, settings.imagePointer ?? 0, Endian.little);
      offset += 8;
    } else {
      buffer.setInt32(offset, settings.imagePointer ?? 0, Endian.little);
      offset += 4;
    }
    buffer.setInt32(offset, settings.imagePointerSize ?? 0, Endian.little);
    offset += 4;
    if (!GemKitPlatform.instance.is32BitSystem()) {
      buffer.setInt64(offset, settings.hashCode, Endian.little);
      offset += 8;
    } else {
      buffer.setInt32(offset, settings.hashCode, Endian.little);
      offset += 4;
    }

    // Serialize Colors
    buffer.setUint8(offset++, (settings.polylineInnerColor.r * 255).toInt());
    buffer.setUint8(offset++, (settings.polylineInnerColor.g * 255).toInt());
    buffer.setUint8(offset++, (settings.polylineInnerColor.b * 255).toInt());
    buffer.setUint8(offset++, (settings.polylineInnerColor.a * 255).toInt());

    buffer.setUint8(offset++, (settings.polylineOuterColor.r * 255).toInt());
    buffer.setUint8(offset++, (settings.polylineOuterColor.g * 255).toInt());
    buffer.setUint8(offset++, (settings.polylineOuterColor.b * 255).toInt());
    buffer.setUint8(offset++, (settings.polylineOuterColor.a * 255).toInt());

    buffer.setUint8(offset++, (settings.polygonFillColor.r * 255).toInt());
    buffer.setUint8(offset++, (settings.polygonFillColor.g * 255).toInt());
    buffer.setUint8(offset++, (settings.polygonFillColor.b * 255).toInt());
    buffer.setUint8(offset++, (settings.polygonFillColor.a * 255).toInt());

    buffer.setUint8(offset++, (settings.labelTextColor.r * 255).toInt());
    buffer.setUint8(offset++, (settings.labelTextColor.g * 255).toInt());
    buffer.setUint8(offset++, (settings.labelTextColor.b * 255).toInt());
    buffer.setUint8(offset++, (settings.labelTextColor.a * 255).toInt());

    return buffer.buffer.asUint8List();
  }
}

/// A simplified representation of a Marker
///
/// {@category Maps & 3D Scene}
class MarkerJson {
  MarkerJson({required this.coords, this.name});

  /// Coordinates of the marker
  final List<Coordinates> coords;

  /// Name of the marker
  String? name;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['coords'] = coords;
    if (name != null) {
      json['name'] = name;
    }
    return json;
  }
}
