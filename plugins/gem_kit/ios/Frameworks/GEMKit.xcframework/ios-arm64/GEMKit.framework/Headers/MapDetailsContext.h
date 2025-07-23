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
#import <GEMKit/ImageObject.h>
#import <GEMKit/RectangleGeographicAreaObject.h>

/**
 * Constants indicating the map coverage.
 */
typedef NS_ENUM(NSInteger, MapCoverage)
{
    /// There is country map available on the device. No connection required.
    MapCoverageOffline,
    
    /// There is map content (detailed tile) available on the device. No connection required.
    MapCoverageOnlineTile,
    
    /// There is map content available but not on device. Server connection required.
    MapCoverageOnlineNoData,
    
    /// There is no map coverage available on device and cannot determine if there exists content on the server.
    MapCoverageUnknown,
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates map details information.
 */
__attribute__((visibility("default"))) @interface MapDetailsContext : NSObject

/**
 * Returns the map coverage for the region specified by WGS84 coordinates.
 * @details This function checks only using the information available on device. No server connection is performed.
 */
- (MapCoverage)getMapCoverage:(nonnull CoordinatesObject *)location;

/**
 * Returns the map coverage for the country specified by ISO 3166-1 alpha-3 country code.
 * @details This function checks only using the information available on device. No server connection is performed.
 * @return MapCoverageOffline - Entire country map is available on the device.
 * @return MapCoverageOnlineNoData - Country map is available but not all tiles are on the device.
 * @return MapCoverageUnknown - No map coverage available on device and cannot determine if there.
 */
- (MapCoverage)getCountryMapCoverage:(nonnull NSString*)isoCode;

/**
 * Returns the country name for the specified WGS.
 */
- (nonnull NSString *)getCountryNameWithLocation:(nonnull CoordinatesObject *)location;

/**
 * Returns the country name for the specified index.
 * @param index Country index.
 */
- (nonnull NSString *)getCountryNameWithIndex:(unsigned int)index;

/**
 * Returns the ISO 3166-1 alpha-3 country code for the specified WGS.
 * @details Empty string means no country.
 */
- (nonnull NSString *)getCountryCodeWithCoordinates:(nonnull CoordinatesObject *)location;

/**
 * Returns the ISO 3166-1 alpha-3 country code for the specified index.
 * @details Empty string means no country.
 * See: http://en.wikipedia.org/wiki/ISO_3166-1 for the list of codes.
 */
- (nonnull NSString *)getCountryCodeWithIndex:(unsigned int)index;

/**
 * Returns the country image for the specified index.
 */
- (nullable ImageObject *)getCountryImage:(unsigned int)index;

/**
 * Returns the language codes for the specified WGS.
 * @details Empty list means no coordinates match.
 * See: https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes for the list of codes.
 */
- (nonnull NSArray <NSString *> *)getLanguageCodesWithCoordinates:(nonnull CoordinatesObject *)location;

/**
 * Returns the country name for the isoCode.
 * @param isoCode ISO 3166-1 alpha-3 country code.
 */
- (nonnull NSString *)getCountryNameWithIsoCode:(nonnull NSString *)isoCode;

/**
 * Returns the country flag for the isoCode.
 * @param isoCode ISO 3166-1 alpha-3 country code.
 */
- (nullable ImageObject *)getCountryFlag:(nonnull NSString *)isoCode;

/**
 * Returns the country bounding rectangle for the isoCode.
 * @param isoCode ISO 3166-1 alpha-3 country code.
 * @return Country bounding rectangle.
 */
- (nullable RectangleGeographicAreaObject *)getCountryBoundingRectangle:(nonnull NSString *)isoCode;

/**
 * Check if it is night at the specified coordinated.
 * @param location WGS Coordinates.
 */
- (BOOL)isNight:(nonnull CoordinatesObject *)location;

/**
 * Returns country data count.
 */
- (int)getCountryDataCount;

@end

NS_ASSUME_NONNULL_END
