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
 * This class handles sdk api exceptions.
 */
__attribute__((visibility("default"))) @interface GEMExceptionHandler : NSObject

+ (GEMExceptionHandler*)sharedInstace;

/**
 * Register to receive API exception.
 */
- (void)registerWithCompletionHandler:(nonnull void(^)(NSException *exception))handler;

/**
 * Deregister the service.
 */
- (void)deregister;

@end

NS_ASSUME_NONNULL_END
