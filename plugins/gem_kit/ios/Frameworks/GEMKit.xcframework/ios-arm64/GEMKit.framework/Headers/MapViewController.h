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
#import <GEMKit/MapViewHeader.h>
#import <GEMKit/LandmarkObject.h>
#import <GEMKit/LandmarkCategoryObject.h>
#import <GEMKit/LandmarkStoreContext.h>
#import <GEMKit/RouteObject.h>
#import <GEMKit/MapViewControllerDelegate.h>
#import <GEMKit/TrafficContext.h>
#import <GEMKit/RouteTrafficEventObject.h>
#import <GEMKit/RectangleGeographicAreaObject.h>
#import <GEMKit/PolygonGeographicAreaObject.h>
#import <GEMKit/GeographicAreaObject.h>
#import <GEMKit/MarkerCollectionObject.h>
#import <GEMKit/PathCollectionObject.h>
#import <GEMKit/MapViewPreferencesContext.h>
#import <GEMKit/HighlightRenderSettings.h>
#import <GEMKit/MapCameraObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * An object that manages a interactive map view.
 */
__attribute__((visibility("default"))) @interface MapViewController : UIViewController

/**
 * Init the map view with the following ppi and scale value.
 * @param ppi Screen pixel per inch.
 * @param scale Screen scale factor.
 */
- (instancetype)initWithPpi:(NSInteger)ppi scale:(CGFloat)scale;

/**
 * The initial position coordinates.
 */
@property(nonatomic, strong) CoordinatesObject *initialPosition;

/**
 * The initial zoom level.
 */
@property(nonatomic, assign) NSInteger initialZoomLevel;

/**
 * Returns the model data.
 */
- (void *)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Destroy the map view.
 */
- (void)destroy;

/**
 * The delegate for the map view controller.
 */
@property(nonatomic, weak) NSObject <MapViewControllerDelegate> *delegate;

/**
 Disable the behaviour of the map when tapping on the compass view. Default to false.
 */
@property(nonatomic, assign) BOOL disableCompassViewTapBehaviour;

/**
 * Start map render.
 */
- (void)startRender;

/**
 * Stop map render.
 */
- (void)stopRender;

/**
 * Check if render is active.
 */
- (BOOL)isRenderActive;

/**
 * Returns the map preferences context.
 */
- (nonnull MapViewPreferencesContext *)getPreferences;

/**
 * Stop the current animation.
 * @param jump True if we want to jump to the destination when stopping animation; otherwise stop immediately.
 */
- (void)skipAnimation:(BOOL)jumpToDestination;

/**
 * Check if there is an animation in progress.
 */
- (BOOL)isAnimationInProgress;

/**
 * Returns the UIView scale factor.
 */
- (CGFloat)getScaleFactor;

/**
 * Returns the ppi factor.
 */
- (NSInteger)getPpiFactor;

/**
 * Returns view viewport in parent screen coordinates.
 */
- (CGRect)getViewport;

/**
 * Set the fonts modifiers.
 * @details The modifiers apply to all fonts in screen to improve their visibility & readability.
 */
- (void)setFontModifiersScale:(CGFloat)value boldStyle:(BOOL)state;

/**
 * Set the textures scale factor.
 * @details The scale factor applies to all textures rendered in screen to improve their visibility & readability.
 */
- (void)setTextureScaleFactor:(CGFloat)value;

/**
 * Returns the cursor screen position in pixels.
 */
- (CGPoint)getCursorPosition;

/**
 * Set the cursor screen position.
 * @param point The screen point in pixels.
 */
- (void)setCursorPosition:(CGPoint)point;

/**
 * Get the cursor WGS coordinates.
 */
- (nonnull CoordinatesObject *)getCursorWgsPosition;

/**
 * Retrieves the list of landmarks under the cursor location.
 */
- (nonnull NSArray <LandmarkObject *> *)getCursorSelectionLandmarks;

/**
 * Retrieves the list of streets under the cursor location.
 */
- (nonnull NSArray <LandmarkObject *> *)getCursorSelectionStreets;

/**
 * Retrieves the list of overlay items under the cursor location.
 */
- (nonnull NSArray <OverlayItemObject *> *)getCursorSelectionOverlayItems;

/**
 * Retrieves the list of traffic events under the cursor location.
 */
- (nonnull NSArray <TrafficEventObject *> *)getCursorSelectionTrafficEvents;

/**
 * Retrieves the list of routes under the cursor location.
 */
- (nonnull NSArray <RouteObject *> *)getCursorSelectionRoutes;

/**
 * Retrieves the set of landmarks on the specified coordinates.
 */
- (nonnull NSArray <LandmarkObject *> *)getNearestLocations:(nonnull CoordinatesObject *)location;

/**
 * Returns the closest address landmark based on location.
 * @param location The location.
 * @param radius The radius in meters.
 */
- (nullable LandmarkObject *)getClosestAddress:(nonnull CoordinatesObject *)location radius:(int)radius;

/**
 * Show compass on the map.
 */
- (void)showCompass;

/**
 * Hide compass from the map.
 */
- (void)hideCompass;

/**
 * Check if compass is visible.
 */
- (BOOL)isCompassHidden;

/**
 * Set compass day mode.
 */
- (void)setCompassDayMode;

/**
 * Set compass night mode.
 */
- (void)setCompassNightMode;

/**
 * Refresh compass image.
 */
- (void)refreshCompassImage;

/**
 * Set compass to follow user interface style light or dark.
 */
- (void)setCompassFollowUserInterfaceStyle:(BOOL)value;

/**
 * Returns the compass image view.
 */
- (nonnull UIImageView *)getCompassImageView;

/**
 * Returns the compass image layout constraints array.
 */
- (nonnull NSArray <NSLayoutConstraint *> *)getCompassLayoutConstraints;

/**
 *  Register tap compass completion handler.
 */
- (void)setTapCompassCompletionHandler:(nonnull void(^)(FollowPositionMapRotationMode mode))handler;

/**
 *  Register map view render completion handler.
 */
- (void)setOnMapViewRendered:(nonnull void (^)(ViewDataTransitionStatus status, ViewCameraTransitionStatus cameratatus))handler;

/**
 *  Deregister map view render completion handler.
 */
- (void)resetOnMapViewRenderedCompletion;

/**
 * Set compass image size.
 */
- (void)setCompassSize:(CGFloat)size;

/**
 * Set the map compass insets. By default, the compass constraints are set to top-right corner.
 */
- (void)setCompassInsets:(UIEdgeInsets)insets;

/**
 * Show map logo.
 */
- (void)showMapLogo;

/**
 * Hide map logo.
 */
- (void)hideMapLogo;

/**
 * Start following the current position.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 * @param level Use -1 for automatic zoom. Bigger zoom factor means closer to the map.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)startFollowingPositionWithAnimationDuration:(NSTimeInterval)duration zoomLevel:(int)level completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Start following the current position.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 * @param level Use -1 for automatic zoom. Bigger zoom factor means closer to the map.
 * @param angle The map view angle. Default is std::numeric_limits<double>::max() meaning use default specified.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)startFollowingPositionWithAnimationDuration:(NSTimeInterval)duration zoomLevel:(int)level viewAngle:(double)angle completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Stop following the current position.
 */
- (void)stopFollowingPosition;

/**
 * Restore following position from a manually adjusted mode to default auto-zoom mode.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)restoreFollowingPositionWithAnimationDuration:(NSTimeInterval)duration completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Retrieves the camera associated with this map view.
 */
- (nullable MapCameraObject *)getMapCamera;

/**
 * Stop following the current position.
 * @param restoreCameraMode Restore camera zoom level and view angle from follow touch camera mode.
 */
- (void)stopFollowingPositionWithRestoreCameraMode:(BOOL)restoreCameraMode;

/**
 * Returns true if following the current position mode.
 */
- (BOOL)isFollowingPosition;

/**
 * Test if following the current position is modified by the touch handler.
 */
- (BOOL)isFollowingPositionTouchHandlerModified;

/**
 * Test if following the current position is in default auto-zoom mode.
 */
- (BOOL)isDefaultFollowingPosition;

/**
 * Returns the zoom level.
 */
- (int)getZoomLevel;

/**
 * Returns the maximum zoom level.
 */
- (int)getMaxZoomLevel;

/**
 * Set a new zoom level centered on the specified screen position.
 * @param level The zoom level.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 */
- (void)setZoomLevel:(int)level animationDuration:(NSTimeInterval)duration;

/**
 * Set a new zoom level centered on the specified screen position.
 * @param level The zoom level.
 * @param point The screen point in pixels.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 */
- (void)setZoomLevel:(int)level point:(CGPoint)point animationDuration:(NSTimeInterval)duration;

/**
 * Set the configured max zoom level.
 */
- (void)setMaxZoomLevel:(int)level;

/**
 * Set the configured min zoom level.
 */
- (void)setMinZoomLevel:(int)level;

/**
 * Returns the min zoom level.
 */
- (int)getMinZoomLevel;

/**
 * Set map details quality level. Default is MapDetailsQualityLevelHigh.
 * @param level Map details quality level, see MapDetailsQualityLevel.
 */
- (void)setMapDetailsQualityLevel:(MapDetailsQualityLevel)level;

/**
 * Returns the map details quality level.
 */
- (MapDetailsQualityLevel)getMapDetailsQualityLevel;

/**
 * Set the viewing angle in degrees.
 * @param value The angle in degree.
 */
- (void)setViewAngle:(double)value;

/**
 * Returns the viewing angle.
 */
- (double)getViewAngle;

/**
 * Set tilt angle in degrees.
 * @param angle The angle in degree.
 */
- (void)setTiltAngle:(double)angle;

/**
 * Returns the tilt angle in degrees.
 */
- (double)getTiltAngle;

/**
 * Returns the camera heading in degrees, with respect to Earth.
 */
- (double)getHeadingInDegrees;

/**
 * Returns the camera pitch in degrees, with respect to Earth.
 */
- (double)getPitchInDegrees;

/**
 * Returns the map view current scale ( meters for 1 mm ).
 */
- (double)getMapScale;

/**
 * Check if map view contains terrain topography information.
 * @details The map view has terrain topography if the map style includes the terrain elevation layer and data is available on queried location
 */
- (BOOL)hasTerrainTopography;

/**
 * Set custom watermark texts to show on the map.
 * @param line1 The first line to show.
 * @param line2 The second line to show - this has a smaller font
 */
- (void)setWatermarkText:(nonnull NSString *)line1 line2:(nonnull NSString *)line2;

/**
 * Center the map.
 * @param zoomLevel Use -1 for automatic zoom. Bigger zoom factor means closer to the map.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 */
- (void)centerOnZoomLevel:(int)zoomLevel animationDuration:(NSTimeInterval)duration;

/**
 * Center the map on location.
 * @param location The location object.
 * @param level Use -1 for automatic zoom. Bigger zoom factor means closer to the map.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 */
- (void)centerOnCoordinates:(nonnull CoordinatesObject *)location zoomLevel:(int)level animationDuration:(NSTimeInterval)duration;

/**
 * Center the map on location.
 * @param location The location object.
 * @param level Use -1 for automatic zoom. Bigger zoom factor means closer to the map.
 * @param mapAngle Map rotation angle in the range [0.0, 360.0] degrees. (Use std::numeric_limits<double>::max() for automatic selection).
 * @param viewAngle Map view angle in the range [-90.0, 90.0] degrees.  (Use std::numeric_limits<double>::max() for automatic selection).
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 */
- (void)centerOnCoordinates:(nonnull CoordinatesObject *)location zoomLevel:(int)level mapAngle:(double)mapAngle viewAngle:(double)viewAngle animationDuration:(NSTimeInterval)duration;

/**
 * Center the map on location.
 * @param location The location object.
 * @param level Use -1 for automatic zoom. Bigger zoom factor means closer to the map.
 * @param point Screen position in pixels where the coordinates should project ( default uses the specified cursor coordinates ).
 * @param mapAngle Map rotation angle in the range [0.0, 360.0] degrees. (Use std::numeric_limits<double>::max() for automatic selection).
 * @param viewAngle Map view angle in the range [-90.0, 90.0] degrees.  (Use std::numeric_limits<double>::max() for automatic selection).
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)centerOnCoordinates:(nonnull CoordinatesObject *)location zoomLevel:(int)level point:(CGPoint)point mapAngle:(double)mapAngle viewAngle:(double)viewAngle animationDuration:(NSTimeInterval)duration completionHandler:(nonnull void(^)(BOOL finished))handler;

/**
 * Center the map on location.
 * @param location The location object.
 * @param level Use -1 for automatic zoom. Bigger zoom factor means closer to the map.
 * @param point Screen position in pixels where the coordinates should project ( default uses the specified cursor coordinates ).
 * @param mapAngle Map rotation angle in the range [0.0, 360.0] degrees. (Use std::numeric_limits<double>::max() for automatic selection).
 * @param viewAngle Map view angle in the range [-90.0, 90.0] degrees.  (Use std::numeric_limits<double>::max() for automatic selection).
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 */
- (void)centerOnCoordinates:(nonnull CoordinatesObject *)location zoomLevel:(int)level point:(CGPoint)point mapAngle:(double)mapAngle viewAngle:(double)viewAngle animationDuration:(NSTimeInterval)duration;

/**
 * Change the map view perspective.
 * @param perspective The map perspective.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)setPerspective:(MapViewPerspective)perspective animationDuration:(NSTimeInterval)duration completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Get the map view perspective.
 */
- (MapViewPerspective)getPerspective;

/**
 * Align the map north up.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)alignNorthUpWithAnimationDuration:(NSTimeInterval)duration completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Draw a marker collection on the map.
 * @param markerCollection The marker collection.
 */
- (void)addMarker:(nonnull MarkerCollectionObject *)markerCollection;

/**
 * Draw a marker collection on the map with center layout animation.
 * @param markerCollection The marker collection.
 * @param duration The fly animation duration in milliseconds. 0 means no animation. -1, means without center on the area.
 */
- (void)addMarker:(nonnull MarkerCollectionObject *)markerCollection animationDuration:(NSTimeInterval)duration;

/**
 * Draw a marker collection on the map with custom render settings.
 * @param markerCollection The marker collection.
 * @param renderSettings The render settings.
 */
- (void)addMarker:(nonnull MarkerCollectionObject *)markerCollection renderSettings:(MarkerCollectionObjectRenderSettings)renderSettings;

/**
 * Draw a marker collection on the map with custom render settings.
 * @param markerCollection The marker collection.
 * @param renderSettings The render settings.
 * @param duration The fly animation duration in milliseconds. 0 means no animation. -1, means without center on the area.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)addMarker:(nonnull MarkerCollectionObject *)markerCollection renderSettings:(MarkerCollectionObjectRenderSettings)renderSettings animationDuration:(NSTimeInterval)duration completionHandler:(nonnull void(^)(BOOL finished))handler;

/**
 * Remove the specified marker collection from the map.
 * @param markerCollection The marker collection.
 */
- (void)removeMarker:(nonnull MarkerCollectionObject *)markerCollection;

/**
 * Removes all the markers collection from the map.
 */
- (void)removeAllMarkers;

/**
 * Returns the available markers collection from the map.
 */
- (nonnull NSArray <MarkerCollectionObject *> *)getAvailableMarkers;

/**
 * Returns the path collection from the map.
 */
- (nullable PathCollectionObject *)getPaths;

/**
 * Removes all the paths collection from the map.
 */
- (void)removeAllPaths;

/**
 * Apply the following map style to the map.
 * @param styleIdentifier The map style identifier.
 * @param smoothTransition Set true for a smooth transition between old and new style.
 */
- (void)applyStyleWithStyleIdentifier:(NSInteger)styleIdentifier smoothTransition:(BOOL)smoothTransition;

/**
 * Apply the following map style to the map.
 * @param styleBuffer The map style data buffer.
 * @param smoothTransition Set true for a smooth transition between old and new style.
 */
- (void)applyStyleWithStyleBuffer:(nonnull NSData *)styleBuffer smoothTransition:(BOOL)smoothTransition;

/**
 * Apply the following map style to the map.
 * @param filePath The map style file path.
 * @param smoothTransition Set true for a smooth transition between old and new style.
 */
- (void)applyStyleWithFilePath:(nonnull NSString *)filePath smoothTransition:(BOOL)smooth;

/**
 * Returns the current map style identifier.
 * @details If no style is yet set the function returns 0.
 */
- (NSInteger)getStyleIdentifier;

/**
 * Start a search request for the given query using the map view center as the reference point.
 * @param query The query string.
 * @param handler The block to execute asynchronously with the search results.
 */
- (void)searchWithQuery:(nonnull NSString*)query completionHandler:(nonnull void(^)(NSArray<LandmarkObject *> *array))handler;

/**
 * Start a nearby search request using the map view center as the reference point.
 * @param handler The block to execute asynchronously with the search results.
 */
- (void)searchAroundWithCompletionHandler:(nonnull void(^)(NSArray<LandmarkObject *> *array))handler;

/**
 * Start a nearby search request using the map view center as the reference point.
 * @param category The search category.
 * @param handler The block to execute asynchronously with the search results.
 */
- (void)searchAroundWithCategory:(nonnull LandmarkCategoryObject *)category completionHandler:(void(^)(NSArray<LandmarkObject *> *array))handler;

/**
 * Stop a search request.
 */
- (void)cancelSearch;

/**
 * Set the search max number of matches.
 */
- (void)setMaxMatches:(int)value;

/**
 * If set to true, only an exact match of free text search is returned as result.
 */
- (void)setExactMatch:(BOOL)value;

/**
 * If set to true, search is perform through the addresses.
 */
- (void)setSearchAddresses:(BOOL)value;

/**
 * If set to true, search is perform through map POIs.
 */
- (void)setSearchMapPOIs:(BOOL)value;

/**
 * If set to true, search will be done using only onboard data.
 */
- (void)setSearchOnlyOnboard:(BOOL)value;

/**
 * Set the search threshold distance.
 * @details This may be used to control the reverse geocoding and search along route lookup area.
 * @param threshold The threshold value.
 */
- (void)setThresholdDistance:(int)threshold;

/**
 * Set the search landmark category. Returns true if operation was successful.
 * @param category The landmark category object.
 */
- (BOOL)setCategory:(nonnull LandmarkCategoryObject*)category;

/**
 * Enables and disables the inclusion of fuzzy search results.
 */
- (void)setAllowFuzzyResults:(BOOL)value;

/**
 * Highlight on the map the given landmark.
 * @param highlights The landmarks array.
 * @param settings The highlight render settings.
 */
- (void)presentHighlights:(nonnull NSArray<LandmarkObject *> *)highlights settings:(nonnull HighlightRenderSettings *)settings;

/**
 * Highlight on the map the given landmark.
 * @param highlights The landmarks array.
 * @param settings The highlight render settings.
 * @param highlightId The highlighted collection id. If already exist a highlighted collection with this id, it will be replaced.
 * @details Highlighted collections will be displayed ordered ascending by the highlightId.
 */
- (void)presentHighlights:(nonnull NSArray<LandmarkObject *> *)highlights settings:(nonnull HighlightRenderSettings *)settings highlightId:(int)highlightId;

/**
 * Highlight on the map the given landmarks and center on the area.
 * @param highlights The landmarks array.
 * @param settings The highlight render settings.
 * @param highlightId The highlighted collection id. If already exist a highlighted collection with this id, it will be replaced.
 * @param duration The center fly animation duration in milliseconds. 0, means no animation. -1, means without center on the area.
 * @param handler The block to execute asynchronously with the result.
 * @details Highlighted collections will be displayed ordered ascending by the highlightId.
 * @details The edge area insets ( from setEdgeAreaInsets API ) is taking into consideration for centering.
 */
- (void)presentHighlights:(nonnull NSArray<LandmarkObject *> *)highlights settings:(nonnull HighlightRenderSettings *)settings highlightId:(int)highlightId animationDuration:(NSTimeInterval)duration completionHandler:(nonnull void(^)(BOOL finished))handler;

/**
 * Remove map highlights with id.
 * @param highlightId The highlighted collection id.
 */
- (void)removeHighlight:(int)highlightId;

/**
 * Disable all highlights.
 */
- (void)removeHighlights;

/**
 * Returns the highlight geographic area.
 */
- (nullable RectangleGeographicAreaObject *)getHighlightArea;

/**
 * Returns the highlight geographic area for the collection id.
 * @param highlightId The highlighted collection id.
 */
- (nullable RectangleGeographicAreaObject *)getHighlightArea:(int)highlightId;

/**
 * Returns the highlighted landmarks for the collection id.
 * @param highlightId The highlighted collection id.
 */
- (nonnull NSArray <LandmarkObject *> *)getHighlight:(int)highlightId;

/**
 * Show routes on the map. The main route is considered the first route from the list.
 * @param routes The list of routes.
 * @param traffic The traffic context, if available.
 * @param summary Specify true for route summary to be visible.
 */
- (void)showRoutes:(nonnull NSArray<RouteObject *> *)routes withTraffic:(nullable TrafficContext *)traffic showSummary:(BOOL)summary;

/**
 * Show better route on the map.
 * @param route The better route.
 * @param trafficContext The traffic context, if available.
 * @param timeGain The time gain in minutes.
 * @param summary Specify true for route summary to be visible.
 */
- (void)showBetterRoute:(nonnull RouteObject *)route withTraffic:(nullable TrafficContext *)trafficContext timeGain:(NSUInteger)timeGain showSummary:(BOOL)summary;

/**
 * Present routes on the map with center layout animation. The main route is considered the first route from the list.
 * @param routes The list of routes.
 * @param traffic The traffic context, if available.
 * @param summary Specify true for route summary to be visible.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 */
- (void)presentRoutes:(nonnull NSArray<RouteObject *> *)routes withTraffic:(nullable TrafficContext *)traffic showSummary:(BOOL)summary animationDuration:(NSTimeInterval)duration;

/**
 * Present routes on the map with center layout animation. The main route is considered the first route from the list.
 * @param routes The list of routes.
 * @param traffic The traffic context, if available.
 * @param summary Specify true for route summary to be visible.
 * @param mode The display mode.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)presentRoutes:(nonnull NSArray<RouteObject *> *)array withTraffic:(nullable TrafficContext *)trafficContext showSummary:(BOOL)summary displayMode:(RouteDisplayMode)mode animationDuration:(NSTimeInterval)duration completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Remove the summary label from the routes.
 * @param routes The list of routes.
 */
- (void)hideSummaryFor:(nonnull NSArray<RouteObject *> *)routes;

/**
 * Remove routes from the map.
 * @param routes The list of routes.
 */
- (void)removeRoutes:(nonnull NSArray<RouteObject *> *)routes;

/**
 * Returns the routes presented on the map view. The main route is the last route in the collection.
 */
- (nonnull NSArray < RouteObject *> *)getPresentedRoutes;

/**
 * Remove all map routes.
 */
- (void)removeAllRoutes;

/**
 * Center the map on the given routes collection.
 * @param routes The list of routes.
 * @param mode The display mode.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 * @details The edge area insets ( from setEdgeAreaInsets API ) is taking into consideration.
 */
- (void)centerOnRoutes:(nonnull NSArray<RouteObject *> *)routes displayMode:(RouteDisplayMode)mode animationDuration:(NSTimeInterval)duration;

/**
 * Center the map on the given routes collection.
 * @param routes The list of routes.
 * @param mode The display mode.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 * @param handler The block to execute asynchronously with the result.
 * @details The edge area insets ( from setEdgeAreaInsets API ) is taking into consideration.
 */
- (void)centerOnRoutes:(nonnull NSArray<RouteObject *> *)array displayMode:(RouteDisplayMode)mode animationDuration:(NSTimeInterval)duration completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Center the map on the given routes collection using rectangle.
 * @param routes The list of routes.
 * @param mode The display mode.
 * @param rect The screen viewport rectangle where routes should be centered. The value must be in pixels. Leave empty to allow SDK to compute an optimal viewport
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 */
- (void)centerOnRoutes:(nonnull NSArray<RouteObject *> *)array displayMode:(RouteDisplayMode)mode rectangle:(CGRect)rect animationDuration:(NSTimeInterval)duration;

/**
 * Center the map on the given routes collection using rectangle.
 * @param routes The list of routes.
 * @param mode The display mode.
 * @param rect The screen viewport rectangle where routes should be centered. The value must be in pixels. Leave empty to allow SDK to compute an optimal viewport
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 * @param handler The block to execute asynchronously with the result.
 * @details The edge area insets ( from setEdgeAreaInsets API ) is taking into consideration.
 */
- (void)centerOnRoutes:(nonnull NSArray<RouteObject *> *)array displayMode:(RouteDisplayMode)mode rectangle:(CGRect)rect animationDuration:(NSTimeInterval)duration completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Center the map on the given route parts.
 * @details The zoom level is automatically selected so that the entire route part between start distance and end distance is visible on the map
 * @param route The route to be shown.
 * @param startDist The start distance from route begin.
 * @param endDist The end distance from route begin
 * @param rect The screen viewport rectangle where routes should be centered. The value must be in pixels.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 */
- (void)centerOnRoute:(RouteObject *)route startDist:(int)startDist endDist:(int)endDist rectangle:(CGRect)rect animationDuration:(NSTimeInterval)duration;

/**
 * Set the edge area insets. The values must be in pixels.
 */
- (void)setEdgeAreaInsets:(UIEdgeInsets)insets;

/**
 * Set the edge area insets and also refresh routes center layout.
 */
- (void)refreshRoutesWithEdgeAreaInsets:(UIEdgeInsets)insets;

/**
 * Set the route as main route.
 * @param route The main route.
 */
- (void)setMainRoute:(nonnull RouteObject *)route;

/**
 * Returns true if the route is the main route.
 * @param route The route.
 */
- (BOOL)isMainRoute:(nonnull RouteObject *)route;

/**
 * Returns the main route, if available.
 */
- (nullable RouteObject *)getMainRoute;

/**
 * Center the map on the given route instruction.
 * @param routeInstruction The route instruction.
 * @param level Use -1 for automatic zoom. Bigger zoom factor means closer to the map.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 */
- (void)centerOnRouteInstruction:(nonnull RouteInstructionObject *)routeInstruction zoomLevel:(int)level animationDuration:(NSTimeInterval)duration;

/**
 * Center the map on the given route instruction.
 * @param routeInstruction The route instruction.
 * @param level Use -1 for automatic zoom. Bigger zoom factor means closer to the map.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)centerOnRouteInstruction:(nonnull RouteInstructionObject *)routeInstruction zoomLevel:(int)level animationDuration:(NSTimeInterval)duration completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Center the map on the given traffic event.
 * @param trafficEvent The route traffic event.
 * @param level Use -1 for automatic zoom. Bigger zoom factor means closer to the map.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 */
- (void)centerOnRouteTrafficEvent:(nonnull RouteTrafficEventObject *)trafficEvent zoomLevel:(int)level animationDuration:(NSTimeInterval)duration;

/**
 * Center the map on the given traffic event.
 * @param trafficEvent The route traffic event.
 * @param level Use -1 for automatic zoom. Bigger zoom factor means closer to the map.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)centerOnRouteTrafficEvent:(nonnull RouteTrafficEventObject *)trafficEvent zoomLevel:(int)level animationDuration:(NSTimeInterval)duration completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Center the map on the given rectangle geographic area.
 * @param area The geographic area.
 * @param level Use -1 for automatic zoom. Bigger zoom factor means closer to the map.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 */
- (void)centerOnArea:(nonnull RectangleGeographicAreaObject *)area zoomLevel:(int)level animationDuration:(NSTimeInterval)duration;

/**
 * Center the map on the given rectangle geographic area.
 * @param area The geographic area.
 * @param level Use -1 for automatic zoom. Bigger zoom factor means closer to the map.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)centerOnArea:(nonnull RectangleGeographicAreaObject *)area zoomLevel:(int)level animationDuration:(NSTimeInterval)duration completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Center the map on the given polygon geographic area.
 * @param area The geographic area.
 * @param level Use -1 for automatic zoom. Bigger zoom factor means closer to the map.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 */
- (void)centerOnPolygonArea:(nonnull PolygonGeographicAreaObject *)area zoomLevel:(int)level animationDuration:(NSTimeInterval)duration completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Center the map on the given geographic area.
 * @param area The geographic area.
 * @param level Use -1 for automatic zoom. Bigger zoom factor means closer to the map.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 */
- (void)centerOnGeographicArea:(nonnull GeographicAreaObject *)area zoomLevel:(int)level animationDuration:(NSTimeInterval)duration completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Center the map on the given landmark object.
 * @param landmark The landmark object.
 * @param rect The screen viewport rectangle where the landmark should be centered. The value must be in pixels.
 * @param duration The fly animation duration in milliseconds. 0 means no animation.
 */
- (void)centerOnLocation:(nonnull LandmarkObject *)landmark rectangle:(CGRect)rect animationDuration:(NSTimeInterval)duration;

/**
 * Scroll map view.
 * @param translation.x Horizontal in screen units.
 * @details A positive value will move the map to the screen right, a negative value will move the map to the screen left.
 * @param translation.y Vertical in screen units.
 * @details A positive value will move the map to the screen bottom, a negative value will move the map to the screen top.
 */
- (void)scrollMap:(CGPoint)translation;

/**
 * Fling map view.
 * @param velocity.x Horizontal velocity in screen units.
 * @details A positive value will move the map to the screen right, a negative value will move the map to the screen left.
 * @param velocity.y Vertical velocity in screen units.
 * @details A positive value will move the map to the screen bottom, a negative value will move the map to the screen top.
 */
- (void)flingMap:(CGPoint)velocity;

/**
 * Convert a screen coordinate to a World Geodetic System coordinate.
 * @param point The screen point in pixels.
 */
- (nonnull CoordinatesObject *)transformScreenToWgs:(CGPoint)point;

/**
 * Convert a WGS84 coordinate to a screen coordinate.
 * @param location The WGS coordinates.
 * @return The screen coordinates relative to view parent screen.
 */
- (CGPoint)transformWgsToScreen:(nonnull CoordinatesObject *)location;

/**
 * Get altitude at the given coordinates.
 * @param location The WGS coordinates.
 * @return Altitude as meters from sea level if capability exist, otherwise returns 0.
 * @details Use hasTerrainTopography() to check if the map view has the capability to return an altitude at coordinates.
 */
- (double)getAltitude:(nonnull CoordinatesObject *)location;

/**
 * Convert a screen coordinate to a World Geodetic System coordinate.
 * @param rect The screen rectangle in pixels.
 */
- (nonnull NSArray <RectangleGeographicAreaObject *> *)transformScreenRectToWgs:(CGRect)rect;

/**
 * Get the clipped part of the given route as a pair ( startDistance, endDistance ).
 * @param route The target route.
 * @param rect The clipping rectangle in screen coordinates. If no clip rectangle is given, the whole screen is used.
 */
- (nonnull NSArray <NSNumber *> *)getVisibleRouteInterval:(nonnull RouteObject *)route rect:(CGRect)rect;

/**
 * Set the GPS arrow focus position in "following position" mode.
 * @param point The focus point between 0.0 and 1.0.
 */
- (void)setFollowPositionCameraFocus:(CGPoint)point;

/**
 * Returns the GPS arrow focus position in "following position" mode.
 */
- (CGPoint)getFollowPositionCameraFocus;

/**
 * Set the minimum allowed zoom level.
 */
- (void)setMinimumAllowedZoomLevel:(int)level;

/**
 * Set the maximum allowed zoom level.
 */
- (void)setMaximumAllowedZoomLevel:(int)level;

/**
 * Returns true if view camera is moving.
 */
- (BOOL)isCameraMoving;

/**
 * Set buildings visibility to the specified option.
 */
- (void)setBuildingsVisibility:(BuildingsVisibility)visibility;

/**
 * Show all the landmarks from all categories of the specified landmark store.
 */
- (void)showLandmarksFromAllCategories:(nonnull LandmarkStoreContext*)landmarkStore;

/**
 * Hide all the landmarks from all categories of the specified landmark store.
 */
- (void)hideLandmarksFromAllCategories:(nonnull LandmarkStoreContext*)landmarkStore;

/**
 * Show all the landmarks from the specified landmark category and store.
 */
- (void)showLandmarksFromCategory:(nonnull LandmarkCategoryObject*)landmarkCategory context:(nonnull LandmarkStoreContext*)landmarkStore;

/**
 * Hide all the landmarks from the specified landmark category and store.
 */
- (void)hideLandmarksFromCategory:(nonnull LandmarkCategoryObject*)landmarkCategory context:(nonnull LandmarkStoreContext*)landmarkStore;

/**
 * Check if the default position scene object is visible on the map view.
 */
- (BOOL)isDefaultPositionTrackerVisible;

/**
 * Check if the default position scene object is visible on the map view in the given rectangle.
 * @param rectangle The rectangle in screen coordinates.
 */
- (BOOL)isDefaultPositionTrackerVisible:(CGRect)rectangle;

/**
 * Set default position tracked object.
 */
- (void)setDefaultPositionTracker;

/**
 * Set flat position tracked object.
 */
- (void)setFlatPositionTracker;

/**
 * Get position tracked object coordinates.
 */
- (nullable CoordinatesObject *)getPositionTrackerCoordinates;

/**
 * Set position tracked object coordinates.
 */
- (void)setPositionTrackerCoordinates:(nonnull CoordinatesObject *)coordinates;

/**
 * Get position tracked object orientation camera angles.
 */
- (CameraOrientationAngles)getPositionTrackerOrientation;

/**
 * Set position tracked object orientation camera angles.
 */
- (void)setPositionTrackerOrientation:(CameraOrientationAngles)orientation;

/**
 * Get position tracked object visibility.
 */
- (BOOL)getPositionTrackerVisibility;

/**
 * Set position tracked object visibility.
 */
- (void)setPositionTrackerVisibility:(BOOL)state;

/**
 * Set position tracked object accuracy circle color.
 */
- (void)setPositionTrackerAccuracyCircleColor:(nonnull UIColor *)color;

/**
 * Set position tracker scale factor.
 */
- (void)setPositionTrackerScaleFactor:(double)factor;

/**
 * Get position tracker scale factor.
 */
- (double)getPositionTrackerScaleFactor;

/**
 * Get position tracker max scale factor.
 */
- (double)getPositionTrackerMaxScaleFactor;

/**
 * Get position tracker screen rectangle.
 */
- (CGRect)getPositionTrackerScreenRect;

/**
 * Customize default position tracked object.
 * @param textureData The texture input data.
 */
- (void)customizePositionTracker:(nonnull NSData *)textureData;

/**
 * Customize default position tracked object.
 * @param objData The object geometry input data.
 * @param matData The object materials input data.
 */
- (void)customizePositionTracker:(nonnull NSData *)objData material:(nonnull NSData *)matData;

/**
 * Customize default position tracked object.
 * @param data The glTF input data.
 */
- (BOOL)customizePositionTrackerGlTF:(nonnull NSData *)data;

/**
 * Save default position tracked object state.
 * @return The data buffer containing the state.
 */
- (nullable NSData *)saveStatePositionTracker;

/**
 * Restore default position tracked object state.
 * @return The operation code.
 */
- (SDKErrorCode)restoreStatePositionTracker:(nonnull NSData *)data;

/**
 * Get position tracker heading angle.
 */
- (double)getTrackingObjectHeading;

/**
 * Get tracking object pitch angle.
 */
- (double)getTrackingObjectPitch;

/**
 * Get tracking object distance to camera.
 */
- (double)getTrackingObjectDistance;

/**
 * Get tracking object zoom factor.
 */
- (double)getTrackingObjectZoomFactor;

/**
 * Make edge area visible for debug purpose only.
 */
- (void)setDebugEdgeAreaVisible:(BOOL)state;

/**
 * Set the touch behaviour new state.
 */
- (void)setTouchViewBehaviour:(TouchViewBehaviour)behaviour completionHandler:(nullable void(^)(MarkerObject * _Nullable market))handler;

/**
 * Set the touch behaviour new state with completion handler notification.
 */
- (void)setTouchViewBehaviour:(TouchViewBehaviour)behaviour didStartTouchHandler:(nullable void(^)(MarkerCollectionObject * _Nullable marketCollection))startTouchHandler didFinishTouchHandler:(nullable void(^)(MarkerObject * _Nullable market))finishTouchHandler;

/**
 * Set the touch behaviour new state with custom render settings.
 */
- (void)setTouchViewBehaviour:(TouchViewBehaviour)behaviour renderSettings:(MarkerCollectionObjectRenderSettings)renderSettings completionHandler:(nullable void(^)(MarkerObject * _Nullable market))handler;

/**
 * Get the touch behaviour state.
 */
- (TouchViewBehaviour)getTouchViewBehaviour;

/**
 * Make a screen capture of the  map.
 * @param size The size in points of the returned image.
 * @param rect The rectangle in points to capture. If (0, 0, 0, 0) is provided then the entire map screen is captured.
 */
- (nullable UIImage *)snapshotImageWithSize:(CGSize)size captureRect:(CGRect)rect;

/**
 * Generate new markers collection from route packed geometry. Old collection is removed.
 * @param data Route packed geometry buffer.
 * @param renderSettings Route render settings.
 * @param connectionsSettings Route connections render settings.
 */
- (SDKErrorCode)generateRouteGeometry:(nonnull NSData *)data routeRenderSettings:(MarkerObjectRenderSettings)renderSettings connectionsRenderSettings:(MarkerObjectRenderSettings)connectionsSettings;

/**
 * Remove markers collection for route packed geometry.
 */
- (void)removeRouteGeometry;

/**
 * Generate new marker collection from route instruction packed geometry. Old collection is removed.
 * @param data Route instruction packed geometry buffer.
 * @param renderSettings Route render settings.
 */
- (SDKErrorCode)generateNavigationInstructionGeometry:(nonnull NSData *)data renderSettings:(MarkerObjectRenderSettings)renderSettings;

/**
 * Remove marker collection from route instruction packed geometry.
 */
- (void)removeNavigationInstructionGeometry;

/**
 * Split path loop. Debug purpose only.
 */
- (void)showSplitPathLoops:(nonnull PathObject*)pathObject splitOverGeometry:(BOOL)state;

/**
 * Hide split path loop. Debug purpose only.
 */
- (void)hideSplitPathLoops;

@end

NS_ASSUME_NONNULL_END
