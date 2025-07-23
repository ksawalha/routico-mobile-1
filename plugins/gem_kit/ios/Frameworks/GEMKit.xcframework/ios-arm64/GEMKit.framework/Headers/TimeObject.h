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
 * This class encapsulates time object information.
 */
__attribute__((visibility("default"))) @interface TimeObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Check if the date is valid.
 */
- (BOOL)isValid;

/**
 * Sleep in this thread for specified number of milliseconds.
 */
- (void)milliSecondSleep:(unsigned int)msec;

/**
 * Number of milliseconds that have passed since 1970-01-01T00:00:00.
 */
- (NSUInteger)getEpoch;

/**
 * Returns a time object with local time.
 */
- (nonnull TimeObject *)getLocalTime;

/**
 * Returns a time object with universal time.
 */
- (nonnull TimeObject *)getUniversalTime;

/**
 * Set time object to universal time.
 */
- (void)setUniversalTime;

/**
 * Set time object to local time.
 */
- (void)setLocalTime;

/**
 * Number of milliseconds that have passed since 1970-01-01T00:00:00.
 */
- (NSUInteger)asInt;

/**
 * Set the time from a timestamp.
 * @details Timestamp is the number of milliseconds that have passed since 1970-01-01T00:00:00.
 */
- (void)fromInt:(NSInteger)timestamp;

/**
 * Get the year.
 */
- (int)getYear;

/**
 * Set the year.
 */
- (void)setYear:(int)value;

/**
 * Get the month. Valid values 1..12
 */
- (int)getMonth;

/**
 * Set the month. Valid values 1..12
 */
- (void)setMonth:(int)value;

/**
 * Get the day. Valid values 1..31
 */
- (int)getDay;

/**
 * Set the day. Valid values 1..31
 */
- (void)setDay:(int)value;

/**
 * Get the day of the week. Valid values 1..7 (1 being Sunday).
 */
- (int)getDayOfWeek;

/**
 * Get the hour. Valid values 0..23
 */
- (int)getHour;

/**
 * Set the hour. Valid values 0..23
 */
- (void)setHour:(int)value;

/**
 * Get the minute. Valid values 0..59
 */
- (int)getMinute;

/**
 * Set the minute. Valid values 0..59
 */
- (void)setMinute:(int)value;

/**
 * Get the second. Valid values 0..59
 */
- (int)getSecond;

/**
 * Set the second. Valid values 0..59
 */
- (void)setSecond:(int)value;

/**
 * Get the millisecond. Valid values 0..999
 */
- (int)getMillisecond;

/**
 * Set the millisecond. Valid values 0..999
 */
- (void)setMillisecond:(int)value;

/**
 * Format string conform to ISO8601.
 * @param utcTime Time should be considered as UTC.
 */
- (nonnull NSString *)toStr:(BOOL)utcTime;

/**
 * Get time zone in milliseconds
 */
- (NSInteger)getTimeZoneMilliseconds;

@end

NS_ASSUME_NONNULL_END
