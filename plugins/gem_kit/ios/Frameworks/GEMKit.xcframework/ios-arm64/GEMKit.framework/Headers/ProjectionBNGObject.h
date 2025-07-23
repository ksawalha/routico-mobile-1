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

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates BNG projection information.
 */
__attribute__((visibility("default"))) @interface ProjectionBNGObject : ProjectionObject

/**
 * Initializes and returns a newly allocated object using the parameters for projection.
 */
- (instancetype)initWithEasting:(double)easting northing:(double)northing;

/**
 * Initializes and returns a newly allocated object using the parameters for projection.
 */
- (instancetype)initWithGridReference:(nonnull NSString *)grid;

/**
 * Set the fields for projection.
 */
- (void)setEasting:(double)easting northing:(double)northing;

/**
 * Set the fields for projection.
 */
- (void)setGridReference:(nonnull NSString *)grid;

/**
 * Get easting for the projection.
 */
- (double)getEasting;

/**
 * Get northing for the projection.
 */
- (double)getNorthing;

/**
 * Get grid reference for the projection.
 */
- (nonnull NSString *)getGridReference;

@end

NS_ASSUME_NONNULL_END
