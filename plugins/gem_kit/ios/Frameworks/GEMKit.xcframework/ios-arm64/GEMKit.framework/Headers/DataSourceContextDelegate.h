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
#import <GEMKit/DataSourceHeader.h>

@class DataSourceContext;
@class DataObject;

NS_ASSUME_NONNULL_BEGIN

/**
 * A set of delegate methods for data source context.
 */
__attribute__((visibility("default"))) @protocol DataSourceContextDelegate <NSObject>

@optional

/**
 * Notifies the delegate with the new data.
 * @param dataSourceContext The data source context informing the delegate of this event.
 * @param data The data base class. Use getType to find the type.
 */
- (void)dataSourceContext:(nonnull DataSourceContext *)dataSourceContext onNewData:(nonnull DataObject *)dataObject;

/**
 * Notifies the delegate when device is mounted for camera use ( in a fixed vertical mount, in a car ) and device is in portrait orientation.
 * @param dataSourceContext The data source context informing the delegate of this event.
 * @param isMounted The mount state.
 * @param isPortrait True if in portrait, false if in landscape orientation.
 */
- (void)dataSourceContext:(nonnull DataSourceContext *)dataSourceContext onDeviceMountedChanged:(BOOL)isMounted isPortraitMode:(BOOL)isPortrait;

/**
 * Notifies the delegate when device temperature level changed.
 * @param dataSourceContext The data source context informing the delegate of this event.
 * @param level The temperature level.
 * @param degree The approximate temperature degree.
 */
- (void)dataSourceContext:(nonnull DataSourceContext *)dataSourceContext onTemperatureChanged:(TemperatureLevel)level degreee:(double)degree;

/**
 * Notifies the delegate when data type is no longer available.
 * @param dataSourceContext The data source context informing the delegate of this event.
 * @param type The data type.
 * @param reason The interruption reason.
 * @param isEnded The interruption ended.
 */
- (void)dataSourceContext:(nonnull DataSourceContext *)dataSourceContext onDataInterruptionEvent:(DataType)type reason:(DataInterruptionReason)reason isEnded:(BOOL)isEnded;

/**
 * Notifies the delegate when progress changed.
 * @param dataSourceContext The data source context informing the delegate of this event.
 * @param progress New progress in milliseconds
 */
- (void)dataSourceContext:(nonnull DataSourceContext *)dataSourceContext onProgressChanged:(NSInteger)progress;

/**
 * Notifies the delegate when the data source playing status changed.
 * @param dataSourceContext The data source context informing the delegate of this event.
 * @param type The data type.
 * @param status The new status.
 */
- (void)dataSourceContext:(nonnull DataSourceContext *)dataSourceContext onPlayingStatusChanged:(DataType)type status:(PlayingStatus)status;

@end

NS_ASSUME_NONNULL_END
