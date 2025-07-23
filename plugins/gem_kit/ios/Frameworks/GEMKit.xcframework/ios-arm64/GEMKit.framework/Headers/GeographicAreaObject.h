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

/**
 * Constants indicating the types of geographic areas.
 */
typedef NS_ENUM(NSInteger, GeographicAreaType)
{
    /// @brief Undefined.
    GeographicAreaTypeUndefined = 0,
    
    /// @brief Circle area.
    GeographicAreaTypeCircle,
    
    /// @brief Rectangle area.
    GeographicAreaTypeRectangle,
    
    /// @brief Polygon area.
    GeographicAreaTypePolygon,
    
    /// @brief Area represented as a collection of tiles.
    GeographicAreaTypeTileCollection,
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates geographic area information.
 */
__attribute__((visibility("default"))) @interface GeographicAreaObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the type of the geographic area.
 */
- (GeographicAreaType)getType;

/**
 * Returns true if the provided point is contained by the geographic area.
 */
- (BOOL)containsCoordinates:(nonnull CoordinatesObject *)location;

/**
 * Returns the center of the geographic area.
 */
- (nonnull CoordinatesObject *)getCenterPoint;

/**
 * Check if two geographic areas are equal.
 */
- (BOOL)equals:(nonnull GeographicAreaObject *)geoArea;

/**
 * Check if this is a default object ( nothing was modified on it since creation ).
 */
- (BOOL)isDefault;

/**
 * Check empty area.
 */
- (BOOL)isEmpty;

/**
 * Reset the object to default.
 */
- (void)reset;

@end

NS_ASSUME_NONNULL_END
