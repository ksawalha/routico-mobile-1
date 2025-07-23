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
#import <GEMKit/LandmarkObject.h>
#import <GEMKit/RouteInstructionObject.h>
#import <GEMKit/PTRouteInstructionObject.h>
#import <GEMKit/RectangleGeographicAreaObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates route segment information.
 */

__attribute__((visibility("default"))) @interface RouteSegmentObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the list of waypoints.
 * @details The waypoints are ordered like: departure, first waypoint, ..., destination. Only the route can have intermediate waypoints. The segments have only departure and destination.
 */
- (nonnull NSArray<LandmarkObject *> *)getWaypoints;

/**
 * Returns the length in meters and estimated travel time in seconds for the route segment.
 */
- (nullable TimeDistanceObject *)getTimeDistance;

/**
 * Returns the geographic area of the route. The geographic area is the smallest rectangle that can be drawn around the route.
 */
- (nullable RectangleGeographicAreaObject *)getGeographicArea;

/**
 * Returns true if traveling the route or route segment incurs cost to the user.
 */
-(BOOL)getIncursCosts;

/**
 * Returns the summary of the route segment.
 */
- (NSString*)getSummary;

/**
 * Returns the route instructions list.
 */
- (nonnull NSArray<RouteInstructionObject *> *)getInstructions;

/**
 * Returns the public transit route instructions list.
 */
- (nonnull NSArray<PTRouteInstructionObject *> *)getPTInstructions;

/**
 * Returns true if route segment is common.
 * @details A common type route segment has the same travel mode as the parent route.
 * @details E.g. a walk segment in a public transport route has isCommon = false
 */
- (BOOL)isCommon;

@end

NS_ASSUME_NONNULL_END
