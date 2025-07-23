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

/**
 * Constants indicating the default landmark categories.
 * JSR 293 categories( plain landmark store ).
 */
typedef NS_ENUM(NSInteger, DefaultLandmarkCategory)
{
    /// Base
    DefaultLandmarkCategoryBase = 0,
    
    ///  Accommodation
    DefaultLandmarkCategoryAccommodation = DefaultLandmarkCategoryBase,
    
    /// Business
    DefaultLandmarkCategoryBusiness,
    
    /// Communication
    DefaultLandmarkCategoryCommunication,
    
    /// Education institute
    DefaultLandmarkCategoryEducationalInstitute,
    
    /// Entertainment
    DefaultLandmarkCategoryEntertainment,
    
    /// Food & Beverage
    DefaultLandmarkCategoryFoodAndBeverage,
    
    /// Geographical area
    DefaultLandmarkCategoryGeographicalArea,
    
    /// Outdoor activities
    DefaultLandmarkCategoryOutdoorActivities,
    
    /// People
    DefaultLandmarkCategoryPeople,
    
    ///  Public service
    DefaultLandmarkCategoryPublicService,
    
    /// Religious places
    DefaultLandmarkCategoryReligiousPlaces,
    
    /// Shopping
    DefaultLandmarkCategoryShopping,
    
    /// Sightseeing
    DefaultLandmarkCategorySightseeing,
    
    /// Sports
    DefaultLandmarkCategorySports,
    
    /// Transport
    DefaultLandmarkCategoryTransport,
    
    /// Last
    DefaultLandmarkCategoryLast = DefaultLandmarkCategoryTransport
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates landmark category information.
 */
__attribute__((visibility("default"))) @interface LandmarkCategoryObject : NSObject

/**
 * Initializes and returns a newly allocated object using category name.
 */
- (instancetype)initWithName:(nonnull NSString *)name;

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the category identifier.
 */
- (int)getIdentifier;

/**
 * Returns the category name.
 */
- (nonnull NSString *)getName;

/**
 * Set the category name.
 */
- (void)setName:(nonnull NSString *)name;

/**
 * Returns the category image.
 * @param size The image size in pixels
 */
- (nullable UIImage *)getImage:(CGSize)size;

/**
 * Returns the category image.
 * @param size The size in pixels.
 * @param scale The screen scale factor.
 * @param ppi The screen pixel per inch.
 */
- (nullable UIImage *)getImage:(CGSize)size scale:(CGFloat)scale ppi:(NSInteger)ppi;

/**
 * Set the category image.
 */
- (void)setImage:(nonnull UIImage *)image;

/**
 * Returns the landmark store identifier. If the category doesn't belong to a landmark store the function will return 0.
 */
- (int)getLandmarkStoreIdentifier;

@end

NS_ASSUME_NONNULL_END
