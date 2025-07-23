// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'dart:async';
import 'dart:convert';

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// Alarm listener interface.
///
/// {@category Routes & Navigation}
class AlarmListener extends EventHandler {
  /// Creates an alarm listener and sets the callbacks.
  ///
  /// Needs to be used as a parameter to the [AlarmService] constructor in order to receive callbacks.
  ///
  /// **Parameters**
  ///
  /// * **IN** *onBoundaryCrossed* See [registerOnBoundaryCrossed] for more information about usage.
  /// * **IN** *onMonitoringStateChanged* See [registerOnMonitoringStateChanged] for more information about usage.
  /// * **IN** *onTunnelEntered* See [registerOnTunnelEntered] for more information about usage.
  /// * **IN** *onTunnelLeft* See [registerOnTunnelLeft] for more information about usage.
  /// * **IN** *onLandmarkAlarmsUpdated* See [registerOnLandmarkAlarmsUpdated] for more information about usage.
  /// * **IN** *onOverlayItemAlarmsUpdated* See [registerOnOverlayItemAlarmsUpdated] for more information about usage.
  /// * **IN** *onLandmarkAlarmsPassedOver* See [registerOnLandmarkAlarmsPassedOver] for more information about usage.
  /// * **IN** *onOverlayItemAlarmsPassedOver* See [registerOnOverlayItemAlarmsPassedOver] for more information about usage.
  /// * **IN** *onHighSpeed* See [registerOnHighSpeed] for more information about usage.
  /// * **IN** *onNormalSpeed* See [registerOnNormalSpeed] for more information about usage.
  /// * **IN** *onSpeedLimit* See [registerOnSpeedLimit] for more information about usage.
  /// * **IN** *onEnterDayMode* See [registerOnEnterDayMode] for more information about usage.
  /// * **IN** *onEnterNightMode* See [registerOnEnterNightMode] for more information about usage.
  factory AlarmListener({
    final void Function(List<String> enteredAreas, List<String> exitedAreas)?
        onBoundaryCrossed,
    final void Function(bool isMonitoringActive)? onMonitoringStateChanged,
    final void Function()? onTunnelEntered,
    final void Function()? onTunnelLeft,
    final void Function()? onLandmarkAlarmsUpdated,
    final void Function()? onOverlayItemAlarmsUpdated,
    final void Function()? onLandmarkAlarmsPassedOver,
    final void Function()? onOverlayItemAlarmsPassedOver,
    final void Function(double limit, bool insideCityArea)? onHighSpeed,
    final void Function(double limit, bool insideCityArea)? onNormalSpeed,
    final void Function(double speed, double limit, bool insideCityArea)?
        onSpeedLimit,
    final void Function()? onEnterDayMode,
    final void Function()? onEnterNightMode,
  }) {
    final AlarmListener listener = AlarmListener._create();

    if (onBoundaryCrossed != null) {
      listener.registerOnBoundaryCrossed(onBoundaryCrossed);
    }
    if (onMonitoringStateChanged != null) {
      listener.registerOnMonitoringStateChanged(onMonitoringStateChanged);
    }
    if (onTunnelEntered != null) {
      listener.registerOnTunnelEntered(onTunnelEntered);
    }
    if (onTunnelLeft != null) {
      listener.registerOnTunnelLeft(onTunnelLeft);
    }
    if (onLandmarkAlarmsUpdated != null) {
      listener.registerOnLandmarkAlarmsUpdated(onLandmarkAlarmsUpdated);
    }
    if (onOverlayItemAlarmsUpdated != null) {
      listener.registerOnOverlayItemAlarmsUpdated(onOverlayItemAlarmsUpdated);
    }
    if (onLandmarkAlarmsPassedOver != null) {
      listener.registerOnLandmarkAlarmsPassedOver(onLandmarkAlarmsPassedOver);
    }
    if (onOverlayItemAlarmsPassedOver != null) {
      listener.registerOnOverlayItemAlarmsPassedOver(
        onOverlayItemAlarmsPassedOver,
      );
    }
    if (onHighSpeed != null) {
      listener.registerOnHighSpeed(onHighSpeed);
    }
    if (onNormalSpeed != null) {
      listener.registerOnNormalSpeed(onNormalSpeed);
    }
    if (onSpeedLimit != null) {
      listener.registerOnSpeedLimit(onSpeedLimit);
    }
    if (onEnterDayMode != null) {
      listener.registerOnEnterDayMode(onEnterDayMode);
    }
    if (onEnterNightMode != null) {
      listener.registerOnEnterNightMode(onEnterNightMode);
    }

    return listener;
  }
  @internal
  AlarmListener.init(this.id);

  void Function(List<String> enteredAreas, List<String> exitedAreas)?
      _onBoundaryCrossedCallback;
  void Function(bool isMonitoringActive)? _onMonitoringStateChangedCallback;
  void Function()? _onTunnelEnteredCallback;
  void Function()? _onTunnelLeftCallback;
  void Function()? _onLandmarkAlarmsUpdatedCallback;
  void Function()? _onOverlayItemAlarmsUpdatedCallback;
  void Function()? _onLandmarkAlarmsPassedOverCallback;
  void Function()? _onOverlayItemAlarmsPassedOverCallback;
  void Function(double limit, bool insideCityArea)? _onHighSpeedCallback;
  void Function(double limit, bool insideCityArea)? _onNormalSpeedCallback;
  void Function(double speed, double limit, bool insideCityArea)?
      _onSpeedLimitCallback;
  void Function()? _onEnterDayModeCallback;
  void Function()? _onEnterNightModeCallback;

  dynamic id;

  /// Called when a boundary is crossed.
  ///
  /// Does not get called initailly when the user starts from inside the boundary.
  ///
  /// **Parameters**
  ///
  /// * **IN** *enteredAreas* List of area ids entered.
  /// * **IN** *exitedAreas* List of areas ids exited.
  void registerOnBoundaryCrossed(
    final void Function(List<String> enteredAreas, List<String> exitedAreas)?
        callback,
  ) {
    _onBoundaryCrossedCallback = callback;
  }

  /// Called when monitoring state changes.
  ///
  /// **Parameters**
  ///
  /// * **IN** *isMonitoringActive* True if monitoring is active, false otherwise.
  void registerOnMonitoringStateChanged(
    final void Function(bool isMonitoringActive)? callback,
  ) {
    _onMonitoringStateChangedCallback = callback;
  }

  /// Called when a tunnel is entered.
  void registerOnTunnelEntered(final void Function()? callback) {
    _onTunnelEnteredCallback = callback;
  }

  /// Called when a tunnel is left.
  void registerOnTunnelLeft(final void Function()? callback) {
    _onTunnelLeftCallback = callback;
  }

  /// Called when landmark alarms are updated.
  void registerOnLandmarkAlarmsUpdated(final void Function()? callback) {
    _onLandmarkAlarmsUpdatedCallback = callback;
  }

  /// Called when overlay item alarms are updated.
  void registerOnOverlayItemAlarmsUpdated(final void Function()? callback) {
    _onOverlayItemAlarmsUpdatedCallback = callback;
  }

  /// Called when landmark alarms are passed over.
  void registerOnLandmarkAlarmsPassedOver(final void Function()? callback) {
    _onLandmarkAlarmsPassedOverCallback = callback;
  }

  /// Called when overlay item alarms are passed over.
  void registerOnOverlayItemAlarmsPassedOver(final void Function()? callback) {
    _onOverlayItemAlarmsPassedOverCallback = callback;
  }

  /// Called when high speed is detected.
  ///
  /// This callback is triggered continuously while the vehicle is exceeding the speed limit.
  ///
  /// Called continuously while the user is exceeding the speed limit.
  ///
  /// **Parameters**
  ///
  /// * **IN** *limit* Speed limit.
  /// * **IN** *insideCityArea* Whether inside a city area.
  void registerOnHighSpeed(
    final void Function(double limit, bool insideCityArea)? callback,
  ) {
    _onHighSpeedCallback = callback;
  }

  /// Called when the speed returns to normal.
  ///
  /// This callback is triggered once when the vehicle slows down from high speed to within the normal speed range.
  ///
  /// Called only once when the event occurs.
  ///
  /// **Parameters**
  ///
  /// * **IN** *limit* Speed limit.
  /// * **IN** *insideCityArea* Whether inside a city area.
  void registerOnNormalSpeed(
    final void Function(double limit, bool insideCityArea)? callback,
  ) {
    _onNormalSpeedCallback = callback;
  }

  /// Called when a new speed limit is encountered.
  ///
  /// The `limit` parameter provided will be 0 if the speed limit for the road section is unknown the road section does not have a speed limit or if the matched position is not on a road.
  ///
  /// **Parameters**
  ///
  /// * **IN** *speed* Current speed.
  /// * **IN** *limit* Speed limit.
  /// * **IN** *insideCityArea* Whether inside a city area.
  void registerOnSpeedLimit(
    final void Function(double speed, double limit, bool insideCityArea)?
        callback,
  ) {
    _onSpeedLimitCallback = callback;
  }

  /// Called when day mode is entered.
  void registerOnEnterDayMode(final void Function()? callback) {
    _onEnterDayModeCallback = callback;
  }

  /// Called when night mode is entered.
  void registerOnEnterNightMode(final void Function()? callback) {
    _onEnterNightModeCallback = callback;
  }

  static AlarmListener _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, dynamic>{
        'class': 'AlarmListener',
        'args': <String, dynamic>{},
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return AlarmListener.init(decodedVal['result']);
  }

  @override
  FutureOr<void> dispose() {}

  @override
  void handleEvent(final Map<dynamic, dynamic> arguments) {
    final String eventSubtype = arguments['event_subtype'];

    switch (eventSubtype) {
      case 'onBoundaryCrossed':
        if (_onBoundaryCrossedCallback != null) {
          final List<String> enteredAreas =
              (arguments['enteredAreas'] as List<dynamic>).cast<String>();
          final List<String> exitedAreas =
              (arguments['exitedAreas'] as List<dynamic>).cast<String>();

          _onBoundaryCrossedCallback!(enteredAreas, exitedAreas);
        }

      case 'onMonitoringStateChanged':
        if (_onMonitoringStateChangedCallback != null) {
          _onMonitoringStateChangedCallback!(arguments['isMonitoringActive']);
        }

      case 'onTunnelEntered':
        if (_onTunnelEnteredCallback != null) {
          _onTunnelEnteredCallback!();
        }

      case 'onTunnelLeft':
        if (_onTunnelLeftCallback != null) {
          _onTunnelLeftCallback!();
        }

      case 'onLandmarkAlarmsUpdated':
        if (_onLandmarkAlarmsUpdatedCallback != null) {
          _onLandmarkAlarmsUpdatedCallback!();
        }

      case 'onOverlayItemAlarmsUpdated':
        if (_onOverlayItemAlarmsUpdatedCallback != null) {
          _onOverlayItemAlarmsUpdatedCallback!();
        }

      case 'onLandmarkAlarmsPassedOver':
        if (_onLandmarkAlarmsPassedOverCallback != null) {
          _onLandmarkAlarmsPassedOverCallback!();
        }

      case 'onOverlayItemAlarmsPassedOver':
        if (_onOverlayItemAlarmsPassedOverCallback != null) {
          _onOverlayItemAlarmsPassedOverCallback!();
        }

      case 'onHighSpeed':
        if (_onHighSpeedCallback != null) {
          _onHighSpeedCallback!(
            arguments['limit'],
            arguments['insideCityArea'],
          );
        }

      case 'onNormalSpeed':
        if (_onNormalSpeedCallback != null) {
          _onNormalSpeedCallback!(
            arguments['limit'],
            arguments['insideCityArea'],
          );
        }

      case 'onSpeedLimit':
        if (_onSpeedLimitCallback != null) {
          _onSpeedLimitCallback!(
            arguments['speed'],
            arguments['limit'],
            arguments['insideCityArea'],
          );
        }

      case 'onEnterDayMode':
        if (_onEnterDayModeCallback != null) {
          _onEnterDayModeCallback!();
        }

      case 'onEnterNightMode':
        if (_onEnterNightModeCallback != null) {
          _onEnterNightModeCallback!();
        }

      default:
        gemSdkLogger.log(
          Level.WARNING,
          'Unknown event subtype: $eventSubtype in AlarmListener',
        );
    }
  }
}
