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
#import <GEMKit/CoordinatesObject.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((visibility("default"))) @interface TimeDistanceCoordinatesObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Initializes and returns a newly allocated object using the location coordinates.
 */
- (instancetype)initWithCoordinates:(nonnull CoordinatesObject *)coordinates;

/**
 * Initializes and returns a newly allocated object using the location coordinates, distance and timestamp.
 */
- (instancetype)initWithCoordinates:(nonnull CoordinatesObject *)coordinates distance:(int)distance timestamp:(int)timestamp;

/**
 * Set the WGS coordinates.
 */
- (void)setCoordinates:(nonnull CoordinatesObject *)object;

/**
 * Get the WGS coordinates.
 */
- (nonnull CoordinatesObject *)getCoordinates;

/**
 * Set the distance in meters.
 */
- (void)setDistance:(int)distance;

/**
 * Get the distance in meters.
 */
- (int)getDistance;

/**
 * Set the timestamp in seconds.
 */
- (void)setTimestamp:(int)stamp;

/**
 * Get the timestamp.
 */
- (int)getTimestamp;

@end

NS_ASSUME_NONNULL_END
