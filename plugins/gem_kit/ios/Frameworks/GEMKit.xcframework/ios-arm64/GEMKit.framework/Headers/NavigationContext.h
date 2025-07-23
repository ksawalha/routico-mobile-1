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
#import <GEMKit/RouteObject.h>
#import <GEMKit/NavigationContextDelegate.h>
#import <GEMKit/NavigationInstructionObject.h>
#import <GEMKit/RoutePreferencesObject.h>
#import <GEMKit/GenericHeader.h>
#import <GEMKit/TransferStatisticsContext.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class handles the navigation.
 */
__attribute__((visibility("default"))) @interface NavigationContext : NSObject

/**
 * Initializes and returns a newly allocated object using the route preferences object.
 */
- (instancetype)initWithPreferences:(nonnull RoutePreferencesObject *)preferences;

/**
 The delegate for the navigation contex.
 */
@property(nonatomic, weak) NSObject <NavigationContextDelegate> *delegate;

/**
 * Returns the route preferences object.
 */
- (nonnull RoutePreferencesObject*)getRoutePreferencesObject;

/**
 * Calculate a route between the specified waypoints.
 * @param array The list of waypoints.
 * @param handler The block to execute asynchronously with the route results.
 */
- (void)calculateRouteWithWaypoints:(nonnull NSArray<LandmarkObject *> *)array completionHandler:(nonnull void(^)(NSArray<RouteObject *> *array))handler;

/**
 * Calculate a route between the specified waypoints.
 * @param array The list of waypoints.
 * @param statusHandler The block to execute asynchronously with operation status.
 * @param completionHandler The block to execute asynchronously with the route results.
 */
- (void)calculateRouteWithWaypoints:(nonnull NSArray<LandmarkObject *> *)array statusHandler:(nonnull void(^)(RouteStatus))statusHandler completionHandler:(nonnull void(^)(NSArray<RouteObject *> *array, SDKErrorCode code))completionHandler;

/**
 * Calculate a route between the specified waypoints and data buffer.
 * @param startArray The list of start waypoints.
 * @param data The data waypoints.
 * @param endArray The list of end waypoints.
 * @param handler The block to execute asynchronously with the route results.
 */
- (void)calculateRouteWithStartWaypoints:(nonnull NSArray<LandmarkObject *> *)startArray buffer:(nonnull NSData*)data endWaypoints:(nonnull NSArray<LandmarkObject *> *)endArray completionHandler:(nonnull void(^)(NSArray<RouteObject *> *array))handler;

/**
 * Cancel the route calculation.
 */
- (void)cancelCalculateRoute;

/**
 * Check if there is route calculation in progress.
 */
- (BOOL)isCalculatingRoute;

/**
 * Set a user road block from the provided route instruction.
 */
- (SDKErrorCode)setRouteRoadBlock:(nonnull RouteInstructionObject *)object;

/**
 * Reset the user road blocks.
 */
- (void)resetRouteRoadBlocks;

/**
 * Get data transfer statistics for this service.
 */
- (nonnull TransferStatisticsContext *)getTransferStatistics;

/**
 * Get the current route used for navigation.
 */
- (nullable RouteObject *)getNavigationRoute;

/**
 * Start a route simulation.
 * @param route The route object.
 * @param speed The route simulation speed multiplier.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)simulateWithRoute:(nonnull RouteObject *)route speedMultiplier:(float)speed completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Cancel the route simulation.
 */
- (void)cancelSimulateRoute;

/**
 * Start a route navigation.
 * @param route The route object.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)navigateWithRoute:(nonnull RouteObject *)route completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Cancel the route navigation.
 */
- (void)cancelNavigateRoute;

/**
 * Set a roadblock on the current route having the length specified in meters starting from the current GPS position.
 * @param length The length specified in meters.
 */
- (void)setRoadBlockWithLength:(NSInteger)length;

/**
 * Set a roadblock on the current route having the length and distance specified in meters.
 * @param length The length specified in meters.
 * @param distance The distance from start where the roadblock begins, defaults to -1 meaning the current navigation position.
 */
- (void)setRoadBlockWithLength:(NSInteger)length starting:(NSInteger)distance;

/**
 * Returns the minimum simulation speed multiplier.
 */
- (float)getSimulationMinSpeedMultiplier;

/**
 * Returns the maximum simulation speed multiplier.
 */
- (float)getSimulationMaxSpeedMultiplier;

/**
 * Returns the current navigation instruction.
 */
- (nullable NavigationInstructionObject*)getNavigationInstruction;

/**
 * Skip next intermediate destination on the navigation route.
 * @details If there are no more intermediate waypoints on the route, KNotFound is returned.
 * @details The route will be recalculated and an navigationRouteUpdated notification will be thrown.
 */
- (SDKErrorCode)skipNextIntermediateDestination;

/**
 * Returns true if there is an active navigation in progress.
 */
- (BOOL)isNavigationActive;

/**
 * Returns true if there is an active simulation in progress.
 */
- (BOOL)isSimulationActive;

/**
 * Returns the estimate time of arrival formatted.
 */
- (nonnull NSString*)getEstimateTimeOfArrivalFormatted;

/**
 * Returns the estimate time of arrival unit formatted.
 */
- (nonnull NSString*)getEstimateTimeOfArrivalUnitFormatted;

/**
 * Returns the remaining travel time formatted.
 */
- (nonnull NSString*)getRemainingTravelTimeFormatted;

/**
 * Returns the remaining travel time unit formatted.
 */
- (nonnull NSString*)getRemainingTravelTimeUnitFormatted;

/**
 * Returns the remaining travel distance formatted.
 */
- (nonnull NSString*)getRemainingTravelDistanceFormatted;

/**
 * Returns the remaining travel distance unit formatted.
 */
- (nonnull NSString*)getRemainingTravelDistanceUnitFormatted;

@end

NS_ASSUME_NONNULL_END
