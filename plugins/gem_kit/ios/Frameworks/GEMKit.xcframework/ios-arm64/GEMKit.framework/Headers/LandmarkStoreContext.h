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
#import <GEMKit/LandmarkObject.h>
#import <GEMKit/LandmarkCategoryObject.h>
#import <GEMKit/GeographicAreaObject.h>
#import <GEMKit/RectangleGeographicAreaObject.h>
#import <GEMKit/GenericHeader.h>

/**
 * Constants indicating the landmark stores types.
 */
typedef NS_ENUM(NSInteger, LandmarkStoreType)
{
    /// No landmark store type.
    LandmarkStoreTypeNone = 0,
    
    /// Plain landmark store.
    LandmarkStoreTypeDefault,
    
    /// Map address database ( not listed as landmark store ).
    /// This type is returned by a cursor selection in a MapView or by an address search result.
    /// Can be added to a landmark store collection.
    LandmarkStoreTypeMapAddress,
    
    /// Map POIs landmark store.
    LandmarkStoreTypeMapPoi,
    
    /// Map cities database ( not listed as landmark store ).
    /// This type is returned by a cursor selection in a MapView or by a city search result.
    /// Can be added to a landmark store collection.
    LandmarkStoreTypeMapCity,
    
    /// Map highway exits ( not listed as landmark store ).
    /// This type is returned by a cursor selection in a MapView or by a country search result.
    /// Can be added to a landmark store collection.
    LandmarkStoreTypeMapHighwayExit,
    
    /// Map countries database ( not listed as landmark store ).
    /// This type is returned by a cursor selection in a MapView or by a country search result.
    /// Can be added to a landmark store collection.
    LandmarkStoreTypeMapCountry,
};

/**
 * Constants indicating the landmark import supported formats.
 */
typedef NS_ENUM(NSInteger, LandmarkImportFileFormat)
{
    /// Unknown format.
    LandmarkImportFileFormatUnknown,
    
    /// KML.
    LandmarkImportFileFormatKml,
    
    /// GeoJson
    LandmarkImportFileFormatGeoJson,
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates landmark store context information.
 */
__attribute__((visibility("default"))) @interface LandmarkStoreContext : NSObject

/**
 * Initializes and returns a newly allocated object using the store name.
 */
- (instancetype)initWithName:(nonnull NSString *)name;

/**
 * Initializes and returns a newly allocated object using the store identifier.
 */
- (instancetype)initWithIdentifier:(int)identifier;

/**
 * Add a new category to the store. After this method call, the category object that is passed as a parameter belongs to this landmark store. The category must have a name.
 */
- (void)addCategory:(nonnull LandmarkCategoryObject *)category;

/**
 * Update the specified category. The category object must belong to this landmark store.
 */
- (BOOL)updateCategory:(nonnull LandmarkCategoryObject *)category;

/**
 * Remove the specified category.
 * @details The landmarks belonging to the category are marked uncategorized.
 */
- (BOOL)removeCategory:(nonnull LandmarkCategoryObject *)category;

/**
 * Remove the specified category.
 * @details The landmarks belonging to the category are removed.
 */
- (BOOL)removeCategoryWithAllContent:(nonnull LandmarkCategoryObject *)category;

/**
 * Returns the specified landmark category, if available.
 */
- (nullable LandmarkCategoryObject *)getCategoryById:(int)categoryId;

/**
 * Add landmark in the landmark store. The landmark will be added as uncategorized.
 * @param[in]landmark The landmark object.
 * @return Operation with success.
 */
- (BOOL)addLandmark:(nonnull LandmarkObject*)landmark;

/**
 * Update the information about a landmark.
 * @details This updates only the information about a landmark and does not modify the categories the landmark belongs to.
 * @details The landmark instance passed in as the parameter must be an instance that belongs to this landmark store.
 * @details Calling this method updates the timestamp of the landmark.
 * @param[in]landmark The landmark object.
 * @return Operation with success.
 */
- (BOOL)updateLandmark:(nonnull LandmarkObject*)landmark;

/**
 * Remove the specified landmark from the landmark store.
 * @param[in]landmark The landmark object.
 * @return Operation with success.
 */
- (BOOL)removeLandmark:(nonnull LandmarkObject*)landmark;

/**
 * Remove all landmarks from the landmark store.
 */
- (void)removeAllLandmarks;

/**
 * Add a landmark to the specified category in the landmark store.
 * @param[in]landmark The landmark object.
 * @param[in]categoryId The ID of the category.
 * @return Operation with success.
 */
- (BOOL)addLandmark:(nonnull LandmarkObject*)landmark toCategoryId:(int)categoryId;

/**
 * Remove the specified landmark from the specified category.
 * @param[in]landmark The landmark object.
 * @param[in]categoryId The ID of the category.
 * @return Operation with success.
 */
- (BOOL)removeLandmark:(nonnull LandmarkObject*)landmark fromCategoryId:(int)categoryId;

/**
 * Remove all landmarks from the specified category.
 * @param[in]categoryId The ID of the category.
 */
- (void)removeAllLandmarksFromCategoryId:(int)categoryId;

/**
 * Returns the ID of the landmark store.
 */
- (int)getId;

/**
 * Returns the type of the landmark store.
 */
- (LandmarkStoreType)getType;

/**
 * Returns the landmark store name.
 */
- (nonnull NSString*)getName;

/**
 * Returns the landmark store file path.
 */
- (nonnull NSString*)getFilePath;

/**
 * Returns the list of all categories.
 */
- (nonnull NSArray <LandmarkCategoryObject *> *)getCategories;

/**
 * Returns the specified landmark, if available.
 * @param[in]landmarkId The landmark identifier.
 */
- (nullable LandmarkObject *)getLandmark:(int)landmarkId;

/**
 * Returns the number of all landmarks from the landmark store.
 */
- (int)getLandmarkCount;

/**
 * Returns the landmarks from the landmark store.
 */
- (nonnull NSArray <LandmarkObject *> *)getLandmarks;

/**
 * Returns the number of all landmarks within the specified category.
 * @param[in]categoryId The ID of the category.
 */
- (int)getLandmarkCount:(int)categoryId;

/**
 * Returns the landmarks within the specified category.
 * @param[in]categoryId The ID of the category.
 */
- (nonnull NSArray <LandmarkObject *> *)getLandmarks:(int)categoryId;

/**
 * Returns the landmarks within the specified rectangle geographic area.
 * @param[in]rectangleArea The geographic area.
 */
- (nonnull NSArray <LandmarkObject *> *)getLandmarksWithRectangleGeographicArea:(nonnull RectangleGeographicAreaObject*)rectangleArea;

/**
 * Returns the landmarks within the specified rectangle geographic area.
 * @param rectangleArea The geographic area.
 * @param categoryId The category id for which landmarks are retrieved.
 */
- (nonnull NSArray <LandmarkObject *> *)getLandmarksWithRectangleGeographicArea:(nonnull RectangleGeographicAreaObject*)rectangleArea categoryId:(int)categoryId;

/**
 * Returns the landmarks within the specified geographic area.
 * @param[in]geographicArea The geographic area.
 */
- (nonnull NSArray <LandmarkObject *> *)getLandmarksWithGeographicArea:(nonnull GeographicAreaObject*)geographicArea;

/**
 * Returns the landmarks within the specified geographic area.
 * @param[in]geographicArea The geographic area.
 * @param categoryId The category id for which landmarks are retrieved.
 */
- (nonnull NSArray <LandmarkObject *> *)getLandmarksWithGeographicArea:(nonnull GeographicAreaObject*)geographicArea categoryId:(int)categoryId;

/**
 * Async import landmarks from given file format.
 * @param path The file path.
 * @param format The file format.
 * @param handler The operation completion handler.
 */
- (void)importLandmarks:(nonnull NSString *)filePath format:(LandmarkImportFileFormat)format completionHandler:(nonnull void(^)(SDKErrorCode code))handler;

/**
 * Async import landmarks from given file format.
 * @param path The file path.
 * @param format The file format.
 * @param progressHandler The operation progress handler. The value will be between 0 and 100.
 * @param completionHandler The operation completion handler.
 * @details All the landmarks will be added as uncategorized.
 */
- (void)importLandmarks:(nonnull NSString *)filePath
                 format:(LandmarkImportFileFormat)format
        progressHandler:(nonnull void(^)(float progress))progressHandler
      completionHandler:(nonnull void(^)(SDKErrorCode code))completionHandler;

/**
 * Async import landmarks from given file format.
 * @param path The file path.
 * @param format The file format.
 * @param categoryId The category id.
 * @param progressHandler The operation progress handler. The value will be between 0 and 100.
 * @param completionHandler The operation completion handler.
 * @details All the landmarks will be added to the category id specify. The category must be available in the store.
 */
- (void)importLandmarks:(nonnull NSString *)filePath
                 format:(LandmarkImportFileFormat)format
             categoryId:(int)categoryId
        progressHandler:(nonnull void(^)(float progress))progressHandler
      completionHandler:(nonnull void(^)(SDKErrorCode code))completionHandler;

/**
 * Cancel async import landmarks operation
 */
- (void)cancelImportLandmarks;

@end

NS_ASSUME_NONNULL_END
