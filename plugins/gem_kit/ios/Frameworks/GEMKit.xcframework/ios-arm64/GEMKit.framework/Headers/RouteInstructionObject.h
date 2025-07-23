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
#import <GEMKit/SignpostDetailsObject.h>
#import <GEMKit/TimeDistanceObject.h>
#import <GEMKit/TurnDetailsObject.h>
#import <GEMKit/RoadInfoObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates route instruction information.
 */

__attribute__((visibility("default"))) @interface RouteInstructionObject : NSObject

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
 * Returns extended signpost details.
 */
- (nullable SignpostDetailsObject *)getSignpostDetails;

/**
 * Returns the textual description for the signpost information.
 */
- (nonnull NSString *)getSignpostInstruction;

/**
 * Returns the distance to the next turn in meters, time in seconds.
 */
- (nullable TimeDistanceObject *)getTimeDistanceToNextTurn;

/**
 * Returns the remaining travel distance in meters and remaining traveling time in seconds.
 */
- (nullable TimeDistanceObject *)getRemainingTravelTimeDistance;

/**
 * Returns the remaining traveling time in seconds to the next way point.
 */
- (nullable TimeDistanceObject *)getRemainingTravelTimeDistanceToNextWaypoint;

/**
 * Returns the traveled distance in meters and the traveled time in seconds.
 */
- (nullable TimeDistanceObject *)getTraveledTimeDistance;

/**
 * Returns the ISO 3166-1 alpha-3 country code for the navigation instruction.
 * @details Empty string means no country. See: http://en.wikipedia.org/wiki/ISO_3166-1 for the list of codes.
 */
- (nonnull NSString *)getCountryCodeISO;

/**
 * Returns true if turn information is available.
 */
- (BOOL)hasTurnInfo;

/**
 * Returns the image for the turn.
 * @param size The image size.
 */
- (nullable UIImage *)getTurnImage:(CGSize)size;

/**
 * Returns the full details for the turn.
 */
- (nullable TurnDetailsObject *)getTurnDetails;

/**
 * Returns the textual description for the turn.
 */
- (nonnull NSString *)getTurnInstruction;

/**
 * Returns true if follow road information is available.
 */
- (BOOL)hasFollowRoadInfo;

/**
 * Returns the textual description for the follow road information.
 */
- (nonnull NSString *)getFollowRoadInstruction;

/**
 * Get if road information is available.
 */
- (BOOL)hasRoadInfo;

/**
 * Get road information.
 * @details The road info list is in ascending priority order.
 */
- (nonnull NSArray <RoadInfoObject *> *)getRoadInfo;

/**
 * Get road info image.
 * @param size The image size in pixels.
 */
- (nullable UIImage*)getRoadInfoImage:(CGSize)size;

/**
 * Get road info image.
 * @param size The image size in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 */
- (nullable UIImage*)getRoadInfoImage:(CGSize)size scale:(CGFloat)scale ppi:(NSInteger)ppi;

/**
 * Returns the coordinates for this route instruction.
 */
- (nonnull CoordinatesObject*)getCoordinates;

/**
 * Returns true if the route instruction is a main road exit instruction.
 */
- (BOOL)isExit;

/**
 * Returns the exit route instruction text.
 * @details If the instruction is not an exit, returns empty string.
 */
- (nonnull NSString *)getExitDetails;

/**
 * Returns true if the route instruction is a ferry.
 */
- (BOOL)isFerry;

/**
 * Returns true if the route instruction is a toll road.
 */
- (BOOL)isTollRoad;

/**
 * Check if this instruction is of common type.
 *  @details Common type route instruction is part of a common type route segment, see RouteSegmentObject::isCommon.
 */
- (BOOL)isCommon;

/**
 * Check if this instruction is part of an EV route.
 */
- (BOOL)isEV;

@end

NS_ASSUME_NONNULL_END
