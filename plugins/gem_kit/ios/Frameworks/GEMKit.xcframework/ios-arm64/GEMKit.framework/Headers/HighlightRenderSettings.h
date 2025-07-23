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
#import <GEMKit/LandmarkObject.h>
#import <GEMKit/MapViewHeader.h>

/**
 * Constants indicating the landmark highlight option.
 */
typedef NS_ENUM(NSInteger, HighlightOption)
{
    /// Shows landmark icon & text ( default ).
    HighlightOptionShowLandmark = 0x01,
    
    /// Shows landmark impact area contour ( when available ).
    /// @details By default, the option is true.
    HighlightOptionShowContour = 0x2,
    
    /// Groups landmarks.
    /// @details This option is available only in conjunction with HighlightOptionsShowLandmark.
    /// @details By default, the option is false.
    HighlightOptionGroup = 0x4,
    
    /// Overlap highlight over existing map data
    /// @details This option is available only in conjunction with HighlightOptionsShowLandmark.
    /// @details By default, the option is false.
    HighlightOptionOverlap = 0x8,
    
    /// Disable highlight fading in / out.
    /// @details This option is available only in conjunction with HighlightOptionsShowLandmark.
    /// @details By default, the option is false.
    HighlightOptionNoFading = 0x10,
    
    /// Bubble display
    /// @details The highlights are displayed in a bubble with custom icon placement inside the text.
    /// @details This option is available only in conjunction with HighlightOptionsShowLandmark.
    /// @details This option will automatically invalidate the HighlightOptionsGroup.
    /// @details By default, the option is false.
    HighlightOptionBubble = 0x20,
    
    /// Selectable
    /// @details This option is available only in conjunction with ShowLandmark.
    /// @details By default, the option is false.
    HighlightOptionSelectable = 0x40
};

NS_ASSUME_NONNULL_BEGIN

/**
 * An object that manages landmark highlights render settings.
 */
__attribute__((visibility("default"))) @interface HighlightRenderSettings : NSObject

/**
 * The highlight options.
 */
@property(nonatomic, assign) int options;

/**
 * The highlight contour inner color.
 */
@property(nonatomic, strong) UIColor *contourInnerColor;

/**
 * The highlight contour outer color.
 */
@property(nonatomic, strong) UIColor *contourOuterColor;

/**
 * The highlight contour inner size in mm.
 */
@property(nonatomic, assign) double contourInnerSize;

/**
 * The highlight contour outer ( border ) size in mm.
 */
@property(nonatomic, assign) double contourOuterSize;

/**
 * The icon size in mm ( default value from current style ).
 */
@property(nonatomic, assign) double imageSize;

/**
 * The image position.
 */
@property(nonatomic, assign) ImagePosition imagePosition;

/**
 * The text size in mm ( default value from current style ).
 */
@property(nonatomic, assign) double textSize;

/**
 * The text color ( default value from current style ).
 */
@property(nonatomic, strong) UIColor *textColor;

/**
 * Highlight pin on the map. Default false.
 * @details This will overwrite the landmark image.
 */
@property(nonatomic, assign) BOOL showPin;

@end

NS_ASSUME_NONNULL_END
