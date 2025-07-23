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

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates abstract geometry image information.
 */
__attribute__((visibility("default"))) @interface AbstractGeometryImageObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the schematic image of the next turn.
 * @param size The size in pixels.
 * @param colorActiveIn The inner active color.
 * @param colorActiveOut The outer active color.
 * @param colorInactiveIn The inner inactive color.
 * @param colorInactiveOut The outer inactive color.
 */
- (nullable UIImage*)getImage:(CGSize)size
                     colorActiveInner:(nonnull UIColor*)colorActiveIn
                     colorActiveOuter:(nonnull UIColor*)colorActiveOut
                   colorInactiveInner:(nonnull UIColor*)colorInactiveIn
                   colorInactiveOuter:(nonnull UIColor*)colorInactiveOut;


/**
 * Returns the render abstract geometry image.
 * @param size The size in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 * @param colorActiveIn The inner active color.
 * @param colorActiveOut The outer active color.
 * @param colorInactiveIn The inner inactive color.
 * @param colorInactiveOut The outer inactive color.
 */
- (nullable UIImage*)getImage:(CGSize)size
                        scale:(CGFloat)scale
                          ppi:(NSInteger)ppi
             colorActiveInner:(nonnull UIColor*)colorActiveIn
             colorActiveOuter:(nonnull UIColor*)colorActiveOut
           colorInactiveInner:(nonnull UIColor*)colorInactiveIn
           colorInactiveOuter:(nonnull UIColor*)colorInactiveOut;

@end

NS_ASSUME_NONNULL_END
