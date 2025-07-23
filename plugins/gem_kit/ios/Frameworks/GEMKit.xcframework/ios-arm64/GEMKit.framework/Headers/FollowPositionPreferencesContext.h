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
#import <GEMKit/MapViewHeader.h>
#import <GEMKit/GenericHeader.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * An object that manages map view follow position preferences.
 */
__attribute__((visibility("default"))) @interface FollowPositionPreferencesContext : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Set the time interval before starting a turn presentation.
 * @param value The time interval in seconds. -1 means using SDK default value.
 */
- (void)setTimeBeforeTurnPresentation:(int)value;

/**
 * Get the time interval before starting a turn presentation.
 * @return The time interval in seconds.
 */
- (int)getTimeBeforeTurnPresentation;

/**
 * Sets the follow position camera focus in viewport coordinates ( between 0.f = left / top and 1.f = right / bottom ).
 */
- (void)setCameraFocus:(CGPoint)point;

/**
 * Gets the follow position camera focus in viewport coordinates ( between 0.f = left / top and 1.f = right / bottom ).
 */
- (CGPoint)getCameraFocus;

/**
 * Sets manually changes ( via touch handler ) persistent from one follow position session to another.
 * @details Default value is false.
 */
- (void)setTouchHandlerModifyPersistent:(BOOL)persistent;

/**
 * Gets if manually changes ( via touch handler ) are persistent.
 */
- (BOOL)getTouchHandlerModifyPersistent;

/**
 * Sets allows manually exiting follow position via touch handler events. Default value is true.
 */
- (void)setTouchHandlerExitAllow:(BOOL)allowExit;

/**
 * Gets state for allows manually exiting follow position via touch handler events.
 */
- (BOOL)getTouchHandlerExitAllow;

/**
 * Set touch handler horizontal angle adjust limits.
 * @param horizAngleLimits . Values must be in { -180., 180. } range
 * @details Empty { 0., 0. } interval can be provided to forbid manually adjusting horizontal angle. Default values are { 0., 0. }
 */
- (void)setTouchHandlerModifyHorizontalAngleLimits:(nonnull NSArray <NSNumber *> *)horizAngleLimits;

/**
 * Get touch handler horizontal angle adjust limits. Empty { 0., 0. } means value adjustment is forbidden.
 * @details Default returns { 0., 0. }, meaning adjustment is forbidden.
 */
- (nonnull NSArray <NSNumber *> *)getTouchHandlerModifyHorizontalAngleLimits;

/**
 * Set touch handler vertical angle adjust limits
 * @param vertAngleLimits Vertical angle adjust limits. Values must be in { 0., 90. } range
 * @details Empty { 0., 0. } interval can be provided to forbid manually adjusting vertical angle. Default values are { 0., 70. }
 */
- (void)setTouchHandlerModifyVerticalAngleLimits:(nonnull NSArray <NSNumber *> *)horizAngleLimits;

/**
 * Get touch handler vertical angle adjust limits. Empty { 0., 0. } means value adjustment is forbidden.
 * @details Default returns { 0., 70. }
 */
- (nonnull NSArray <NSNumber *> *)getTouchHandlerModifyVerticalAngleLimits;

/**
 * Set touch handler distance to object adjust limits.
 * @param distanceLimits Values must be in { 0, std::numeric_limits<double>::max() } range.
 * @details Empty { 0., 0. } interval can be provided to forbid manually adjusting distance to object. Default values are { 50, std::numeric_limits<double>::max() }
 */
- (void)setTouchHandlerModifyDistanceLimits:(nonnull NSArray <NSNumber *> *)horizAngleLimits;

/**
 * Get touch handler distance to object adjust limits.
 * @details Default returns { 50, std::numeric_limits<double>::max() }, meaning no limits in max distance to tracked object.
 */
- (nonnull NSArray <NSNumber *> *)getTouchHandlerModifyDistanceLimits;

/**
 * Set the map view perspective in follow position mode.
 * @param perspective The map perspective.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)setPerspective:(MapViewPerspective)perspective animationDuration:(NSTimeInterval)duration completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Gets the map view perspective in follow position mode.
 */
- (MapViewPerspective)getPerspective;

/**
 * Set vertical angle in follow position mode.
 */
- (void)setViewAngle:(double)value;

/**
 * Gets the vertical angle.
 */
- (double)getViewAngle;

/**
 * Set a zoom level in follow position mode.
 * @param level Zoom level, may be between 0 and getMaxZoomLevel.
 * @param duration The animation duration in milliseconds (0 means no animation ).
 * @return The previous zoom level.
 */
- (int)setZoomLevel:(int)level animationDuration:(NSTimeInterval)duration;

/**
 * Get zoom level in follow position mode.
 * @details -1 means auto-zooming is enabled
 * @return The current zoom level.
 */
- (int)getZoomLevel;

/**
 * Set map rotation mode in follow position.
 * @param mode Map rotation mode.
 * @param angle The fixed rotation angle for FollowPositionMapRotationModeFixed.
 * @param followMap The position tracker object orientation will follow map view rotation.
 * @details If the position tracker object orientation will follow map view rotation, all views using the same tracking object will see the object update.
 */
- (void)setMapRotationMode:(FollowPositionMapRotationMode)mode angle:(double)angle objectFollowMap:(BOOL)followMap;

/**
 * Get map rotation mode in follow position.
 */
- (FollowPositionMapRotationMode)getMapRotationMode;

/**
 * Check if position tracking object rotation follows map rotation.
 */
- (BOOL)isTrackObjectFollowingMapRotation;

/**
 * Set accuracy circle visibility.
 */
- (void)setAccuracyCircleVisibility:(BOOL)value;

/**
 * Check if accuracy circle is visible.
 */
- (BOOL)isAccuracyCircleVisible;

@end

NS_ASSUME_NONNULL_END
