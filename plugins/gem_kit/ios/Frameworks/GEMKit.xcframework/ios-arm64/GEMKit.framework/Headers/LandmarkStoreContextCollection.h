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
#import <GEMKit/LandmarkStoreContext.h>
#import <GEMKit/GenericHeader.h>
#import <GEMKit/LandmarkCategoryObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates landmark store context collection information.
 */
__attribute__((visibility("default"))) @interface LandmarkStoreContextCollection : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the number of stores in the collection.
 */
- (int)size;

/**
 * Returns the store items.
 */
- (nonnull NSArray <LandmarkStoreContext *> *)getItems;

/**
 * Returns the store ID for the specified index.
 */
- (int)getStoreIdAt:(int)index;

/**
 * Check if the specified store ID has any category in the list.
 */
- (BOOL)contains:(int)storeId;

/**
 * Check if the specified category ID from the specified store ID was already added.
 */
- (BOOL)contains:(int)storeId categoryId:(int)categoryId;

/**
 * Get the number of categories enabled for the specified store.
 */
- (int)getCategoryCount:(int)storeId;

/**
 * Get the specified category ID for the specified store.
 */
- (int)getStoreCategoryId:(int)storeId indexCategory:(int)indexCategory;

/**
 * Add a new category ID into the specified store list.
 * @return SDKErrorCodeKNoError on success.
 */
- (SDKErrorCode)addStoreCategoryId:(int)storeId categoryId:(int)categoryId;

/**
 * Add a list of categories into the specified store list.
 * @return SDKErrorCodeKNoError on success.
 */
- (SDKErrorCode)addStoreCategoryList:(int)storeId categories:(nonnull NSArray <LandmarkCategoryObject *> *)array;

/**
 * Add all the categories of the specified store ID.
 * @return SDKErrorCodeKNoError on success.
 */
- (SDKErrorCode)addAllStoreCategories:(int)storeId;

/**
 * Remove category ID from the specified store list.
 * @return SDKErrorCodeKNoError on success.
 */
- (SDKErrorCode)removeStoreCategoryId:(int)storeId categoryId:(int)categoryId;

/**
 * Remove all the categories of the specified store ID.
 * @return SDKErrorCodeKNoError on success.
 */
- (SDKErrorCode)removeAllStoreCategories:(int)storeId;

/**
 * Remove all stores and categories.
 */
- (void)clear;

@end

NS_ASSUME_NONNULL_END

