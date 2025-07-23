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
#import <GEMKit/GenericHeader.h>
#import <GEMKit/CoordinatesObject.h>
#import <GEMKit/TimeObject.h>
#import <GEMKit/TimezoneResultObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class handles the timezone.
 */
__attribute__((visibility("default"))) @interface TimezoneContext : NSObject

/**
 * Return singleton instance.
 */
+ (nonnull TimezoneContext*)sharedInstance;

/// Returns the timezone from coordinates.
/// @param location The location from where to get the timezone result.
/// @param time The time for which offsets are calculated ( UTC ).
/// @details The result will be computed using the available offline resource.
- (nonnull TimezoneResultObject *)getOfflineTimezoneInfo:(nonnull CoordinatesObject *)location time:(nonnull TimeObject *)time;

@end

NS_ASSUME_NONNULL_END
