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
#import <GEMKit/OverlayCategoryObject.h>
#import <GEMKit/OverlayHeader.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates social reports overlay category information.
 */
__attribute__((visibility("default"))) @interface SocialReportsOverlayCategoryObject : OverlayCategoryObject

/**
 * Returns the category ISO 3166-1 alpha-3 country code representation. Returns default empty string for generic country.
 */
- (nonnull NSString *)getCountry;

/**
 * Returns the subcategories.
 */
- (nonnull NSArray <SocialReportsOverlayCategoryObject *> *)getSubcategories;

/**
 * Returns the value for the social report overlay category.
 * @param parameterType The data parameter type.
 */
- (nullable NSValue *)searchInPreviewData:(SocialReportCategoryParameterType)parameterType;


@end

NS_ASSUME_NONNULL_END
