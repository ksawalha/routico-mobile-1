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
#import <GEMKit/DataSourceContextDelegate.h>
#import <GEMKit/DataSourceConfigurationObject.h>
#import <GEMKit/GenericHeader.h>
#import <GEMKit/MockPositionObject.h>
#import <GEMKit/RouteObject.h>
#import <GEMKit/DataObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class handles the data source context.
 */
__attribute__((visibility("default"))) @interface DataSourceContext : NSObject

/**
 * Init the data source context from live sensors.
 * @return The newly created data source context.
 */
- (instancetype)init;

/**
 * Create a dummy playback datasource.
 * @return The newly created data source context. Nil in case of error.
 */
- (nullable instancetype)initDummyPlayback;

/**
 * Init the data source context from log file.
 * @param filePath The log file path.
 * @return The newly created data source context. Nil in case of error.
 */
- (nullable instancetype)initWithFilePath:(nonnull NSString *)filePath;

/**
 * Init the data source context from a route ( a route simulation data source ).
 * @param route The route used for generating data source data.
 * @return The newly created data source context. Nil in case of error.
 */
- (nullable instancetype)initWithRoute:(nonnull RouteObject *)route;

/**
 * Init the data source context from an external data source.
 * @details The resulting data source will be able to provide improved positions for the navigation service
 * @param dataSource The external data source.
 * @return The newly created data source context. Nil in case of error.
 */
- (nullable instancetype)initWithExternalSource:(nonnull DataSourceContext *)dataSource;

/**
 * Init the data source context from an external data source.
 * @details The resulting data source will be able to provide improved positions for the navigation service
 * @param dataTypes The data types ( array of DataType ) that will be pushed into the data source.
 * @return The newly created data source context. Nil in case of error.
 */
- (nullable instancetype)initWithExternalDataTypes:(nonnull NSArray < NSNumber *> *)dataTypes;

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 The delegate for the data source context.
 */
@property(nonatomic, weak) NSObject <DataSourceContextDelegate> *delegate;

/**
 * Updates the configuration for the specified type.
 * @param configuration The configuration to be applied.
 * @param type Type of the data.
 */
- (BOOL)setConfiguration:(nonnull DataSourceConfigurationObject *)configuration forType:(DataType)type;

/**
 * Start the data source.
 */
- (BOOL)start;

/**
 * Stop the data source.
 */
- (BOOL)stop;

/**
 * Check if source is paused.
 */
- (BOOL)isStopped;

/**
 * Test if a data type is provided by the data source.
 */
- (BOOL)isDataTypeAvailable:(DataType)type;

/**
 * Returns the data source type.
 */
- (DataSourceType)getDataSourceType;

/**
 * If data source produces such a data type then it returns a description, otherwise it returns an empty string.
 * @param type The data type.
 */
- (nonnull NSString*)getDataTypeDescription:(DataType)type;

/**
 *Returns the log path if the data source is of type playback.
 */
- (nonnull NSString*)getLogPath;

/**
 * Returns the available data types.
 */
- (nonnull NSArray <NSNumber *> *)getAvailableDataTypes;

/**
 * If data source produces such a data type then it returns the data object.
 * @param type The data type.
 */
- (nullable DataObject *)getLatestData:(DataType)type;

/**
 * Start delegate notification.
 * @param type The type of data.
 */
- (BOOL)startDelegateNotificationWithType:(DataType)type;

/**
 * Stop delegate notification.
 * @param type The type of data.
 */
- (BOOL)stopDelegateNotificationWithType:(DataType)type;

/**
 * Stop delegate notification for all available data types.
 */
- (void)stopDelegateNotifications;

/**
 * Returns the origin of the data source.
 */
- (DataSourceOrigin)getOrigin;

/**
 * Tells if the device is in portrait orientation. Valid only if DataTypeMountInformation is available.
 */
- (BOOL)isPortraitMode;

/**
 * Tells if the device is mounted for camera use ( in a fixed vertical mount, in a car) . Valid only if DataTypeMountInformation is available.
 */
- (BOOL)isMountedForCameraUse;

/**
 * Returns the device temperature level.
 */
- (TemperatureLevel)getTemperatureLevel;

/**
 * Returns the approximate temperature degree.
 */
- (double)getTemperatureDegrees;

/**
 * Seeking log file for DataSourceType Playback.
 */
- (void)seekTo:(NSInteger)valueMs;

/**
 * Returns current position log for DataSourceType Playback. The value is in milliseconds.
 */
- (NSInteger)getCurrentPosition;

/**
 * Returns the log duration for DataSourceType Playback. The value is in milliseconds.
 */
- (NSInteger)getDuration;

/**
 * Play log continuously.
 */
- (void)setLoopMode:(BOOL)value;

/**
 * Set mock data position for testing purpose.
 * @param positionObject The mock position object. If nil mock data will reset to default.
 */
- (SDKErrorCode)setMockDataWithPosition:(nullable MockPositionObject *)positionObject;

/**
 * Check if mock data is enabled for the given type.
 */
- (BOOL)isMockData:(DataType)type;

/**
 * Test if this is an SDK instance.
 */
- (BOOL)isSDKInstance;

/**
 * Push new data.
 * @param data The data object to be pushed.
 * @return false if the push data type is not available.
 */
- (BOOL)pushData:(nonnull DataObject *)dataObject;

@end

NS_ASSUME_NONNULL_END
