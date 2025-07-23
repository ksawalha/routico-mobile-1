// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all 
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V. 
// or its affiliates is strictly prohibited.

@class RouteObject;

NS_ASSUME_NONNULL_BEGIN

/**
 * A set of delegate methods for route object.
 */
__attribute__((visibility("default"))) @protocol RouteObjectDelegate <NSObject>

@optional

/**
 * Notifies the delegate that route traffic events were updated.
 * @details This notification is sent when there is a change in traffic affecting the route.
 * @param route The route informing the delegate of this event.
 * @param delayDiff Difference between new delay and old delay calculated only for the remaining travel distance.
 */
- (void)routeObject:(nonnull RouteObject *)route onTrafficEventsUpdated:(int)delayDiff;

/**
 * Notifies the delegate that traffic events along route were verified.
 * @param route The route informing the delegate of this event.
 * @param checked The verified status.
 */
- (void)routeObject:(nonnull RouteObject *)route onTrafficEventsAlongRoute:(BOOL)checked;

@end

NS_ASSUME_NONNULL_END
