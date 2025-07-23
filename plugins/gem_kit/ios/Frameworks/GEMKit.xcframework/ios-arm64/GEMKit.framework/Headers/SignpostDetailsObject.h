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
#import <GEMKit/SignpostItemObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates signpost information.
 */
__attribute__((visibility("default"))) @interface SignpostDetailsObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Get the list with SignpostItemObject elements.
 */
- (nonnull NSArray <SignpostItemObject *> *)getItems;

/**
 * Check the border color for the signpost.
 */
- (BOOL)hasBorderColor;

/**
 * Get the border color for the signpost.
 */
- (nonnull UIColor*)getBorderColor;

/**
 * Check the text color for the signpost.
 */
- (BOOL)hasTextColor;

/**
 * Get the text color for the signpost.
 */
- (nonnull UIColor*)getTextColor;

/**
 * Check the background color for the signpost.
 */
- (BOOL)hasBackgroundColor;

/**
 * Returns the background color for the signpost.
 */
- (nonnull UIColor*)getBackgroundColor;

/**
 * Returns the signpost image.
 * @param size The size of the image.
 */
- (nullable UIImage*)getImage:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
