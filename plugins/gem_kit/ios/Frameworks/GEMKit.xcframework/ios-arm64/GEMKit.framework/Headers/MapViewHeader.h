// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all 
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V. 
// or its affiliates is strictly prohibited.

#ifndef MapViewHeader_h
#define MapViewHeader_h

/**
 * Constants indicating the route highlight options.
 */
typedef NS_ENUM(NSInteger, MapViewRouteRenderOption)
{
    /// Route is main route in collection ( i.e. it overlaps all other siblings and have different render settings ).
    MapViewRouteRenderOptionMain = 0x1,
    
    /// Display traffic status over the route.
    MapViewRouteRenderOptionShowTraffic = 0x2,
    
    /// Display the turn arrows associated with route guidance.
    MapViewRouteRenderOptionShowTurnArrows = 0x4,
    
    /// Display the route waypoints.
    MapViewRouteRenderOptionShowWaypoints = 0x8,
    
    /// Public routes will render segments in bus color, public & car routes pedestrian parts are render different.
    MapViewRouteRenderOptionShowHighlights = 0x10,
    
    /// Display user waypoints images.
    /// @details If enabled, user landmark image will be displayed instead of standard pin image. Default is false
    MapViewRouteRenderOptionShowUserImage = 0x20
};

/**
 * Constants indicating the route line type.
 */
typedef NS_ENUM(NSInteger, RouteLineType)
{
    /// Default line type ( map style defined ).
    RouteLineTypeDefault,
    
    /// Line solid.
    RouteLineTypeSolid,
    
    /// Line dashed.
    RouteLineTypeDashed,
    
    /// Point.
    RouteLineTypePoint
};

/**
 * Constants indicating the image positon relative to position reference.
 */
typedef NS_ENUM(NSInteger, ImagePosition)
{
    ///< Default image position ( style defined ).
    ImagePositionStyleDefault,
    
    ///< Centered on position.
    ImagePositionCenter,
    
    ///< Left-top side relative to position.
    ImagePositionLeftTop,
    
    ///< Horizontal centered-top side relative to position.
    ImagePositionCenterTop,       
    
    ///< Right-top side relative to position.
    ImagePositionRightTop,        
    
    ///< Right-vertical centered side relative to position.
    ImagePositionRightCenter,     
    
    ///< Right-bottom side relative to position.
    ImagePositionRightBottom,     
    
    ///< Horizontal centered-bottom side relative to position.
    ImagePositionCenterBottom,    
    
    ///< Left-bottom side relative to position.
    ImagePositionLeftBottom,      
    
    ///< Left-vertical centered side relative to position.
    ImagePositionLeftCenter,      
};

/**
 * Constants indicating the route display modes.
 */
typedef NS_ENUM(NSInteger, RouteDisplayMode)
{
    /// Full route display.
    RouteDisplayModeFull = 0,
    
    /// Zoom to the branched part of the routes.
    RouteDisplayModeBranches,
};

/**
 * Constants indicating the camera follow mode.
 */
typedef NS_ENUM(NSInteger, CameraFollowMode)
{
    /// Camera follows touch handler events ( default ).
    CameraFollowModeTouch = 0,
    
    /// Camera follows attached sense data source position.
    CameraFollowModePosition,
};

/**
 * Constants indicating the perspectives in which the map is viewed.
 */
typedef NS_ENUM(NSInteger, MapViewPerspective)
{
    /// Two dimensional.
    MapViewPerspectiveView2D = 0,
    
    /// Three dimensional.
    MapViewPerspectiveView3D,
};

/**
 * Constants indicating the map details quality level.
 */
typedef NS_ENUM(NSInteger, MapDetailsQualityLevel)
{
    /// Low quality details.
    MapDetailsQualityLevelLow = 0,
    
    /// Medium quality details.
    MapDetailsQualityLevelMedium,
    
    /// High quality details ( default ).
    MapDetailsQualityLevelHigh
};

/**
 * Constants indicating the buildings visibility type.
 */
typedef NS_ENUM(NSInteger, BuildingsVisibility)
{
    /// Show style default.
    BuildingsVisibilityDefault,
    
    /// Hide.
    BuildingsVisibilityHide,
    
    /// Show 2D ( flat ).
    BuildingsVisibility2D,
    
    /// Show 3D.
    BuildingsVisibility3D
};

/**
 * Follow position map rotation mode.
 */
typedef NS_ENUM(NSInteger, FollowPositionMapRotationMode)
{
    /// Use position sensor heading for map rotation.
    FollowPositionMapRotationModePositionHeading,
    
    /// Use compass sensor for map rotation.
    FollowPositionMapRotationModeCompass,
    
    /// Use fixed map rotation angle
    FollowPositionMapRotationModeFixed,
};

/**
 * Constants indicating the map view touch gestures.
 */
typedef NS_ENUM(int, MapViewTouchGestures)
{
    /// Single pointer touch event ( down and up with negligible move ) - not used..
    MapViewOnTouch = 0x100,
    
    /// Single pointer long touch event.
    MapViewOnLongDown = 0x200,
    
    /// Single pointer double touch event - zoom in.
    MapViewOnDoubleTouch = 0x400,
    
    /// Two pointers single touch event - zoom out.
    MapViewOnTwoPointersTouch = 0x800,
    
    /// Two pointers double touch event - autocenter the globe.
    MapViewOnTwoPointersDoubleTouch = 0x1000,
    
    /// Single pointer move event - pan.
    MapViewOnMove = 0x2000,
    
    /// Single pointer touch event followed immediately by a vertical move/pan event = single pointer zoom in/out.
    MapViewOnTouchMove = 0x4000,
    
    /// Single pointer linear swipe event - move/pan with pointer moving when lifted, in the dXInPix, dYInPix direction.
    MapViewOnSwipe = 0x8000,
    
    /// Two pointer zooming swipe event - one or both pointers moving when lifted during pinch zoom, causing motion to continue for a while.
    MapViewOnPinchSwipe = 0x10000,
    
    /// Two pointers pinch (pointers moving toward or away from each other) event - can include zoom and shove (2-pointer pan) but no rotate.
    MapViewOnPinch = 0x20000,
    
    /// Two pointers rotate event - can include zoom and shove (distance between 2 pointers remains constant while line connecting them moves or rotates).
    MapViewOnRotate = 0x40000,
    
    /// Two pointers shove event (2-pointer pan - pointers moving in the same direction the same distance) - can include rotate and zoom.
    MapViewOnShove = 0x80000,
    
    /// Two pointers touch event followed immediately by a pinch event - not used..
    MapViewOnTouchPinch = 0x100000,
    
    /// Two pointers touch event followed immediately by a rotate event - not used..
    MapViewOnTouchRotate = 0x200000,
    
    /// Two pointers touch event followed immediately by a shove event - not used..
    MapViewOnTouchShove = 0x400000,
    
    /// Two pointer rotating swipe event - one or both pointers moving when lifted during pinch rotate, causing motion to continue for a while.
    MapViewOnRotatingSwipe = 0x800000,
};

/**
 * Constants indicating the view data transition.
 */
typedef NS_ENUM(NSInteger, ViewDataTransitionStatus)
{
    /// All data view transitions are complete.
    ViewDataTransitionStatusComplete = 0,
    
    /// View data transitions are incomplete because online data is expected to arrive via the connection.
    ViewDataTransitionStatusIncompleteOnline,
};

/**
 * Constants indicating the view camera transition.
 */
typedef NS_ENUM(NSInteger, ViewCameraTransitionStatus)
{
    /// Camera is stationary.
    ViewCameraTransitionStatusStationary = 0,
    
    /// Camera is moving.
    ViewCameraTransitionStatusMoving,
};

/**
 * Constants indicating the view touch behaviour.
 */
typedef NS_ENUM(NSInteger, TouchViewBehaviour)
{
    /// Default touch behaviour.
    TouchViewBehaviourDefault = 0,
    
    /// Finger draw touch behaviour.
    TouchViewBehaviourFingerDraw,
};

/**
 * Constants indicating the marker labeling mode.
 */
typedef NS_ENUM(NSInteger, MarkerLabelingMode)
{
    /// None.
    MarkerLabelingModeNone = 0,
    
    /// Label each marker item.
    MarkerLabelingModeItem = 0x1,
    
    /// Label marker groups.
    MarkerLabelingModeGroup = 0x2,
    
    /// Item label is centered on image.
    MarkerLabelingModeItemCenter = 0x4,
    
    /// Group label is centered on image.
    MarkerLabelingModeGroupCenter = 0x8,
    
    /// Label fits the image.
    MarkerLabelingModeFitImage = 0x10,
    
    /// Align icon bottom center
    MarkerLabelingModeIconBottomCenter = 0x20,
    
    /// Item label centered on image
    MarkerLabelingModeTextCentered = MarkerLabelingModeItemCenter,
    
    /// Item label above icon
    MarkerLabelingModeTextAbove = 0x40,
    
    /// Item label below icon
    MarkerLabelingModeTextBellow = 0x80,
    
    /// Group label on top-right corner
    MarkerLabelingModeGroupTopRight = 0x100,
};

/**
 * Constants indicating the marker collection render settings.
 */
typedef struct 
{
    /// The image for displaying points.
    /// @details Only for MarkerCollectionTypePoint.
    __unsafe_unretained UIImage * _Nullable pointImage;
    
    /// Polyline inner color ( default not specified ).
    __unsafe_unretained UIColor * _Nullable polylineInnerColor;
    
    /// Polyline outer color ( default not specified ).
    __unsafe_unretained UIColor * _Nullable polylineOuterColor;
    
    /// Polygon fill color ( default not specified ).
    __unsafe_unretained UIColor * _Nullable polygonFillColor;
    
    /// Label text color ( default: is value from current map style ).
    __unsafe_unretained UIColor * _Nullable labelTextColor;
    
    /// Polyline inner size in mm.
    double polylineInnerSize;
    
    /// Polyline outer size in mm.
    double polylineOuterSize;
    
    /// Label text size in mm.
    double labelTextSize;
    
    /// Image size in mm.
    double imageSize;
    
    /// Marker labeling mode.
    /// @details Combination of MarkerLabelingMode bitset values.
    int labelingMode;
    
    /// Visibility min zoom level.
    /// @details Default value is current map view style based.
    __unsafe_unretained NSNumber * _Nullable minVisibilityZoomLevel;
    
    /// @brief Visibility max zoom level.
    /// @details Default value is current map view style based.
    __unsafe_unretained NSNumber * _Nullable maxVisibilityZoomLevel;
    
} MarkerCollectionObjectRenderSettings;

/**
 * Constants indicating the marker render settings.
 */
typedef struct 
{
    /// Polyline inner color ( default not specified ).
    __unsafe_unretained UIColor * _Nullable polylineInnerColor;
    
    /// Polyline outer color ( default not specified ).
    __unsafe_unretained UIColor * _Nullable polylineOuterColor;
    
    /// Polygon fill color ( default not specified ).
    __unsafe_unretained UIColor * _Nullable polygonFillColor;
    
    /// Label text color ( default: is value from current map style ).
    __unsafe_unretained UIColor * _Nullable labelTextColor;
    
    /// Polyline inner size in mm.
    double polylineInnerSize;
    
    /// Polyline outer size in mm.
    double polylineOuterSize;
    
    /// Label text size in mm.
    double labelTextSize;
    
    /// Image size in mm.
    double imageSize;
    
    /// Marker labeling mode.
    /// @details Combination of MarkerLabelingMode flags.
    int labelingMode;
    
} MarkerObjectRenderSettings;

#endif /* MapViewHeader_h */
