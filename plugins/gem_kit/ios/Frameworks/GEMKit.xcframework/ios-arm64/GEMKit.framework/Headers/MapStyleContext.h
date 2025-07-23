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
#import <GEMKit/ContentStoreObject.h>
#import <GEMKit/ContentUpdateDelegate.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class handles the map styles.
 */
__attribute__((visibility("default"))) @interface MapStyleContext : NSObject

/**
 * Check if the online map styles content is preloaded.
 * @details If the content is not cached locally a call to preloadContentWithCompletionHandler must be performed.
 */
- (BOOL)isContentPreloaded;

/**
 * Preload the online map styles content.
 */
- (void)preloadContentWithCompletionHandler:(void(^)(BOOL success))handler;

/**
 * Returns the local map styles list.
 */
- (nonnull NSArray<ContentStoreObject *> *)getLocalList;

/**
 * Asynchronously returns the online map styles list.
 * @details A preload operation is done if previously was not requested.
 */
- (void)getOnlineListWithCompletionHandler:(nonnull void(^)(NSArray<ContentStoreObject *> *array))handler;

/**
 * Start a download request for the given map style identifier.
 * @param identifier The style identifier.
 * @param allowCellularNetwork The flag whether to allow charged networks.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)downloadStyleWithIdentifier:(NSInteger)identifier allowCellularNetwork:(BOOL)allowCellularNetwork completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Check if there is an update available.
 * @param handler The block to execute asynchronously with the content online support status.
 */
- (void)checkForUpdateWithCompletionHandler:(nonnull void(^)(ContentStoreOnlineSupportStatus status))handler;

/**
 * Returns the update size string formatted ( if an update is available ).
 */
- (nonnull NSString *)getUpdateSizeFormatted;

/**
 The delegate for the content update.
 */
@property(nonatomic, weak) NSObject <ContentUpdateDelegate> *delegateUpdate;

/**
 * Start the update process.
 * @param allowCellularNetwork The flag whether to allow charged networks.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)updateWithAllowCellularNetwork:(BOOL)allowCellularNetwork completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Returns the content items list in update process.
 */
- (nonnull NSArray <ContentStoreObject *> *)getUpdateItems;

/**
 * Returns the update operation status.
 */
- (ContentUpdateStatus)getUpdateStatus;

/**
 * Returns the update operation progress.
 */
- (NSInteger)getUpdateProgress;

/**
 * Returns true if an update is already started.
 */
- (BOOL)isUpdateStarted;

/**
 * Cancel the update process.
 */
- (void)cancelUpdate;

/**
 * Returns the item having the specified ID.
 */
- (nullable ContentStoreObject *)getItemById:(NSInteger)contentId;

/**
 * Refresh content store.
 */
- (void)refreshContentStore;

@end

NS_ASSUME_NONNULL_END
