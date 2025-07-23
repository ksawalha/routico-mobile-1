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
#import <GEMKit/DataSourceContext.h>
#import <GEMKit/DataSourceHeader.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates playback context. It represents the operations that can be performed on a DataSourceContext which has playback capabilities ( e.g. log ).
 */
__attribute__((visibility("default"))) @interface DataSourcePlaybackContext : NSObject

/**
 * Init with the data source context.
 */
- (instancetype)initWithContext:(nonnull DataSourceContext *)context;

/**
 * Pause the playback.
 */
- (BOOL)pause;

/**
 * Resume the playback.
 */
- (BOOL)resume;

/**
 * Step through the log data by data.
 */
- (void)step;

/**
 * Returns the playback state of this data source.
 */
- (PlayingStatus)getState;

/**
 * Gets the speed multiplier.
 */
- (float)getSpeedMultiplier;

/**
 * Sets the speed multiplier.
 * @param value The speed multiplier. Can have values between 0.f and getMaxSpeedMultiplier.
 */
- (void)setSpeedMultiplier:(float)value;

/**
 * Gets the max multiplier.
 */
- (float)getMaxSpeedMultiplier;

/**
 * Gets the min multiplier.
 */
- (float)getMinSpeedMultiplier;

/**
 * Returns the current position ( milliseconds from begin ).
 */
- (NSInteger)getCurrentPosition;

/**
 * Sets the current position.
 * @param value - the new current position ( milliseconds from begin ).
 * @return Returns the old position ( milliseconds from begin ).
 */
- (NSInteger)setCurrentPosition:(NSInteger)value;

/**
 * Returns playback duration ( milliseconds ).
 */
- (NSInteger)getDuration;

@end

NS_ASSUME_NONNULL_END
