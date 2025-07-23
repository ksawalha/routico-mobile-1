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
#import <GEMKit/OverlayInfoObject.h>
#import <GEMKit/SocialReportsOverlayCategoryObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates social reports overlay info details.
 */
__attribute__((visibility("default"))) @interface SocialReportsOverlayInfoObject : OverlayInfoObject

/**
 * Returns the overlay categories list.
 * @param isoCode The country ISO code for which the list is retrieved. Use empty String() for generic country.
 */
- (nonnull NSArray < SocialReportsOverlayCategoryObject *> *)getCategoriesWithIsoCode:(nonnull NSString *)isoCode;

/**
 * Returns the overlay category by id.
 * @param categoryId The category id
 * @param isoCode The country ISO code for which the list is retrieved. Use empty String() for generic country.
 */
- (nullable SocialReportsOverlayCategoryObject *)getCategoryWithIdentifier:(int)categoryId isoCode:(nonnull NSString *)isoCode;

@end

NS_ASSUME_NONNULL_END
