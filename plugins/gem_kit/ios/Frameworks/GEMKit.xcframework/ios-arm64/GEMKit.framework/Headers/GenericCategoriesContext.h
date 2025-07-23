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
#import <GEMKit/LandmarkCategoryObject.h>

/**
 * Constants indicating the category types.
 */
typedef NS_ENUM(NSInteger, GenericCategoryType)
{
    /// GasStation
    GenericCategoryTypeGasStation = 1000,
    
    /// Parking
    GenericCategoryTypeParking = 1001,
    
    /// FoodAndDrink
    GenericCategoryTypeFoodAndDrink = 1002,
    
    /// Accommodation
    GenericCategoryTypeAccommodation = 1003,
    
    /// MedicalServices
    GenericCategoryTypeMedicalServices = 1004,
    
    /// Shopping
    GenericCategoryTypeShopping = 1005,
    
    /// CarServices
    GenericCategoryTypeCarServices = 1006,
    
    ///PublicTransport
    GenericCategoryTypePublicTransport = 1007,
    
    /// Wikipedia
    GenericCategoryTypeWikipedia = 1008,
    
    /// Education
    GenericCategoryTypeEducation = 1009,
    
    ///Entertainment
    GenericCategoryTypeEntertainment = 1010,
    
    /// PublicServices
    GenericCategoryTypePublicServices = 1011,
    
    /// GeographicalArea
    GenericCategoryTypeGeographicalArea = 1012,
    
    /// Business
    GenericCategoryTypeBusiness = 1013,
    
    /// Sightseeing
    GenericCategoryTypeSightseeing = 1014,
    
    /// ReligiousPlaces
    GenericCategoryTypeReligiousPlaces = 1015,
    
    /// Roadside
    GenericCategoryTypeRoadside = 1016,
    
    /// Sports
    GenericCategoryTypeSports = 1017,
    
    /// Uncategorised
    GenericCategoryTypeUncategorised = 1018,
    
    /// Hydrants
    GenericCategoryTypeHydrants = 1019,
    
    /// Emergency Services Support
    GenericCategoryTypeEmergencyServicesSupport = 1020,
    
    /// Civil Emergency Infrastructure
    GenericCategoryTypeCivilEmergencyInfrastructure = 1021,
    
    /// Charging Station
    GenericCategoryTypeChargingStation = 1022,
    
    /// Bicycle charging station
    GenericCategoryTypeBicycleChargingStation = 1023,
    
    /// Bicycle Parking
    GenericCategoryTypeBicycleParking = 1024,
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates generic categories information.
 */
__attribute__((visibility("default"))) @interface GenericCategoriesContext : NSObject

/**
 * Returns the generic categories list.
 */
- (nonnull NSArray <LandmarkCategoryObject *> *)getCategories;

/**
 * Returns the landmark category object associated with the category type.
 * @param categoryType The type of category.
 */
- (nullable LandmarkCategoryObject *)getCategory:(GenericCategoryType)categoryType;

/**
 * Returns the list of POI categories for the given generic category.
 * @param genericCategory Generic category id, see GenericCategoryType enum.
 */
- (nonnull NSArray <LandmarkCategoryObject *> *)getPoiCategories:(int)genericCategory;

/**
 * Returns the generic category for the given POI category.
 * @param poiCategory POI category, see LandmarkStoreType enum.
 */
- (nullable LandmarkCategoryObject *)getGenericCategory:(int)poiCategory;

/**
 * Returns the generic categories landmark store id.
 */
- (int)getLandmarkStoreId;

@end

NS_ASSUME_NONNULL_END
