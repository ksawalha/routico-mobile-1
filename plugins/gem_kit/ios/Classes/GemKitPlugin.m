// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all 
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V. 
// or its affiliates is strictly prohibited.

#import "GemKitPlugin.h"
#if __has_include(<gem_kit/gem_kit-Swift.h>)
#import <gem_kit/gem_kit-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "gem_kit-Swift.h"
#endif

@implementation GemKitPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar
{
    [SwiftGemKitPlugin registerWithRegistrar:registrar];
}

@end
