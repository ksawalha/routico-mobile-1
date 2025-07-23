// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

/// Image handler class
///
/// {@category Core}
abstract class ImageHandler {
  /// Decodes image data represented as a [Uint8List] into a [ui.Image] asynchronously.
  ///
  /// **Parameters**
  ///
  /// * **IN** *data* A [Uint8List] representing the raw image data to be decoded.
  /// * **IN** *width* Optional parameter specifying the desired width of the resulting image. Default value is 100.
  /// * **IN** *height* Optional parameter specifying the desired height of the resulting image. Default value is 100.
  ///
  /// **Returns**
  ///
  /// * A [Future] that completes with the decoded [ui.Image] object, or `null` if decoding fails.
  ///
  /// The decoding process is asynchronous, so the returned [Future] will complete when the image decoding is finished.
  static Future<ui.Image?> decodeImageData(
    final Uint8List data, {
    final int width = 100,
    final int height = 100,
  }) async {
    final Completer<ui.Image?> completer = Completer<ui.Image?>();

    ui.decodeImageFromPixels(data, width, height, ui.PixelFormat.rgba8888, (
      final ui.Image img,
    ) async {
      completer.complete(img);
    });

    return completer.future;
  }
}
