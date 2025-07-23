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
#import <GEMKit/ImageObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates image db object information.
 */
__attribute__((visibility("default"))) @interface ImageDatabaseObject : NSObject

/**
 * Returns the image by providing the ID.
 */
- (nullable ImageObject *)getImageById:(unsigned)identifier;

/**
 * Returns the image by providing the image index.
 */
- (nullable ImageObject *)getImageByIndex:(int)index;

/**
 * Returns the number of images.
 */
- (int)getImageCount;

/**
 * Import a new image. The supported formats are: PNG.
 */
- (void)import:(nonnull UIImage *)image;

/**
 * Remove an image from the database by providing the ID.
 * @note Only images imported with Image::import function can be deleted.
 */
- (BOOL)removeImageWithIndex:(int)imageId;

/**
 * Get default green pin image object.
 */
- (nullable ImageObject *)getPinStartImage;

/**
 * Get default red pin image object.
 */
- (nullable ImageObject *)getPinStopImage;

@end

NS_ASSUME_NONNULL_END
