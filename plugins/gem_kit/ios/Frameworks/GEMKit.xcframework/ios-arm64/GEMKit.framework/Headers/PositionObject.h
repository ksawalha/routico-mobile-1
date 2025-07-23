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
#import <GEMKit/DataSourceHeader.h>
#import <GEMKit/LandmarkObject.h>
#import <GEMKit/RoadInfoObject.h>
#import <GEMKit/DataObject.h>

/**
 * Constants indicating the position provider.
 * @details
 */
typedef NS_ENUM(NSInteger, PositionProvider)
{
    /// Unknown.
    PositionProviderUnknown,
    
    /// GPS.
    PositionProviderGPS,
    
    /// Network.
    PositionProviderNetwork,
    
    /// Position improved with inertial sensors.
    PositionProviderSensorFusion,
    
    /// Map-matched position.
    PositionProviderMapMatching,
    
    /// Position coming from simulation.
    PositionProviderSimulation
};

/**
 * Constants indicating the position data quality.
 * @details
 */
typedef NS_ENUM(NSInteger, PositionFixQuality)
{
    /// Invalid.
    /// @details Invalid means the position can not or should not be processed (for instance, invalid coordinates).
    PositionFixQualityInvalid,
    
    /// Invalid.
    /// @details Inertial means position has resulted from inertial extrapolation; there is a GPS outage (e.g. tunnel).
    PositionFixQualityInertial,
    
    /// Low.
    /// @details Low means the position is valid but cannot be trusted because of an outage (e.g. tunnel) or very bad accuracy (e.g. urban canyon)
    PositionFixQualityLow,
    
    /// High.
    /// @details High means the position is valid and can be trusted (is recent and has a good accuracy)
    PositionFixQualityHigh,
};

/**
 * Constants indicating the road modifier types.
 * @details
 */
typedef NS_ENUM(NSInteger, RoadModifier)
{
    /// None
    RoadModifierNone = 0,
    
    /// Tunnel
    RoadModifierTunnel = 0x1,
    
    /// Bridge
    RoadModifierBridge = 0x2,
    
    /// Ramp
    RoadModifierRamp = 0x4,
    
    /// Tollway
    RoadModifierTollway = 0x8,
    
    /// Roundabout
    RoadModifierRoundabout = 0x10,
    
    /// OneWay
    RoadModifierOneWay = 0x20,
    
    /// NoUTurn
    RoadModifierNoUTurn = 0x40,
    
    /// LeftDriveSide
    RoadModifierLeftDriveSide = 0x80,
    
    /// Motorway
    RoadModifierMotorway = 0x100,
    
    /// MotorwayLink
    RoadModifierMotorwayLink = 0x200
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates position information.
 */
__attribute__((visibility("default"))) @interface PositionObject : NSObject

/**
 * New position object.
 * @param timestamp The acquisition timestamp.
 * @param latitude The latitude in degrees.
 * @param longitude The longitude in degrees.
 * @param altitude The altitude in meters.
 * @param course The course in degrees.
 * @param speed The speed in mps.
 * @param speedAccuracy The speed accuracy in mps.
 * @param horizontalAccuracy The horizontal accuracy in meters.
 * @param verticalAccuracy The vertical accuracy in meters.
 * @param courseAccuracy The course accuracy in meters.
 */
+ (nullable PositionObject *)createPosition:(NSInteger)timestamp
                                  latitude:(double)latitude longitude:(double)longitude altitude:(double)altitude
                                    course:(double)course
                                     speed:(double)speed
                             speedAccuracy:(double)speedAccuracy
                        horizontalAccuracy:(double)horizontalAccuracy
                          verticalAccuracy:(double)verticalAccuracy
                            courseAccuracy:(double)courseAccuracy;

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Initializes and returns a newly allocated object using the data object.
 */
- (instancetype)initWithDataObject:(nonnull DataObject *)data;

/**
 * Returns the model data object.
 */
- (nullable DataObject*)getDataObject;

/**
 * Satellite timestamp, milliseconds since 1970.
 * @details Timestamps are expected to increase monotonously for subsequent positions; data with timestamp from the past will be discarded.
 * @return The satellite time in milliseconds.
 */
- (NSInteger)getSatelliteTime;

/**
 * Returns the provider type.
 */
- (PositionProvider)getProvider;

/**
 * Geographical latitude.
 * @details From -90 to +90; positive on northern hemisphere.
 * @details If value is out of the -90...90 range, the position is considered invalid.
 * @return The latitude in degrees.
 */
- (double)getLatitude;

/**
 * Geographical longitude.
 * @details From -180 to +180; positive on eastern hemisphere.
 * @details If value is out of the -180...180 range, the position is considered invalid.
 * @return The longitude in degrees.
 */
- (double)getLongitude;

/**
 * Latitude and longitude.
 * @details If both values are equal to 0, the position is considered invalid.
 * @return Coordinate pair, each one in degrees.
 */
- (nonnull CoordinatesObject*)getCoordinates;

/**
 * Altitude above main sea level.
 * @return The altitude in meters.
 */
- (double)getAltitude;

/**
 * Travel speed.
 * @details Valid speed information should always be non-negative.
 * @details A negative value (-1 by default) means the position has no speed information.
 * @details If car is going backwards, the course should change by 180, but the speed should still be non-negative.
 * @return The speed, in m/s.
 */
- (double)getSpeed;

/**
 * Travel speed accuracy.
 * @details Typical accuracy for consumer GPS is 2 m/s at steady speed and high position accuracy.
 * @details Valid speed accuracy should always be positive.
 * @return The speed accuracy in m/s.
 */
- (double)getSpeedAccuracy;

/**
 * The course of the movement.
 * @details Represents true heading, not magnetic heading.
 * @details 0 means true north, 90 east, 180 south, 270 west.
 * @details A negative value (-1 by default) means the position has no course information.
 * @return The course in degrees.
 */
- (double)getCourse;

/**
 * Course accuracy.
 * @details Typical accuracy for consumer GPS is 25 degrees at high speeds.
 * @details Valid course accuracy should always be positive.
 * @return The course accuracy in degrees.
 */
- (double)getCourseAccuracy;

/**
 * Horizontal accuracy of position.
 * @details Typical accuracy for consumer GPS is 5-20 meters.
 * @details Valid position accuracy should always be positive.
 * @return The horizontal position accuracy in meters.
 */
- (double)getHorizontalAccuracy;

/**
 * Vertical accuracy of position.
 * @details Valid position accuracy should always be positive.
 * @return The vertical position accuracy in meters.
 */
- (double)getVerticalAccuracy;

/**
 * Fix quality (whether this position is trustworthy).
 * @return The fix quality.
 */
- (PositionFixQuality)getFixQuality;

/**
 * Returns true if position is valid.
 */
- (BOOL)isValid;

/**
 * Query if this object has valid coordinates.
 * @return True if latitude and longitude are available and valid, false if not.
 */
- (BOOL)hasCoordinates;

/**
 * Query if this object has altitude.
 * @return True if altitude is available and valid, false if not.
 */
- (BOOL)hasAltitude;

/**
 * Query if this object has speed.
 * @return True if speed is available and valid, false if not.
 */
- (BOOL)hasSpeed;

/**
 * Query if this object has speed accuracy.
 * @return True if speed accuracy is available and valid, false if not.
 */
- (BOOL)hasSpeedAccuracy;

/**
 * Query if this object has course.
 * @return True if course is available and valid, false if not.
 */
- (BOOL)hasCourse;

/**
 * Query if this object has course accuracy.
 * @return True if course accuracy is available and valid, false if not.
 */
- (BOOL)hasCourseAccuracy;

/**
 * Query if this object has horizontal accuracy.
 * @return True if horizontal accuracy is available and valid, false if not.
 */
- (BOOL)hasHorizontalAccuracy;

/**
 * Query if this object has vertical accuracy.
 * @return True if vertical accuracy is available and valid, false if not.
 */
- (BOOL)hasVerticalAccuracy;

/**
 * Get data type.
 */
- (DataType)getType;

/**
 * Check if improved position has a road localization.
 */
- (BOOL)hasRoadLocalization;

/**
 * Get position road address info.
 */
- (nonnull NSString*)getRoadAddressFieldNameWithType:(AddressSearchFieldType)type;

/**
 * Get position road modifiers as an integer of packed RoadModifier flags.
 */
- (int)getRoadModifier;

/**
 * Get position road speed limit in m/s.
 * @details If speed limit doesn't exist in map data, 0 is returned.
 */
- (double)getRoadSpeedLimit;

/**
 * Get position road info details.
 * @details The road info list is in ascending priority order.
 */
- (nonnull NSArray <RoadInfoObject *> *)getRoadInfo;

/**
 * Get road info image.
 * @param size The image size in pixels.
 */
- (nullable UIImage*)getRoadCodeImage:(CGSize)size;

/**
 * Get road info image.
 * @param size The image size in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 */
- (nullable UIImage*)getRoadCodeImage:(CGSize)size scale:(CGFloat)scale ppi:(NSInteger)ppi;

/**
 * Check if position has terrain data.
 */
- (BOOL)hasTerrainData;

/**
 * Returns the terrain altitude.
 * @details This a map data based value comparing to getAltitude which is GPS sensor data.
 */
- (double)getTerrainAltitude;

/**
 * Returns the terrain slope.
 * @details The current slope in degrees, positive value for ascent, negative for descent.
 */
- (double)getTerrainSlope;

/**
 * Returns the travel speed formatted string.
 */
- (nonnull NSString *)getFormattedSpeed;

/**
 * Returns the travel speed unit formatted string.
 */
- (nonnull NSString *)getFormattedSpeedUnit;

@end

NS_ASSUME_NONNULL_END
