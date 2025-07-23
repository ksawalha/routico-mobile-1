// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

/// Current position road modifiers.
///
/// {@category Sensor Data Source}
enum RoadModifier {
  /// None
  none,

  /// Tunnel
  tunnel,

  /// Bridge
  bridge,

  /// Ramp
  ramp,

  /// Tollway
  tollway,

  /// Roundabout
  roundabout,

  /// One way
  oneWay,

  /// No U turn
  noUTurn,

  /// Left drive side
  leftDriveSide,

  /// Motorway
  motorway,

  /// Motorway link
  motorwayLink,
}

/// @nodoc
extension RoadModifierExtension on RoadModifier {
  int get id {
    switch (this) {
      case RoadModifier.none:
        return 0;
      case RoadModifier.tunnel:
        return 1;
      case RoadModifier.bridge:
        return 2;
      case RoadModifier.ramp:
        return 4;
      case RoadModifier.tollway:
        return 8;
      case RoadModifier.roundabout:
        return 16;
      case RoadModifier.oneWay:
        return 32;
      case RoadModifier.noUTurn:
        return 64;
      case RoadModifier.leftDriveSide:
        return 128;
      case RoadModifier.motorway:
        return 256;
      case RoadModifier.motorwayLink:
        return 512;
    }
  }

  static RoadModifier fromId(final int id) {
    switch (id) {
      case 0:
        return RoadModifier.none;
      case 1:
        return RoadModifier.tunnel;
      case 2:
        return RoadModifier.bridge;
      case 4:
        return RoadModifier.ramp;
      case 8:
        return RoadModifier.tollway;
      case 16:
        return RoadModifier.roundabout;
      case 32:
        return RoadModifier.oneWay;
      case 64:
        return RoadModifier.noUTurn;
      case 128:
        return RoadModifier.leftDriveSide;
      case 256:
        return RoadModifier.motorway;
      case 512:
        return RoadModifier.motorwayLink;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}
