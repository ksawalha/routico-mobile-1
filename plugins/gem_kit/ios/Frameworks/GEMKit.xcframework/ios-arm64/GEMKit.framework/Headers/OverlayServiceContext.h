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
#import <GEMKit/GenericHeader.h>
#import <GEMKit/OverlayCollectionObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates overlay service information.
 */
__attribute__((visibility("default"))) @interface OverlayServiceContext : NSObject

/**
 * Get list of SDK available overlays.
 */
- (nullable OverlayCollectionObject *)getAvailableOverlays;

/**
 * Enables the overlay with the given uid. This will activate the overlay for all registered services ( map views, alarms, etc ).
 * @param uid The overlay uid.
 */
- (SDKErrorCode)enableOverlay:(int)uid;

/**
 * Enables the overlay with the given uid. This will activate the overlay for all registered services ( map views, alarms, etc ).
 * @param uid The overlay uid.
 * @param categUid The overlay category uid.
 */
- (SDKErrorCode)enableOverlay:(int)uid category:(int)categUid;

/**
 * Disables the overlay with the given uid. This will deactivate the overlay for all registered services ( map views, alarms, etc )
 * @param uid The overlay uid.
 */
- (SDKErrorCode)disableOverlay:(int)uid;

/**
 * Disables the overlay with the given uid. This will deactivate the overlay for all registered services ( map views, alarms, etc )
 * @param uid The overlay uid.
 * @param categUid The overlay category uid.
 */
- (SDKErrorCode)disableOverlay:(int)uid category:(int)categUid;

/**
 * Check if the overlay with the given uid is enabled.
 * @param  uid The overlay uid.
 */
- (BOOL)isOverlayEnabled:(int)uid;

/**
 * Check if the overlay with the given uid is enabled.
 * @param uid The overlay uid.
 * @param categUid The overlay category uid.
 */
- (BOOL)isOverlayEnabled:(int)uid category:(int)categUid;

/**
 * Enables the offline data grabber for the overlay with the given uid.
 * @param uid The overlay uid.
 * @details The offline data grabber downloads an overlay covering dataset for every new downloaded road map content.
 * @details The offline data is automatically grabbed immediately after a road map content download finishes & is stored in the SDK permanent cache.
 */
- (SDKErrorCode)enableOverlayOfflineDataGrabber:(int)uid;

/**
 * Disables the offline data grabber for the overlay with the given uid.
 * @param uid The overlay uid.
 */
- (SDKErrorCode)disableOverlayOfflineDataGrabber:(int)uid;

/**
 * Check if the offline data grabber for the given overlay uid is enabled.
 * @param uid The overlay uid.
 */
- (BOOL)isOverlayOfflineDataGrabberEnabled:(int)uid;

/**
 * Check if the offline data grabber for the given overlay uid is supported.
 * @param uid The overlay uid.
 */
- (BOOL)isOverlayOfflineDataGrabberSupported:(int)uid;

/**
 * Grab latest overlay offline data over all existing offline maps area.
 * @param uid The overlay uid.
 */
-(void)grabOverlayOfflineData:(int)uid completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Cancel request to grab latest overlay offline data.
 * @param uid The overlay uid.
 */
- (void)cancelGrabOverlayOfflineData:(int)uid;

@end

NS_ASSUME_NONNULL_END
