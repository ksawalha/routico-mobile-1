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
#import <GEMKit/LandmarkStoreContext.h>
#import <GEMKit/CoordinatesObject.h>

/**
 * Constants indicating the ways in which landmarks from a Landmark Browse Session Context can be ordered.
 */
typedef NS_ENUM(NSInteger, LandmarkObjectOrder)
{
    /// Order by Name.
    LandmarkObjectOrderName = 0,
    
    /// Order by Date ( date of insertion ).
    LandmarkObjectOrderDate = 1,
    
    /// Order by Distance ( relative to a given position ).
    LandmarkObjectOrderDistance = 2
};

/**
 * Constants indicating filter by category.
 */
typedef NS_ENUM(NSInteger, CategoryIdFilter)
{
    /// Landmarks that are not part of categories will be selected.
    CategoryIdFilterUncategorized = -1,
    
    /// Landmarks from all categories will be selected.
    CategoryIdFilterInvalid = -2,
};

/**
 * Constants indicating the settings of a LandmarkBrowseSessionContext.
 */
typedef struct {
    
    /// Specify if descending order is desired. By default it is ascending.
    bool descendingOrder;
    
    /// Specify the kind of order desired. By default the landmarks are ordered by name.
    LandmarkObjectOrder orderBy;
    
    /// Specify a filter to be applied to names.
    __unsafe_unretained NSString * _Nonnull nameFilter;
    
    /// Specify a filter by category id. By default CategoryIdFilterInvalid is set, meaning landmarks from all categories will be selected.
    int categoryIdFilter;
    
    /// Coordinates relative to which the order by distance is made
    __unsafe_unretained CoordinatesObject * _Nonnull coordinates;
    
} LandmarkBrowseSessionContextSettings;

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates landmark browse session context information.
 */
__attribute__((visibility("default"))) @interface LandmarkBrowseSessionContext : NSObject

/**
 * Initializes and returns a newly allocated object.
 @param identifier The identifier of a LandmarkStoreContext.
 */
- (instancetype)initWithStoreId:(int)identifier;

/**
 * Initializes and returns a newly allocated object.
 * @param identifier The identifier of a LandmarkStoreContext.
 * @param setting The settings for LandmarkBrowseSessionContext.
 */
- (instancetype)initWithStoreId:(int)identifier settings:(LandmarkBrowseSessionContextSettings)setting;

/**
 * Gets the session settings.
 */
- (LandmarkBrowseSessionContextSettings)getSettings;

/**
 * Gets the session id.
 */
- (int)getId;

/**
 * Gets the belonging landmark store id.
 */
- (int)getLandmarkStoreId;

/**
 * Gets the number of all landmarks within the session.
 */
- (int)getLandmarkCount;

/**
 * Gets the landmarks between the specified indexes.
 * @param fromIndex The from index.
 * @param toIndex The to index.
 */
- (nonnull NSArray <LandmarkObject *> *)getLandmarksFrom:(int)fromIndex to:(int)toIndex;

/**
 * Gets the landmark position in browsing set for the given landmark id.
 * @return The position on success.
 */
- (int)getLandmarkPos:(int)lmkId;

@end

NS_ASSUME_NONNULL_END
