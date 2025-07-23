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
 * This class encapsulates MGRS ( Military Grid Reference System ) projection information.
 */
__attribute__((visibility("default"))) @interface ProjectionMGRSObject : ProjectionObject

/**
 * Initializes and returns a newly allocated object using the parameters for projection.
 */
- (instancetype)initWithEasting:(int)easting northing:(int)northing zone:(nonnull NSString *)zone letters:(nonnull NSString *)letters;

/**
 * Set the fields for projection.
 */
- (void)setEasting:(int)easting northing:(int)northing zone:(nonnull NSString *)zone letters:(nonnull NSString *)letters;

/**
 * Get easting for the projection.
 */
- (int)getEasting;

/**
 * Get northing for the projection.
 */
- (int)getNorthing;

/**
 * Get zone for the projection.
 */
- (nonnull NSString *)getZone;

/**
 * Get identifier for 100.000 square meters.
 */
- (nonnull NSString *)getSq100kIdentifier;

@end

NS_ASSUME_NONNULL_END
