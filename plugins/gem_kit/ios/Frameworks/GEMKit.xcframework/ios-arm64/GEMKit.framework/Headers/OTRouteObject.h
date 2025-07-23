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
#import <GEMKit/RouteObject.h>
#import <GEMKit/PathObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates ev transport route information.
 */
__attribute__((visibility("default"))) @interface OTRouteObject : RouteObject

/**
 * Get the track attached to track route waypoint.
 * @details If the route is part of a navigation session, returns only the active ( remaining ) part of the track, otherwise returns the whole track.
 */
- (nullable PathObject *)getTrack;

@end

NS_ASSUME_NONNULL_END

