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
#import <GEMKit/AlarmContextDelegate.h>
#import <GEMKit/LandmarkObject.h>
#import <GEMKit/PositionObject.h>
#import <GEMKit/OverlayItemObject.h>
#import <GEMKit/GenericHeader.h>
#import <GEMKit/AlarmMonitoredAreaObject.h>
#import <GEMKit/GeographicAreaObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class handles the alarm.
 */
__attribute__((visibility("default"))) @interface AlarmContext : NSObject

/**
 The delegate for the alarm contex.
 */
@property(nonatomic, weak) NSObject <AlarmContextDelegate> *delegate;

/**
 * Enable the safety camera service.
 */
- (void)enableSafetyCamera;

/**
 * Disable the safety camera service.
 */
- (void)disableSafetyCamera;

/**
 * Returns true is safety camera service is enable.
 */
- (BOOL)isSafetyCameraEnabled;

/**
 * Enables the offline data grabber for the safety cameras.
 * @details The offline data grabber downloads an overlay covering dataset for every new downloaded road map content.
 * @details The offline data is automatically grabbed immediately after a road map content download finishes & is stored in the SDK permanent cache
 */
- (void)enableSafetyCameraOfflineDataGrabber;

/**
 * Disables the offline data grabber for the safety cameras.
 */
- (void)disableSafetyCameraOfflineDataGrabber;

/**
 * Check if the offline data grabber for the safety cameras is enabled.
 */
- (BOOL)isSafetyCameraOfflineDataGrabberEnabled;

/**
 * Check if the offline data grabber for the safety cameras overlay is supported.
 */
- (BOOL)isSafetyCameraOfflineDataGrabberSupported;

/**
 * Grab latest safety cameras offline data over all existing offline maps area.
 */
-(void)grabSafetyCameraOfflineDataWithCompletionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Cancel request to grab latest safety cameras offline data.
 */
- (void)cancelGrabSafetyCameraOfflineData;

/**
 * Enable the social reports service.
 */
- (void)enableSocialReports;

/**
 * Disable the social reports service.
 */
- (void)disableSocialReports;

/**
 * Enable the social reports service with specific category.
 * @param categUid The social reports category uid.
 */
- (SDKErrorCode)enableSocialReportsWithCategory:(int)categUid;

/**
 * Disable the social reports service for specific category.
 * @param categUid The social reports category uid.
 */
- (SDKErrorCode)disableSocialReportsWithCategory:(int)categUid;

/**
 * Returns true if social reports service is enabled.
 */
- (BOOL)isSocialReportsEnabled;

/**
 * Returns true if social reports service is enabled for the specific category.
 */
- (BOOL)isSocialReportsEnabledWithCategory:(int)categUid;

/**
 * Enables the offline data grabber for the social reports overlay.
 * @details The offline data grabber downloads an overlay covering dataset for every new downloaded road map content.
 * @details The offline data is automatically grabbed immediately after a road map content download finishes & is stored in the SDK permanent cache.
 */
- (void)enableSocialReportsOfflineDataGrabber;

/**
 * Disables the offline data grabber for the social reports overlay.
 */
- (void)disableSocialReportsOfflineDataGrabber;

/**
 * Check if the offline data grabber for the social reports overlay is enabled.
 */
- (BOOL)isSocialReportsOfflineDataGrabberEnabled;

/**
 * Check if the offline data grabber for the social reports overlay is supported.
 */
- (BOOL)isSocialReportsOfflineDataGrabberSupported;

/**
 * Add new geographic area to monitor.
 * @param geoArea The geographic area object.
 * @param identifier The monitor area identifier. 
 */
- (void)monitorArea:(nonnull GeographicAreaObject *)geoArea areaId:(nonnull NSString *)identifier;

/**
 * Remove the given geographic area from monitor.
 * @param geoArea The geographic area object.
 */
- (void)unmonitorArea:(nonnull GeographicAreaObject *)geoArea;

/**
 * Remove the given geographic areas from monitor.
 * @param array The monitor area identifiers array.
 */
- (void)unmonitorAreas:(nonnull NSArray <NSString *> *)array;

/**
 * Remove all geographic areas from monitor.
 */
- (void)unmonitorAllAreas;

/**
 * Sets the alarm distance in meters.
 */
- (void)setAlarmDistance:(double)distance;

/**
 * Returns the distance in meters for alarming.
 */
- (double)getAlarmDistance;

/**
 * Select if alarms should be provided when navigating without route.
 */
- (void)setMonitorWithoutRoute:(BOOL)state;

/**
 * Returns the status of the "alarming without route" flag .
 */
- (BOOL)getMonitorWithoutRoute;

/**
 * Set the alarm overspeed threshold value, in mps.
 * @param threshold Value in meters per second.
 * @param inside Specify whether the given threshold is for inside city area or for outside city area.
 */
- (void)setOverSpeedThreshold:(double)threshold insideCityArea:(bool)inside;

/**
 * Get the alarm overspeed threshold value, in mps
 * @param insideCityArea Specify whether the returned threshold is for inside city area or for outside city area.
 */
- (double)getOverSpeedThreshold:(BOOL)insideCityArea;

/**
 * Returns the alarm current reference position.
 */
- (nullable PositionObject*)getReferencePosition;

/**
 * Returns the list of crossed boundaries geographic area.
 */
- (nonnull NSArray <GeographicAreaObject *> *)getCrossedBoundaries;

/**
 * Returns the list of active landmark alarms.
 * @details When all alarms become inactive the list of landmark alarms is empty.
 */
- (nonnull NSArray <LandmarkObject *> *)getLandmarkAlarms;

/**
 * Returns the list of active overlay item alarms.
 */
- (nonnull NSArray <OverlayItemObject *> *)getOverlayItemAlarms;

/**
 * Returns the list of passed over overlay item alarms.
 */
- (nonnull NSArray <OverlayItemObject *> *)getOverlayItemAlarmsPassedOver;

/**
 * Returns the distance in meters from the overlay object item to the reference coordinate.
 * @param object The overlay item object.
 */
- (int)getDistanceWithOverlayItemObject:(nonnull OverlayItemObject *)object;

/**
 * Returns the distance string formatted from the overlay object item to the reference coordinate.
 * @param object The overlay item object.
 */
- (nonnull NSString *)getDistanceFormattedWithOverlayItemObject:(nonnull OverlayItemObject *)object;

/**
 * Returns the distance unit string formatted from the overlay object item to the reference coordinate.
 * @param object The overlay item object.
 */
- (nonnull NSString *)getDistanceUnitFormattedWithOverlayItemObject:(nonnull OverlayItemObject *)object;

/**
 * Register for safety camera notifications.
 */
- (void)registerSafetyCameraNotificationsWithCompletionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Register for social report notifications.
 */
- (void)registerSocialReportNotificationsWithCompletionHandler:(nonnull void(^)(BOOL success))handler;

@end

NS_ASSUME_NONNULL_END
