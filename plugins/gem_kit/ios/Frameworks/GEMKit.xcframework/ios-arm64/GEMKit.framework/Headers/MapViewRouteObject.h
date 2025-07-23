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
#import <GEMKit/RouteObject.h>
#import <GEMKit/MapViewRouteRenderSettings.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates route information.
 */
__attribute__((visibility("default"))) @interface MapViewRouteObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the route object.
 */
- (nullable RouteObject *)getRoute;

/**
 * Sets the route object.
 */
- (void)setRoute:(nonnull RouteObject *)routeObject;

/**
 * Returns the route label text.
 */
- (nonnull NSString *)getLabelText;

/**
 * Sets the route label text.
 */
- (void)setLabelText:(nonnull NSString *)text;

/**
 * Returns the route label images.
 */
- (nonnull NSArray <ImageObject *> *)getLabelImages;

/**
 * Sets the route label images.
 */
- (void)setLabelImages:(nonnull NSArray <ImageObject *> *)array;

/**
 * Hides the route label.
 */
- (void)hideRouteLabel;

/**
 * Returns the map view route render settings.
 */
- (nonnull MapViewRouteRenderSettings *)getRenderSettings;

/**
 * Set the map view route render settings.
 */
- (void)setRenderSettings:(nonnull MapViewRouteRenderSettings *)settings;

@end

NS_ASSUME_NONNULL_END
