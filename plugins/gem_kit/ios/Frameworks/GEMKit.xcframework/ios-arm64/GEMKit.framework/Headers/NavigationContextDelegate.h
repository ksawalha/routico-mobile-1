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
#import <GEMKIt/NavigationInstructionObject.h>
#import <GEMKit/SoundObject.h>

@class NavigationContext;

NS_ASSUME_NONNULL_BEGIN

/**
 * A set of delegate methods for navigation context objects.
 */
__attribute__((visibility("default"))) @protocol NavigationContextDelegate <NSObject>

@optional

/**
 * Notifies the delegate with the new navigation status.
 * @param navigationContext The navigation context informing the delegate of this event.
 * @param route The main route.
 * @param status The navigation status.
 */
- (void)navigationContext:(nonnull NavigationContext *)navigationContext route:(nonnull RouteObject *)route navigationStatusChanged:(NavigationStatus)status;

/**
 * Notifies the delegate that the navigation started.
 * @param navigationContext The navigation context informing the delegate of this event.
 * @param route The main route.
 */
- (void)navigationContext:(nonnull NavigationContext *)navigationContext navigationStartedForRoute:(nonnull RouteObject *)route;

/**
 * Notifies the delegate that the navigation instruction is updated.
 * @param navigationContext The navigation context informing the delegate of this event.
 * @param route The main route.
 * @param updatedEvents The turn update events. Please see NavigationInstructionUpdateEvent.
 */
- (void)navigationContext:(nonnull NavigationContext *)navigationContext navigationInstructionUpdatedForRoute:(nonnull RouteObject *)route updatedEvents:(int)events;

/**
 * Notifies the delegate that the navigation route was updated.
 * @param navigationContext The navigation context informing the delegate of this event.
 * @param route The main route.
 */
- (void)navigationContext:(nonnull NavigationContext *)navigationContext navigationRouteUpdated:(nonnull RouteObject*)route;

/**
 * Notifies the delegate when a way point on the route has been reached.
 * @param navigationContext The navigation context informing the delegate of this event.
 * @param route The main route.
 * @param waypoint The way point reached.
 */
- (void)navigationContext:(nonnull NavigationContext *)navigationContext route:(nonnull RouteObject *)route navigationWaypointReached:(nonnull LandmarkObject*)waypoint;

/**
 * Notifies the delegate when the destination have been reached.
 * @param navigationContext The navigation context informing the delegate of this event.
 * @param route The main route.
 * @param waypoint The way point from destination.
 */
- (void)navigationContext:(nonnull NavigationContext *)navigationContext route:(nonnull RouteObject *)route navigationDestinationReached:(nonnull LandmarkObject*)waypoint;

/**
 * Notifies the delegate that the navigation request finished with error.
 * @param navigationContext The navigation context informing the delegate of this event.
 * @param route The main route.
 * @param code The error code.
 */
- (void)navigationContext:(nonnull NavigationContext *)navigationContext route:(nonnull RouteObject *)route navigationError:(NSInteger)code;

/**
 * Returns true if it is allowed to send a 'navigationSound' notification or not.
 * @param navigationContext The navigation context informing the delegate of this event.
 * @param route The main route.
 */
- (BOOL)navigationContext:(nonnull NavigationContext *)navigationContext canPlayNavigationSoundForRoute:(nonnull RouteObject *)route;

/**
 * Notifies the delegate when a sound needs to be played.
 * @param navigationContext The navigation context informing the delegate of this event.
 * @param route The main route.
 * @param sound The sound object.
 */
- (void)navigationContext:(nonnull NavigationContext *)navigationContext route:(nonnull RouteObject *)route navigationSound:(nonnull SoundObject *)sound;

/**
 * Notifies the delegate when a better route was detected. The previous better route ( if exist ) must be considered automatically invalidated.
 * @param navigationContext The navigation context informing the delegate of this event.
 * @param route The better route object.
 * @param travelTime The better route travel time in seconds.
 * @param delay The better route delay in seconds.
 * @param timeGain The time gain from existing route in seconds. -1 means original route has roadblocks and time gain cannot be calculated.
 * @details This notification is sent when a route is calculated with "avoid traffic" flag set to "true" ( setAvoidTraffic(true) ) and the engine detects a better route.
 */
- (void)navigationContext:(nonnull NavigationContext *)navigationContext onBetterRouteDetected:(nonnull RouteObject *)route travelTime:(NSInteger)travelTime delay:(NSInteger)delay timeGain:(NSInteger)timeGain;

/**
 * Notifies the delegate that the previously detected better route became invalid. This notification is sent when current position is no more on the previous calculated better route.
 * @param navigationContext The navigation context informing the delegate of this event.
 * @param state The invalidation state.
 */
- (void)navigationContext:(nonnull NavigationContext *)navigationContext onBetterRouteInvalidated:(BOOL)state;

/**
 * Next intermediate destination skip intention detected.
 * @param navigationContext The navigation context informing the delegate of this event.
 * @param state The detected state.
 * @details This notification is sent the navigation engine detects user intention to skip the next intermediate destination
 */
- (void)navigationContext:(nonnull NavigationContext *)navigationContext onSkipNextIntermediateDestinationDetected:(BOOL)state;

@end

NS_ASSUME_NONNULL_END
