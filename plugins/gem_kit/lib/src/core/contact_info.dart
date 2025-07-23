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

import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Contact info field type
///
/// {@category Places}
enum ContactInfoFieldType {
  /// Phone number
  phone,

  /// Email address
  email,

  /// URL
  url,

  /// Booking URL
  bookingUrl,

  /// Opening hours
  openingHours,

  /// Last field
  last,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Places}
extension ContactInfoFieldTypeExtension on ContactInfoFieldType {
  int get id {
    switch (this) {
      case ContactInfoFieldType.phone:
        return 0;
      case ContactInfoFieldType.email:
        return 1;
      case ContactInfoFieldType.url:
        return 2;
      case ContactInfoFieldType.bookingUrl:
        return 3;
      case ContactInfoFieldType.openingHours:
        return 4;
      case ContactInfoFieldType.last:
        return 5;
    }
  }

  static ContactInfoFieldType fromId(final int id) {
    switch (id) {
      case 0:
        return ContactInfoFieldType.phone;
      case 1:
        return ContactInfoFieldType.email;
      case 2:
        return ContactInfoFieldType.url;
      case 3:
        return ContactInfoFieldType.bookingUrl;
      case 4:
        return ContactInfoFieldType.openingHours;
      case 5:
        return ContactInfoFieldType.last;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Contact info class
///
/// A [ContactInfo] can have multiple values of the same [ContactInfoFieldType].
///
/// Changes made to this object will not be automatically reflected in associated [Landmark].
/// Use the [Landmark.contactInfo] setter to set the contact info for a landmark.
///
/// {@category Places}
class ContactInfo extends GemAutoreleaseObject {
  factory ContactInfo() {
    return ContactInfo._create();
  }

  @internal
  ContactInfo.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final dynamic _pointerId;

  dynamic get pointerId => _pointerId;

  /// Add a new field to the contact info
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* Field's type (multiple values of the same type are supported)
  /// * **IN** *value* Field's value
  /// * **IN** *name* Field's name (usually used for display in UI)
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void addField({
    required final ContactInfoFieldType type,
    required final String value,
    required final String name,
  }) {
    objectMethod(
      _pointerId,
      'ContactInfo',
      'addField',
      args: <String, dynamic>{'type': type.id, 'value': value, 'name': name},
    );
  }

  /// Gets the field count.
  ///
  /// **Returns**
  ///
  /// * The field count
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get fieldsCount {
    final OperationResult result = objectMethod(
      _pointerId,
      'ContactInfo',
      'getFieldsCount',
    );
    return result['result'];
  }

  /// Gets the field name/short description.
  /// Depends on the language set. Usually used for display in UI
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Field index
  ///
  /// **Returns**
  ///
  /// * The field name for the given index, or null if no field corresponds to the given index
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String? getFieldName(final int index) {
    final OperationResult result = objectMethod(
      _pointerId,
      'ContactInfo',
      'getFieldName',
      args: index,
    );
    final String name = result['result'];
    return name.isNotEmpty ? name : null;
  }

  /// Gets the field value.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Field index
  ///
  /// **Returns**
  ///
  /// * The field value for the given index, or null if no field corresponds to the given index
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String? getFieldValue(final int index) {
    final OperationResult result = objectMethod(
      _pointerId,
      'ContactInfo',
      'getFieldValue',
      args: index,
    );

    final String value = result['result'];
    return value.isNotEmpty ? value : null;
  }

  /// Gets the field type.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Field index
  ///
  /// **Returns**
  ///
  /// * The field type for the given index, or null if no field corresponds to the given index
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  ContactInfoFieldType? getFieldType(final int index) {
    final OperationResult result = objectMethod(
      _pointerId,
      'ContactInfo',
      'getFieldType',
      args: index,
    );

    try {
      return ContactInfoFieldTypeExtension.fromId(result['result']);
    } catch (e) {
      return null;
    }
  }

  /// Sets field type, value and name.
  ///
  /// The field must already exist.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Field index
  /// * **IN** *type* Field's type
  /// * **IN** *value* Field's value
  /// * **IN** *name* Field's name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setField({
    required final int index,
    required final ContactInfoFieldType type,
    required final String value,
    required final String name,
  }) {
    if (index < 0) {
      return;
    }
    if (index < fieldsCount) {
      objectMethod(
        _pointerId,
        'ContactInfo',
        'setField',
        args: <String, dynamic>{
          'index': index,
          'type': type.id,
          'value': value,
          'name': name,
        },
      );
    } else {
      addField(type: type, value: value, name: name);
    }
  }

  /// Removes a field specified by index.
  ///
  /// The field must already exist.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Field index
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void removeField(final int index) {
    objectMethod(_pointerId, 'ContactInfo', 'removeField', args: index);
  }

  static ContactInfo _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'ContactInfo'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return ContactInfo.init(decodedVal['result']);
  }
}
