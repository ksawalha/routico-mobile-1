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
#import <GEMKit/GeographicAreaObject.h>
#import <GEMKit/RectangleGeographicAreaObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates polygon geographic area information.
 */
__attribute__((visibility("default"))) @interface PolygonGeographicAreaObject : GeographicAreaObject

/**
 * Initializes and returns a newly allocated object using the coordinates array.
 * @param array The coordinates array.
 */
- (instancetype)initWithCoordinates:(nonnull NSArray <CoordinatesObject *> *)array;

/**
 * Get the coordinates of the polygon.
 */
- (nonnull NSArray <CoordinatesObject *> *)getCoordinates;

/**
 * Sets the coordinates that define the polygon.
 */
- (void)setCoordinates:(nonnull NSArray <CoordinatesObject *> *)array;

/**
 * Get the bounding box. This is the smallest rectangle that can be drawn around the area such that it surrounds this geographic area completely.
 * @details If the area is bigger than what is allowed in the WGS 84 coordinate system, the rectangle is truncated to valid WGS 84 coordinate values. 
 * The RectangleGeographicArea is always aligned with parallels and meridians.
 */
- (nullable RectangleGeographicAreaObject *)getBoundingBox;

@end

NS_ASSUME_NONNULL_END
