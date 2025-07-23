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
#import <GEMKit/ImageObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates overlay category information.
 */
__attribute__((visibility("default"))) @interface OverlayCategoryObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the unique ID of the category within the overlay.
 */
- (int)getUid;

/**
 * Returns the parent overlay uid.
 */
- (int)getOverlayUid;

/**
 * Returns the category name.
 */
- (nonnull NSString *)getName;

/**
 * Returns the category image.
 */
- (nullable ImageObject *)getImage;

/**
 * Returns the category sub-categories.
 */
- (nonnull NSArray <OverlayCategoryObject *> *)getSubcategories;

/**
 * Check if category has subcategories.
 */
- (BOOL)hasSubcategories;

@end

NS_ASSUME_NONNULL_END
