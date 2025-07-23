// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

/// Exception thrown when GemKit is not initialized
///
/// Use [GemKit.initialize] to initialize the GemKit before calling SDK methods
///
/// {@category Core}
class GemKitUninitializedException implements Exception {
  static const String message =
      "Native SDK not initialized! Please add the call 'await GemKit.initialize() ' in the main function, before calling 'runApp'";

  @override
  String toString() => message;
}

/// Exception thrown when an object is not alive
///
/// Used for debugging purposes
///
/// {@category Core}
class ObjectNotAliveException implements Exception {
  ObjectNotAliveException({required this.id, required this.json});
  final dynamic id;
  final String json;

  @override
  String toString() => 'Object with id $id is not alive. Json: $json';
}
