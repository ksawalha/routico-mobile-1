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

/**
 * Constants indicating the network types enumeration.
 */
typedef NS_ENUM(NSInteger, NetworkType)
{
    /// Free of change networks (unlimited WiFi or Wired networks, etc.)
    NetworkTypeFree = 0,
    
    /// Charged per traffic/time (GPRS, EDGE, 3G, 4G, 5G etc).
    NetworkTypeExtraCharged,
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class handles the transfer statistics.
 */
__attribute__((visibility("default"))) @interface TransferStatisticsContext : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Get the overall uploaded data size in bytes.
 */
- (NSInteger)getUpload;

/**
 * Get the overall downloaded data size in bytes.
 */
- (NSInteger)getDownload;

/**
 * Get the overall requests count.
 */
- (NSInteger)getRequests;

/**
 * Get the uploaded data size in bytes / network type ( see NetworkType )
 */
- (NSInteger)getUpload:(NetworkType)networkType;

/**
 * Get the overall downloaded data size in bytes / network type ( see NetworkType ).
 */
- (NSInteger)getDownload:(NetworkType)networkType;

/**
 * Get the overall requests count  / network type ( see NetworkType ).
 */
- (NSInteger)getRequests:(NetworkType)networkType;

/**
 * Reset transfer statistics.
 */
- (void)resetStatistics;

@end

NS_ASSUME_NONNULL_END
