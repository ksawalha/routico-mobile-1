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
#import <GEMKit/TimeObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Constants indicating the type of the response from timezone plugin.
 */
typedef NS_ENUM(NSInteger, TimezoneStatus)
{
    /// Success.
    TimezoneStatusSuccess = 0,
    
    /// Invalid coordinate.
    TimezoneStatusInvalidCoordinate = 1,
    
    /// Wrong timezone id.
    TimezoneStatusWrongTimezoneId = 2,
    
    /// Wrong timestamp.
    TimezoneStatusWrongTimestamp = 3,
    
    /// Not found.
    TimezoneStatusNotFound = 4
};

/**
 * This class handles the timezone result.
 */
__attribute__((visibility("default"))) @interface TimezoneResultObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Get the offset for daylight-savings time.
 */
- (int)getDstOffset;

/**
 * Get the calculated offset ( in seconds ) for the given location.
 */
- (int)getOffset;

/**
 * Get the offset from UTC ( in seconds ) for a given location.
 */
- (int)getUtcOffset;

/**
 * Get the status of the response.
 */
- (TimezoneStatus)getStatus;

/**
 * Get the ID of the timezone.
 */
- (nonnull NSString *)getTimezoneId;

/**
 * Get the local time of the timezone in relation to query time.
 */
- (nullable TimeObject *)getLocalTime;

@end

NS_ASSUME_NONNULL_END
