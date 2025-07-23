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

@class TrafficContext;

NS_ASSUME_NONNULL_BEGIN

/**
 * A set of delegate methods for traffic context.
 */
__attribute__((visibility("default"))) @protocol PersistentRoadblockDelegate <NSObject>

@optional

/**
 * Notification called when some user roadblocks are expired.
 */
- (void)trafficContext:(nonnull TrafficContext *)trafficContext onRoadblocksExpired:(nonnull NSArray <TrafficEventObject *> *)events;

/**
 * Notification called when some user roadblocks are activated.
 */
- (void)trafficContext:(nonnull TrafficContext *)trafficContext onRoadblocksActivated:(nonnull NSArray <TrafficEventObject *> *)events;

@end

NS_ASSUME_NONNULL_END
