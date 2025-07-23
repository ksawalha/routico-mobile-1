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

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates rectangle geographic area information.
 */
__attribute__((visibility("default"))) @interface RectangleGeographicAreaObject : GeographicAreaObject

/**
 * Initializes and returns a newly allocated object using location, horizontal and vertical radius.
 * @param location The geographical location.
 * @param horizRadius The horizontal radius in meters.
 * @param vertRadius The vertical radius in meters.
 */
- (instancetype)initWithLocation:(nonnull CoordinatesObject *)location horizontalRadius:(double)horizRadius verticalRadius:(double)vertRadius;

/**
 * Returns the coordinates for the top left point.
 */
- (nullable CoordinatesObject *)getTopLeft;

/**
 * Returns the coordinates for the bottom right point.
 */
- (nullable CoordinatesObject *)getBottomRight;

/**
 * Set the coordinates for the top-left point.
 */
- (void)setTopLeft:(nonnull CoordinatesObject*)location;

/**
 * Set the coordinates for the bottom-right point.
 */
- (void)setBottomRight:(nonnull CoordinatesObject*)location;

/**
 * Set the rectangle given by individual latitudes and longitudes.
 */
- (void)setRectangle:(double)minLatitude maxLatitude:(double)maxLatitude minLongitude:(double)minLongitude maxLongitude:(double)maxLongitude;

/**
 * Set the rectangle given by individual latitudes and longitudes.
 */
- (void)setRectangle:(nonnull CoordinatesObject*)location horizRadius:(double)horizRadius vertRadius:(double)vertRadius;

/**
 * Check if intersects with the given rectangle geographic area.
 */
- (BOOL)intersects:(nonnull RectangleGeographicAreaObject *)rectangle;

/**
 * Check if contains the given rectangle geographic area.
 */
- (BOOL)contains:(nonnull RectangleGeographicAreaObject *)rectangle;

/**
 * Set the current object as the intersection with the given rectangle geographic area.
 */
- (void)setIntersection:(nonnull RectangleGeographicAreaObject *)rectangle;

/**
 * Create a new area as the result of intersection with the given rectangle geographic area.
 */
- (nullable RectangleGeographicAreaObject *)makeIntersection:(nonnull RectangleGeographicAreaObject *)rectangle;

/**
 * Create a new area as the result of union with the given rectangle geographic area.
 */
- (nullable RectangleGeographicAreaObject *)makeUnion:(nonnull RectangleGeographicAreaObject *)rectangle;

/**
 * Get the bounding box. This is the smallest rectangle that can be drawn around the area such that it surrounds this geographic area completely.
 * @details If the area is bigger than what is allowed in the WGS 84 coordinate system, the rectangle is truncated to valid WGS 84 coordinate values. 
 * The RectangleGeographicArea is always aligned with parallels and meridians.
 */
- (nullable RectangleGeographicAreaObject *)getBoundingBox;

@end

NS_ASSUME_NONNULL_END
