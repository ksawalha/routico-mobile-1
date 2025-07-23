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
#import <GEMKit/LandmarkObject.h>
#import <GEMKit/LandmarkCategoryObject.h>
#import <GEMKit/LandmarkStoreContext.h>
#import <GEMKIt/FollowPositionPreferencesContext.h>
#import <GEMKit/MapViewHeader.h>
#import <GEMKit/RouteObject.h>
#import <GEMKit/ImageObject.h>
#import <GEMKit/PathCollectionObject.h>
#import <GEMKit/MapViewRouteRenderSettings.h>
#import <GEMKit/MarkerCollectionObject.h>
#import <GEMKit/LandmarkStoreContextCollection.h>
#import <GEMKit/MapViewRouteObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * An object that manages map view preferences.
 */
__attribute__((visibility("default"))) @interface MapViewPreferencesContext : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Change the map view perspective.
 * @param perspective The map perspective.
 * @param duration The fly animation duration in milliseconds. 0 means no animation. Default is none.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)setMapViewPerspective:(MapViewPerspective)perspective animationDuration:(NSTimeInterval)duration completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Returns the map view perspective.
 */
- (MapViewPerspective)getMapViewPerspective;

/**
 * Returns the viewing angle.
 */
- (double)getViewAngle;

/**
 * Returns the minimum viewing angle.
 * @details The minimum view angle is when the camera is looking directly downward at the map.
 */
- (double)getMinViewAngle;

/**
 * Returns the maximum viewing angle.
 * @details The maximum view angle is when the camera is looking directly toward the horizon.
 */
- (double)getMaxViewAngle;

/**
 * Sets the viewing angle.
 * @param value The view angle.
 */
- (void)setViewAngle:(double)value;

/**
 * Sets the tilt angle in degrees.
 * @param angle The tilt angle in degrees.
 */
- (void)setTiltAngle:(double)angle;

/**
 * Gets the tilt angle in degrees.
 */
- (double)getTiltAngle;

/**
 * Gets the map rotation angle in degrees relative to north-south axis. The value of 0 corresponds to north-up alignment.
 */
- (double)getRotationAngle;

/**
 * Sets the map rotation angle in degrees relative to north-south axis. The value of 0 corresponds to north-up alignment.
 */
- (void)setRotationAngle:(double)value;

/**
 * Get access to the visibility settings for the landmark stores..
 */
- (nullable LandmarkStoreContextCollection *)getLandmarkStoreCollection;

/**
 * Returns the path collection from the map.
 */
- (nullable PathCollectionObject *)getPaths;

/**
 * Returns the marker collection from the map.
 */
- (nullable MarkerCollectionObject *)getMarkers;

/**
 * Returns the traffic visibility.
 * @details By default is true if current map style contains the traffic layer.
 */
- (BOOL)getTrafficVisibility;

/**
 * Sets the traffic visibility.
 * @details Will return SDKErrorCodeKNotFound if current map style doesn't contains the traffic layer.
 */
- (SDKErrorCode)setTrafficVisibility:(BOOL)state;

/**
 * Enable / Disable the cursor mode.
 * When the cursor is enabled map selection can be activated by calling setCursorScreenPosition. The cursor is automatically disabled by MapView::startFollowingPosition.
 */
- (void)enableCursor:(BOOL)value;

/**
 * Test if cursor is enabled. Default is false.
 */
- (BOOL)isCursorEnabled;

/**
 * Enable / Disable the cursor rendering.
 */
- (void)enableCursorRender:(BOOL)value;

/**
 * Test if cursor render is enabled. Default is false.
 */
- (BOOL)isCursorRenderEnabled;

/**
 * Set map view details by content path.
 * @param path The content path.
 * @param smoothTransition Enables a smooth transition between old and new style.
 */
- (void)setMapStyleWithPath:(nonnull NSString *)path smoothTransition:(BOOL)smoothTransition;

/**
 * Set map view details by content data.
 * @param data The content data.
 * @param smoothTransition Enables a smooth transition between old and new style.
 */
- (void)setMapStyleWithData:(nonnull NSData *)data smoothTransition:(BOOL)smoothTransition;

/**
 * Set map view details by content identifier.
 * @param identifier The content id.
 * @param smoothTransition Enables a smooth transition between old and new style.
 */
- (void)setMapStyleWithIdentifier:(NSInteger)identifier smoothTransition:(BOOL)smoothTransition;

/**
 * Returns the current map style identifier.
 */
- (NSInteger)getMapStyleId;

/**
 * Set buildings visibility to the specified option.
 */
- (void)setBuildingsVisibility:(BuildingsVisibility)visibility;

/**
 * Returns the buildings visibility.
 */
- (BuildingsVisibility)getBuildingsVisibility;

/**
 * Gets follow position preferences.
 */
- (nonnull FollowPositionPreferencesContext *)getFollowPositionPreferences;

/**
 * Enable / disable frames per second draw.
 */
- (void)setDrawFPS:(BOOL)value position:(CGPoint)point;

/**
 * Get the map view focus viewport.
 * @details The focus viewport is the view screen part containing the maximum map details. The coordinates are relative to view parent screen.
 * @details The default value is the view whole viewport.
 * @details The values are in pixels.
 */
- (CGRect)getFocusViewport;

/**
 * Set the map view focus viewport rectangle.
 * @details If rect is empty the focus will be reset to whole view.
 * @details The values are in pixels.
 */
- (void)setFocusViewport:(CGRect)rect;

/**
 * Get the map labels fading animation status.
 * @details By default fading animation is On.
 */
- (BOOL)getMapLabelsFading;

/**
 * Set the map labels fading animation.
 * @details By default fading animation is On.
 */
- (void)setMapLabelsFading:(BOOL)status;

/**
 * Set the map labels continuous rendering state.
 * @details By default is false.
 */
- (void)setMapLabelsContinuousRendering:(BOOL)status;

/**
 * Get the map labels continuous rendering state.
 */
- (BOOL)getMapLabelsContinuousRendering;

/**
 * Get the fast data loading disable state.
 * @details Returns true if fast data loading is disabled.
 */
- (BOOL)getDisableFastLoading;

/**
 * Disable the fast data loading when moving camera.
 */
- (void)setDisableFastLoading:(BOOL)status;

/**
 * Enables or disables the map scale.
 */
- (void)showMapScale:(BOOL)status;

/**
 * Check if map scale is shown.
 */
- (BOOL)isMapScaleShown;

/**
 * Sets the map scale position.
 * @param rect - The rectangle position related to parent view.
 */
- (void)setMapScalePosition:(CGRect)rect;

/**
 * Gets the map scale position.
 */
- (CGRect)getMapScalePosition;

/**
 * Sets the elevation alpha factor.
 * @param factor - float value between 0 and 1 to set the elevation shadows opacity
 */
- (void)setElevationAlphaFactor:(float)factor;

/**
 * Gets the elevation alpha factor.
 */
- (float)getElevationAlphaFactor;

/**
 * Gets frames per second draw state.
 */
- (BOOL)getDrawFPS;

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
 * Enable / disable touch gesture.
 * @param gesture Map view gesture.
 */
- (SDKErrorCode)enableTouchGesture:(MapViewTouchGestures)gesture enable:(BOOL)state;

/**
 * Enable / disable touch gestures.
 * @param gestures Packed map view gestures.
 */
- (SDKErrorCode)enableTouchGestures:(int)gestures enable:(BOOL)state;

/**
 * Check if touch gesture is enabled.
 */
- (BOOL)isTouchGestureEnabled:(MapViewTouchGestures)gesture;

/**
 * Get enabled touch gestures packed.
 */
- (int)getTouchGesturesStates;

/**
 * Set enabled touch gestures packed.
 */
- (void)setTouchGesturesStates:(int)gestures;

/**
 * Get number of routes in this collection.
 */
- (int)routesCollectionSize;

/**
 * Get route specified by index.
 */
- (nullable RouteObject *)getRoute:(int)index;

/**
 * Get index of the specified route. Returns < 0 for error.
 */
- (int)indexOf:(nonnull RouteObject *)route;

/**
 * Check if the route is the main route in the collection.
 */
- (BOOL)isMainRoute:(nonnull RouteObject *)routeObject;

/**
 * Gets the current main route.
 */
- (nullable RouteObject *)getMainRoute;

/**
 * Set the route as main route in the collection.
 */
- (void)setMainRoute:(nonnull RouteObject *)routeObject;

/**
 * Add a route in the collection of visible routes.
 * @param routeObject The route object.
 * @param isMainRoute True if the route is the main route, false if alternative route.
 * @param label The route label string.
 * @param images The route label images.
 */
- (BOOL)addRoute:(nonnull RouteObject *)routeObject isMainRoute:(BOOL)isMainRoute label:(nullable NSString *)label images:(nullable NSArray <UIImage *> *)images;

/**
 * Remove the route.
 */
- (void)removeRoute:(nonnull RouteObject *)routeObject;

/**
 * Check if a route object is part of the routes collection.
 */
- (BOOL)containsRoute:(nonnull RouteObject *)routeObject;

/**
 * Remove all routes.
 */
- (void)clearRoutes;

/**
 * Returns the route custom render settings.
 */
- (nullable MapViewRouteRenderSettings *)getRenderSettings:(nonnull RouteObject *)routeObject;

/**
 * Sets the route custom render settings.
 */
- (void)setRenderSettings:(nonnull MapViewRouteRenderSettings *)settings route:(nonnull RouteObject *)routeObject;

/**
 * Get route label text.
 */
- (nullable NSString *)getRouteLabel:(nonnull RouteObject *)routeObject;

/**
 * Set route bubble text.
 * @param routeObject The route for which the label wants to be set.
 * @param label The route label string.
 * @details The route label supports custom icon placement inside the text by using the icon place-mark %%icon index%%, e.g. "My header text %%0%%\n%%1%% my footer".
 * @details The %%icon index%% must be a valid integer in images list container, i.e. 0 <= icon index < images.size()
 */
- (void)setRouteLabel:(nonnull RouteObject *)routeObject label:(nonnull NSString *)label;

/**
 * Get route image list.
 */
- (nonnull NSArray <ImageObject *> *)getRouteImages:(nonnull RouteObject *)routeObject;

/**
 * Set route bubble image.
 */
- (void)setRouteImages:(nonnull RouteObject *)routeObject images:(nonnull NSArray <UIImage *> *)images;

/**
 * Hide the route label.
 */
- (void)hideRouteLabel:(nonnull RouteObject *)routeObject;

/**
 * Get all map view routes in the collection.
 */
- (nonnull NSArray <MapViewRouteObject *> *)getMapViewRoutes;

@end

NS_ASSUME_NONNULL_END
