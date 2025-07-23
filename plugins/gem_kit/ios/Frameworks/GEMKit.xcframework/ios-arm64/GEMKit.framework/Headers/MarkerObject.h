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
#import <GEMKit/CoordinatesObject.h>
#import <GEMKit/GeographicAreaObject.h>
#import <GEMKit/RectangleGeographicAreaObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates marker information.
 */
__attribute__((visibility("default"))) @interface MarkerObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data..
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Initializes and returns a newly allocated object using the array coordinates.
 */
- (instancetype)initWithCoordinates:(nonnull NSArray <CoordinatesObject *> *)array;

/**
 * Initializes and returns a newly allocated object using the center coordinates and the radius in meters.
 */
- (instancetype)initWithCircleCenter:(nonnull CoordinatesObject*)coordinates radius:(int)radius;

/**
 * Initializes and returns a newly allocated object using the center coordinates and the horizontal and vertical rectangle radius in meters.
 */
- (instancetype)initWithRectangleShapeCenter:(nonnull CoordinatesObject *)coordinates horizRadius:(int)horizRadius vertRadius:(int)vertRadius;

/**
 * Initializes and returns a newly allocated object using the rectangle coordinates corners.
 */
- (instancetype)initWithRectangleFirstCorner:(nonnull CoordinatesObject *)corner1 secondCorner:(nonnull CoordinatesObject*)corner2;

/**
 * Initializes and returns a newly allocated object using the geographic area.
 */
- (instancetype)initWithGeographicArea:(nonnull GeographicAreaObject *)area;

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the marker unique id.
 */
- (NSInteger)getId;

/**
 * Returns the marker parts count.
 */
- (NSInteger)getPartCount;

/**
 * Delete a part from marker.
 */
- (void)deletePart:(int)part;

/**
 * Returns the marker coordinates array.
 */
- (nonnull NSArray <CoordinatesObject *> *)getCoordinates;

/**
 * Returns the marker coordinates array.
 * @param part The marker part index to which the function applies, default 0 ( first part ).
 */
- (nonnull NSArray <CoordinatesObject *> *)getCoordinates:(int)part;

/**
 * Returns the first part marker enclosing area.
 */
- (nonnull RectangleGeographicAreaObject *)getArea;

/**
 * Returns the marker part enclosing area.
 * @param part The marker part index to which the function applies.
 */
- (nonnull RectangleGeographicAreaObject *)getPartArea:(int)part;

/**
 * Set marker first part coordinates.
 * @param array The coordinates array to be set.
 */
- (void)setCoordinates:(nonnull NSArray < CoordinatesObject*> *)array;

/**
 * Set marker part coordinates.
 * @param array The coordinates array to be set.
 * @param part The marker part index to which the function applies.
 */
- (void)setCoordinates:(nonnull NSArray < CoordinatesObject*> *)array part:(int)part;

/**
 * Append at the end a new coordinate to the marker.
 * @param location The coordinate object.
 * @details If part == getPartCount, a new part is automatically added to the marker and the coordinate is assigned to it.
 */
- (void)add:(nonnull CoordinatesObject *)location;

/**
 * Add a new coordinate to the marker.
 * @param location The coordinate object.
 * @param index The position where the coordinate is added, default -1 ( append at the end ).
 * @param part The marker part index to which the function applies, default 0 ( first part )
 * @details If part == getPartCount, a new part is automatically added to the marker and the coordinate is assigned to it.
 */
- (void)add:(nonnull CoordinatesObject *)location index:(int)index part:(int)part;

/**
 * Delete a coordinate from the marker.
 * @param index The position of the deleted coordinate.
 * @param part The marker part index to which the function applies, default 0 ( first part ).
 */
- (void)deleleFromIndex:(int)index part:(int)part;

/**
 * Update a coordinate in the marker.
 * @param location The new coordinate value.
 * @param index The position of the updated coordinate.
 * @param part The marker part index to which the function applies.
 */
- (void)update:(nonnull CoordinatesObject *)location index:(int)index part:(int)part;

/**
 * Returns the marker name.
 */
- (nonnull NSString *)getName;

/**
 * Set marker name.
 */
- (void)setName:(nonnull NSString *)name;

@end

NS_ASSUME_NONNULL_END
