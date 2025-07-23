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
#import <GEMKit/DataSourceHeader.h>
#import <GEMKit/DataObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates rotation information.
 */
__attribute__((visibility("default"))) @interface RotationObject : NSObject

/**
 * New position object.
 * @param timestamp The acquisition timestamp.
 * @param x The rotation rate around the x axis of the device, rad/s.
 * @param y The rotation rate around the y axis of the device, rad/s.
 * @param z The rotation rate around the z axis of the device, rad/s.
 */
+ (nullable RotationObject *)createRotation:(NSInteger)timestamp x:(double)x y:(double)y z:(double)z;

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Initializes and returns a newly allocated object using the data object.
 */
- (instancetype)initWithDataObject:(nonnull DataObject *)data;

/**
 * Returns the model data object.
 */
- (nullable DataObject*)getDataObject;

/**
 * Returns the rotation rate around the x axis of the device, rad/s.
 */
- (double)getX;

/**
 * Returns the rotation rate around the y axis of the device, rad/s.
 */
- (double)getY;

/**
 * Returns the rotation rate around the z axis of the device, rad/s.
 */
- (double)getZ;

@end

NS_ASSUME_NONNULL_END
