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
 * This class encapsulates coordinates information.
 */
__attribute__((visibility("default"))) @interface CoordinatesObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Initializes and returns a newly allocated object using parameter values.
 */
+ (nonnull instancetype)coordinatesWithLatitude:(double)latitude longitude:(double)longitude;

/**
 * Initializes and returns a newly allocated object using parameter values.
 */
+ (nonnull instancetype)coordinatesWithLatitude:(double)latitude longitude:(double)longitude altitude:(double)altitude;

/**
 * The latitude in degrees.
 * @discussion Positive values indicate latitudes north of the equator. Negative values indicate latitudes south of the equator.
 * @discussion Valid values -90.0 .. +90.0.
 */
@property(nonatomic, assign) double latitude;

/**
 * The longitude in degrees.
 * @discussion Measurements are relative to the zero meridian, with positive values extending east of the meridian and negative values extending west of the meridian.
 * @discussion Valid values -180.0 .. +180.0.
 */
@property(nonatomic, assign) double longitude;

/**
 * The altitude in meters.
 */
@property(nonatomic, assign) double altitude;

/**
 * Returns true if the coordinates are valid.
 */
- (BOOL)isValid;

/**
 * Calculate the distance in meters between two WGS84 coordinates.
 * @param point The coordinates to which the distance should be calculated.
 */
- (double)getDistance:(nonnull CoordinatesObject*)point;

/**
 * Calculate the azimuth between the two points according to the ellipsoid model of WGS84.
 * @param point The coordinates to which the a should be calculated.
 */
- (double)getAzimuth:(nonnull CoordinatesObject*)point;

/**
 * Returns parent scene object to which coordinates belongs.
 */
- (int)getSceneObject;

@end

NS_ASSUME_NONNULL_END
