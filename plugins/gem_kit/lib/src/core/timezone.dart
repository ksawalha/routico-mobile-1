import 'dart:convert';

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Enumerates the type of response from the timezone plugin.
///
/// {@category Core}
enum TimeZoneStatus {
  /// Success response.
  success,

  /// Invalid coordinate error.
  invalidCoordinate,

  /// Wrong timezone ID error.
  wrongTimezoneId,

  /// Wrong timestamp error.
  wrongTimestamp,

  /// Timezone not found error.
  timezoneNotFound,

  /// Success response but using obsolete data.
  successUsingObsoleteData,
}

/// @nodoc
extension TimeZoneStatusExtension on TimeZoneStatus {
  int get id {
    switch (this) {
      case TimeZoneStatus.success:
        return 0;
      case TimeZoneStatus.invalidCoordinate:
        return 1;
      case TimeZoneStatus.wrongTimezoneId:
        return 2;
      case TimeZoneStatus.wrongTimestamp:
        return 3;
      case TimeZoneStatus.timezoneNotFound:
        return 4;
      case TimeZoneStatus.successUsingObsoleteData:
        return 5;
    }
  }

  static TimeZoneStatus fromId(final int id) {
    switch (id) {
      case 0:
        return TimeZoneStatus.success;
      case 1:
        return TimeZoneStatus.invalidCoordinate;
      case 2:
        return TimeZoneStatus.wrongTimezoneId;
      case 3:
        return TimeZoneStatus.wrongTimestamp;
      case 4:
        return TimeZoneStatus.timezoneNotFound;
      case 5:
        return TimeZoneStatus.successUsingObsoleteData;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Result which contains all information about a timezone
///
/// This class should not be instantiated directly. Instead, use the related methods from [TimezoneService] to obtain an instance.
///
/// {@category Core}
class TimezoneResult extends GemAutoreleaseObject {
  // ignore: unused_element
  TimezoneResult._() : pointerId = 0;

  @internal
  TimezoneResult.init(this.pointerId) {
    super.registerAutoReleaseObject(pointerId);
  }

  @internal
  final int pointerId;

  /// The offset daylight saving time (DST) offset.
  ///
  /// Returns [Duration.zero] if no DST available.
  Duration get dstOffset {
    final OperationResult resultString = objectMethod(
      pointerId,
      'TimezoneResult',
      'dstOffset',
    );
    return Duration(seconds: resultString['result']);
  }

  /// Get the offset including DST
  ///
  /// Can be negative
  Duration get offset {
    final OperationResult resultString = objectMethod(
      pointerId,
      'TimezoneResult',
      'offset',
    );
    return Duration(seconds: resultString['result']);
  }

  /// Get the UTC offset without DST
  ///
  /// Can be negative
  Duration get utcOffset {
    final OperationResult resultString = objectMethod(
      pointerId,
      'TimezoneResult',
      'utcOffset',
    );
    return Duration(seconds: resultString['result']);
  }

  /// Get the status of the response
  TimeZoneStatus get status {
    final OperationResult resultString = objectMethod(
      pointerId,
      'TimezoneResult',
      'status',
    );
    return TimeZoneStatusExtension.fromId(resultString['result']);
  }

  /// Get the ID of the timezone
  ///
  /// It is in the format "Continent/City_Name".
  /// Examples: Europe/Paris, America/New_York, Europe/Moscow
  String get timezoneId {
    final OperationResult resultString = objectMethod(
      pointerId,
      'TimezoneResult',
      'timezoneId',
    );
    return resultString['result'];
  }

  /// Get the local time
  ///
  /// The local time is returned as a UTC DateTime object but contins the local time at the requested location
  DateTime get localTime {
    final OperationResult resultString = objectMethod(
      pointerId,
      'TimezoneResult',
      'localTime',
    );
    return DateTime.fromMillisecondsSinceEpoch(
      resultString['result'],
      isUtc: true,
    );
  }

  @internal
  static TimezoneResult create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'TimezoneResult'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    final TimezoneResult retVal = TimezoneResult.init(decodedVal['result']);
    return retVal;
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, Object>{'class': 'TimezoneResult', 'id': pointerId}),
    );
  }
}

/// Timezone Service class
///
/// Provides information about timezones.
///
/// {@category Core}
abstract class TimezoneService {
  /// Async gets timezone info based on a coordinate and a timestamp
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The location from where to get the timezone result
  /// * **IN** *time* The time for which offsets are calculated (UTC)
  /// * **IN** *accurateResult* If left 'false' the result will be computed using the available offline resource. If 'true' an HTTP request will be performed for computing the result
  /// * **IN** *onCompleteCallback* The callback which will be called when the operation completes.
  ///   * Will be called with [GemError.success] error and non-null result upon success.
  ///   * Will be called with [GemError.internalAbort] error and null result if the result parsing failed or server internal error occurred
  ///
  /// **Returns**
  ///
  /// * [ProgressListener] for the operation progress if the operation could be started, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static ProgressListener? getTimezoneInfoFromCoordinates({
    required final Coordinates coords,
    required final DateTime time,
    final bool accurateResult = false,
    required final void Function(GemError error, TimezoneResult? result)
        onCompleteCallback,
  }) {
    final TimezoneResult result = TimezoneResult.create();
    final EventDrivenProgressListener listener = EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(listener.id, listener);

    listener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(listener.id);
      if (err == 0) {
        onCompleteCallback(GemErrorExtension.fromCode(err), result);
      } else {
        onCompleteCallback(GemErrorExtension.fromCode(err), null);
      }
    });
    final OperationResult resultString = staticMethod(
      'TimezoneService',
      'getTimezoneInfoCoords',
      args: <String, dynamic>{
        'timezoneResult': result.pointerId,
        'coords': coords,
        'time': time.millisecondsSinceEpoch,
        'progressListener': listener.id,
        'accurateResult': accurateResult,
      },
    );
    final GemError errCode = GemErrorExtension.fromCode(resultString['result']);
    if (errCode != GemError.success) {
      onCompleteCallback(errCode, null);
      return null;
    }
    return listener;
  }

  /// Async gets timezone info based on a timezone if and a timestamp
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The location from where to get the timezone result
  /// * **IN** *timezoneId* The geographic location on earth of type: "Continent/City". Examples: Europe/Paris, America/New_York, Europe/Moscow
  /// * **IN** *accurateResult* If left 'false' the result will be computed using the available offline resource. If 'true' an HTTP request will be performed for computing the result
  /// * **IN** *onCompleteCallback* The callback which will be called when the operation completes.
  ///   * Will be called with [GemError.success] error and non-null result upon success.
  ///   * Will be called with [GemError.internalAbort] error and null result if the result parsing failed or server internal error occurred
  ///
  /// **Returns**
  ///
  /// * [ProgressListener] for the operation progress if the operation could be started, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static ProgressListener? getTimezoneInfoFromTimezoneId({
    required final String timezoneId,
    required final DateTime time,
    final bool accurateResult = false,
    required final void Function(GemError error, TimezoneResult? result)
        onCompleteCallback,
  }) {
    final TimezoneResult result = TimezoneResult.create();
    final EventDrivenProgressListener listener = EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(listener.id, listener);

    listener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(listener.id);
      if (err == 0) {
        onCompleteCallback(GemErrorExtension.fromCode(err), result);
      } else {
        onCompleteCallback(GemErrorExtension.fromCode(err), null);
      }
    });
    final OperationResult resultString = staticMethod(
      'TimezoneService',
      'getTimezoneInfoTimezoneId',
      args: <String, dynamic>{
        'timezoneResult': result.pointerId,
        'timezoneId': timezoneId,
        'time': time.millisecondsSinceEpoch,
        'progressListener': listener.id,
        'accurateResult': accurateResult,
      },
    );
    final GemError errCode = GemErrorExtension.fromCode(resultString['result']);
    if (errCode != GemError.success) {
      onCompleteCallback(errCode, null);
      return null;
    }
    return listener;
  }
}
