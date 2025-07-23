// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'dart:typed_data';

import 'package:gem_kit/map.dart';

/// @nodoc
Uint8List serializeListOfMarkers(final List<MarkerWithRenderSettings> markers) {
  int totalLength = 4; // Initial 4 bytes for the length of the list

  // Calculate the total length of the binary data
  for (final MarkerWithRenderSettings marker in markers) {
    totalLength += marker.toBinary().length;
  }

  final ByteData buffer = ByteData(totalLength);
  int offset = 0;

  // Write the length of the list
  buffer.setInt32(offset, markers.length, Endian.little);
  offset += 4;

  // Serialize each MarkerWithRenderSettings and append to the buffer
  for (final MarkerWithRenderSettings marker in markers) {
    final Uint8List markerData = marker.toBinary();
    buffer.buffer.asUint8List().setRange(
          offset,
          offset + markerData.length,
          markerData,
        );
    offset += markerData.length;
  }

  return buffer.buffer.asUint8List();
}

/// @nodoc
class MarkerInfoSpecialAccess {
  // Static method to access the imagePointer of a MarkerJson instance
  static dynamic getImagePointer(final MarkerRenderSettings markerJson) {
    return markerJson.imagePointer;
  }

  // Static method to access the imagePointerSize of a MarkerJson instance
  static dynamic getImagePointerSize(final MarkerRenderSettings markerJson) {
    return markerJson.imagePointerSize;
  }

  static void updateImagePointerValueRenderSettings(
    final MarkerRenderSettings settings,
    final dynamic value,
  ) {
    settings.imagePointer = value;
  }

  static void updateImagePointerSizeRenderSettings(
    final MarkerRenderSettings settings,
    final dynamic value,
  ) {
    settings.imagePointerSize = value;
  }
}
