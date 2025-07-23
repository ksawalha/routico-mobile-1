// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Map view extensions class
///
/// {@category Maps & 3D Scene}
class MapViewExtensions {
  MapViewExtensions()
      : _pointerId = -1,
        _mapId = -1;

  @internal
  MapViewExtensions.init(final int id, final int mapId)
      : _pointerId = id,
        _mapId = mapId;
  final dynamic _pointerId;
  final dynamic _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  /// Get group highlighted item index for the given highlighted item index (in original list)
  ///
  /// **Parameters**
  ///
  /// * **IN** *idx*	The highlighted item index in original list for which the group head is searched.
  /// * **IN** *highlightId*	The highlight collection id (optional).
  ///
  /// **Returns**
  ///
  /// * On success, returns the group index in highlighted items original list.
  /// * On error, returns the error code.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int getHighlightGroupItemIndex(final int idx, {final int highlightId = 0}) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewExtensions',
      'getHighlightGroupItemIndex',
      args: <String, int>{'idx': idx, 'highlightId': highlightId},
    );

    return resultString['result'];
  }

  /// Get the maximum allowed zoom level.
  ///
  /// **Returns**
  ///
  /// * The maximum allowed zoom level
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get maximumAllowedZoomLevel {
    throw UnimplementedError(
      'Unimplemented method: get maximumAllowedZoomLevel',
    );
    // try {
    //   final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
    //     'id': _pointerId,
    //     'MapViewExtensions',
    //     'getMaximumAllowedZoomLevel',
    //     'args': {}
    //   }));
    //
    //   return resultString['result'];
    // } catch (e) {
    //   rethrow;
    // }
  }

  /// Get the minimum allowed zoom level.
  ///
  /// **Returns**
  ///
  /// * The minimum allowed zoom level
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get minimumAllowedZoomLevel {
    throw UnimplementedError(
      'Unimplemented method: get minimumAllowedZoomLevel',
    );
    // try {
    //   final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
    //     'id': _pointerId,
    //     'MapViewExtensions',
    //     'getMinimumAllowedZoomLevel',
    //     'args': {}
    //   }));
    //
    //   return resultString['result'];
    // } catch (e) {
    //   rethrow;
    // }
  }

  /// Set the maximum allowed zoom level.
  ///
  /// **Parameters**
  ///
  /// * **IN** *zoomLevel*	The maximum allowed zoom level
  ///
  /// **Throws**
  ///
  /// * An exception if it fails. For the moment always throws an UnimplementedError.
  set maximumAllowedZoomLevel(final int zoomLevel) {
    throw UnimplementedError(
      'Unimplemented method: set maximumAllowedZoomLevel',
    );
    // try {
    //   final result = GemKitPlatform.instance.callObjectMethod(jsonEncode({
    //     'id': _pointerId,
    //     'MapViewExtensions',
    //     'setMaximumAllowedZoomLevel',
    //     'args': zoomLevel
    //   }));

    //   final error = GemErrorExtension.fromCode(result['gemApiError'] as int);
    //   if(error != GemError.success) {
    //     throw error;
    //   }
    // } catch (e) {
    //   rethrow;
    // }
  }

  /// Set the minimum allowed zoom level.
  ///
  /// **Parameters**
  ///
  /// * **IN** *zoomLevel*	The minimum allowed zoom level
  ///
  /// **Throws**
  ///
  /// * An exception if it fails. For the moment always throws an UnimplementedError.
  set minimumAllowedZoomLevel(final int zoomLevel) {
    throw UnimplementedError(
      'Unimplemented method: set minimumAllowedZoomLevel',
    );
    // try {
    //   final result = GemKitPlatform.instance.callObjectMethod(jsonEncode({
    //     'id': _pointerId,
    //     'MapViewExtensions',
    //     'setMinimumAllowedZoomLevel',
    //     'args': zoomLevel
    //   }));

    //   final error = GemErrorExtension.fromCode(result['gemApiError'] as int);
    //   if(error != GemError.success) {
    //     throw error;
    //   }
    // } catch (e) {
    //   rethrow;
    // }
  }

  /// Enable optimizations for low end CPU.
  ///
  /// **Parameters**
  ///
  /// * **IN** *bEnable*	True to enable optimizations, false to disable
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set lowEndCPUOptimizations(final bool bEnable) {
    objectMethod(
      _pointerId,
      'MapViewExtensions',
      'setLowEndCPUOptimizations',
      args: bEnable,
    );
  }

  /// Get low end CPU optimizations flag.
  ///
  /// **Returns**
  ///
  /// * True if optimizations are enabled, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get lowEndCPUOptimizations {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewExtensions',
      'getLowEndCPUOptimizations',
    );

    return resultString['result'];
  }

  /// Gets navigation route low rate update flag
  ///
  /// **Returns**
  ///
  /// * True if navigation route low rate update is enabled, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool get navigationRouteLowRateUpdate {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'MapViewExtensions',
      'getNavigationRouteLowRateUpdate',
    );

    return resultString['result'];
  }

  /// Sets navigation route low rate update flag
  ///
  /// **Parameters**
  ///
  /// * **IN** *bEnable* True to enable navigation route low rate update, false to disable
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  set navigationRouteLowRateUpdate(final bool bEnable) {
    objectMethod(
      _pointerId,
      'MapViewExtensions',
      'setNavigationRouteLowRateUpdate',
      args: bEnable,
    );
  }
}
