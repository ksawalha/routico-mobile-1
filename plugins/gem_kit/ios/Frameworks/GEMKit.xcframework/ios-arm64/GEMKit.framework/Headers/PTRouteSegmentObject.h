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
#import <GEMKit/RouteSegmentObject.h>

/**
 * Constants indicating the transit type.
 */
typedef NS_ENUM(NSInteger, TransitType)
{
    /// Walk
    TransitTypeWalk,
    
    /// Bus
    TransitTypeBus,
    
    /// Underground
    TransitTypeUnderground,
    
    /// Railway
    TransitTypeRailway,
    
    /// Tram
    TransitTypeTram,
    
    /// Water transport
    TransitTypeWaterTransport,
    
    /// Other
    TransitTypeOther,
    
    /// Shared bike
    TransitTypeSharedBike,
    
    /// Shared scooter
    TransitTypeSharedScooter,
    
    /// Shared car
    TransitTypeSharedCar,
    
    /// Unknown
    TransitTypeUnknown
};

/**
 * Constants indicating the realtime status.
 */
typedef NS_ENUM(NSInteger, RealtimeStatus)
{
    /// Delayed
    RealtimeStatusDelay,
    
    /// On time
    RealtimeStatusOnTime,
    
    /// Not available
    RealtimeStatusNotAvailable
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates public transport route segment information.
 */
__attribute__((visibility("default"))) @interface PTRouteSegmentObject : RouteSegmentObject

/**
 * Returns the segment name.
 */
- (nonnull NSString *)getName;

/**
 * Returns the platform code.
 */
- (nonnull NSString *)getPlatformCode;

/**
 * Returns the arrival time.
 */
- (nullable TimeObject *)getArrivalTime;

/**
 * Returns the departure time.
 */
- (nullable TimeObject *)getDepartureTime;

/**
 * Returns true for wheelchair support.
 */
- (BOOL)getHasWheelchairSupport;

/**
 * Returns the segment short name.
 */
- (nonnull NSString *)getShortName;

/**
 * Returns the segment route url.
 */
- (nonnull NSString *)getRouteUrl;

/**
 * Returns the segment agency name.
 */
- (nonnull NSString *)getAgencyName;

/**
 * Returns the segment agency phone.
 */
- (nonnull NSString *)getAgencyPhone;

/**
 * Returns the segment agency url.
 */
- (nonnull NSString *)getAgencyUrl;

/**
 * Returns the segment agency fare url.
 */
- (nonnull NSString *)getAgencyFareUrl;

/**
 * Returns the segment line from.
 */
- (nonnull NSString *)getLineFrom;

/**
 * Returns the segment line towards.
 */
- (nonnull NSString *)getLineTowards;

/**
 * Returns the segment arrival delay in seconds.
 */
- (int)getArrivalDelayInSeconds;

/**
 * Returns the segment departure delay in seconds.
 */
- (int)getDepartureDelayInSeconds;

/**
 * Returns true for bicycle support.
 */
- (BOOL)getHasBicycleSupport;

/**
 * Returns true for stay on same transit.
 */
- (BOOL)getStayOnSameTransit;

/**
 * Returns the segment transit type.
 */
- (TransitType)getTransitType;

/**
 * Returns the segment realtime status.
 */
- (RealtimeStatus)getRealtimeStatus;

/**
 * Returns the segment line block id.
 */
- (int)getLineBlockID;

/**
 * Returns the segment line color.
 */
- (nonnull UIColor *)getLineColor;

/**
 * Returns the segment line text color.
 */
- (nonnull UIColor *)getLineTextColor;

/**
 * Returns the segment alerts count.
 */
- (int)getCountAlerts;

/**
 * Returns true if route segment is significant ( worth showing information about it ).
 */
- (BOOL)isSignificant;

/**
 * Returns the segment departure time formatted.
 */
- (nonnull NSString *)getDepartureTimeFormatted;

/**
 * Returns the segment departure time unit formatted.
 */
- (nonnull NSString *)getDepartureTimeUnitFormatted;

/**
 * Returns the segment arrival time formatted.
 */
- (nonnull NSString *)getArrivalTimeFormatted;

/**
 * Returns the segment arrival time unit formatted.
 */
- (nonnull NSString *)getArrivalTimeUnitFormatted;

@end

NS_ASSUME_NONNULL_END
