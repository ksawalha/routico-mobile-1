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

import 'package:flutter/foundation.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Address field enumeration
///
/// {@category Places}
enum AddressField {
  /// Address field denoting an address extension, e.g. flat (apt, unit) number.
  extension,

  /// Address field denoting a building floor.
  buildingFloor,

  /// Address field denoting a building name.
  buildingName,

  /// Address field denoting a building room.
  buildingRoom,

  /// Address field denoting a building zone.
  buildingZone,

  /// Address field denoting a street/road name.
  streetName,

  /// Address field denoting a street number.
  streetNumber,

  /// Address field denoting a ZIP or postal code.
  postalCode,

  /// Address field denoting a settlement.
  settlement,

  /// Address field denoting a town or city name.
  city,

  /// Address field denoting a county, which is an intermediate entity between a state and a city.
  county,

  /// Address field denoting a state or province.
  state,

  /// Abbreviation for state.
  stateCode,

  /// Address field denoting a country.
  country,

  /// Address field denoting a country as a three-letter ISO 3166-1 alpha-3 code.
  countryCode,

  /// Address field denoting a municipal district.
  district,

  /// Address field denoting the first street in an intersection.
  crossing1,

  /// Address field denoting the second street in an intersection.
  crossing2,

  /// Address field denoting the road segment.
  segmentName,

  /// Last item of this enumeration
  addrLast,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Places}
extension AddressFieldExtension on AddressField {
  int get id {
    switch (this) {
      case AddressField.extension:
        return 0;
      case AddressField.buildingFloor:
        return 1;
      case AddressField.buildingName:
        return 2;
      case AddressField.buildingRoom:
        return 3;
      case AddressField.buildingZone:
        return 4;
      case AddressField.streetName:
        return 5;
      case AddressField.streetNumber:
        return 6;
      case AddressField.postalCode:
        return 7;
      case AddressField.settlement:
        return 8;
      case AddressField.city:
        return 9;
      case AddressField.county:
        return 10;
      case AddressField.state:
        return 11;
      case AddressField.stateCode:
        return 12;
      case AddressField.country:
        return 13;
      case AddressField.countryCode:
        return 14;
      case AddressField.district:
        return 15;
      case AddressField.crossing1:
        return 16;
      case AddressField.crossing2:
        return 17;
      case AddressField.segmentName:
        return 18;
      case AddressField.addrLast:
        return 19;
    }
  }

  static AddressField fromId(final int id) {
    switch (id) {
      case 0:
        return AddressField.extension;
      case 1:
        return AddressField.buildingFloor;
      case 2:
        return AddressField.buildingName;
      case 3:
        return AddressField.buildingRoom;
      case 4:
        return AddressField.buildingZone;
      case 5:
        return AddressField.streetName;
      case 6:
        return AddressField.streetNumber;
      case 7:
        return AddressField.postalCode;
      case 8:
        return AddressField.settlement;
      case 9:
        return AddressField.city;
      case 10:
        return AddressField.county;
      case 11:
        return AddressField.state;
      case 12:
        return AddressField.stateCode;
      case 13:
        return AddressField.country;
      case 14:
        return AddressField.countryCode;
      case 15:
        return AddressField.district;
      case 16:
        return AddressField.crossing1;
      case 17:
        return AddressField.crossing2;
      case 18:
        return AddressField.segmentName;
      case 19:
        return AddressField.addrLast;

      default:
        throw ArgumentError('Invalid id');
    }
  }

  static AddressField fromString(final String str) {
    switch (str) {
      case 'extension':
        return AddressField.extension;
      case 'buildingFloor':
        return AddressField.buildingFloor;
      case 'buildingName':
        return AddressField.buildingName;
      case 'buildingRoom':
        return AddressField.buildingRoom;
      case 'buildingZone':
        return AddressField.buildingZone;
      case 'streetName':
        return AddressField.streetName;
      case 'streetNumber':
        return AddressField.streetNumber;
      case 'postalCode':
        return AddressField.postalCode;
      case 'settlement':
        return AddressField.settlement;
      case 'city':
        return AddressField.city;
      case 'county':
        return AddressField.county;
      case 'state':
        return AddressField.state;
      case 'stateCode':
        return AddressField.stateCode;
      case 'country':
        return AddressField.country;
      case 'countryCode':
        return AddressField.countryCode;
      case 'district':
        return AddressField.district;
      case 'crossing1':
        return AddressField.crossing1;
      case 'crossing2':
        return AddressField.crossing2;
      case 'segment':
        return AddressField.segmentName;
      case 'addrLast':
        return AddressField.addrLast;

      default:
        throw ArgumentError('Invalid string');
    }
  }
}

/// Address info class
///
/// {@category Places}
class AddressInfo extends GemAutoreleaseObject {
  factory AddressInfo() {
    return AddressInfo.create();
  }

  @internal
  AddressInfo.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }

  @internal
  factory AddressInfo.fromJson(final Map<String, String> json) {
    final AddressInfo retVal = AddressInfo();

    for (final MapEntry<String, String> entry in json.entries) {
      final String key = entry.key;
      final String value = entry.value;
      final AddressField field = AddressFieldExtension.fromString(key);
      retVal.setField(value, field);
    }

    return retVal;
  }
  final int _pointerId;

  int get pointerId => _pointerId;

  /// Formats the address as a string.
  ///
  /// **Parameters**
  ///
  /// * **IN** *excludeFields* Fields to be excluded from result. If not specified nothing is excluded.
  /// * **IN** *includeFields* Fields to be included from result. If not specified all are included.
  ///
  /// **Returns**
  ///
  /// * Formatted string
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String format({
    final List<AddressField>? excludeFields,
    final List<AddressField>? includeFields,
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'AddressInfo',
      'format',
      args: <String, dynamic>{
        if (excludeFields != null)
          'excludeFields':
              excludeFields.map((final AddressField e) => e.id).toList(),
        if (includeFields != null)
          'includeFields':
              includeFields.map((final AddressField e) => e.id).toList(),
      },
    );

    return resultString['result'];
  }

  /// Get address field name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *field* Address field requested.
  ///
  /// **Returns**
  ///
  /// * Field value if it exists, otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String? getField(final AddressField field) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'AddressInfo',
      'getField',
      args: field.id,
    );

    final String returnString = resultString['result'];
    if (returnString.isEmpty) {
      return null;
    }
    return resultString['result'];
  }

  /// Set address field name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *str* New value of the address field.
  /// * **IN** *field* Address field requested.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setField(final String str, final AddressField field) {
    objectMethod(
      _pointerId,
      'AddressInfo',
      'setField',
      args: <String, dynamic>{'str': str, 'field': field.id},
    );
  }

  @override
  bool operator ==(covariant final AddressInfo other) {
    if (identical(this, other)) {
      return true;
    }

    final Map<AddressField, String> thisMap = _getAsMap();
    final Map<AddressField, String> otherMap = other._getAsMap();

    return mapEquals(thisMap, otherMap);
  }

  @override
  int get hashCode {
    int hash = 0;
    for (final MapEntry<AddressField, String> entry in _getAsMap().entries) {
      final AddressField key = entry.key;
      final String value = entry.value;
      hash = hash ^ value.hashCode ^ key.hashCode;
    }

    return hash;
  }

  Map<AddressField, String> _getAsMap() {
    final Map<AddressField, String> thisMap = <AddressField, String>{};

    for (final AddressField field in AddressField.values) {
      final String? thisFieldValue = getField(field);
      if (thisFieldValue == null) {
        continue;
      }
      thisMap[field] = thisFieldValue;
    }

    return thisMap;
  }

  static AddressInfo create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, dynamic>{'class': 'AddressInfo'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    final AddressInfo retVal = AddressInfo.init(decodedVal['result']);
    return retVal;
  }
}
