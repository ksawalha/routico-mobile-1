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

import 'package:gem_kit/core.dart';
import 'package:gem_kit/sense.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/position/gem_position.dart';
import 'package:gem_kit/src/position/gem_position_listener.dart';
import 'package:gem_kit/src/position/gem_position_listener_impl.dart';
import 'package:gem_kit/src/sense/sense_data_impl.dart';

/// Position service class
///
/// {@category Sensor Data Source}
class PositionService {
  PositionService._();
  static final PositionService _instance = PositionService._();
  static PositionService get instance => _instance;

  /// Register a new listener for updates.
  ///
  /// The listener also gets updates when the availability state of the data type provider changes.
  ///
  /// **Parameters**
  ///
  /// * **IN** *positionUpdatedCallback* The callback the listener registers for.
  ///
  /// **Returns**
  ///
  /// * [GemPositionListener]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemPositionListener addPositionListener(
    final void Function(GemPosition position) positionUpdatedCallback,
  ) {
    final GemPositionListener posListener = GemPositionListener(
      onNewPositionCallback: positionUpdatedCallback,
    );
    final String result = GemKitPlatform.instance.callObjectMethod(
      jsonEncode(<String, Object>{
        'id': 0,
        'class': 'PositionService',
        'method': 'registerSenseDataListener',
        'senseDataType': DataType.position.id,
      }),
    );

    posListener.id = jsonDecode(result)['result'];
    GemKitPlatform.instance.registerEventHandler(posListener.id, posListener);
    return posListener;
  }

  /// Register a new improved listener for updates.
  ///
  /// The listener also gets updates when the availability state of the data type provider changes.
  ///
  /// **Parameters**
  ///
  /// * **IN** *positionUpdatedCallback* The callback the listener registers for.
  ///
  /// **Returns**
  ///
  /// * [GemPositionListener]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemPositionListener addImprovedPositionListener(
    final void Function(GemImprovedPosition position) positionUpdatedCallback,
  ) {
    final GemPositionListener posListener = GemPositionListener(
      onNewImprovedPositionCallback: positionUpdatedCallback,
    );
    final String result = GemKitPlatform.instance.callObjectMethod(
      jsonEncode(<String, Object>{
        'id': 0,
        'class': 'PositionService',
        'method': 'registerSenseDataListener',
        'senseDataType': DataType.improvedPosition.id,
      }),
    );

    posListener.id = jsonDecode(result)['result'];
    GemKitPlatform.instance.registerEventHandler(posListener.id, posListener);
    return posListener;
  }

  /// Unregister a position listener.
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener* The listener to be unregistered.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void removeListener(final IGemPositionListener listener) {
    GemKitPlatform.instance.unregisterEventHandler(listener.id);
    GemKitPlatform.instance.callObjectMethod(
      jsonEncode(<String, Object>{
        'id': 0,
        'class': 'PositionService',
        'method': 'registerSenseDataListener',
        'senseDataType': 'none',
      }),
    );
  }

  @Deprecated('Use the position getter instead.')
  GemPosition? getPosition() => position;

  @Deprecated('Use the improvedPosition getter instead.')
  GemImprovedPosition? getImprovedPosition() => improvedPosition;

  /// Fetches the latest position data available.
  ///
  /// **Returns**
  ///
  /// * Latest position if available, otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemPosition? get position {
    final OperationResult retVal = staticMethod(
      'PositionService',
      'getPosition',
      args: DataType.position.id,
    );

    final GemError gemApiError = GemErrorExtension.fromCode(
      retVal['gemApiError'],
    );

    if (gemApiError != GemError.success) {
      return null;
    }

    final dynamic result = retVal['result'];
    if (result != null) {
      return GemPositionImpl.fromJson(result);
    }
    return null;
  }

  /// Fetches the latest map-matched position data available.
  ///
  /// **Returns**
  ///
  /// * Latest improved position if available, otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemImprovedPosition? get improvedPosition {
    final OperationResult retVal = staticMethod(
      'PositionService',
      'getPosition',
      args: DataType.improvedPosition.id,
    );
    final GemError gemApiError = GemErrorExtension.fromCode(
      retVal['gemApiError'],
    );

    if (gemApiError != GemError.success) {
      return null;
    }

    final dynamic result = retVal['result'];
    if (result != null) {
      return GemImprovedPositionImpl.fromJson(result);
    }
    return null;
  }

  /// Set the position service current datasource to **live**.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.invalidInput] if the datasource could not be created (missing permissions, no position provider, etc.)
  /// * [GemError.exist] if the datasource is already set
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError setLiveDataSource() {
    final String resultString = GemKitPlatform.instance.callObjectMethod(
      jsonEncode(<String, dynamic>{
        'id': 0,
        'class': 'PositionService',
        'method': 'selectPositionDataSource',
        'senseDataSourceType': 'live',
      }),
    );
    final dynamic result = jsonDecode(resultString);
    final int errCode = result['gemApiError'];
    return GemErrorExtension.fromCode(errCode);
  }

  /// Retrieves the current data source used for obtaining position data.
  ///
  /// **Returns**
  ///
  /// * The data source if it exists, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  DataSource? getDataSource() {
    final OperationResult resultString = staticMethod(
      'PositionService',
      'getDataSource',
    );
    if (resultString['result'] == null) {
      return null;
    }
    return DataSource.init(resultString['result']);
  }

  /// Retrieves the method used to obtain the position data.
  ///
  /// **Returns**
  ///
  /// * The data source type
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  DataSourceType get sourceType {
    final OperationResult resultString = objectMethod(
      0,
      'PositionService',
      'getSourceType',
    );

    return DataSourceTypeExtension.fromId(resultString['result']);
  }

  /// Remove the position service current datasource (set it to **none**)
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void removeDataSource() {
    GemKitPlatform.instance.callObjectMethod(
      jsonEncode(<String, Object>{
        'id': 0,
        'class': 'PositionService',
        'method': 'selectPositionDataSource',
        'senseDataSourceType': 'none',
      }),
    );
  }

  /// Sets the current data source for obtaining position data.
  ///
  /// **Parameters**
  ///
  /// * **IN** *dataSource* The data source to be used for fetching position data.
  ///
  /// If dataSource is empty, the current data source will be removed.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.exist] if the datasource is already set
  /// * [GemError.invalidInput] if the datasource is invalid
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError setExternalDataSource(final DataSource dataSource) {
    final OperationResult resultString = staticMethod(
      'PositionService',
      'setExternalDataSource',
      args: dataSource.pointerId,
    );
    return GemErrorExtension.fromCode(resultString['gemApiError']);
  }

  /// Requests location permission. Only works on Web.
  ///
  /// **Returns**
  ///
  /// * True if the permission was granted, false otherwise
  ///
  /// **Throws**
  ///
  /// * [UnimplementedError] on iOS/Android
  static Future<bool> requestLocationPermission() {
    return GemKitPlatform.instance.askForLocationPermission();
  }
}
