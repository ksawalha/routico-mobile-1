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
#import <GEMKit/OverlayItemObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates overlay item position information.
 */
__attribute__((visibility("default"))) @interface OverlayItemPositionObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the overlay item object.
 */
- (nonnull OverlayItemObject *)getOverlayItem;

/**
 * Returns the distance in meters from reference coordinates to the overlay item object.
 */
- (int)getDistance;

@end

NS_ASSUME_NONNULL_END
