// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all 
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V. 
// or its affiliates is strictly prohibited.

#ifndef GenericHeader_h
#define GenericHeader_h

/**
 * Constants indicating the Sdk capabilities.
 */
typedef NS_ENUM(NSInteger, SdkCapabilities)
{
    /// Offline.
    SdkCapabilitiesOffline = 0,
    
    /// Search.
    SdkCapabilitiesSearch,
    
    /// Navigation.
    SdkCapabilitiesNavigation,
    
    /// Mapping.
    SdkCapabilitiesMapping,
    
    /// Social.
    SdkCapabilitiesSocial,
    
    /// Adas.
    SdkCapabilitiesAdas,
    
    /// Content.
    SdkCapabilitiesContent,
    
    /// Dashcam.
    SdkCapabilitiesDashcam,
    
    /// Weather.
    SdkCapabilitiesWeather,
    
    /// Vrp.
    SdkCapabilitiesVrp,
    
    /// Sense.
    SdkCapabilitiesSense,
    
    /// Places.
    SdkCapabilitiesPlaces,
    
    /// Timezone.
    SdkCapabilitiesTimezone,
    
    /// Sound.
    SdkCapabilitiesSound,
};

/**
 * Constants indicating the unit system.
 */
typedef NS_ENUM(NSInteger, UnitSystemType)
{
    /// Unit system metric.
    UnitSystemTypeMetric = 0,
    
    /// Unit system imperial UK.
    UnitSystemTypeImperialUK,
    
    /// Unit system imperial US.
    UnitSystemTypeImperialUS
};

/**
 * Constants indicating the map language.
 */
typedef NS_ENUM(NSInteger, MapLanguageType)
{
    /// The map language is automatically selected based on the API language.
    MapLanguageTypeAutomatic,
    
    /// The native language is used on map objects.
    MapLanguageTypeNative
};

/**
 * Constants indicating the authorization key status.
 */
typedef NS_ENUM(NSInteger, AuthorizationKeyStatus)
{
    /// Authorization key valid.
    AuthorizationKeyStatusValid = 0,
    
    /// Authorization key expired.
    AuthorizationKeyStatusExpired,
    
    /// Authorization key invalid input.
    AuthorizationKeyStatusInvalidInput,
    
    /// Authorization key blacklisted.
    AuthorizationKeyStatusAccessDenied,
    
    /// Online connection is required.
    AuthorizationKeyStatusConnectionRequired,
    
    /// Authorization key error.
    AuthorizationKeyStatusError
};

/**
 * Constants indicating sdk service group: tiles, traffic, terrain.
 */
typedef NS_ENUM(NSInteger, ServiceGroupType)
{
    /// All map data related services: map tiles, overlays, searching, routing.
    ServiceGroupTypeMapDataService = 0,
    
    /// Traffic related services: live traffic flow, congestion, detours, closed roads.
    ServiceGroupTypeTrafficService,
    
    /// Terrain/topography/elevation/height map and satellite services.
    ServiceGroupTypeTerrainService,
    
    /// Content download service.
    ServiceGroupTypeContentService
};

/**
 * Constants indicating how an image should fill the area.
 */
typedef NS_ENUM(NSInteger, FrameFit)
{
    /// Centered used as default.
    FrameFitUnknown = 0,
    
    /// Frame maximizes viewport space used while being entirely visible
    /// Original aspect ratio, not zoomed.
    FrameFitInside = FrameFitUnknown,
    
    /// Fills the view port by stretching the image.
    /// Changes aspect ratio, not zoomed.
    FrameFitStretchFill,
    
    /// Video frame is displayed in the center of the viewport
    /// Original aspect ratio, not zoomed
    FrameFitCentered,
    
    /// Video frame is displayed in the center of the viewport
    /// @note Original aspect ratio, zoomed
    FrameFitZoomFill,
};

/**
 * Constants indicating the camera orientation angles.
 */
typedef struct
{
    /// Camera orientation x.
    double x;
    
    /// Camera orientation y.
    double y;
    
    /// Camera orientation z.
    double z;
    
    /// Camera orientation w.
    double w;
    
} CameraOrientationAngles;

/**
 * Constants indicating the Sdk error codes.
 */
typedef NS_ENUM(NSInteger, SDKErrorCode)
{
    /// Code returned when all went as intended.
    SDKErrorCodeKNoError = 0,
    
    
    /// General error.
    SDKErrorCodeKGeneral = -1,
    
    /// Activation required to perform the request.
    SDKErrorCodeKActivation =  -2,
    
    /// Operation canceled.
    SDKErrorCodeKCancel =  -3,
    
    /// Feature not supported.
    SDKErrorCodeKNotSupported =  -4,
    
    /// Item already exists.
    SDKErrorCodeKExist =  -5,
    
    /// I/O error.
    SDKErrorCodeKIo = -6,
    
    /// Access denied.
    SDKErrorCodeKAccessDenied = -7,
    
    /// Read-only drive.
    SDKErrorCodeKReadonlyDrive = -8,
    
    /// Not enough disk space available.
    SDKErrorCodeKNoDiskSpace = -9,
    
    /// Item in use.
    SDKErrorCodeKInUse = -10,
    
    /// Required item not found.
    SDKErrorCodeKNotFound = -11,
    
    /// Index out of range.
    SDKErrorCodeKOutOfRange = -12,
    
    /// Content was updated.
    SDKErrorCodeKInvalidated = -13,
    
    /// Not enough memory to complete the request.
    SDKErrorCodeKNoMemory = -14,
    
    /// Invalid input provided.
    SDKErrorCodeKInvalidInput = -15,
    
    /// Reduced results returned.
    SDKErrorCodeKReducedResult = -16,
    
    /// Additional data required.
    SDKErrorCodeKRequired = -17,
    
    /// No route possible.
    SDKErrorCodeKNoRoute = -18,
    
    /// One or more way points not accessible.
    SDKErrorCodeKWaypointAccess = -19,
    
    /// Requested route is too long.
    SDKErrorCodeKRouteTooLong = -20,
    
    /// Operation internally aborted.
    SDKErrorCodeKInternalAbort = -21,
    
    /// Connection failed.
    SDKErrorCodeKConnection = -22,
    
    /// Network connection failed.
    SDKErrorCodeKNetworkFailed = -23,
    
    /// No connection available.
    SDKErrorCodeKNoConnection = -24,
    
    /// Connection required to perform the request.
    SDKErrorCodeKConnectionRequired = -25,
    
    /// Data sending failed.
    SDKErrorCodeKSendFailed = -26,
    
    /// Data receiving failed.
    SDKErrorCodeKRecvFailed = -27,
    
    /// Operation could not start.
    SDKErrorCodeKCouldNotStart = -28,
    
    /// Network operation timeout.
    SDKErrorCodeKNetworkTimeout = -29,
    
    /// Network couldn't resolve host
    SDKErrorCodeKNetworkCouldntResolveHost = -30,
    
    /// Network couldn't resolve proxy
    SDKErrorCodeKNetworkCouldntResolveProxy =-31,
    
    /// Network couldn't resume download
    SDKErrorCodeKNetworkCouldntResume = -32,
    
    /// Not logged in.
    SDKErrorCodeKNotLoggedIn = -33,
    
    /// Operation suspended/paused.
    SDKErrorCodeKSuspended = -34,
    
    /// Content is up-to-date.
    SDKErrorCodeKUpToDate = -35,
    
    /// Internal engine resource is missing
    SDKErrorCodeKResourceMissing = -36,
    
    /// Internal operation aborted due to timer timeout
    SDKErrorCodeKOperationTimeout = -37,
    
    /// Requested operation cannot be performed. Internal limit reached.
    SDKErrorCodeKBusy = -38,
    
    /// Content is expired.
    SDKErrorCodeKExpired = -39,
    
    /// The engine needs to be initialized before calling this
    SDKErrorCodeKEngineNotInitialized = -40,
    
    /// Operation couldn't be completed but was scheduled for later.
    SDKErrorCodeKScheduled = -41,
    
    /// Network SSL connect error
    SDKErrorCodeKSSLConnectFail = -42,
    
    /// Device has low battery.
    SDKErrorCodeKLowBattery = -43,
    
    /// Device is overheated.
    SDKErrorCodeKOverheated = -44,
    
    /// Missing SDK capability.
    SDKErrorCodeKMissingCapability = -45,
    
    /// Recorded log is too short
    SDKErrorCodeRecordedLogTooShort = -46,
};

/**
 * Constants indicating weather daylight.
 */
typedef NS_ENUM(NSInteger, WeatherDaylight)
{
    /// N/A
    WeatherDaylightNotAvailable = 0,
    
    /// Day.
    WeatherDaylightDay,
    
    /// Night.
    WeatherDaylightNight
};

/**
 * Constants indicating log file sorting types.
 */
typedef NS_ENUM(NSInteger, LogFileSortingType)
{
    /// @brief Sort files by name.
    LogFileSortingTypeName = 0,
    
    /// @brief Sort files by type (e.g., file extension).
    LogFileSortingTypeType,
    
    /// @brief Sort files by date (e.g., modification date).
    LogFileSortingTypeDate,
    
    /// @brief Sort files by name and date.
    LogFileSortingTypeNameDate,
    
    /// @brief Sort files by path and date.
    LogFileSortingTypePathDate,
    
    /// @brief Sort files by path in lexicographical order.
    LogFileSortingTypePathLexicographical
};

/**
 * Constants indicating log file sorting orders.
 */
typedef NS_ENUM(NSInteger, LogFileSortingOrder)
{
    /// @brief No specific sorting order is applied.
    LogFileSortingOrderNone = 0,
    
    /// @brief Sort files in ascending order (e.g., A-Z, oldest to newest).
    LogFileSortingOrderAsc,
    
    /// @brief Sort files in descending order (e.g., Z-A, newest to oldest).
    LogFileSortingOrderDesc
};

/**
 * Constants indicating the drive side.
 */
typedef NS_ENUM(NSInteger, DriveSideType)
{
    /// Side left.
    DriveSideTypeLeft = 0,
    
    /// Side right.
    DriveSideTypeRight,
};

/**
 * Constants indicating the anchor type.
 * @details The anchor is a point ( all intersections ), a circle ( roundabout, complex traffic figure ) or a waypoint.
 */
typedef NS_ENUM(NSInteger, RoadAnchorType)
{
    /// Point
    RoadAnchorTypePoint,
    
    /// Circle
    RoadAnchorTypeCircle,
    
    /// Waypoint
    RoadAnchorTypeWaypoint,
    
    /// EV charging station waypoint
    RoadAnchorTypeEVWaypoint,
};

/**
 * Constants indicating the form of the shape.
 */
typedef NS_ENUM(NSInteger, RoadShapeFormType)
{
    /// Line is a simple line with width defined by RoadShapeType,
    RoadShapeFormTypeLine,
    
    /// Circle segment ( clock wise or counter clock wise depending on drive side) is a part of a RoadAnchorType::Circle.
    RoadShapeFormTypeCircleSegment,
    
    /// Point is a maker (e.g. Waypoint place) outside the anchor and not connected by a line. Get the index of the next route instruction on the current route segment.
    RoadShapeFormTypePoint
};

/**
 * Constants indicating the type of the shape.
 * @details Use the type to render the shape in different width and color.
 */
typedef NS_ENUM(NSInteger, RoadShapeType)
{
    ///< Route
    RoadShapeTypeRoute,
    
    ///< Street
    RoadShapeTypeStreet
};

/**
 * Constants indicating the arrow type of the shape.
 */
typedef NS_ENUM(NSInteger, ShapeArrowType)
{
    /// None.
    ShapeArrowTypeNone,
    
    /// Shape arrow begin.
    ShapeArrowTypeBegin,
    
    /// Shape arrow end
    ShapeArrowTypeEnd
};

/**
 * Constants indicating the restriction type of the shape.
 * @details The restriction type can be used to visualize the restriction for the connected street.
 */
typedef NS_ENUM(NSInteger, ShapeRestrictionType)
{
    /// No restriction.
    ShapeRestrictionTypeNone,
    
    /// Direction restriction.
    ShapeRestrictionTypeDirection,
    
    /// Manoeuvre restriction.
    ShapeRestrictionTypeManoeuvre
};

/**
 * Constants indicating the arrow direction of the shape.
 * @details The arrow direction will be only valid for RoadShapeFormTypeCircleSegment and some combined turns.
 */
typedef NS_ENUM(NSInteger, ShapeArrowDirectionType)
{
    /// None
    ShapeArrowDirectionTypeNone,
    
    /// Left
    ShapeArrowDirectionTypeLeft,
    
    /// Straight
    ShapeArrowDirectionTypeStraight,
    
    /// Right
    ShapeArrowDirectionTypeRight
};

/**
 * Constants indicating the log metrics.
 */
typedef struct
{
    /// The total distance traveled in meters.
    double distanceMeters;
    
    /// The total elevation gain in meters.
    double elevationGainMeters;
    
    /// The average speed in meters per second.
    double avgSpeedMps;
    
} LogBookmarksMetrics;

#endif /* GenericHeader_h */

