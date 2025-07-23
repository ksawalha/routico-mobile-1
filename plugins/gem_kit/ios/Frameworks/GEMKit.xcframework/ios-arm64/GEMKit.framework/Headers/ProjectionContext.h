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
#import <GEMKit/ProjectionObject.h>
#import <GEMKit/GenericHeader.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates projection context details.
 */
__attribute__((visibility("default"))) @interface ProjectionContext : NSObject

/**
 * Async returns the projection result from an input projection.
 * @param fromProj The input projection that needs to be converted.
 * @param[out] toProj The result projection object.
 * @param[out] handler The block to execute asynchronously with the result.
 * @return Error code if the operation couldn't start. If operation successfully started the completion notification will come via the completion handler.
 */
- (SDKErrorCode)convert:(nonnull ProjectionObject *)fromProj to:(nonnull ProjectionObject *)toProj completionHandler:(nonnull void(^)(SDKErrorCode code))handler;

@end

NS_ASSUME_NONNULL_END
