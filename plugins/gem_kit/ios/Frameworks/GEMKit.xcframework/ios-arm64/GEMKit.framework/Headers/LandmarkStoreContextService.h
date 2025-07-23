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
#import <GEMKit/GenericHeader.h>
#import <GEMKit/LandmarkStoreContext.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates landmark store context service information.
 */
__attribute__((visibility("default"))) @interface LandmarkStoreContextService : NSObject

/**
 * Register an already existing landmark store.
 * @param name The landmark store name. Must be unique, otherwise SDKErrorCodeKExist is returned.
 * @param path The landmark store path.
 * @return On success the landmark store ID.
 */
- (int)registerLandmarkStoreContext:(nonnull NSString *)name path:(nonnull NSString *)path;

/**
 * Remove the landmark store context specified by ID.
 * @param identifier The ID of the landmark store context.
 */
- (SDKErrorCode)removeLandmarkStoreContext:(int)identifier;

/**
 * Get landmark store context by ID.
 * @param identifier The ID of the landmark store context.
 */
- (nonnull LandmarkStoreContext *)getLandmarkStoreContextWithIdentifier:(int)identifier;

/**
 * Get landmark store context by name.
 * @param storeName The name of the landmark store context.
 */
- (nonnull LandmarkStoreContext *)getLandmarkStoreContextWithName:(nonnull NSString *)storeName;

/**
 * Get the type of the landmark store.
 * @param identifier The ID of the landmark store context.
 */
- (LandmarkStoreType)getLandmarkStoreContextType:(int)identifier;

/**
 * Get Map POIs landmark store.
 */
- (int)getMapPoisLandmarkStoreId;

/**
 * Get landmark store id attached to map address database information.
 */
- (int)getMapAddressLandmarkStoreId;

/**
 * Get landmark store id attached to map cities database information.
 */
- (int)getMapCitiesLandmarkStoreId;

/**
 * Returns all available landmark stores.
 */
- (nonnull NSArray <LandmarkStoreContext *> *)getStores;

@end

NS_ASSUME_NONNULL_END
