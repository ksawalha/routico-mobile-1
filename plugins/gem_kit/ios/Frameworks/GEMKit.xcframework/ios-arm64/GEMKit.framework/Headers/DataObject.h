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
#import <GEMKit/DataSourceHeader.h>
#import <GEMKit/TimeObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates position information.
 */
__attribute__((visibility("default"))) @interface DataObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the data type.
 */
- (DataType)getType;

/**
 * Returns the acquisition timestamp in milliseconds since 1970 ( epoch ).
 */
- (NSInteger)getAcquisitionTimestamp;

/**
 * Returns the system acquisition time.
 */
- (nullable TimeObject *)getTime;

@end

NS_ASSUME_NONNULL_END
