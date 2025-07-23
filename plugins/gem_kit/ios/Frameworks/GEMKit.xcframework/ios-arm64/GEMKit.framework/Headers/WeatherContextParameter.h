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

NS_ASSUME_NONNULL_BEGIN

/**
 * Weather context parameter data.
 */
__attribute__((visibility("default"))) @interface WeatherContextParameter: NSObject

/// Parameter type. This can be: Temperature, FeelsLike, Sunrise, Sunset, Visibility, WindSpeed.
@property(nonnull, nonatomic, strong) NSString *type;

/// Value
@property(nonatomic, assign) double value;

/// Name translated according to current language
@property(nonnull, nonatomic, strong) NSString *name;

/// Unit name translated according to current language.
@property(nonnull, nonatomic, strong) NSString *unit;

@end

NS_ASSUME_NONNULL_END
