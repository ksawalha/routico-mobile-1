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
#import <GEMKit/TimeObject.h>
#import <GEMKit/ImageObject.h>
#import <GEMKit/WeatherContextParameter.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Weather context conditions for a given timestamp.
 */
__attribute__((visibility("default"))) @interface WeatherContextConditions : NSObject

/// Type.
@property(nonnull, nonatomic, strong) NSString *type;

/// Timestamp.
@property(nullable, nonatomic, strong) TimeObject *stamp;

/// Image object representation.
@property(nullable, nonatomic, strong) ImageObject *imageObject;

/// Description translated according to current language.
@property(nonnull, nonatomic, strong) NSString *details;

/// Condition daylight.
@property(nonatomic, assign) WeatherDaylight daylight;

/// Parameters list.
@property(nonnull, nonatomic, strong) NSArray <WeatherContextParameter *> *parameters;

@end

NS_ASSUME_NONNULL_END
