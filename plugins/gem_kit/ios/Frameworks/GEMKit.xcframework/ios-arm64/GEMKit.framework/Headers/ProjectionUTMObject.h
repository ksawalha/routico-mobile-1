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

/**
 * Constants indicating the hemisphere from projection plugin.
 */
typedef NS_ENUM(NSInteger, HemisphereType)
{
    /// South.
    HemisphereSouth = 0,
    
    /// North
    HemisphereNorth = 1
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates GK projection information.
 */
__attribute__((visibility("default"))) @interface ProjectionUTMObject : ProjectionObject

/**
 * Initializes and returns a newly allocated object using the parameters for projection.
 */
- (instancetype)initWithX:(double)x y:(double)y zone:(unsigned int)zone hemisphere:(HemisphereType)hemisphere;

/**
 * Set the fields for projection.
 */
- (void)setX:(double)x setY:(double)y zone:(unsigned int)zone hemisphere:(HemisphereType)hemisphere;

/**
 * Get the first coordinate for the projection.
 */
- (double)getX;

/**
 * Get the second coordinate for the projection.
 */
- (double)getY;

/**
 * Get zone for the projection.
 */
- (int)getZone;

/**
 * Get the hemisphere of the projection.
 */
- (HemisphereType)getHemisphere;

@end

NS_ASSUME_NONNULL_END
