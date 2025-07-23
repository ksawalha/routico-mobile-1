// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all 
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V. 
// or its affiliates is strictly prohibited.

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <GEMKit/CoordinatesObject.h>
#import <GEMKit/LandmarkObject.h>
#import <GEMKit/RouteSegmentObject.h>
#import <GEMKit/RouteTrafficEventObject.h>
#import <GEMKit/RouteTerrainProfileObject.h>
#import <GEMKit/RectangleGeographicAreaObject.h>
#import <GEMKit/PathObject.h>
#import <GEMKit/RoutePreferencesObject.h>
#import <GEMKit/SearchableParameterListObject.h>
#import <GEMKit/RouteObjectDelegate.h>
#import <GEMKit/TimeDistanceCoordinatesObject.h>

/**
 * Constants indicating the route status.
 */
typedef NS_ENUM(NSInteger, RouteStatus)
{
    /// Uninitialized.
    RouteStatusUninitialized = 0,
    
    /// Calculating.
    RouteStatusCalculating,
    
    /// Waiting internet connection.
    RouteStatusWaitingInternetConnection,
    
    /// Ready.
    RouteStatusReady,
    
    /// Error.
    RouteStatusError
};

/**
 * Constants indicating the route waypoints options.
 */
typedef NS_ENUM(NSInteger, RouteWaypointsOption)
{
    /// Initial route calculation waypoints.
    RouteWaypointsOptionInitial = 0,
    
    /// Remaining to travel set from the initial calculation waypoints. Navigating a route will remove all passed by intermediate waypoints.
    RouteWaypointsOptionRemainingInitial,
    
    /// Remaining to travel set ( user set + service added set ). Routing service may add additional waypoints to route result, e.g. for follow track and EV routing
    RouteWaypointsOptionRemaining
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates route information.
 */
__attribute__((visibility("default"))) @interface RouteObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 The delegate for the route.
 */
@property(nonatomic, weak) NSObject <RouteObjectDelegate> *delegate;

/**
 * Returns true if the route is a Public Transport route.
 */
- (BOOL)isPTRoute;

/**
 * Returns Public Transport route.
 */
- (nullable RouteObject *)toPTRoute;

/**
 * Check if the route is an EV route.
 */
- (BOOL)isEVRoute;

/**
 * Check if the route is an over track route.
 */
- (BOOL)isOTRoute;

/**
 * Convert to a EVRoute from this one.
 */
- (nullable RouteObject *)toEVRoute;

/**
 * Convert to an over track route from this one.
 */
- (nullable RouteObject *)toOTRoute;

/**
 * Returns the list of waypoints.
 * @details The waypoints are ordered like: departure, first waypoint, ..., destination.
 */
- (nonnull NSArray<LandmarkObject *> *)getWaypoints;

/**
 * Returns the list of waypoints.
 * @param option. See RouteWaypointsOption for details
 */
- (nonnull NSArray<LandmarkObject *> *)getWaypoints:(RouteWaypointsOption)option;

/**
 * Returns the length in meters and estimated travel time in seconds for the route.
 */
- (nullable TimeDistanceObject *)getTimeDistance;

/**
 * Returns the geographic area of the route. The geographic area is the smallest rectangle that can be drawn around the route.
 */
- (nullable RectangleGeographicAreaObject *)getGeographicArea;

/**
 * Returns true if traveling the route or route segment incurs cost to the user.
 */
- (BOOL)getIncursCosts;

/**
 * Returns the summary of the route.
 */
- (nonnull NSString*)getSummary;

/**
 * Returns the length in meters and estimated travel time in seconds for the route.
 * @param activePart If true, returns only the active part of the route metrics, if false returns whole route metrics.
 */
- (nullable TimeDistanceObject *)getTimeDistanceWithActivePart:(BOOL)activePart;

/**
 * Returns the list of traffic events affecting the route.
 */
- (nonnull NSArray<RouteTrafficEventObject *> *)getTrafficEvents;

/**
 * Returns the route segment list.
 */
- (nonnull NSArray<RouteSegmentObject *> *)getSegments;

/**
 * Returns the index of the closest route segment to the given location.
 */
- (int)getClosestSegment:(nonnull CoordinatesObject *)location;

/**
 * Returns true if the route contains ferry connections.
 */
- (BOOL)hasFerryConnections;

/**
 * Returns true if the route contains toll roads.
 */
- (BOOL)hasTollRoads;

/**
 * Returns the route status.
 */
- (RouteStatus)getStatus;

/**
 * Export route data in the requested data format.
 * @param format Data format, see PathObject, PathFileFormat.
 */
- (nullable NSData *)exportAs:(PathFileFormat)format;

/**
 * Export route data in the requested data format.
 * @param format Data format, see PathObject, PathFileFormat.
 * @param compressed Compression flag.
 */
- (nullable NSData *)exportAs:(PathFileFormat)format withCompresion:(BOOL)compressed;

/**
 * Returns the route terrain profile.
 * @details The setBuildTerrainProfile API must be called on Route Preferences in order for profile to be available.
 */
- (nullable RouteTerrainProfileObject *)getTerrainProfile;

/**
 * Returns a coordinate on route at the given distance.
 */
- (nullable CoordinatesObject *)getCoordinateOnRoute:(int)distance;

/**
 * Returns a time distance coordinate on route from the given coordinate.
 */
- (nullable TimeDistanceCoordinatesObject *)getTimeDistanceCoordinateOnRoute:(nonnull CoordinatesObject *)coordinate;

/**
 * Returns the route distance from departure at the given coordinate.
 * @param activePart If true, returns only the active distance part.
 */
- (int)getDistanceOnRoute:(nonnull CoordinatesObject*)location activePart:(BOOL)activePart;

/**
 * Returns a path object from the route start - end segment.
 * @param start The start distance in meters.
 * @param end The end distance in meters.
 */
- (nullable PathObject*)getPath:(int)start end:(int)end;

/**
 * Build path from route.
 */
- (nullable PathObject*)getPath;

/**
 * Build a list of timestamp coordinates from a route.
 * @param[in] start Start distance from route start.
 * @param[in] end End distance from route start.
 * @param[in] step The step on which the coordinates are created.
 * @param[in] stepType The step unit type: true = distance in meters, false = time in seconds.
 * @return The result list
 */
- (nonnull NSArray<TimeDistanceCoordinatesObject*> *)getTimeDistanceCoordinatesFrom:(int)start end:(int)end step:(int)step stepType:(BOOL)stepType;

/**
 * Get the dominant road names.
 * @details A road is considered dominant when it covers n% from route total length.
 * @return The names list. If a road has multiple names, they will be presented as "name1 / name2 / ... / namex"
 */
- (nonnull NSArray <NSString *> *)getDominantRoads;

/**
 * Returns the route preferences.
 */
- (nullable RoutePreferencesObject *)getPreferences;

/**
 * Get user extra info.
 */
- (nullable SearchableParameterListObject *)getExtraInfo;

/**
 * Set user extra info.
 */
- (void)setExtraInfo:(nonnull SearchableParameterListObject *)list;

/**
 * Returns true if the current route is equal with route.
 */
- (BOOL)isEqualWithRoute:(nonnull RouteObject *)route;

@end

NS_ASSUME_NONNULL_END
