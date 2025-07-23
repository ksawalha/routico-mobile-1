// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/position/gem_position.dart';

/// Position listener interface.
///
/// {@category Sensor Data Source}
abstract class IGemPositionListener extends EventHandler {
  int id = 0;

  ///	Notification sent when a new position is available.
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* [GemPosition] object
  void onNewPosition(final GemPosition pos);

  ///	Notification sent when a new improved position is available.
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* [GemImprovedPosition] object
  void onNewImprovedPosition(final GemImprovedPosition pos);
}
