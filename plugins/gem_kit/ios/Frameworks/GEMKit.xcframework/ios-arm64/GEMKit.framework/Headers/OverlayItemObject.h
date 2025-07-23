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
#import <GEMKit/GenericHeader.h>
#import <GEMKit/OverlayHeader.h>
#import <GEMKit/CoordinatesObject.h>
#import <GEMKit/OverlayInfoObject.h>
#import <GEMKit/SearchableParameterListObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates overlay item information.
 */
__attribute__((visibility("default"))) @interface OverlayItemObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the unique ID of the item within the overlay.
 */
- (NSInteger)getUid;

/**
 * Returns the parent overlay UID.
 */
- (NSInteger)getOverlayUid;

/**
 * Get the parent overlay info.
 */
- (nullable OverlayInfoObject *)getOverlayInfo;

/**
 * Returns the overlay item coordinates.
 */
- (nullable CoordinatesObject*)getCoordinates;

/**
 * Returns the name of the item.
 */
- (nonnull NSString *)getName;

/**
 * Returns the image of the item.
 * @param height The image height in pixels.
 * @details Aspect ratio is taking into consideration. The image is cached after first render.
 */
- (nullable UIImage *)getAspectRatioImage:(CGFloat)height;

/**
 * Returns the image of the item.
 * @param height The image height in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 * @details Aspect ratio is taking into consideration. The image is cached after first render.
 */
- (nullable UIImage *)getAspectRatioImage:(CGFloat)height scale:(CGFloat)scale ppi:(NSInteger)ppi;

/**
 * Returns the image of the item.
 * @param size The image size in pixels.
 */
- (nullable UIImage *)getImage:(CGSize)size;

/**
 * Returns the image of the item.
 * @param size The image size in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 * @details The image is cached after first render.
 */
- (nullable UIImage *)getImage:(CGSize)size scale:(CGFloat)scale ppi:(NSInteger)ppi;

/**
 * Returns the preview URL for the item (if any).
 * @details The preview URL may be opened by the UI into a web browser window to present more details to the user about this item.
 * @param webViewSize is the size of the web view window.
 * @return empty if the item has no preview URL.
 */
- (nullable NSURL *)getPreviewUrl;

/**
 * Returns the overlay item preview data.
 * @param  type The preview data format.
 * @return The preview data in the given type format.
 */
- (nonnull NSString *)getPreviewData:(PreviewDataType)type;

/**
 * Returns the value for the social report overlay item preview data parameter type.
 */
- (nullable NSValue *)searchInPreviewDataSocialReportParameterType:(SocialReportParameterType)parameterType;

/**
 * Returns the value for the safety camera overlay item preview data parameter type.
 */
- (nullable NSValue *)searchInPreviewDataSafetyCameraParameterType:(SafetyCameraParameterType)parameterType;

/**
 * Check if this type has preview EXTENDED data ( dynamic data that needs to be downloaded ).
 */
- (BOOL)hasPreviewExtendedData;

/**
 * Asynchronous get preview extended data ( dynamic data that needs to be downloaded ) as parameters list.
 * @param  parametersList The list that will be populated with the preview extended data once it is downloaded.
 */
- (void)getPreviewExtendedDataWithCompletionHandler:(nonnull void(^)(SearchableParameterListObject *parametersList))handler;

/**
 * Cancel an asynchronous get preview extended data.
 */
- (void)cancelGetPreviewExtendedDataWithCompletionHandler:(nonnull void(^)(BOOL finished))handler;

/**
 * Get OverlayItem category id.
 * @return The overlay category id if exist otherwise 0.
 */
- (int)getCategoryId;

/**
 * Reset cache image.
 */
- (void)resetCacheImage;

@end

NS_ASSUME_NONNULL_END
