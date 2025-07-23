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
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/task_handler.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// The map projection type
///
/// {@category Projections}
enum ProjectionType {
  /// British National Grid (BNG)
  bng,

  /// Lambert 93 (LAM)
  lam,

  /// Universal Transverse Mercator (UTM)
  utm,

  /// Military Grid Reference System (MGRS)
  mgrs,

  /// Gauss-Krüger (GK)
  gk,

  /// World Geodetic System (WGS84)
  wgs84,

  /// What3Words (W3W)
  w3w,

  /// Undefined
  undefined
}

/// The hemisphere type
///
/// {@category Projections}
enum Hemisphere {
  ///< Southern Hemisphere
  south,

  ///< Northern Hemisphere
  north,
}

/// @nodoc
extension HemisphereExtension on Hemisphere {
  int get id {
    switch (this) {
      case Hemisphere.south:
        return 0;
      case Hemisphere.north:
        return 1;
    }
  }

  static Hemisphere fromId(final int id) {
    switch (id) {
      case 0:
        return Hemisphere.south;
      case 1:
        return Hemisphere.north;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// @nodoc
extension ProjectionTypeExtension on ProjectionType {
  int get id {
    switch (this) {
      case ProjectionType.bng:
        return 0;
      case ProjectionType.lam:
        return 1;
      case ProjectionType.utm:
        return 2;
      case ProjectionType.mgrs:
        return 3;
      case ProjectionType.gk:
        return 4;
      case ProjectionType.wgs84:
        return 5;
      case ProjectionType.w3w:
        return 6;
      case ProjectionType.undefined:
        return 7;
    }
  }

  static ProjectionType fromId(final int id) {
    switch (id) {
      case 0:
        return ProjectionType.bng;
      case 1:
        return ProjectionType.lam;
      case 2:
        return ProjectionType.utm;
      case 3:
        return ProjectionType.mgrs;
      case 4:
        return ProjectionType.gk;
      case 5:
        return ProjectionType.wgs84;
      case 6:
        return ProjectionType.w3w;
      case 7:
        return ProjectionType.undefined;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Projection interface which deals with all types of projections.
///
/// {@category Projections}
class Projection extends GemAutoreleaseObject {
  // ignore: unused_element
  Projection._() : _pointerId = -1;

  @internal
  Projection.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }

  final int _pointerId;

  dynamic get pointerId => _pointerId;

  /// Retrieves the specific type of the projection.
  ///
  /// **Returns**
  ///
  /// * The type of the projection as an [ProjectionType] enumeration.
  ProjectionType get type {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Projection',
      'type',
    );

    return ProjectionTypeExtension.fromId(resultString['result']);
  }
}

/// Projection service class
///
/// {@category Projections}
abstract class ProjectionService {
  /// Async method that returns the projection result from an input projection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* The type of projection to cast to.
  /// * **IN** *from* The input projection that needs to be converted.
  /// * **IN** *onCompleteCallback* Callback for the operation completion.
  ///   * **err** [GemError] The error code returned by the operation.
  ///   * [GemError.success] and a non-null [Projection] if the conversion was successfully completed
  ///   * [GemError.notSupported] and null if the conversion cannot be done
  ///   * [GemError.internalAbort] and null if the result parsing failed or server internal error occurred
  ///
  /// **Returns**
  ///
  /// * A [TaskHandler] that can be used to track the progress of the operation or null if it failed.
  static TaskHandler? convert(
      {required Projection from,
      required ProjectionType toType,
      required final void Function(GemError err, Projection? result)
          onCompleteCallback}) {
    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();

    late Projection result;

    switch (toType) {
      case ProjectionType.bng:
        result = BNGProjection(easting: 0, northing: 0);

      case ProjectionType.lam:
        result = LAMProjection(x: 0, y: 0);

      case ProjectionType.utm:
        result =
            UTMProjection(x: 0, y: 0, zone: 0, hemisphere: Hemisphere.north);

      case ProjectionType.mgrs:
        result = MGRSProjection(easting: 0, northing: 0, zone: '', letters: '');

      case ProjectionType.gk:
        result = GKProjection(x: 0, y: 0, zone: 0);

      case ProjectionType.wgs84:
        result = WGS84Projection(Coordinates());

      case ProjectionType.w3w:
        result = W3WProjection('');
      case ProjectionType.undefined:
        throw UnimplementedError();
    }

    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);

    progListener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);

      if (err == GemError.success.code) {
        onCompleteCallback(GemErrorExtension.fromCode(err), result);
      } else {
        onCompleteCallback(GemErrorExtension.fromCode(err), null);
      }
    });

    final OperationResult resultString = staticMethod(
      'ProjectionService',
      'convert',
      args: <String, dynamic>{
        'from': from.pointerId,
        'to': result.pointerId,
        'listener': progListener.id,
      },
    );

    final GemError errorCode =
        GemErrorExtension.fromCode(resultString['result']);

    if (errorCode != GemError.success) {
      onCompleteCallback(errorCode, null);
      return null;
    }

    return TaskHandlerImpl(progListener.id);
  }
}

/// GKProjection class
///
/// {@category Projections}
class GKProjection extends Projection {
  factory GKProjection(
      {required double x, required double y, required int zone}) {
    return GKProjection._create(x, y, zone);
  }
  GKProjection.init(super.id) : super.init();

  static GKProjection _create(double x, double y, int zone) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, dynamic>{
        'class': 'Projection_GK',
        'x': x,
        'y': y,
        'zone': zone,
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    final GKProjection retVal = GKProjection.init(decodedVal['result']);
    return retVal;
  }

  /// Sets the horizontal axis, vertical axis and zone of the point.
  ///
  /// **Parameters**
  ///
  /// * **IN** *x* The x coordinate of the point.
  /// * **IN** *y* The y coordinate of the point.
  /// * **IN** *zone* The zone of the point.
  void setFields({required double x, required double y, required int zone}) {
    objectMethod(
      _pointerId,
      'Projection_GK',
      'set',
      args: <String, dynamic>{'x': x, 'y': y, 'zone': zone},
    );
  }

  /// Retrieves the easting of the point.
  ///
  /// **Returns**
  ///
  /// * The easting of the point as a double.
  double get easting {
    final OperationResult result = objectMethod(
      _pointerId,
      'Projection_GK',
      'getEasting',
    );

    return result['result'];
  }

  /// Retrieves the northing of the point.
  ///
  /// **Returns**
  ///
  /// * The northing of the point as a double.
  double get northing {
    final OperationResult result = objectMethod(
      _pointerId,
      'Projection_GK',
      'getNorthing',
    );

    return result['result'];
  }

  /// Retrieves the zone of the point.
  ///
  /// **Returns**
  ///
  /// * The zone of the point as an integer.
  int get zone {
    final OperationResult result = objectMethod(
      _pointerId,
      'Projection_GK',
      'getZone',
    );

    return result['result'];
  }
}

/// BNGProjection class
///
/// {@category Projections}
class BNGProjection extends Projection {
  factory BNGProjection({required double easting, required double northing}) {
    return BNGProjection._create(easting, northing);
  }
  BNGProjection.init(super.id) : super.init();

  static BNGProjection _create(double easting, double northing) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, dynamic>{
        'class': 'Projection_BNG',
        'easting': easting,
        'northing': northing,
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    final BNGProjection retVal = BNGProjection.init(decodedVal['result']);
    return retVal;
  }

  /// Sets the easting and northing of the point.
  ///
  /// **Parameters**
  ///
  /// * **IN** *easting* The easting coordinate of the point.
  /// * **IN** *northing* The northing coordinate of the point.
  void setFields({required double easting, required double northing}) {
    objectMethod(
      _pointerId,
      'Projection_BNG',
      'set',
      args: <String, dynamic>{
        'easting': easting,
        'northing': northing,
      },
    );
  }

  /// Sets the grid reference of the point.
  ///
  /// **Parameters**
  ///
  /// * **IN** *gridReference* The grid reference of the point.
  set gridReference(String gridReference) {
    objectMethod(
      _pointerId,
      'Projection_BNG',
      'setGridReference',
      args: gridReference,
    );
  }

  /// Retrieves the grid reference of the point.
  ///
  /// **Returns**
  ///
  /// * The grid reference of the point as a string.
  String get gridReference {
    final OperationResult resultString =
        objectMethod(_pointerId, 'Projection_BNG', 'getGridReference');

    return resultString['result'];
  }

  /// Retrieves the easting of the point.
  ///
  /// **Returns**
  ///
  /// * The easting of the point as a double.
  double get easting {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Projection_BNG',
      'getEasting',
    );

    return resultString['result'];
  }

  /// Retrieves the northing of the point.
  ///
  /// **Returns**
  ///
  /// * The northing of the point as a double.
  double get northing {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Projection_BNG',
      'getNorthing',
    );

    return resultString['result'];
  }
}

/// UTMProjection class
///
/// {@category Projections}
class UTMProjection extends Projection {
  /// Creates a new UTMProjection
  factory UTMProjection(
      {required double x,
      required double y,
      required int zone,
      required Hemisphere hemisphere}) {
    return UTMProjection._create(x, y, zone, hemisphere);
  }
  UTMProjection.init(super.id) : super.init();

  static UTMProjection _create(
      double x, double y, int zone, Hemisphere hemisphere) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, dynamic>{
        'class': 'Projection_UTM',
        'x': x,
        'y': y,
        'zone': zone,
        'hemisphere': hemisphere.index,
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    final UTMProjection retVal = UTMProjection.init(decodedVal['result']);
    return retVal;
  }

  /// Sets the horizontal axis, vertical axis, zone and hemisphere of the point.
  ///
  /// **Parameters**
  ///
  /// * **IN** *x* The x coordinate of the point.
  /// * **IN** *y* The y coordinate of the point.
  /// * **IN** *zone* The zone of the point.
  /// * **IN** *hemisphere* The [Hemisphere] of the point.
  void setFields(
      {required double x,
      required double y,
      required int zone,
      required Hemisphere hemisphere}) {
    objectMethod(
      _pointerId,
      'Projection_UTM',
      'set',
      args: <String, dynamic>{
        'x': x,
        'y': y,
        'zone': zone,
        'hemisphere': hemisphere.index,
      },
    );
  }

  /// Returns the x coordinate of the point.
  ///
  ///  **Returns**
  ///
  /// * The x coordinate of the point as a double.
  double get x {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Projection_UTM',
      'getX',
    );

    return resultString['result'];
  }

  /// Returns the y coordinate of the point.
  ///
  /// **Returns**
  ///
  /// * The y coordinate of the point as a double.
  double get y {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Projection_UTM',
      'getY',
    );

    return resultString['result'];
  }

  /// Retrieves the zone of the point.
  ///
  /// **Returns**
  ///
  /// * The zone of the point as an integer.
  int get zone {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Projection_UTM',
      'getZone',
    );

    return resultString['result'];
  }

  /// Retrieves the hemisphere of the point.
  ///
  /// **Returns**
  ///
  /// * The hemisphere of the point as a [Hemisphere] enumeration.
  Hemisphere get hemisphere {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Projection_UTM',
      'getHemisphere',
    );

    return HemisphereExtension.fromId(resultString['result']);
  }
}

/// MGRSProjection class
///
/// {@category Projections}
class MGRSProjection extends Projection {
  /// Creates a new MGRSProjection
  factory MGRSProjection(
      {required double easting,
      required double northing,
      required String zone,
      required String letters}) {
    return MGRSProjection._create(easting, northing, zone, letters);
  }
  MGRSProjection.init(super.id) : super.init();

  static MGRSProjection _create(
      double x, double y, String zone, String letters) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, dynamic>{
        'class': 'Projection_MGRS',
        'easting': x,
        'northing': y,
        'zone': zone,
        'letters': letters,
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    final MGRSProjection retVal = MGRSProjection.init(decodedVal['result']);
    return retVal;
  }

  /// Sets the easting, northing, zone and letters of the point.
  ///
  /// **Parameters**
  ///
  /// * **IN** *easting* The easting coordinate of the point.
  /// * **IN** *northing* The northing coordinate of the point.
  /// * **IN** *zone* The zone of the point as a string.
  /// * **IN** *letters* The letters of the point as a string.
  void setFields(
      {required int easting,
      required int northing,
      required String zone,
      required String letters}) {
    objectMethod(
      _pointerId,
      'Projection_MGRS',
      'set',
      args: <String, dynamic>{
        'easting': easting,
        'northing': northing,
        'zone': zone,
        'letters': letters,
      },
    );
  }

  /// Returns the letters of the point.
  ///
  ///  **Returns**
  ///
  /// * The letters of the point as a string.
  String get letters {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Projection_MGRS',
      'getSq100kIdentifier',
    );

    return resultString['result'];
  }

  /// Returns the easting coordinate of the point.
  ///
  ///  **Returns**
  ///
  /// * The easting coordinate of the point as an integer.
  int get easting {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Projection_MGRS',
      'getEasting',
    );

    return resultString['result'];
  }

  /// Returns the northing coordinate of the point.
  ///
  ///  **Returns**
  ///
  /// * The northing coordinate of the point as an integer.
  int get northing {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Projection_MGRS',
      'getNorthing',
    );

    return resultString['result'];
  }

  /// Returns the zone of the point.
  ///
  ///  **Returns**
  ///
  /// * The zone of the point as a string.
  String get zone {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Projection_MGRS',
      'getZone',
    );

    return resultString['result'];
  }
}

/// W3WProjection class
///
/// {@category Projections}
class W3WProjection extends Projection {
  factory W3WProjection(String threeWords) {
    return W3WProjection._create(threeWords);
  }
  W3WProjection.init(super.id) : super.init();

  static W3WProjection _create(String token) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, dynamic>{
        'class': 'Projection_W3W',
        'token': token,
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    final W3WProjection retVal = W3WProjection.init(decodedVal['result']);
    return retVal;
  }

  /// Sets the token for the W3WProjection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *token* An user obtained token from What3Words services.
  set token(String token) {
    objectMethod(
      _pointerId,
      'Projection_W3W',
      'setToken',
      args: token,
    );
  }

  /// Sets the words for the W3WProjection.
  ///
  ///  **Parameters**
  ///
  /// * **IN** *words* The three words that represent the location.
  set words(String words) {
    objectMethod(
      _pointerId,
      'Projection_W3W',
      'setWords',
      args: words,
    );
  }

  /// Retrieves the three words that represent the location.
  ///
  /// **Returns**
  ///
  /// * The three words that represent the location as a string.
  String get words {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Projection_W3W',
      'getWords',
    );

    return resultString['result'];
  }

  /// Retrieves the token from the What3Words services.
  ///
  /// **Returns**
  ///
  /// * The token as a string.
  String get token {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Projection_W3W',
      'getToken',
    );

    return resultString['result'];
  }
}

/// LAMProjection class
///
///  {@category Projections}
class LAMProjection extends Projection {
  /// Creates a new LAMProjection
  factory LAMProjection({required double x, required double y}) {
    return LAMProjection._create(x, y);
  }
  LAMProjection.init(super.id) : super.init();

  static LAMProjection _create(double x, double y) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, dynamic>{
        'class': 'Projection_LAM',
        'x': x,
        'y': y,
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    final LAMProjection retVal = LAMProjection.init(decodedVal['result']);
    return retVal;
  }

  /// Sets the horizontal axis and vertical axis of the point.
  ///
  /// **Parameters**
  ///
  /// * **IN** *x* The x coordinate of the point.
  /// * **IN** *y* The y coordinate of the point.
  void setFields({required double x, required double y}) {
    objectMethod(
      _pointerId,
      'Projection_LAM',
      'set',
      args: <String, dynamic>{
        'x': x,
        'y': y,
      },
    );
  }

  /// Retrieves the horizontal axis of the point.
  ///
  /// **Returns**
  ///
  /// * The x coordinate of the point as a double.
  double get x {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Projection_LAM',
      'getX',
    );

    return resultString['result'];
  }

  /// Retrieves the vertical axis of the point.
  ///
  /// **Returns**
  ///
  /// * The y coordinate of the point as a double.
  double get y {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Projection_LAM',
      'getY',
    );

    return resultString['result'];
  }
}

/// WGS84Projection class
///
/// {@category Projections}
class WGS84Projection extends Projection {
  factory WGS84Projection(Coordinates coordinates) {
    return WGS84Projection._create(coordinates);
  }

  factory WGS84Projection.fromLatLong(
      {required double latitude, required double longitude}) {
    return WGS84Projection._create(
        Coordinates(latitude: latitude, longitude: longitude));
  }
  WGS84Projection.init(super.id) : super.init();

  static WGS84Projection _create(Coordinates coordinates) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(
        <String, dynamic>{
          'class': 'Projection_WGS84',
          'coordinates': coordinates,
        },
      ),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    final WGS84Projection retVal = WGS84Projection.init(decodedVal['result']);
    return retVal;
  }

  /// Returns the coordinates for the WGS84Projection.
  ///
  /// **Returns**
  ///
  /// * The coordinates as a [Coordinates] object, or null if the coordinates are not set.
  Coordinates? get coordinates {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'Projection_WGS84',
      'getCoordinates',
    );

    if (resultString['result'] == null) {
      return null;
    }

    return Coordinates.fromJson(resultString['result']);
  }

  /// Sets the coordinates for the WGS84Projection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coordinates* The coordinates to set for the projection.
  set coordinates(Coordinates? coordinates) {
    coordinates ??= Coordinates();

    objectMethod(
      _pointerId,
      'Projection_WGS84',
      'set',
      args: coordinates.toJson(),
    );
  }
}
