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
#import <GEMKit/TurnDetailsHeader.h>
#import <GEMKit/AbstractGeometryObject.h>
#import <GEMKit/AbstractGeometryImageObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates turn details information.
 */
__attribute__((visibility("default"))) @interface TurnDetailsObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the turn info type.
 */
- (TurnType)getEvent;

/**
 * Returns the abstract geometry of the turn.
 */
- (nullable AbstractGeometryObject *)getAbstractGeometry;

/**
 * Returns the abstract geometry image of the turn.
 */
- (nullable AbstractGeometryImageObject *)getAbstractGeometryImage;

/**
 * Returns the roundabout exit number. -1 when no roundabout exit number.
 */
- (int)getRoundaboutExitNumber;

/**
 * Returns the image for the turn.
 * @param size The size in pixels.
 * @param colorActiveIn The inner active color.
 * @param colorActiveOut The outer active color.
 * @param colorInactiveIn The inner inactive color.
 * @param colorInactiveOut The outer inactive color.
 */
- (nullable UIImage *)getTurnImage:(CGSize)size colorActiveInner:(nonnull UIColor*)colorActiveIn colorActiveOuter:(nonnull UIColor*)colorActiveOut colorInactiveInner:(nonnull UIColor*)colorInactiveIn colorInactiveOuter:(nonnull UIColor*)colorInactiveOut;

/**
 * Returns the turn image id.
 */
- (int)getTurnImageId;

/**
 * Returns the turn simplified 32 id.
 */
- (TurnSimplifiedType32)getTurnId32;

/**
 * Returns the turn simplified 64 id.
 */
- (TurnSimplifiedType64)getTurnId64;

@end

NS_ASSUME_NONNULL_END

