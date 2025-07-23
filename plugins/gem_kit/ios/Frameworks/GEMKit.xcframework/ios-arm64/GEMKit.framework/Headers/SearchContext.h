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
#import <GEMKit/LandmarkObject.h>
#import <GEMKit/RouteObject.h>
#import <GEMKit/LandmarkCategoryObject.h>
#import <GEMKit/LandmarkStoreContextCollection.h>
#import <GEMKit/OverlayMutableCollectionObject.h>

/**
 * Constants indicating the address level type.
 */
typedef NS_ENUM(NSInteger, AddressLevelType)
{
    /// No address details available.
    AddressLevelTypeNoDetail,
    
    /// Country.
    AddressLevelTypeCountry,
    
    /// State or province.
    AddressLevelTypeState,
    
    /// County, which is an entity between a state and a city.
    AddressLevelTypeCounty,
    
    /// Municipal district.
    AddressLevelTypeDistrict,
    
    /// Town or city.
    AddressLevelTypeCity,
    
    /// Settlement.
    AddressLevelTypeSettlement,
    
    /// Zip or postal code.
    AddressLevelTypePostalCode,
    
    /// Street/road name.
    AddressLevelTypeStreet,
    
    /// Street section subdivision.
    AddressLevelTypeStreetSection,
    
    /// Street lane subdivision.
    AddressLevelTypeStreetLane,
    
    /// Street alley subdivision.
    AddressLevelTypeStreetAlley,
    
    /// Address field denoting house number.
    AddressLevelTypeHouseNumber,
    
    /// Address field denoting a street in a crossing.
    AddressLevelTypeCrossing
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class handles the search.
 */
__attribute__((visibility("default"))) @interface SearchContext : NSObject

/**
 * Start a search request for the given query and location.
 * @param query The query string.
 * @param location The location object.
 * @param handler The block to execute asynchronously with the search results.
 */
- (void)searchWithQuery:(nonnull NSString*)query location:(nonnull CoordinatesObject *)location completionHandler:(nonnull void(^)(NSArray<LandmarkObject *> *array))handler;

/**
 * Start a nearby search request.
 * @param location The location object.
 * @param handler The block to execute asynchronously with the search results.
 */
- (void)searchAroundWithLocation:(nonnull CoordinatesObject *)location completionHandler:(nonnull void(^)(NSArray<LandmarkObject *> *array))handler;

/**
 * Start a nearby search request.
 * @param query The query string.
 * @param location The location object.
 * @param handler The block to execute asynchronously with the search results.
 */
- (void)searchAroundWithQuery:(nonnull NSString*)query location:(nonnull CoordinatesObject *)location completionHandler:(nonnull void(^)(NSArray<LandmarkObject *> *array))handler;

/**
 * Start a search request along the specified route.
 * @param route The route object.
 * @param query The query string.
 * @param handler The block to execute asynchronously with the search results.
 */
- (void)searchAlongWithRoute:(nonnull RouteObject*)route query:(nonnull NSString*)query completionHandler:(nonnull void(^)(NSArray<LandmarkObject *> *array))handler;

/**
 * Stop a search request.
 */
- (void)cancelSearch;

/**
 * Set the max number of matches.
 */
- (void)setMaxMatches:(int)value;

/**
 * If set to true, only an exact match of free text search is returned as result.
 */
- (void)setExactMatch:(BOOL)value;

/**
 * If set to true, search is perform through the addresses.
 */
- (void)setSearchAddresses:(BOOL)value;

/**
 * Enable or disable search through geofences.
 */
- (void)setSearchGeofences:(BOOL)value;

/**
 * If set to true, search is perform through map POIs.
 */
- (void)setSearchMapPOIs:(BOOL)value;

/**
 * Get access to the searching settings for the landmark stores.
 */
- (nullable LandmarkStoreContextCollection *)getLandmarkStoreCollection;

/**
 * Get access to the search target overlays collection.
 */
- (nullable OverlayMutableCollectionObject *)geOverlayMutableCollection;

/**
 * If set to true, search will be done using only onboard data.
 */
- (void)setSearchOnlyOnboard:(BOOL)value;

/**
 * Get the flag for onboard search.
 */
- (BOOL)isSearchOnlyOnboardEnabled;

/**
 * Set the threshold distance.
 * @details This may be used to control the reverse geocoding and search along route lookup area.
 * @param threshold The threshold value.
 */
- (void)setThresholdDistance:(int)threshold;

/**
 * Get the threshold distance for the request.
 */
- (int)getThresholdDistance;

/**
 * Set the landmark category. Returns true if operation was successful.
 * @param category The landmark category object.
 */
- (BOOL)setCategory:(nonnull LandmarkCategoryObject*)category;

/**
 * Remove the landmark category. Returns true if operation was successful.
 * @param category The landmark category object.
 */
- (BOOL)removeCategory:(nonnull LandmarkCategoryObject*)category;

/**
 * Remove all landmark categories. Returns true if operation was successful.
 */
- (BOOL)removeAllCategories;

/**
 * Enables and disables the inclusion of fuzzy search results.
 */
- (void)setAllowFuzzyResults:(BOOL)value;

/**
 * Test if fuzzy search results are allowed.
 */
- (BOOL)getAllowFuzzyResults;

/**
 * Enables and disables the inclusion of interpolated house number results.
 * @note Default is true.
 */
- (void)setEstimateMissingHouseNumbers:(BOOL)state;

/**
 * Test if interpolated house number setting is allowed.
 */
- (BOOL)getEstimateMissingHouseNumbers;

/**
 * Enable or disable the easy access filter for results.
 * @note Default is true.
 */
- (void)setEasyAccessOnlyResults:(BOOL)state;

/**
 * Test if easy access filter is enabled
 */
- (BOOL)getEasyAccessOnlyResults;

/**
 * Returns the country for the specific location.
 * @param location The location object.
 */
- (nonnull LandmarkObject *)addressSearchGetCountryWithCoordinates:(nonnull CoordinatesObject *)location;

/**
 * Returns the country for the specific iso code.
 * @param location The location object.
 */
- (nonnull LandmarkObject *)addressSearchGetCountryWithIsoCode:(nonnull NSString *)isoCode;

/**
 * Start a search address request for the given level and query.
 * @param landmark The landmark object.
 * @param type The address level type.
 * @param query The query string.
 */
- (void)addressSearchWithLandmark:(nonnull LandmarkObject *)landmark level:(AddressLevelType)type query:(nonnull NSString*)query completionHandler:(nonnull void(^)(NSArray<LandmarkObject *> *array))handler;

/**
 * Start a search address countries request for the given query.
 * @param query The query string.
 */
- (void)addressSearchCountriesWithQuery:(nonnull NSString*)query completionHandler:(nonnull void(^)(NSArray<LandmarkObject *> *array))handler;

/**
 * Returns true if country has state address level.
 * @param landmark The landmark country object.
 */
- (BOOL)hasAddressSearchStateWithCountry:(nonnull LandmarkObject *)landmark;

/**
 * Stop a search address request.
 */
- (void)cancelAddressSearch;

/**
 * Stop a search countries request.
 */
- (void)cancelAddressSearchCountries;

/**
 * Returns the maximum number of matches.
 */
- (int)getAddressSearchMaximumMatches;

/**
 * Set the maximum number of matches.
 */
- (void)setAddressSearchMaximumMatches:(int)value;

/**
 * If set to true, then the search will be done using only onboard data.
 */
- (void)setAddressSearchOnlyOnboard:(BOOL)state;

/**
 * Returns the state for onboard search.
 */
- (BOOL)getAddressSearchOnlyOnboard;

@end

NS_ASSUME_NONNULL_END
