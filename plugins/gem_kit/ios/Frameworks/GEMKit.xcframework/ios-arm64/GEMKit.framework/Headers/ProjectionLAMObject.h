// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all 
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V. 
// or its affiliates is strictly prohibited.

#import <GEMKit/GEMKit.h>
#import <GEMKit/ProjectionObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates LAM projection information.
 */
__attribute__((visibility("default"))) @interface ProjectionLAMObject : ProjectionObject

/**
 * Initializes and returns a newly allocated object using the coordinates for projection.
 */
- (instancetype)initWithX:(double)x y:(double)y;

/**
 * Set the coordinates for projection.
 */
- (void)setX:(double)x setY:(double)y;

/**
 * Get the first coordinate.
 */
- (double)getX;

/**
 * Get the second coordinate.
 */
- (double)getY;

@end

NS_ASSUME_NONNULL_END
