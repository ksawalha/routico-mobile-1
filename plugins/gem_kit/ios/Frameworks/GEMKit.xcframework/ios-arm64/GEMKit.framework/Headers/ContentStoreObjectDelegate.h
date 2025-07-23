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
typedef NS_ENUM(NSInteger, ContentStoreObjectStatus)
{
    /// The item has no content.
    ContentStoreObjectStatusUnavailable,
    
    /// The item has complete content.
    ContentStoreObjectStatusCompleted,
    
    /// The item download is paused.
    ContentStoreObjectStatusPaused,
    
    /// Download is waiting in the downloads queue.
    /// @details A download might be enqueued due to "max parallel downloads" constraint or because of an API token rate limit.
    ContentStoreObjectStatusDownloadQueued,
    
    /// Download is temporary waiting for some condition to be met.
    /// @details E.g. waiting for a connection to be available.
    ContentStoreObjectStatusDownloadWaiting,
    
    /// Download is waiting for a free network to begin/resume the download.
    ContentStoreObjectStatusDownloadWaitingFreeNetwork,
    
    /// Download is running.
    ContentStoreObjectStatusDownloadRunning,
    
    /// Item download is waiting for the update operation to finish
    /// @details Items selected for download during an update operation will enter this state
    ContentStoreObjectStatusUpdateWaiting
};

/**
 * Constants indicating the download thread priorities.
 */
typedef NS_ENUM(NSInteger, ContentDownloadThreadPriority)
{
    /// Priority default.
    ContentDownloadThreadPriorityDefault,
    
    /// Priority low.
    ContentDownloadThreadPriorityLow,
    
    /// Priority high.
    ContentDownloadThreadPriorityHigh
};

/**
 * A set of methods that you can use to get notify.
 */
__attribute__((visibility("default"))) @protocol ContentStoreObjectDelegate <NSObject>

/**
 * Notifies the delegate that the requested operation was started.
 * @param object The content store object informing the delegate of this event.
 * @param hasProgress If the operation supports progress then hasProgress is true.
 */
- (void)contentStoreObject:(nonnull ContentStoreObject *)object notifyStart:(BOOL)hasProgress;

/**
 * Notifies the delegate with the progress on requested operation.
 * @param object The content store object informing the delegate of this event.
 * @param progress The progress value.
 */
- (void)contentStoreObject:(nonnull ContentStoreObject *)object notifyProgress:(int)progress;

/**
 * Notifies the delegate that the requested operation was completed.
 * @param object The content store object informing the delegate of this event.
 * @param success If the operation was successfully.
 */
- (void)contentStoreObject:(nonnull ContentStoreObject *)object notifyComplete:(BOOL)success;

/**
 * Notifies the delegate with the new content store object status.
 * @param object The content store object informing the delegate of this event.
 * @param status The new status.
 */
- (void)contentStoreObject:(nonnull ContentStoreObject *)object notifyStatusChanged:(ContentStoreObjectStatus)status;

@end

NS_ASSUME_NONNULL_END
