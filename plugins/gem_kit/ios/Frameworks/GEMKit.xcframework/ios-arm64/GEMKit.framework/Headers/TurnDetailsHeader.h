// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all 
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V. 
// or its affiliates is strictly prohibited.

#ifndef TurnDetailsHeader_h
#define TurnDetailsHeader_h

/**
 * Constants indicating the turn information type.
 */
typedef NS_ENUM(NSInteger, TurnType)
{
    /// Turn type not available
    TurnTypeNA,
    
    /// Continue straight ahead
    TurnTypeStraight,
    
    /// Turn right
    TurnTypeRight,
    
    /// Turn right
    TurnTypeRight1,
    
    /// Turn right
    TurnTypeRight2,
    
    /// Turn left
    TurnTypeLeft,
    
    /// Turn left
    TurnTypeLeft1,
    
    /// Turn left
    TurnTypeLeft2,
    
    /// Turn half left
    TurnTypeLightLeft,
    
    /// Turn half left 2ndRoad
    TurnTypeLightLeft1,
    
    /// Turn half left 3rdRoad
    TurnTypeLightLeft2,
    
    /// Turn half right
    TurnTypeLightRight,
    
    /// Turn half right 2ndRoad
    TurnTypeLightRight1,
    
    /// Turn half right 3rdRoad
    TurnTypeLightRight2,
    
    /// Turn sharp right
    TurnTypeSharpRight,
    
    /// Turn sharp right
    TurnTypeSharpRight1,
    
    /// Turn sharp right
    TurnTypeSharpRight2,
    
    /// Turn sharp left
    TurnTypeSharpLeft,
    
    /// Turn sharp left
    TurnTypeSharpLeft1,
    
    /// Turn sharp left
    TurnTypeSharpLeft2,
    
    /// Leave the roundabout to the right
    TurnTypeRoundaboutExitRight,
    
    /// Continue on the roundabout
    TurnTypeRoundabout,
    
    /// Make a U-Turn
    TurnTypeRoundRight,
    
    /// Make a U-Turn
    TurnTypeRoundLeft,
    
    /// Take the exit
    TurnTypeExitRight,
    
    /// Take the exit
    TurnTypeExitRight1,
    
    /// Take the exit
    TurnTypeExitRight2,
    
    /// Info Generic
    TurnTypeInfoGeneric,
    
    /// DriveOn
    TurnTypeDriveOn,
    
    /// Take exit No. ...
    TurnTypeExitNr,
    
    /// Take the exit
    TurnTypeExitLeft,
    
    /// Take the exit
    TurnTypeExitLeft1,
    
    /// Take the exit
    TurnTypeExitLeft2,
    
    /// Leave the roundabout to the left
    TurnTypeRoundaboutExitLeft,
    
    /// Leave the roundabout at the ... exit
    TurnTypeIntoRoundabout,
    
    /// Continue straight ahead
    TurnTypeStayOn,
    
    /// Take the ferry
    TurnTypeBoatFerry,
    
    /// Take the car transport by train
    TurnTypeRailFerry,
    
    /// Info Lane
    TurnTypeInfoLane,
    
    /// Info Sign
    TurnTypeInfoSign,
    
    /// Left and then turn right
    TurnTypeLeftRight,
    
    /// Right and then turn left
    TurnTypeRightLeft,
    
    /// Bear left
    TurnTypeKeepLeft,
    
    /// Bear right
    TurnTypeKeepRight,
    
    /// Start waypoint
    TurnTypeStart,
    
    /// Intermediate waypoint
    TurnTypeIntermediate,
    
    /// Stop waypoint
    TurnTypeStop
};

/**
 * Constants indicating the navigation turn simplified unique id.
 */
typedef NS_ENUM(NSInteger, TurnSimplifiedType32)
{
    /// NoRoute
    TurnSimplifiedType32NoRoute = 0,
    
    /// Straight
    TurnSimplifiedType32Straight,
    
    /// Bear left
    TurnSimplifiedType32BearLeft,
    
    /// Turn left
    TurnSimplifiedType32TurnLeft,
    
    /// Turn sharp left
    TurnSimplifiedType32TurnSharpLeft,
    
    /// U-turn left
    TurnSimplifiedType32UTurnLeft,
    
    /// Bear right
    TurnSimplifiedType32BearRight,
    
    /// Turn right
    TurnSimplifiedType32TurnRight,
    
    /// Turn sharp right
    TurnSimplifiedType32TurnSharpRight,
    
    /// U-turn right
    TurnSimplifiedType32UTurnRight,
    
    /// Roundabout CW(clock wise) 1
    TurnSimplifiedType32RoundaboutCW1,
    
    /// Roundabout CW 2
    TurnSimplifiedType32RoundaboutCW2,
    
    /// Roundabout CW 3
    TurnSimplifiedType32RoundaboutCW3,
    
    /// Roundabout CW 4
    TurnSimplifiedType32RoundaboutCW4,
    
    /// Roundabout CW 5
    TurnSimplifiedType32RoundaboutCW5,
    
    /// Roundabout CW 6
    TurnSimplifiedType32RoundaboutCW6,
    
    /// Roundabout CW 7
    TurnSimplifiedType32RoundaboutCW7,
    
    /// Roundabout CCW 1
    TurnSimplifiedType32RoundaboutCCW1,
    
    /// Roundabout CCW 2
    TurnSimplifiedType32RoundaboutCCW2,
    
    /// Roundabout CCW 3
    TurnSimplifiedType32RoundaboutCCW3,
    
    /// Roundabout CCW 4
    TurnSimplifiedType32RoundaboutCCW4,
    
    /// Roundabout CCW 5
    TurnSimplifiedType32RoundaboutCCW5,
    
    /// Roundabout CCW 6
    TurnSimplifiedType32RoundaboutCCW6,
    
    /// Roundabout CCW 7
    TurnSimplifiedType32RoundaboutCCW7,
    
    /// Roundabout back
    TurnSimplifiedType32RoundaboutBack,
    
    /// Roundabout general
    TurnSimplifiedType32RoundaboutGen,
    
    /// Roundabout leave CW
    TurnSimplifiedType32RoundaboutLeaveCW,
    
    /// Roundabout leave CCW
    TurnSimplifiedType32RoundaboutLeaveCCW,
    
    /// Waypoint
    TurnSimplifiedType32Waypoint,
    
    /// Destination
    TurnSimplifiedType32Destination,
    
    /// Boat ferry
    TurnSimplifiedType32BoatFerry,
    
    /// Train ferry
    TurnSimplifiedType32TrainFerry 
};

/**
 * Constants indicating the navigation turn simplified unique id.
 */
typedef NS_ENUM(NSInteger, TurnSimplifiedType64)
{
    /// NoRoute
    TurnSimplifiedType64NoRoute = 0,
    
    /// Straight
    TurnSimplifiedType64Straight,
    
    /// Left1
    TurnSimplifiedType64Left1,
    
    /// Left2
    TurnSimplifiedType64Left2,
    
    /// Left3
    TurnSimplifiedType64Left3,
    
    /// Left4
    TurnSimplifiedType64Left4,
    
    /// Left5
    TurnSimplifiedType64Left5,
    
    /// Right1
    TurnSimplifiedType64Right1,
    
    /// Right2
    TurnSimplifiedType64Right2,
    
    /// Right3
    TurnSimplifiedType64Right3,
    
    /// Right4
    TurnSimplifiedType64Right4,
    
    /// Right5
    TurnSimplifiedType64Right5,
    
    /// UTurnLeft
    TurnSimplifiedType64UTurnLeft,
    
    /// UTurnRight
    TurnSimplifiedType64UTurnRight,
    
    /// Left1WithFork
    TurnSimplifiedType64Left1WithFork,
    
    /// Right1WithFork
    TurnSimplifiedType64Right1WithFork,
    
    /// StraightCrossingL
    TurnSimplifiedType64StraightCrossingL,
    
    /// StraightCrossingR
    TurnSimplifiedType64StraightCrossingR,
    
    /// StraightCrossingLR
    TurnSimplifiedType64StraightCrossingLR,
    
    /// LeftCrossingF
    TurnSimplifiedType64LeftCrossingF,
    
    /// LeftCrossingR
    TurnSimplifiedType64LeftCrossingR,
    
    /// LeftCrossingFR
    TurnSimplifiedType64LeftCrossingFR,
    
    /// RightCrossingF
    TurnSimplifiedType64RightCrossingF,
    
    /// RightCrossingL
    TurnSimplifiedType64RightCrossingL,
    
    /// RightCrossingFL
    TurnSimplifiedType64RightCrossingFL,
    
    /// KeepOnHighwayL
    TurnSimplifiedType64KeepOnHighwayL,
    
    /// KeepOnHighwayR
    TurnSimplifiedType64KeepOnHighwayR,
    
    /// LeftRight
    TurnSimplifiedType64LeftRight,
    
    /// RightLeft
    TurnSimplifiedType64RightLeft,
    
    /// RoundaboutCW01
    TurnSimplifiedType64RoundaboutCW01,
    
    /// RoundaboutCW02
    TurnSimplifiedType64RoundaboutCW02,
    
    /// RoundaboutCW03
    TurnSimplifiedType64RoundaboutCW03,
    
    /// RoundaboutCW04
    TurnSimplifiedType64RoundaboutCW04,
    
    /// RoundaboutCW05
    TurnSimplifiedType64RoundaboutCW05,
    
    /// RoundaboutCW06
    TurnSimplifiedType64RoundaboutCW06,
    
    /// RoundaboutCW07
    TurnSimplifiedType64RoundaboutCW07,
    
    /// RoundaboutCW08
    TurnSimplifiedType64RoundaboutCW08,
    
    /// RoundaboutCW09
    TurnSimplifiedType64RoundaboutCW09,
    
    /// RoundaboutCW010
    TurnSimplifiedType64RoundaboutCW10,
    
    /// RoundaboutCW011
    TurnSimplifiedType64RoundaboutCW11,
    
    /// RoundaboutCW012
    TurnSimplifiedType64RoundaboutCW12,
    
    /// RoundaboutCCW01
    TurnSimplifiedType64RoundaboutCCW01,
    
    /// RoundaboutCCW02
    TurnSimplifiedType64RoundaboutCCW02,
    
    /// RoundaboutCCW03
    TurnSimplifiedType64RoundaboutCCW03,
    
    /// RoundaboutCCW04
    TurnSimplifiedType64RoundaboutCCW04,
    
    /// RoundaboutCCW05
    TurnSimplifiedType64RoundaboutCCW05,
    
    /// RoundaboutCCW06
    TurnSimplifiedType64RoundaboutCCW06,
    
    /// RoundaboutCCW07
    TurnSimplifiedType64RoundaboutCCW07,
    
    /// RoundaboutCCW08
    TurnSimplifiedType64RoundaboutCCW08,
    
    /// RoundaboutCCW09
    TurnSimplifiedType64RoundaboutCCW09,
    
    /// RoundaboutCCW010
    TurnSimplifiedType64RoundaboutCCW10,
    
    /// RoundaboutCCW011
    TurnSimplifiedType64RoundaboutCCW11,
    
    /// RoundaboutCCW012
    TurnSimplifiedType64RoundaboutCCW12,
    
    /// RoundaboutGen
    TurnSimplifiedType64RoundaboutGen,
    
    /// RoundaboutLeaveCW
    TurnSimplifiedType64RoundaboutLeaveCW,
    
    /// RoundaboutLeaveCCW
    TurnSimplifiedType64RoundaboutLeaveCCW,
    
    /// WaypointLeft
    TurnSimplifiedType64WaypointLeft,
    
    /// WaypointRight
    TurnSimplifiedType64WaypointRight,
    
    /// DestinationLeft
    TurnSimplifiedType64DestinationLeft,
    
    /// DestinationRight
    TurnSimplifiedType64DestinationRight,
    
    /// BoatFerry
    TurnSimplifiedType64BoatFerry,
    
    /// TrainFerry
    TurnSimplifiedType64TrainFerry
};

#endif /* TurnDetailsHeader_h */
