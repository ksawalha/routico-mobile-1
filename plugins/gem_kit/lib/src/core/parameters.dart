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

import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Types of values.
///
/// {@category Core}
enum ValueType {
  /// Invalid type.
  invalid,

  /// Bool value.
  bool,

  /// 64 bit int value.
  int,

  /// Double value
  real,

  /// String value
  string,

  /// List value
  list,
}

/// @nodoc
///
/// {@category Core}
extension ValueTypeExtension on ValueType {
  int get id {
    switch (this) {
      case ValueType.invalid:
        return 0;
      case ValueType.bool:
        return 1;
      case ValueType.int:
        return 2;
      case ValueType.real:
        return 3;
      case ValueType.string:
        return 4;
      case ValueType.list:
        return 5;
    }
  }

  static ValueType fromId(final int id) {
    switch (id) {
      case 0:
        return ValueType.invalid;
      case 1:
        return ValueType.bool;
      case 2:
        return ValueType.int;
      case 3:
        return ValueType.real;
      case 4:
        return ValueType.string;
      case 5:
        return ValueType.list;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// {@category Core}
/// A parameter is a tuple ( key, value, name ).
///
/// [key] is the string parameter identifier
///
/// [value] is the parameter variant value.
///
/// [name] is the string parameter name. When parameters are returned from SDK the name is translated in the SDK language
///
/// [value] is the parameter value. It is dependent on the [type]
class GemParameter {
  /// Construct a parameter object with key & value & name ( optional )
  /// **Parameters**
  /// * **IN** *type*	Parameter type
  /// * **IN** *key*	Parameter key
  /// * **IN** *value*	Parameter value
  /// * **IN** *name*	Parameter name
  GemParameter({this.type, this.value, this.name, this.key});

  /// Creates a [GemParameter] with a [ValueType.bool] value type
  factory GemParameter.withBool({
    required final String key,
    required final bool value,
    final String? name,
  }) {
    return GemParameter(
      key: key,
      type: ValueType.bool,
      value: value,
      name: name,
    );
  }

  /// Creates a [GemParameter] with a [ValueType.int] value type
  factory GemParameter.withInt({
    required final String key,
    required final int value,
    final String? name,
  }) {
    return GemParameter(
      key: key,
      type: ValueType.int,
      value: value,
      name: name,
    );
  }

  /// Creates a [GemParameter] with a [ValueType.real] value type
  factory GemParameter.withReal({
    required final String key,
    required final double value,
    final String? name,
  }) {
    return GemParameter(
      key: key,
      type: ValueType.real,
      value: value,
      name: name,
    );
  }

  /// Creates a [GemParameter] with a [ValueType.string] value type
  factory GemParameter.withString({
    required final String key,
    required final String value,
    final String? name,
  }) {
    return GemParameter(
      key: key,
      type: ValueType.string,
      value: value,
      name: name,
    );
  }

  /// Creates a [GemParameter] with a [ValueType.list] value type
  factory GemParameter.withList({
    required final String key,
    required final ParameterList value,
    final String? name,
  }) {
    return GemParameter(
      key: key,
      type: ValueType.list,
      value: value,
      name: name,
    );
  }

  factory GemParameter.fromJson(final Map<String, dynamic> json) {
    final ValueType type = ValueTypeExtension.fromId(json['type']);
    dynamic value = json['value'];

    if (type == ValueType.list) {
      value = ParameterList.init(json['value']);
    }

    return GemParameter(
      type: ValueTypeExtension.fromId(json['type']),
      value: value,
      name: json['name'],
      key: json['key'],
    );
  }
  ValueType? type;
  dynamic value;
  String? name;
  String? key;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    if (type != null) {
      json['type'] = type!.id;
    }
    if (value != null) {
      if (type == ValueType.list) {
        json['value'] = (value as ParameterList).pointerId;
      } else {
        json['value'] = value;
      }
    }
    if (name != null) {
      json['name'] = name;
    }
    if (key != null) {
      json['key'] = key;
    }
    return json;
  }

  /// Returns the parameters as a deeply structured JSON object (the lists contained within will be expanded).
  ///
  /// Includes the [GemParameter.key], [GemParameter.value], and, if available, [GemParameter.name].
  /// The [GemParameter.value] is formatted according to its [GemParameter.type].
  ///
  /// Returns null if [GemParameter.key], [GemParameter.value], or [GemParameter.type] are null.
  Map<String, dynamic>? asJson() {
    if (type == null || value == null || key == null) {
      return null;
    }
    if (type == ValueType.invalid) {
      return null;
    }

    return <String, dynamic>{
      'key': key,
      if (name != null) 'name': name,
      'value': value is! ParameterList ? value : value.asJson(),
    };
  }

  @override
  bool operator ==(covariant final GemParameter other) {
    if (identical(this, other)) {
      return true;
    }

    return other.type == type &&
        other.value == value &&
        other.name == name &&
        other.key == key;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        type.hashCode ^
        value.hashCode ^
        name.hashCode ^
        key.hashCode;
  }
}

/// Searchable parameters list.
///
/// {@category Core}
class ParameterList extends GemList<GemParameter> {
  /// Create a new [ParameterList] object.
  factory ParameterList() {
    return ParameterList.create();
  }

  @internal
  ParameterList.init(final dynamic id, {final String? className})
      : super(
          id,
          className ?? 'ParameterList',
          (final dynamic data) => GemParameter.fromJson(data),
        );

  static ParameterList create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'ParameterList'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return ParameterList.init(decodedVal['result']);
  }

  void add(final GemParameter parameter) {
    objectMethod(
      super.pointerId,
      'ParameterList',
      'push_back',
      args: parameter.toJson(),
    );
  }

  /// Returns the parameters as a deeply structured JSON list.
  ///
  /// Each entry includes the [GemParameter.key], [GemParameter.value], and, if available, [GemParameter.name].
  /// The [GemParameter.value] is formatted according to its [GemParameter.type].
  ///
  /// Only parameters with non-null [GemParameter.key], [GemParameter.value], and [GemParameter.type] are included.
  List<Map<String, dynamic>> asJson() {
    final List<Map<String, dynamic>> json = <Map<String, dynamic>>[];
    for (final GemParameter param in this) {
      final Map<String, dynamic>? parsedParam = param.asJson();
      if (parsedParam != null) {
        json.add(parsedParam);
      }
    }

    return json;
  }
}

/// Searchable parameters list.
///
/// Container for different types of values.
///
/// {@category Core}
class SearchableParameterList extends ParameterList {
  /// Create a new [SearchableParameterList] object.
  ///
  /// **Parameters**
  ///
  /// * **IN** *parameterList* Optional parameter list to be used for the object initialization.
  /// If no value is passed then it will instantiate an empty list.
  factory SearchableParameterList({final ParameterList? parameterList}) {
    return SearchableParameterList.create(0, parameterList: parameterList);
  }
  @internal
  SearchableParameterList.init(super.id)
      : super.init(className: 'SearchableParameterList');

  /// Search for first occurrence of a parameter identifier and get the name of the parameter.
  ///
  /// **Parameters**
  ///
  /// * **IN** *key*	Parameter key as string
  ///
  /// **Returns**
  ///
  /// * The name of the parameter if found. Empty string otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String find(final String key) {
    final OperationResult resultString = objectMethod(
      pointerId,
      'SearchableParameterList',
      'find',
      args: key,
    );
    return resultString['result'];
  }

  /// Search for all occurrences of a parameter identifier in a list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *key*	Parameter key as string
  ///
  /// **Returns**
  ///
  /// * The list of parameters. Is empty if there are no matches.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  ParameterList findAll(final String key) {
    final OperationResult resultString = objectMethod(
      pointerId,
      'SearchableParameterList',
      'findAll',
      args: key,
    );
    return ParameterList.init(resultString['result']);
  }

  /// Search for first occurrence of a parameter identifier.
  ///
  /// **Parameters**
  ///
  /// * **IN** *key*	Parameter key as string
  ///
  /// **Returns**
  ///
  /// * [GemParameter] object. If not found then [GemParameter.key] is an empty string.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemParameter findParameter(final String key) {
    final OperationResult resultString = objectMethod(
      pointerId,
      'SearchableParameterList',
      'findParameter',
      args: key,
    );
    return GemParameter.fromJson(resultString['result']);
  }

  static SearchableParameterList create(
    final int mapId, {
    final ParameterList? parameterList,
  }) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, dynamic>{
        'class': 'SearchableParameterList',
        if (parameterList != null) 'args': parameterList.pointerId,
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return SearchableParameterList.init(decodedVal['result']);
  }

  @override
  void dispose() => GemKitPlatform.instance.callDeleteObject(
        jsonEncode(<String, dynamic>{
          'class': 'SearchableParameterList',
          'id': pointerId,
        }),
      );
}
