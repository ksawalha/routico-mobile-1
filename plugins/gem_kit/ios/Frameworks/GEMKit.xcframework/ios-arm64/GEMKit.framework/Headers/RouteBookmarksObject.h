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
#import <GEMKit/RoutePreferencesObject.h>
#import <GEMKit/CoordinatesObject.h>
#import <GEMKit/LandmarkObject.h>
#import <GEMKit/TimeObject.h>
#import <GEMKit/PathObject.h>

/**
 * Constants indicating the sort order of the routes.
 */
typedef NS_ENUM(NSInteger, RouteBookmarksSort)
{
    /// Sorts descending by update time ( most recent at top ).
    RouteBookmarksSortByDate = 0,
    
    /// Sorts ascending by name.
    RouteBookmarksSortByName,
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates route bookmarks information.
 */
__attribute__((visibility("default"))) @interface RouteBookmarksObject : NSObject

/**
 * Initializes and returns a newly allocated object using the file name and folder name ( optionally ).
 */
- (instancetype)initWithFileName:(nonnull NSString *)file folderName:(nullable NSString *)folder;

/**
 * Returns the bookmarks collection path.
 */
- (nonnull NSString *)getFilePath;

/**
 * Changes the sort order of the routes.
 */
- (void)setSortOrder:(RouteBookmarksSort)sort;

/**
 * Returns the number of routes.
 */
- (int)getSize;

/**
 * Returns the name of the route specified by index.
 */
- (nonnull NSString *)getName:(int)index;

/**
 * Returns the preferences of the route specified by index.
 */
- (nonnull RoutePreferencesObject *)getPreferences:(int)index;

/**
 * Returns the waypoints of the route specified by index.
 */
- (nonnull NSArray <LandmarkObject *> *)getWaypoints:(int)index;

/**
 * Returns the timestamp of the route specified by index.
 */
- (nullable TimeObject*)getTimestamp:(int)index;

/**
 * Returns true if updating the route was done with success.
 */
- (BOOL)update:(int)index name:(nonnull NSString *)name list:(nonnull NSArray <LandmarkObject *> *)waypoints preferences:(nullable RoutePreferencesObject *)preferences;

/**
 * Returns true if the add route operation was done with success.
 */
- (BOOL)add:(nonnull NSString *)name list:(nonnull NSArray <LandmarkObject *> *)waypoints preferences:(nullable RoutePreferencesObject *)preferences overwrite:(BOOL)overwrite;

/**
 * Returns the number of imported routes, otherwise 0 for operation failed.
 */
- (NSInteger)addTrips:(nonnull NSString*)fileName skipDuplicates:(BOOL)skipDuplicates;

/**
 * Returns true if the remove operation was done with success.
 */
- (BOOL)remove:(int)index;

/**
 * Clears routes.
 */
- (void)clear;

/**
 * Creates a basic route unique name based on waypoints coordinates.
 */
- (nonnull NSString *)getBaseUniqueName:(nonnull NSArray < LandmarkObject *> *)waypoints;

/**
 * Create a new landmark with the given track.
 * @return New landmark object with the path if operation succeeded.
 */
+ (nullable LandmarkObject *)setWaypointTrackData:(nonnull PathObject *)pathObject;

/**
 * Add the given track to landmark.
 * @return New landmark object with the path if operation succeeded.
 */
+ (nullable LandmarkObject *)setWaypointTrackData:(nonnull LandmarkObject *)landmarkObject path:(nonnull PathObject *)pathObject;

/**
 * Extract track from the given landmark.
 */
+ (nullable PathObject *)getWaypointTrackData:(nonnull LandmarkObject *)landmarkObject;

/**
 * Returns true if the landmark has track data.
 */
+ (BOOL)waypointHasTrackData:(nonnull LandmarkObject *)landmarkObject;

/**
 * Returns true if the reverse waypoint track data operation was done with success.
 */
+ (BOOL)reverseWaypointTrackData:(nonnull LandmarkObject *)landmarkObject;

/**
 * Returns true if the truncate track data operation between the given departure and destination coordinates was done with success.
 */
+ (BOOL)setWaypointTrackDepartureAndDestination:(nonnull LandmarkObject *)landmarkObject departure:(nonnull CoordinatesObject *)departure destination:(nonnull CoordinatesObject *)destination;

/**
 * Export the route to the given file.
 */
- (BOOL)exportToFile:(int)index path:(nonnull NSString *)path;

/**
 * Set auto delete mode.
 * @details If auto delete mode is true, the database if automatically deleted when object is destroyed.
 * @details Default is false.
 */
- (void)setAutoDeleteMode:(BOOL)mode;

/**
 * Get auto delete mode.
 * @details If auto delete mode is true, the database if automatically deleted when object is destroyed.
 * @details Default is false
 */
- (BOOL)getAutoDeleteMode;

@end

NS_ASSUME_NONNULL_END
