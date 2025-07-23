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
#import <GEMKit/CoordinatesObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates mock position information.
 */
__attribute__((visibility("default"))) @interface MockPositionObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Initializes and returns a newly allocated object using the speed value.
 * @details The speed is in m/s.
 */
- (instancetype)initWithSpeed:(double)speed;

/**
 * Initializes and returns a newly allocated object using the location and speed value.
 * @details The speed is in m/s.
 */
- (instancetype)initWithLocation:(nonnull CoordinatesObject *)location speed:(double)speed;

/**
 * Geographical latitude.
 * @return The latitude in degrees.
 */
- (double)getLatitude;

/**
 * Geographical longitude.
 * @return The longitude in degrees.
 */
- (double)getLongitude;

/**
 * Latitude and longitude.
 * @return Coordinate pair, each one in degrees.
 */
- (nonnull CoordinatesObject*)getCoordinates;

/**
 * Altitude above main sea level.
 * @return The altitude in meters.
 */
- (double)getAltitude;

/**
 * Travel speed.
 * @return The speed, in m/s.
 */
- (double)getSpeed;
@end

NS_ASSUME_NONNULL_END
