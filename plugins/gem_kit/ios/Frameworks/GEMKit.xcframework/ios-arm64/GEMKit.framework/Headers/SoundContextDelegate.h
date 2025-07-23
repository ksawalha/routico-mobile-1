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

@class SoundContext;

NS_ASSUME_NONNULL_BEGIN

/**
 * A set of delegate methods for sound context objects.
 */
__attribute__((visibility("default"))) @protocol SoundContextDelegate <NSObject>

@optional

/**
 * Notifies the delegate that sound session interruption began.
 * @param SoundContext The sound context informing the delegate of this event.
 */
- (void)soundContextNotifyInterruptionBegin:(nonnull SoundContext *)soundContext;

/**
 * Notifies the delegate that sound session interruption ended.
 * @param SoundContext The sound context informing the delegate of this event.
 */
- (void)soundContextNotifyInterruptionEnded:(nonnull SoundContext *)soundContext;

@end

NS_ASSUME_NONNULL_END
