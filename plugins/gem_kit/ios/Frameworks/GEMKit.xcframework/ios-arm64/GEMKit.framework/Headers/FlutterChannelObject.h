// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all 
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V. 
// or its affiliates is strictly prohibited.

// #ifdef WITH_FLUTTER_FEATURE

#import <Foundation/Foundation.h>
#import <GEMKit/GenericHeader.h>
#import <GEMKit/MapViewController.h>

/**
 * Constants indicating the Flutter method exceptions.
 */
typedef NS_ENUM(NSInteger, FlutterMethodException)
{
    /// FlutterMethodCompletion onException should return the created MapViewController.
    FlutterMethodExceptionCreateView,
    
    /// FlutterMethodCompletion onException should return the released MapViewController.
    FlutterMethodExceptionReleaseView,
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class handles the flutter channel object.
 */
__attribute__((visibility("default"))) @interface FlutterChannelObject : NSObject

/**
 * Register map view.
 * @param mapViewController The map view controller.
 * @param args Method arguments as Json data buffer.
 * @param completionHandler The completion handler with the operation code, data and the flag to indicate future events.
 * @details Returns SDKErrorCodeKNoError if the method was understood by the channel.
 * @details Returns error if the method call is unknown of ill formatted.
 */
- (SDKErrorCode)registerMapView:(nonnull MapViewController *)mapViewController args:(nonnull NSData *)data
                   eventHandler:(nonnull void(^)(NSString * _Nonnull eventName, NSData * _Nonnull  data, BOOL finalEvent))eventHandler
              completionHandler:(nonnull void(^)(SDKErrorCode code,  NSData * _Nonnull  data, BOOL waitFutureEvents))completionHandler;

/**
 * Clear map view.
 * @param mapViewController The map view controller.
 * @param completionHandler The completion handler with the operation code.
 * @details Returns SDKErrorCodeKNoError if the method was understood by the channel.
 * @details Returns error if the method call is unknown of ill formatted.
 */
- (SDKErrorCode)clearMapView:(nonnull MapViewController *)mapViewController
           completionHandler:(nonnull void(^)(SDKErrorCode code))completionHandler;

/**
 * Parse channel method.
 * @param name Method name.
 * @param args Method arguments as Json data buffer.
 * @param eventHandler The event handler with the event name, data and flag if it is the last event in the process.
 * @param completionHandler The completion handler with the operation code, data and the flag to indicate future events.
 * @details Returns SDKErrorCodeKNoError if the method was understood by the channel.
 * @details Returns error if the method call is unknown of ill formatted.
 */
- (SDKErrorCode)parseMethod:(nonnull NSString *)name args:(nonnull NSData *)data
               eventHandler:(nonnull void(^)(NSString * _Nonnull eventName, NSData * _Nonnull  data, BOOL finalEvent))eventHandler
          completionHandler:(nonnull void(^)(SDKErrorCode code,  NSData * _Nonnull  data, BOOL waitFutureEvents))completionHandler;

@end

NS_ASSUME_NONNULL_END

// #endif // WITH_FLUTTER_FEATURE
