// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

// ignore_for_file: always_specify_types

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/map/overlays.dart';
import 'package:meta/meta.dart';

/// Landmark class. This is the core class for location information.
///
/// {@category Places}
class Landmark extends GemAutoreleaseObject {
  /// Creates a new landmark
  factory Landmark() {
    return Landmark._create();
  }

  /// Creates a new landmark with the given latitude and longitude
  factory Landmark.withLatLng({
    required final double latitude,
    required final double longitude,
  }) =>
      Landmark()
        ..coordinates = Coordinates(latitude: latitude, longitude: longitude);

  /// Creates a new landmark with the given coordinates
  factory Landmark.withCoordinates(final Coordinates coordinates) =>
      Landmark()..coordinates = coordinates;

  @internal
  Landmark.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  dynamic get pointerId => _pointerId;

  /// Get the address of this landmark.
  ///
  /// Some of the values (or all) may be empty.
  ///
  /// **Returns**
  ///
  /// * [AddressInfo] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  AddressInfo get address {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getAddress',
    );

    return AddressInfo.init(resultString['result']);
  }

  /// Get the author of this landmark.
  ///
  /// It may be empty.
  ///
  /// **Returns**
  ///
  /// * The author
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get author {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getAuthor',
    );

    return resultString['result'];
  }

  /// Get landmark categories list.
  ///
  /// **Returns**
  ///
  /// * List<[LandmarkCategory]>
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<LandmarkCategory> get categories {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getCategories',
    );

    return LandmarkCategoryList.init(resultString['result']).toList();
  }

  /// Get contact info attached to this landmark Phone numbers & descriptions, email addresses & descriptions, URLs & descriptions.
  ///
  /// **Returns**
  ///
  /// * [ContactInfo] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  ContactInfo get contactInfo {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getContactInfo',
    );

    return ContactInfo.init(resultString['result']);
  }

  /// Get contour rectangle geographic area.
  ///
  /// **Parameters**
  ///
  /// * **IN** *relevantOnly* If true, it will return the relevant contour bounding box if it exists, otherwise the full contour bounding box.
  ///
  /// **Returns**
  ///
  /// * [RectangleGeographicArea] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea getContourGeographicArea({
    final bool relevantOnly = true,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getContourGeograficArea',
      args: relevantOnly,
    );

    return RectangleGeographicArea.fromJson(resultString['result']);
  }

  /// Get direct access to the coordinates attached to this landmark (centroid coordinates).
  ///
  /// **Returns**
  ///
  /// * [Coordinates] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Coordinates get coordinates {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getCoordinates',
    );

    return Coordinates.fromJson(resultString['result']);
  }

  /// Get the description of this landmark.
  ///
  /// It may be empty.
  ///
  /// **Returns**
  ///
  /// * The description
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get description {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getDescription',
    );

    return resultString['result'];
  }

  /// Get direct access to the entrance locations.
  ///
  /// Locations & access type for entrances to the landmark.
  ///
  /// **Returns**
  ///
  /// * [EntranceLocations] object. Locations & access type for entrances to the landmark.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  EntranceLocations get entrances {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getEntrances',
    );

    return EntranceLocations.init(resultString['result']);
  }

  /// Get extra image
  ///
  /// **Returns**
  ///
  /// * Extra image if it is available. Null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Uint8List? getExtraImage({final Size? size, final ImageFileFormat? format}) {
    return GemKitPlatform.instance.callGetImage(
      _pointerId,
      'LandmarkgetExtraImage',
      size?.width.toInt() ?? -1,
      size?.height.toInt() ?? -1,
      format?.id ?? -1,
    );
  }

  /// Get extra image
  ///
  /// **Returns**
  ///
  /// * Extra image. The user is responsible to check if the image is valid
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Img get extraImg {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getExtraImg',
    );

    return Img.init(resultString['result']);
  }

  /// Set extra image
  ///
  /// **Parameters**
  ///
  /// * Extra image to be set
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set extraImg(Img value) {
    objectMethod(_pointerId, 'Landmark', 'setExtraImg', args: value.pointerId);
  }

  /// Get direct access to the extra info attached to this landmark.
  ///
  /// **Returns**
  ///
  /// * [ExtraInfo] object.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  ExtraInfo get extraInfo {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getExtraInfo',
    );

    return ExtraInfo.fromList(resultString['result']);
  }

  /// Get geographic area.
  ///
  /// **Returns**
  ///
  /// * [GeographicArea] object.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GeographicArea get geographicArea {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getGeographicArea',
    );

    switch (GeographicAreaTypeExtension.fromId(
      resultString['result']['type'],
    )) {
      case GeographicAreaType.rectangle:
        return RectangleGeographicArea.fromJson(resultString['result']);
      case GeographicAreaType.circle:
        return CircleGeographicArea.fromJson(resultString['result']);
      case GeographicAreaType.polygon:
        return PolygonGeographicArea.fromJson(resultString['result']);
      case GeographicAreaType.tileCollection:
        return RectangleGeographicArea.fromJson(resultString['result']);
      case GeographicAreaType.undefined:
        return RectangleGeographicArea.fromJson(resultString['result']);
    }
  }

  /// Get the landmark ID.
  ///
  /// **Returns**
  ///
  /// * landmark id
  /// * [GemError.general].code (-1) if it does not have an associated ID, i.e. the landmark doesn't belong to a landmark store.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get id {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getLandmarkId',
    );

    return resultString['result'];
  }

  /// Get the landmark image.
  ///
  /// **Returns**
  ///
  /// * The image if it is available. Otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Uint8List? getImage({final Size? size, final ImageFileFormat? format}) {
    return GemKitPlatform.instance.callGetImage(
      _pointerId,
      'Landmark',
      size?.width.toInt() ?? -1,
      size?.height.toInt() ?? -1,
      format?.id ?? -1,
    );
  }

  /// Get the landmark image
  ///
  /// **Returns**
  ///
  /// * Landmark image. The user is responsible to check if the image is valid
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Img get img {
    final resultString = objectMethod(_pointerId, 'Landmark', 'getImg');

    return Img.init(resultString['result']);
  }

  /// Sets the landmark image
  ///
  /// **Returns**
  ///
  /// * The landmark image to be set
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set img(Img value) {
    objectMethod(_pointerId, 'Landmark', 'setImg', args: value.pointerId);
  }

  /// Get the unique ID of the image.
  ///
  /// **Returns**
  ///
  /// * The image unique ID
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get imageUid {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getImageUid',
    );

    return resultString['result'];
  }

  /// If the landmark store is set then it returns the landmark store ID.
  ///
  /// **Returns**
  ///
  /// * [GemError.general].code (-1) on error.
  /// * The landmark store ID on success. The id should be grater than 0
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get landmarkStoreId {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getLandmarkStoreId',
    );

    return resultString['result'];
  }

  /// If the landmark store is set then it returns the landmark store type.
  ///
  /// See [LandmarkStoreType] for possible values
  ///
  /// **Returns**
  ///
  /// * The landmark store type code
  /// * [GemError.general].code (-1) on error.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get landmarkStoreType {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getLandmarkStoreType',
    );

    return resultString['result'];
  }

  /// Get the name of this landmark.
  ///
  /// It may be empty.
  ///
  /// **Returns**
  ///
  /// * The landmark name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getName',
    );

    return resultString['result'];
  }

  /// Get provider id of this landmark.
  ///
  /// **Returns**
  ///
  /// * The provider ID. See [MapProviderId] for more information.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get providerId {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getProviderId',
    );

    return resultString['result'];
  }

  /// Get the timestamp.
  ///
  /// If no value is set by the user, the timestamp will be set to current time when the landmark is inserted in a landmark store.
  ///
  /// * [DateTime] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  DateTime get timeStamp {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getTimeStamp',
    );

    return DateTime.fromMillisecondsSinceEpoch(
      resultString['result'],
      isUtc: true,
    );
  }

  /// Set the address of this landmark.
  ///
  /// **Parameters**
  ///
  /// * **IN** *addr* [AddressInfo] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set address(final AddressInfo addr) {
    objectMethod(_pointerId, 'Landmark', 'setAddress', args: addr.pointerId);
  }

  /// Set the author of this landmark.
  ///
  /// It may be empty.
  ///
  /// **Parameters**
  ///
  /// * **IN** *auth* The author
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set author(final String auth) {
    objectMethod(_pointerId, 'Landmark', 'setAuthor', args: auth);
  }

  /// Set the contact info.
  ///
  /// Phone numbers & descriptions, email addresses & descriptions, URLs & descriptions.
  ///
  /// **Parameters**
  ///
  /// * **IN** *ci* [ContactInfo] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set contactInfo(final ContactInfo ci) {
    objectMethod(_pointerId, 'Landmark', 'setContactInfo', args: ci.pointerId);
  }

  /// Set the centroid coordinates.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* [Coordinates] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set coordinates(final Coordinates coords) {
    objectMethod(
      _pointerId,
      'Landmark',
      'setCoordinates',
      args: coords.toJson(),
    );
  }

  /// Set the description of this landmark.
  ///
  /// It may be empty.
  ///
  /// **Parameters**
  ///
  /// * **IN** *desc* The description
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set description(final String desc) {
    objectMethod(_pointerId, 'Landmark', 'setDescription', args: desc);
  }

  /// Set the landmark extra image.
  ///
  /// **Parameters**
  ///
  /// * **IN** *imageData* The image
  /// * **IN** *format* [ImageFileFormat] of the image.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setExtraImage({
    required final Uint8List imageData,
    required final ImageFileFormat format,
  }) {
    final dynamic gemImage = GemKitPlatform.instance.createGemImage(
      imageData,
      format.id,
    );
    try {
      GemKitPlatform.instance.callObjectMethod(
        jsonEncode(<String, dynamic>{
          'id': _pointerId,
          'class': 'Landmark',
          'method': 'setExtraImage',
          'args': gemImage,
        }),
      );
    } finally {
      GemKitPlatform.instance.deleteCPointer(gemImage);
    }
  }

  /// Set extra info.
  ///
  /// **Parameters**
  ///
  /// * **IN** *list* [ExtraInfo] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set extraInfo(final ExtraInfo list) {
    objectMethod(
      _pointerId,
      'Landmark',
      'setExtraInfo',
      args: list.toInputFormat(),
    );
  }

  /// Set geographic area.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area* [GeographicArea] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set geographicArea(final GeographicArea area) {
    final Map<String, dynamic> serializedGeographicArea = area.toJson();
    serializedGeographicArea['type'] = area.type.id;

    GemKitPlatform.instance.callObjectMethod(
      jsonEncode(<String, Object>{
        'id': _pointerId,
        'class': 'Landmark',
        'method': 'setGeographicArea',
        'args': serializedGeographicArea,
      }),
    );
  }

  /// Set the image of this landmark.
  ///
  /// **Parameters**
  ///
  /// * **IN** *imageData* The image
  /// * **IN** *format* [ImageFileFormat] of the image.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setImage({
    required final Uint8List imageData,
    final ImageFileFormat format = ImageFileFormat.png,
  }) {
    final dynamic gemImage = GemKitPlatform.instance.createGemImage(
      imageData,
      format.id,
    );
    try {
      objectMethod(_pointerId, 'Landmark', 'setImage', args: gemImage);
    } finally {
      GemKitPlatform.instance.deleteCPointer(gemImage);
    }
  }

  /// Set the image of the landmark with an Icon
  ///
  /// See [GemIcon].
  ///
  /// **Parameters**
  ///
  /// * **IN** *icon* [GemIcon] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setImageFromIcon(final GemIcon icon) {
    objectMethod(_pointerId, 'Landmark', 'setImageFromIconId', args: icon.id);
  }

  /// Set the name of this landmark.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* The name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set name(final String name) {
    objectMethod(_pointerId, 'Landmark', 'setName', args: name);
  }

  /// Set provider id of this landmark.
  ///
  /// See the [MapProviderId] enum for more details.
  ///
  /// **Parameters**
  ///
  /// * **IN** *providerId* The provider ID
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set providerId(final int providerId) {
    objectMethod(_pointerId, 'Landmark', 'setProviderId', args: providerId);
  }

  /// Set the timestamp.
  ///
  /// **Parameters**
  ///
  /// * **IN** *time* [DateTime] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set timeStamp(final DateTime time) {
    objectMethod(
      _pointerId,
      'Landmark',
      'setTimeStamp',
      args: time.millisecondsSinceEpoch,
    );
  }

  /// Get the overlay item attached to a landmark.
  ///
  /// E.g. if the landmark is a result of a search in overlays
  ///
  /// **Returns**
  ///
  /// * If exists, return a valid overlay item. See [OverlayItem]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  OverlayItem? get overlayItem {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Landmark',
      'getOverlayItem',
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return OverlayItem.init(resultString['result']);
  }

  static Landmark _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'Landmark'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    final Landmark retVal = Landmark.init(decodedVal['result']);
    return retVal;
  }

  Map<String, dynamic> getJson(
    final int landmarkImageWidth,
    final int landmarkImageHeight,
  ) {
    final String resultString = GemKitPlatform.instance.callObjectMethod(
      jsonEncode(<String, Object>{
        'id': _pointerId,
        'class': 'Landmark',
        'method': 'getJson',
        'args': XyType<int>(x: landmarkImageWidth, y: landmarkImageHeight),
      }),
    );

    final dynamic decodedVal = jsonDecode(resultString);
    final Map<String, dynamic> retMap = <String, dynamic>{};

    retMap['name'] = decodedVal['result']['name'];
    retMap['description'] = decodedVal['result']['description'];
    retMap['author'] = decodedVal['result']['author'];
    retMap['image'] = Uint8List.fromList(
      decodedVal['result']['image'].cast<int>(),
    );
    retMap['extrainfo'] = decodedVal['result']['extrainfo'];
    retMap['address'] = decodedVal['result']['address'];
    final dynamic categorieslist = decodedVal['result']['categories'];
    retMap['categories'] = LandmarkCategoryList.init(categorieslist);

    return retMap;
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, Object>{'class': 'Landmark', 'id': _pointerId}),
    );
  }
}

/// Coordinate referenced [Landmark] object.
///
/// This class should not be instantiated directly.
///
/// {@category Maps & 3D Scene}
class LandmarkPosition extends GemAutoreleaseObject {
  // ignore: unused_element
  LandmarkPosition._() : _pointerId = -1;

  @internal
  LandmarkPosition.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(id);
  }
  final int _pointerId;
  int get id => _pointerId;

  /// Get the Landmark object.
  ///
  /// **Returns**
  ///
  /// * The [Landmark] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Landmark get landmark {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkPosition',
      'getLandmark',
    );

    return Landmark.init(resultString['result']);
  }

  /// Get distance in meters from reference coordinates to the Landmark object.
  ///
  /// **Returns**
  ///
  /// * Distance in meters to the [landmark]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get distance {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LandmarkPosition',
      'getDistance',
    );

    return resultString['result'];
  }
}

/// Prefefined custom landmark extra info keys
///
/// {@category Places}
abstract class PredefinedExtraInfoKey {
  /// Full contour landmark bounding box
  static const String gmContourBox = 'gm_display_box';

  /// Landmark relevant contour partial bounding box
  static const String gmRelevantContourBox = 'gm_display_box_relevant';

  /// Search result link position side
  static const String gmSearchResultSidePosition = 'gm_search_result_side';

  /// Search result distance relative to search position reference
  static const String gmSearchResultDistance = 'gm_search_result_dist';

  /// Search result detailed type
  static const String gmSearchResultType = 'gm_search_result_type';

  /// Wiki info
  static const String wikiInfo = 'gm_wiki_info';

  /// Wiki native name
  static const String gmWikiNativeName = 'gm_wiki_native_name';

  /// Wiki English name
  static const String gmWikiEngName = 'gm_wiki_eng_name';

  /// Population
  static const String gmPopulation = 'gm_population';

  /// External provider
  static const String gmExtProvider = 'gm_ext_provider';
}

/// Extra info
///
/// Changes made to this object will not be automatically reflected in associated [Landmark].
/// Use the [Landmark.extraInfo] setter to set the extra info for a landmark.
///
/// {@category Places}
class ExtraInfo {
  ExtraInfo() : _data = <dynamic, dynamic>{};
  ExtraInfo.fromList(final List<dynamic> input) : _data = _parseInput(input);
  final Map<dynamic, dynamic> _data;
  static Map<dynamic, dynamic> _parseInput(final List<dynamic> input) {
    final Map<dynamic, dynamic> parsedData = <dynamic, dynamic>{};
    int index = 0;

    for (final dynamic line in input) {
      final dynamic parts = line.split('=');
      if (parts.length == 2) {
        final dynamic key = parts[0].trim();
        final dynamic value = parts[1].trim();
        parsedData[key] = value;
      } else if (parts.length == 1) {
        final dynamic value = parts[0].trim();
        final String key = index.toString();
        parsedData[key] = value;
        index++;
      }
    }

    return parsedData;
  }

  /// Get the value of a key
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* [dynamic] The key
  ///
  /// **Returns**
  ///
  /// * **null** if the value doesn't exist or if the value is set to null
  /// * **bool** if the value is 'true' or 'false'
  /// * **int** if the value can be parsed as an int
  /// * **double** if the value can be parsed as a double
  /// * **dynamic** if the value can't be parsed as a bool, int, or double
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  dynamic getByKey(final dynamic key) {
    if (!_data.containsKey(key)) {
      return null;
    }
    final dynamic value = _data[key];
    if (value != null) {
      if (value == 'true' || value == 'false') {
        return value == 'true';
      }
      try {
        return int.parse(value);
      } catch (e) {
        // Not an int, try parsing as double
        try {
          return double.parse(value);
        } catch (e) {
          // Not a double, return the original string value
          return value;
        }
      }
    }
    return null;
  }

  /// Formats the data as a list of strings
  ///
  /// If the key is an integer, it means the original input was a single value.
  /// If the key is not an integer, it means the original input was a key-value pair.
  ///
  /// **Returns**
  ///
  /// * The extra info data formatted as a list of strings
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  List<String> toInputFormat() {
    final List<String> output = <String>[];
    _data.forEach((final dynamic key, final dynamic value) {
      if (key is int) {
        // If the key is an integer, it means the original input was a single value
        output.add(value);
      } else {
        // If the key is not an integer, it means the original input was a key-value pair
        output.add('$key = $value');
      }
    });
    return output;
  }

  /// Method for adding a key-value pair to data
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* [dynamic]
  /// * **IN** *value* [dynamic]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void add(final dynamic key, final dynamic value) {
    _data[key] = value;
  }

  @override
  bool operator ==(covariant final ExtraInfo other) {
    if (identical(this, other)) {
      return true;
    }

    return mapEquals(_data, other._data);
  }

  @override
  int get hashCode {
    int hash = 0;
    for (final MapEntry<dynamic, dynamic> entry in _data.entries) {
      final dynamic value = entry.value;
      final dynamic key = entry.key;
      hash = hash ^ value.hashCode ^ key.hashCode;
    }

    return hash;
  }
}

/// Landmark class ideally for setting large amount of landmarks data. eg. for List of Landmarks.
class LandmarkJson {
  LandmarkJson({
    required this.coordinates,
    this.name,
    this.description,
    this.author,
    this.image,
    this.extrainfo,
    this.address,
  });
  String? name;
  String? description;
  String? author;
  GemImage? image;
  ExtraInfo? extrainfo;
  AddressInfo? address;
  final Coordinates? coordinates;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    if (address != null) {
      json['address'] = address!.pointerId;
    }
    if (image != null) {
      json['image'] = image;
    }
    if (coordinates != null) {
      json['coordinates'] = coordinates;
    }
    if (name != null) {
      json['name'] = name;
    }
    if (description != null) {
      json['description'] = description;
    }
    if (author != null) {
      json['author'] = author;
    }
    if (extrainfo != null) {
      json['extraInfo'] = extrainfo!.toInputFormat();
    }
    return json;
  }
}
