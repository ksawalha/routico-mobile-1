// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/extensions.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Enumerates known image file formats.
///
/// {@category Core}
enum ImageFileFormat {
  /// BMP image file format.
  bmp,

  /// JPEG image file format.
  jpeg,

  /// GIF image file format.
  gif,

  /// PNG image file format.
  png,

  /// TGA image file format.
  tga,

  /// WebP image file format
  pvrtc,

  /// Automatically detect image file format.
  autoDetect,
}

/// @nodoc
///
/// {@category Core}
extension ImageFileFormatExtension on ImageFileFormat {
  int get id {
    switch (this) {
      case ImageFileFormat.bmp:
        return 0;
      case ImageFileFormat.jpeg:
        return 1;
      case ImageFileFormat.gif:
        return 2;
      case ImageFileFormat.png:
        return 3;
      case ImageFileFormat.tga:
        return 4;
      case ImageFileFormat.pvrtc:
        return 5;
      case ImageFileFormat.autoDetect:
        return 6;
    }
  }

  static ImageFileFormat fromId(final int id) {
    switch (id) {
      case 0:
        return ImageFileFormat.bmp;
      case 1:
        return ImageFileFormat.jpeg;
      case 2:
        return ImageFileFormat.gif;
      case 3:
        return ImageFileFormat.png;
      case 4:
        return ImageFileFormat.tga;
      case 5:
        return ImageFileFormat.pvrtc;
      case 6:
        return ImageFileFormat.autoDetect;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Abstract geometry image render settings.
///
/// Initialized with default optimal values
///
/// {@category Core}
class AbstractGeometryImageRenderSettings {
  /// Constructor with optional border size, border round corners and maximum rows
  ///
  /// **Parameters**
  ///
  /// * **IN** *activeInnerColor*	Active turn arrow inner color. If not specified, the SDK default is used
  /// * **IN** *activeOuterColor*	Active turn arrow outer color. If not specified, the SDK default is used
  /// * **IN** *inactiveInnerColor*	Inactive turn arrow inner color. If not specified, the SDK default is used
  /// * **IN** *inactiveOuterColor*	Inactive turn arrow outer color. If not specified, the SDK default is used
  const AbstractGeometryImageRenderSettings({
    this.activeInnerColor = const Color.fromARGB(255, 255, 255, 255),
    this.activeOuterColor = const Color.fromARGB(255, 0, 0, 0),
    this.inactiveInnerColor = const Color.fromARGB(255, 128, 128, 128),
    this.inactiveOuterColor = const Color.fromARGB(255, 128, 128, 128),
  });

  factory AbstractGeometryImageRenderSettings.fromJson(
    final Map<String, dynamic> json,
  ) {
    return AbstractGeometryImageRenderSettings(
      activeInnerColor:
          json['activeInnerColor'] ?? const Color.fromARGB(255, 255, 255, 255),
      activeOuterColor:
          json['activeOuterColor'] ?? const Color.fromARGB(255, 0, 0, 0),
      inactiveInnerColor: json['inactiveInnerColor'] ??
          const Color.fromARGB(255, 128, 128, 128),
      inactiveOuterColor: json['inactiveOuterColor'] ??
          const Color.fromARGB(255, 128, 128, 128),
    );
  }

  /// Active turn arrow inner color. If not specified, the SDK default is used
  final Color activeInnerColor;

  /// Active turn arrow outer color. If not specified, the SDK default is used
  final Color activeOuterColor;

  /// Inactive turn arrow inner color. If not specified, the SDK default is used
  final Color inactiveInnerColor;

  /// Inactive turn arrow outer color. If not specified, the SDK default is used
  final Color inactiveOuterColor;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['activeInnerColor'] = activeInnerColor.toRgba();
    json['activeOuterColor'] = activeOuterColor.toRgba();
    json['inactiveInnerColor'] = inactiveInnerColor.toRgba();
    json['inactiveOuterColor'] = inactiveOuterColor.toRgba();
    return json;
  }

  @override
  bool operator ==(covariant final AbstractGeometryImageRenderSettings other) {
    if (identical(this, other)) {
      return true;
    }

    return other.activeInnerColor == activeInnerColor &&
        other.activeOuterColor == activeOuterColor &&
        other.inactiveInnerColor == inactiveInnerColor &&
        other.inactiveOuterColor == inactiveOuterColor;
  }

  @override
  int get hashCode {
    return activeInnerColor.hashCode ^
        activeOuterColor.hashCode ^
        inactiveInnerColor.hashCode ^
        inactiveOuterColor.hashCode;
  }
}

/// Signpost image render settings.
///
/// Initialized with default optimal values
///
/// {@category Core}
class SignpostImageRenderSettings {
  /// Constructor with optional border size, border round corners and maximum rows
  ///
  /// **Parameters**
  ///
  /// * **IN** *borderSize*	Border size in pixels
  /// * **IN** *borderRoundCorners*	Round corners border
  /// * **IN** *maxRows* Maximum rows of details in the signpost
  const SignpostImageRenderSettings({
    this.borderSize = 10,
    this.borderRoundCorners = true,
    this.maxRows = 3,
  });

  factory SignpostImageRenderSettings.fromJson(
    final Map<String, dynamic> json,
  ) {
    return SignpostImageRenderSettings(
      borderSize: json['borderSize'],
      borderRoundCorners: json['borderRoundCorners'],
      maxRows: json['maxRows'],
    );
  }

  /// Border size in pixels
  final int borderSize;

  /// Round corners border
  final bool borderRoundCorners;

  /// Maximum rows of details in the signpost
  final int maxRows;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['borderSize'] = borderSize;
    json['borderRoundCorners'] = borderRoundCorners;
    json['maxRows'] = maxRows;

    return json;
  }

  @override
  bool operator ==(covariant final SignpostImageRenderSettings other) {
    if (identical(this, other)) {
      return true;
    }

    return other.borderSize == borderSize &&
        other.borderRoundCorners == borderRoundCorners &&
        other.maxRows == maxRows;
  }

  @override
  int get hashCode {
    return borderSize.hashCode ^ borderRoundCorners.hashCode ^ maxRows.hashCode;
  }
}

/// Lane image render settings.
///
/// Initialized with default optimal values
///
/// {@category Core}
class LaneImageRenderSettings {
  /// Constructor
  ///
  /// **Parameters**
  ///
  /// * **IN** *backgroundColor* Background color
  /// * **IN** *activeColor* Active lanes color
  /// * **IN** *inactiveColor* Inactive lanes color
  const LaneImageRenderSettings({
    this.backgroundColor = const Color.fromARGB(0, 0, 0, 0),
    this.activeColor = const Color.fromARGB(255, 255, 255, 255),
    this.inactiveColor = const Color.fromARGB(255, 140, 140, 140),
  });

  factory LaneImageRenderSettings.fromJson(final Map<String, dynamic> json) {
    return LaneImageRenderSettings(
      backgroundColor:
          json['backgroundColor'] ?? const Color.fromARGB(0, 0, 0, 0),
      activeColor:
          json['activeColor'] ?? const Color.fromARGB(255, 255, 255, 255),
      inactiveColor:
          json['inactiveColor'] ?? const Color.fromARGB(255, 140, 140, 140),
    );
  }

  /// Background color
  final Color backgroundColor;

  /// Active lanes color
  final Color activeColor;

  /// Inactive lanes color
  final Color inactiveColor;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['backgroundColor'] = backgroundColor.toRgba();
    json['activeColor'] = activeColor.toRgba();
    json['inactiveColor'] = inactiveColor.toRgba();
    return json;
  }

  @override
  bool operator ==(covariant final LaneImageRenderSettings other) {
    if (identical(this, other)) {
      return true;
    }

    return other.backgroundColor == backgroundColor &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor;
  }

  @override
  int get hashCode {
    return backgroundColor.hashCode ^
        activeColor.hashCode ^
        inactiveColor.hashCode;
  }
}

/// @nodoc
///
/// {@category Core}
class GemImage {
  GemImage({this.image, this.format, this.imageId = -1}) {
    _computeAspectRatio();
  }
  final Uint8List? image;
  final ImageFileFormat? format;
  final int? imageId;
  double aspectRatioX = 1.0;
  double aspectRatioY = 1.0;

  // Method to convert GemImage to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    if (image != null) {
      json['image'] = image;
    }
    if (format != null) {
      json['format'] = format!.id;
    }
    if (imageId != null) {
      json['imageId'] = imageId;
    }

    json['aspectRatioX'] = aspectRatioX;
    json['aspectRatioY'] = aspectRatioY;

    return json;
  }

  static GemImage fromJson(final Map<String, dynamic> json) {
    return GemImage(
      image: utf8.encode(json['image']),
      format: ImageFileFormatExtension.fromId(json['format']),
      imageId: json['imageId'],
    );
  }

  @override
  bool operator ==(covariant final GemImage other) {
    if (identical(this, other)) {
      return true;
    }

    return other.image == image &&
        other.format == format &&
        other.imageId == imageId;
  }

  (int, int)? _getImageDimensionsPng(final Uint8List imageData) {
    if (imageData[0] == 0x89 &&
        imageData[1] == 0x50 &&
        imageData[2] == 0x4E &&
        imageData[3] == 0x47) {
      // PNG Width/Height are stored at bytes 16-23
      final int width = imageData.buffer.asByteData().getUint32(16);
      final int height = imageData.buffer.asByteData().getUint32(20);
      return (width, height);
    }
    return null;
  }

  (int, int)? _getImageDimensionsJpeg(final Uint8List imageData) {
    if (imageData[0] == 0xFF && imageData[1] == 0xD8) {
      int offset = 2;
      while (offset < imageData.length) {
        if (imageData[offset] == 0xFF) {
          final int marker = imageData[offset + 1];
          final int length =
              imageData.buffer.asByteData().getUint16(offset + 2) + 2;

          // Check for SOF0 marker (start of frame) where dimensions are stored
          if (marker == 0xC0 || marker == 0xC2) {
            final int height = imageData.buffer.asByteData().getUint16(
                  offset + 5,
                );
            final int width = imageData.buffer.asByteData().getUint16(
                  offset + 7,
                );
            return (width, height);
          }

          offset += length;
        } else {
          break; // Invalid JPEG format
        }
      }
    }
    return null;
  }

  (int, int)? _getImageDimensionsBmp(final Uint8List imageData) {
    if (imageData[0] == 0x42 && imageData[1] == 0x4D) {
      // BMP Width/Height are stored at bytes 18-25 (4 bytes each)
      final int width = imageData.buffer.asByteData().getUint32(
            18,
            Endian.little,
          );
      final int height = imageData.buffer.asByteData().getUint32(
            22,
            Endian.little,
          );
      return (width, height);
    }
    return null;
  }

  (int, int)? _getImageDimensionsGif(final Uint8List imageData) {
    if (imageData.length < 10) {
      return null; // Not enough data for a GIF header
    }

    // Check for GIF signature ("GIF" at the start, followed by "87a" or "89a" version)
    if (imageData[0] == 0x47 && imageData[1] == 0x49 && imageData[2] == 0x46) {
      final int width = imageData.buffer.asByteData().getUint16(
            6,
            Endian.little,
          );
      final int height = imageData.buffer.asByteData().getUint16(
            8,
            Endian.little,
          );
      return (width, height);
    }
    // Not a GIF file
    return null;
  }

  (int, int) _getImageDimensions(
    final Uint8List imageData,
    final ImageFileFormat format,
  ) {
    if (imageData.length < 24) {
      return (1, 1); // Not enough data
    }
    switch (format) {
      case ImageFileFormat.png:
        return _getImageDimensionsPng(imageData) ?? (1, 1);
      case ImageFileFormat.jpeg:
        return _getImageDimensionsJpeg(imageData) ?? (1, 1);
      case ImageFileFormat.bmp:
        return _getImageDimensionsBmp(imageData) ?? (1, 1);
      case ImageFileFormat.gif:
        return _getImageDimensionsGif(imageData) ?? (1, 1);
      case ImageFileFormat.autoDetect:
        return _getImageDimensionsPng(imageData) ??
            _getImageDimensionsJpeg(imageData) ??
            _getImageDimensionsBmp(imageData) ??
            (1, 1);

      case ImageFileFormat.tga:
        return (1, 1);
      case ImageFileFormat.pvrtc:
        return (1, 1);
    }
  }

  void _computeAspectRatio() {
    if (image != null) {
      final (int, int) imgDimensions = _getImageDimensions(image!, format!);
      if (imgDimensions.$1 > imgDimensions.$2) {
        aspectRatioX =
            imgDimensions.$1.toDouble() / imgDimensions.$2.toDouble();
        aspectRatioY = 1.0;
      } else if (imgDimensions.$1 < imgDimensions.$2) {
        aspectRatioX = 1.0;
        aspectRatioY =
            imgDimensions.$1.toDouble() / imgDimensions.$2.toDouble();
      } else {
        aspectRatioX = 1.0;
        aspectRatioY = 1.0;
      }
    }
  }

  @override
  int get hashCode {
    return image.hashCode ^ format.hashCode ^ imageId.hashCode;
  }
}

/// Type of an image
///
/// {@category Maps & 3D Scene}
enum ImageType {
  /// Base type. Provided by ImageDatabase
  base,

  /// Abstract geometry icon type. Provided by [TurnDetails]
  abstractGeometry,

  /// Road info type. Provided by [RoadInfo]
  roadInfo,

  /// Signpost type. Provided by [SignpostDetails]
  signpost,

  /// Lane info type. Provided by [NavigationInstruction]
  lane,
}

/// This class will not be documented
///
/// @nodoc
extension ImageTypeExtension on ImageType {
  int get id {
    switch (this) {
      case ImageType.base:
        return 0;
      case ImageType.abstractGeometry:
        return 1;
      case ImageType.roadInfo:
        return 2;
      case ImageType.signpost:
        return 3;
      case ImageType.lane:
        return 4;
    }
  }

  static ImageType fromId(int id) {
    switch (id) {
      case 0:
        return ImageType.base;
      case 1:
        return ImageType.abstractGeometry;
      case 2:
        return ImageType.roadInfo;
      case 3:
        return ImageType.signpost;
      case 4:
        return ImageType.lane;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Base class for images
///
/// Represents the image in an abstract way, providing metadata and access to the [RenderableImg].
/// {@category Core}
abstract class ImgBase extends GemAutoreleaseObject {
  // ignore: unused_element
  ImgBase._() : _pointerId = -1;

  ImgBase.init(int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Get the image unique ID
  ///
  /// **Returns**
  ///
  /// * The image ID
  int get uid {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ImgFlutter',
      'getUid',
    );

    return resultString['result'];
  }

  /// Get the image type
  ///
  /// **Returns**
  ///
  /// * The image type
  ImageType get imageType {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ImgFlutter',
      'getType',
    );

    return ImageTypeExtension.fromId(resultString['result']);
  }

  /// Check if the image is valid
  ///
  /// **Returns**
  ///
  /// * True if the image is valid, false otherwise
  bool get isValid {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ImgFlutter',
      'isValid',
    );

    return resultString['result'] == 1;
  }

  /// Get the image data as a [Uint8List].
  ///
  /// Display the image on UI using the [Image.memory] constructor.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The image size as (width, height).
  /// * **IN** *format* The image format. By default it is PNG.
  ///
  /// **Returns**
  ///
  /// * The image as a [Uint8List] if the image [isValid], null otherwise
  Uint8List? getRenderableImageBytes({
    Size? size,
    ImageFileFormat format = ImageFileFormat.png,
  }) {
    return getRenderableImage(size: size, format: format)?.bytes;
  }

  /// Get the image data as a [RenderableImg].
  /// A [RenderableImg] contains the [Uint8List] and its width and height.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The image size as (width, height).
  /// * **IN** *format* The image format. By default it is PNG.
  ///
  /// **Returns**
  ///
  /// * The image as a [RenderableImg] if the image [isValid], null otherwise
  RenderableImg? getRenderableImage({
    Size? size,
    ImageFileFormat format = ImageFileFormat.png,
  }) {
    return GemKitPlatform.instance.callGetFlutterImg(
      _pointerId,
      size != null ? size.width.toInt() : -1,
      size != null ? size.height.toInt() : -1,
      format.id,
      allowResize: false,
    );
  }
}

/// Class used for basic images
///
/// Represents the image in an abstract way, providing metadata and access to the [RenderableImg].
///
/// {@category Maps & 3D Scene}
class Img extends ImgBase {
  /// Create a new image based on image data and format
  ///
  /// **Parameters**
  ///
  /// * **IN** *data* The image data as a [Uint8List].
  /// * **IN** *format* The image format.
  factory Img(
    Uint8List data, {
    ImageFileFormat format = ImageFileFormat.autoDetect,
  }) {
    final dynamic gemImage = GemKitPlatform.instance.createGemImage(
      data,
      format.id,
    );

    try {
      final String resultString = GemKitPlatform.instance.callCreateObject(
        jsonEncode(<String, dynamic>{'class': 'ImgFlutter', 'args': gemImage}),
      );
      final dynamic decodedVal = jsonDecode(resultString);
      final Img retVal = Img.init(decodedVal['result']);
      return retVal;
    } finally {
      GemKitPlatform.instance.deleteCPointer(gemImage);
    }
  }
  // ignore: unused_element
  Img._() : super._();

  Img.init(super.id) : super.init();

  /// Get the image data as a [Uint8List].
  /// Display the image on UI using the [Image.memory] constructor.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The image size as (width, height). If no value is provided then the recomended size for the image will be used.
  /// * **IN** *format* The image format. By default it is PNG.
  ///
  /// **Returns**
  ///
  /// * The image as a [Uint8List] if the image [isValid], null otherwise
  @override
  Uint8List? getRenderableImageBytes({
    Size? size,
    ImageFileFormat format = ImageFileFormat.png,
  }) {
    return super.getRenderableImageBytes(size: size, format: format);
  }

  /// Get the image data as a [RenderableImg].
  /// A [RenderableImg] contains the [Uint8List] and its width and height.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The image size as (width, height). If no value is provided then the recomended size for the image will be used.
  /// * **IN** *format* The image format. By default it is PNG.
  ///
  /// **Returns**
  ///
  /// * The image as a [RenderableImg] if the image [isValid], null otherwise
  @override
  RenderableImg? getRenderableImage({
    Size? size,
    ImageFileFormat format = ImageFileFormat.png,
  }) {
    return super.getRenderableImage(size: size, format: format);
  }

  /// Create a [Img] from an asset
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* The asset key
  /// * **IN** *bundle* The bundle to be used. By default it is [rootBundle]
  static Future<Img> fromAsset(String key, {AssetBundle? bundle}) async {
    bundle ??= rootBundle;

    final ByteData byteData = await bundle.load(key);
    final ByteBuffer buffer = byteData.buffer;
    final Uint8List uint8list = buffer.asUint8List();

    return Img(uint8list);
  }

  /// Get the recommended image size
  ///
  /// **Returns**
  ///
  /// * The recommended image size as (width, height)
  Size get size {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ImgFlutter',
      'getSize',
    );

    final Map<String, dynamic> decodedVal = resultString['result'];
    return Size(decodedVal['first'] + 0.0, decodedVal['second'] + 0.0);
  }

  /// Get the aspect recommended ratio (width / height)
  ///
  /// **Returns**
  ///
  /// * The image aspect ratio
  double get aspectRatio {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ImgFlutter',
      'getAspectRatioF',
    );

    return resultString['result'];
  }

  @internal
  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, Object>{'class': 'ImgFlutter', 'id': _pointerId}),
    );
  }
}

/// Class used for customizable turn images
///
/// Represents the image in an abstract way, providing metadata and access to the [RenderableImg].
///
/// {@category Maps & 3D Scene}
class AbstractGeometryImg extends ImgBase {
  @internal
  AbstractGeometryImg.init(super.id) : super.init();

  /// Get the image data as a [RenderableImg].
  /// A [RenderableImg] contains the [Uint8List] and its width and height.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The image size as (width, height). By default the [SdkSettings.getDefaultWidthHeightImageFormat].size is used
  /// * **IN** *format* The image format. By default it is PNG.
  /// * **IN** *renderSettings* The render settings to be used.
  ///
  /// **Returns**
  ///
  /// * The image as a [RenderableImg] if the image [isValid], null otherwise
  @override
  RenderableImg? getRenderableImage({
    Size? size,
    ImageFileFormat format = ImageFileFormat.png,
    AbstractGeometryImageRenderSettings? renderSettings,
  }) {
    renderSettings ??= const AbstractGeometryImageRenderSettings();

    return GemKitPlatform.instance.callGetFlutterImg(
      _pointerId,
      size != null ? size.width.toInt() : -1,
      size != null ? size.height.toInt() : -1,
      format.id,
      arg: jsonEncode(renderSettings),
      allowResize: false,
    );
  }

  /// Get the image data as a [Uint8List].
  /// Display the image on UI using the [Image.memory] constructor.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The image size as (width, height). By default the [SdkSettings.getDefaultWidthHeightImageFormat].size is used
  /// * **IN** *format* The image format. By default it is PNG.
  /// * **IN** *renderSettings* The render settings to be used.
  ///
  /// **Returns**
  ///
  /// * The image as a [Uint8List] if the image [isValid], null otherwise
  @override
  Uint8List? getRenderableImageBytes({
    Size? size,
    ImageFileFormat format = ImageFileFormat.png,
    AbstractGeometryImageRenderSettings? renderSettings,
  }) {
    return getRenderableImage(
      size: size,
      format: format,
      renderSettings: renderSettings,
    )?.bytes;
  }
}

/// Class used for customizable lane images
///
/// Represents the image in an abstract way, providing metadata and access to the [RenderableImg].
///
/// {@category Maps & 3D Scene}
class LaneImg extends ImgBase {
  @internal
  LaneImg.init(super.id) : super.init();

  /// Get the image data as a [RenderableImg].
  /// A [RenderableImg] contains the [Uint8List] and its width and height.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The image size as (width, height). By default the [SdkSettings.getDefaultWidthHeightImageFormat].size is used
  /// * **IN** *format* The image format. By default it is PNG.
  /// * **IN** *renderSettings* The render settings to be used.
  /// * **IN** *allowResize* If false then the given [size] will be used to render the image. If true then the SDK might choose a suitable size based on the height of the [size]. By default it is false.
  ///
  /// **Returns**
  ///
  /// * The image as a [RenderableImg] if the image [isValid], null otherwise.
  @override
  RenderableImg? getRenderableImage({
    Size? size,
    ImageFileFormat format = ImageFileFormat.png,
    LaneImageRenderSettings? renderSettings,
    bool allowResize = false,
  }) {
    renderSettings ??= const LaneImageRenderSettings();

    return GemKitPlatform.instance.callGetFlutterImg(
      _pointerId,
      size != null ? size.width.toInt() : -1,
      size != null ? size.height.toInt() : -1,
      format.id,
      arg: jsonEncode(renderSettings),
      allowResize: allowResize,
    );
  }

  /// Get the image data as a [Uint8List].
  /// Display the image on UI using the [Image.memory] constructor.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The image size as (width, height). By default the [SdkSettings.getDefaultWidthHeightImageFormat].size is used
  /// * **IN** *format* The image format. By default it is PNG.
  /// * **IN** *renderSettings* The render settings to be used.
  /// * **IN** *allowResize* If false then the given [size] will be used to render the image. If true then the SDK might choose a suitable size based on the height of the [size]. By default it is false.
  ///
  /// **Returns**
  ///
  /// * The image as a [RenderableImg] if the image [isValid], null otherwise.
  @override
  Uint8List? getRenderableImageBytes({
    Size? size,
    ImageFileFormat format = ImageFileFormat.png,
    LaneImageRenderSettings? renderSettings,
    bool allowResize = false,
  }) {
    return getRenderableImage(
      size: size,
      format: format,
      renderSettings: renderSettings,
      allowResize: allowResize,
    )?.bytes;
  }
}

/// Class used for customizable signposts images
///
/// Represents the image in an abstract way, providing metadata and access to the [RenderableImg].
///
/// {@category Maps & 3D Scene}
class SignpostImg extends ImgBase {
  @internal
  SignpostImg.init(super.id) : super.init();

  /// Get the image data as a [RenderableImg].
  /// A [RenderableImg] contains the [Uint8List] and its width and height.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The image size as (width, height). By default the [SdkSettings.getDefaultWidthHeightImageFormat].size is used
  /// * **IN** *format* The image format. By default it is PNG.
  /// * **IN** *renderSettings* The render settings to be used.
  /// * **IN** *allowResize* If false then the given [size] will be used to render the image. If true then the SDK might choose a suitable size based on the height of the [size]. By default it is false.
  ///
  /// **Returns**
  ///
  /// * The image as a [RenderableImg] if the image [isValid], null otherwise.
  @override
  RenderableImg? getRenderableImage({
    Size? size,
    ImageFileFormat format = ImageFileFormat.png,
    SignpostImageRenderSettings? renderSettings,
    bool allowResize = false,
  }) {
    renderSettings ??= const SignpostImageRenderSettings();

    return GemKitPlatform.instance.callGetFlutterImg(
      _pointerId,
      size != null ? size.width.toInt() : -1,
      size != null ? size.height.toInt() : -1,
      format.id,
      arg: jsonEncode(renderSettings),
      allowResize: allowResize,
    );
  }

  /// Get the image data as a [Uint8List].
  /// Display the image on UI using the [Image.memory] constructor.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The image size as (width, height). By default the [SdkSettings.getDefaultWidthHeightImageFormat].size is used
  /// * **IN** *format* The image format. By default it is PNG.
  /// * **IN** *renderSettings* The render settings to be used.
  /// * **IN** *allowResize* If false then the given [size] will be used to render the image. If true then the SDK might choose a suitable size based on the height of the [size]. By default it is false.
  ///
  /// **Returns**
  ///
  /// * The image as a [RenderableImg] if the image [isValid], null otherwise.
  @override
  Uint8List? getRenderableImageBytes({
    Size? size,
    ImageFileFormat format = ImageFileFormat.png,
    SignpostImageRenderSettings? renderSettings,
    bool allowResize = false,
  }) {
    return getRenderableImage(
      size: size,
      format: format,
      renderSettings: renderSettings,
      allowResize: allowResize,
    )?.bytes;
  }
}

/// Class used for customizable road info images
///
/// Represents the image in an abstract way, providing metadata and access to the [RenderableImg].
///
/// {@category Maps & 3D Scene}
class RoadInfoImg extends ImgBase {
  @internal
  RoadInfoImg.init(super.id) : super.init();

  /// Get the image data as a [RenderableImg].
  /// A [RenderableImg] contains the [Uint8List] and its width and height.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The image size as (width, height). By default the [SdkSettings.getDefaultWidthHeightImageFormat].size is used
  /// * **IN** *format* The image format. By default it is PNG.
  /// * **IN** *backgroundColor* The background color to be used.
  /// * **IN** *allowResize* If false then the given [size] will be used to render the image. If true then the SDK might choose a suitable size based on the height of the [size]. By default it is false.
  ///
  /// **Returns**
  ///
  /// * The image as a [RenderableImg] if the image [isValid], null otherwise.
  @override
  RenderableImg? getRenderableImage({
    Size? size,
    ImageFileFormat format = ImageFileFormat.png,
    Color backgroundColor = Colors.transparent,
    bool allowResize = false,
  }) {
    final Rgba bgColor = backgroundColor.toRgba();

    return GemKitPlatform.instance.callGetFlutterImg(
      _pointerId,
      size != null ? size.width.toInt() : -1,
      size != null ? size.height.toInt() : -1,
      format.id,
      arg: jsonEncode(bgColor),
      allowResize: allowResize,
    );
  }

  /// Get the image data as a [Uint8List].
  /// Display the image on UI using the [Image.memory] constructor.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The image size as (width, height). By default the [SdkSettings.getDefaultWidthHeightImageFormat].size is used
  /// * **IN** *format* The image format. By default it is PNG.
  /// * **IN** *backgroundColor* The background color to be used.
  /// * **IN** *allowResize* If false then the given [size] will be used to render the image. If true then the SDK might choose a suitable size based on the height of the [size]. By default it is false.
  ///
  /// **Returns**
  ///
  /// * The image as a [RenderableImg] if the image [isValid], null otherwise.
  @override
  Uint8List? getRenderableImageBytes({
    Size? size,
    ImageFileFormat format = ImageFileFormat.png,
    Color backgroundColor = Colors.transparent,
    bool allowResize = false,
  }) {
    return getRenderableImage(
      size: size,
      format: format,
      backgroundColor: backgroundColor,
      allowResize: allowResize,
    )?.bytes;
  }
}

/// Renderable image
///
/// Contains the image [bytes] in the form of a [Uint8List] and metadata such as [width] and [height].
///
/// {@category Maps & 3D Scene}
class RenderableImg {
  /// Constructor for [RenderableImg] class
  RenderableImg(this.width, this.height, this.bytes);

  /// Image width
  final int width;

  /// Image height
  final int height;

  /// Image data
  ///
  /// Can be used with the [Image.memory] constructor to display the image
  final Uint8List bytes;
}
