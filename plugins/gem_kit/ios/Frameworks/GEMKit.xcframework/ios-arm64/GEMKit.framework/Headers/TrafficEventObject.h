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
#import <GEMKit/RectangleGeographicAreaObject.h>
#import <GEMKit/TimeObject.h>

/**
 * Constants indicating the traffic event class.
 */
typedef NS_ENUM(NSInteger, TrafficEventClass)
{
    TrafficEventClassBase = 0,                        ///< -
    
    TrafficEventClassOther = TrafficEventClassBase,   ///< 00 - 001 - info
    TrafficEventClassLevelOfService,                  ///< 01 - 100 - congestion
    TrafficEventClassExpectedLevelOfService,          ///< 02 - 101 - attention
    TrafficEventClassAccidents,                       ///< 03 - 102 - accident
    TrafficEventClassIncidents,                       ///< 04 - 103 - accident
    TrafficEventClassClosuresAndLaneRestrictions,     ///< 05 - 104 - no entry
    TrafficEventClassCarriagewayRestrictions,         ///< 06 - 105 - no entry
    TrafficEventClassExitRestrictions,                ///< 07 - 106
    TrafficEventClassEntryRestrictions,               ///< 08 - 107
    TrafficEventClassTrafficRestrictions,             ///< 09 - 108
    TrafficEventClassCarpoolInfo,                     ///< 10 - 001 - info
    TrafficEventClassRoadworks,                       ///< 11 - 110
    TrafficEventClassObstructionHazards,              ///< 12 - 111
    TrafficEventClassDangerousSituations,             ///< 13 - 112
    TrafficEventClassRoadConditions,                  ///< 14 - 113 - slippery road
    TrafficEventClassTemperatures,                    ///< 15 - 114
    TrafficEventClassPrecipitationAndVisibility,      ///< 16 - 115 - mandatory
    TrafficEventClassWindAndAirQuality,               ///< 17 - 116
    TrafficEventClassActivities,                      ///< 18 - 117
    TrafficEventClassSecurityAlerts,                  ///< 19 - 118
    TrafficEventClassDelays,                          ///< 20 - 001 - info
    TrafficEventClassCancellations,                   ///< 21 - 120 - restrictions removal
    TrafficEventClassTravelTimeInfo,                  ///< 22 - 121 - warning
    TrafficEventClassDangerousVehicles,               ///< 23 - 122
    TrafficEventClassExceptionalLoadsOrVehicles,      ///< 24 - 123
    TrafficEventClassTrafficEquipmentStatus,          ///< 25 - 124
    TrafficEventClassSizeAndWeightLimits,             ///< 26 - 125 - circulation closed
    TrafficEventClassParkingRestrictions,             ///< 27 - 126
    TrafficEventClassParking,                         ///< 28 - 127
    TrafficEventClassReferenceToAudioBroadcast,       ///< 29 - 001 - info
    TrafficEventClassServiceMessages,                 ///< 30 - 001 - info
    TrafficEventClassSpecialMessages,                 ///< 31 - 001 - info
    
    TrafficEventClassUserEventsBase = 100,                           ///< 100 - * - user events above this value
    TrafficEventClassUserRoadblock = TrafficEventClassUserEventsBase ///< User-defined roadblock.
};

/**
 * Constants indicating the traffic event severity.
 */
typedef NS_ENUM(NSInteger, TrafficEventSeverity)
{
    /// Stationary.
    TrafficEventSeverityStationary = 0,
    
    /// Queuing.
    TrafficEventSeverityQueuing,
    
    /// Slow traffic.
    TrafficEventSeveritySlowTraffic,
    
    /// Possible delay.
    TrafficEventSeverityPossibleDelay,
    
    /// Unknown.
    TrafficEventSeverityUnknown
};

/**
 * Constants indicating the traffic event shape.
 */
typedef NS_ENUM(NSInteger, TrafficEventImpactZone)
{
    /// Path as a collection of roads impact zone.
    TrafficEventImpactZonePath = 0,
    
    /// Geographic area impact zone.
    TrafficEventImpactZoneArea,
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class handles the traffic event.
 */
__attribute__((visibility("default"))) @interface TrafficEventObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Check if this traffic event is a roadblock.
 */
- (BOOL)isRoadblock;

/**
 * Get the estimated delay in seconds caused by the traffic event.
 * @details For roadblocks it will return -1.
 */
- (int)getDelay;

/**
 * Get the length in meters of the road segment affected by the traffic event.
 */
- (int)getLength;

/**
 * Get the traffic event impact zone.
 */
- (TrafficEventImpactZone)getImpactZone;

/**
 * Get the traffic event reference point.
 * @details If the traffic event doesn't have a reference point the CoordinatesObject::isValid() will return false.
 */
- (nullable CoordinatesObject *)getReferencePoint;

/**
 * Get the bounding box of the traffic event.
 */
- (nullable RectangleGeographicAreaObject *)getBoundingBox;

/**
 * Get the area of the traffic event.
 */
- (nullable GeographicAreaObject *)getArea;

/**
 * Get the description of the traffic event.
 */
- (nonnull NSString*)getDescription;

/**
 * Returns the traffic event class.
 */
- (TrafficEventClass)getEventClass;

/**
 * Returns the traffic event severity.
 */
- (TrafficEventSeverity)getEventSeverity;

/**
 * Returns the image of the traffic event.
 * @param size The size of the image.
 */
- (nullable UIImage*)getImage:(CGSize)size;

/**
 * Returns the image of the traffic event.
 * @param height The image size in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 */
- (nullable UIImage*)getImage:(CGSize)size scale:(CGFloat)scale ppi:(NSInteger)ppi;

/**
 * Returns the traffic event preview URL.
 */
- (nullable NSURL*)getPreviewURL;

/**
 * Returns true if the traffic event is a user roadblock.
 */
- (BOOL)isUserRoadblock;

/**
 * Returns the affected transport modes
 */
- (int)getAffectedTransportMode;

/**
 * Returns the start time ( UTC )
 */
- (nullable TimeObject*)getStartTime;

/**
 * Returns the end time ( UTC )
 */
- (nullable TimeObject*)getEndTime;

/**
 * Check if traffic event is expired ( i.e. is ended ).
 */
- (BOOL)isActive;

/**
 * Check if traffic event is expired ( i.e. is ended ).
 */
- (BOOL)isExpired;

/**
 * Returns true if event has a sibling on opposite direction.
 */
- (BOOL)hasOppositeSibling;

@end

NS_ASSUME_NONNULL_END
