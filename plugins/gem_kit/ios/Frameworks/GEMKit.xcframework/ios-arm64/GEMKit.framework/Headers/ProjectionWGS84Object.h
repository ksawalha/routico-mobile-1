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
#import <GEMKit/CoordinatesObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates WGS84 ( World Geodetic System ) projection information.
 */
__attribute__((visibility("default"))) @interface ProjectionWGS84Object : ProjectionObject

/**
 * Initializes and returns a newly allocated object using the coordinates.
 */
- (instancetype)initWithCoordinates:(nonnull CoordinatesObject *)coordinates;

/**
 * Get the coordinates of wgs84 projection.
 */
- (nonnull CoordinatesObject *)getCoordinates;

/**
 * Set the coordinates of wgs84 projection.
 */
- (void)setCoordinates:(nonnull CoordinatesObject *)object;

@end

NS_ASSUME_NONNULL_END
