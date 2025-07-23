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
import 'dart:ui' show Color;

import 'package:flutter/material.dart' show Colors;
import 'package:gem_kit/core.dart';
import 'package:gem_kit/map.dart';
import 'package:gem_kit/src/core/extensions.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Mapview Routes collection class
///
/// This class should not be instantiated directly. Instead, use the [MapViewPreferences.routes] getter to obtain an instance.
///
/// {@category Routes & Navigation}
class MapViewRoutesCollection extends GemList<Route> {
  MapViewRoutesCollection(final dynamic id)
      : super(
          id,
          'MapViewRouteCollection',
          (final dynamic data) => Route.init(data),
        ) {
    super.registerAutoReleaseObject(id);
  }

  // ignore: unused_element
  MapViewRoutesCollection._()
      : super(
          0,
          'MapViewRouteCollection',
          (final dynamic data) => Route.init(data),
        );

  @internal
  MapViewRoutesCollection.init(final int id)
      : super(
          id,
          'MapViewRouteCollection',
          (final dynamic data) => Route.init(data),
        ) {
    super.registerAutoReleaseObject(id);
    hasInit = true;
  }
  bool hasInit = false;

  /// Add or update a route in the collection with the given render settings.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route to be added / updated.
  /// * **IN** *bMainRoute* True if the route is the main route, false if it is an alternative route.
  /// * **IN** *label* [Route] label string.
  /// * **IN** *images* [Route] label images.
  /// * **IN** *routeRenderSettings* [Route] render settings.
  /// * **IN** *autoGenerateLabel* True if the label should be generated automatically.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void add(
    final Route route,
    final bool bMainRoute, {
    final String? label,
    RouteRenderSettings? routeRenderSettings,
    final bool autoGenerateLabel = false,
  }) {
    routeRenderSettings ??= RouteRenderSettings();
    if (bMainRoute) {
      routeRenderSettings.options = <RouteRenderOptions>{
        RouteRenderOptions.main,
        ...routeRenderSettings.options,
      };
    }
    objectMethod(
      pointerId,
      'MapViewRouteCollection',
      'add',
      args: <String, dynamic>{
        'route': route.pointerId,
        'bMainRoute': bMainRoute,
        'routeRenderSettings': routeRenderSettings,
        'autoGenerateLabel': autoGenerateLabel,
        if (label != null) 'label': label,
      },
    );
  }

  /// Add or update a route in the collection.
  ///
  /// If the route already exists in the collection, it will be updated with the new settings.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route to be added / updated.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void addMapViewRoute(final MapViewRoute route) {
    objectMethod(
      pointerId,
      'MapViewRouteCollection',
      'add',
      args: route.pointerId,
    );
  }

  /// Remove all routes.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void clear() {
    objectMethod(pointerId, 'MapViewRouteCollection', 'clear');
  }

  /// Remove all routes, except the main route.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void clearAllButMainRoute() {
    objectMethod(pointerId, 'MapViewRouteCollection', 'clearAllButMainRoute');
  }

  /// Get route label text.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route whose label should be retrieved.
  ///
  /// **Returns**
  ///
  /// * The actual label
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String getLabel(final Route route) {
    final OperationResult resultString = objectMethod(
      pointerId,
      'MapViewRouteCollection',
      'getLabel',
      args: route.pointerId,
    );

    return resultString['result'];
  }

  /// Get the current main route.
  ///
  /// **Returns**
  ///
  /// * The main route from the collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Route? get mainRoute {
    final OperationResult resultString = objectMethod(
      pointerId,
      'MapViewRouteCollection',
      'getMainRoute',
    );

    final dynamic result = resultString['result'];
    if (result['empty'] == true) {
      return null;
    }
    return Route.init(result['oid']);
  }

  /// Get map view route in collection by route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The map view route index in collection.
  ///
  /// The main route in the collection
  ///
  /// **Returns**
  ///
  /// * [MapViewRoute] object if a route with the given index exists, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MapViewRoute? getMapViewRoute(final int index) {
    final OperationResult resultString = objectMethod(
      pointerId,
      'MapViewRouteCollection',
      'getMapViewRoute',
      args: index,
    );

    if (resultString['gemApiError'] == -11) {
      return null;
    }
    return MapViewRoute.init(resultString['result'], this);
  }

  /// Get route specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The index of the route in the collection
  ///
  /// The main route in the collection
  ///
  /// **Returns**
  ///
  /// * [Route] object if index is valid, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Route? getRoute(final int index) {
    final OperationResult resultString = objectMethod(
      pointerId,
      'MapViewRouteCollection',
      'getRoute',
      args: index,
    );

    final dynamic result = resultString['result'];
    if (result['empty'] == true) {
      return null;
    }
    return Route.init(result['oid']);
  }

  /// Hide route label.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route for which the label should be hidden
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void hideLabel(final Route route) {
    objectMethod(
      pointerId,
      'MapViewRouteCollection',
      'hideLabel',
      args: route.pointerId,
    );
  }

  /// Get the index of the specified route
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route to be found
  ///
  /// **Returns**
  ///
  /// * The index of the route in the collection
  /// * [GemError.notFound].code if the route is not in the collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int indexOf(final Route route) {
    final OperationResult resultString = objectMethod(
      pointerId,
      'MapViewRouteCollection',
      'indexOf',
      args: route.pointerId,
    );

    return resultString['result'];
  }

  /// Check if the route is the main route in the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route to be checked
  ///
  /// **Returns**
  ///
  /// * True if the route is the main route in the collection
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool isMainRoute(final Route route) {
    final OperationResult resultString = objectMethod(
      pointerId,
      'MapViewRouteCollection',
      'isMainRoute',
      args: route.pointerId,
    );

    return resultString['result'];
  }

  /// Set route bubble text.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route whose label should be set.
  /// * **IN** *label* The label.
  ///
  /// The route label supports custom icon placement inside the text by using the icon place-mark `%icon index%%`, e.g. `'My header text %%0%%\n%%1%% my footer'`.
  ///
  /// The `_icon index_` must be a valid integer in images list container, i.e. 0 <= icon index < images.size()
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setLabel(final Route route, final String text) {
    objectMethod(
      pointerId,
      'MapViewRouteCollection',
      'setLabel',
      args: <String, dynamic>{'route': route.pointerId, 'label': text},
    );
  }

  /// Set the route as the main route in the collection.
  ///
  /// Does not work unless the route is already in the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route to be set as the main route.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set mainRoute(final Route? route) {
    if (route == null) {
      ApiErrorServiceImpl.apiErrorAsInt = GemError.invalidInput.code;
      return;
    }

    objectMethod(
      pointerId,
      'MapViewRouteCollection',
      'setMainRoute',
      args: route.pointerId,
    );
  }

  /// Remove the route from the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route to be removed
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void remove(final Route route) {
    objectMethod(
      pointerId,
      'MapViewRouteCollection',
      'remove',
      args: route.pointerId,
    );
  }

  /// Set route render settings.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route whose render settings should be set.
  /// * **IN** *settings* The render settings.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setRenderSettings(
    final Route route,
    final RouteRenderSettings settings,
  ) {
    objectMethod(
      pointerId,
      'MapViewRouteCollection',
      'setRenderSettings',
      args: <String, dynamic>{
        'route': route.pointerId,
        'routeRenderSettings': settings,
      },
    );
  }

  /// Get the route custom render settings(read-only)
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* route	The route for which the render settings are requested
  ///
  /// **Returns**
  ///
  /// * [RouteRenderSettings] object if the route is in the collection, null otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RouteRenderSettings? getRenderSettings(final Route route) {
    final OperationResult resultString = objectMethod(
      pointerId,
      'MapViewRouteCollection',
      'getRenderSettings',
      args: route.pointerId,
    );

    if (resultString['gemApiError'] == -15) {
      return null;
    }
    return RouteRenderSettings.fromJson(resultString['result']);
  }

  @override
  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, dynamic>{
        'class': 'MapViewRouteCollection',
        'id': pointerId,
      }),
    );
  }
}

/// Mapview route class
///
/// This class should not be instantiated directly. Instead, use the [MapViewRoutesCollection.getMapViewRoute] getter to obtain an instance.
///
/// {@category Routes & Navigation}
class MapViewRoute extends GemAutoreleaseObject {
  // ignore: unused_element
  MapViewRoute._() : _pointerId = -1;

  @internal
  MapViewRoute.init(
    final int id,
    final MapViewRoutesCollection mapViewRouteCollection,
  )   : _pointerId = id,
        _mapViewRouteCollection = mapViewRouteCollection {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;
  late MapViewRoutesCollection _mapViewRouteCollection;
  int get pointerId => _pointerId;

  /// Get route label text.
  ///
  /// **Returns**
  ///
  /// * The label text
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get labelText {
    return _mapViewRouteCollection.getLabel(route);
  }

  /// Get route render settings.
  ///
  /// **Returns**
  ///
  /// * [RouteRenderSettings] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RouteRenderSettings get renderSettings {
    return _mapViewRouteCollection.getRenderSettings(route)!;
  }

  /// Get route object.
  ///
  /// **Returns**
  ///
  /// * [Route] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Route get route {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewRoute',
      'getRoute',
    );

    return Route.init(resultString['result']);
  }

  /// Hide route label.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void hideLabel() {
    _mapViewRouteCollection.hideLabel(route);
  }

  /// Set route label text.
  ///
  /// **Parameters**
  ///
  /// * **IN** *text* The label text to be set.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set labelText(final String text) {
    _mapViewRouteCollection.setLabel(route, text);
  }

  /// Set route render settings.
  ///
  /// **Parameters**
  ///
  /// * **IN** *settings* The render settings to be set.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set renderSettings(final RouteRenderSettings settings) {
    _mapViewRouteCollection.setRenderSettings(route, settings);
  }
}

/// A class that extends [RenderSettings] to provide additional
/// rendering settings specifically for routes.
///
/// It includes colors and sizes for traveled path and turn arrows, fill color for the route,
/// text size and colors for waypoints, and the line type for the route.
///
/// The `traveledInnerColor` field defines the color for the traveled part of the route.
///
/// The `turnArrowInnerColor` and `turnArrowOuterColor` fields define the colors for the inner and outer parts of the turn arrows.
///
/// The `turnArrowInnerSz` and `turnArrowOuterSz` fields define the sizes for the inner and outer parts of the turn arrows in millimeters.
///
/// The `fillColor` field defines the fill color for the route.
///
/// The `waypointTextSz` field defines the size for the waypoint text in millimeters.
///
/// The `waypointTextInnerColor` and `waypointTextOuterColor` fields define the colors for the inner and outer parts of the waypoint text.
///
/// The `lineType` field defines the type of line used for the route.
///
/// {@category Routes & Navigation}
class RouteRenderSettings extends RenderSettings<RouteRenderOptions> {
  RouteRenderSettings({
    super.options = const <RouteRenderOptions>{
      RouteRenderOptions.showTraffic,
      RouteRenderOptions.showTurnArrows,
      RouteRenderOptions.showWaypoints,
      RouteRenderOptions.showHighlights,
    },
    super.innerColor = RenderSettings.defaultInnerColor,
    super.outerColor = RenderSettings.defaultOuterColor,
    super.innerSz = RenderSettings.defaultInnerSize,
    super.outerSz = RenderSettings.defaultOuterSize,
    super.lineType = RenderSettings.defaultLineType,
    super.imgSz = RenderSettings.defaultImageSize,
    super.textSz = RenderSettings.defaultTextSize,
    super.textColor = RenderSettings.defaultTextColor,
    this.traveledInnerColor = Colors.transparent,
    this.turnArrowInnerColor = Colors.transparent,
    this.turnArrowOuterColor = Colors.transparent,
    this.turnArrowInnerSz = RenderSettings.defaultInnerSize,
    this.turnArrowOuterSz = RenderSettings.defaultOuterSize,
    this.waypointTextSz = RenderSettings.defaultTextSize,
    this.waypointTextInnerColor = Colors.transparent,
    this.waypointTextOuterColor = Colors.transparent,
    this.fillColor = Colors.transparent,
    this.directionArrowInnerColor = Colors.transparent,
    this.directionArrowOuterColor = Colors.transparent,
  });

  factory RouteRenderSettings.fromJson(final Map<String, dynamic> json) {
    final Set<RouteRenderOptions> loptions = <RouteRenderOptions>{};
    final int id = json['options'];
    for (final RouteRenderOptions option in RouteRenderOptions.values) {
      if (id & option.id != 0) {
        loptions.add(option);
      }
    }

    return RouteRenderSettings(
      traveledInnerColor: ColorExtension.tryFromJson(
        json['traveledInnerColor'],
      ),
      turnArrowInnerColor: ColorExtension.tryFromJson(
        json['turnArrowInnerColor'],
      ),
      turnArrowOuterColor: ColorExtension.tryFromJson(
        json['turnArrowOuterColor'],
      ),
      turnArrowInnerSz:
          json['turnArrowInnerSz'] ?? RenderSettings.defaultInnerSize,
      turnArrowOuterSz:
          json['turnArrowOuterSz'] ?? RenderSettings.defaultOuterSize,
      fillColor: ColorExtension.tryFromJson(json['fillColor']),
      waypointTextSz: json['waypointTextSz'] ?? RenderSettings.defaultTextSize,
      waypointTextInnerColor: ColorExtension.tryFromJson(
        json['waypointTextInnerColor'],
      ),
      waypointTextOuterColor: ColorExtension.tryFromJson(
        json['waypointTextOuterColor'],
      ),
      lineType: LineTypeExtension.fromId(
        json['lineType'] ?? RenderSettings.defaultLineType.id,
      ),
      imgSz: json['imgSz'] ?? RenderSettings.defaultImageSize,
      innerColor: ColorExtension.tryFromJson(json['innerColor']),
      outerColor: ColorExtension.tryFromJson(json['outerColor']),
      innerSz: json['innerSz'] ?? RenderSettings.defaultInnerSize,
      outerSz: json['outerSz'] ?? RenderSettings.defaultOuterSize,
      textSz: json['textSz'] ?? RenderSettings.defaultTextSize,
      textColor: ColorExtension.tryFromJson(json['textColor']),
      options: loptions,
      directionArrowInnerColor: ColorExtension.tryFromJson(
        json['directionArrowInnerColor'],
      ),
      directionArrowOuterColor: ColorExtension.tryFromJson(
        json['directionArrowOuterColor'],
      ),
    );
  }

  /// The color of the traveled part of the route.
  Color traveledInnerColor;

  /// The inner color of the turn arrows on the route.
  Color turnArrowInnerColor;

  /// The outer color of the turn arrows on the route.
  Color turnArrowOuterColor;

  /// The default inner size for turn arrows on the route in millimeters.
  double turnArrowInnerSz;

  /// The outer size of the turn arrows on the route in millimeters.
  double turnArrowOuterSz;

  /// The fill color for the route.
  Color fillColor;

  /// The text size for waypoints on the route in millimeters.
  double waypointTextSz;

  /// The inner text color for waypoint labels on the route.
  Color waypointTextInnerColor;

  /// The outer text color for waypoint labels on the route.
  Color waypointTextOuterColor;

  ///Direction arrow inner color
  Color directionArrowInnerColor;

  /// Direction arrow outer color
  Color directionArrowOuterColor;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = super.toJsonWithOptions((
      final Set<dynamic> options,
    ) {
      int el1 = (options.first as RouteRenderOptions).id;
      for (final dynamic option in options.skip(1)) {
        el1 |= (option as RouteRenderOptions).id;
      }
      return el1;
    });
    json['traveledInnerColor'] = traveledInnerColor.toRgba();
    json['turnArrowInnerColor'] = turnArrowInnerColor.toRgba();
    json['turnArrowOuterColor'] = turnArrowOuterColor.toRgba();
    json['turnArrowInnerSz'] = turnArrowInnerSz;
    json['turnArrowOuterSz'] = turnArrowOuterSz;
    json['fillColor'] = fillColor.toRgba();
    json['waypointTextSz'] = waypointTextSz;
    json['waypointTextInnerColor'] = waypointTextInnerColor.toRgba();
    json['waypointTextOuterColor'] = waypointTextOuterColor.toRgba();
    json['directionArrowInnerColor'] = directionArrowInnerColor.toRgba();
    json['directionArrowOuterColor'] = directionArrowOuterColor.toRgba();
    return json;
  }
}
