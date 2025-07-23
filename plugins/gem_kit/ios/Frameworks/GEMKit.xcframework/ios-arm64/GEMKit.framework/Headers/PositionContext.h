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
#import <GEMKit/PositionContextDelegate.h>
#import <GEMKit/DataSourceContext.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Constants indicating the position type.
 */
typedef NS_ENUM(NSInteger, PositionType)
{
    /// Position Type.
    PositionTypePosition = 0,
    
    /// Improved Position Type.
    PositionTypeImprovedPosition,
};

/**
 * Constants indicating the position data type.
 */
typedef NS_ENUM(NSInteger, PositionDataType)
{
    /// Data got from the sensors or any other live source.
    PositionDataTypeLive = 0,
    
    /// Data got from playing a log or a simulation.
    PositionDataTypePlayback,
    
    /// No data type available.
    PositionDataTypeUnavailable
};

/**
 * This class handles the gps position.
 */
__attribute__((visibility("default"))) @interface PositionContext : NSObject

/**
 * Init with the data source context.
 */
- (instancetype)initWithContext:(nonnull DataSourceContext *)context;

/**
 The delegate for the navigation contex.
 */
@property(nonatomic, weak) NSObject <PositionContextDelegate> *delegate;

/**
 * Starts the generation of updates that report the user’s current position.
 */
- (void)startUpdatingPositionDelegate:(PositionType)type;

/**
 * Stops the generation of position updates.
 */
- (void)stopUpdatingPositionDelegate;

/**
 * Returns the latest position.
 */
- (nullable PositionObject*)getPosition;

/**
 * Returns the latest position.
 */
- (nullable PositionObject*)getPosition:(PositionType)type;

/**
 * Returns the position data source type.
 */
- (PositionDataType)getSourceType;

/**
 * Returns the position data type.
 */
- (PositionDataType)getPositionDataType;

/**
 * Set the speed multiplier.
 */
- (void)setSpeedMultiplier:(float)value;

/**
 * Clean operation.
 */
- (BOOL)clean;

@end

NS_ASSUME_NONNULL_END
