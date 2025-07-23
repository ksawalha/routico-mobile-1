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
#import <GEMKit/PositionObject.h>
#import <GEMKit/AlarmMonitoredAreaObject.h>

@class AlarmContext;

NS_ASSUME_NONNULL_BEGIN

/**
 * A set of delegate methods for alarm context objects.
 */
__attribute__((visibility("default"))) @protocol AlarmContextDelegate <NSObject>

@optional

/**
 * Notifies the delegate that the boundary of some areas was crossed.
 * @param alarmContext The alarm context informing the delegate of this event.
 */
- (void)alarmContextOnBoundaryCrossed:(nonnull AlarmContext *)alarmContext __attribute__((deprecated("Please use alarmContextOnBoundaryCrossed:enteredArea:exitedAreas:")));;

/**
 * Notifies the delegate that the boundary of some areas was crossed.
 * @param alarmContext The alarm context informing the delegate of this event.
 * @param arrayIn The new entered areas list.
 * @param arrayOut The new exited areas list
 */
- (void)alarmContextOnBoundaryCrossed:(nonnull AlarmContext *)alarmContext enteredArea:(nonnull NSArray <AlarmMonitoredAreaObject *> *)arrayIn exitedAreas:(nonnull NSArray <AlarmMonitoredAreaObject *> *)arrayOut;

/**
 * Notifies the delegate that the state of the monitoring has changed.
 * @param alarmContext The alarm context informing the delegate of this event.
 */
- (void)alarmContextOnMonitoringStateChanged:(nonnull AlarmContext *)alarmContext;

/**
 * Notifies the delegate when entering into a tunnel.
 * @param alarmContext The alarm context informing the delegate of this event.
 */
- (void)alarmContextOnTunnelEntered:(nonnull AlarmContext *)alarmContext;

/**
 * Notifies the delegate when leaving a tunnel.
 * @param alarmContext The alarm context informing the delegate of this event.
 */
- (void)alarmContextOnTunnelLeft:(nonnull AlarmContext *)alarmContext;

/**
 * Notifies the delegate that the landmark alarms updated.
 * @param alarmContext The alarm context informing the delegate of this event.
 */
- (void)alarmContextOnLandmarkAlarmsUpdated:(nonnull AlarmContext *)alarmContext;

/**
 * Notifies the delegate that the overlay Item alarms updated.
 * @param alarmContext The alarm context informing the delegate of this event.
 */
- (void)alarmContextOnOverlayItemAlarmsUpdated:(nonnull AlarmContext *)alarmContext;

/**
 * Notifies the delegate that the landmark alarms passed over.
 * @param alarmContext The alarm context informing the delegate of this event.
 */
- (void)alarmContextOnLandmarkAlarmsPassedOver:(nonnull AlarmContext *)alarmContext;

/**
 * Notifies the delegate that the overlay item alarms passed over.
 * @param alarmContext The alarm context informing the delegate of this event.
 */
- (void)alarmContextOnOverlayItemAlarmsPassedOver:(nonnull AlarmContext *)alarmContext;

/**
 * Notifies the delegate that the current speed is too high than the recommended range.
 * @param alarmContext The alarm context informing the delegate of this event.
 * @param limit The speed limit range in the current navigation position, in mps.
 * @param insideCityArea The over-speed inside city area flag recommended speed is provided as parameter.
 */
- (void)alarmContext:(nonnull AlarmContext *)alarmContext onHighSpeed:(double)limit insideCityArea:(bool)insideCityArea;

/**
 * Notifies the delegate that the current speed is in the recommended range.
 * @param alarmContext The alarm context informing the delegate of this event.
 * @param limit The speed limit range in the current navigation position, in mps.
 * @param insideCityArea The normal speed inside city area flag. Undefined if speed limit is unavailable for the current position.
 * @details A value of 0 means that a limit is not available for the current position but the notification is sent to silence a previous existing alarm.
 */
- (void)alarmContext:(nonnull AlarmContext *)alarmContext onNormalSpeed:(double)limit insideCityArea:(bool)insideCityArea;

/**
 * Notifies the delegate about the current speed limit status.
 * @param alarmContext The alarm context informing the delegate of this event.
 * @param speed The current navigation speed, in mps.
 * @param limit The speed limit range in the current navigation position, in mps. A value of 0 means it is not available for the current position.
 * @param insideCityArea The current navigation position city area flag. Undefined if speed limit is unavailable for the current position
 */
- (void)alarmContext:(nonnull AlarmContext *)alarmContext onSpeedLimit:(double)speed limit:(double)limit insideCityArea:(bool)insideCityArea;

/**
 * Notifies the delegate that the outside luminosity meets the "day" conditions.
 * @param alarmContext The alarm context informing the delegate of this event.
 */
- (void)alarmContextOnEnterDayMode:(nonnull AlarmContext *)alarmContext;

/**
 * Notifies the delegate that the outside luminosity meets the "night" conditions.
 * @param alarmContext The alarm context informing the delegate of this event.
 */
- (void)alarmContextOnEnterNightMode:(nonnull AlarmContext *)alarmContext;

@end

NS_ASSUME_NONNULL_END
