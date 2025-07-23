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
#import <GEMKit/SignpostDetailsObject.h>
#import <GEMKit/TimeDistanceObject.h>
#import <GEMKit/TurnDetailsObject.h>
#import <GEMKit/PositionObject.h>
#import <GEMKit/RoadInfoObject.h>
#import <GEMKit/PathObject.h>
#import <GEMKit/RouteInstructionObject.h>
#import <GEMKit/GenericHeader.h>

/**
 * Constants indicating the navigation states.
 */
typedef NS_ENUM(NSInteger, NavigationStatus)
{
    /// Running, this is the normal state.
    NavigationStatusRunning = 0,
    
    /// Waiting route.
    /// @details Check navigation route status for details about route update.
    NavigationStatusWaitingRoute,
    
    /// Paused, waiting for GPS location to recover.
    NavigationStatusWaitingGPS,
};

/**
 * Constants indicating the navigation instruction update events.
 */
typedef NS_ENUM(NSInteger, NavigationInstructionUpdateEvent)
{
    /// Next route turn updated.
    NavigationInstructionUpdateEventNextTurnUpdated = 1,
    
    /// Turn image updated.
    /// @details Even if the next turn doesn't updates the image may change  (e.g. intermediates left / right street count before turn ).
    NavigationInstructionUpdateEventNextTurnImageUpdated = 2,
    
    /// Lane info updated.
    NavigationInstructionUpdateEventLaneInfoUpdated = 4,
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates navigation instruction information.
 */
__attribute__((visibility("default"))) @interface NavigationInstructionObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns true if signpost information is available.
 */
- (BOOL)hasSignpostInfo;

/**
 * Returns the extended signpost details.
 */
- (nullable SignpostDetailsObject *)getSignpostDetails;

/**
 * Returns the textual description for the signpost information.
 */
- (nonnull NSString*)getSignpostInstruction;

/**
 * Returns the signpost image.
 * @param size The image size in pixels.
 * @param border The border size in pixels.
 * @param roundCorners Set true for rounded corners.
 * @param rows The maximum rows of details in the signpost.
 */
- (nullable UIImage*)getSignpostImage:(CGSize)size border:(NSInteger)border roundCorners:(BOOL)round rows:(NSInteger)rows;

/**
 * Returns the signpost image.
 * @param size The image size in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 * @param border The border size in pixels.
 * @param roundCorners Set true for rounded corners.
 * @param rows The maximum rows of details in the signpost.
 */
- (nullable UIImage*)getSignpostImage:(CGSize)size
                                scale:(CGFloat)scale
                                  ppi:(NSInteger)ppi
                               border:(NSInteger)border
                         roundCorners:(BOOL)round
                                 rows:(NSInteger)rows;

/**
 * Returns the distance to the next turn in meters, time in seconds.
 */
- (nullable TimeDistanceObject*)getTimeDistanceToNextTurn;

/**
 * Returns the remaining travel distance in meters and remaining traveling time in seconds.
 */
- (nullable TimeDistanceObject*)getRemainingTravelTimeDistance;

/**
 * Returns the remaining traveling time in seconds to the next way point and the remaining travel distance in meters to the next way point.
 */
- (nullable TimeDistanceObject*)getRemainingTravelTimeDistanceToNextWaypoint;

/**
 * Returns the traveled distance in meters and the traveled time in seconds.
 */
- (nullable TimeDistanceObject*)getTraveledTimeDistance;

/**
 * Returns the navigation/simulation status.
 */
- (NavigationStatus)getNavigationStatus;

/**
 * Returns the ISO 3166-1 alpha-3 country code for the current navigation instruction.
 * @details Empty string means no country.
 */
- (nonnull NSString*)getCurrentCountryCodeISO;

/**
 * Returns the maximum speed limit on the current street in meters per second.
 * @return 0 if maximum speed limit is not available.
 */
- (double)getCurrentStreetSpeedLimit;

/**
 * Returns the current street name.
 */
- (nonnull NSString*)getCurrentStreetName;

/**
 * Returns the current road information.
 */
- (nonnull NSArray <RoadInfoObject *> *)getCurrentRoadInformation;

/**
 * Returns true if current road info is available.
 */
- (BOOL)hasCurrentRoadInfo;

/**
 * Returns the current road code image.
 * @param size The image size in pixels.
 */
- (nullable UIImage*)getCurrentRoadCodeImage:(CGSize)size;

/**
 * Returns the current road code image(s).
 * @param size The image size in pixels.
 * @param limit The limit number of images. Use 0 to get all the available images.
 */
- (nullable UIImage*)getCurrentRoadCodeImage:(CGSize)size limit:(int)limit;

/**
 * Returns the current road code image.
 * @param size The image size in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 */
- (nullable UIImage*)getCurrentRoadCodeImage:(CGSize)size scale:(CGFloat)scale ppi:(NSInteger)ppi;

/**
 * Returns the current road code image(s).
 * @param size The image size in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 * @param limit The limit number of images. Use 0 to get all the available images.
 */
- (nullable UIImage*)getCurrentRoadCodeImage:(CGSize)size scale:(CGFloat)scale ppi:(NSInteger)ppi limit:(int)limit;

/**
 * Returns the ISO 3166-1 alpha-3 country code for the next navigation instruction.
 * @details Empty string means no country.
 */
- (nonnull NSString*)getNextCountryCodeISO;

/**
 * Returns the next street name.
 */
- (nonnull NSString*)getNextStreetName;

/**
 * Returns the next road information.
 */
- (nonnull NSArray <RoadInfoObject *> *)getNextRoadInformation;

/**
 * Returns true if next road info is available.
 */
- (BOOL)hasNextRoadInfo;

/**
 * Returns the next road code image.
 * @param size The image size.
 */
- (nullable UIImage*)getNextRoadCodeImage:(CGSize)size;

/**
 * Returns the next road code image(s).
 * @param size The image size.
 * @param limit The limit number of images. Use -1 to get all the available images.
 */
- (nullable UIImage*)getNextRoadCodeImage:(CGSize)size limit:(int)limit;

/**
 * Returns the next road code image.
 * @param height The image height in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 */
- (nullable UIImage*)getNextRoadCodeImage:(CGSize)size scale:(CGFloat)scale ppi:(NSInteger)ppi;

/**
 * Returns the next road code image(s).
 * @param height The image height in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 * @param limit The limit number of images. Use -1 to get all the available images.
 */
- (nullable UIImage*)getNextRoadCodeImage:(CGSize)size scale:(CGFloat)scale ppi:(NSInteger)ppi limit:(int)limit;

/**
 * Returns true if next turn information is available.
 */
- (BOOL)hasNextTurnInfo;

/**
 * Returns the schematic image of the next turn.
 * @param size The size of the image.
 */
- (nullable UIImage*)getNextTurnImage:(CGSize)size;

/**
 * Returns the schematic image of the next turn.
 * @param size The size of the image in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 */
- (nullable UIImage*)getNextTurnImage:(CGSize)size scale:(CGFloat)scale ppi:(NSInteger)ppi;

/**
 * Returns the schematic image of the next turn.
 * @param size The size in pixels.
 * @param colorActiveIn The inner active color.
 * @param colorActiveOut The outer active color.
 * @param colorInactiveIn The inner inactive color.
 * @param colorInactiveOut The outer inactive color.
 */
- (nullable UIImage*)getNextTurnImage:(CGSize)size
                     colorActiveInner:(nonnull UIColor*)colorActiveIn
                     colorActiveOuter:(nonnull UIColor*)colorActiveOut
                   colorInactiveInner:(nonnull UIColor*)colorInactiveIn
                   colorInactiveOuter:(nonnull UIColor*)colorInactiveOut;

/**
 * Returns the schematic image of the next turn.
 * @param size The size in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 * @param colorActiveIn The inner active color.
 * @param colorActiveOut The outer active color.
 * @param colorInactiveIn The inner inactive color.
 * @param colorInactiveOut The outer inactive color.
 */
- (nullable UIImage*)getNextTurnImage:(CGSize)size
                                scale:(CGFloat)scale
                                  ppi:(NSInteger)ppi
                     colorActiveInner:(nonnull UIColor*)colorActiveIn
                     colorActiveOuter:(nonnull UIColor*)colorActiveOut
                   colorInactiveInner:(nonnull UIColor*)colorInactiveIn
                   colorInactiveOuter:(nonnull UIColor*)colorInactiveOut;

/**
 * Returns the full details for the next turn.
 */
- (nullable TurnDetailsObject*)getNextTurnDetails;

/**
 * Returns the textual description for the next turn.
 */
- (nonnull NSString*)getNextTurnInstruction;

/**
 * Returns true if next next turn information is available.
 */
- (BOOL)hasNextNextTurnInfo;

/**
 * Returns the textual description for the next next turn.
 */
- (nonnull NSString*)getNextNextStreetName;

/**
 * Returns true if next next road info is available.
 */
- (BOOL)hasNextNextRoadInfo;

/**
 * Returns the next next road code image.
 * @param size The image size.
 */
- (nullable UIImage*)getNextNextRoadCodeImage:(CGSize)size;

/**
 * Returns the next next road code image(s).
 * @param limit The limit number of images. Use 0 to get all the available images.
 */
- (nullable UIImage*)getNextNextRoadCodeImage:(CGSize)size limit:(int)limit;

/**
 * Returns the next next road code image.
 * @param height The image height in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 */
- (nullable UIImage*)getNextNextRoadCodeImage:(CGSize)size scale:(CGFloat)scale ppi:(NSInteger)ppi;

/**
 * Returns the next next road code image(s).
 * @param height The image height in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 * @param limit The limit number of images. Use 0 to get all the available images.
 */
- (nullable UIImage*)getNextNextRoadCodeImage:(CGSize)size scale:(CGFloat)scale ppi:(NSInteger)ppi limit:(int)limit;

/**
 * Returns the next next road information.
 */
- (nonnull NSArray <RoadInfoObject *> *)getNextNextRoadInformation;

/**
 * Returns the schematic image of the next next turn.
 * @param size The size of the image.
 */
- (nullable UIImage*)getNextNextTurnImage:(CGSize)size;

/**
 * Returns the schematic image of the next next turn.
 * @param size The size in pixels.
 * @param colorActiveIn The inner active color.
 * @param colorActiveOut The outer active color.
 * @param colorInactiveIn The inner inactive color.
 * @param colorInactiveOut The outer inactive color.
 */
- (nullable UIImage*)getNextNextTurnImage:(CGSize)size
                         colorActiveInner:(nonnull UIColor*)colorActiveIn
                         colorActiveOuter:(nonnull UIColor*)colorActiveOut
                       colorInactiveInner:(nonnull UIColor*)colorInactiveIn
                       colorInactiveOuter:(nonnull UIColor*)colorInactiveOut;

/**
 * Returns the schematic image of the next next turn.
 * @param size The size in pixels.
 * @param scale The screen scale.
 * @param ppi The screen pixel per inch.
 * @param colorActiveIn The inner active color.
 * @param colorActiveOut The outer active color.
 * @param colorInactiveIn The inner inactive color.
 * @param colorInactiveOut The outer inactive color.
 */
- (nullable UIImage*)getNextNextTurnImage:(CGSize)size
                                    scale:(CGFloat)scale
                                      ppi:(NSInteger)ppi
                         colorActiveInner:(nonnull UIColor*)colorActiveIn
                         colorActiveOuter:(nonnull UIColor*)colorActiveOut
                       colorInactiveInner:(nonnull UIColor*)colorInactiveIn
                       colorInactiveOuter:(nonnull UIColor*)colorInactiveOut;

/**
 * Returns the textual description for the next next turn.
 */
- (nonnull NSString*)getNextNextTurnInstruction;

/**
 * Returns the full details for the next-next turn.
 */
- (nullable TurnDetailsObject*)getNextNextTurnDetails;

/**
 * Returns the full details for the next-next turn.
 */
- (nullable TimeDistanceObject*)getTimeDistanceToNextNextTurn;

/**
 * Returns true if lane information is available.
 */
- (BOOL)hasLaneInfo;

/**
 * Returns the image representation of current lane configuration.
 * @param size The size in pixels.
 * @param backgroundColor The background color.
 * @param activeColor The active color.
 * @param inactiveColor The inactive color.
 */
- (nullable UIImage*)getLaneImage:(CGSize)size
                  backgroundColor:(nonnull UIColor *)backgroundColor
                      activeColor:(nonnull UIColor *)activeColor
                    inactiveColor:(nonnull UIColor *)inactiveColor;

/**
 * Returns the image representation of current lane configuration.
 * @param size The size in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 * @param backgroundColor The background color.
 * @param activeColor The active color.
 * @param inactiveColor The inactive color.
 */
- (nullable UIImage*)getLaneImage:(CGSize)size
                            scale:(CGFloat)scale
                              ppi:(NSInteger)ppi
                  backgroundColor:(nonnull UIColor *)backgroundColor
                      activeColor:(nonnull UIColor *)activeColor
                    inactiveColor:(nonnull UIColor *)inactiveColor;

/**
 * Returns the current position.
 */
- (nullable PositionObject*)getCurrentPosition;

/**
 * Returns the index of the current route segment.
 */
- (int)getSegmentIndex;

/**
 * Returns the index of the current route instruction on the current route.
 */
- (int)getInstructionIndex;

/**
 * Get the next route instruction on the route.
 */
- (nullable RouteInstructionObject *)getNextInstruction;

/**
 * Get the next-next route instruction on the route.
 */
- (nullable RouteInstructionObject *)getNextNextInstruction;

/**
 * Returns the drive side flag of the current traveled road.
 */
- (DriveSideType)getDriveSide;

/**
 * Get battery current SoC.
 * @details SoC is in the interval from 0.f ( empty battery ) to 1.f ( fully charged )
 * @details This will provide the estimated battery SoC for navigation on routes calculated with MotorVehicleProfile fuel electric.
 */
- (float)getBatterySoC;

/**
 * Export navigation instruction.
 * @param format Data format, see PathFileFormat.
 * @param compressed Compression flag.
 * @details Only PathFileFormatPackedGeometry is available at this time.
 */
- (nullable NSData *)exportAs:(PathFileFormat)format withCompresion:(BOOL)compressed;

/**
 * Returns the textual description for the next turn formatted.
 */
- (nonnull NSString*)getNextTurnInstructionFormatted;

/**
 * Returns the total distance description for the next turn formatted.
 */
- (nonnull NSString*)getDistanceToNextTurnFormatted;

/**
 * Returns the total distance unit description for the next turn formatted.
 */
- (nonnull NSString*)getDistanceToNextTurnUnitFormatted;

/**
 * Returns the textual description for the next next turn formatted.
 */
- (nonnull NSString*)getNextNextTurnInstructionFormatted;

/**
 * Returns the total distance description for the next next turn formatted.
 */
- (nonnull NSString*)getDistanceToNextNextTurnFormatted;

/**
 * Returns the total distance unit description for the next next turn formatted.
 */
- (nonnull NSString*)getDistanceToNextNextTurnUnitFormatted;

/**
 * Returns the maximum speed limit on the current street formatted.
 */
- (nonnull NSString*)getCurrentStreetSpeedLimitFormatted;

@end

NS_ASSUME_NONNULL_END
