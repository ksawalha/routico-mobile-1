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
#import <GEMKit/DataSourceHeader.h>
#import <GEMKit/DataObject.h>

/**
 * Constants indicating the device orientation type.
 */
typedef NS_ENUM(NSInteger, OrientationType)
{
    /// Unknown,.
    OrientationTypeUnknown = 0,
    
    /// Portrait.
    OrientationTypePortrait,
    
    /// PortraitUpsideDown
    OrientationTypePortraitUpsideDown,
    
    /// LandscapeLeft
    OrientationTypeLandscapeLeft,
    
    /// LandscapeRight
    OrientationTypeLandscapeRight,
};

/**
 * Constants indicating the camera configuration structure.
 */
typedef struct {
    
    /// Horizontal Field Of View in radians.
    double horizontalFOV;
    
    /// Vertical Field Of View in radians.
    double verticalFOV;
    
    /// Frame width in pixels.
    int frameWidth;
    
    /// Frame height in pixels.
    int frameHeight;
    
    /// The pixel format (encoding type)
    ImagePixelFormat pixelFormat;
    
    /// The frameRate value.
    double frameRate;
    
    /// The frame orientation.
    OrientationType orientation;
    
    /// The horizontal focal length in pixels.
    float focalLengthHorizontal;
    
    /// The vertical focal length in pixels.
    float focalLengthVertical;
    
    /// The minimum possible focal length in millimeters.
    float focalLengthMinimum;
    
    /// The physical sensor width in millimeters.
    float physicalSensorWidth;
    
    /// The physical sensor height in millimeters.
    float physicalSensorHeight;
    
    /// Exposure in nanoseconds.
    double exposure;
    
    /// The minimum possible exposure in nanoseconds.
    double minExposure;
    
    /// The maximum possible exposure in nanoseconds.
    double maxExposure;
    
    /// The exposure target offset in EV units.
    double exposureTargetOffset;
    
    /// The actual ISO value in ISO arithmetic units.
    double isoValue;
    
    /// The minimum possible ISO value in ISO arithmetic units.
    double minIso;
    
    /// The maximum possible ISO value in ISO arithmetic units.
    double maxIso;
    
} CameraConfig;

/**
 * Constants indicating the buffer type for rendering.
 */
typedef NS_ENUM(NSInteger, DirectBufferType)
{
    /// Unknown.
    DirectBufferTypeUnknown = 0,
    
    /// UINT8_PTR
    DirectBufferTypeUINT8_PTR = 1,
    
    /// CVPixelBufferRef
    DirectBufferTypeCVPixelBufferRef = 2,
    
    /// CMSampleBufferRef
    DirectBufferTypeCMSampleBufferRef = 3
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates camera information.
 */
__attribute__((visibility("default"))) @interface CameraObject : NSObject

/**
 * New camera object.
 * @param timestamp The acquisition timestamp.
 * @param configuration The camera configuration structure.
 * @param buffer The camera buffer data.
 * @param bufferType The camera buffer data type.
 */
+ (nullable CameraObject *)createCamera:(NSInteger)timestamp configuration:(CameraConfig)configuration buffer:(nonnull void *)buffer bufferType:(DirectBufferType)bufferType bufferSize:(NSInteger)bufferSize allowReleaseBuffer:(BOOL)allowRelease;

/**
 Creates a CameraConfig instance with the specified parameters.
 
 @param horizontalFOV Horizontal Field Of View in radians.
 @param verticalFOV Vertical Field Of View in radians.
 @param frameWidth Frame width in pixels.
 @param frameHeight Frame height in pixels.
 @param pixelFormat The pixel format (encoding type).
 @param frameRate The frame rate value.
 @param orientation The frame orientation.
 @param focalLengthHorizontal The horizontal focal length in pixels.
 @param focalLengthVertical The vertical focal length in pixels.
 @param focalLengthMinimum The minimum possible focal length in millimeters.
 @param physicalSensorWidth The physical sensor width in millimeters.
 @param physicalSensorHeight The physical sensor height in millimeters.
 @param exposure Exposure in nanoseconds.
 @param minExposure The minimum possible exposure in nanoseconds.
 @param maxExposure The maximum possible exposure in nanoseconds.
 @param exposureTargetOffset The exposure target offset in EV units.
 @param isoValue The actual ISO value in ISO arithmetic units.
 @param minIso The minimum possible ISO value in ISO arithmetic units.
 @param maxIso The maximum possible ISO value in ISO arithmetic units.
 @return A CameraConfig instance initialized with the provided parameters.
 */
+(CameraConfig)createCameraConfiguration:(double)horizontalFOV
                                              verticalFOV:(double)verticalFOV
                                               frameWidth:(int)frameWidth
                                              frameHeight:(int)frameHeight
                                              pixelFormat:(ImagePixelFormat)pixelFormat
                                              frameRate:(double)frameRate
                                              orientation:(OrientationType)orientation
                                    focalLengthHorizontal:(float)focalLengthHorizontal
                                      focalLengthVertical:(float)focalLengthVertical
                                       focalLengthMinimum:(float)focalLengthMinimum
                                      physicalSensorWidth:(float)physicalSensorWidth
                                     physicalSensorHeight:(float)physicalSensorHeight
                                                 exposure:(double)exposure
                                              minExposure:(double)minExposure
                                              maxExposure:(double)maxExposure
                                     exposureTargetOffset:(double)exposureTargetOffset
                                                 isoValue:(double)isoValue
                                                   minIso:(double)minIso
                                                   maxIso:(double)maxIso;

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void*)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Initializes and returns a newly allocated object using the data object.
 */
- (instancetype)initWithDataObject:(nonnull DataObject *)data;

/**
 * Returns the model data object.
 */
- (nullable DataObject*)getDataObject;

/**
 * Get the camera configuration.
 */
- (CameraConfig)getCameraConfiguration;

/**
 * Get the direct buffer as uint8*, independent of platform.
 */
- (nullable void *)getBuffer;

/**
 * Get the buffer size.
 */
- (NSUInteger)getBufferSize;

/**
 * Get the raw buffer.
 */
- (nullable void *)getDirectBuffer;

/**
 * Get direct buffer type.
 */
- (DirectBufferType)getDirectBufferType;

@end

NS_ASSUME_NONNULL_END

