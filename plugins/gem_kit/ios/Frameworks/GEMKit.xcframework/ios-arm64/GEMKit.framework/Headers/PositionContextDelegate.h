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
#import <GEMKit/PositionObject.h>

@class PositionContext;

NS_ASSUME_NONNULL_BEGIN

/**
 * A set of delegate methods for position context objects.
 */
__attribute__((visibility("default"))) @protocol PositionContextDelegate <NSObject>

/**
 * Notifies the delegate when a new position is available.
 * @param positionContext The position context informing the delegate of this event.
 * @param position The new position.
 */
- (void)positionContext:(nonnull PositionContext *)positionContext didUpdatePosition:(nonnull PositionObject *)position;

@end

NS_ASSUME_NONNULL_END
