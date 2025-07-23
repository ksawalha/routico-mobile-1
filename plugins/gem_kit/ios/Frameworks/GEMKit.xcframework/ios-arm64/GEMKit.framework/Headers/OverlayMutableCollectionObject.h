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
 * This class encapsulates overlay mutable collection details.
 */
__attribute__((visibility("default"))) @interface OverlayMutableCollectionObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Add an overlay to the collection. If the overlay has categories, all are added to the collection.
 @param overlayId The overlay id.
 */
- (void)add:(int)overlayId;

/**
 * Add an online overlay category to the collection.
 * @param overlayId The overlay id.
 * @param categoryId The overlay category id in OverlayInfo.getCategories result list.
 */
- (void)add:(int)overlayId categoryId:(int)categoryId;

/**
 * Remove the overlay from the collection.
 * @param overlayId The overlay id.
 */
- (void)remove:(int)overlayId;

/**
 * Remove the overlay category id from the collection.
 * @param overlayId The overlay id.
 * @param categoryId The overlay category id in OverlayInfo.getCategories result list.
 */
- (void)remove:(int)overlayId categoryId:(int)categoryId;

/**
 * Clear all overlays in collection.
 */
- (void)clear;

@end

NS_ASSUME_NONNULL_END
