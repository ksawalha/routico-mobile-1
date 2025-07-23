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
#import <CoreLocation/CoreLocation.h>
#import <GEMKit/RoutePreferencesObject.h>
#import <GEMKit/DataSourceHeader.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates position preferences object.
 */
__attribute__((visibility("default"))) @interface DataSourceConfigurationObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Sets the allow background location updates flag.
 * @param state A Boolean value indicating whether the Sdk should receive location updates when client app is in background. Setting the value to YES but omitting the UIBackgroundModes key and location value in your app’s Info.plist file is a programmer error.
 * @discussion Application must have access to user location before calling this API.
 */
- (void)setAllowBackgroundLocationUpdates:(BOOL)state;

/**
 * Sets the position accuracy flag.
 */
- (void)setPositionAccuracy:(PositionAccuracyType)accuracy;

/**
 * Sets the position activity flag.
 */
- (void)setPositionActivity:(PositionActivityType)activity;

/**
 * Sets the pauses location updates automatically flag.
 */
- (void)setPausesLocationUpdatesAutomatically:(BOOL)state;

/**
 * Sets the position distance filter flag.
 * @details The minimum distance in meters the device must move horizontally before an update event is generated.
 */
- (void)setPositionDistanceFilter:(float)distanceFilter;

/**
 * Sets the improved position update frequency.
 * @details Default value is 30 Hz. Bigger frequency provides smoother positions but increases CPU / battery usage.
 */
- (void)setImprovedPositionUpdateFrequency:(NSInteger)frequency;

/**
 * Sets the improved position default transport mode.
 */
- (void)setImprovedPositionDefTransportMode:(RouteTransportMode)mode;

/**
 * Sets the threshold for snapping to map link data ( meters integer ) - car / truck transport mode.
 * @details default 50 meters.
 * If position is close to a map link at a smaller distance than this value, the improved position will automatically snap to the map link.
 * 0 means never snap to map data.
 */
- (void)setImprovedPositionSnapToMapLinkThresholdVehicle:(NSInteger)threshold;

/**
 * Sets the threshold for snapping to map link data ( meters integer ) - bike transport mode.
 * @details default 50 meters
 * if position is close to a map link at a smaller distance than this value, the improved position will automatically snap to the map link
 * 0 means never snap to map data.
 */
- (void)setImprovedPositionSnapToMapLinkThresholdBike:(NSInteger)threshold;

/**
 * Sets the preffered  value for snapping the arrow to the route (instead of the most probable link). Default is false.
 * @details If set to true, the arrow will always snap to the route (if the route exits). If set to false, it will snap to the most probable map link, which is not necessarily the route link.
 * This is only for display; does not affect the matching and guidance algorithm
 */
- (void)setImprovedPositionPreferRouteSnap:(BOOL)state;

@end

NS_ASSUME_NONNULL_END
