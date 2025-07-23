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
#import <GEMKit/LandmarkObject.h>

@class ContentStoreObject;

NS_ASSUME_NONNULL_BEGIN

/**
 * Constants indicating the content store object status.
 */
typedef NS_ENUM(NSInteger, ContentUpdateStatus)
{
    /// Not started.
    ContentUpdateStatusIdle,
    
    /// Wait for internet connection.
    ContentUpdateStatusWaitConnection,
    
    /// Wait for WIFI internet connection.
    ContentUpdateStatusWaitWIFIConnection,
    
    /// Check for updated items.
    ContentUpdateStatusCheckForUpdate,
    
    /// Download updated content.
    ContentUpdateStatusDownload,
    
    /// @details When entering this state 'getUpdateItems' will return the list of items target to update.
    /// Update is fully downloaded & ready to apply.
    ContentUpdateStatusFullyReady,
    
    /// Update is partially downloaded & ready to apply.
    ContentUpdateStatusPartiallyReady,
    
    /// Download remaining content after appliance.
    ContentUpdateStatusDownloadRemainingContent,
    
    /// Download pending content.
    ContentUpdateStatusDownloadPendingContent,
    
    /// Finished with success.
    ContentUpdateStatusComplete,
    
    /// Finished with error.
    ContentUpdateStatusError
};

/**
 * A set of delegate methods for content update.
 */
__attribute__((visibility("default"))) @protocol ContentUpdateDelegate <NSObject>

/**
 * Notifies the delegate that the requested operation was started.
 * @param context The context informing the delegate of this event.
 * @param hasProgress If the operation supports progress then hasProgress is true.
 */
- (void)contextUpdate:(nonnull NSObject *)context notifyStart:(BOOL)hasProgress;

/**
 * Notifies the delegate with the progress on requested operation.
 * @param context The context informing the delegate of this event.
 * @param progress The progress value.
 */
- (void)contextUpdate:(nonnull NSObject *)context notifyProgress:(int)progress;

/**
 * Notifies the delegate that the requested operation was completed.
 * @param context The context informing the delegate of this event.
 * @param success If the operation was successfully.
 */
- (void)contextUpdate:(nonnull NSObject *)context notifyComplete:(BOOL)success;

/**
 * Notifies the delegate with the new content store object status.
 * @param context The context informing the delegate of this event.
 * @param status The new status.
 */
- (void)contextUpdate:(nonnull NSObject *)context notifyStatusChanged:(ContentUpdateStatus)status;

@end

NS_ASSUME_NONNULL_END
