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
#import <GEMKit/RouteObject.h>
#import <GEMKit/OverlayItemObject.h>
#import <GEMKit/MapViewHeader.h>
#import <GEMKit/TrafficEventObject.h>

@class MapViewController;

/**
 * A set of delegate methods for map view controller objects.
 */
__attribute__((visibility("default"))) @protocol MapViewControllerDelegate <NSObject>

@optional

/**
 * Notifies the delegate when the map view is initialized and ready to be used.
 * @param mapViewController The map view controller informing the delegate of this event.
 */
- (void)mapViewControllerReady:(nonnull MapViewController *)mapViewController;

/**
 * Notifies the delegate before map view rendering is started.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param cameraStatus The view camera transition status.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController willRender:(ViewCameraTransitionStatus)cameraStatus;

/**
 * Notifies the delegate when the map view rendering is finished.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param dataStatus The view data transition status.
 * @param cameraStatus The view camera transition status.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didRender:(ViewDataTransitionStatus)dataStatus cameraTransitionStatus:(ViewCameraTransitionStatus)cameraStatus;

/**
 * Notifies the delegate when the map view enters/exits following position mode.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param isFollowingPosition The current state.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController onFollowingPositionStateChanged:(BOOL)isFollowingPosition;

/**
 * Notifies the delegate when the map view camera entered / exited manually adjusted following position.
 * @param mapViewController The map view controller informing the delegate of this event.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController onFollowingPositionModifyByTouchHandler:(BOOL)isModify;

/**
 * Notifies the delegate when the map view style has been changed.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param identifier The map style identifier.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController onMapStyleChanged:(NSInteger)identifier;

/**
 * Notifies the delegate with the single pointer touch down event.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param point The touch point.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController onTouchPoint:(CGPoint)point;

/**
 * Notifies the delegate with the single pointer long touch event.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param point The long touch point.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController onLongTouchPoint:(CGPoint)point;

/**
 * Notifies the delegate with single pointer double touch event.
 * @details A double touch event is defined as two consecutive touches within a preset time duration in milliseconds, and distance between the two touches has to be less than a preset distance in millimeters.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param position The position where the event occurred.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController onDoubleTouch:(CGPoint)position;

/**
 * Notifies the delegate with two pointers touch event.
 * @details A two pointers touch event is defined as two simultaneous touches from which the pointer ups are within a preset time in milliseconds.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param position The mid position of the segment determined by the two pointer positions.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController onTwoTouches:(CGPoint)position;

/**
 * Notifies the delegate with move event.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param startPoint The start point.
 * @param endPoint The end point.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController onMovePoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;

/**
 * Notifies the delegate with two pointers pinch event.
 * @details A two pointers rotate event is defined as two pointers down, followed by rotation such that the distance between the pointers remains within a preset threshold.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param startPoint1 The start position for first pointer.
 * @param startPoint2 The start position for second pointer.
 * @param endPoint1 The end position for first pointer.
 * @param endPoint2 The end position for second pointer.
 * @param center The rotation center.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController onPinch:(CGPoint)startPoint1 startPoint2:(CGPoint)startPoint2 toPoint1:(CGPoint)endPoint1 toPoint2:(CGPoint)endPoint2 center:(CGPoint)center;

/**
 * Notifies the delegate with two pointers shove event.
 * @details Two pointers move with distance between pointers and pointers angle remaining inside predefined thresholds.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param pointersAngleDeg The angle in degrees determined by the two pointers involved in gesture.
 * @param initial is the mid point of the segment determined by the two pointers initial touch down positions.
 * @param start The mid point of the segment determined by the two pointers previous positions.
 * @param end The mid point of the segment determined by the two pointers current positions.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController onShove:(double)pointersAngleDeg initial:(CGPoint)initial start:(CGPoint)start end:(CGPoint)end;

/**
 * Notifies the delegate if the map should handle landmark selection.
 * @param mapViewController The map view controller informing the delegate of this event.
 */
- (BOOL)shouldSelectLandmark:(nonnull MapViewController *)mapViewController;

/**
 * Notifies the delegate with the map selected landmark.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param landmark The selected landmark.
 * @param point The touch point.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didSelectLandmark:(nonnull LandmarkObject *)landmark onTouchPoint:(CGPoint)point;

/**
 * Notifies the delegate with the map selected landmarks.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param landmark The selected landmarks.
 * @param point The touch point.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didSelectLandmarks:(nonnull NSArray <LandmarkObject *> *)landmarks onTouchPoint:(CGPoint)point;

/**
 * Notifies the delegate with the map selected landmark.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param landmark The selected landmark.
 * @param point The long touch point.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didSelectLandmark:(nonnull LandmarkObject *)landmark onLongTouchPoint:(CGPoint)point;

/**
 * Notifies the delegate with the map selected landmarks.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param landmark The selected landmark.
 * @param point The long touch point.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didSelectLandmarks:(nonnull NSArray <LandmarkObject *> *)landmarks onLongTouchPoint:(CGPoint)point;
/**
 * Notifies the delegate with the list of streets under the cursor location.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param streets The list of streets.
 * @param point The touch point.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didSelectStreets:(nonnull NSArray<LandmarkObject *> *)streets onTouchPoint:(CGPoint)point;

/**
 * Notifies the delegate if the map should handle streets selection.
 * @param mapViewController The map view controller informing the delegate of this event.
 */
- (BOOL)shouldSelectStreets:(nonnull MapViewController *)mapViewController;

/**
 * Notifies the delegate with the list of streets under the cursor location.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param streets The list of streets.
 * @param point The long touch point.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didSelectStreets:(nonnull NSArray<LandmarkObject *> *)streets onLongTouchPoint:(CGPoint)point;

/**
 * Notifies the delegate if the map should handle route selection.
 * @param mapViewController The map view controller informing the delegate of this event.
 */
- (BOOL)shouldSelectRoute:(nonnull MapViewController *)mapViewController;

/**
 * Notifies the delegate with the map selected route.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param route The new main route.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didSelectRoute:(nonnull RouteObject *)route;

/**
 * Notifies the delegate with the map selected routes.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param route The new main route.
 * @param point The touch point.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didSelectRoutes:(nonnull NSArray<RouteObject *> *)routes onTouchPoint:(CGPoint)point;

/**
 * Notifies the delegate if the map should handle overlays selection.
 * @param mapViewController The map view controller informing the delegate of this event.
 */
- (BOOL)shouldSelectOverlays:(nonnull MapViewController *)mapViewController;

/**
 * Notifies the delegate with the list of overlays under the cursor location.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param overlays The list of overlays.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didSelectOverlays:(nonnull NSArray<OverlayItemObject *> *)overlays;

/**
 * Notifies the delegate with the list of overlays under the cursor location.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param overlays The list of overlays.
 * @param point The touch point.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didSelectOverlays:(nonnull NSArray<OverlayItemObject *> *)overlays onTouchPoint:(CGPoint)point;

/**
 * Notifies the delegate with the list of overlays under the cursor location.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param overlays The list of overlays.
 * @param point The long touch point.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didSelectOverlays:(nonnull NSArray<OverlayItemObject *> *)overlays onLongTouchPoint:(CGPoint)point;

/**
 * Notifies the delegate if the map should handle traffic events selection.
 * @param mapViewController The map view controller informing the delegate of this event.
 */
- (BOOL)shouldSelectTrafficEvents:(nonnull MapViewController *)mapViewController;

/**
 * Notifies the delegate with the list of traffic events under the cursor location.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param events The list of traffic events..
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didSelectTrafficEvents:(nonnull NSArray<TrafficEventObject *> *)events;

/**
 * Notifies the delegate with the list of traffic events under the cursor location.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param events The list of traffic events.
 * @param point The touch point.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didSelectTrafficEvents:(nonnull NSArray<TrafficEventObject *> *)events onTouchPoint:(CGPoint)point;

/**
 * Notifies the delegate with the list of traffic events under the cursor location.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param events The list of traffic events.
 * @param point The long touch point.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didSelectTrafficEvents:(nonnull NSArray<TrafficEventObject *> *)events onLongTouchPoint:(CGPoint)point;

/**
 * Notifies the delegate when the map view angle was updated.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param angle The new map angle in degrees.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didUpdateMapAngle:(double)angle;

/**
 * Notifies the delegate when the map compass was tapped.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param mode The follow position map rotation mode.
 */
- (void)mapViewController:(nonnull MapViewController *)mapViewController didTapCompass:(FollowPositionMapRotationMode)mode;

/**
 * Notifies the delegate when the map scale needs to be rendered.
 * @details Return false if map scale should be rendered by the SDK, otherwise client should return true and optionally do a custom render of the scale.
 * @param mapViewController The map view controller informing the delegate of this event.
 * @param width The width in pixels of the bar.
 * @param value The string value of the scale.
 * @param units The string units of the scale.
 */
- (BOOL)mapViewController:(nonnull MapViewController *)mapViewController onRenderMapScale:(NSInteger)width scaleValue:(nonnull NSString *)value scaleUnits:(nonnull NSString *)units;

@end
