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
#import <GEMKit/TimeObject.h>
#import <GEMKit/CoordinatesObject.h>
#import <GEMKit/WeatherContextConditions.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class handles the weather context foecast.
 */
__attribute__((visibility("default"))) @interface WeatherContextForecast: NSObject

/// Forecast update timestamp.
@property(nullable, nonatomic, strong) TimeObject *updateTimestamp;

/// Geographic location.
@property(nullable, nonatomic, strong) CoordinatesObject *coordinatesObject;

/// Forecast data.
@property(nonatomic, strong) WeatherContextConditions *conditions;

@end

NS_ASSUME_NONNULL_END
