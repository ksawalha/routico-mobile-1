import 'dart:ui';

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';

/// This class represents a public transport agency.
///
/// It contains the agency's ID, name, and an optional URL.
///
/// {@category Maps & 3D Scene}
class PTAgency {
  PTAgency({required this.id, required this.name, this.url});

  factory PTAgency._build(GemParameter param) {
    final Map<String, dynamic> map = <String, dynamic>{};

    final ParameterList agency = param.value as ParameterList;
    for (final GemParameter el in agency) {
      map[el.key!] = el.value;
    }

    return PTAgency(
      id: map['agency_id'] as int,
      name: map['agency_name'] as String,
      url: map['agency_url'] as String?, // This can be null
    );
  }

  /// The ID of the agency.
  final int id;

  /// The name of the agency.
  final String name;

  /// The URL of the agency's website.
  /// This can be null if not provided.
  final String? url;
}

List<PTAgency> _buildAgencies(SearchableParameterList paramList) {
  final List<PTAgency> agencies = <PTAgency>[];

  for (final GemParameter param in paramList) {
    if (param.name == 'agencies') {
      for (final GemParameter param in param.value as ParameterList) {
        agencies.add(PTAgency._build(param));
      }
      break;
    }
  }

  return agencies;
}

/// This enum represents the different types of public transport routes.
/// It includes bus, underground, railway, tram, water transport, and miscellaneous.
///
/// {@category Maps & 3D Scene}
enum PTRouteType {
  /// Bus
  bus,

  /// Underground
  underground,

  /// Railway
  railway,

  /// Tram
  tram,

  /// Water transport
  waterTransport,

  /// Miscellaneous
  misc,
}

/// @nodoc
extension PTRouteTypeExtension on PTRouteType {
  int get id => index;

  static PTRouteType fromId(int value) {
    if (value < 0 || value >= PTRouteType.values.length) {
      throw ArgumentError('Invalid id');
    }

    return PTRouteType.values[value];
  }
}

/// This class represents a public transport route.
///
/// It contains the route's ID, short name, long name, type, color, text color,
/// and an optional heading.
/// The route type is represented by the [PTRouteType] enum.
///
/// {@category Maps & 3D Scene}
class PTRouteInfo {
  PTRouteInfo({
    required this.routeId,
    this.routeShortName,
    this.routeLongName,
    required this.routeType,
    this.routeColor,
    this.routeTextColor,
    this.heading,
  });

  factory PTRouteInfo._build(GemParameter param) {
    final Map<String, dynamic> map = <String, dynamic>{};

    param.value.forEach((dynamic el) => map[el.key] = el.value);

    return PTRouteInfo(
      routeId: map['route_id'] as int,
      routeShortName: map['route_short_name'] as String?,
      routeLongName: map['route_long_name'] as String?,
      routeType: map['route_type'] != null
          ? PTRouteTypeExtension.fromId(map['route_type'] as int)
          : PTRouteType.misc,
      routeColor: _parseColor(map['route_color']),
      routeTextColor: _parseColor(map['route_text_color']),
      heading: map['route_heading'] as String?,
    );
  }

  /// The ID of the route.
  final int routeId;

  /// The short name of the route.
  final String? routeShortName;

  /// The long name of the route.
  final String? routeLongName;

  /// The type of the route, represented by the [PTRouteType] enum.
  final PTRouteType routeType;

  /// The color of the route, represented as a [Color] object.
  /// This can be null if not provided.
  final Color? routeColor;

  /// The text color of the route, represented as a [Color] object.
  /// This can be null if not provided.
  final Color? routeTextColor;

  /// An optional heading for the route.
  /// This can be null if not provided.
  final String? heading;

  static List<PTRouteInfo> _buildStopRoutes(ParameterList param) {
    final List<PTRouteInfo> routes = <PTRouteInfo>[];

    for (final GemParameter el in param) {
      routes.add(PTRouteInfo._build(el));
    }

    return routes;
  }

  // Helper method to parse color from hex string (e.g., "#fa6544")
  static Color? _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return null;
    }

    // Remove the leading '#' if it exists
    colorString =
        colorString.startsWith('#') ? colorString.substring(1) : colorString;
    try {
      return Color(
        int.parse('0xFF$colorString'),
      ); // Add '0xFF' for full opacity
    } catch (e) {
      gemSdkLogger.warning(
        '[PTRoute][_build] Parsing color $colorString failed. Returning null.',
      );
      return null;
    }
  }
}

/// This class represents a public transport stop.
///
/// It contains the stop's ID, name, an optional flag indicating if it's a station,
/// and a list of routes associated with the stop.
///
/// {@category Maps & 3D Scene}
class PTStop {
  /// Constructor for the [PTStop] class.
  PTStop({
    required this.stopId,
    required this.stopName,
    this.isStation,
    required this.routes,
  });

  factory PTStop._build(GemParameter param) {
    final Map<String, dynamic> map = <String, dynamic>{};

    final ParameterList stop = param.value as ParameterList;
    for (final GemParameter el in stop) {
      if (el.key == 'routes') {
        map[el.key!] = PTRouteInfo._buildStopRoutes(el.value as ParameterList);
      } else {
        map[el.key!] = el.value;
      }
    }

    return PTStop(
      stopId: map['stop_id'] as int,
      stopName: map['stop_name'] as String,
      isStation: map['is_station'] != null ? (map['is_station'] == 1) : null,
      routes: map['routes'] as List<PTRouteInfo>,
    );
  }

  /// The ID of the stop.
  final int stopId;

  /// The name of the stop.
  final String stopName;

  /// An optional flag indicating if the stop is a station.
  final bool? isStation;

  /// A list of routes associated with the stop.
  /// This is a list of [PTRouteInfo] objects.
  final List<PTRouteInfo> routes;
}

List<PTStop> _buildStops(SearchableParameterList paramList) {
  final List<PTStop> stops = <PTStop>[];

  for (final GemParameter param in paramList) {
    if (param.name == 'stops') {
      for (final GemParameter param in param.value as ParameterList) {
        stops.add(PTStop._build(param));
      }
      break;
    }
  }

  return stops;
}

/// This class represents a public transport stop time.
///
/// It contains the stop name, coordinates, a flag indicating if real-time
/// information is available, a delay, an optional departure time,
/// and a stop details value.
///
/// {@category Maps & 3D Scene}
class PTStopTime {
  /// Constructor for the [PTStopTime] class.
  PTStopTime({
    required this.stopName,
    required this.coordinates,
    required this.hasRealtime,
    required this.delay,
    required this.departureTime,
    required int stopDetails,
    required this.isBefore,
  }) : _stopDetails = stopDetails;

  factory PTStopTime._build(GemParameter param) {
    final Map<String, dynamic> map = <String, dynamic>{};

    final ParameterList stopTime = param.value as ParameterList;
    for (final GemParameter el in stopTime) {
      map[el.key!] = el.value;
    }

    return PTStopTime(
      stopName: map['stop_name'] as String,
      coordinates: Coordinates(
        latitude: map['lat'] as double,
        longitude: map['lon'] as double,
      ),
      hasRealtime: map['has_realtime'] != null && map['has_realtime'] == 1,
      delay: map['delay'] as int,
      departureTime: map['departure_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (map['departure_time'] as int) * 1000,
              isUtc: true,
            )
          : null,
      stopDetails: map['stop_details'] as int,
      isBefore: map['is_before'] as int == 1,
    );
  }

  /// The name of the stop.
  String stopName;

  /// The coordinates of the stop.
  Coordinates coordinates;

  /// A flag indicating if real-time information is available.
  bool hasRealtime;

  /// The delay in seconds.
  int delay;

  /// An optional departure time.
  DateTime? departureTime;

  int _stopDetails;

  /// Indicates whether the stop is before or after the current time.
  bool isBefore;

  /// Indicates whether the stop has wheelchair support.
  bool get isWheelchairFriendly => (_stopDetails & 0x11) == 1;

  static List<PTStopTime> _buildStopTimes(ParameterList param) {
    final List<PTStopTime> stopTimes = <PTStopTime>[];

    for (final GemParameter el in param) {
      stopTimes.add(PTStopTime._build(el));
    }

    return stopTimes;
  }
}

/// This class represents a public transport trip.
///
/// It contains the route, agency, trip index, trip date, departure time,
/// a flag indicating if real-time information is available, an optional
/// cancellation flag, delay in minutes, a list of stop times, stop index,
/// stop platform code, and flags indicating if wheelchair access and bike
/// allowance are available.
///
/// The trip is associated with a specific route and agency.
///
/// {@category Maps & 3D Scene}
class PTTrip {
  /// Constructor for the [PTTrip] class.
  PTTrip({
    required this.route,
    required this.agency,
    required this.tripIndex,
    required this.tripDate,
    required this.hasRealtime,
    required this.departureTime,
    this.isCancelled,
    this.delayMinutes,
    required this.stopTimes,
    required this.stopIndex,
    this.stopPlatformCode,
    required this.isWheelchairAccessible,
    required this.isBikeAllowed,
  });

  factory PTTrip._build(GemParameter param, List<PTAgency> agencies) {
    final Map<String, dynamic> map = <String, dynamic>{};

    final ParameterList trip = param.value as ParameterList;
    for (final GemParameter el in trip) {
      if (el.key == 'stop_times') {
        map[el.key!] = PTStopTime._buildStopTimes(el.value as ParameterList);
      } else {
        map[el.key!] = el.value;
      }
    }

    final PTRouteInfo ptRoute = PTRouteInfo._build(param);

    final int agencyId = map['agency_id'] as int;

    final PTAgency ptAgency = agencies.firstWhere(
      (PTAgency agency) => agency.id == agencyId,
      orElse: () => PTAgency(id: agencyId, name: 'Unknown Agency'),
    );

    final PTTrip myTrip = PTTrip(
      route: ptRoute,
      agency: ptAgency,
      tripIndex: map['trip_index'] as int,
      tripDate: map['trip_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (map['trip_date'] as int) * 1000,
              isUtc: true,
            )
          : null,
      departureTime: map['departure_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (map['departure_time'] as int) * 1000,
              isUtc: true,
            )
          : null,
      hasRealtime: map['has_realtime'] != null && map['has_realtime'] == 1,
      isCancelled:
          map['is_cancelled'] != null ? (map['is_cancelled'] == 1) : null,
      delayMinutes: map['delay_minutes'] as int?,
      stopTimes: map['stop_times'] as List<PTStopTime>,
      stopIndex: map['stop_index'] as int,
      stopPlatformCode: map['stop_platform_code'] != null
          ? map['stop_platform_code'] as String
          : null,
      isWheelchairAccessible: map['is_wheelchair_accessible'] == 1,
      isBikeAllowed: map['bikes_allowed'] == 1,
    );

    return myTrip;
  }

  /// The route associated with the trip.
  PTRouteInfo route;

  /// The agency associated with the trip.
  PTAgency agency;

  /// The index of the trip.
  final int tripIndex;

  /// The date of the trip.
  final DateTime? tripDate;

  /// The departure time of the trip.
  DateTime? departureTime;

  /// A flag indicating if real-time information is available.
  bool hasRealtime;

  /// An optional flag indicating if the trip is cancelled.
  bool? isCancelled;

  /// The delay in minutes.
  /// This can be null if hasRealtime is false.
  int? delayMinutes;

  /// A list of stop times associated with the trip.
  List<PTStopTime> stopTimes;

  /// The index of the stop in the trip.
  /// This is the index of the stop in the list of stop times.
  int stopIndex;

  /// The platform code of the stop.
  String? stopPlatformCode;

  /// A flag indicating if the stop is wheelchair accessible.
  bool isWheelchairAccessible;

  /// A flag indicating if bikes are allowed on the trip.
  bool isBikeAllowed;
}

List<PTTrip> _buildTrips(
  SearchableParameterList paramList,
  List<PTAgency> agencies,
) {
  final List<PTTrip> trips = <PTTrip>[];

  for (final GemParameter param in paramList) {
    if (param.name == 'trips') {
      for (final GemParameter param in param.value as ParameterList) {
        trips.add(PTTrip._build(param, agencies));
      }
      break;
    }
  }

  return trips;
}

/// This class represents public transport stop information.
///
/// It contains lists of agencies, stops, and trips.
/// It provides methods to filter trips by route short name, route type,
/// and agency.
///
/// {@category Maps & 3D Scene}
class PTStopInfo {
  PTStopInfo();

  // Factory constructor
  factory PTStopInfo.fromParameters(SearchableParameterList paramList) {
    final PTStopInfo stopInfo = PTStopInfo();
    stopInfo._build(paramList);
    return stopInfo;
  }
  List<PTAgency> _agencies = <PTAgency>[];
  List<PTStop> _stops = <PTStop>[];
  List<PTTrip> _trips = <PTTrip>[];

  /// The list of public transport agencies for the stop.
  List<PTAgency> get agencies => _agencies;

  /// The list of public transport stops for the stop.
  List<PTStop> get stops => _stops;

  /// The list of public transport trips for the stop.
  /// This is a list of [PTTrip] objects.
  /// It contains all trips associated with the stop.
  List<PTTrip> get trips => _trips;

  /// Filters the trips by route short name.
  /// Returns a list of trips that match the specified route short name.
  ///
  /// *Parameter*:
  /// - [routeShortName]: The short name of the route to filter by.
  ///
  /// *Returns*: A list of [PTTrip] objects that match the specified route short name.
  ///
  List<PTTrip> tripsByRouteShortName(String routeShortName) => _trips
      .where(
        (PTTrip trip) =>
            trip.route.routeShortName != null &&
            trip.route.routeShortName == routeShortName,
      )
      .toList();

  /// Filters the trips by route type.
  /// Returns a list of trips that match the specified route type.
  ///
  /// *Parameter*:
  /// - [routeType]: The type of the route to filter by.
  ///
  /// *Returns*: A list of [PTTrip] objects that match the specified route type.
  ///
  List<PTTrip> tripsByRouteType(PTRouteType routeType) =>
      _trips.where((PTTrip trip) => trip.route.routeType == routeType).toList();

  /// Filters the trips by agency.
  /// Returns a list of trips that match the specified agency.
  ///
  /// *Parameter*:
  /// - [agency]: The agency to filter by.
  ///
  /// *Returns*: A list of [PTTrip] objects that match the specified agency.
  ///
  /// *Note*: The agency must be one of the agencies in the list of agencies.
  /// If the agency is not found, an empty list is returned.
  ///
  List<PTTrip> tripsByAgency(PTAgency agency) =>
      _trips.where((PTTrip trip) => trip.agency.id == agency.id).toList();

  void _build(SearchableParameterList paramList) {
    _agencies = _buildAgencies(paramList);
    _stops = _buildStops(paramList);
    _trips = _buildTrips(paramList, _agencies);
  }
}
