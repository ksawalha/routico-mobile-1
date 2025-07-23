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
#import <GEMKit/GeographicAreaObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates circle geographic area information.
 */
__attribute__((visibility("default"))) @interface CircleGeographicAreaObject : GeographicAreaObject

/**
 * Initializes and returns a newly allocated object using location, horizontal and vertical radius.
 * @param coordinates The geographical location.
 * @param radius The horizontal radius in meters.
 */
- (instancetype)initWithCenter:(nonnull CoordinatesObject *)coordinates radius:(int)radius;

/**
 * Set the center of the circular geographic area.
 */
- (void)setCenter:(nonnull CoordinatesObject *)coordinates;

/**
 * Get the radius of the circular geographic area in meters.
 */
- (int)getRadius;

/**
 * Set the radius of the circular geographic area in meters.
 */
- (void)setRadius:(int)value;

/**
 * Set the center & radius.
 * @param coordinates The coordinates of the circle.
 * @param radius The radius in meters.
 */
- (void)setCenter:(nonnull CoordinatesObject *)coordinates radius:(int)radius;

@end

NS_ASSUME_NONNULL_END
