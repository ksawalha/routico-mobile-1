// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

/// Route result
///
/// {@category Routes & Navigation}
enum RouteResultType {
  /// Path route result type - navigable route.
  path,

  /// Route range ( Isochrone ) result type - reachable area within a range of travel costs.
  range,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension RouteResultTypeExtension on RouteResultType {
  int get id {
    switch (this) {
      case RouteResultType.path:
        return 0;
      case RouteResultType.range:
        return 1;
    }
  }

  static RouteResultType fromId(final int id) {
    switch (id) {
      case 0:
        return RouteResultType.path;
      case 1:
        return RouteResultType.range;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Algorithm type
///
/// {@category Routes & Navigation}
enum PTAlgorithmType {
  /// Algorithm type - departure/starting point
  departure,

  /// Algorithm type - arrival/destination point
  arrival,
}

/// This class will not be documented.
///
/// @nodoc
extension PTAlgorithmTypeExtension on PTAlgorithmType {
  int get id {
    switch (this) {
      case PTAlgorithmType.departure:
        return 0;
      case PTAlgorithmType.arrival:
        return 1;
    }
  }

  static PTAlgorithmType fromId(final int id) {
    switch (id) {
      case 0:
        return PTAlgorithmType.departure;
      case 1:
        return PTAlgorithmType.arrival;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Sorting strategy
///
/// {@category Routes & Navigation}
enum PTSortingStrategy {
  /// Sorting strategy - best time
  bestTime,

  /// Sorting strategy - least walk
  leastWalk,

  /// Sorting strategy - fewest transfers
  leastTransfers,
}

/// This class will not be documented.
///
/// @nodoc
extension PTSortingStrategyExtension on PTSortingStrategy {
  int get id {
    switch (this) {
      case PTSortingStrategy.bestTime:
        return 0;
      case PTSortingStrategy.leastWalk:
        return 1;
      case PTSortingStrategy.leastTransfers:
        return 2;
    }
  }

  static PTSortingStrategy fromId(final int id) {
    switch (id) {
      case 0:
        return PTSortingStrategy.bestTime;
      case 1:
        return PTSortingStrategy.leastWalk;
      case 2:
        return PTSortingStrategy.leastTransfers;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Route type
///
/// {@category Routes & Navigation}
enum RouteType {
  /// Fastest route between the given waypoints
  fastest,

  /// Shortest route between the given waypoints
  shortest,

  /// Economical, as fuel consumption, route between the given waypoints
  economic,

  /// Fastest route, with best scenic view, between the given waypoints
  scenic,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension RouteTypeExtension on RouteType {
  int get id {
    switch (this) {
      case RouteType.fastest:
        return 0;
      case RouteType.shortest:
        return 1;
      case RouteType.economic:
        return 2;
      case RouteType.scenic:
        return 3;
    }
  }

  static RouteType fromId(final int id) {
    switch (id) {
      case 0:
        return RouteType.fastest;
      case 1:
        return RouteType.shortest;
      case 2:
        return RouteType.economic;
      case 3:
        return RouteType.scenic;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Transport mode
///
/// {@category Routes & Navigation}
enum RouteTransportMode {
  /// Transport mode - car.
  car,

  /// Transport mode - lorry/truck.
  lorry,

  /// Transport mode - on foot.
  pedestrian,

  /// Transport mode - bike.
  bicycle,

  /// Transport mode - public transport.
  public,

  /// Transport mode - shared vehicles.
  sharedVehicles,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension RouteTransportModeExtension on RouteTransportMode {
  int get id {
    switch (this) {
      case RouteTransportMode.car:
        return 0;
      case RouteTransportMode.lorry:
        return 1;
      case RouteTransportMode.pedestrian:
        return 2;
      case RouteTransportMode.bicycle:
        return 3;
      case RouteTransportMode.public:
        return 4;
      case RouteTransportMode.sharedVehicles:
        return 5;
    }
  }

  static RouteTransportMode fromId(final int id) {
    switch (id) {
      case 0:
        return RouteTransportMode.car;
      case 1:
        return RouteTransportMode.lorry;
      case 2:
        return RouteTransportMode.pedestrian;
      case 3:
        return RouteTransportMode.bicycle;
      case 4:
        return RouteTransportMode.public;
      case 5:
        return RouteTransportMode.sharedVehicles;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Traffic avoidance options
///
/// {@category Routes & Navigation}
enum TrafficAvoidance {
  /// Disable traffic avoidance.
  none,

  /// Avoid all traffic events: congestions and roadblocks.
  all,

  /// Avoid only roadblock traffic events.
  roadblocks,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension TrafficAvoidanceExtension on TrafficAvoidance {
  int get id {
    switch (this) {
      case TrafficAvoidance.none:
        return 0;
      case TrafficAvoidance.all:
        return 1;
      case TrafficAvoidance.roadblocks:
        return 2;
    }
  }

  static TrafficAvoidance fromId(final int id) {
    switch (id) {
      case 0:
        return TrafficAvoidance.none;
      case 1:
        return TrafficAvoidance.all;
      case 2:
        return TrafficAvoidance.roadblocks;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Bike profile
///
/// {@category Routes & Navigation}
enum BikeProfile {
  /// Bike profile - road.
  road,

  /// Bike profile - cross.
  cross,

  /// Bike profile - city.
  city,

  /// Bike profile - mountain.
  mountain,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension BikeProfileExtension on BikeProfile {
  int get id {
    switch (this) {
      case BikeProfile.road:
        return 0;
      case BikeProfile.cross:
        return 1;
      case BikeProfile.city:
        return 2;
      case BikeProfile.mountain:
        return 3;
    }
  }

  static BikeProfile fromId(final int id) {
    switch (id) {
      case 0:
        return BikeProfile.road;
      case 1:
        return BikeProfile.cross;
      case 2:
        return BikeProfile.city;
      case 3:
        return BikeProfile.mountain;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// eBike type
///
/// {@category Routes & Navigation}
enum ElectricBikeType {
  /// Electric bike type - none.
  none,

  /// Electric bike type - pedelec.
  pedelec,

  /// Electric bike type - power on demand.
  powerOnDemand,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension ElectricBikeTypeExtension on ElectricBikeType {
  int get id {
    switch (this) {
      case ElectricBikeType.none:
        return 0;
      case ElectricBikeType.pedelec:
        return 1;
      case ElectricBikeType.powerOnDemand:
        return 2;
    }
  }

  static ElectricBikeType fromId(final int id) {
    switch (id) {
      case 0:
        return ElectricBikeType.none;
      case 1:
        return ElectricBikeType.pedelec;
      case 2:
        return ElectricBikeType.powerOnDemand;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Pedestrian profile
///
/// {@category Routes & Navigation}
enum PedestrianProfile {
  /// Pedestrian profile - walk.
  walk,

  /// Pedestrian profile - hike.
  hike,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension PedestrianProfileExtension on PedestrianProfile {
  int get id {
    switch (this) {
      case PedestrianProfile.walk:
        return 0;
      case PedestrianProfile.hike:
        return 1;
    }
  }

  static PedestrianProfile fromId(final int id) {
    switch (id) {
      case 0:
        return PedestrianProfile.walk;
      case 1:
        return PedestrianProfile.hike;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Routing result details
///
/// {@category Routes & Navigation}
enum RouteResultDetails {
  /// Path and guidance
  full,

  /// Path time / distance only
  timeDistance,

  /// Path time / distance and geometry
  path,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension RouteResultDetailsExtension on RouteResultDetails {
  int get id {
    switch (this) {
      case RouteResultDetails.full:
        return 0;
      case RouteResultDetails.timeDistance:
        return 1;
      case RouteResultDetails.path:
        return 2;
    }
  }

  static RouteResultDetails fromId(final int id) {
    switch (id) {
      case 0:
        return RouteResultDetails.full;
      case 1:
        return RouteResultDetails.timeDistance;
      case 2:
        return RouteResultDetails.path;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Alternative routes scheme
///
/// {@category Routes & Navigation}
enum RouteAlternativesSchema {
  /// Alternative routes scheme - Service default - depending on selected transport, route type & result details
  defaultSchema,

  /// Alternative routes scheme - never
  never,

  /// Alternative routes scheme - always ( even if not recommended, e.g. for shortest etc )
  always,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension RouteAlternativesSchemaExtension on RouteAlternativesSchema {
  int get id {
    switch (this) {
      case RouteAlternativesSchema.defaultSchema:
        return 0;
      case RouteAlternativesSchema.never:
        return 1;
      case RouteAlternativesSchema.always:
        return 2;
    }
  }

  static RouteAlternativesSchema fromId(final int id) {
    switch (id) {
      case 0:
        return RouteAlternativesSchema.defaultSchema;
      case 1:
        return RouteAlternativesSchema.never;
      case 2:
        return RouteAlternativesSchema.always;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Path calculation algorithm
///
/// {@category Routes & Navigation}
enum RoutePathAlgorithm {
  /// Path calculation algorithm - Service default - Magic Lane routing algorithm
  ml,

  /// Deprecated alias to ml
  @Deprecated('Use ml enum value instead')
  me,

  /// Simplified Magic Lane routing algorithm - Best speed, recommended for low end devices
  simplifiedMl,

  /// Path calculation algorithm - External CH routing algorithm
  externalCH,

  /// Magic Lane CH routing algorithm
  mlch,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension RoutePathAlgorithmExtension on RoutePathAlgorithm {
  int get id {
    switch (this) {
      case RoutePathAlgorithm.ml:
        return 0;
      case RoutePathAlgorithm.me:
        return 0;
      case RoutePathAlgorithm.simplifiedMl:
        return 1;
      case RoutePathAlgorithm.externalCH:
        return 2;
      case RoutePathAlgorithm.mlch:
        return 3;
    }
  }

  static RoutePathAlgorithm fromId(final int id) {
    switch (id) {
      case 0:
        return RoutePathAlgorithm.ml;
      case 1:
        return RoutePathAlgorithm.simplifiedMl;
      case 2:
        return RoutePathAlgorithm.externalCH;
      case 3:
        return RoutePathAlgorithm.mlch;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Path calculation flavors
///
/// {@category Routes & Navigation}
enum RoutePathAlgorithmFlavor {
  /// Service default - Magic Lane routing flavor
  magicLane,

  /// GraphHopper flavor
  graphHopper,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension RoutePathAlgorithmFlavorExtension on RoutePathAlgorithmFlavor {
  int get id {
    switch (this) {
      case RoutePathAlgorithmFlavor.magicLane:
        return 0;
      case RoutePathAlgorithmFlavor.graphHopper:
        return 1;
    }
  }

  static RoutePathAlgorithmFlavor fromId(final int id) {
    switch (id) {
      case 0:
        return RoutePathAlgorithmFlavor.magicLane;
      case 1:
        return RoutePathAlgorithmFlavor.graphHopper;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Bike and Electric bike routing profile
///
/// {@category Routes & Navigation}
class BikeProfileElectricBikeProfile {
  BikeProfileElectricBikeProfile({
    this.profile = BikeProfile.city,
    this.eProfile,
  });

  factory BikeProfileElectricBikeProfile.fromJson(
    final Map<String, dynamic> json,
  ) {
    return BikeProfileElectricBikeProfile(
      profile: BikeProfileExtension.fromId(json['profile']),
      eProfile: json['eprofile'] is ElectricBikeProfile
          ? json['eprofile'] as ElectricBikeProfile
          : ElectricBikeProfile.fromJson(json['eprofile']),
    );
  }

  /// Selected bike profile.
  /// Default is [BikeProfile.city].
  BikeProfile profile;

  /// Selected e-bike profile.
  ElectricBikeProfile? eProfile;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['profile'] = profile.id;

    json['eprofile'] = eProfile ?? ElectricBikeProfile();
    return json;
  }

  @override
  bool operator ==(covariant final BikeProfileElectricBikeProfile other) {
    return other.profile == profile && other.eProfile == eProfile;
  }

  @override
  int get hashCode => profile.hashCode ^ eProfile.hashCode;
}

/// Preferences regarding building terrain profile
///
/// {@category Routes & Navigation}
class BuildTerrainProfile {
  const BuildTerrainProfile({this.enable = false, this.minVariation = -1});

  factory BuildTerrainProfile.fromJson(final Map<String, dynamic> json) {
    return BuildTerrainProfile(
      enable: json['b'],
      minVariation: json['minVariation'],
    );
  }

  /// Enable / disable terrain profile build
  /// Default is false
  final bool enable;

  /// The minimum elevation variation to be registered for total up / total down statistics
  /// A value < 0 lets the SDK to choose a proper value
  /// Default is 0
  final double minVariation;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['b'] = enable;
    json['minVariation'] = minVariation;
    return json;
  }

  @override
  bool operator ==(covariant final BuildTerrainProfile other) {
    return other.enable == enable && other.minVariation == minVariation;
  }

  @override
  int get hashCode => enable.hashCode ^ minVariation.hashCode;
}

/// Departure heading
///
/// {@category Routes & Navigation}
class DepartureHeading {
  const DepartureHeading({this.heading = -1, this.accuracy = 0});

  factory DepartureHeading.fromJson(final Map<String, dynamic> json) {
    return DepartureHeading(heading: json['first'], accuracy: json['second']);
  }

  /// The departure heading in degrees.
  ///
  /// Values are in 0 - 360 interval with 0 representing the magnetic north.
  /// Value -1 means no departure heading is specified
  final double heading;

  /// The departure heading accuracy, in degrees.
  ///
  /// Values are in 0 - 90 interval. A typical value is 25 degrees
  final double accuracy;

  Map<String, dynamic> toJson() {
    return <String, double>{'first': heading, 'second': accuracy};
  }

  @override
  bool operator ==(covariant final DepartureHeading other) {
    return other.heading == heading && other.accuracy == accuracy;
  }

  @override
  int get hashCode => heading.hashCode ^ accuracy.hashCode;
}

/// Route type preference
///
/// {@category Routes & Navigation}
enum RouteTypePreferences {
  /// No preference regarding route type, unpaved road is good enough
  none,

  /// Prefer buses
  bus,

  /// Prefer underground/overground subways/metro and underground railway/tunnel transportation
  underground,

  /// Prefer train and coach services
  railway,

  /// Prefer trams
  tram,

  /// Prefer water transportation (boats, ships, gondolas, water taxis)
  waterTransport,

  /// Prefer other means of transportation: funicular, telecabins, air transportation, taxis etc.
  misc,

  /// Prefer shared bikes
  sharedBike,

  /// Prefer shared cars
  sharedCar,

  /// Prefer shared scooters
  sharedScooter,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension RouteTypePreferencesExtension on RouteTypePreferences {
  int get id {
    switch (this) {
      case RouteTypePreferences.none:
        return 0x00000000;
      case RouteTypePreferences.bus:
        return 0x00000001;
      case RouteTypePreferences.underground:
        return 0x00000002;
      case RouteTypePreferences.railway:
        return 0x00000004;
      case RouteTypePreferences.tram:
        return 0x00000008;
      case RouteTypePreferences.waterTransport:
        return 0x00000010;
      case RouteTypePreferences.misc:
        return 0x00000020;
      case RouteTypePreferences.sharedBike:
        return 0x00000040;
      case RouteTypePreferences.sharedCar:
        return 0x00000080;
      case RouteTypePreferences.sharedScooter:
        return 0x00000100;
    }
  }

  static RouteTypePreferences fromId(final int id) {
    switch (id) {
      case 0x00000000:
        return RouteTypePreferences.none;
      case 0x00000001:
        return RouteTypePreferences.bus;
      case 0x00000002:
        return RouteTypePreferences.underground;
      case 0x00000004:
        return RouteTypePreferences.railway;
      case 0x00000008:
        return RouteTypePreferences.tram;
      case 0x00000010:
        return RouteTypePreferences.waterTransport;
      case 0x00000020:
        return RouteTypePreferences.misc;
      case 0x00000040:
        return RouteTypePreferences.sharedBike;
      case 0x00000080:
        return RouteTypePreferences.sharedCar;
      case 0x00000100:
        return RouteTypePreferences.sharedScooter;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Route preferences - contains the preferences used for route calculation.
///
/// {@category Routes & Navigation}
class RoutePreferences {
  RoutePreferences({
    this.accurateTrackMatch = true,
    this.algorithmType = PTAlgorithmType.departure,
    this.allowOnlineCalculation = true,
    this.alternativeRoutesBalancedSorting = true,
    this.alternativesSchema = RouteAlternativesSchema.defaultSchema,
    this.avoidBikingHillFactor = 0.5,
    this.avoidCarpoolLanes = false,
    this.avoidFerries = false,
    this.avoidMotorways = false,
    this.avoidTollRoads = false,
    this.avoidTraffic = TrafficAvoidance.none,
    this.avoidTurnAroundInstruction = false,
    this.avoidUnpavedRoads = false,
    this.bikeProfile,
    this.buildConnections = false,
    this.buildTerrainProfile = const BuildTerrainProfile(),
    this.carProfile,
    this.departureHeading = const DepartureHeading(),
    this.emergencyVehicleExtraFreedomLevels = 0,
    this.emergencyVehicleMode = false,
    this.evProfile,
    this.ignoreRestrictionsOverTrack = false,
    this.maximumDistanceConstraint = true,
    this.maximumTransferTimeInMinutes = 300,
    this.maximumWalkDistance = 5000,
    this.minimumTransferTimeInMinutes = 1,
    this.pathAlgorithm = RoutePathAlgorithm.ml,
    this.pathAlgorithmFlavor = RoutePathAlgorithmFlavor.magicLane,
    this.pedestrianProfile = PedestrianProfile.walk,
    this.resultDetails = RouteResultDetails.full,
    this.routeGroupIdsEarlierLater = const <int>[],
    this.routeRanges = const <int>[],
    this.routeRangesQuality = 100,
    this.routeResultType = RouteResultType.path,
    this.routeType = RouteType.fastest,
    this.routeTypePreferences = const <RouteTypePreferences>{
      RouteTypePreferences.none,
    },
    this.sortingStrategy = PTSortingStrategy.bestTime,
    this.timestamp,
    this.transportMode = RouteTransportMode.car,
    this.truckProfile,
    this.useBikes = false,
    this.useWheelchair = false,
  });

  factory RoutePreferences.fromJson(final Map<String, dynamic> json) {
    final int routeTypePreferencesInt = json['routetypepreferences'];
    final Set<RouteTypePreferences> routeTypePreferences =
        <RouteTypePreferences>{};

    for (final RouteTypePreferences value in RouteTypePreferences.values) {
      if (routeTypePreferencesInt & value.id != 0) {
        routeTypePreferences.add(value);
      }
    }
    if (routeTypePreferences.isEmpty) {
      routeTypePreferences.add(RouteTypePreferences.none);
    }

    return RoutePreferences(
      accurateTrackMatch: json['accuratetrackmatch'],
      algorithmType: PTAlgorithmTypeExtension.fromId(json['algorithmtype']),
      allowOnlineCalculation: json['allowonlinecalculation'],
      alternativeRoutesBalancedSorting:
          json['alternativeroutesbalancedsorting'],
      alternativesSchema: RouteAlternativesSchemaExtension.fromId(
        json['alternativesschema'],
      ),
      avoidBikingHillFactor: json['avoidbikinghillFactor'],
      avoidCarpoolLanes: json['avoidcarpoollanes'],
      avoidFerries: json['avoidferries'],
      avoidMotorways: json['avoidmotorways'],
      avoidTollRoads: json['avoidtollroads'],
      avoidTraffic: TrafficAvoidanceExtension.fromId(json['avoidtraffic']),
      avoidTurnAroundInstruction: json['avoidturnaroundinstruction'],
      avoidUnpavedRoads: json['avoidunpavedroads'],
      bikeProfile: BikeProfileElectricBikeProfile.fromJson(json['bikeprofile']),
      buildConnections: json['buildconnections'],
      buildTerrainProfile: BuildTerrainProfile.fromJson(
        json['buildterrainprofile'],
      ),
      carProfile: CarProfile.fromJson(json['carprofile']),
      departureHeading: DepartureHeading.fromJson(json['departureheading']),
      emergencyVehicleExtraFreedomLevels: json['emergencyVehicleMode']
          ['extraFreedom'],
      emergencyVehicleMode: json['emergencyVehicleMode']['enable'],
      evProfile: EVProfile.fromJson(json['evprofile']),
      ignoreRestrictionsOverTrack: json['ignorerestrictionsovertrack'],
      maximumDistanceConstraint: json['maximumdistanceconstraint'],
      maximumTransferTimeInMinutes: json['maximumtransfertimeInminutes'],
      maximumWalkDistance: json['maximumwalkdistance'],
      minimumTransferTimeInMinutes: json['minimumtransfertimeInminutes'],
      pathAlgorithm: RoutePathAlgorithmExtension.fromId(json['pathalgorithm']),
      pathAlgorithmFlavor: RoutePathAlgorithmFlavorExtension.fromId(
        json['pathalgorithmflavor'],
      ),
      pedestrianProfile: PedestrianProfileExtension.fromId(
        json['pedestrianprofile'],
      ),
      resultDetails: RouteResultDetailsExtension.fromId(json['resultdetails']),
      routeGroupIdsEarlierLater:
          (json['routegroupidsearlierlater'] as List<dynamic>)
              .map((final dynamic item) => item as int)
              .toList(),
      routeRanges: (json['routeranges']['list'] as List<dynamic>)
          .map((final dynamic item) => item as int)
          .toList(),
      routeRangesQuality: json['routeranges']['quality'],
      routeResultType: RouteResultTypeExtension.fromId(json['routeresulttype']),
      routeType: RouteTypeExtension.fromId(json['routetype']),
      routeTypePreferences: routeTypePreferences,
      sortingStrategy: PTSortingStrategyExtension.fromId(json['routetype']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['timestamp'], isUtc: true),
      transportMode: RouteTransportModeExtension.fromId(json['transportmode']),
      truckProfile: TruckProfile.fromJson(json['truckprofile']),
      useBikes: json['usebikes'],
      useWheelchair: json['usewheelchair'],
    );
  }

  /// Track accurate match.
  ///
  /// Default is true
  bool accurateTrackMatch;

  /// Get algorithm type.
  ///
  /// Default is departure.
  PTAlgorithmType algorithmType;

  /// Get the online route calculation allowance
  ///
  /// Default value is true
  bool allowOnlineCalculation;

  /// Enable/disable alternative routes balanced sorting.
  ///
  /// Default is true
  bool alternativeRoutesBalancedSorting;

  /// Alternative schema.
  ///
  /// Default is [RouteAlternativesSchema.defaultSchema]
  RouteAlternativesSchema alternativesSchema;

  /// Avoid biking hill factor 0.f - no avoidance, 1.f - full avoidance.
  ///
  /// Default is 0.5
  double avoidBikingHillFactor;

  /// Avoid carpool lanes flag.
  ///
  /// Only available for custom builds containing TomTom map data.
  /// Ignored for public builds.
  ///
  /// Default is false.
  bool avoidCarpoolLanes;

  /// Avoid ferries flag.
  ///
  /// Default is false.
  bool avoidFerries;

  /// Avoid motorways flag.
  ///
  /// Default is false.
  bool avoidMotorways;

  /// Avoid toll roads flag.
  ///
  /// Default is false.
  bool avoidTollRoads;

  /// Route calculation traffic avoidance method.
  ///
  /// Default is [TrafficAvoidance.none]
  TrafficAvoidance avoidTraffic;

  /// Avoid turnaround instruction flag.
  ///
  /// If set to true then the message "Turnaround when possible" will be avoided during navigation.
  ///
  /// This preference is always overridden in car / truck navigation route recalculations, in which case the current
  /// driving direction is used, except for the case when emergency mode is activated.
  ///
  /// For car / truck this preference is used when setting a user roadblock during navigation.
  /// If set to false, a turn around instruction may be generated
  ///
  /// Default is true for car/truck transport modes and false for the rest
  /// If emergency mode is active, default value is always false
  ///
  /// Default is false
  bool avoidTurnAroundInstruction;

  /// Avoid unpaved roads flag.
  ///
  /// Default is false.
  bool avoidUnpavedRoads;

  /// Bike profile.
  BikeProfileElectricBikeProfile? bikeProfile;

  /// Build terrain profile.

  /// Get route connections build
  ///
  /// Default is false
  bool buildConnections;

  /// If [BuildTerrainProfile.enable] is set to false then the route computed will have the [RouteBase.terrainProfile] null.
  ///
  /// Default is set to an object with [BuildTerrainProfile.enable] set to false.
  BuildTerrainProfile buildTerrainProfile;

  /// Car profile.
  CarProfile? carProfile;

  /// The departure heading.
  ///
  /// By default it is set to an object with  [DepartureHeading.heading] set to -1 and [DepartureHeading.accuracy] set to -1,
  /// which means no departure heading is specified
  DepartureHeading departureHeading;

  /// The extra freedom levels for emergency vehicles, packed in an integer value.
  int emergencyVehicleExtraFreedomLevels;

  /// The emergency vehicle mode, true for activation
  /// Emergency mode set the default AvoidTurnAroundInstruction setting to false also for car/truck
  /// Emergency mode enables access to emergency dedicated links and enables a more relaxed routing set of constraints
  ///
  /// Default is false
  bool emergencyVehicleMode;

  /// The EV profile
  EVProfile? evProfile;

  /// The ignore map restrictions in route-over-track mode.
  ///
  /// Default is false
  bool ignoreRestrictionsOverTrack;

  /// Service maximum distance constraint.
  /// Maximum distance constraint depends on transport and result details.
  ///
  /// Default is true
  bool maximumDistanceConstraint;

  /// Maximum transfer time in minutes
  /// Refers to the transfer time between two means of transportation.
  ///
  /// Enable the user to specify the desired maximum amount of minutes between the arrival of one means of
  /// transportation and the departure of the next one.
  ///
  /// Default is 300.
  int maximumTransferTimeInMinutes;

  /// Maximum walk distance.
  ///
  /// Default is 5000.
  int maximumWalkDistance;

  /// Get minimum transfer time in minutes.
  /// Refers to the transfer time between two means of transportation.
  ///
  /// Enable the user to specify the desired minimum amount of minutes between the arrival of one means of
  /// transportation and the departure of the next one.
  ///
  /// Default is 1.
  int minimumTransferTimeInMinutes;

  /// Path algorithm.
  ///
  /// Default is [RoutePathAlgorithm.ml]
  RoutePathAlgorithm pathAlgorithm;

  /// Path algorithm flavor.
  ///
  /// Default is [RoutePathAlgorithmFlavor.magicLane]
  RoutePathAlgorithmFlavor pathAlgorithmFlavor;

  /// Pedestrian profile.
  ///
  /// Default is [PedestrianProfile.walk]
  PedestrianProfile pedestrianProfile;

  /// Result details.
  ///
  /// Default is [RouteResultDetails.full]
  RouteResultDetails resultDetails;

  /// Group ids for earlier/later trip.
  List<int> routeGroupIdsEarlierLater;

  /// Route ranges list.
  ///
  /// Range units depend on route type: [RouteType.fastest] - seconds, [RouteType.shortest] - meters, [RouteType.economic] - Wh
  ///
  /// Default is an empty list
  List<int> routeRanges;

  /// Range result quality must a valid integer in the 0 - 100 range, where 0 = lowest quality, 100 = highest quality
  ///
  /// Default is 100 (max quality)
  int routeRangesQuality;

  /// Route result type.
  ///
  /// The value is not passed to the route calculation, but used as a result via [RouteBase.preferences]
  RouteResultType routeResultType;

  /// The route type.

  /// Default is [RouteType.fastest]
  RouteType routeType;

  /// Route type preferences.
  ///
  /// Default is [RouteTypePreferences.none]
  Set<RouteTypePreferences> routeTypePreferences;

  /// Sorting strategy
  ///
  /// Default is [PTSortingStrategy.bestTime]
  PTSortingStrategy sortingStrategy;

  /// The timestamp.
  ///
  /// Get departure timestamp.
  DateTime? timestamp;

  /// Route transport mode.
  ///
  /// Default is [RouteTransportMode.car]
  RouteTransportMode transportMode;

  /// Truck profile.
  TruckProfile? truckProfile;

  /// Option toggle to use bike.
  ///
  /// Default is false
  bool useBikes;

  /// Option toggle to use wheelchair.
  ///
  /// Default is false
  bool useWheelchair;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['accuratetrackmatch'] = accurateTrackMatch;
    json['algorithmtype'] = algorithmType.id;
    json['allowonlinecalculation'] = allowOnlineCalculation;
    json['alternativeroutesbalancedsorting'] = alternativeRoutesBalancedSorting;
    json['alternativesschema'] = alternativesSchema.id;
    json['automatictimestamp'] = timestamp == null;
    json['avoidbikinghillFactor'] = avoidBikingHillFactor;
    json['avoidcarpoollanes'] = avoidCarpoolLanes;
    json['avoidferries'] = avoidFerries;
    json['avoidmotorways'] = avoidMotorways;
    json['avoidtollroads'] = avoidTollRoads;
    json['avoidtraffic'] = avoidTraffic.id;
    json['avoidturnaroundinstruction'] = avoidTurnAroundInstruction;
    json['avoidunpavedroads'] = avoidUnpavedRoads;
    json['buildconnections'] = buildConnections;
    json['buildterrainprofile'] = buildTerrainProfile;
    json['departureheading'] = departureHeading;
    json['emergencyVehicleMode'] = <String, dynamic>{};
    json['emergencyVehicleMode']['extraFreedom'] =
        emergencyVehicleExtraFreedomLevels;
    json['emergencyVehicleMode']['enable'] = emergencyVehicleMode;
    json['ignorerestrictionsovertrack'] = ignoreRestrictionsOverTrack;
    json['maximumdistanceconstraint'] = maximumDistanceConstraint;
    json['maximumtransfertimeInminutes'] = maximumTransferTimeInMinutes;
    json['maximumwalkdistance'] = maximumWalkDistance;
    json['minimumtransfertimeInminutes'] = minimumTransferTimeInMinutes;
    json['pathalgorithm'] = pathAlgorithm.id;
    json['pathalgorithmflavor'] = pathAlgorithmFlavor.id;
    json['pedestrianprofile'] = pedestrianProfile.id;
    json['resultdetails'] = resultDetails.id;
    json['routegroupidsearlierlater'] = routeGroupIdsEarlierLater;
    json['routeranges'] = <String, dynamic>{};
    json['routeranges']['list'] = routeRanges;
    json['routeranges']['quality'] = routeRangesQuality;
    json['routeresulttype'] = routeResultType.id;
    json['routetype'] = routeType.id;
    json['routetypepreferences'] = routeTypePreferences.fold(
      0,
      (final int res, final RouteTypePreferences item) => res | item.id,
    );
    json['sortingstrategy'] = sortingStrategy.id;
    json['transportmode'] = transportMode.id;
    json['usebikes'] = useBikes;
    json['usewheelchair'] = useWheelchair;
    json['bikeprofile'] = bikeProfile ?? BikeProfileElectricBikeProfile();
    json['carprofile'] = carProfile ?? CarProfile();
    json['evprofile'] = evProfile ?? EVProfile();
    if (timestamp != null) {
      json['timestamp'] = timestamp!.millisecondsSinceEpoch;
    }
    json['truckprofile'] = truckProfile ?? TruckProfile();
    return json;
  }
}

/// eBike profile
///
/// {@category Routes & Navigation}
class ElectricBikeProfile {
  /// Default constructor ElectricBikeProfile
  ///
  /// **Parameters**
  /// * **IN** *type* eBike type
  /// * **IN** *bikeMass* bike mass in kg
  /// * **IN** *bikerMass* biker mass in kg
  /// * **IN** *auxConsumptionDay* bike auxiliary power consumption during day in Watts
  /// * **IN** *auxConsumptionNight* bike auxiliary power consumption during night in Watts
  /// * **IN** *ignoreLegalRestrictions* ignore country based legal restrictions related to e-bikes
  ElectricBikeProfile({
    this.type = ElectricBikeType.pedelec,
    this.bikeMass = 0.0,
    this.bikerMass = 0.0,
    this.auxConsumptionDay = 0.0,
    this.auxConsumptionNight = 0.0,
    this.ignoreLegalRestrictions = false,
  });

  factory ElectricBikeProfile.fromJson(final Map<String, dynamic> json) {
    return ElectricBikeProfile(
      type: ElectricBikeTypeExtension.fromId(json['type']),
      bikeMass: json['bikeMass'],
      bikerMass: json['bikerMass'],
      auxConsumptionDay: json['auxConsumptionDay'],
      auxConsumptionNight: json['auxConsumptionNight'],
      ignoreLegalRestrictions: json['ignoreLegalRestrictions'],
    );
  }

  /// Ebike type
  ElectricBikeType type;

  /// Bike mass in kg. If 0, a default value is used
  double bikeMass;

  /// Biker mass in kg. If 0, a default value is used
  double bikerMass;

  /// Bike auxiliary power consumption during day in Watts. If 0, a default value is used
  double auxConsumptionDay;

  /// Bike auxiliary power consumption during night in Watts. If 0, a default value is used
  double auxConsumptionNight;

  /// Ignore country based legal restrictions related to e-bikes
  bool ignoreLegalRestrictions;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['type'] = type.id;
    json['bikeMass'] = bikeMass;
    json['bikerMass'] = bikerMass;
    json['auxConsumptionDay'] = auxConsumptionDay;
    json['auxConsumptionNight'] = auxConsumptionNight;
    json['ignoreLegalRestrictions'] = ignoreLegalRestrictions;
    return json;
  }

  @override
  bool operator ==(covariant final ElectricBikeProfile other) {
    if (identical(this, other)) {
      return true;
    }

    return other.type == type &&
        other.bikeMass == bikeMass &&
        other.bikerMass == bikerMass &&
        other.auxConsumptionDay == auxConsumptionDay &&
        other.auxConsumptionNight == auxConsumptionNight &&
        other.ignoreLegalRestrictions == ignoreLegalRestrictions;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      bikeMass,
      bikerMass,
      auxConsumptionDay,
      auxConsumptionNight,
      ignoreLegalRestrictions,
    );
  }
}

/// EV routing profile
///
/// {@category Routes & Navigation}
class EVProfile {
  EVProfile({
    this.ports = 0,
    this.departureSoc = 0.85,
    this.destinationSoc = 0.2,
    this.chargerDestSoc = 1,
    this.chargerDepSoc = 0.1,
    this.chargerOverheadMins = 5,
    this.batteryHealth = 0.0,
    this.id = 0,
    this.batteryCapacity = 0.0,
    this.towbarPossible = 0,
    this.vehicleRange = 0,
    this.efficiency = 0,
    this.fastCharge = 0,
  });

  factory EVProfile.fromJson(final Map<String, dynamic> json) {
    return EVProfile(
      id: json['id'],
      ports: json['ports'],
      departureSoc: json['departureSoc'],
      destinationSoc: json['destinationSoc'],
      chargerDestSoc: json['chargerDestSoc'],
      chargerDepSoc: json['chargerDepSoc'],
      chargerOverheadMins: json['chargerOverheadMins'],
      batteryHealth: json['battery_Health'],
      batteryCapacity: json['batteryCapacity'],
      towbarPossible: json['towbarPossible'],
      vehicleRange: json['vehicleRange'],
      efficiency: json['efficiency'],
      fastCharge: json['fastCharge'],
    );
  }

  /// Model unique id
  int id;

  /// Battery usable capacity Wh
  double batteryCapacity;

  /// Maximum weight available on vehicle towbar
  int towbarPossible;

  /// Vehicle range in meters
  int vehicleRange;

  /// Consumption in Wh / km
  int efficiency;

  /// How many km charged in one hour (10 - 80 interval)
  int fastCharge;

  /// Supported charging ports, a combination of 1 or more [EVChargingConnector]
  int ports;

  /// Departure battery state of charge, from 0.f ( empty ) to 1.f ( full )
  double departureSoc;

  /// Destination min battery state of charge, from 0.f ( empty ) to 1.f ( full )
  double destinationSoc;

  /// Charger destination min battery state of charge, from 0.f ( empty ) to 1.f ( full )
  double chargerDestSoc;

  /// Charger departure max battery state of charge, from 0.f ( empty ) to 1.f ( full )
  double chargerDepSoc;

  /// Charger time overhead in minutes
  int chargerOverheadMins;

  /// Battery health, from 0.f ( nonfunctional ) to 1.f ( brand new )
  double batteryHealth;

  /// List of [EVChargingConnector]
  List<EVChargingConnector> get connectors {
    final List<EVChargingConnector> result = <EVChargingConnector>[];

    for (final EVChargingConnector connector in EVChargingConnector.values) {
      if ((ports & connector.id) != 0) {
        result.add(connector);
      }
    }

    return result;
  }

  /// List of [EVChargingConnector]
  set connectors(final List<EVChargingConnector> connectors) {
    int result = 0;

    for (final EVChargingConnector connector in connectors) {
      result |= connector.id;
    }

    ports = result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['id'] = id;

    json['ports'] = ports;

    json['departureSoc'] = departureSoc;
    json['destinationSoc'] = destinationSoc;
    json['chargerDestSoc'] = chargerDestSoc;
    json['chargerDepSoc'] = chargerDepSoc;
    json['chargerOverheadMins'] = chargerOverheadMins;
    json['battery_Health'] = batteryHealth;
    json['batteryCapacity'] = batteryCapacity;
    json['towbarPossible'] = towbarPossible;
    json['vehicleRange'] = vehicleRange;
    json['efficiency'] = efficiency;
    json['fastCharge'] = fastCharge;
    return json;
  }

  @override
  bool operator ==(covariant final EVProfile other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id &&
        other.ports == ports &&
        other.departureSoc == departureSoc &&
        other.destinationSoc == destinationSoc &&
        other.chargerDestSoc == chargerDestSoc &&
        other.chargerDepSoc == chargerDepSoc &&
        other.chargerOverheadMins == chargerOverheadMins &&
        other.batteryHealth == batteryHealth &&
        other.batteryCapacity == batteryCapacity &&
        other.towbarPossible == towbarPossible &&
        other.vehicleRange == vehicleRange &&
        other.efficiency == efficiency &&
        other.fastCharge == fastCharge;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      id,
      ports,
      departureSoc,
      destinationSoc,
      chargerDestSoc,
      chargerDepSoc,
      chargerOverheadMins,
      batteryHealth,
      batteryCapacity,
      towbarPossible,
      vehicleRange,
      efficiency,
      fastCharge,
    ]);
  }
}

/// Fuel Type
///
/// {@category Routes & Navigation}
enum FuelType {
  /// Petrol fuel type
  petrol,

  /// Diesel fuel type
  diesel,

  /// LPG (Liquid Petroleum Gas) fuel type
  lpg,

  /// Electric fuel type
  electric,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension FuelTypeExtension on FuelType {
  int get id {
    switch (this) {
      case FuelType.petrol:
        return 0;
      case FuelType.diesel:
        return 1;
      case FuelType.lpg:
        return 2;
      case FuelType.electric:
        return 3;
    }
  }

  static FuelType fromId(final int id) {
    switch (id) {
      case 0:
        return FuelType.petrol;
      case 1:
        return FuelType.diesel;
      case 2:
        return FuelType.lpg;
      case 3:
        return FuelType.electric;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
enum EVChargingConnector {
  /// J1772 connector
  j1772,

  /// Mennekes connector
  mennekes,

  /// Type 2 connector
  type2,

  /// Type 3 connector
  type3,

  /// GBT AC connector
  gbtAc,

  /// GBT DC connector
  gbtDc,

  /// CHAdeMO connector
  chaemo,

  /// CSS1 connector
  css1,

  /// CSS2 connector
  css2,

  /// Tesla connector
  tesla,

  /// Super Tesla connector
  superTesla,

  /// Super Tesla CCS connector
  superTeslaCCS,

  /// Tesla destination charger connector
  teslaDestination,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension EVChargingConnectorExtension on EVChargingConnector {
  int get id {
    switch (this) {
      case EVChargingConnector.j1772:
        return 0x1;
      case EVChargingConnector.mennekes:
        return 0x2;
      case EVChargingConnector.type2:
        return 0x4;
      case EVChargingConnector.type3:
        return 0x8;
      case EVChargingConnector.gbtAc:
        return 0x10;
      case EVChargingConnector.gbtDc:
        return 0x20;
      case EVChargingConnector.chaemo:
        return 0x40;
      case EVChargingConnector.css1:
        return 0x80;
      case EVChargingConnector.css2:
        return 0x100;
      case EVChargingConnector.tesla:
        return 0x200;
      case EVChargingConnector.superTesla:
        return 0x400;
      case EVChargingConnector.superTeslaCCS:
        return 0x800;
      case EVChargingConnector.teslaDestination:
        return 0x1000;
    }
  }

  static EVChargingConnector fromId(final int id) {
    switch (id) {
      case 0x1:
        return EVChargingConnector.j1772;
      case 0x2:
        return EVChargingConnector.mennekes;
      case 0x4:
        return EVChargingConnector.type2;
      case 0x8:
        return EVChargingConnector.type3;
      case 0x10:
        return EVChargingConnector.gbtAc;
      case 0x20:
        return EVChargingConnector.gbtDc;
      case 0x40:
        return EVChargingConnector.chaemo;
      case 0x80:
        return EVChargingConnector.css1;
      case 0x100:
        return EVChargingConnector.css2;
      case 0x200:
        return EVChargingConnector.tesla;
      case 0x400:
        return EVChargingConnector.superTesla;
      case 0x800:
        return EVChargingConnector.superTeslaCCS;
      case 0x1000:
        return EVChargingConnector.teslaDestination;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Motor vehicle profile.
///
/// This is a base class for car and truck profiles
///
/// {@category Routes & Navigation}
class MotorVehicleProfile {
  MotorVehicleProfile({
    this.mass = 0,
    this.maxSpeed = 0,
    this.fuel = FuelType.petrol,
  });

  /// Vehicle mass in kg. By default it is 0 and is not considered in routing
  int mass;

  /// Vehicle max speed in m/s. By default it is 0 and is not considered in routing
  double maxSpeed;

  /// Engine fuel type. Default is petrol
  FuelType fuel;
}

/// Truck routing profile
///
/// {@category Routes & Navigation}
class TruckProfile extends MotorVehicleProfile {
  /// Truck profile constructor with predefined FT_Diesel as fuel type.
  ///
  /// **Parameters**
  ///
  /// * **IN** *mass* Mass in kg.
  /// * **IN** *height* Height in cm.
  /// * **IN** *length* Length in cm.
  /// * **IN** *width* Width in cm.
  /// * **IN** *axleLoad* Axle load in kg.
  /// * **IN** *maxSpeed* Max speed in m/s.
  /// * **IN** *fuel* Fuel type.
  TruckProfile({
    this.height = 0,
    this.length = 0,
    this.width = 0,
    this.axleLoad = 0,
    super.maxSpeed = 0,
    super.mass = 0,
    super.fuel = FuelType.diesel,
  });

  factory TruckProfile.fromJson(final Map<String, dynamic> json) {
    return TruckProfile(
      mass: json['mass'],
      height: json['height'],
      length: json['length'],
      width: json['width'],
      axleLoad: json['axleLoad'],
      maxSpeed: json['maxSpeed'],
      fuel: FuelTypeExtension.fromId(json['fuel']),
    );
  }

  /// Truck height in cm. By default it is 0 and is not considered in routing
  int height;

  /// Truck length in cm. By default it is 0 and is not considered in routing
  int length;

  /// Truck width in cm. By default it is 0 and is not considered in routing
  int width;

  /// Truck axle load in kg. By default it is 0 and is not considered in routing
  int axleLoad;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['mass'] = mass;
    json['height'] = height;
    json['length'] = length;
    json['width'] = width;
    json['axleLoad'] = axleLoad;
    json['maxSpeed'] = maxSpeed;
    json['fuel'] = fuel.id;
    return json;
  }

  @override
  bool operator ==(covariant final TruckProfile other) {
    if (identical(this, other)) {
      return true;
    }
    return mass == other.mass &&
        height == other.height &&
        length == other.length &&
        width == other.width &&
        axleLoad == other.axleLoad &&
        maxSpeed == other.maxSpeed &&
        fuel == other.fuel;
  }

  @override
  int get hashCode {
    return Object.hash(mass, height, length, width, axleLoad, maxSpeed, fuel);
  }
}

/// Car routing profile
///
/// {@category Routes & Navigation}
class CarProfile extends MotorVehicleProfile {
  /// Car profile constructor with predefined [FuelType.petrol] as fuel type.
  ///
  /// **Parameters**
  ///
  /// * **IN** *mass* Mass in kg.
  /// * **IN** *fuel* Fuel type.
  /// * **IN** *maxSpeed* Max speed in m/s.
  CarProfile({
    super.mass = 0,
    super.fuel = FuelType.petrol,
    super.maxSpeed = 0.0,
  });

  factory CarProfile.fromJson(final Map<String, dynamic> json) {
    return CarProfile(
      mass: json['mass'],
      fuel: FuelTypeExtension.fromId(json['fuel']),
      maxSpeed: json['maxSpeed'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['mass'] = mass;
    json['fuel'] = fuel.id;
    json['maxSpeed'] = maxSpeed;
    return json;
  }

  @override
  bool operator ==(covariant final CarProfile other) {
    if (identical(this, other)) {
      return true;
    }

    return other.mass == mass &&
        other.fuel == fuel &&
        other.maxSpeed == maxSpeed;
  }

  @override
  int get hashCode {
    return mass.hashCode ^ fuel.hashCode ^ maxSpeed.hashCode;
  }
}
