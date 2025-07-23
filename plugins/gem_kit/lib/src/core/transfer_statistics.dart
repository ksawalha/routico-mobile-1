// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Network types enumeration.
///
/// {@category Core}
enum NetworkType {
  /// Free of charge networks (unlimited WiFi or Wired networks, etc.)
  free,

  /// Charged per traffic/time (GPRS, EDGE, 3G, etc)
  extraCharged,
}

/// This class will not be documented.
///
/// @nodoc
extension NetworkTypeExtension on NetworkType {
  int get id {
    switch (this) {
      case NetworkType.free:
        return 0;
      case NetworkType.extraCharged:
        return 1;
    }
  }

  static NetworkType fromId(final int id) {
    switch (id) {
      case 0:
        return NetworkType.free;
      case 1:
        return NetworkType.extraCharged;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Online service type for which the view can generate data transfer statistics
enum ViewOnlineServiceType {
  /// Service type - map
  map,

  /// Service type - satellite elevation topography
  satelliteElevation,

  /// Service type - overlays
  overlays,

  /// External data ( WMTS, Wiki, etc )
  external,
}

/// This class will not be documented.
///
/// @nodoc
extension ViewOnlineServiceTypeExtension on ViewOnlineServiceType {
  int get id {
    switch (this) {
      case ViewOnlineServiceType.map:
        return 0;
      case ViewOnlineServiceType.satelliteElevation:
        return 1;
      case ViewOnlineServiceType.overlays:
        return 2;
      case ViewOnlineServiceType.external:
        return 3;
    }
  }

  static ViewOnlineServiceType fromId(final int id) {
    switch (id) {
      case 0:
        return ViewOnlineServiceType.map;
      case 1:
        return ViewOnlineServiceType.satelliteElevation;
      case 2:
        return ViewOnlineServiceType.overlays;
      case 3:
        return ViewOnlineServiceType.external;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Provides data transfer statistics for a specific online service
///
/// {@category Core}
class TransferStatistics extends GemAutoreleaseObject {
  // ignore: unused_element
  TransferStatistics._() : _pointerId = -1;

  @internal
  TransferStatistics.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;

  /// Gets the overall uploaded data size in bytes
  ///
  /// **Returns**
  ///
  /// * The overall uploaded data size in bytes
  int get upload {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TransferStatistics',
      'getUpload',
    );
    return resultString['result'];
  }

  /// Gets the overall downloaded data size in bytes
  ///
  /// **Returns**
  ///
  /// * The overall downloaded data size in bytes
  int get download {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TransferStatistics',
      'getDownload',
    );
    return resultString['result'];
  }

  /// Gets the overall number of requests
  ///
  /// **Returns**
  ///
  /// * The overall number of requests
  int get requests {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TransferStatistics',
      'getRequests',
    );
    return resultString['result'];
  }

  /// Gets the overall uploaded data size in bytes / network type
  ///
  /// **Parameters**
  ///
  /// * **IN** *networkType* The network type
  ///
  /// **Returns**
  ///
  /// * The overall uploaded data size in bytes
  int getUpload(NetworkType networkType) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TransferStatistics',
      'getUploadNetworkType',
      args: networkType.id,
    );
    return resultString['result'];
  }

  /// Gets the overall downloaded data size in bytes / network type
  ///
  /// **Parameters**
  ///
  /// * **IN** *networkType* The network type
  ///
  /// **Returns**
  ///
  /// * The overall downloaded data size in bytes
  int getDownload(NetworkType networkType) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TransferStatistics',
      'getDownloadNetworkType',
      args: networkType.id,
    );
    return resultString['result'];
  }

  /// Gets the overall number of requests / network type
  ///
  /// **Parameters**
  ///
  /// * **IN** *networkType* The network type
  ///
  /// **Returns**
  ///
  /// * The overall number of requests
  int getRequests(NetworkType networkType) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'TransferStatistics',
      'getRequestsNetworkType',
      args: networkType.id,
    );
    return resultString['result'];
  }

  /// Reset transfer statistics
  ///
  /// The object will no longer be available after this call and another [TransferStatistics] object needs to be retrieved
  void resetStatistics() {
    objectMethod(_pointerId, 'TransferStatistics', 'reset');
  }
}
