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

/**
 * Constants indicating the type of a projection.
 */
typedef NS_ENUM(NSInteger, ProjectionType)
{
    /// British National Grid ( BNG )
    ProjectionTypeBng = 0,
    
    /// Lambert 93
    ProjectionTypeLam = 1,
    
    /// Universal Transverse Mercator ( UTM )
    ProjectionTypeUtm = 2,
    
    /// Military Grid Reference System ( MGRS )
    ProjectionTypeMgrs = 3,
    
    /// Gauss-Krüger ( GK )
    ProjectionTypeGk = 4,
    
    /// World Geodetic System ( WGS84 )
    ProjectionTypeWgs84 = 5,
    
    /// What3Words
    ProjectionTypeW3W = 6,
    
    /// Undefined
    ProjectionTypeUndefined = 7
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates projection information.
 */
__attribute__((visibility("default"))) @interface ProjectionObject : NSObject

/**
 * Initializes and returns a newly allocated object using the project type.
 */
- (instancetype)initWithType:(ProjectionType)type NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Get the projection type.
 */
- (ProjectionType)getType;

/**
 * Check if object is equals to current projection.
 */
- (BOOL)isEqualTo:(ProjectionObject *)object;

/**
 * Check if this is a default object ( nothing was modified on it since creation ).
 */
- (BOOL)isDefault;

/**
 * Check empty projection.
 */
- (BOOL)isEmpty;

/**
 * Reset the object to default.
 */
- (void)reset;

@end

NS_ASSUME_NONNULL_END
