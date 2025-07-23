// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

/// SDK icons
///
/// {@category Core}
enum GemIcon {
  blueBall,
  favoriteHeart,
  greenBall,
  menuMoreDotsCircle,
  redBall,
  searchResultsPin,
  waypointFinish,
  waypointIntermediary,
  waypointStart,
  yellowBall,
  coreCount,
  coreBase,
}

/// @nodoc
///
/// {@category Core}
extension GemIconExtension on GemIcon {
  int get id {
    switch (this) {
      case GemIcon.blueBall:
        return 54000;
      case GemIcon.favoriteHeart:
        return 54009;
      case GemIcon.greenBall:
        return 54001;
      case GemIcon.menuMoreDotsCircle:
        return 54005;
      case GemIcon.redBall:
        return 54002;
      case GemIcon.searchResultsPin:
        return 54003;
      case GemIcon.waypointFinish:
        return 54006;
      case GemIcon.waypointIntermediary:
        return 54007;
      case GemIcon.waypointStart:
        return 54008;
      case GemIcon.yellowBall:
        return 54004;
      case GemIcon.coreCount:
        return 10;
      case GemIcon.coreBase:
        return 54000;
    }
  }

  static GemIcon fromId(final int id) {
    switch (id) {
      case 54000:
        return GemIcon.blueBall;
      case 54009:
        return GemIcon.favoriteHeart;
      case 54001:
        return GemIcon.greenBall;
      case 54005:
        return GemIcon.menuMoreDotsCircle;
      case 54002:
        return GemIcon.redBall;
      case 54003:
        return GemIcon.searchResultsPin;
      case 54006:
        return GemIcon.waypointFinish;
      case 54007:
        return GemIcon.waypointIntermediary;
      case 54008:
        return GemIcon.waypointStart;
      case 54004:
        return GemIcon.yellowBall;
      case 10:
        return GemIcon.coreCount;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Miscellaneous icons
///
/// {@category Core}
enum EngineMisc {
  alertActive,
  alertInactive,
  compassEnableSensorOFF,
  compassEnableSensorOFFnight,
  compassEnableSensorON,
  compassEnableSensorONNight,
  folder,
  locationDetailsFavouritePushPin,
  locationDetailsPlacePushpin,
  locationDetailsPlaceStreet,
  locationDetailsPlaceStreetSign,
  locationDetailsSendDetails,
  mapScale,
  myLocation,
  poiHome,
  poiToLeft,
  poiToRight,
  poiWork,
  positionGPSNavigationAvailable,
  positionGPSNoNavigationAvailable,
  positionGPSSlice,
  roadShieldExitName,
  roadShieldExitNumber,
  settlementIsland,
  sorting,
  waypointFlagPointFinish,
  waypointFlagPointFinishSearchOnMap,
  waypointFlagPointIntermediary,
  waypointFlagPointIntermediarySearchOnMap,
  waypointFlagPointStart,
  waypointFlagPointStartSearchOnMap,
  engineMiscCount,
  engineMiscBase,
}

/// @nodoc
///
/// {@category Core}
extension EngineMiscExtension on EngineMisc {
  int get id {
    switch (this) {
      case EngineMisc.alertActive:
        return 6060;
      case EngineMisc.alertInactive:
        return 6061;
      case EngineMisc.compassEnableSensorOFF:
        return 6001;
      case EngineMisc.compassEnableSensorOFFnight:
        return 6071;
      case EngineMisc.compassEnableSensorON:
        return 6003;
      case EngineMisc.compassEnableSensorONNight:
        return 6072;
      case EngineMisc.folder:
        return 6096;
      case EngineMisc.locationDetailsFavouritePushPin:
        return 6005;
      case EngineMisc.locationDetailsPlacePushpin:
        return 6008;
      case EngineMisc.locationDetailsPlaceStreet:
        return 6102;
      case EngineMisc.locationDetailsPlaceStreetSign:
        return 6103;
      case EngineMisc.locationDetailsSendDetails:
        return 6108;
      case EngineMisc.mapScale:
        return 6010;
      case EngineMisc.myLocation:
        return 6078;
      case EngineMisc.poiHome:
        return 6067;
      case EngineMisc.poiToLeft:
        return 6014;
      case EngineMisc.poiToRight:
        return 6015;
      case EngineMisc.poiWork:
        return 6068;
      case EngineMisc.positionGPSNavigationAvailable:
        return 6019;
      case EngineMisc.positionGPSNoNavigationAvailable:
        return 6021;
      case EngineMisc.positionGPSSlice:
        return 6023;
      case EngineMisc.roadShieldExitName:
        return 6069;
      case EngineMisc.roadShieldExitNumber:
        return 6070;
      case EngineMisc.settlementIsland:
        return 6029;
      case EngineMisc.sorting:
        return 6098;
      case EngineMisc.waypointFlagPointFinish:
        return 6034;
      case EngineMisc.waypointFlagPointFinishSearchOnMap:
        return 6073;
      case EngineMisc.waypointFlagPointIntermediary:
        return 6035;
      case EngineMisc.waypointFlagPointIntermediarySearchOnMap:
        return 6074;
      case EngineMisc.waypointFlagPointStart:
        return 6036;
      case EngineMisc.waypointFlagPointStartSearchOnMap:
        return 6075;
      case EngineMisc.engineMiscCount:
        return 31;
      case EngineMisc.engineMiscBase:
        return 6000;
    }
  }

  static EngineMisc fromId(final int id) {
    switch (id) {
      case 6060:
        return EngineMisc.alertActive;
      case 6061:
        return EngineMisc.alertInactive;
      case 6001:
        return EngineMisc.compassEnableSensorOFF;
      case 6071:
        return EngineMisc.compassEnableSensorOFFnight;
      case 6003:
        return EngineMisc.compassEnableSensorON;
      case 6072:
        return EngineMisc.compassEnableSensorONNight;
      case 6096:
        return EngineMisc.folder;
      case 6005:
        return EngineMisc.locationDetailsFavouritePushPin;
      case 6008:
        return EngineMisc.locationDetailsPlacePushpin;
      case 6102:
        return EngineMisc.locationDetailsPlaceStreet;
      case 6103:
        return EngineMisc.locationDetailsPlaceStreetSign;
      case 6108:
        return EngineMisc.locationDetailsSendDetails;
      case 6010:
        return EngineMisc.mapScale;
      case 6078:
        return EngineMisc.myLocation;
      case 6067:
        return EngineMisc.poiHome;
      case 6014:
        return EngineMisc.poiToLeft;
      case 6015:
        return EngineMisc.poiToRight;
      case 6068:
        return EngineMisc.poiWork;
      case 6019:
        return EngineMisc.positionGPSNavigationAvailable;
      case 6021:
        return EngineMisc.positionGPSNoNavigationAvailable;
      case 6023:
        return EngineMisc.positionGPSSlice;
      case 6069:
        return EngineMisc.roadShieldExitName;
      case 6070:
        return EngineMisc.roadShieldExitNumber;
      case 6029:
        return EngineMisc.settlementIsland;
      case 6098:
        return EngineMisc.sorting;
      case 6034:
        return EngineMisc.waypointFlagPointFinish;
      case 6073:
        return EngineMisc.waypointFlagPointFinishSearchOnMap;
      case 6035:
        return EngineMisc.waypointFlagPointIntermediary;
      case 6074:
        return EngineMisc.waypointFlagPointIntermediarySearchOnMap;
      case 6036:
        return EngineMisc.waypointFlagPointStart;
      case 6075:
        return EngineMisc.waypointFlagPointStartSearchOnMap;
      case 31:
        return EngineMisc.engineMiscCount;
      case 6000:
        return EngineMisc.engineMiscBase;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}
