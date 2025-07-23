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
#import <GEMKit/RouteInstructionObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates public transport route instruction information.
 */
__attribute__((visibility("default"))) @interface PTRouteInstructionObject : RouteInstructionObject

/**
 * Get Name.
 */
- (nonnull NSString *)getName;

/**
 * Get Platform Code.
 */
- (nonnull NSString *)getPlatformCode;

/**
 * Get Arrival Time.
 */
- (nullable TimeObject *)getArrivalTime;

/**
 * Get Departure Time.
 */
- (nullable TimeObject *)getDepartureTime;

/**
 * Get Wheelchair Support.
 */
- (BOOL)getHasWheelchairSupport;

@end

NS_ASSUME_NONNULL_END
