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
#import <GEMKit/MarkerObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Constants indicating the marker collection type.
 */
typedef NS_ENUM(NSInteger, MarkerCollectionType)
{
    /// Multi-points marker.
    MarkerCollectionTypePoint = 0,
    
    /// Polyline marker.
    MarkerCollectionTypePolyline,
    
    /// Polygon marker.
    MarkerCollectionTypePolygon,
    
    /// Area marker. Same sahe as polygon with a layer position on top of map view areas stack
    MarkerCollectionTypeArea
};

/**
 * This class encapsulates marker collection information.
 */
__attribute__((visibility("default"))) @interface MarkerCollectionObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data..
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Initializes and returns a newly allocated object using the name and type.
 */
- (instancetype)initWithName:(nonnull NSString *)name type:(MarkerCollectionType)type;

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the collection id.
 */
- (NSInteger)getId;

/**
 * Returns the collection type.
 */
- (MarkerCollectionType)getType;

/**
 * Returns the collection name.
 */
- (nonnull NSString *)getName;

/**
 * Returns the collection size.
 */
- (int)getSize;

/**
 * Returns the marker at the given index.
 */
- (nullable MarkerObject *)getMarkerAt:(int)index;

/**
 * Returns the marker with the given identifier.
 */
- (nullable MarkerObject *)getMarkerById:(int)identifier;

/**
 * Returns the index of the given marker.
 */
- (int)indexOf:(nonnull MarkerObject*)marker;

/**
 * Add a new marker to collection.
 */
- (void)addMarker:(nonnull MarkerObject*)marker;

/**
 * Add a new marker to collection at the given index.
 */
- (void)addMarker:(nonnull MarkerObject*)marker atIndex:(int)index;

/**
 * Remove the marker from collection at the given index.
 */
- (void)deleteMarkerAtIndex:(int)index;

/**
 * Remove all markers.
 */
- (void)clear;

/**
 * Get whole collection enclosing area.
 */
- (nullable RectangleGeographicAreaObject *)getArea;

/**
 * Set the polyline inner color.
 */
- (void)setInnerColor:(nonnull UIColor *)color;

/**
 * Set the polyline outer color.
 */
- (void)setOuterColor:(nonnull UIColor *)color;

/**
 * Set the polyline inner size ( in millimeters ).
 */
- (void)setInnerSize:(double)size;

/**
 * Set the polyline outer size ( in millimeters ).
 */
- (void)setOuterSize:(double)size;

/**
 * Set the polygon fill color.
 */
- (void)setFillColor:(nonnull UIColor *)color;

/**
 * Returns the polyline inner color.
 */
- (nonnull UIColor *)getInnerColor;

/**
 * Returns the polyline outer color.
 */
- (nonnull UIColor *)getOuterColor;

/**
 * Returns the polyline inner size ( in millimeters ).
 */
- (double)getInnerSize;

/**
 * Returns the polyline outer size ( in millimeters ).
 */
- (double)getOuterSize;

/**
 * Returns the polygon fill color.
 */
- (nonnull UIColor *)getFillColor;

/**
 * Set the point image.
 */
- (void)setPointImage:(nonnull UIImage*)image;

/**
 * Returns the point image.
 */
- (nullable UIImage*)getPointImage;

/**
 * Set the min visibility zoom levels for markers collection render settings.
 */
- (void)setMinVisibilityZoomLevel:(int)value;

/**
 * Get the min visibility zoom levels for markers collection render settings.
 */
- (int)getMinVisibilityZoomLevel;

/**
 * Set the max visibility zoom levels for markers collection render settings.
 */
- (void)setMaxVisibilityZoomLevel:(int)value;

/**
 * Get the max visibility zoom levels for markers collection render settings.
 */
- (int)getMaxVisibilityZoomLevel;

@end

NS_ASSUME_NONNULL_END
