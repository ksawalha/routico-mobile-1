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

/**
 * Constants indicating image file formats.
 */
typedef NS_ENUM(NSInteger, ImageFormat)
{
    /// Bmp format.
    ImageFormatBmp,
    
    /// Jpeg format.
    ImageFormatJpeg,
    
    /// Gif format.
    ImageFormatGif,
    
    /// Png format.
    ImageFormatPng,
    
    /// Tga format.
    ImageFormatTga,
    
    /// WebP format format.
    ImageFormatWebP,
    
    /// Auto-Detect format.
    ImageFormatAutoDetect
};

/**
 * Constants indicating the type of a navigation image
 */
typedef NS_ENUM(NSInteger, ImageType)
{
    /// Base type, result of ImageDatabase::getImageById
    ImageTypeBase,
    
    /// Abstract geometry type.
    ImageTypeAbstractGeometry,
    
    /// Road info type.
    ImageTypeRoadInfo,
    
    /// Signpost type.
    ImageTypeSignpost,
    
    /// Lane info type.
    ImageTypeLaneInfo
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates image object information.
 */
__attribute__((visibility("default"))) @interface ImageObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Initializes and returns a newly allocated object using the data buffer and format.
 */
- (instancetype)initWithDataBuffer:(nonnull NSData *)data format:(ImageFormat)format;

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the type of the image.
 */
- (ImageType)getType;

/**
 * Returns the unique ID of the image.
 */
- (unsigned)getUid;

/**
 * Renders the image.
 * @param size The size in pixels.
 */
- (nullable UIImage*)renderImageWithSize:(CGSize)size;

/**
 * Renders the image.
 * @param size The size in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 */
- (nullable UIImage*)renderImageWithSize:(CGSize)size scale:(CGFloat)scale ppi:(NSInteger)ppi;

/**
 * Returns the image of the item.
 * @param height The image height in pixels.
 * @details Aspect ratio is taking into consideration.
 */
- (nullable UIImage *)renderAspectRatioImage:(CGFloat)height;

/**
 * Returns the image of the item.
 * @param height The image height in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 * @details Aspect ratio is taking into consideration.
 */
- (nullable UIImage *)renderAspectRatioImage:(CGFloat)height scale:(CGFloat)scale ppi:(NSInteger)ppi;

/**
 * Returns the size of the image.
 */
- (CGSize)getSize;

/**
 * Returns the aspect ratio of the image.
 * @details If width > height return ( width / height, 1.f ). If width < height return ( 1.f, height / width ).
 */
- (CGSize)getAspectRatio;

/**
 * Check if icon is scalable ( i.e. it has vectorial format ).
 */
- (BOOL)isScalable;

/**
 * Check the validity of the Image.
 */
- (BOOL)isValid;

@end

NS_ASSUME_NONNULL_END
