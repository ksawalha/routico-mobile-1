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
 * Project version number for GEMKit.
 */
FOUNDATION_EXPORT double GEMKitVersionNumber;

/**
 * Project version string for GEMKit.
 */
FOUNDATION_EXPORT const unsigned char GEMKitVersionString[];

/**
 * Core
 */
#import <GEMKit/GEMSdk.h>
#import <GEMKit/GEMSdkDelegate.h>
#import <GEMKit/GenericHeader.h>

/**
 * Maps & 3D Scene
 */
#import <GEMKit/MapViewController.h>
#import <GEMKit/MapViewHeader.h>
#import <GEMKit/MapCameraObject.h>
#import <GEMKit/MapViewControllerDelegate.h>
#import <GEMKit/MapViewPreferencesContext.h>
#import <GEMKit/FollowPositionPreferencesContext.h>
#import <GEMKit/SearchContext.h>
#import <GEMKit/MapStyleContext.h>
#import <GEMKit/MapsContext.h>
#import <GEMKit/GenericCategoriesContext.h>
#import <GEMKit/MapDetailsContext.h>
#import <GEMKit/CoordinatesObject.h>
#import <GEMKit/ImageObject.h>
#import <GEMKit/ImageDatabaseObject.h>
#import <GEMKit/ContactInfoObject.h>
#import <GEMKit/ContentStoreObject.h>
#import <GEMKit/ContentStoreObjectDelegate.h>
#import <GEMKit/ContentUpdateDelegate.h>
#import <GEMKit/MarkerCollectionObject.h>
#import <GEMKit/MarkerObject.h>
#import <GEMKit/HighlightRenderSettings.h>
#import <GEMKit/MapViewRouteRenderSettings.h>
#import <GEMKit/TimezoneContext.h>

/**
 * Projections
 */
#import <GEMKit/ProjectionContext.h>
#import <GEMKit/ProjectionObject.h>
#import <GEMKit/ProjectionWGS84Object.h>
#import <GEMKit/ProjectionLAMObject.h>
#import <GEMKit/ProjectionMGRSObject.h>
#import <GEMKit/ProjectionBNGObject.h>
#import <GEMKit/ProjectionGKObject.h>
#import <GEMKit/ProjectionUTMObject.h>
#import <GEMKit/ProjectionW3WObject.h>

/**
 * Landmark
 */
#import <GEMKit/LandmarkObject.h>
#import <GEMKit/LandmarkCategoryObject.h>
#import <GEMKit/LandmarkStoreContext.h>
#import <GEMKit/LandmarkStoreContextCollection.h>
#import <GEMKit/LandmarkStoreContextService.h>
#import <GEMKit/LandmarkPositionObject.h>
#import <GEMKit/LandmarkBrowseSessionContext.h>

/**
 * Geographic Area
 */
#import <GEMKit/GeographicAreaObject.h>
#import <GEMKit/CircleGeographicAreaObject.h>
#import <GEMKit/PolygonGeographicAreaObject.h>
#import <GEMKit/RectangleGeographicAreaObject.h>

/**
 * Overlay
 */
#import <GEMKit/OverlayHeader.h>
#import <GEMKit/OverlayServiceContext.h>
#import <GEMKit/OverlayItemObject.h>
#import <GEMKit/OverlayItemPositionObject.h>
#import <GEMKit/OverlayCategoryObject.h>
#import <GEMKit/OverlayCollectionObject.h>
#import <GEMKit/OverlayMutableCollectionObject.h>
#import <GEMKit/OverlayInfoObject.h>
#import <GEMKit/SearchableParameterListObject.h>

/**
 * Social Overlay
 */
#import <GEMKit/SocialOverlayContext.h>
#import <GEMKit/SocialReportsOverlayCategoryObject.h>
#import <GEMKit/SocialReportsOverlayInfoObject.h>

/**
 * Data Source
 */
#import <GEMKit/DataSourceContext.h>
#import <GEMKit/DataSourceContextDelegate.h>
#import <GEMKit/DataSourceHeader.h>
#import <GEMKit/DataSourceConfigurationObject.h>
#import <GEMKit/DataObject.h>
#import <GEMKit/DataSourcePlaybackContext.h>
#import <GEMKit/PositionContext.h>
#import <GEMKit/PositionContextDelegate.h>
#import <GEMKit/PositionObject.h>
#import <GEMKit/AccelerationObject.h>
#import <GEMKit/RotationObject.h>
#import <GEMKit/CameraObject.h>
#import <GEMKit/MockPositionObject.h>

/**
 * Routes & Navigation
 */
#import <GEMKit/NavigationContext.h>
#import <GEMKit/NavigationContextDelegate.h>
#import <GEMKit/RouteObject.h>
#import <GEMKit/RouteObjectDelegate.h>
#import <GEMKit/MapViewRouteObject.h>
#import <GEMKit/RouteSegmentObject.h>
#import <GEMKit/RouteInstructionObject.h>
#import <GEMKit/SignpostDetailsObject.h>
#import <GEMKit/SignpostItemObject.h>
#import <GEMKit/TimeDistanceObject.h>
#import <GEMKit/TimeDistanceCoordinatesObject.h>
#import <GEMKit/TurnDetailsObject.h>
#import <GEMKit/AbstractGeometryObject.h>
#import <GEMKit/AbstractGeometryItemObject.h>
#import <GEMKit/AbstractGeometryImageObject.h>
#import <GEMKit/RouteBookmarksObject.h>
#import <GEMKit/RoutePreferencesObject.h>
#import <GEMKit/PathObject.h>
#import <GEMKit/NavigationInstructionObject.h>
#import <GEMKit/TimeObject.h>
#import <GEMKit/RoadInfoObject.h>
#import <GEMKit/PTRouteSegmentObject.h>
#import <GEMKit/PTRouteObject.h>
#import <GEMKit/PTRouteInstructionObject.h>
#import <GEMKit/EVRouteObject.h>
#import <GEMKit/OTRouteObject.h>
#import <GEMKit/RouteTerrainProfileObject.h>

/**
 * Traffic
 */
#import <GEMKit/TrafficContext.h>
#import <GEMKit/TrafficEventObject.h>
#import <GEMKit/RouteTrafficEventObject.h>

/**
 * Alarm
 */
#import <GEMKit/AlarmContext.h>
#import <GEMKit/AlarmContextDelegate.h>
#import <GEMKit/AlarmMonitoredAreaObject.h>

/**
 * Sound
 */
#import <GEMKit/SoundContext.h>
#import <GEMKit/SoundContextDelegate.h>
#import <GEMKit/HumanVoiceContext.h>
#import <GEMKit/SoundObject.h>

/**
 * Sound
 */
#import <GEMKit/LocalizationHeader.h>
#import <GEMKit/LocalizationContext.h>

/**
 * Transfer Statistics
 */
#import <GEMKit/TransferStatisticsContext.h>

/**
 * Exception Handler
 */
#import <GEMKit/ExceptionHandler.h>

/**
 * Intents Handler
 */
#import <GEMKit/IntentsContext.h>

/**
 * Flutter
 */
#import <GEMKit/FlutterChannelObject.h>

/**
 * Weather
 */
#import <GEMKit/WeatherContext.h>
#import <GEMKit/WeatherContextParameter.h>
#import <GEMKit/WeatherContextConditions.h>
#import <GEMKit/WeatherContextForecast.h>

/**
 * Geofence
 */
#import <GEMKit/GeofenceProximityAreaObject.h>
