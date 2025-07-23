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
#import <GEMKit/OverlayCategoryObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates overlay info details.
 */
__attribute__((visibility("default"))) @interface OverlayInfoObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Get the unique ID of the overlay.
 */
- (int)getUid;

/**
 * Get the name of the overlay.
 */
- (nonnull NSString *)getName;

/**
 * Returns the image of the item.
 * @param height The desired image height.
 */
- (nullable UIImage *)getImage:(CGFloat)height;

/**
 * Gets the overlay categories.
 * @return empty if no categories are available.
 */
- (nonnull NSArray <OverlayCategoryObject *> *)getCategories;

/**
 * Gets the overlay category by id.
 * @return empty if no category is found.
 */
- (nullable OverlayCategoryObject *)getCategory:(int)categoryId;

/**
 * Check if a category has subcategories.
 */
- (BOOL)hasCategories:(int)categoryId;

@end

NS_ASSUME_NONNULL_END
