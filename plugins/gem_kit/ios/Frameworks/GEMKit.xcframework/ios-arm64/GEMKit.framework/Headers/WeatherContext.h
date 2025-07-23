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
#import <GEMKit/WeatherContextForecast.h>
#import <GEMKit/CoordinatesObject.h>
#import <GEMKit/GenericHeader.h>
#import <GEMKit/TimeDistanceCoordinatesObject.h>
#import <GEMKit/TransferStatisticsContext.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class handles the weather information.
 */
__attribute__((visibility("default"))) @interface WeatherContext : NSObject

/**
 * Returns the singleton SDK instance.
 */
+ (instancetype)shared;

/**
 * Async gets current weather for a list of coordinates.
 * @param coordinates The coordinates list for which the weather is requested.
 * @param completionHandler The completion handler with the operation code and the array with weather conditions for every requested coordinates.
 * @return Error code if the operation couldn't start. If operation successfully started the completion notifications will come with the result.
 */
- (SDKErrorCode)requestCurrentForecast:(nonnull NSArray <CoordinatesObject *> *)coordinates
                     completionHandler:(nonnull void(^)(SDKErrorCode code, NSArray<WeatherContextForecast *> *array))handler;

/**
 * Async gets daily forecast weather for a list of coordinates.
 * @param coordinates The coordinates list for which the weather is requested.
 * @param days The number of days for which the forecast is requested ( value should be <= 10 ).
 * @param completionHandler The completion handler with the operation code and the array with weather conditions for every requested coordinates.
 * @return Error code if the operation couldn't start. If operation successfully started the completion notifications will come with the result.
 */
- (SDKErrorCode)requestDailyForecast:(nonnull NSArray <CoordinatesObject *> *)coordinates days:(NSInteger)days
                   completionHandler:(nonnull void(^)(SDKErrorCode code, NSArray< NSArray<WeatherContextForecast *> *> *array))handler;

/**
 * Async gets hourly forecast weather for a list of coordinates.
 * @param coordinates The coordinates list for which the weather is requested.
 * @param hours The number of hours for which the forecast is requested ( value should be <= 240 )
 * @param completionHandler The completion handler with the operation code and the array with weather conditions for every requested coordinates.
 * @return Error code if the operation couldn't start. If operation successfully started the completion notifications will come with the result.
 */
- (SDKErrorCode)requestHourlyForecast:(nonnull NSArray <CoordinatesObject *> *)coordinates hours:(NSInteger)hours
                    completionHandler:(nonnull void(^)(SDKErrorCode code, NSArray< NSArray<WeatherContextForecast *> *> *array))handler;

/**
 * Async gets forecast weather for a list of coordinates and timestamps.
 * @param timeDistanceCoordinates The time distance coordinates list for which the forecast weather is requested. The timestamp should be relative to current time.
 * @param completionHandler The completion handler with the operation code and the array with weather conditions for every requested coordinates.
 * @return Error code if the operation couldn't start. If operation successfully started the completion notifications will come with the result.
 */
- (SDKErrorCode)requestForecast:(nonnull NSArray <TimeDistanceCoordinatesObject *> *)timeDistanceCoordinates
              completionHandler:(nonnull void(^)(SDKErrorCode code, NSArray< NSArray<WeatherContextForecast *> *> *array))handler;

/**
 * Cancel async operations.
 */
- (void)cancelRequests;

/**
 * Get max coordinates per request limit.
 */
- (int)getMaxCoordinatesPerRequest;

/**
 * Get max day for daily forecast limit.
 */
- (int)getMaxDayForDailyForecast;

/**
 * Get max hours for hourly forecast limit.
 */
- (int)getMaxHoursForHourlyForecast;

/**
 * Get data transfer statistics for weather service.
 */
- (nonnull TransferStatisticsContext*)getTransferStatistics;

@end

NS_ASSUME_NONNULL_END
