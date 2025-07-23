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

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates abstract geometry item information.
 */
__attribute__((visibility("default"))) @interface AbstractGeometryItemObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Get the shape form.
 */
- (RoadShapeFormType)getShapeForm;

/**
 * Get the shape type.
 */
- (RoadShapeType)getShapeType;

/**
 * Get the shape arrow type.
 */
- (ShapeArrowType)getArrowType;

/**
 * Get the shape restriction type.
 */
- (ShapeRestrictionType)getRestrictionType;

/**
 * Get the slot the shape begin is attached to the anchor.
 * @param highDefinition Enable high definition mode ( more slots ). Default false.
 * @details The begin slot references the position where the begin shape is attached to the anchor,
 * HD mode = false : 12 slots are possible, -1 indicates N/A.
 * HD mode = true : 16 slots are possible, -1 indicates N/A.
 * @details The numbers indicate position similar to a clock face.
 */
- (int)getBeginSlot:(BOOL)highDefinition;

/**
 * Get the arrow direction at the begin.
 */
- (ShapeArrowDirectionType)getBeginArrowDirection;

/**
 * Get the slot the shape end is attached to the anchor.
 * @param highDefinition Enable high definition mode (more slots). Default false.
 * @details The begin slot references the position where the end shape is attached to the anchor,
 * 12 slots are possible, -1 indicates N/A. The numbers indicate position similar to a clock face.
 * @details CircleSegment follows the circle from begin to end slot. Line spans over the circle from begin to end slot. The numbers indicate position similar to a clock face.
 */
- (int)getEndSlot:(BOOL)highDefinition;

/**
 * Get the arrow direction at the end.
 */
- (ShapeArrowDirectionType)getEndArrowDirection;

/**
 * Get the slot allocation.
 * @details The slot allocation indicates how many shapes are occupying a slot.
 */
- (int)getSlotAllocation;

@end

NS_ASSUME_NONNULL_END
