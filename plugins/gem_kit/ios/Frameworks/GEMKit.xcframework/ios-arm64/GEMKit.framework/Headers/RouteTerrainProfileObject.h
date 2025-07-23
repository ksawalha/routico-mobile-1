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

/**
 * Constants indicating the climb grade.
 * @details
 */
typedef NS_ENUM(NSInteger, ClimbGrade)
{
    /// Climb Grade HC ( Hors Category )
    /// @details From the French term meaning beyond categorisation. The longest or steepest climbs, often both combined.
    ClimbGradeHC,
    
    /// Climb Grade 1.
    /// @details A very significant climb.
    ClimbGrade1,
    
    /// Climb Grade 2.
    ClimbGrade2,
    
    /// Climb Grade 3.
    ClimbGrade3,
    
    /// Climb Grade 4.
    /// @details The easiest categorised climbs of all.
    ClimbGrade4
};

/**
 * Constants indicating the surface type.
 */
typedef NS_ENUM(NSInteger, SurfaceType)
{
    /// Asphalt
    SurfaceTypeAsphalt,
    
    /// Paved
    SurfaceTypePaved,
    
    /// Unpaved
    SurfaceTypeUnpaved,
    
    /// Unknown
    SurfaceTypeUnknown
};

/**
 * Constants indicating the road type.
 */
typedef NS_ENUM(NSInteger, RoadType)
{
    /// Motorway
    RoadTypeMotorways,
    
    /// State road
    RoadTypeStateRoad,
    
    /// Road
    RoadTypeRoad,
    
    /// Street
    RoadTypeStreet,
    
    /// Cycleway
    RoadTypeCycleway,
    
    /// Path
    RoadTypePath,
    
    /// Single track
    RoadTypeSingleTrack
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates climb section information.
 */
__attribute__((visibility("default"))) @interface ClimbSectionObject: NSObject

/// Distance in meters where this section starts.
@property(nonatomic, assign) int startDistanceM;

/// Distance in meters where this section ends.
@property(nonatomic, assign) int endDistanceM;

/// Slope value
@property(nonatomic, assign) float slope;

/// The grade value of the section.
@property(nonatomic, assign) ClimbGrade grade;

@end


/**
 * This class encapsulates surface section information.
 */
__attribute__((visibility("default"))) @interface SurfaceSectionObject: NSObject

/// Distance in meters where the section starts.
@property(nonatomic, assign) int startDistanceM;

/// The type of surface.
@property(nonatomic, assign) SurfaceType type;

@end


/**
 * This class encapsulates road type section information.
 */
__attribute__((visibility("default"))) @interface RoadTypeSectionObject: NSObject

/// Distance in meters where the section starts.
@property(nonatomic, assign) int startDistanceM;

/// The type of road.
@property(nonatomic, assign) RoadType type;

@end


/**
 * This class encapsulates road steep section information.
 */
__attribute__((visibility("default"))) @interface RoadSteepSectionObject: NSObject

/// Distance in meters where the section starts.
@property(nonatomic, assign) int startDistanceM;

/// The category of steep ( index in user steep categories list, see getSteepSections for details )
@property(nonatomic, assign) int categ;

@end


/**
 * This class encapsulates route terrain profile information.
 */
__attribute__((visibility("default"))) @interface RouteTerrainProfileObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the terrain minimum elevation.
 */
- (float)getMinElevation;

/**
 * Returns the terrain maximum elevation.
 */
- (float)getMaxElevation;

/**
 * Returns the terrain minimum elevation distance ( from route start ).
 */
- (int)getMinElevationDistance;

/**
 * Returns the terrain maximum elevation distance ( from route start ).
 */
- (int)getMaxElevationDistance;

/**
 * Returns the total terrain elevation up.
 */
- (float)getTotalUp;

/**
 * Returns the total terrain elevation down.
 */
- (float)getTotalDown;

/**
 * Returns the total terrain elevation up for specified route section.
 */
- (float)getTotalUp:(int)distBegin end:(int)distEnd;

/**
 * Returns the total terrain elevation down for specified route section.
 */
- (float)getTotalDown:(int)distBegin end:(int)distEnd;

/**
 * Returns the elevation samples list.
 * @param countSamples The number of samples.
 */
- (nonnull NSArray <NSNumber *> *)getElevationSamples:(int)countSamples;

/**
 * Returns the elevation samples list.
 * @param countSamples The number of samples.
 * @param distBegin The begin distance on route for sample interval.
 * @param distEnd The end distance on route for sample interval.
 */
- (nonnull NSArray <NSNumber *> *)getElevationSamples:(int)countSamples distBegin:(int)distBegin distEnd:(int)distEnd;

/**
 * Returns the elevation at the given distance.
 * @param distance The distance in meters from departure point/start of route.
 */
- (float)getElevation:(int)distance;

/**
 * Returns the list of route climb sections, that is, which are increasing in elevation.
 */
- (nonnull NSArray <ClimbSectionObject *> *)getClimbSections;

/**
 * Returns the list of route sections which are flat, that is, no significant elevation change.
 */
- (nonnull NSArray <SurfaceSectionObject *> *)getSurfaceSections;

/**
 * Returns the list of route sections which are of type road, typically, paved.
 */
- (nonnull NSArray <RoadTypeSectionObject *> *)getRoadTypeSections;

/**
 * Get list of route sections which are abrupt, that is, they have a significant elevation change.
 * @param categs The user list of steep categories. Each entry contains the max slope for the steep category as diffX / diffY.
 * @details A common steep categories list is { -16.f, -10.f, -7.f, -4.f, -1.f, 1.f, 4.f, 7.f, 10.f, 16.f }
 * @details A positive value is for an ascension category, a negative value if a descent category.
 * @details Each section has the start distance from route start and the category ( index in user defined steep categories ).
 * @details The end of the section is the distance from start of the next section or route total length ( for the last section ).
 */
- (nonnull NSArray <RoadSteepSectionObject *> *)getSteepSections:(NSArray <NSNumber *> *)steepnessIntervals;

/**
 * Returns the elevation chart min value Oy.
 */
- (float)getElevationChartMinValueY;

/**
 * Returns the elevation chart max value Oy.
 */
- (float)getElevationChartMaxValueY;

@end

NS_ASSUME_NONNULL_END
