// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all 
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V. 
// or its affiliates is strictly prohibited.

#import <Foundation/Foundation.h>
#import <GEMKit/TimeObject.h>

/**
 * Constants indicating the route type.
 */
typedef NS_ENUM(NSInteger, RouteType)
{
    /// Route type - fastest
    /// Fastest route between the given waypoints. The default route type.
    RouteTypeFastest = 0,
    
    /// Route type - shortest
    /// Shortest route between the given waypoints.
    RouteTypeShortest,
    
    /// Route type - economical
    /// Economical, as fuel consumption, route between the given waypoints.
    RouteTypeEconomic,
    
    /// Route type - scenic
    /// @brief Fastest route, with best scenic view, between the given waypoints.
    RouteTypeScenic
}; 

/**
 * Constants indicating the route transport mode.
 */
typedef NS_ENUM(NSInteger, RouteTransportMode)
{
    /// Transport mode car.
    RouteTransportModeCar = 0,
    
    /// Transport mode lorry.
    RouteTransportModeLorry,
    
    /// Transport mode pedestrian.
    RouteTransportModePedestrian,
    
    /// Transport mode bicycle.
    RouteTransportModeBicycle,
    
    /// Transport mode public.
    RouteTransportModePublic
};

/**
 * Constants indicating the route type preference.
 */
typedef NS_ENUM(NSInteger, RoutePreferenceType)
{
    /// No preference regarding route type, unpaved road is good enough.
    RoutePreferenceTypeNone = 0x00000000,
    
    /// Prefer buses.
    RoutePreferenceTypeBus = 0x00000001,
    
    /// Prefer underground/overground subways/metro and underground railway/tunnel transportation.
    RoutePreferenceTypeUnderground = 0x00000002,
    
    /// Prefer train and coach services.
    RoutePreferenceTypeRailway = 0x00000004,
    
    /// Prefer trams.
    RoutePreferenceTypeTram = 0x00000008,
    
    /// Prefer water transportation (boats, ships, gondolas, water taxis).
    RoutePreferenceTypeWaterTransport = 0x00000010,
    
    /// Prefer other means of transportation: funicular, telecabins, air transportation, taxis etc.
    RoutePreferenceTypeMisc = 0x00000020,
    
    /// Prefer shared bikes.
    RoutePreferenceTypeSharedBike = 0x00000040,
    
    /// Prefer shared cars.
    RoutePreferenceTypeSharedCar = 0x00000080,
    
    /// Prefer shared scooters.
    RoutePreferenceTypeSharedScooter = 0x000000100
};

/**
 * Constants indicating the traffic avoidance type.
 */
typedef NS_ENUM(NSInteger, TrafficAvoidanceType)
{
    /// None
    TrafficAvoidanceTypeNone = 0,
    
    /// All
    TrafficAvoidanceTypeAll = 1,
    
    /// Roadblocks
    TrafficAvoidanceTypeRoadblocks = 2
};

/**
 * Constants indicating the route result details.
 */
typedef NS_ENUM(NSInteger, RouteResultDetails)
{
    /// Path and guidance.
    RouteResultDetailsFull = 0,
    
    /// Path time / distance only.
    RouteResultDetailsTimeDistance,
    
    /// Path time / distance and geometry.
    RouteResultDetailsPath,
};

/**
 * Constants indicating the algorithm type.
 */
typedef NS_ENUM(NSInteger, RouteAlgorithmType)
{
    /// Algorithm type - departure / starting point.
    RouteAlgorithmTypeDeparture = 0,
    
    /// Algorithm type - arrival / destination point.
    RouteAlgorithmTypeArrival,
};

/**
 * Constants indicating the public transport sorting strategy.
 */
typedef NS_ENUM(NSInteger, PTRouteSortingStrategy)
{
    /// Sorting strategy - best time.
    PTRouteSortingStrategyBestTime = 0,
    
    /// Sorting strategy - least walk.
    PTRouteSortingStrategyLeastWalk,
    
    /// Sorting strategy - fewest transfers.
    PTRouteSortingStrategyLeastTransfers,
};

/**
 * Constants indicating the bike profile.
 */
typedef NS_ENUM(NSInteger, BikeProfile)
{
    /// Bike profile - road.
    BikeProfileRoad = 0,
    
    /// Bike profile - cross.
    BikeProfileCross,
    
    /// Bike profile - city.
    BikeProfileCity,
    
    /// Bike profile - mountain.
    BikeProfileMountain,
};

/**
 * Constants indicating the ebike profile.
 */
typedef NS_ENUM(NSInteger, EBikeProfile)
{
    /// eBike profile - none
    EBikeProfileNone = 0,
    
    /// eBike profile - pedelec
    EBikeProfilePedelec,
    
    /// eBike profile - power-on-demand
    EBikeProfilePowerOnDemand
};

/**
 * Constants indicating the ebike profile details.
 */
typedef struct {
    
    /// @details eBike type.
    EBikeProfile type;
    
    /// @details Bike mass in kg. If 0, a default value is used.
    float bikeMass;
    
    /// @details Biker mass in kg. If 0, a default value is used.
    float bikerMass;
    
    /// @details Bike auxiliary power consumption during day in Watts. If 0, a default value is used.
    float auxConsumptionDay;
    
    /// @details Bike auxiliary power consumption during night in Watts. If 0, a default value is used.
    float auxConsumptionNight;
    
    /// @details Battery usable capacity Wh. Default to 1000 Wh.
    float batteryCapacity;
    
    /// @details Departure battery state of charge, from 0.f ( empty ) to 1.f ( full )
    float departureSoc;
    
    /// @details Reference speed in m/s. The usual speed for this e-bike type, default is 0 meaning an internal SDK parameter is used.
    float refSpeed;
    
    /// @details Ignore country based legal restrictions related to e-bikes.
    bool ignoreLegalRestrictions;
    
} EBikeProfileDetails;

/**
 * Constants indicating the pedestrian profile.
 */
typedef NS_ENUM(NSInteger, PedestrianProfile)
{
    /// Pedestrian profile - walk.
    PedestrianProfileWalk = 0,
    
    /// Pedestrian profile - hike.
    PedestrianProfileHike,
};

/**
 * Constants indicating the Truck routing profile.
 */
typedef struct {
    
    /// @details Truck weight in kg. By default is 0 and is not considered in routing
    int mass;
    
    /// @details Truck height in cm. By default is 0 and is not considered in routing
    int height;
    
    /// @details Truck length in cm. By default is 0 and is not considered in routing
    int length;
    
    /// @details Truck width in cm. By default is 0 and is not considered in routing
    int width;
    
    /// @details Truck max weight / axle in kg. By default is 0 and is not considered in routing
    int axleLoad;
    
    /// @details Truck max speed im m/s. By default is 0 and is not considered in routing
    double maxSpeed;
    
} TruckProfileDetails;

/**
 * Constants indicating the alternative routes scheme.
 */
typedef NS_ENUM(NSInteger, RouteAlternativesSchema)
{
    /// Alternative routes scheme - Service default - depending on selected transport, route type & result details.
    RouteAlternativesSchemaDefault = 0,
    
    /// Alternative routes scheme - No alternatives.
    RouteAlternativesSchemaNever,
    
    /// Alternative routes scheme - Always ( even if not recommended, e.g. for shortest etc ).
    RouteAlternativesSchemaAlways,
};

/**
 * Constants indicating the Path calculation algorithm.
 */
typedef NS_ENUM(NSInteger, RoutePathAlgorithmType)
{
    /// Path calculation algorithm - Default Magic Lane routing algorithm.
    RoutePathAlgorithmTypeMagicLane,
    
    /// Simplified Magic Lane routing algorithm - Best speed, recommended for low end devices.
    RoutePathAlgorithmTypeMagicLaneSimplified,
    
    /// Path calculation algorithm - Magic Lane Contraction Hierarchy routing algorithm.
    RoutePathAlgorithmTypeMagicLaneCH,
    
    /// Path calculation algorithm - External Contraction Hierarchy routing algorithm.
    RoutePathAlgorithmTypeExternalCH,
};

/**
 * Constants indicating the Path calculation flavors.
 */
typedef NS_ENUM(NSInteger, RoutePathAlgorithmFlavorType)
{
    /// Default Magic Lane routing.
    RoutePathAlgorithmFlavorTypeMagicLane,
    
    /// GraphHopper routing. 
    RoutePathAlgorithmFlavorTypeGraphHopper
};

/**
 * Constants indicating the emergency vehicles extra freedom options.
 */
typedef NS_ENUM(int, EmergencyExtraFreedomLevels)
{
    /// Ignore map defined conditional maneuvers such as prohibited turn left / turn right.
    EmergencyExtraFreedomLevelsIgnoreCDM = 0x1
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates route preferences object.
 */
__attribute__((visibility("default"))) @interface RoutePreferencesObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Tests if avoid motorways is set. Default is false.
 */
- (BOOL)getAvoidMotorways;

/**
 * Sets the avoid motorways flag.
 */
- (void)setAvoidMotorways:(BOOL)state;

/**
 * Tests if avoid toll roads is set. Default is false.
 */
- (BOOL)getAvoidTollRoads;

/**
 * Sets the avoid toll roads flag.
 */
- (void)setAvoidTollRoads:(BOOL)state;

/**
 * Tests if avoid ferries is set. Default is false.
 */
- (BOOL)getAvoidFerries;

/**
 * Sets the avoid ferries flag.
 */
- (void)setAvoidFerries:(BOOL)state;

/**
 * Tests if avoid turnaround instruction flag is set. Default is false.
 */
- (BOOL)getAvoidTurnAroundInstruction;

/**
 * Set the avoid turnaround instruction flag. If set to true then the message "Turnaround when possible" will be avoided during navigation.
 * @details This preference is always overridden in car / truck navigation route recalculations, in which cases the current driving direction is used.
 * @details For car / truck this preference is used when setting a user roadblock during navigation. If set to false, a turn around instruction may be generated.
 */
- (void)setAvoidTurnAroundInstruction:(BOOL)state;

/**
 * Tests if avoid unpaved roads is set. Default is false.
 */
- (BOOL)getAvoidUnpavedRoads;

/**
 * Sets the avoid unpaved roads flag.
 */
- (void)setAvoidUnpavedRoads:(BOOL)state;

/**
 * Tests if avoid carpool lanes is set. Default is false.
 */
- (BOOL)getAvoidCarpoolLanes;

/**
 * Sets the avoid carpool lanes flag.
 */
- (void)setAvoidCarpoolLanes:(BOOL)state;

/**
 * Get route type. Default is Fastest.
 */
- (RouteType)getRouteType;

/**
 * Sets the route type.
 */
- (void)setRouteType:(RouteType)type;

/**
 * Get transport mode. Default is Car.
 */
- (RouteTransportMode)getTransportMode;

/**
 * Sets the transport mode.
 */
- (void)setTransportMode:(RouteTransportMode)type;

/**
 * Get algorithm type.
 */
- (RouteAlgorithmType)getAlgorithmType;

/**
 * Set algorithm type.
 */
- (void)setAlgorithmType:(RouteAlgorithmType)type;

/**
 * Get sorting strategy.
 */
- (PTRouteSortingStrategy)getSortingStrategy;

/**
 * Set sorting strategy.
 */
- (void)setSortingStrategy:(PTRouteSortingStrategy)type;

/**
 * Get timestamp.
 */
- (nonnull TimeObject *)getTimestamp;

/**
 * Set timestamp.
 */
- (void)setTimestamp:(nonnull TimeObject *)time;

/**
 * Get use wheelchair.
 */
- (BOOL)getUseWheelchair;

/**
 * Set use wheelchair.
 */
- (void)setUseWheelchair:(BOOL)state;

/**
 * Get use bikes.
 */
- (BOOL)getUseBikes;

/**
 * Sett use bikes.
 */
- (void)setUseBikes:(BOOL)state;

/**
 * Get minimum transfer time in minutes. Default is 0.
 */
- (int)getMinimumTransferTimeInMinutes;

/**
 * Set minimum transfer time in minutes.
 */
- (void)setMinimumTransferTimeInMinutes:(int)value;

/**
 * Get maximum transfer time in minutes. Default is 300.
 */
- (unsigned int)getMaximumTransferTimeInMinutes;

/**
 * Set maximum transfer time in minutes.
 */
- (void)setMaximumTransferTimeInMinutes:(unsigned int)value;

/**
 * Get maximum walk distance. Default is 4000.
 */
- (unsigned int)getMaximumWalkDistance;

/**
 * Set maximum walk distance in meters.
 */
- (void)setMaximumWalkDistance:(unsigned int)value;

/**
 * Get route calculation traffic avoidance method.
 * @details Default is TrafficAvoidanceTypeNone.
 */
- (TrafficAvoidanceType)getAvoidTraffic;

/**
 * Enable / disable traffic information usage for route calculation.
 */
- (void)setAvoidTraffic:(BOOL)state;

/**
 * Set route calculation traffic avoidance method.
 * @details Default is TrafficAvoidance None.
 */
- (void)setAvoidTrafficType:(TrafficAvoidanceType)type;

/**
 * Set avoidance of the given geofence area ids.
 * @param areas The geofence area ids to avoid.
 * @details Send an empty list to disable geofence area avoidance.
 * @return The geofence area ids to avoid
 */
- (void)setAvoidGeofenceAreas:(nonnull NSArray <NSString *> *)areas;

/**
 * Get the geofence area avoidance ids list.
 * @return The geofence area ids to avoid
 */
- (nonnull NSArray <NSString *> *)getAvoidGeofenceAreas;

/**
 * Returns true if alternative routes balanced sorting is enabled.
 */
- (BOOL)getAlternativeRoutesBalancedSorting;

/**
 * Enable / disable alternatives routes balanced sorting.
 */
- (void)setAlternativeRoutesBalancedSorting:(BOOL)state;

/**
 * Get route type preferences. Default is 0 - no special preference for one route type.
 */
- (int)getRouteTypePreferences;

/**
 * Set route type preferences. Example ( RoutePreferenceTypeBus | RoutePreferenceTypeUnderground )
 */
- (void)setRouteTypePreferences:(int)value;

/**
 * Get group ids for earlier / later trip.
 */
- (nonnull NSArray < NSNumber *> *)getRouteGroupIdsEarlierLater;

/**
 * Set group ids for earlier / later trip.
 */
- (void)setRouteGroupIdsEarlierLater:(nonnull NSArray < NSNumber *> *)array;

/**
 * Get terrain profile build.
 */
- (BOOL)getBuildTerrainProfile;

/**
 * Set terrain profile build.
 */
- (void)setBuildTerrainProfile:(BOOL)state;

/**
 * Get selected bike profile.
 */
- (BikeProfile)getBikeProfile;

/**
 * Set bike profile.
 */
- (void)setBikeProfile:(BikeProfile)profile;

/**
 * Set bike profile with EBike profile details.
 */
- (void)setBikeProfile:(BikeProfile)profile withEBikeProfileDetails:(EBikeProfileDetails)eBikeProfileDetails;

/**
 * Get the EBike profile details.
 */
- (EBikeProfileDetails)getEBikeProfileDetails;

/**
 * Get the default bike profile details.
 */
- (EBikeProfileDetails)getDefaultEBikeProfile;

/**
 * Get avoid biking hill factor.
 */
- (float)getAvoidBikingHillFactor  __attribute__((deprecated("Please use getFitnessFactor.")));

/**
 * Set avoid biking hill factor.
 * @details 0.f - no avoidance, 1.f - full avoidance.
 */
- (void)setAvoidBikingHillFactor:(float)factor __attribute__((deprecated("Please use setFitnessFactor.")));

/**
 * Get bike & pedestrian routing fitness factor.
 * @details Default is 0.5 ( normal / good shape ).
 */
- (float)getFitnessFactor;

/**
 * Set the bike & pedestrian routing fitness factor.
 * @param factor The fitness factor in range [0, 1], 0.f - untrained , 1.f - professional
 * @details The fitness factor affects route path configuration.
 * @details For mountain bike and pedestrian hiking profiles the fitness factor is used to boost to steeper slopes in path links selection.
 * @details For city bike, road bike and cross bike the fitness factor is used to avoid steeper slopes in path links selection.
 */
- (void)setFitnessFactor:(float)factor;

/**
 * Get pedestrian profile.
 */
- (PedestrianProfile)getPedestrianProfile;

/**
 * Set pedestrian profile.
 */
- (void)setPedestrianProfile:(PedestrianProfile)profile;

/**
 * Gets truck profile.
 */
- (TruckProfileDetails)getTruckProfile;

/**
 * Sets truck profile.
 */
- (void)setTruckProfile:(TruckProfileDetails)profile;

/**
 * Set route ranges list.
 * @details A non empty int range list will generate an isocost range route result.
 * @details Range result quality must a valid integer in 0 - 100 range, 0 = lowest quality, 100 = highest quality.
 * @details Ranges units depends on route type: Fastest - seconds,  Shortest - meters, Economic - Wh.
 */
- (void)setRouteRanges:(nonnull NSArray <NSNumber *> *)array quality:(int)quality;

/**
 * Get route ranges list.
 */
- (nonnull NSArray <NSNumber *> *)getRouteRanges;

/**
 * Get route range quality.
 * @details Default is 100 ( max quality ).
 */
- (int)getRouteRangesQuality;

/**
 * Get result details.
 */
- (RouteResultDetails)getResultDetails;

/**
 * Set result details.
 */
- (void)setResultDetails:(RouteResultDetails)details;

/**
 * Get alternative schema.
 */
- (RouteAlternativesSchema)getAlternativesSchema;

/**
 * Set alternative schema.
 */
- (void)setAlternativesSchema:(RouteAlternativesSchema)schema;

/**
 * Get service maximum distance constraint. Default is active.
 * @details Maximum distance constraint depends on transport and result details.
 */
- (BOOL)getMaximumDistanceConstraint;

/**
 * Set maximum distance constraint.
 */
- (void)setMaximumDistanceConstraint:(BOOL)state;

/**
 * Set the ignore map restrictions in route-over-track mode.
 * @details Default is false
 */
- (void)setIgnoreRestrictionsOverTrack:(BOOL)state;

/**
 * Get the ignore map restrictions in route-over-track mode.
 * @details Default is false.
 */
- (BOOL)getIgnoreRestrictionsOverTrack;

/**
 * Set the track accurate match.
 */
- (void)setAccurateTrackMatch:(BOOL)value;

/**
 * Get the track accurate match.
 * @details Default is true.
 */
- (BOOL)getAccurateTrackMatch;

/**
 * Set the track resume mode. 
 * @details If true, the track will be used in routing from the closest coordinate until the last.
 * @details At least one waypoint before the track waypoint should be configured - this will determine the closest position on track.
 * @details If false, the track will be used entirely in routing, from the first coordinate until the last.
 */
- (void)setTrackResume:(BOOL)value;

/**
 * Get the track resume mode. The default value is true.
 */
- (BOOL)getTrackResume;

/**
 * Set the emergency vehicle mode.
 * @param mode The emergency vehicle mode, true for activation.
 * @details Emergency mode enables setAvoidTurnAroundInstruction setting also for car/truck.
 * @details Emergency mode enables access to emergency dedicated links.
 * @details Default is false.
 */
- (void)setEmergencyVehicleMode:(BOOL)mode;

/**
 * Set the emergency vehicle mode.
 * @param mode The emergency vehicle mode, true for activation.
 * @param extraFreedom The extra freedom levels for emergency vehicles, packed in an integer value. See EmergencyExtraFreedomLevels for possible values.
 * @details Emergency mode enables setAvoidTurnAroundInstruction setting also for car/truck.
 * @details Emergency mode enables access to emergency dedicated links.
 * @details Default is false
 */
- (void)setEmergencyVehicleMode:(BOOL)mode extraFreedom:(int)extraFreedom;

/**
 * Get the emergency vehicle mode.
 */
- (BOOL)getEmergencyVehicleMode;

/**
 * Get the emergency vehicle extra freedom levels packed in an integer value. See EmergencyExtraFreedomLevels for possible values
 */
- (int)getEmergencyVehicleExtraFreedomLevels;

/**
 * Get path algorithm.
 */
- (RoutePathAlgorithmType)getPathAlgorithm;

/**
 * Set path algorithm.
 */
- (void)setPathAlgorithm:(RoutePathAlgorithmType)algorithmType;

/**
 * Get path algorithm flavor. Default is RoutePathAlgorithmFlavorTypeMagicLane.
 */
- (RoutePathAlgorithmFlavorType)getPathAlgorithmFlavor;

/**
 * Set path algorithm flavor.
 */
- (void)setPathAlgorithmFlavor:(RoutePathAlgorithmFlavorType)flavorType;

/**
 * Get the departure heading in degrees.
 */
- (double)getDepartureHeading;

/**
 * Get the departure heading accuracy in degrees.
 */
- (double)getDepartureHeadingAccuracy;

/**
 * Set the departure heading in degrees.
 * @param head The departure heading, in degrees east from north axis.
 * @details Values are in 0 - 360 interval with 0 representing the magnetic north.
 * @details Value -1 means no departure heading is specified.
 * @param accuracy The departure heading accuracy, in degrees.
 * @details Values are in 0 - 90 interval. A typical value is 25 degrees.
 */
- (void)setDepartureHeading:(double)head accuracy:(double)accuracy;

/**
 * Get the online route calculation allowance.
 * @details Default value is true.
 */
- (BOOL)getAllowOnlineCalculation;

/**
 * Set the online route calculation allowance.
 */
- (void)setAllowOnlineCalculation:(BOOL)state;

/**
 * Set build route connections.
 * @param state Enable connections build.
 * @param maxLengthM Maximum connection length. For default set -1.
 */
- (void)setBuildConnections:(BOOL)state maxLengthM:(int)maxLengthM;

/**
 * Get route connections build state.
 */
- (BOOL)getBuildConnections;

/**
 * Get route connections build max length.
 */
- (int)getBuildConnectionsMaxLength;

/**
 * Get accurate waypoints approach. Default is false.
 *  @details An accurate approach implies that the route arrives at the waypoint on the drive side of the region.
 */
- (BOOL)getAccurateWaypointsApproach;

/**
 * Set the accurate waypoints approach.
 * @param state The approach value, true for accurate approach.
 */
- (void)setAccurateWaypointsApproach:(BOOL)state;

@end

NS_ASSUME_NONNULL_END
