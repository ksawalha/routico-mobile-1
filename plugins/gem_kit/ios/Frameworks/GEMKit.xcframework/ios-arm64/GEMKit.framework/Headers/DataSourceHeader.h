// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all 
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V. 
// or its affiliates is strictly prohibited.

#ifndef DataSourceHeader_h
#define DataSourceHeader_h

/**
 * Constants indicating the data origin.
 */
typedef NS_ENUM(NSInteger, DataSourceOrigin)
{
    /// Unknown.
    DataSourceOriginUnknown = 0,
    
    /// Internal data source magic lane.
    DataSourceOriginGM,
    
    /// Custom data source defined by an external party.
    DataSourceOriginExternal
};

/**
 * Constants indicating the data types.
 */
typedef NS_ENUM(NSInteger, DataType)
{
    /// Acceleration
    DataTypeAcceleration = 0,
    
    /// Activity
    DataTypeActivity,
    
    /// Attitude
    DataTypeAttitude,
    
    /// Battery
    DataTypeBattery,
    
    /// Camera
    DataTypeCamera,
    
    /// Compass
    DataTypeCompass,
    
    /// MagneticField
    DataTypeMagneticField,
    
    /// Orientation
    DataTypeOrientation,
    
    /// Position
    DataTypePosition,
    
    /// ImprovedPosition
    DataTypeImprovedPosition,
    
    /// RotationRate
    DataTypeRotationRate,
    
    /// Temperature
    DataTypeTemperature,
    
    /// Notification
    DataTypeNotification,
    
    /// Mount Information
    DataTypeMountInformation,
    
    /// Unknown
    DataTypeUnknown,
};

/**
 * Constants indicating the data source type.
 */
typedef NS_ENUM(NSInteger, DataSourceType)
{
    /// Data got from the sensors or any other live source.
    DataSourceTypeLive = 0,
    
    /// Data got from playing a log or a simulation.
    DataSourceTypePlayback,
    
    /// No data type available.
    DataSourceTypeUnknown
};

/**
 * Constants indicating the reason for data interruption.
 */
typedef NS_ENUM(NSInteger, DataInterruptionReason)
{
    /// Reason is unknown.
    DataInterruptionReasonUnknown = 0,
    
    /// The sensor that generates the data has stopped.
    DataInterruptionReasonSensorStopped,
    
    /// The application was sent in the background.
    DataInterruptionReasonAppSentToBackground,
    
    /// This value applies to Position data type ( for example the provider may be GPS or Network ).
    DataInterruptionReasonLocationProvidersChanged,
    
    /// Sensor configuration changed.
    DataInterruptionReasonSensorConfigurationChanged,
    
    /// Device orientation changed.
    DataInterruptionReasonDeviceOrientationChanged,
    
    /// In use by another client.
    DataInterruptionReasonInUseByAnotherClient,
    
    /// Not available with multiple foreground apps.
    DataInterruptionReasonNotAvailableWithMultipleForegroundApps,
    
    /// Not available due to system pressure.
    DataInterruptionReasonNotAvailableDueToSystemPressure,
    
    /// Not available in background.
    DataInterruptionReasonNotAvailableInBackground,
    
    /// Audio device in use by another client.
    DataInterruptionReasonAudioDeviceInUseByAnotherClient,
    
    /// Video device in use by another client.
    DataInterruptionReasonVideoDeviceInUseByAnotherClient,
};

/**
 * Constants indicating the data source status.
 */
typedef NS_ENUM(NSInteger, PlayingStatus)
{
    /// Unknown.
    PlayingStatusUnknown = 0,
    
    /// Data source is in a stopped state.
    PlayingStatusStopped,
    
    /// Data source is in a paused state.
    PlayingStatusPaused,
    
    /// Data source is in a playing state.
    PlayingStatusPlaying
};

/**
 * Constants indicating the device temperature level.
 */
typedef NS_ENUM(NSInteger, TemperatureLevel)
{
    /// Unknown.
    TemperatureLevelUnknown = 0,
    
    /// Normal.
    TemperatureLevelNormal,
    
    /// Fair.
    TemperatureLevelFair,
    
    /// Serious
    TemperatureLevelSerious,
    
    /// Critical
    TemperatureLevelCritical,
    
    /// ShuttingDown
    TemperatureLevelShuttingDown,
};

/**
 * Constants indicating the unit of measurement.
 */
typedef NS_ENUM(NSInteger, DataUnitMeasurement)
{
    /// Gravitational force.
    DataUnitMeasurementG,
    
    /// Meters per second per second.
    DataUnitMeasurementMeterPerSecond2
};

/**
 * Constants indicating the data source video encoding type.
 */
typedef NS_ENUM(NSInteger, ImagePixelFormat)
{
    /// /////////////////////////// ///
    /// Custom Formats      ///
    /// /////////////////////////// ///
    
    
    /// Unknown
    ImagePixelFormatUnknown = 0,
    
    /// 24-bit encoding( 8-bit Red, 8-bit Green, 8-bit Blue). Bit masks:
    /// - Red   0xFF0000
    /// - Green 0x00FF00
    /// - Blue  0x0000FF
    ImagePixelFormatRGB_888 = 1,
    
    /// 24-bit encoding( 8-bit Blue, 8-bit Green, 8-bit Red). Bit masks:
    /// - Blue  0xFF0000
    /// - Green 0x00FF00
    /// - Red   0x0000FF
    ImagePixelFormatBGR_888 = 2,
    
    /// 32-bit encoding( 8-bit Alpha, 8-bit Blue, 8-bit Green, 8-bit Red).
    /// Bit masks: ABGR
    /// - Alpha 0xFF000000
    /// - Blue  0x00FF0000
    /// - Green 0x0000FF00
    /// - Red   0x000000FF
    ImagePixelFormatABGR_8888 = 3,
    
    
    /// /////////////////////////// ///
    /// OS                            ///
    /// /////////////////////////// ///
    
    
    /// 8-bit encoding( 8-bit Alpha ).
    /// @see [android.graphics.Bitmap.Config.ALPHA_8].
    ImagePixelFormatALPHA_8 = 4,
    
    /// 16-bit encoding( 5-bit Red, 6-bit Green, 5-bit Blue). Bit masks:
    /// - Red   0xF800( 5 bits of red)
    /// - Green 0x07E0( 6 bits of green)
    /// - Blue  0x001F( 5 bits of blue)
    /// @see [android.graphics.ImageFormat.RGB_565].
    /// @see [android.graphics.Bitmap.Config.RGB_565].
    ImagePixelFormatRGB_565 = 5,
    
    /// 32-bit encoding( 8-bit Alpha, 8-bit Red, 8-bit Green, 8-bit Blue).
    /// Bit masks: ARGB
    /// - Alpha 0xFF000000
    /// - Red   0x00FF0000
    /// - Green 0x0000FF00
    /// - Blue  0x000000FF
    /// @see [android.graphics.Bitmap.Config.ARGB_8888]
    ImagePixelFormatARGB_8888 = 6,
    
    /// YUV (YCbCr)
    /// One pixel represents as: YYYYYYYY UVUV
    /// For a n-pixel frame: Y×8×n (UV)×2×n
    /// @see [android.graphics.ImageFormat.YUV_420_888].
    ImagePixelFormatYUV_420_888 = 7,
    
    /// YVU (YCrCb)
    /// One pixel represents as: YYYYYYYY VUVU
    /// For a n-pixel frame: Y×8×n (VU)×2×n.
    /// @see [android.graphics.ImageFormat.YV12].
    ImagePixelFormatYV12 = 8,
    
    /// Android YUV format.
    /// This format is exposed to software decoders and applications.
    /// Is a 4:2:0 YCrCb planar format comprised of a WxH Y plane followed by (W/2) x (H/2) Cr and Cb planes.
    /// @see [ImageFormat.NV21].
    ImagePixelFormatNV21 = 9,
};

/**
 * Constants indicating the data source 16:9 standard resolutions.
 */
typedef NS_ENUM(NSInteger, ResolutionFormat)
{
    /// Unknown.
    ResolutionFormatUnknown = 0,
    
    /// 640 * 480 resolution.
    ResolutionFormatSD_480p,
    
    /// 1280 * 720 resolution.
    ResolutionFormatHD_720p,
    
    /// 1920 * 1080 resolution.
    ResolutionFormatFullHD_1080p,
    
    /// 2560 * 1440 resolution.
    ResolutionFormatWQHD_1440p,
    
    /// 3840 * 2160 resolution.
    ResolutionFormatUHD_4K_2160p,
    
    /// 7680 * 4320 resolution.
    ResolutionFormatUHD_8K_4320p,
};

/**
 * Constants indicating the position accuracy type.
 */
typedef NS_ENUM(NSInteger, PositionAccuracyType)
{
    /// Unknown.
    PositionAccuracyTypeUnknown = 0,
    
    /// Every second.
    PositionAccuracyTypeEverySecond,
    
    /// When moving.
    PositionAccuracyTypeWhenMoving,
    
    /// Nearest ten meters.
    PositionAccuracyTypeNearestTenMeters,
    
    /// Hundred of meters.
    PositionAccuracyTypeHundredMeters,
    
    /// Kilometer.
    PositionAccuracyTypeKilometer,
};

/**
 * Constants indicating the position activity type.
 */
typedef NS_ENUM(NSInteger, PositionActivityType)
{
    /// Unknown.
    PositionActivityTypeUnknown = 0,
    
    /// Other.
    PositionActivityTypeOther,
    
    /// The value that indicates positioning in an automobile following a road.
    PositionActivityTypeAutomotive,
    
    /// The value that indicates positioning during walking, walking workouts, running workouts, cycling workouts, and so on.
    PositionActivityTypePedestrian,
    
    /// The value that indicates positioning for activities that may not follow roads, such as cycling, scooters, trains, boats, and off-road vehicles.
    PositionActivityTypeOtherNavigation,
};

/**
 * Constants indicating the recording transport mode.
 */
typedef NS_ENUM(NSInteger, RecordingTransportMode)
{
    /// Unknown transport mode, used when the mode is not specified or recognized.
    RecordingTransportModeUnknown,
    
    /// Transport mode for cars.
    RecordingTransportModeCar,
    
    /// Transport mode for trucks.
    RecordingTransportModeTruck,
    
    /// Transport mode for bicycles in general.
    RecordingTransportModeBike,
    
    /// Transport mode for pedestrians, representing walking.
    RecordingTransportModePedestrianWalk,
    
    /// Transport mode for pedestrians, representing hiking.
    RecordingTransportModePedestrianHike,
    
    /// Transport mode for road bikes, typically used on paved roads.
    RecordingTransportModeRoadBike,
    
    ///Transport mode for cross bikes, used on mixed terrain.
    RecordingTransportModeCrossBike,
    
    /// Transport mode for city bikes, designed for urban commuting.
    RecordingTransportModeCityBike,
    
    /// Transport mode for mountain bikes, used on rough, off-road terrain.
    RecordingTransportModeMountainBike
};

#endif /* DataSourceHeader_h */
