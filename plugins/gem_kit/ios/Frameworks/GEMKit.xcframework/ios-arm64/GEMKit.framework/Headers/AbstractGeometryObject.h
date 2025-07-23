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
#import <GEMKit/GenericHeader.h>
#import <GEMKit/AbstractGeometryItemObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates abstract geometry information.
 */
__attribute__((visibility("default"))) @interface AbstractGeometryObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Get the anchor type.
 */
- (RoadAnchorType)getAnchorType;

/**
 * Get the drive side.
 */
- (DriveSideType)getDriveSide;

/**
 * Get the list with AbstractGeometryItemObject elements.
 */
- (nonnull NSArray <AbstractGeometryItemObject *> *)getItems;

/**
 * Get the number of left side intermediate turns.
 */
- (int)getLeftIntermediateTurns;

/**
 * Get the number of right side intermediate turns.
 */
- (int)getRightIntermediateTurns;

@end

NS_ASSUME_NONNULL_END
