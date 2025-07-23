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

NS_ASSUME_NONNULL_BEGIN

/**
 * Constants indicating the authorization key status.
 */
typedef NS_ENUM(NSInteger, IntentHandlerType)
{
    /// ShowOnMap type.
    IntentHandlerTypeShowOnMap = 0,
    
    /// Query type.
    IntentHandlerTypeQuery,
    
    /// WhatIsNearby type.
    IntentHandlerTypeWhatIsNearby,
    
    /// SearchAround type.
    IntentHandlerTypeSearchAround,
    
    /// OpenSearch type.
    IntentHandlerTypeOpenSearch,
    
    
    
    /// DriveTo type.
    IntentHandlerTypeDriveTo,
    
    /// WalkTo type.
    IntentHandlerTypeWalkTo,
    
    /// BikeTo type.
    IntentHandlerTypeBikeTo,
    
    /// TruckTo type.
    IntentHandlerTypeTruckTo,
    
    /// PublicTransportTo type.
    IntentHandlerTypePublicTransportTo,
    
    /// NavigateVia type.
    IntentHandlerTypeNavigateVia,
    
    
    
    /// GetDirections type.
    IntentHandlerTypeGetDirections,
    
    /// AddToFavorites type.
    IntentHandlerTypeAddToFavorites,
    
    /// SaveAsHome type.
    IntentHandlerTypeSaveAsHome,
    
    /// SaveAsWork type.
    IntentHandlerTypeSaveAsWork,
    
    /// Unknown type.
    IntentHandlerTypeUnknown
};

/**
 * An object that manages url intents strings.
 */
__attribute__((visibility("default"))) @interface IntentsContext : NSObject

/**
 * Return singleton instance.
 */
+ (nonnull IntentsContext*)sharedInstance;

/**
 * The prefix for intent.
 */
@property (nonatomic, strong) NSString *prefix;

/**
 * Handle intent.
 */
- (void)processIntent:(nonnull NSString*)intent completionHandler:(nonnull void(^)(LandmarkObject *landmark, IntentHandlerType type))handler;

@end

NS_ASSUME_NONNULL_END
