// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/map/pt_stop_info.dart';
import 'package:meta/meta.dart';

/// Overlay Ids enumeration
///
/// {@category Maps & 3D Scene}
enum CommonOverlayId {
  /// Safety overlay ID
  safety,

  /// Public transport overlay ID
  publicTransport,

  /// Social labels overlay ID
  socialLabels,

  /// Social reports overlay ID
  socialReports,
}

/// This class will not be documented
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension CommonOverlayIdExtension on CommonOverlayId {
  int get id {
    switch (this) {
      case CommonOverlayId.safety:
        return 0x50A04;

      case CommonOverlayId.publicTransport:
        return 0x2EEFAA;

      case CommonOverlayId.socialLabels:
        return 0xA200;

      case CommonOverlayId.socialReports:
        return 0xA300;
    }
  }

  static CommonOverlayId fromId(final int id) {
    switch (id) {
      case 0x50A04:
        return CommonOverlayId.safety;
      case 0x2EEFAA:
        return CommonOverlayId.publicTransport;
      case 0xA200:
        return CommonOverlayId.socialLabels;
      case 0xA300:
        return CommonOverlayId.socialReports;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Overlay category
///
/// {@category Maps & 3D Scene}
class OverlayCategory {
  OverlayCategory({
    required this.name,
    required this.overlayuid,
    required this.subcategories,
    required this.uid,
    required this.img,
  });

  factory OverlayCategory.fromJson(final Map<String, dynamic> json) {
    return OverlayCategory(
      img: Img.init(json['img']),
      name: json['name'],
      overlayuid: json['overlayuid'],
      subcategories: json['subcategories'] != null
          ? (json['subcategories'] as List<dynamic>)
              .map((final dynamic item) => OverlayCategory.fromJson(item))
              .toList()
          : <OverlayCategory>[],
      uid: json['uid'],
    );
  }

  /// The category icon
  Uint8List? get image => img.getRenderableImageBytes();

  /// The category name
  String name;

  /// The parent overlay ID
  int overlayuid;

  /// The subcategories
  List<OverlayCategory> subcategories;

  /// Check whether the category has subcategories
  bool get hasSubcategories => subcategories.isNotEmpty;

  /// The category ID
  int uid;

  /// The category icon
  Img img;
}

/// Overlay category
///
/// {@category Maps & 3D Scene}
class SocialReportsOverlayCategory extends OverlayCategory {
  SocialReportsOverlayCategory({
    required super.img,
    required super.name,
    required super.overlayuid,
    required super.uid,
    required this.overlaySubcategories,
    required this.country,
    required this.parameters,
  }) : super(subcategories: overlaySubcategories);

  factory SocialReportsOverlayCategory.fromJson(
    final Map<String, dynamic> json,
  ) {
    return SocialReportsOverlayCategory(
      img: Img.init(json['img']),
      name: json['name'],
      overlayuid: json['overlayuid'],
      overlaySubcategories: json['subcategories'] != null
          ? (json['subcategories'] as List<dynamic>)
              .map(
                (final dynamic item) => SocialReportsOverlayCategory.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList()
          : <SocialReportsOverlayCategory>[],
      uid: json['uid'],
      country: json['country'],
      parameters: SearchableParameterList.init(json['parameters']),
    );
  }

  /// Category ISO 3166-1 alpha-3 country code representation.
  String country;

  /// Report category parameters.
  SearchableParameterList parameters;

  /// The subcategories
  List<SocialReportsOverlayCategory> overlaySubcategories;
}

/// Overlay info class
///
/// This class should not be instantiated directly.
///
/// {@category Maps & 3D Scene}
class OverlayInfo extends GemAutoreleaseObject {
  // ignore: unused_element
  OverlayInfo._() : _pointerId = -1;

  @internal
  OverlayInfo.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(id);
  }
  final int _pointerId;
  int get pointerId => _pointerId;

  /// Get the overlay categories.
  ///
  /// **Returns**
  ///
  /// * Empty list if no categories are available.
  /// * Categories list if categories are available
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  List<OverlayCategory> get categories {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayInfo',
      'categories',
    );

    final List<OverlayCategory> overlayCategories =
        (resultString['result'] as List<dynamic>)
            .map<OverlayCategory>(
              (final dynamic item) => OverlayCategory.fromJson(item),
            )
            .toList();
    return overlayCategories;
  }

  /// Get the overlay category by Id.
  ///
  /// **Parameters**
  ///
  /// * **IN** *categId* The category id
  ///
  /// **Returns**
  ///
  /// * null if no category is found.
  /// * [OverlayCategory] if category is found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  OverlayCategory? getCategory(final int categId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayInfo',
      'getCategory',
      args: categId,
    );

    if (resultString['result']['uid'] == 0) {
      return null;
    }
    return OverlayCategory.fromJson(resultString['result']);
  }

  /// Get the image of the overlay.
  ///
  /// **Returns**
  ///
  /// * Empty if image is not available.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  Uint8List? get image {
    return img.getRenderableImageBytes();
  }

  /// Get the image of the overlay.
  ///
  /// **Returns**
  ///
  /// * The overlay image. The user is responsible to check if the image is valid
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  Img get img {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayInfo',
      'getImg',
    );

    return Img.init(resultString['result']);
  }

  /// Get the name of the overlay.
  ///
  /// **Returns**
  ///
  /// * The overlay name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  String get name {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayInfo',
      'name',
    );

    return resultString['result'];
  }

  /// Get the unique Id of the overlay.
  ///
  /// **Returns**
  ///
  /// * The overlay Id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get uid {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayInfo',
      'uid',
    );

    return resultString['result'];
  }

  /// Check if category has subcategories.
  ///
  /// **Parameters**
  ///
  /// * **IN** *categId* The category id
  ///
  /// **Returns**
  ///
  /// * True if category has subcategories, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool hasCategories(final int categId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayInfo',
      'hasCategories',
      args: categId,
    );

    return resultString['result'];
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, Object>{'class': 'OverlayInfo', 'id': _pointerId}),
    );
  }
}

/// Overlays collection.
///
/// This class should not be instantiated directly. Instead, use the related methods from [OverlayService].
///
/// {@category Maps & 3D Scene}
class OverlayCollection extends GemAutoreleaseObject {
  // ignore: unused_element
  OverlayCollection._() : _pointerId = -1;

  @internal
  OverlayCollection.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;
  int get pointerId => _pointerId;

  /// Get the number of overlay datasets in this collection.
  ///
  /// **Returns**
  ///
  /// * The number of overlays
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get size {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayCollection',
      'size',
    );
    return resultString['result'];
  }

  /// Get the overlay at the specified index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The index of the overlay
  ///
  /// **Returns**
  ///
  /// * Empty if the index is out of bounds
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  OverlayInfo? getOverlayAt(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayCollection',
      'getOverlayAt',
      args: index,
    );
    final int id = resultString['result'];

    if (id == -1) {
      return null;
    }

    return OverlayInfo.init(id);
  }

  /// Get the overlay having the specified UID.
  ///
  /// **Parameters**
  ///
  /// * **IN** *overlayUid* The overlay UID
  ///
  /// **Returns**
  ///
  /// * Empty if the overlay is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  OverlayInfo? getOverlayByUId(final int overlayUid) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayCollection',
      'getOverlayByUid',
      args: overlayUid,
    );
    final int id = resultString['result'];

    if (id == -1) {
      return null;
    }

    return OverlayInfo.init(id);
  }

  /// Check if an overlay is in the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *id* The overlay id. The list of available overlays can be obtained by using [OverlayService].
  ///
  /// **Returns**
  ///
  /// * True if overlay is in the collection, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool contains(final int overlayId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayCollection',
      'contains',
      args: overlayId,
    );
    return resultString['result'];
  }

  /// Check if overlay is added to the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *overlayId* The overlay id. The list of available overlays can be obtained by using [OverlayService].
  /// * **IN** *categoryId* The overlay category id in OverlayInfo.getCategories result list.
  ///
  /// **Returns**
  ///
  /// * True if overlay category is in the collection, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool containsCategory(final int overlayId, final int categoryId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayCollection',
      'containsCategory',
      args: <String, int>{'overlayId': overlayId, 'categoryId': categoryId},
    );
    return resultString['result'];
  }

  /// Provides the complete [OverlayInfo] list contained within the collection
  ///
  /// **Returns**
  ///
  /// * The OverlayInfo list
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  List<OverlayInfo> get overlayInfos {
    final OperationResult resultString = objectMethod(
      pointerId,
      'OverlayCollection',
      'getOverlays',
    );

    final List<dynamic> res = resultString['result'];
    return res.map((final dynamic e) => OverlayInfo.init(e)).toList();
  }
}

/// Mutable overlays collection.
///
/// This class should not be instantiated directly. Instead, use the related methods from [AlarmService].
///
/// {@category Maps & 3D Scene}
class OverlayMutableCollection extends OverlayCollection {
  // ignore: unused_element
  OverlayMutableCollection._() : super._();

  @internal
  OverlayMutableCollection.init(super.id) : super.init();

  /// Add an online overlay to the collection.
  ///
  /// Add an overlay to the collection. If the overlay has categories, all are added to the collection
  ///
  /// **Parameters**
  ///
  /// * **IN** *overlayId* The overlay id. The list of available overlays can be obtained by using [OverlayService].
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void add(final int overlayId) {
    objectMethod(
      _pointerId,
      'OverlayMutableCollection',
      'add',
      args: overlayId,
    );
  }

  /// Add an online overlay category to the collection.
  ///
  /// Add an overlay category id to the collection
  ///
  /// **Parameters**
  ///
  /// * **IN** *overlayId* The overlay id. The list of available overlays can be obtained by using [OverlayService].
  /// * **IN** *categoryId* The category id in [OverlayInfo.categories] result list
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void addCategory({
    required final int overlayId,
    required final int categoryId,
  }) {
    objectMethod(
      _pointerId,
      'OverlayMutableCollection',
      'addCategory',
      args: <String, int>{'overlayId': overlayId, 'categoryId': categoryId},
    );
  }

  /// Clear all overlays in collection.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void clear() {
    objectMethod(_pointerId, 'OverlayMutableCollection', 'clear');
  }

  /// Remove the overlay from the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *overlayId* the overlay id. The list of available overlays can be obtained by using [OverlayService]
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, [GemError.notFound] if the overlay is not in the collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError remove(final int overlayId) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayMutableCollection',
      'remove',
      args: overlayId,
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Remove the overlay from the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *overlayId* the overlay id. The list of available overlays can be obtained by using [OverlayService]
  /// * **IN** *categoryId* The category id in [OverlayInfo.categories] result list
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, [GemError.notFound] if the overlay is not in the collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  GemError removeCategory({
    required final int overlayId,
    required final int categoryId,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayMutableCollection',
      'removeCategory',
      args: <String, int>{'overlayId': overlayId, 'categoryId': categoryId},
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }
}

/// Overlay service class
///
/// {@category Maps & 3D Scene}
class OverlayService {
  /// Get a list of available SDK overlays.
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener* Progress listener. If not all overlays info is available onboard, a notification will be sent when it will be downloaded.
  ///
  /// **Returns**
  ///
  /// * Record of [OverlayCollection], [bool]. If `$2 == false`, some overlay information is not available and will be downloaded when network is available.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static (OverlayCollection, bool) getAvailableOverlays({
    final void Function(GemError error)? onCompleteDownload,
  }) {
    EventDrivenProgressListener? listener;
    if (onCompleteDownload != null) {
      listener = EventDrivenProgressListener();

      listener.registerOnCompleteWithDataCallback((
        final int err,
        final String hint,
        final Map<dynamic, dynamic> json,
      ) {
        GemKitPlatform.instance.unregisterEventHandler(listener!.id);
        onCompleteDownload(GemErrorExtension.fromCode(err));
      });

      GemKitPlatform.instance.registerEventHandler(listener.id, listener);
    }

    final OperationResult resultString = objectMethod(
      0,
      'OverlayService',
      'getAvailableOverlays',
      args: (listener != null) ? listener.id : 0,
    );

    final (OverlayCollection, bool) result = (
      OverlayCollection.init(resultString['result']['first']),
      resultString['result']['second'],
    );

    if (onCompleteDownload != null && result.$2) {
      onCompleteDownload(GemError.success);
    }

    return result;
  }

  /// Enables the overlay with the given uid. This will activate the overlay for all registered services ( map views, alarms, etc ).
  ///
  /// If *categUid* is given the value -1, then the whole overlay will be enabled.
  ///
  /// **Parameters**
  ///
  ///  * **IN** *uid* The overlay uid
  ///  * **IN** *categUid* The overlay category uid ( optional )
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, [GemError.notFound] if the overlay is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static GemError enableOverlay(final int uid, {final int categUid = -1}) {
    final OperationResult resultString = objectMethod(
      0,
      'OverlayService',
      'enableOverlay',
      args: <String, int>{'uid': uid, 'categUid': categUid},
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Disables the overlay with the given uid. This will deactivate the overlay for all registered services ( map views, alarms, etc )
  ///
  /// If *categUid* is given the value -1, then the whole overlay will be disabled.
  ///
  /// **Parameters**
  ///
  /// * **IN** *uid* The overlay uid
  /// * **IN** *categUid* The overlay category uid ( optional )
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, [GemError.notFound] if the overlay is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static GemError disableOverlay(final int uid, {final int categUid = -1}) {
    final OperationResult resultString = objectMethod(
      0,
      'OverlayService',
      'disableOverlay',
      args: <String, int>{'uid': uid, 'categUid': categUid},
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Check if the overlay with the given uid is enabled.
  ///
  /// If [categUid] is -1 the whole overlay will be disabled.
  ///
  /// **Parameters**
  /// * **IN** *uid* The overlay uid
  /// * **IN** *categUid* The overlay category uid ( optional )
  ///
  /// **Returns**
  ///
  /// * True if the overlay is enabled, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static bool isOverlayEnabled(final int uid, {final int categUid = -1}) {
    final OperationResult resultString = objectMethod(
      0,
      'OverlayService',
      'isOverlayEnabled',
      args: <String, int>{'uid': uid, 'categUid': categUid},
    );

    return resultString['result'];
  }
}

/// Class representing an overlay item.
///
/// This class should not be instantiated directly.
///
/// {@category Maps & 3D Scene}
class OverlayItem extends GemAutoreleaseObject {
  // ignore: unused_element
  OverlayItem._() : _pointerId = -1;

  @internal
  OverlayItem.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(id);
  }
  final int _pointerId;
  int get pointerId => _pointerId;

  /// Get OverlayItem category id.
  ///
  /// **Returns**
  ///
  /// * The overlay category id if it exists, otherwise 0
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get categoryId {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItem',
      'getCategoryId',
    );

    return resultString['result'];
  }

  /// Get the OverlayItem coordinates
  ///
  /// **Returns**
  ///
  /// * The OverlayItem coordinates if they are available
  /// * Coordinates with [Coordinates.isValid] field false if the coordinates are not available
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  Coordinates get coordinates {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItem',
      'coordinates',
    );

    return Coordinates.fromJson(resultString['result']);
  }

  /// Check if this type of [OverlayItem] has preview EXTENDED data (dynamic data that needs to be downloaded)
  ///
  /// **Returns**
  ///
  /// * True if this type of [OverlayItem] has preview EXTENDED data, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get hasPreviewExtendedData {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItem',
      'hasPreviewExtendedData',
    );

    return resultString['result'];
  }

  /// Get the image of the item
  ///
  /// **Returns**
  ///
  /// * The image of the item if available, otherwise empty image
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  Uint8List get image {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItem',
      'image',
    );

    return base64Decode(resultString['result']);
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
  Img get img {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItem',
      'img',
    );

    return Img.init(resultString['result']);
  }

  /// Get the name of the item.
  ///
  /// **Returns**
  ///
  /// * The name of the item if available, otherwise empty string
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  String get name {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItem',
      'name',
    );

    return resultString['result'];
  }

  /// Get the unique ID of the item within the overlay.
  ///
  /// ** Returns**
  ///
  /// * The item ID
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get uid {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItem',
      'uid',
    );

    return resultString['result'];
  }

  /// Get the parent overlay info.
  ///
  /// **Returns**
  ///
  /// * Empty if OverlayItem is empty
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  OverlayInfo? get overlayInfo {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItem',
      'overlayinfo',
    );

    if (resultString['result'] == -1) {
      return null;
    }

    return OverlayInfo.init(resultString['result']);
  }

  /// Get [OverlayItem] preview data as parameters list.
  ///
  /// **Returns**
  ///
  /// * The [OverlayItem] preview data as parameters list
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  SearchableParameterList get previewData {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItem',
      'getPreviewData',
    );

    return SearchableParameterList.init(resultString['result']);
  }

  /// Get [OverlayItem] preview data as JSON.
  ///
  /// **Returns**
  ///
  /// * The [OverlayItem] preview data as JSON
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  Map<dynamic, dynamic> get previewDataJson {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItem',
      'getPreviewDataJson',
    );

    return jsonDecode(resultString['result']);
  }

  /// Get the preview URL for the item (if any).
  ///
  /// The preview URL may be opened by the UI into a web browser window to present more details to the user about this item.
  ///
  /// **Returns**
  ///
  /// * Empty if the item has no preview URL.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  String get previewUrl {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItem',
      'previewurl',
    );

    return resultString['result'];
  }

  /// Get the parent overlay UID.
  ///
  /// The parent overlay UID
  ///
  /// **Returns**
  ///
  /// * The parent overlay UID if it exists
  /// * 0 otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get overlayUid {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItem',
      'overlayuid',
    );

    return resultString['result'];
  }

  /// Check if the overlay is of the given type.
  ///
  /// **Parameters**
  ///
  /// * **IN** *overlayId* The overlay type you want to check
  ///
  /// **Returns**
  ///
  /// * True if the overlay is of the given type, false otherwise
  bool isOfType(CommonOverlayId overlayId) {
    return overlayUid == overlayId.id;
  }

  /// Get the [PTStopInfo] object for this item.
  ///
  /// **Returns**
  ///
  /// * The [PTStopInfo] object if the item is of type [CommonOverlayId.publicTransport]
  /// * null if the item is not of type [CommonOverlayId.publicTransport]
  ///
  Future<PTStopInfo?> getPTStopInfo() async {
    final Completer<PTStopInfo?> completer = Completer<PTStopInfo?>();

    if (isOfType(CommonOverlayId.publicTransport)) {
      // Trigger the callback-based async operation
      getPreviewExtendedData((GemError err, SearchableParameterList? params) {
        if (params != null) {
          // If successful, complete the Future with PTStopInfo
          completer.complete(PTStopInfo.fromParameters(params));
        } else {
          // In case of an error or null params, complete with null
          completer.complete(null);
        }
      });
    } else {
      // If the item isn't of the correct type, complete with null
      completer.complete(null);
    }

    // Return the Future that will eventually be completed
    return completer.future;
  }

  /// Asynchronous get [OverlayItem] preview EXTENDED data (dynamic data that needs to be downloaded) as parameters list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *onComplete* Will be invoked when the operation is completed, providing the results and an error code.
  ///   * Will call with error code [GemError.success] and non-null results on success
  ///   * Will call with error code [GemError.invalidInput] and null results if no listener was provided.
  ///   * Will call with error code [GemError.couldNotStart] and null results if the request couldn't be started
  ///   * Will call with error code [GemError.notSupported] and null results if called even though [hasPreviewExtendedData] returned false
  ///   * Will call with error code [GemError.general] and null results in any other error case
  ///   * Will call with other error codes and null results if an error occurred.
  ///
  /// **Returns**
  ///
  /// * The [ProgressListener] associated with the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  ProgressListener getPreviewExtendedData(
    final void Function(GemError error, SearchableParameterList? parameters)
        onComplete,
  ) {
    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
    final SearchableParameterList params = SearchableParameterList.create(0);

    progListener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);
      if (err != 0) {
        onComplete(GemErrorExtension.fromCode(err), null);
      } else {
        onComplete(GemErrorExtension.fromCode(err), params);
      }
    });

    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItem',
      'getPreviewExtendedData',
      args: <String, dynamic>{
        'list': params.pointerId,
        'listener': progListener.id,
      },
    );

    final int id = resultString['result'];

    if (id != 0) {
      onComplete(GemErrorExtension.fromCode(id), null);
    }

    return progListener;
  }

  /// Cancel an asynchronous [getPreviewExtendedData] operation.
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener* The [ProgressListener] used to identify the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void cancelGetPreviewExtendedData(final ProgressListener listener) {
    objectMethod(
      _pointerId,
      'OverlayItem',
      'cancelGetPreviewExtendedData',
      args: <String, dynamic>{'progress': listener.id},
    );
  }
}

/// Coordinate referenced [OverlayItem] object.
///
/// This class should not be instantiated directly.
///
/// {@category Maps & 3D Scene}
class OverlayItemPosition extends GemAutoreleaseObject {
  // ignore: unused_element
  OverlayItemPosition._() : _pointerId = -1;

  @internal
  OverlayItemPosition.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(id);
  }
  final int _pointerId;
  int get pointerId => _pointerId;

  /// Get the [OverlayItem] object.
  ///
  /// **Returns**
  ///
  /// * The [OverlayItem] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  OverlayItem get overlayItem {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItemPosition',
      'getOverlayItem',
    );

    return OverlayItem.init(resultString['result']);
  }

  /// Get distance in meters from reference coordinates to the OverlayItem object.
  ///
  /// **Returns**
  ///
  /// * The distance in meters from reference coordinates
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int get distance {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'OverlayItemPosition',
      'getDistance',
    );

    return resultString['result'];
  }
}

/// Overlay generic parameters ids
///
/// {@category Maps & 3D Scene}
abstract class PredefinedOverlayGenericParametersIds {
  /// LargeInteger
  static const String id = 'id';

  /// String
  static const String categName = 'type';

  /// int
  static const String categId = 'icon';

  /// String
  static const String country = 'Country';

  /// String
  static const String location = 'eStrLocation';

  /// List of Parameter( key, value, name:translated )
  static const String keyVals = 'keyvals';

  /// double
  static const String longitude = 'longitude';

  /// double
  static const String latitude = 'latitude';

  /// String
  static const String address = 'location_address';

  /// int UTC timestamp ( seconds )
  static const String releaseDate = 'create_stamp_utc';
}
