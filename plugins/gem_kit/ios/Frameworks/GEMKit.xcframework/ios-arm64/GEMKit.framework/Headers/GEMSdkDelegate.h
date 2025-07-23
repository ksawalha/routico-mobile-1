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
#import <GEMKit/ContentStoreObject.h>

/**
 * Constants indicating the online connection status.
 */
typedef NS_ENUM(NSInteger, OnlineConnectionStatus)
{
    /// Mobile Data Connection.
    OnlineConnectionStatusMobileData = 0,
    
    /// WiFi connection.
    OnlineConnectionStatusWifi,
    
    /// Connection off.
    OnlineConnectionStatusOff
};

/**
 * Constants indicating the reason type.
 */
typedef NS_ENUM(NSInteger, ReasonType)
{
    /// There is not enough space on disk.
    ReasonNoDiskSpace = 0,
    
    /// Worldwide road map versions are incompatible with current SDK version. SDK must be updated to the latest version.
    ReasonExpiredSDK,
};

/**
 * A set of delegate methods about GEM Sdk.
 */
__attribute__((visibility("default"))) @protocol GEMSdkDelegate <NSObject>

@optional

/**
 * Notifies the delegate that the authorization key was rejected.
 */
- (void)authorizationKeyRejected;

/**
 * Notifies the delegate that the authorization key was updated.
 * @details This notification will be available only for tokens updated internally via MagicEarth services.
 */
- (void)authorizationKeyUpdated;

/**
 * Notifies the delegate that there is an update for the world map. Notification is triggered only if there are no local maps.
 * @param status The online support status.
 * Returning true will trigger an automatically update for the world map.
 */
- (BOOL)shouldUpdateWorldwideRoadMapForStatus:(ContentStoreOnlineSupportStatus)status;

/**
 * Notifies the delegate when the worldwide road map automatically update is finished.
 */
- (void)updateWorldwideRoadMapFinished:(BOOL)success;

/**
 * Notifies the delegate that there is an update for the current map style.
 * @param status The online support status.
 * Returning true will trigger an automatically update for the map style.
 */
- (BOOL)shouldUpdateMapStyleForStatus:(ContentStoreOnlineSupportStatus)status;

/**
 * Notifies the delegate when the map style automatically update is finished.
 */
- (void)updateMapStyleFinished:(BOOL)success;

/**
 * Notifies the delegate that the worldwide road map support is enabled.
 */
- (void)onWorldwideRoadMapSupportEnabled;

/**
 * Notifies the delegate that the worldwide road map support is disabled.
 */
- (void)onWorldwideRoadMapSupportDisabled:(ReasonType)reason;

/**
 * Notifies the delegate that the worldwide road map status changed.
 */
- (void)onWorldwideRoadMapSupportStatusChanged:(ContentStoreOnlineSupportStatus)status;

/**
 * Notifies the delegate that the worldwide road map version was updated.
 */
- (void)onWorldwideRoadMapVersionUpdated;

/**
 * Notifies the delegate that the SDK doesn't support latest worldwide road map capabilities. 
 * @details The SDK must be updated to latest version in order to be able tu use the latest online maps.
 */
- (void)onWorldwideRoadMapUnsupportedCapabilities;

/**
 * Notifies the delegate with the online connection status.
 * @param connected The online connection status.
 */
- (void)onConnectionStatusUpdated:(BOOL)connected;

/**
 * Notifies the delegate that the Sdk resources are ready to be deployed.
 */
- (void)onResourcesReadyToDeploy;

/**
 * Notifies the delegate if Sdk resources update is allowed.
 * @details Returning true will allow the SDK to download and prepare the latest resources. 
 */
- (BOOL)isResourcesUpdateAllowed;

/**
 * Notifies the delegate that offboard cache changed size.
 * @details Cache size is given in KB.
 */
- (void)onOnlineCacheSizeChange:(int)size;

@end
