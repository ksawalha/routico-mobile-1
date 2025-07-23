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
#import <GEMKit/MapViewHeader.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * An object that manages map view route render settings.
 */
__attribute__((visibility("default"))) @interface MapViewRouteRenderSettings : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * The traveled route highlight options.
 * @details Please check MapViewRouteRenderOption.
 */
@property(nonatomic, assign) int options;

/**
 * The traveled route contour inner color.
 */
@property(nonatomic, strong) UIColor *contourInnerColor;

/**
 * The traveled route contour outer color.
 */
@property(nonatomic, strong) UIColor *contourOuterColor;

/**
 * The traveled route contour inner size in mm.
 */
@property(nonatomic, assign) double contourInnerSize;

/**
 * The traveled route contour outer ( border ) size in mm.
 */
@property(nonatomic, assign) double contourOuterSize;

/**
 * The traveled route part inner color.
 */
@property(nonatomic, strong) UIColor *traveledInnerColor;

/**
 * The turn arrow inner color.
 */
@property(nonatomic, strong) UIColor *turnArrowInnerColor;

/**
 * The turn arrow outer color.
 */
@property(nonatomic, strong) UIColor *turnArrowOuterColor;

/**
 * The turn arrow inner size ( mm ).
 */
@property(nonatomic, assign) double turnArrowInnerSize;

/**
 * The turn arrow outer size ( mm ).
 */
@property(nonatomic, assign) double turnArrowOuterSize;

/**
 * The route bubble label icon size in mm ( default value from current style ).
 */
@property(nonatomic, assign) double imageSize;

/**
 * The route bubble label text size in mm ( default value from current style ).
 */
@property(nonatomic, assign) double textSize;

/**
 * The route bubble label text color.
 */
@property(nonatomic, strong) UIColor *textColor;

/**
 * The route waypoint label text size in mm ( default value from current style ).
 */
@property(nonatomic, assign) double waypointTextSize;

/**
 * The route waypoint image size in mm ( default value from current style ).
 */
@property(nonatomic, assign) double waypointImageSize;

/**
 * The route waypoint text inner color.
 */
@property(nonatomic, strong) UIColor *waypointTextInnerColor;

/**
 * The route waypoint text outer color.
 */
@property(nonatomic, strong) UIColor *waypointTextOuterColor;

/**
 * The direction arrow width ( mm ).
 */
@property(nonatomic, assign) double directionArrowSize;

/**
 * The direction arrow inner color.
 */
@property(nonatomic, strong) UIColor *directionArrowInnerColor;

/**
 * The direction arrow outer color.
 */
@property(nonatomic, strong) UIColor *directionArrowOuterColor;

/**
 * The route fill color ( only for RouteResultType Range ).
 * @details If not specified the Sdk will use the innerColor with a default alpha channel.
 */
@property(nonatomic, strong) UIColor *fillColor;

/**
 * The route line type.
 */
@property(nonatomic, assign) RouteLineType lineType;

@end

NS_ASSUME_NONNULL_END
