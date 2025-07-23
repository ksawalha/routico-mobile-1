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
#import <GEMKit/RouteObject.h>
#import <GEMKit/TransferStatisticsContext.h>
#import <GEMKit/TrafficEventObject.h>
#import <GEMKit/TimeObject.h>
#import <GEMKit/RoutePreferencesObject.h>
#import <GEMKit/PersistentRoadblockDelegate.h>
#import <GEMKit/CircleGeographicAreaObject.h>

/**
 * Constants indicating the traffic usage.
 */
typedef NS_ENUM(NSInteger, TrafficUsage)
{
    /// No traffic.
    TrafficUsageUseNone = 0,
    
    /// Online and offline.
    TrafficUsageUseOnline,
    
    /// Offline only.
    TrafficUsageUseOffline
};

/**
 * Constants indicating the restrictions which prevent online service functionality.
 */
typedef NS_ENUM(NSInteger, TrafficOnlineRestrictions)
{
    /// Service is disabled from settings.
    TrafficOnlineRestrictionsSettings = 1,
    
    /// No internet connection.
    TrafficOnlineRestrictionsConnection = 2,
    
    /// Restricted by network type.
    TrafficOnlineRestrictionsNetworkType = 4,
    
    /// Missing provider data.
    TrafficOnlineRestrictionsProviderData = 8,
    
    /// Outdated world map version.
    TrafficOnlineRestrictionsWorldMapVersion = 16,
    
    /// Not enough disk space to store data.
    TrafficOnlineRestrictionsDiskSpace = 32
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class handles the traffic information.
 */
__attribute__((visibility("default"))) @interface TrafficContext : NSObject

/**
 The delegate for the persistent roadblock.
 */
@property(nonatomic, weak) NSObject <PersistentRoadblockDelegate> *persistentRoadblockDelegate;

/**
 * Get the online traffic service restrictions for the given position.
 * @param location The check location.
 * @return Traffic restriction type.
 */
- (TrafficOnlineRestrictions)getOnlineServiceRestrictions:(nonnull CoordinatesObject *)location;

/**
 * Get data transfer statistics for this service.
 */
- (nonnull TransferStatisticsContext*)getTransferStatistics;

/**
 * Add an user persistent roadblock to collection ( path impact zone type ).
 * @param coordinates The roadblock coordinates list.
 * @param startUTC The roadblock start time in Coordinated Universal Time.
 * @param expireUTC The roadblock expire time in Coordinated Universal Time.
 * @param transportMode The transport mode for which the roadblock applies.
 * @details if coordsStart == coordsEnd a point located roadblock is defined - this may result in 2 map roadblocks for both ways.
 * @details if coordsStart != coordsEnd a path located roadblock is defined - this will result in 1 map roadblock in start -> end way.
 * @return The new defined roadblock. On success it contains new event information, on failure null.
 */
- (nullable TrafficEventObject *)addPersistentRoadblock:(nonnull NSArray <CoordinatesObject *> *)coordinates startTime:(nonnull TimeObject *)startUTC expireTime:(nonnull TimeObject *)expireUTC transportMode:(RouteTransportMode)transportMode;

/**
 * Add an user persistent roadblock to collection ( area impact zone type ).
 * @param circleArea The geographic area affected by the roadblock.
 * @param startUTC The roadblock start time in Coordinated Universal Time.
 * @param expireUTC The roadblock expire time in Coordinated Universal Time.
 * @param transportMode The transport mode for which the roadblock applies.
 * @param id The user roadblock id. Can be used to get / delete a defined roadblock
 * @return The new defined roadblock. On success it contains new event information, on failure null.
 */
- (nullable TrafficEventObject *)addPersistentRoadblock:(nonnull CircleGeographicAreaObject*)circleArea startTime:(nonnull TimeObject *)startUTC expireTime:(nonnull TimeObject *)expireUTC transportMode:(RouteTransportMode)transportMode identifier:(nonnull NSString *)identifier;

/**
 * Remove an user persistent roadblock.
 * @param location The roadblock start coordinates.
 * @details Coords must be equal with coordsStart provided when the roadblock was defined.
 */
- (void)removePersistentRoadblock:(nonnull CoordinatesObject *)location;

/**
 * Remove all user persistent roadblock.
 */
- (void)removeAllPersistentRoadblocks;

/**
 * Get all persistent user roadblocks.
 */
- (nonnull NSArray < RouteTrafficEventObject *> *)getPersistentRoadblocks;

/**
 * Remove an user roadblock ( persistent or non-persistent ).
 */
- (void)removeUserRoadblock:(nonnull TrafficEventObject *)event;

/**
 * Start persistent roadblock notifications.
 */
- (void)startPersistentRoadblockNotification;

/**
 * Stop persistent roadblock notifications.
 */
- (void)stopPersistentRoadblockNotification;

/**
 * Set the traffic delay threshold in minutes.
 */
- (void)setTrafficDelayThreshold:(int)delay;

/**
 * Returns the traffic delay threshold in minutes.
 */
- (int)getTrafficDelayThreshold;

/**
 * Enable/disable traffic service.
 * @details Default it is disabled.
 */
- (void)setUseTraffic:(TrafficUsage)type;

/**
 * Get the use mode.
 */
- (TrafficUsage)getUseTraffic;

/**
 * Get the traffic color.
 */
- (nullable UIColor *)getTrafficColorForRoute:(nonnull RouteObject *)route;

/**
 * Get the traffic icon id.
 */
- (int)getTrafficIconIdForRoute:(nonnull RouteObject *)routeObject;

@end

NS_ASSUME_NONNULL_END
