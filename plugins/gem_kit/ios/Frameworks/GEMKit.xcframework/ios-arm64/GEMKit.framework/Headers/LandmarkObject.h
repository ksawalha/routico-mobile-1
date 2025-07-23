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
#import <GEMKit/CoordinatesObject.h>
#import <GEMKit/TimeObject.h>
#import <GEMKit/LandmarkCategoryObject.h>
#import <GEMKit/RectangleGeographicAreaObject.h>
#import <GEMKit/ContactInfoObject.h>
#import <GEMKit/ImageObject.h>
#import <GEMKit/OverlayItemObject.h>
#import <GEMKit/GeofenceProximityAreaObject.h>

/**
 * Constants indicating the address search field.
 */
typedef NS_ENUM(NSInteger, AddressSearchFieldType)
{
    /// Address field denoting address extension, e.g. flat number.
    AddressSearchFieldTypeExtension = 0,
    
    /// Address field denoting a building floor.
    AddressSearchFieldTypeBuildingFloor,
    
    /// Address field denoting a building name.
    AddressSearchFieldTypeBuildingName,
    
    /// Address field denoting a building room.
    AddressSearchFieldTypeBuildingRoom,
    
    /// Address field denoting a building zone.
    AddressSearchFieldTypeBuildingZone,
    
    /// Address field denoting street/road name.
    AddressSearchFieldTypeStreetName,
    
    /// Address field denoting street number.
    AddressSearchFieldTypeStreetNumber,
    
    /// Address field denoting zip or postal code.
    AddressSearchFieldTypePostalCode,
    
    /// Address field denoting the settlement.
    AddressSearchFieldTypeSettlement,
    
    /// Address field denoting town or city name.
    AddressSearchFieldTypeCity,
    
    /// Address field denoting a county, which is an entity between a state and a city.
    AddressSearchFieldTypeCounty,
    
    /// Address field denoting state or province.
    AddressSearchFieldTypeState,
    
    /// Abbreviation for state
    AddressSearchFieldTypeStateCode,
    
    /// Address field denoting country.
    AddressSearchFieldTypeCountry,
    
    /// Address field denoting country as a three-letter ISO 3166-1 alpha-3 code.
    AddressSearchFieldTypeCountryCode,
    
    /// Address field denoting a municipal district.
    AddressSearchFieldTypeDistrict,
    
    /// Address field denoting a street in a crossing.
    AddressSearchFieldTypeCrossing1,
    
    /// Address field denoting a street in a crossing.
    AddressSearchFieldTypeCrossing2,
    
    /// Address field denoting the road segment.
    AddressSearchFieldTypeSegmentName,
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates landmark information.
 */
__attribute__((visibility("default"))) @interface LandmarkObject : NSObject <NSSecureCoding>

/**
 * Returns a landmark object with the given name and location.
 */
+ (nonnull instancetype)landmarkWithName:(nonnull NSString *)name location:(nonnull CoordinatesObject *)location;

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the identifier of the landmark.
 * Returning -1 if it does not have an associated ID, i.e. the landmark doesn't belong to a landmark store.
 */
- (int)getLandmarkIdentifier;

/**
 * Returns the store identifier of the landmark.
 */
- (int)getLandmarkStoreIdentifier;

/**
 * Returns the name of the landmark.
 */
- (nonnull NSString*)getLandmarkName;

/**
 * Set the landmark name.
 */
- (void)setLandmarkName:(nonnull NSString *)name;

/**
 * Returns the description of the landmark.
 */
- (nonnull NSString*)getLandmarkDescription;

/**
 * Set the description of this landmark.
 */
- (void)setLandmarkDescription:(nonnull NSString *)description;

/**
 * Returns the author of this landmark.
 */
- (nonnull NSString*)getAuthor;

/**
 * Set the author of this landmark.
 */
- (void)setAuthor:(nonnull NSString *)value;

/**
 * Returns the provider id of this landmark. .
 */
- (int)getProviderId;

/**
 * Set provider id of this landmark.
 */
- (void)setProviderId:(int)value;

/**
 * Returns the landmark timestamp.
 */
- (nullable TimeObject*)getTimeStamp;

/**
 * Set the timestamp.
 */
- (void)setTimeStamp:(nullable TimeObject*)object;

/**
 * Returns the coordinates of the landmark.
 */
- (nonnull CoordinatesObject*)getCoordinates;

/**
 * Set the centroid coordinates.
 */
- (void)setCoordinates:(nonnull CoordinatesObject *)location;

/**
 * Returns the image object.
 */
- (nullable ImageObject*)getImage;

/**
 * Set the image object.
 */
- (void)setImage:(nonnull ImageObject *)object;

/**
 * Set the landmark image buffer data. 
 */
- (void)setImageData:(nonnull NSData *)data format:(ImageFormat)format;

/**
 * Returns the extra image object.
 */
- (nullable ImageObject*)getExtraImage;

/**
 * Set the extra image object.
 */
- (void)setExtraImage:(nonnull ImageObject *)object;

/**
 * Returns the image of the landmark.
 * @details The image is cached after first render.
 */
- (nullable UIImage*)getLandmarkImage:(CGSize)size;

/**
 * Returns the image of the landmark.
 * @param size The size in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 * @details The image is cached after first render.
 */
- (nullable UIImage*)getLandmarkImage:(CGSize)size scale:(CGFloat)scale ppi:(NSInteger)ppi;

/**
 * Set the landmark image. The supported formats are: PNG.
 */
- (void)setLandmarkImage:(nonnull UIImage *)image;

/**
 * Returns the extra info attached to this landmark.
 */
- (nonnull NSArray <NSString *> *)getExtraInfo;

/**
 * Set the extra info attached to this landmark.
 */
- (void)setExtraInfo:(nonnull NSArray <NSString *> *)array;

/**
 * Find extra info.
 */
- (nonnull NSString *)findExtraInfo:(nonnull NSString *)string;

/**
 * Returns the landmark categories list.
 */
- (nonnull NSArray <LandmarkCategoryObject *> *)getCategories;

/**
 * Detach the landmark from the parent landmark store.
 * @details After this call, the getLandmarkStoreId() will return -1
 */
- (void)detachFromStore;

/**
 * Returns the contour rectangle geographic area.
 */
- (nullable RectangleGeographicAreaObject *)getContourGeograficArea;

/**
 * Returns true if the contour rectangle geographic area is empty.
 */
- (BOOL)isContourGeograficAreaEmpty;

/**
 * Get the overlay item attached to a landmark.
 * @details If the landmark is a result of a search in overlays.
 */
- (nullable OverlayItemObject *)getOverlayItem;

/**
 * Get the geofence proximity area attached to a landmark.
 * @details If the landmark is a result of a search in geofences.
 */
- (nullable GeofenceProximityAreaObject *)getGeofenceProximityArea;

/**
 * Returns the direct access to the contact info attached to this landmark.
 */
- (nullable ContactInfoObject *)getContactInfo;

/**
 * Set the contact info. Phone numbers & descriptions, email addresses & descriptions, URLs & descriptions.
 */
- (void)setContactInfo:(nullable ContactInfoObject *)object;

/**
 * Returns the address search field name.
 * @param type The address search field type.
 */
- (nonnull NSString*)getAddressFieldNameWithType:(AddressSearchFieldType)type;

/**
 * Returns the landmark distance formatted string.
 * @param location The reference point.
 */
- (nonnull NSString*)getLandmarkDistanceFormattedWithLocation:(nonnull CoordinatesObject*)location;

/**
 * Returns the landmark distance unit formatted string.
 * @param location The reference point.
 */
- (nonnull NSString*)getLandmarkDistanceUnitFormattedWithLocation:(nonnull CoordinatesObject*)location;

/**
 * Reset cache image.
 */
- (void)resetCacheImage;

/**
 * Returns the landmark name formatted string.
 */
- (nonnull NSString*)getLandmarkNameFormatted;

/**
 * Returns the landmark description formatted string.
 */
- (nonnull NSString*)getLandmarkDescriptionFormatted;

@end

NS_ASSUME_NONNULL_END
