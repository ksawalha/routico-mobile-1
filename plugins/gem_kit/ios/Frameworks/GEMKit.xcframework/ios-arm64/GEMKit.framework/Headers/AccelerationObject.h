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
 * This class encapsulates acceleration information.
 */
__attribute__((visibility("default"))) @interface AccelerationObject : NSObject

/**
 * New position object.
 * @param timestamp The acquisition timestamp.
 * @param x The acceleration on the x axis.
 * @param y The acceleration on the y axis.
 * @param z The acceleration on the z axis.
 * @param unit The course in degrees.
 */
+ (nullable AccelerationObject *)createAcceleration:(NSInteger)timestamp x:(double)x y:(double)y z:(double)z unit:(DataUnitMeasurement)unit;

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
 * Returns the acceleration on the x axis of the device.
 */
- (double)getX;

/**
 * Returns the acceleration on the y axis of the device.
 */
- (double)getY;

/**
 * Returns the acceleration on the z axis of the device.
 */
- (double)getZ;

/**
 * Returns the unit of measurement.
 */
- (DataUnitMeasurement)getUnit;

@end

NS_ASSUME_NONNULL_END
