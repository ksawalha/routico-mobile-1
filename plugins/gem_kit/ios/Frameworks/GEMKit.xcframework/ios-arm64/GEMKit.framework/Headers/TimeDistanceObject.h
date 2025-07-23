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
 * This class encapsulates time distance information.
 */
__attribute__((visibility("default"))) @interface TimeDistanceObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the total time in seconds.
 */
- (unsigned int)getTotalTime;

/**
 * Returns the unrestricted time in seconds.
 */
- (unsigned int)getUnrestrictedTime;

/**
 * Returns the restricted time in seconds.
 */
- (unsigned int)getRestrictedTime;

/**
 * Returns the restricted time at beginning.
 */
- (unsigned int)getRestrictedTimeAtBegin;

/**
 * Returns the restricted time at end.
 */
- (unsigned int)getRestrictedTimeAtEnd;

/**
 * Returns the total distance in meters
 */
- (unsigned int)getTotalDistance;

/**
 * Returns the total distance measurement.
 * @details Measurement of total distance based on accuracy.
 * @details >20 km: 1 km accuracy.
 * @details 1 - 20 km: 0.1 km accuracy.
 * @details 500 - 1,000 m: 50 m accuracy.
 * @details 200 - 500 m: 25 m accuracy.
 * @details 100 - 200 m: 10 m accuracy.
 * @details   0 - 100 m: 5 m accuracy.
 */
- (nonnull NSMeasurement <NSUnitLength *> *)getTotalDistanceMeasurement;

/**
 * Returns the unrestricted distance in meters.
 */
- (unsigned int)getUnrestrictedDistance;

/**
 * Returns the restricted distance in meters.
 */
- (unsigned int)getRestrictedDistance;

/**
 * Returns the restricted distance at beginning in meters.
 */
- (unsigned int)getRestrictedDistanceAtBegin;

/**
 * Returns the restricted distance at end in meters.
 */
- (unsigned int)getRestrictedDistanceAtEnd;

/**
 * Returns the total distance formatted string.
 */
- (NSString*)getTotalDistanceFormatted;

/**
 * Returns the distance unit formatted string.
 */
- (NSString*)getTotalDistanceUnitFormatted;

/**
 * Returns the time formatted string.
 */
- (NSString*)getTotalTimeFormatted;

/**
 * Returns the time unit formatted string.
 */
- (NSString*)getTotalTimeUnitFormatted;

/**
 * Returns the formatted distance string.
 * @param value Must be in meters.
 * @details > 20 km - 1 km accuracy - KM
 * @details 1 - 20 km - 0.1 km accuracy - KM
 * @details 500 - 1,000 m - 50 m accuracy - M
 * @details 200 - 500 m - 25 m accuracy - M
 * @details 100 - 200 m - 10 m accuracy - M
 * @details 0 - 100 m - 5 m accuracy - M
 */
- (NSString*)getFormattedDistance:(int)value;

/**
 * Returns the formatted distance unit string.
 * @param value Must be in meters.
 */
- (NSString*)getFormattedDistanceUnit:(int)value;

@end

NS_ASSUME_NONNULL_END
