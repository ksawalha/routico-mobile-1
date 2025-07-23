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
#import <GEMKit/RoadInfoObject.h>

/**
 * Constants indicating the signpost item type.
 */
typedef NS_ENUM(NSInteger, SignpostItemObjectType)
{
    /// Invalid
    SignpostItemObjectTypeInvalid = 0,
    
    /// Place name
    SignpostItemObjectTypePlaceName,
    
    /// Route number
    SignpostItemObjectTypeRouteNumber,
    
    /// Route name
    SignpostItemObjectTypeRouteName,
    
    /// Exit number
    SignpostItemObjectTypeExitNumber,
    
    /// Exit name
    SignpostItemObjectTypeExitName,
    
    /// Pictogram
    SignpostItemObjectTypePictogram,
    
    /// Other destination
    SignpostItemObjectTypeOtherDestination,
};

/**
 * Constants indicating the signpost item pictogram type.
 */
typedef NS_ENUM(NSInteger, SignpostItemObjectPictogramType)
{
    /// Invalid
    SignpostItemObjectPictogramTypeInvalid = 0,
    
    /// Airport
    SignpostItemObjectPictogramTypeAirport,
    
    /// Bus station
    SignpostItemObjectPictogramTypeBusStation,
    
    /// Fair ground
    SignpostItemObjectPictogramTypeFairGround,
    
    /// Ferry
    SignpostItemObjectPictogramTypeFerry,
    
    /// First aid post
    SignpostItemObjectPictogramTypeFirstAidPost,
    
    /// Harbour
    SignpostItemObjectPictogramTypeHarbour,
    
    /// Hospital
    SignpostItemObjectPictogramTypeHospital,
    
    /// Hotel/Motel
    SignpostItemObjectPictogramTypeHoteMotel,
    
    /// Industrial area
    SignpostItemObjectPictogramTypeIndustrialArea,
    
    /// Information Centre
    SignpostItemObjectPictogramTypeInformationCentre,
    
    /// Parking facility
    SignpostItemObjectPictogramTypeParkingFacility,
    
    /// Petrol / fuel station
    SignpostItemObjectPictogramTypePetrolStation,
    
    /// Railway station
    SignpostItemObjectPictogramTypeRailwayStation,
    
    /// Rest area
    SignpostItemObjectPictogramTypeRestArea,
    
    /// Restaurant
    SignpostItemObjectPictogramTypeRestaurant,
    
    /// Toilet
    SignpostItemObjectPictogramTypeToilet
};

/**
 * Constants indicating the signpost item type.
 */
typedef NS_ENUM(NSInteger, SignpostItemObjectConnectionInfo)
{
    /// Invalid
    SignpostItemObjectConnectionInfoInvalid = 0,
    
    /// Branch
    SignpostItemObjectConnectionInfoBranch,
    
    /// Towards
    SignpostItemObjectConnectionInfoTowards,
    
    /// Exit
    SignpostItemObjectConnectionInfoExit
};


NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates signpost information.
 */
__attribute__((visibility("default"))) @interface SignpostItemObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the type of the item.
 */
- (SignpostItemObjectType)getType;

/**
 * Get the text.
 */
- (nonnull NSString *)getText;

/**
 * Get the phoneme.
 */
- (nonnull NSString *)getPhoneme;

/**
 * Get the one based row.
 */
- (int)getRow;

/**
 * Get the one based column.
 */
- (int)getColumn;

/**
 * Get the ambiguity flag.
 */
- (BOOL)hasAmbiguity;

/**
 * Get the shield level flag.
 * @details True for road code items with same shield level as the road the signpost is attached to.
 */
- (BOOL)hasSameShieldLevel;

/**
 * Get the connection type of the item.
 */
- (SignpostItemObjectConnectionInfo)getConnectionInfo;

/**
 * Gets the pictogram type for the item.
 */
- (SignpostItemObjectPictogramType)getPictogramType;

/**
 * Returns the shield type.
 * @details Only items with type SignpostItemObjectType RouteNumber will return a valid value.
 */
- (RoadShieldType)getShieldType;

@end

NS_ASSUME_NONNULL_END
