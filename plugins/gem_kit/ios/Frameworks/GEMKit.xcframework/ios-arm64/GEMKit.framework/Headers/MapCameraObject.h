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
#import <GEMKit/GenericHeader.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * An object that manages a map view camera.
 */
__attribute__((visibility("default"))) @interface MapCameraObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (void *)getModelData NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Saves the current state of the camera into a binary format. The data buffer instance containing the binary representation of the camera's current state.
 * @details The returned buffer can be used to restore the camera state at a later time.
 */
- (nullable NSData *)saveCameraState;

/**
 * Restores the camera's state from a previously saved binary format.
 * @param data The data buffer instance containing the binary data to restore the camera's state from.
 * @details The returned integer indicating the success (0) or failure (non-zero) of the operation.
 */
- (SDKErrorCode)restoreCameraState:(nonnull NSData *)data;

@end

NS_ASSUME_NONNULL_END
