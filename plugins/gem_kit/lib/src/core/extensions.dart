// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'dart:ui';

import 'package:gem_kit/src/core/types.dart';

/// Extension methods for [Color]
///
/// {@category Core}
extension ColorExtension on Color {
  /// Convert [Color] to [Map]. Used for serialization with GemKit
  Map<String, dynamic> toJson() => <String, double>{
        'r': r,
        'g': g,
        'b': b,
        'a': a,
      };

  /// Convert [Color] to GemKit [Rgba] class
  Rgba toRgba() => Rgba(
        r: (r * 255).toInt(),
        g: (g * 255).toInt(),
        b: (b * 255).toInt(),
        a: (a * 255).toInt(),
      );

  /// Convert GemKit [Rgba] class to [Color]. Used for deserialization with GemKit
  static Color fromJson(final Map<String, dynamic> json) =>
      Color.fromARGB(json['a'], json['r'], json['g'], json['b']);

  /// Convert [Map] to [Color]. Used for deserialization with GemKit
  static Color tryFromJson(final Map<String, dynamic>? json) {
    if (json == null) {
      return const Color(0x00000000);
    }
    try {
      return fromJson(json);
    } catch (e) {
      return const Color(0x00000000);
    }
  }
}
