// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'package:flutter/material.dart';
import 'package:gem_kit/src/core/extensions.dart';

/// Line type for linear features.
///
/// {@category Maps & 3D Scene}
enum LineType {
  /// Default line style.
  styleDefault,

  /// Solid line style.
  solid,

  /// Dashed line style.
  dashed,
}

/// @nodoc
///
/// {@category Maps & 3D Scene}
extension LineTypeExtension on LineType {
  int get id {
    switch (this) {
      case LineType.styleDefault:
        return 0;
      case LineType.solid:
        return 1;
      case LineType.dashed:
        return 2;
    }
  }

  static LineType fromId(final int id) {
    switch (id) {
      case 0:
        return LineType.styleDefault;
      case 1:
        return LineType.solid;
      case 2:
        return LineType.dashed;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Image position relative to position reference.
///
/// {@category Maps & 3D Scene}
enum ImagePosition {
  /// Default image position (style defined).
  styleDefault,

  /// Centered on position. Default.
  center,

  /// Left-top side relative to position.
  leftTop,

  /// Horizontal centered-top side relative to position.
  centerTop,

  /// Right-top side relative to position.
  rightTop,

  /// Right-vertical centered side relative to position.
  rightCenter,

  /// Right-bottom side relative to position.
  rightBottom,

  /// Horizontal centered-bottom side relative to position.
  centerBottom,

  /// Left-bottom side relative to position.
  leftBottom,

  /// Left-vertical centered side relative to position.
  leftCenter,
}

/// @nodoc
///
/// {@category Maps & 3D Scene}
extension ImagePositionExtension on ImagePosition {
  int get id {
    switch (this) {
      case ImagePosition.styleDefault:
        return 0;
      case ImagePosition.center:
        return 1;
      case ImagePosition.leftTop:
        return 2;
      case ImagePosition.centerTop:
        return 3;
      case ImagePosition.rightTop:
        return 4;
      case ImagePosition.rightCenter:
        return 5;
      case ImagePosition.rightBottom:
        return 6;
      case ImagePosition.centerBottom:
        return 7;
      case ImagePosition.leftBottom:
        return 8;
      case ImagePosition.leftCenter:
        return 9;
    }
  }

  static ImagePosition fromId(final int id) {
    switch (id) {
      case 0:
        return ImagePosition.styleDefault;
      case 1:
        return ImagePosition.center;
      case 2:
        return ImagePosition.leftTop;
      case 3:
        return ImagePosition.centerTop;
      case 4:
        return ImagePosition.rightTop;
      case 5:
        return ImagePosition.rightCenter;
      case 6:
        return ImagePosition.rightBottom;
      case 7:
        return ImagePosition.centerBottom;
      case 8:
        return ImagePosition.leftBottom;
      case 9:
        return ImagePosition.leftCenter;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Landmarks highlight display options
///
/// {@category Maps & 3D Scene}
enum HighlightOptions {
  /// Shows the landmark icon & text
  showLandmark,

  /// Shows the landmark impact area contour ( when available )
  ///
  /// By default, the option is enabled
  showContour,

  /// Groups landmarks
  ///
  /// This option is available only in conjunction with [showLandmark]. By default, the option is disabled.
  group,

  /// Overlap highlight over existing map data
  ///
  /// This option is available only in conjunction with [showLandmark]. By default, the option is disabled.
  overlap,

  /// Disable highlight fading in / out
  ///
  /// This option is available only in conjunction with [showLandmark]. By default, the option is disabled.
  noFading,

  /// Bubble display
  ///
  /// The highlights are displayed in a bubble with custom icon placement inside the text by using the icon place-mark `%%0%%`, e.g. `"My header text %%0%%\nMy footer text"`
  /// This option is available only in conjunction with [showLandmark]
  /// This option will automatically invalidate the [group]
  /// By default, the option is disabled
  bubble,

  /// Selectable
  ///
  /// The highlights are selectable using setCursorScreenPosition
  /// This option is available only in conjunction with [showLandmark]
  /// By default, the option is disabled
  selectable,
}

/// @nodoc
///
/// {@category Maps & 3D Scene}
extension HighlightOptionsExtension on HighlightOptions {
  int get id {
    switch (this) {
      case HighlightOptions.showLandmark:
        return 1;
      case HighlightOptions.showContour:
        return 2;
      case HighlightOptions.group:
        return 4;
      case HighlightOptions.overlap:
        return 8;
      case HighlightOptions.noFading:
        return 16;
      case HighlightOptions.bubble:
        return 32;
      case HighlightOptions.selectable:
        return 64;
    }
  }

  static HighlightOptions fromId(final int id) {
    switch (id) {
      case 1:
        return HighlightOptions.showLandmark;
      case 2:
        return HighlightOptions.showContour;
      case 4:
        return HighlightOptions.group;
      case 8:
        return HighlightOptions.overlap;
      case 16:
        return HighlightOptions.noFading;
      case 32:
        return HighlightOptions.bubble;
      case 64:
        return HighlightOptions.selectable;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Enum for route render options.
///
/// {@category Maps & 3D Scene}
enum RouteRenderOptions {
  /// Main route.
  main,

  /// Show traffic on the route.
  showTraffic,

  /// Show turn arrows on the route.
  showTurnArrows,

  /// Show waypoints on the route.
  showWaypoints,

  /// Show highlights on the route.
  showHighlights,

  /// Show user images that were set previously to route landmarks or waypoints.
  /// For example, if this flag is set, it will take the image from landmark(user image) and show it on the route instead of the default icon.
  showUserImage,
}

/// @nodoc
///
/// {@category Maps & 3D Scene}
extension RouteRenderOptionsExtension on RouteRenderOptions {
  int get id {
    switch (this) {
      case RouteRenderOptions.main:
        return 1;
      case RouteRenderOptions.showTraffic:
        return 2;
      case RouteRenderOptions.showTurnArrows:
        return 4;
      case RouteRenderOptions.showWaypoints:
        return 8;
      case RouteRenderOptions.showHighlights:
        return 16;
      case RouteRenderOptions.showUserImage:
        return 32;
    }
  }

  static RouteRenderOptions fromId(final int id) {
    switch (id) {
      case 1:
        return RouteRenderOptions.main;
      case 2:
        return RouteRenderOptions.showTraffic;
      case 4:
        return RouteRenderOptions.showTurnArrows;
      case 8:
        return RouteRenderOptions.showWaypoints;
      case 16:
        return RouteRenderOptions.showHighlights;
      case 32:
        return RouteRenderOptions.showUserImage;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Class that defines the rendering settings for a view.
///
/// {@category Maps & 3D Scene}
class RenderSettings<T> {
  RenderSettings({
    this.options = const <Never>{},
    this.innerColor = defaultInnerColor,
    this.outerColor = defaultOuterColor,
    this.innerSz = defaultInnerSize,
    this.outerSz = defaultOuterSize,
    this.imgSz = defaultImageSize,
    this.textSz = defaultTextSize,
    this.textColor = defaultTextColor,
    this.lineType = defaultLineType,
    this.imagePosition = defaultImagePosition,
  });

  /// The set that defines what elements to show.
  Set<T> options;

  /// The color for the inner area.
  Color innerColor;

  /// The color for the outer area.
  Color outerColor;

  /// The size for the inner area in millimeters.
  double innerSz;

  /// The size for the outer area in millimeters.
  double outerSz;

  /// The size of the image in millimeters.
  double imgSz;

  /// The size for the text in millimeters.
  double textSz;

  /// The color for the text.
  Color textColor;

  /// The line type.
  LineType lineType;

  /// Image position
  ImagePosition imagePosition;

  Map<String, dynamic> toJsonWithOptions(
    final dynamic Function(Set<dynamic> options) optionsSerializer,
  ) {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['options'] = optionsSerializer(options);
    json['innerColor'] = innerColor.toRgba();
    json['outerColor'] = outerColor.toRgba();
    json['innerSz'] = innerSz;
    json['outerSz'] = outerSz;
    json['imgSz'] = imgSz;
    json['textSz'] = textSz;
    json['textColor'] = textColor.toRgba();
    json['lineType'] = lineType.id;
    json['imagePosition'] = imagePosition.id;
    return json;
  }

  /// Default value for [innerColor]
  static const Color defaultInnerColor = Color(0x00000000);

  /// Default value for [outerColor]
  static const Color defaultOuterColor = Color(0x00000000);

  /// Default value for [textColor]
  static const Color defaultTextColor = Color(0x00000000);

  /// Default value for [innerSz]
  static const double defaultInnerSize = -1.0;

  /// Default value for [outerSz]
  static const double defaultOuterSize = 0.0;

  /// Default value for [imgSz]
  static const double defaultImageSize = 0.0;

  /// Default value for [textSz]
  static const double defaultTextSize = 0.0;

  /// Default value for [lineType]
  static const LineType defaultLineType = LineType.styleDefault;

  /// Default value for [imagePosition]
  static const ImagePosition defaultImagePosition = ImagePosition.styleDefault;
}

/// Highlights render settings
///
/// {@category Maps & 3D Scene}
class HighlightRenderSettings extends RenderSettings<HighlightOptions> {
  HighlightRenderSettings({
    super.options = const <HighlightOptions>{HighlightOptions.showLandmark},
    super.innerColor = const Color.fromARGB(255, 255, 98, 0),
    super.outerColor = const Color.fromARGB(255, 255, 98, 0),
    super.innerSz = 1.5,
    super.outerSz = RenderSettings.defaultOuterSize,
    super.imgSz = RenderSettings.defaultImageSize,
    super.textSz = RenderSettings.defaultTextSize,
    super.textColor = RenderSettings.defaultTextColor,
    super.lineType = RenderSettings.defaultLineType,
    super.imagePosition = RenderSettings.defaultImagePosition,
  });

  Map<String, dynamic> toJson() {
    return super.toJsonWithOptions((final Set<dynamic> options) {
      int el1 = (options.first as HighlightOptions).id;
      for (final dynamic option in options.skip(1)) {
        el1 |= (option as HighlightOptions).id;
      }
      return el1;
    });
  }
}
