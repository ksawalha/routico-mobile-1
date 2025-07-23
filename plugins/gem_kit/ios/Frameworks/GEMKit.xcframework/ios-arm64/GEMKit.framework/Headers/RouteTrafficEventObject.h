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
#import <GEMKit/CoordinatesObject.h>
#import <GEMKit/TimeObject.h>
#import <GEMKit/TrafficEventObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates route traffic event information.
 */
__attribute__((visibility("default"))) @interface RouteTrafficEventObject : TrafficEventObject

/**
 * Returns the distance in meters from starting point on current route of the traffic event to the destination.
 */
- (int)getDistanceToDestination;

/**
 * Returns the route traffic event start point.
 */
- (nullable CoordinatesObject *)getFrom;

/**
 * Returns the route traffic event end point.
 */
- (nullable CoordinatesObject *)getTo;

/**
 * Returns the traffic event start point as landmark.
 */
- (nullable LandmarkObject*)getFromLandmark;

/**
 * Returns the traffic event end point as landmark.
 */
- (nullable LandmarkObject*)getToLandmark;

/**
 * Returns true if event contains traffic delay.
 * @param distance The remaining travel distance in meters.
 */
- (BOOL)hasTrafficEventOnDistance:(unsigned int)distance;

/**
 * Returns the distance formatted.
 */
- (nonnull NSString*)getDistanceFormatted;

/**
 * Returns the distance unit formatted.
 */
- (nonnull NSString*)getDistanceUnitFormatted;

/**
 * Returns the delay time formatted.
 */
- (nonnull NSString*)getDelayTimeFormatted;

/**
 * Returns the delay time unit formatted.
 */
- (nonnull NSString*)getDelayTimeUnitFormatted;

/**
 * Returns the delay distance formatted.
 */
- (nonnull NSString*)getDelayDistanceFormatted;

/**
 * Returns the delay distance unit formatted.
 */
- (nonnull NSString*)getDelayDistanceUnitFormatted;

@end

NS_ASSUME_NONNULL_END
