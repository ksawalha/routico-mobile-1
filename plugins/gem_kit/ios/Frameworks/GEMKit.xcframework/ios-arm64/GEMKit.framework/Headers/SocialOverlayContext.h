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
#import <GEMKit/GenericHeader.h>
#import <GEMKit/OverlayItemObject.h>
#import <GEMKit/CoordinatesObject.h>
#import <GEMKit/DataSourceContext.h>
#import <GEMKit/SocialReportsOverlayCategoryObject.h>
#import <GEMKit/LandmarkPositionObject.h>
#import <GEMKit/OverlayItemPositionObject.h>
#import <GEMKit/RouteObject.h>
#import <GEMKit/TransferStatisticsContext.h>
#import <GEMKit/SocialReportsOverlayInfoObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates social overlay context information.
 */
__attribute__((visibility("default"))) @interface SocialOverlayContext : NSObject

/**
 * Returns the social reports overlay info.
 */
- (nullable SocialReportsOverlayInfoObject *)getReportsOverlayInfo;

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

/**
 * Prepare reporting.
 * @param location Report coordinates.
 * @param categId Report category id, default = 0. If != 0, a dry run test is performed to check if the given category id can be reported.
 * @return If in dry run mode ( category id != 0 ), will check if reporting is possible and return the error code:
 * @details KSuspended - Reports rate limit exceeded.
 * @details KInvalidInput - CategId id not a valid social report category id.
 * @details KAccessDenied - Social report overlay category doesn't allow custom coordinates reporting, call prepareReporting with sense::DataSourcePtr instead
 * @return If in preparing mode ( category id = 0 ):
 * @details KSuspended - Reports rate limit exceeded.
 * @details value > 0 - The prepared operation id.
 */
- (int)prepareReportingWithLocation:(nonnull CoordinatesObject *)location categoryId:(int)categId;

/**
 * Prepare reporting.
 * @param context The data source context.
 * @param categId Report category id, default = 0. If != 0, a dry run test is performed to check if the given category id can be reported.
 * @return If in dry run mode ( category id != 0 ), will check if reporting is possible and return the error code:
 * @details KSuspended - Reports rate limit exceeded.
 * @details KInvalidInput - CategId id not a valid social report category id
 * @details KNotFound - No valid data source position for reporting
 * @details KRequired - No valid data source type for reporting, must be EDataSourceType::Live
 * @return If in preparing mode ( category id = 0 ):
 * @details KSuspended - Reports rate limit exceeded.
 * @details KNotFound - Invalid data source position for reporting
 * @details value > 0 - The prepared operation id.
 */
- (int)prepareReportingWithDataSourceContext:(nonnull DataSourceContext *)context categoryId:(int)categId;

/// Report an social event
/// @param prepareId Prepare operation id ( returned by a call to prepareReporting ).
/// @param description The report description text ( optional ).
/// @param snapshot The report snapshot ( optional ). The supported formats are: PNG.
/// @return The operation error code.
/// @details KInvalidInput - categId is not a valid social report category id /  params are ill-formed / snapshot is an invalid image.
/// @details KSuspended - reports rate limit exceeded.
/// @details KExpired - prepared report id not found or is expired ( too old ).
/// @details KNotFound - no accurate sense data source position to complete.
/// @details KScheduled - operation will proceed later, when internet connection is available. Not an error.
- (int)report:(int)prepareId categoryId:(int)categId description:(nullable NSString *)description snapshot:(nullable UIImage *)snapshot completionHandler:(nonnull void(^)(SDKErrorCode code))handler;

/**
 * Confirm an existing report as in effect.
 * @param item The report overlay item.
 * @param handler The completion handler with the result code.
 * @details SDKErrorCode KAccessDenied - Already confirmed or denied.
 * @details SDKErrorCode KScheduled - Operation will proceed later, when internet connection is available.
 */
- (int)confirmReport:(nonnull OverlayItemObject *)item completionHandler:(nonnull void(^)(SDKErrorCode code))handler;

/**
 * Denied an existing report as not in effect anymore.
 * @param item The report overlay item.
 * @param handler The completion handler with the result code.
 * @return The operation error code.
 * @details KInvalidInput - Invalid item ( not a social report overlay item ) or item is not a result of alarm notification.
 * @details KAccessDenied - Already confirmed or denied.
 * @details KScheduled - Operation will proceed later, when internet connection is available. Not an error.
 */
- (int)denyReport:(nonnull OverlayItemObject *)item completionHandler:(nonnull void(^)(SDKErrorCode code))handler;

/**
 * Update an existing report parameters.
 * @param item The report overlay item.
 * @param handler The completion handler with the result code.
 * @return The operation error code.
 * @details KInvalidInput - Invalid item ( not a social report overlay item ).
 * @details KScheduled - Operation will proceed later, when internet connection is available. Not an error.
 */
- (int)updateReport:(nonnull OverlayItemObject *)item completionHandler:(nonnull void(^)(SDKErrorCode code))handler;

/**
 * Delete an owned report.
 * @param item The report overlay item.
 * @param handler The completion handler with the result code.
 * @return The operation error code.
 * @details KInvalidInput - Invalid item ( not a social report overlay item ).
 * @details KAccessDenied - Not an owned report.
 * @details KScheduled - Operation will proceed later, when internet connection is available. Not an error.
 */
- (int)deleteReport:(nonnull OverlayItemObject *)item completionHandler:(nonnull void(^)(SDKErrorCode code))handler;

/**
 * Add a comment to report.
 * @param item The report overlay item.
 * @param handler The completion handler with the result code.
 * @return The operation error code.
 * @details KInvalidInput - Invalid item ( not a social report overlay item ).
 * @details KConnectionRequired - No internet connection available.
 * @details KBusy - Another add comment operation is in progress.
 */
- (int)addComment:(nonnull OverlayItemObject *)item comment:(nonnull NSString *)string completionHandler:(nonnull void(^)(SDKErrorCode code))handler;

/**
 * Get report snapshot.
 * @param item The report overlay item.
 * @param handler The completion handler with the image.
 * @return The operation error code.
 * @details KInvalidInput - Invalid item ( not a social report overlay item ).
 * @details KConnectionRequired - No internet connection available.
 */
- (int)getReportSnapshot:(nonnull OverlayItemObject *)item completionHandler:(nonnull void(^)(UIImage* _Nullable image) )handler;

/**
 * Get data transfer statistics for this service.
 */
- (nonnull TransferStatisticsContext*)getTransferStatistics;

@end

NS_ASSUME_NONNULL_END
