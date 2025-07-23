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
#import <GEMKit/RouteObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates public transport route information.
 */
__attribute__((visibility("default"))) @interface PTRouteObject : RouteObject

/**
 * Get Fare.
 */
- (nonnull NSString*)getPTFare;

/**
 * Get Frequency.
 */
- (NSInteger)getPTFrequency;

/**
 * Check if the solution meets all the preferences.
 */
- (BOOL)getPTRespectsAllConditions;

/**
 * Get number of Buy Ticket Information objects for PT route.
 */
- (NSInteger)getCountBuyTicketInformation;

/**
 * Get the buy ticket URL.
 * @param index The Buy Ticket Information index.
 */
- (nonnull NSString *)getBuyTicketURL:(int)index;

/**
 * Get indexes of the affected solution parts.
 * @param index The Buy Ticket Information index.
 */
- (nonnull NSArray <NSNumber *> *)getSolutionPartIndexes:(int)index;

@end

NS_ASSUME_NONNULL_END
