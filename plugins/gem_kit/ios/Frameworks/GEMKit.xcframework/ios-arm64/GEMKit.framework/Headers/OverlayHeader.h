// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all 
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V. 
// or its affiliates is strictly prohibited.

#ifndef OverlayHeader_h
#define OverlayHeader_h

/**
 * Constants indicating the Social Report Category.
 */
typedef NS_ENUM(NSInteger, SocialReportCategory)
{
    /// Json format.
    SocialReportCategorySpeedCamera = 512,
};

/**
 * Constants indicating the overlayItem preview data formats.
 */
typedef NS_ENUM(NSInteger, PreviewDataType)
{
    /// Json format.
    PreviewDataTypeJson = 0,
};

/**
 * Constants indicating the common overlay identifier.
 */
typedef NS_ENUM(NSInteger, CommonOverlayIdentifier)
{
    /// Safety overlay ID.
    CommonOverlayIdentifierSafety = 0x50A04,
    
    /// Public transport overlay ID.
    CommonOverlayIdentifierPublicTransport = 0x2EEFAA,
    
    /// Social Labels overlay ID.
    CommonOverlayIdentifierSocialLabels = 0xA200,
    
    /// Social Reports const overlay ID.
    CommonOverlayIdentifierSocialReports = 0xA300,
    
    /// Charging station overlay ID.
    CommonOverlayIdentifierEVCharging = 0x8200,
};

/**
 * Constants indicating the safety camera overlay parameters type.
 */
typedef NS_ENUM(NSInteger, SafetyCameraParameterType)
{
    SafetyCameraParameterTypeSpeedUnit,
    
    SafetyCameraParameterTypeSpeedVal,
    
    SafetyCameraParameterTypeTowards,
    
    SafetyCameraParameterTypeDriveDir,
};

/**
 * Constants indicating the type of transportation returned by PublicTransportRouteParameterType: type.
 */
typedef NS_ENUM(NSInteger, PublicTransportRouteTransportType)
{
    /// Bus
    PublicTransportRouteTransportTypeBus = 0,
    
    /// Underground
    PublicTransportRouteTransportTypeUnderground = 1,
    
    /// Railway
    PublicTransportRouteTransportTypeRailway = 2,
    
    /// Tram
    PublicTransportRouteTransportTypeTram = 3,
    
    /// Water transport
    PublicTransportRouteTransportTypeWaterTransport = 4,
    
    /// Other type
    PublicTransportRouteTransportTypeMisc = 5
};

/**
 * Constants indicating the wheelchair accessibility returned by PublicTransportTripParameterType: wheelchairAccessible.
 */
typedef NS_ENUM(NSInteger, PublicTransportWheelchairAccessibleType)
{
    /// No accessibility information for the trip.
    PublicTransportWheelchairAccessibleTypeNoInfo = 0,
    
    /// Vehicle being used on this particular trip can accommodate at least one rider in a wheelchair.
    PublicTransportWheelchairAccessibleTypeYes = 1,
    
    /// No riders in wheelchairs can be accommodated on this trip.
    PublicTransportWheelchairAccessibleTypeNo = 2
};

/**
 * Constants indicating the bikes allowed returned by PublicTransportTripParameterType: bikesAllowed.
 */
typedef NS_ENUM(NSInteger, PublicTransportBikesAllowedType)
{
    /// No bike information for the trip.
    PublicTransportBikesAllowedTypeNoInfo = 0,
    
    /// Vehicle being used on this particular trip can accommodate at least one bicycle.
    PublicTransportBikesAllowedTypeYes = 1,
    
    /// No bicycles are allowed on this trip.
    PublicTransportBikesAllowedTypeNo = 2
};

/**
 * Constants indicating the public transport overlay parameters type.
 */
typedef NS_ENUM(NSInteger, PublicTransportParameterType)
{
    /// Array of dictionary.
    PublicTransportParameterTypeStops,
    
    /// Array of dictionary.
    PublicTransportParameterTypeTrips,
    
    /// Array of dictionary.
    PublicTransportParameterTypeAgencies,
};

/**
 * Constants indicating the public transport overlay route parameters type.
 */
typedef NS_ENUM(NSInteger, PublicTransportRouteParameterType)
{
    /// Large Integer
    PublicTransportRouteParameterTypeId,
    
    /// String
    PublicTransportRouteParameterTypeShortName,
    
    /// String
    PublicTransportRouteParameterTypeLongName,
    
    /// Int
    PublicTransportRouteParameterTypeType,
    
    /// String
    PublicTransportRouteParameterTypeRouteColor,
    
    /// String
    PublicTransportRouteParameterTypeTextColor,
    
    /// String
    PublicTransportRouteParameterTypeHeading,
};

/**
 * Constants indicating the public transport overlay route parameters type.
 */
typedef NS_ENUM(NSInteger, PublicTransportTripParameterType)
{
    /// Bool
    PublicTransportTripParameterTypeHasShape = 100,
    
    /// Bool
    PublicTransportTripParameterTypeHasRealtime,
    
    /// Int - seconds that have passed since 1970-01-01T00:00:00.
    PublicTransportTripParameterTypeDepartureTime,
    
    /// Int - seconds that have passed since 1970-01-01T00:00:00.
    PublicTransportTripParameterTypeTripDate,
    
    /// Int
    PublicTransportTripParameterTypeTripDelayMinutes,
    
    /// String
    PublicTransportTripParameterTypeStopPlatformCode,
    
    /// Int
    PublicTransportTripParameterTypeIndex,
    
    /// Int
    PublicTransportTripParameterTypeStopIndex,
    
    /// Bool
    PublicTransportTripParameterTypeIsCancelled,
    
    /// Int
    PublicTransportTripParameterTypeWheelchairAccessible,
    
    /// Int
    PublicTransportTripParameterTypeBikesAllowed,
    
    /// Int
    PublicTransportTripParameterTypeAgencyId,
    
    /// Array of dictionary.
    PublicTransportTripParameterTypeStopTimes
};

/**
 * Constants indicating the public transport overlay agency parameters type.
 */
typedef NS_ENUM(NSInteger, PublicTransportAgencyParameterType)
{
    /// Int
    PublicTransportAgencyParameterTypeId,
    
    /// String
    PublicTransportAgencyParameterTypeName,
    
    /// String
    PublicTransportAgencyParameterTypeUrl,
};

/**
 * Constants indicating the public transport overlay stop parameters type.
 */
typedef NS_ENUM(NSInteger, PublicTransportStopParameterType)
{
    /// Large Integer
    PublicTransportStopParameterTypeId,
    
    /// String
    PublicTransportStopParameterTypeName,
    
    /// Bool
    PublicTransportStopParameterTypeIsStation,
    
    /// Dictionary
    PublicTransportStopParameterTypeRoutes,
};

/**
 * Constants indicating the public transport overlay stop time parameters type.
 */
typedef NS_ENUM(NSInteger, PublicTransportStopTimeParameterType)
{
    /// String
    PublicTransportStopTimeParameterTypeStopName,
    
    /// Int - seconds that have passed since 1970-01-01T00:00:00.
    PublicTransportStopTimeParameterTypeDepartureTime,
    
    /// Bool
    PublicTransportStopTimeParameterTypeHasRealtime,
    
    /// Int
    PublicTransportStopTimeParameterTypeDelay,
    
    /// Bool
    PublicTransportStopTimeParameterTypeIsBefore,
    
    /// Int
    PublicTransportStopTimeParameterTypeDetails,
    
    /// Double
    PublicTransportStopTimeParameterTypeLatitude,
    
    /// Double
    PublicTransportStopTimeParameterTypeLongitude
};

/**
 * Constants indicating the social report category parameter type.
 */
typedef NS_ENUM(NSInteger, SocialReportCategoryParameterType)
{
    SocialReportCategoryParameterTypeName,
    
    SocialReportCategoryParameterTypeId,
    
    SocialReportCategoryParameterTypeKVTypeInteger,
    
    SocialReportCategoryParameterTypeKVTypeDouble,
    
    SocialReportCategoryParameterTypeKVTypeString,
    
    SocialReportCategoryParameterTypeCurrency,
    
    SocialReportCategoryParameterTypeValidity,
    
    SocialReportCategoryParameterTypeNameTTS
};

/**
 * Constants indicating the social report parameters type.
 */
typedef NS_ENUM(NSInteger, SocialReportParameterType)
{
    
    /// String value
    SocialReportParameterTypeCategNameTTS = 0,
    
    /// Int ( minutes )
    SocialReportParameterTypeCategValidity,
    
    /// String value
    SocialReportParameterTypeDescription,
    
    /// Large Integer
    SocialReportParameterTypeOwnerId,
    
    /// String value
    SocialReportParameterTypeOwnerName,
    
    /// Bool value
    SocialReportParameterTypeOwnReport,
    
    /// Int value
    SocialReportParameterTypeScore,
    
    /// Int timestamp ( seconds )
    SocialReportParameterTypeCreateTimeUTC,
    
    /// Int timestamp ( seconds )
    SocialReportParameterTypeUpdateTimeUTC,
    
    /// Int timestamp ( seconds )
    SocialReportParameterTypeExpireTimeUTC,
    
    /// Bool value
    SocialReportParameterTypeHasSnapshot,
    
    /// Double value
    SocialReportParameterTypeDirection,
    
    /// Double value
    SocialReportParameterTypeDirection1,
    
    /// Double value
    SocialReportParameterTypeDirection2,
    
    /// Bool value
    SocialReportParameterTypeAllowThumb,
    
    /// Bool value
    SocialReportParameterTypeAllowUpdate,
    
    /// Bool value
    SocialReportParameterTypeAllowDelete,
    
    /// String value
    SocialReportParameterTypeCurrency,
    
    /// Array
    SocialReportParameterTypeComment,
    
    /// String value
    SocialReportParameterTypeCommentUserIcon,
    
    /// String value
    SocialReportParameterTypeCommentUserName,
    
    /// String value
    SocialReportParameterTypeCommentText,
    
    /// Int timestamp ( seconds )
    SocialReportParameterTypeCommentTimeUTC,
};

/**
 * Constants indicating the social report category parameter type.
 */
typedef NS_ENUM(NSInteger, SocialReportUserParameterType)
{
    SocialReportUserParameterTypeName,
    
    SocialReportUserParameterTypeRank,
    
    SocialReportUserParameterTypeScore,
};

#endif /* OverlayHeader_h */
