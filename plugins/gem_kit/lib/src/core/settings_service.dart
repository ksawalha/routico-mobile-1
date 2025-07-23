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

/// Used to store persistent settings in a key-value pair
///
/// {@category Places}
class SettingsService extends GemAutoreleaseObject {
  /// Creates or opens a SettingsService at the given path
  /// If no path is given, a default path will be used
  ///
  /// **Parameters**
  ///
  /// * **IN** *path* The path to the settings file
  factory SettingsService({String? path}) {
    return _create(path: path);
  }
  SettingsService.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }

  int _pointerId;

  /// Get the path where settings written using this SettingsService object are stored.
  ///
  /// **Returns**
  ///
  /// * The path where settings are stored
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  String get path {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SettingsService',
      'getPath',
    );

    return resultString['result'];
  }

  /// Write any unsaved changes to permanent storage.
  ///
  /// Call [flush] after a set value to ensure immediate sync with storage, otherwise the change may be updated after 1 second.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void flush() {
    objectMethod(
      _pointerId,
      'SettingsService',
      'flush',
    );
  }

  /// Start a group with the specified name
  ///
  /// The default group name is "DEFAULT". Does not allow nested groups.
  ///
  /// **Parameters**
  ///
  /// * **IN** *groupName* The name of the group
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void beginGroup(String groupName) {
    objectMethod(
      _pointerId,
      'SettingsService',
      'beginGroup',
      args: groupName,
    );

    flush();
  }

  /// End the current group
  ///
  /// Will set the [group] to "DEFAULT"
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void endGroup() {
    objectMethod(
      _pointerId,
      'SettingsService',
      'endGroup',
    );

    flush();
  }

  /// Get the name of the current group
  ///
  /// **Returns**
  ///
  /// * The name of the current group. The default group name is "DEFAULT"
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  String get group {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SettingsService',
      'getGroup',
    );

    return resultString['result'];
  }

  /// Set a value for the given key
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* The key
  /// * **IN** *value* The value
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void setString(final String key, final String value) {
    objectMethod(
      _pointerId,
      'SettingsService',
      'setValueString',
      args: <String, dynamic>{'first': key, 'second': value},
    );
  }

  /// Set a value for the given key
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* The key
  /// * **IN** *value* The value
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void setBool(final String key, final bool value) {
    objectMethod(
      _pointerId,
      'SettingsService',
      'setValueBool',
      args: <String, dynamic>{'first': key, 'second': value},
    );
  }

  /// Set a value for the given key
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* The key
  /// * **IN** *value* The value
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void setInt(final String key, final int value) {
    objectMethod(
      _pointerId,
      'SettingsService',
      'setValueInt',
      args: <String, dynamic>{'first': key, 'second': value},
    );
  }

  /// Set a value for the given key
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* The key
  /// * **IN** *value* The value
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void setLargeInt(final String key, final int value) {
    objectMethod(
      _pointerId,
      'SettingsService',
      'setValueInt64',
      args: <String, dynamic>{'first': key, 'second': value},
    );
  }

  /// Set a value for the given key
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* The key
  /// * **IN** *value* The value
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void setDouble(final String key, final double value) {
    objectMethod(
      _pointerId,
      'SettingsService',
      'setValueDouble',
      args: <String, dynamic>{'first': key, 'second': value},
    );
  }

  /// Get a value for the given key
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* The key
  /// * **IN** *defaultValue* The default value to return if the key is not found
  ///
  /// **Returns**
  ///
  /// * The value for the given key, or the default value if the key is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  String getString(final String key, {String defaultValue = ''}) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SettingsService',
      'getValueString',
      args: <String, dynamic>{'first': key, 'second': defaultValue},
    );

    return resultString['result'];
  }

  /// Get a value for the given key
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* The key
  /// * **IN** *defaultValue* The default value to return if the key is not found
  ///
  /// **Returns**
  ///
  /// * The value for the given key, or the default value if the key is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  bool getBool(final String key, {bool defaultValue = false}) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SettingsService',
      'getValueBool',
      args: <String, dynamic>{'first': key, 'second': defaultValue},
    );

    return resultString['result'];
  }

  /// Get a value for the given key
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* The key
  /// * **IN** *defaultValue* The default value to return if the key is not found
  ///
  /// **Returns**
  ///
  /// * The value for the given key, or the default value if the key is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int getInt(final String key, {int defaultValue = 0}) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SettingsService',
      'getValueInt',
      args: <String, dynamic>{'first': key, 'second': defaultValue},
    );

    return resultString['result'];
  }

  /// Get a value for the given key
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* The key
  /// * **IN** *defaultValue* The default value to return if the key is not found
  ///
  /// **Returns**
  ///
  /// * The value for the given key, or the default value if the key is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int getLargeInt(final String key, {int defaultValue = 0}) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SettingsService',
      'getValueInt64',
      args: <String, dynamic>{'first': key, 'second': defaultValue},
    );

    return resultString['result'];
  }

  /// Get a value for the given key
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* The key
  /// * **IN** *defaultValue* The default value to return if the key is not found
  ///
  /// **Returns**
  ///
  /// * The value for the given key, or the default value if the key is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  double getDouble(final String key, {double defaultValue = 0.0}) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SettingsService',
      'getValueDouble',
      args: <String, dynamic>{'first': key, 'second': defaultValue},
    );

    return resultString['result'];
  }

  /// Remove the specified setting key
  ///
  /// Use '*' wildcard to remove all keys matching a pattern
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* The key to remove
  ///
  /// **Returns**
  ///
  /// * The number of keys removed
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  int remove(final String key) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'SettingsService',
      'remove',
      args: key,
    );

    return resultString['result'];
  }

  /// Remove all settings
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void clear() {
    objectMethod(
      _pointerId,
      'SettingsService',
      'clear',
    );
  }

  static SettingsService _create({String? path}) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{
        'class': 'SettingsService',
        if (path != null) 'args': path,
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    final SettingsService retVal = SettingsService.init(decodedVal['result']);
    return retVal;
  }
}
