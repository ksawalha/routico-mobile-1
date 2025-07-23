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

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates road info information.
 */
__attribute__((visibility("default"))) @interface RoadInfoObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Constants indicating the road shield type.
 */
typedef NS_ENUM(NSInteger, RoadShieldType)
{
    /// Invalid.
    RoadShieldTypeInvalid = 0,
    
    /// County.
    RoadShieldTypeCounty,
    
    /// State.
    RoadShieldTypeState,
    
    /// Federal.
    RoadShieldTypeFederal,
    
    /// Interstate.
    RoadShieldTypeInterstate,
    
    /// RS4.
    RoadShieldTypeRS4,
    
    /// RS5.
    RoadShieldTypeRS5,
    
    /// RS6.
    RoadShieldTypeRS6,
    
    /// RS7.
    RoadShieldTypeRS7
};

/**
 * Returns the shield type.
 */
- (RoadShieldType)getShieldType;

/**
 * Returns the road name.
 */
- (nonnull NSString *)getRoadName;

@end

NS_ASSUME_NONNULL_END
