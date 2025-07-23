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
#import <GEMKit/RectangleGeographicAreaObject.h>

/**
 * Constants indicating the path import supported formats.
 */
typedef NS_ENUM(NSInteger, PathFileFormat)
{
    /// GPX
    PathFileFormatGpx = 0,
    
    /// KML
    PathFileFormatKml,
    
    /// NMEA
    PathFileFormatNmea,
    
    /// GeoJson
    PathFileFormatGeoJson,
    
    /// Latitude, Longitude lines in txt file ( debug purposes )
    PathFileFormatLatLonTxt,
    
    /// Longitude Latitude lines in txt file ( debug purposes )
    PathFileFormatLonLatTxt,
    
    /// Packed geometry
    PathFileFormatPackedGeometry
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates path information.
 */

__attribute__((visibility("default"))) @interface PathObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Initializes and returns a newly allocated object using the data buffer path of a given format.
 */
- (instancetype)initWithDataBuffer:(nonnull NSData *)data format:(PathFileFormat)format;

/**
 * Initializes and returns a newly allocated object using the location array coordinates.
 */
- (instancetype)initWithCoordinates:(nonnull NSArray <CoordinatesObject *> *)coordinates;

/**
 * Returns read-only access to the internal coordinates list.
 */
- (nonnull NSArray <CoordinatesObject *> *)getCoordinates;

/**
 * Returns read-only access to the internal waypoint list.
 */
- (nonnull NSArray <NSNumber *> *)getWayPoints;

/**
 * Returns the path rectangle area.
 */
- (nullable RectangleGeographicAreaObject *)getArea;

/**
 * Get path length.
 */
- (int)getLength;

/**
 * Returns the path name.
 */
- (nonnull NSString*)getName;

/**
 * Set the path name.
 */
- (void)setName:(nonnull NSString*)name;

/**
 * Clone path from the given coordinate.
 */
- (nullable PathObject *)cloneStartEnd:(nonnull CoordinatesObject *)startLocation endLocation:(nonnull CoordinatesObject *)endLocation;

/**
 * Clone reverse order path.
 */
- (nullable PathObject *)cloneReverse;

/**
 * Export path coordinates in the requested data format.
 * @param format Data format, see PathFileFormat
 */
- (nullable NSData *)exportAs:(PathFileFormat)format;

/**
 * Gets a coordinate on path from at the given percent.
 * @param percent Value between 0 and 1.
 */
- (nullable CoordinatesObject *)getCoordinatesAtPercent:(double)percent;

@end

NS_ASSUME_NONNULL_END
