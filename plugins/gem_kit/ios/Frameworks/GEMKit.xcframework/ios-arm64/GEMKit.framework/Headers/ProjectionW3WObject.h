// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all 
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V. 
// or its affiliates is strictly prohibited.

#import <GEMKit/GEMKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates W3W projection information.
 */
__attribute__((visibility("default"))) @interface ProjectionW3WObject : ProjectionObject

/**
 * Initializes and returns a newly allocated object using the token parameter.
 */
- (instancetype)initWithToken:(nonnull NSString *)token;

/**
 * Set the user token for WhatThreeWords API.
 */
- (void)setToken:(nonnull NSString *)token;

/**
 * Get the user token for WhatThreeWords API.
 */
- (nonnull NSString *)getToken;

/**
 * Set the three words location.
 */
- (void)setWords:(nonnull NSString *)whatThreeWords;

/**
 * Get the three words location.
 */
- (nonnull NSString *)getWords;

@end

NS_ASSUME_NONNULL_END
