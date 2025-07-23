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
#import <GEMKit/LocalizationHeader.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * An object that manages localization strings.
 */
__attribute__((visibility("default")))  @interface LocalizationContext : NSObject

/**
 * Return singleton instance.
 */
+ (nonnull LocalizationContext*)sharedInstance;

/**
 * The translation string or empty if no translation is found.
 * @param The string identifier. See LocalizationStringId.
 */
- (nonnull NSString*)getString:(LocalizationStringId)identifier;

/**
 * The tts translation string or empty if no translation is found.
 * @param The string identifier. See LocalizationStringId.
 */
- (nonnull NSString*)getTTSString:(LocalizationStringId)type;

@end

NS_ASSUME_NONNULL_END
