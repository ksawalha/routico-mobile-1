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
#import <GEMKit/ContentStoreObjectDelegate.h>

/**
 * Constants indicating the content store online type.
 */
typedef NS_ENUM(NSInteger, ContentStoreOnlineType)
{
    /// View styles for high resolution displays.
    ContentStoreOnlineTypeViewStyleHighRes,

    /// View styles for high resolution displays.
    ContentStoreOnlineTypeViewStyleLowRes,
    
    /// Road map.
    ContentStoreOnlineTypeRoadMap,
    
    /// Human voice.
    ContentStoreOnlineTypeHumanVoice,
    
    /// Computer voice.
    ContentStoreOnlineTypeComputerVoice,
};

/**
 * Constants indicating the content store online support status.
 */
typedef NS_ENUM(NSInteger, ContentStoreOnlineSupportStatus)
{
    /// Old data, content still has online support.
    ContentStoreOnlineSupportStatusOldData,
    
    /// Expired data, content without online support.
    ContentStoreOnlineSupportStatusExpiredData,
    
    /// Data is up to date.
    ContentStoreOnlineSupportStatusUpToDate
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates position information.
 */
__attribute__((visibility("default"))) @interface ContentStoreObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (nullable void *)getModelData;

/**
 * The delegate for the content store object.
 */
@property(nonatomic, weak) NSObject <ContentStoreObjectDelegate> *delegate;

/**
 * Returns the identifier of the content store object.
 */
- (NSInteger)getIdentifier;

/**
 * Returns the name of the content store object.
 */
- (nonnull NSString *)getName;

/**
 * Returns the type of the content store object.
 */
- (ContentStoreOnlineType)getType;

/**
 * Returns the image preview of the content store object.
 * @param width The desired image width in pixels.
 */
- (nullable UIImage*)getImagePreview:(CGFloat)width;

/**
 * Async returns the image preview of the content store object on the completion handler. In case the image preview is already available the method will return the image immediately.
 * @param width The desired image width in pixels.
 * @param handler The async completion handler.
 */
- (nullable UIImage *)getAsyncImagePreview:(CGFloat)width completionHandler:(nonnull void(^)(UIImage* _Nullable image) )handler;

/**
 * Returns true if the image preview is available.
 */
- (BOOL)isImagePreviewAvailable;

/**
 * Returns the product chapter name translated to interface language.
 */
- (NSString *)getChapterName;

/**
 * Returns the country code (ISO 3166-1 alpha-3 ) list of the product as text.
 */
- (nonnull NSArray<NSString *> *)getCountryCodes;

/**
 * Returns the full path to the content data file when available.
 */
- (nonnull NSString *)getFileName;

/**
 * Returns the client version of the content.
 */
- (nonnull NSString *)getClientVersion;

/**
 * Returns the size of the content in bytes.
 */
- (NSInteger)getTotalSize;

/**
 * Returns the size of the content formatted.
 */
- (NSString*)getTotalSizeFormatted;

/**
 * Returns the available size of the content in bytes. The size of the downloaded content.
 */
- (NSInteger)getAvailableSize;

/**
 * Returns true if the item is completed downloaded.
 */
- (BOOL)isCompleted;

/**
 * Asynchronous start / resume the download of the content store object.
 * @param allowCellularNetwork The flag whether to allow charged networks.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)downloadWithAllowCellularNetwork:(BOOL)allowCellularNetwork completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Asynchronous start / resume the download of the content store object.
 * @param allowCellularNetwork The flag whether to allow charged networks.
 * @param progressHandler The block to execute asynchronously with the progress download.
 * @param completionHandler The block to execute asynchronously with the result.
 */
- (void)downloadWithAllowCellularNetwork:(BOOL)allowCellularNetwork progressHandler:(nonnull void(^)(int progress))progressHandler completionHandler:(nonnull void(^)(BOOL success))completionHandler;

/**
 * Asynchronous start / resume the download of the content store object.
 * @param allowCellularNetwork The flag whether to allow charged networks.
 * @param progressHandler The block to execute asynchronously with the progress download.
 * @param priority Download thread priority, default OS value.
 * @param completionHandler The block to execute asynchronously with the result.
 */
- (void)downloadWithAllowCellularNetwork:(BOOL)allowCellularNetwork progressHandler:(nonnull void(^)(int progress))progressHandler priority:(ContentDownloadThreadPriority)priority completionHandler:(nonnull void(^)(BOOL success))completionHandler;

/**
 * Returns the current item status.
 */
- (ContentStoreObjectStatus)getStatus;

/**
 * Pause a previous download operation.
 */
- (void)pauseDownload;

/**
 * Cancel a previous download operation. The partially downloaded content is deleted.
 */
- (void)cancelDownload;

/**
 * Returns the current download progress.
 */
- (int)getDownloadProgress;

/**
 * Returns true if content can be deleted.
 */
- (BOOL)canDeleteContent;

/**
 * Delete the associated content.
 */
- (void)deleteContent;

/**
 * Returns the corresponding update item.
 * @details The function will return an valid item only if an update is in progress for that item.
 */
- (nullable ContentStoreObject *)getUpdateItem;

/**
 * Check if item is updatable, i.e. it has a newer version available.
 */
- (BOOL)isUpdatable;

/**
 * Returns the update size  ( if an update is available for this item ).
 * @details The function will return a valid size ( != 0 ) only if item has a newer version in store.
 * @details This function doesn't request an update to be started for the item.
 */
- (NSInteger)getUpdateSize;

/**
 * Returns the update size string formatted ( if an update is available for this item ).
 * @details The function will return a valid size ( != 0 ) only if item has a newer version in store.
 * @details This function doesn't request an update to be started for the item.
 */
- (nonnull NSString *)getUpdateSizeFormatted;

/**
 * Returns the update version string ( if an update is available for this item ).
 * @details The function will return a valid version ( != 0 ) only if item has a newer version in store.
 * @details The function doesn't request an update to be started for the item
 */
- (nonnull NSString *)getUpdateVersion;

/**
 * Returns true if the content store object style is dark.
 */
- (BOOL)isNightStyle;

@end

NS_ASSUME_NONNULL_END
