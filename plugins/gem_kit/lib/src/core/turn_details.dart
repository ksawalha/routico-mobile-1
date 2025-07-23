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
import 'dart:typed_data';
import 'dart:ui';

import 'package:gem_kit/src/core/images.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Turn details class
///
/// This class should not be instantiated directly. Instead, use the related methods from [RouteInstruction] or [NavigationInstruction] to obtain an instance.
///
/// {@category Routes & Navigation}
class TurnDetails {
  // ignore: unused_element
  TurnDetails._() : _pointerId = -1;

  @internal
  TurnDetails.init(final int id) : _pointerId = id;
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Get the abstract geometry.
  ///
  /// **Returns**
  ///
  /// * The abstract geometry
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  AbstractGeometry get abstractGeometry {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TurnDetails',
      'getAbstractGeometry',
    );

    return AbstractGeometry.fromJson(resultString['result']);
  }

  /// Get the image for the abstract geometry.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* [Size] of the image
  /// * **IN** *format* [ImageFileFormat] of the image.
  /// * **IN** *renderSettings* [AbstractGeometryImageRenderSettings] object, representing the settings of the image.
  ///
  /// **Returns**
  ///
  /// * The image for the lane abstract geometry is available, otherwise null
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Uint8List? getAbstractGeometryImage({
    final Size? size,
    final ImageFileFormat? format,
    final AbstractGeometryImageRenderSettings renderSettings =
        const AbstractGeometryImageRenderSettings(),
  }) {
    return GemKitPlatform.instance.callGetImage(
      pointerId,
      'TurnDetailsGetAbstractGeometryImage',
      size?.width.toInt() ?? -1,
      size?.height.toInt() ?? -1,
      format?.id ?? -1,
      arg: jsonEncode(renderSettings),
    );
  }

  /// Get the image of the abstract geometry image
  ///
  /// **Parameters**
  ///
  /// **Returns**
  ///
  /// * The image for the abstract geometry image. The user is responsible to check if the image is valid.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  AbstractGeometryImg get abstractGeometryImg {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TurnDetails',
      'getAbstractGeometryImg',
    );

    return AbstractGeometryImg.init(resultString['result']);
  }

  /// Get the UID of the image for the abstract geometry.
  ///
  /// **Returns**
  ///
  /// * The UID of the image
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get abstractGeometryImageUid {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TurnDetails',
      'getAbstractGeometryImageUid',
    );

    return resultString['result'];
  }

  /// Get event.
  ///
  /// Result is in [TurnEvent] range.
  ///
  /// **Returns**
  ///
  /// * The turn event
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  TurnEvent get event {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TurnDetails',
      'getEvent',
    );

    return TurnEventExtension.fromId(resultString['result']);
  }

  /// Get the roundabout exit number
  ///
  /// **Returns**
  ///
  /// * A positive integer when a roundabout exit number is available.
  /// * -1 when no roundabout exit number.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get roundaboutExitNumber {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TurnDetails',
      'getRoundaboutExitNumber',
    );

    return resultString['result'];
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, Object>{'class': 'TurnDetails', 'id': _pointerId}),
      );
}

/// AbstractGeometryItem object.
/// @nodoc
///
/// {@category Routes & Navigation}
class AbstractGeometryItem {
  AbstractGeometryItem({
    this.arrowType = ArrowType.none,
    this.beginArrowDirection = ArrowDirection.none,
    this.beginSlot = -1,
    this.endArrowDirection = ArrowDirection.none,
    this.endSlot = -1,
    this.restrictionType = RestrictionType.none,
    this.shapeForm = ShapeForm.line,
    this.shapeType = ShapeType.street,
    this.slotAllocation = 0,
  });

  factory AbstractGeometryItem.fromJson(final Map<String, dynamic> json) {
    return AbstractGeometryItem(
      arrowType: ArrowTypeExtension.fromId(json['arrowtype']),
      beginArrowDirection: ArrowDirectionExtension.fromId(
        json['beginarrowdirection'],
      ),
      beginSlot: json['beginslot'],
      endArrowDirection: ArrowDirectionExtension.fromId(
        json['endarrowdirection'],
      ),
      endSlot: json['endslot'],
      restrictionType: RestrictionTypeExtension.fromId(json['restrictiontype']),
      shapeForm: ShapeFormExtension.fromId(json['shapeform']),
      shapeType: ShapeTypeExtension.fromId(json['shapetype']),
      slotAllocation: json['slotallocation'],
    );
  }
  // Arrow type
  ArrowType arrowType;

  /// Arrow direction at the begin.
  ArrowDirection beginArrowDirection;

  /// Get the slot the shape begin is attached to the anchor.
  /// The begin slot references the position where the begin shape is attached to the anchor.
  ///
  /// 12 slots are possible, -1 indicates N/A. The numbers indicate position similar to a clock face.
  /// [ShapeForm.circleSegment] follows the circle from begin to end slot, [ShapeForm.line] spans over the
  /// circle from begin to end slot
  int beginSlot;

  /// Arrow direction at the end.
  ArrowDirection endArrowDirection;

  /// Get the slot the shape end is attached to the anchor.
  /// The begin slot references the position where the end shape is attached to the anchor.
  ///
  /// 12 slots are possible, -1 indicates N/A. The numbers indicate position similar to a clock face.
  /// [ShapeForm.circleSegment] follows the circle from begin to end slot, [ShapeForm.line] spans over the
  /// circle from begin to end slot
  int endSlot;

  /// Restriction type.
  RestrictionType restrictionType;

  /// Shape form.
  ShapeForm shapeForm;

  /// Shape type.
  ShapeType shapeType;

  /// Slot allocation.
  /// The slot allocation indicates how many shapes are occupying a slot. The rendering should reflect this by different dividers.
  int slotAllocation;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['arrowtype'] = arrowType.id;
    json['beginarrowdirection'] = beginArrowDirection.id;
    json['beginslot'] = beginSlot;
    json['endarrowdirection'] = endArrowDirection.id;
    json['endslot'] = endSlot;
    json['restrictiontype'] = restrictionType.id;
    json['shapeform'] = shapeForm.id;
    json['shapetype'] = shapeType.id;
    json['slotallocation'] = slotAllocation;
    return json;
  }

  @override
  bool operator ==(covariant final AbstractGeometryItem other) {
    if (identical(this, other)) {
      return true;
    }
    return arrowType == other.arrowType &&
        beginArrowDirection == other.beginArrowDirection &&
        beginSlot == other.beginSlot &&
        endArrowDirection == other.endArrowDirection &&
        endSlot == other.endSlot &&
        restrictionType == other.restrictionType &&
        shapeForm == other.shapeForm &&
        shapeType == other.shapeType &&
        slotAllocation == other.slotAllocation;
  }

  @override
  int get hashCode {
    return arrowType.hashCode ^
        beginArrowDirection.hashCode ^
        beginSlot.hashCode ^
        endArrowDirection.hashCode ^
        endSlot.hashCode ^
        restrictionType.hashCode ^
        shapeForm.hashCode ^
        slotAllocation.hashCode;
  }
}

/// AbstractGeometry object.
///
/// {@category Routes & Navigation}
class AbstractGeometry {
  AbstractGeometry({
    this.anchorType = AnchorType.point,
    this.driveSide = DriveSide.right,
    this.items = const <AbstractGeometryItem>[],
    this.leftIntermediateTurns = 0,
    this.rightIntermediateTurns = 0,
  });

  factory AbstractGeometry.fromJson(final Map<String, dynamic> json) {
    return AbstractGeometry(
      anchorType: AnchorTypeExtension.fromId(json['anchortype']),
      driveSide: DriveSideExtension.fromId(json['driveside']),
      items: (json['items'] as List<dynamic>)
          .map(
            (final dynamic item) =>
                AbstractGeometryItem.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      leftIntermediateTurns: json['leftintermediateturns'],
      rightIntermediateTurns: json['rightintermediateturns'],
    );
  }
  // Anchor type
  AnchorType anchorType;

  /// Drive side
  DriveSide driveSide;

  /// List of geometry items
  List<AbstractGeometryItem> items;

  // Get the number of left side intermediate turns.
  int leftIntermediateTurns;

  // Get the number of right side intermediate turns.
  int rightIntermediateTurns;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['anchortype'] = anchorType.id;
    json['driveside'] = driveSide.id;
    json['items'] = items;
    json['leftintermediateturns'] = leftIntermediateTurns;
    json['rightintermediateturns'] = rightIntermediateTurns;
    return json;
  }
}

/// Navigation turn events
///
/// {@category Routes & Navigation}
enum TurnEvent {
  /// Turn type not available
  na,

  /// Continue straight ahead
  straight,

  /// Turn right
  right,

  /// Turn right
  right1,

  /// Turn right
  right2,

  /// Turn left
  left,

  /// Turn left
  left1,

  /// Turn left
  left2,

  ///Turn half left
  lightLeft,

  /// Turn half left
  lightLeft1,

  ///Turn half left
  lightLeft2,

  ///Turn half right
  lightRight,

  ///Turn half right
  lightRight1,

  ///Turn half right
  lightRight2,

  /// Turn sharp right
  sharpRight,

  /// Turn sharp right
  sharpRight1,

  /// Turn sharp right
  sharpRight2,

  /// Turn sharp left
  sharpLeft,

  /// Turn sharp left
  sharpLeft1,

  /// Turn sharp left
  sharpLeft2,

  /// Leave the roundabout to the right
  roundaboutExitRight,

  /// Continue on the roundabout
  roundabout,

  /// Make a U-turn
  roundRight,

  /// Make a U-turn
  roundLeft,

  /// Take the exit
  exitRight,

  /// Take the exit
  exitRight1,

  /// Take the exit
  exitRight2,

  /// Generic info
  infoGeneric,

  /// Drive on
  driveOn,

  /// Take exit number
  exitNr,

  /// Take the exit
  exitLeft,

  /// Take the exit
  exitLeft1,

  /// Take the exit
  exitLeft2,

  /// Leave the roundabout to the left
  roundaboutExitLeft,

  /// Leave the roundabout at the ... exit
  intoRoundabout,

  /// Continue straight ahead
  stayOn,

  /// Take the ferry
  boatFerry,

  /// Take the car transport by train
  railFerry,

  /// Lane info
  infoLane,

  /// Info sign
  infoSign,

  /// Left and then turn right
  leftRight,

  /// Right and then turn left
  rightLeft,

  /// Bear left
  keepLeft,

  /// Bear right
  keepRight,

  /// Start waypoint
  start,

  /// Intermediate waypoint
  intermediate,

  /// Stop waypoint
  stop,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension TurnEventExtension on TurnEvent {
  int get id {
    switch (this) {
      case TurnEvent.na:
        return 0;
      case TurnEvent.straight:
        return 1;
      case TurnEvent.right:
        return 2;
      case TurnEvent.right1:
        return 3;
      case TurnEvent.right2:
        return 4;
      case TurnEvent.left:
        return 5;
      case TurnEvent.left1:
        return 6;
      case TurnEvent.left2:
        return 7;
      case TurnEvent.lightLeft:
        return 8;
      case TurnEvent.lightLeft1:
        return 9;
      case TurnEvent.lightLeft2:
        return 10;
      case TurnEvent.lightRight:
        return 11;
      case TurnEvent.lightRight1:
        return 12;
      case TurnEvent.lightRight2:
        return 13;
      case TurnEvent.sharpRight:
        return 14;
      case TurnEvent.sharpRight1:
        return 15;
      case TurnEvent.sharpRight2:
        return 16;
      case TurnEvent.sharpLeft:
        return 17;
      case TurnEvent.sharpLeft1:
        return 18;
      case TurnEvent.sharpLeft2:
        return 19;
      case TurnEvent.roundaboutExitRight:
        return 20;
      case TurnEvent.roundabout:
        return 21;
      case TurnEvent.roundRight:
        return 22;
      case TurnEvent.roundLeft:
        return 23;
      case TurnEvent.exitRight:
        return 24;
      case TurnEvent.exitRight1:
        return 25;
      case TurnEvent.exitRight2:
        return 26;
      case TurnEvent.infoGeneric:
        return 27;
      case TurnEvent.driveOn:
        return 28;
      case TurnEvent.exitNr:
        return 29;
      case TurnEvent.exitLeft:
        return 30;
      case TurnEvent.exitLeft1:
        return 31;
      case TurnEvent.exitLeft2:
        return 32;
      case TurnEvent.roundaboutExitLeft:
        return 33;
      case TurnEvent.intoRoundabout:
        return 34;
      case TurnEvent.stayOn:
        return 35;
      case TurnEvent.boatFerry:
        return 36;
      case TurnEvent.railFerry:
        return 37;
      case TurnEvent.infoLane:
        return 38;
      case TurnEvent.infoSign:
        return 39;
      case TurnEvent.leftRight:
        return 40;
      case TurnEvent.rightLeft:
        return 41;
      case TurnEvent.keepLeft:
        return 42;
      case TurnEvent.keepRight:
        return 43;
      case TurnEvent.start:
        return 44;
      case TurnEvent.intermediate:
        return 45;
      case TurnEvent.stop:
        return 46;
    }
  }

  static TurnEvent fromId(final int id) {
    switch (id) {
      case 0:
        return TurnEvent.na;
      case 1:
        return TurnEvent.straight;
      case 2:
        return TurnEvent.right;
      case 3:
        return TurnEvent.right1;
      case 4:
        return TurnEvent.right2;
      case 5:
        return TurnEvent.left;
      case 6:
        return TurnEvent.left1;
      case 7:
        return TurnEvent.left2;
      case 8:
        return TurnEvent.lightLeft;
      case 9:
        return TurnEvent.lightLeft1;
      case 10:
        return TurnEvent.lightLeft2;
      case 11:
        return TurnEvent.lightRight;
      case 12:
        return TurnEvent.lightRight1;
      case 13:
        return TurnEvent.lightRight2;
      case 14:
        return TurnEvent.sharpRight;
      case 15:
        return TurnEvent.sharpRight1;
      case 16:
        return TurnEvent.sharpRight2;
      case 17:
        return TurnEvent.sharpLeft;
      case 18:
        return TurnEvent.sharpLeft1;
      case 19:
        return TurnEvent.sharpLeft2;
      case 20:
        return TurnEvent.roundaboutExitRight;
      case 21:
        return TurnEvent.roundabout;
      case 22:
        return TurnEvent.roundRight;
      case 23:
        return TurnEvent.roundLeft;
      case 24:
        return TurnEvent.exitRight;
      case 25:
        return TurnEvent.exitRight1;
      case 26:
        return TurnEvent.exitRight2;
      case 27:
        return TurnEvent.infoGeneric;
      case 28:
        return TurnEvent.driveOn;
      case 29:
        return TurnEvent.exitNr;
      case 30:
        return TurnEvent.exitLeft;
      case 31:
        return TurnEvent.exitLeft1;
      case 32:
        return TurnEvent.exitLeft2;
      case 33:
        return TurnEvent.roundaboutExitLeft;
      case 34:
        return TurnEvent.intoRoundabout;
      case 35:
        return TurnEvent.stayOn;
      case 36:
        return TurnEvent.boatFerry;
      case 37:
        return TurnEvent.railFerry;
      case 38:
        return TurnEvent.infoLane;
      case 39:
        return TurnEvent.infoSign;
      case 40:
        return TurnEvent.leftRight;
      case 41:
        return TurnEvent.rightLeft;
      case 42:
        return TurnEvent.keepLeft;
      case 43:
        return TurnEvent.keepRight;
      case 44:
        return TurnEvent.start;
      case 45:
        return TurnEvent.intermediate;
      case 46:
        return TurnEvent.stop;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// The type of the shape.
/// Use the type to render the shape in different width and color.
///
/// {@category Routes & Navigation}
enum ShapeForm {
  /// Line is a simple line with width defined by [ShapeType],
  line,

  /// CircleSegment (clock wise or counter clock wise depending on drive side) is a part of a [AnchorType.circle]
  circleSegment,

  /// Point is a maker (e.g. Waypoint place) outside the anchor and not connected by a line. Get the index of the next route instruction on the current route segment.
  point,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension ShapeFormExtension on ShapeForm {
  int get id {
    switch (this) {
      case ShapeForm.line:
        return 0;
      case ShapeForm.circleSegment:
        return 1;
      case ShapeForm.point:
        return 2;
    }
  }

  static ShapeForm fromId(final int id) {
    switch (id) {
      case 0:
        return ShapeForm.line;
      case 1:
        return ShapeForm.circleSegment;
      case 2:
        return ShapeForm.point;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// The type of the shape.
/// Use the type to render the shape in different width and color.
/// [ShapeType.route] should be rendered over [ShapeType.street]
///
/// {@category Routes & Navigation}
enum ShapeType {
  /// Route
  route,

  /// Street
  street,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension ShapeTypeExtension on ShapeType {
  int get id {
    switch (this) {
      case ShapeType.route:
        return 0;
      case ShapeType.street:
        return 1;
    }
  }

  static ShapeType fromId(final int id) {
    switch (id) {
      case 0:
        return ShapeType.route;
      case 1:
        return ShapeType.street;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// The arrow type of the shape.
///
/// The arrow is either attached to the anchor side [begin], or the opposite side [end].
///
/// {@category Routes & Navigation}
enum ArrowType {
  /// None
  none,

  /// Begin
  begin,

  /// End
  end,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension ArrowTypeExtension on ArrowType {
  int get id {
    switch (this) {
      case ArrowType.none:
        return 0;
      case ArrowType.begin:
        return 1;
      case ArrowType.end:
        return 2;
    }
  }

  static ArrowType fromId(final int id) {
    switch (id) {
      case 0:
        return ArrowType.none;
      case 1:
        return ArrowType.begin;
      case 2:
        return ArrowType.end;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// The restriction type of the shape.
///
/// The restriction type can be used to visualize the restriction for the connected street.
///
/// {@category Routes & Navigation}
enum RestrictionType {
  /// No restriction
  none,

  /// Direction restriction
  direction,

  /// Maneuver restriction
  manoeuvre,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension RestrictionTypeExtension on RestrictionType {
  int get id {
    switch (this) {
      case RestrictionType.none:
        return 0;
      case RestrictionType.direction:
        return 1;
      case RestrictionType.manoeuvre:
        return 2;
    }
  }

  static RestrictionType fromId(final int id) {
    switch (id) {
      case 0:
        return RestrictionType.none;
      case 1:
        return RestrictionType.direction;
      case 2:
        return RestrictionType.manoeuvre;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// The arrow direction of the shape.
///
/// The arrow direction will be only valid for [ShapeForm.circleSegment] and some combined turns
///
/// {@category Routes & Navigation}
enum ArrowDirection {
  /// None
  none,

  /// Left
  left,

  /// Straight
  straight,

  /// Right
  right,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension ArrowDirectionExtension on ArrowDirection {
  int get id {
    switch (this) {
      case ArrowDirection.none:
        return 0;
      case ArrowDirection.left:
        return 1;
      case ArrowDirection.straight:
        return 2;
      case ArrowDirection.right:
        return 3;
    }
  }

  static ArrowDirection fromId(final int id) {
    switch (id) {
      case 0:
        return ArrowDirection.none;
      case 1:
        return ArrowDirection.left;
      case 2:
        return ArrowDirection.straight;
      case 3:
        return ArrowDirection.right;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// The anchor type.
///
/// The anchor is a point (all intersections), a circle (roundabout, complex traffic figure) or a waypoint.
///
/// {@category Routes & Navigation}
enum AnchorType {
  /// Point
  point,

  /// Circle
  circle,

  /// Waypoint
  waypoint,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension AnchorTypeExtension on AnchorType {
  int get id {
    switch (this) {
      case AnchorType.point:
        return 0;
      case AnchorType.circle:
        return 1;
      case AnchorType.waypoint:
        return 2;
    }
  }

  static AnchorType fromId(final int id) {
    switch (id) {
      case 0:
        return AnchorType.point;
      case 1:
        return AnchorType.circle;
      case 2:
        return AnchorType.waypoint;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// The drive side of the abstract geometry.
///
/// The drive side allows to render the correct U-Turn shape.
///
/// {@category Routes & Navigation}
enum DriveSide {
  /// Left
  left,

  /// Right
  right,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension DriveSideExtension on DriveSide {
  int get id {
    switch (this) {
      case DriveSide.left:
        return 0;
      case DriveSide.right:
        return 1;
    }
  }

  static DriveSide fromId(final int id) {
    switch (id) {
      case 0:
        return DriveSide.left;
      case 1:
        return DriveSide.right;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}
