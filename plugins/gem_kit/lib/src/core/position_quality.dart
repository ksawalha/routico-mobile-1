// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

/// Values that represent position data quality.
///
/// {@category Sensor Data Source}
enum PositionQuality {
  /// Position can not or should not be processed(for instance, invalid coordinates)
  invalid,

  /// Position resulted from inertial extrapolation; there is a GPS outage (e.g. tunnel)
  inertial,

  /// Position is valid but cannot be trusted because of bad GPS accuracy (e.g. urban canyon)
  low,

  /// Position is valid and can be trusted (is recent and has a good accuracy)
  high,
}

/// @nodoc
///
/// {@category Sensor Data Source}
extension PositionQualityExtension on PositionQuality {
  int get id {
    switch (this) {
      case PositionQuality.invalid:
        return 0;
      case PositionQuality.inertial:
        return 1;
      case PositionQuality.low:
        return 2;
      case PositionQuality.high:
        return 3;
    }
  }

  static PositionQuality fromId(final int id) {
    switch (id) {
      case 0:
        return PositionQuality.invalid;
      case 1:
        return PositionQuality.inertial;
      case 2:
        return PositionQuality.low;
      case 3:
        return PositionQuality.high;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}
