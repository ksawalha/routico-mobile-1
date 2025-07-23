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
import 'dart:typed_data';

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Day light
///
/// {@category Weather}
enum Daylight {
  /// Unknown
  notAvailable,

  /// Day
  day,

  /// Night
  night,
}

/// This class will not be documented.
///
/// @nodoc
extension DaylightExtension on Daylight {
  int get id {
    switch (this) {
      case Daylight.notAvailable:
        return 0;
      case Daylight.day:
        return 1;
      case Daylight.night:
        return 2;
    }
  }

  static Daylight fromId(final int id) {
    switch (id) {
      case 0:
        return Daylight.notAvailable;
      case 1:
        return Daylight.day;
      case 2:
        return Daylight.night;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// This class will not be documented.
///
/// @nodoc
class LocationForecastList {
  LocationForecastList() : _id = -1;

  @internal
  LocationForecastList.init(final int id) : _id = id;
  final dynamic _id;
  dynamic get id => _id;

  static LocationForecastList create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'LocationForecastList'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return LocationForecastList.init(decodedVal['result']);
  }

  List<LocationForecast> getJson() {
    final OperationResult result = objectMethod(
      _id,
      'LocationForecastList',
      'getJson',
    );
    final List<dynamic> listJson = result['result'] as List<dynamic>;
    final List<LocationForecast> retList = listJson
        .map(
          (final dynamic categoryJson) =>
              LocationForecast.fromJson(categoryJson),
        )
        .toList();
    return retList;
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, dynamic>{'class': 'LocationForecastList', 'id': _id}),
    );
  }
}

/// Weather service class
///
/// {@category Weather}
abstract class WeatherService {
  /// Async gets current weather for a list of coordinates.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The coordinates list for which the current weather is requested.
  /// * **IN** *onCompleteCallback* The callback which will be called when the operation completes.
  ///   * Will be called with [GemError.success] error and non-empty locationForecasts upon success.
  ///   * Will be called with [GemError.invalidInput] error and empty locationForecasts if the coordinates list is empty.
  ///   * Will be called with [GemError.resourceMissing] error and empty locationForecasts if the internal engine resource is missing
  ///   * Will be called with [GemError.outOfRange] error and empty locationForecasts if number of coordinates is greater than the maximum allowed.
  ///   * Will be called with other [GemError] values and empty locationForecasts on other errors
  ///
  /// **Returns**
  ///
  /// * [ProgressListener] for the operation progress
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static ProgressListener getCurrent({
    required final List<Coordinates> coords,
    required final void Function(
      GemError error,
      List<LocationForecast> locationForecasts,
    ) onCompleteCallback,
  }) {
    final LocationForecastList result = LocationForecastList.create();
    final EventDrivenProgressListener listener = EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(listener.id, listener);

    listener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(listener.id);
      if (err == 0) {
        onCompleteCallback(GemErrorExtension.fromCode(err), result.getJson());
        result.dispose();
      } else {
        onCompleteCallback(
          GemErrorExtension.fromCode(err),
          <LocationForecast>[],
        );
      }
    });
    final OperationResult resultOperation = staticMethod(
      'Weather',
      'getCurrent',
      args: <String, dynamic>{
        'coords': coords,
        'result': result.id,
        'listener': listener.id,
      },
    );
    final GemError errCode = GemErrorExtension.fromCode(
      resultOperation['result'],
    );
    if (errCode != GemError.success) {
      onCompleteCallback(errCode, <LocationForecast>[]);
    }
    return listener;
  }

  /// Async gets forecast weather for a list of coordinates and durations.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The coordinates & timestamps list for which the forecast is requested.
  /// * **IN** *onCompleteCallback* The callback which will be called when the operation completes.
  ///   * Will be called with [GemError.success] error and non-empty locationForecasts upon success.
  ///   * Will be called with [GemError.invalidInput] error and empty locationForecasts if the coordinates list is empty.
  ///   * Will be called with [GemError.resourceMissing] error and empty locationForecasts if the internal engine resource is missing
  ///   * Will be called with [GemError.outOfRange] error and empty locationForecasts if number of coordinates is greater than the maximum allowed.
  ///   * Will be called with other [GemError] values and empty locationForecasts on other errors
  ///
  /// **Returns**
  ///
  /// * [ProgressListener] for the operation progress
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static ProgressListener getForecast({
    required final List<WeatherDurationCoordinates> coords,
    required final void Function(
      GemError,
      List<LocationForecast> locationForecasts,
    ) onCompleteCallback,
  }) {
    for (final WeatherDurationCoordinates coord in coords) {
      if (coord.coordinates.latitude.abs() > 90 ||
          coord.coordinates.longitude.abs() > 180) {
        onCompleteCallback(GemError.invalidInput, <LocationForecast>[]);
        return EventDrivenProgressListener();
      }
    }

    final LocationForecastList result = LocationForecastList.create();
    final EventDrivenProgressListener listener = EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(listener.id, listener);

    listener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(listener.id);
      if (err == 0) {
        onCompleteCallback(GemErrorExtension.fromCode(err), result.getJson());
        result.dispose();
      } else {
        onCompleteCallback(
          GemErrorExtension.fromCode(err),
          <LocationForecast>[],
        );
      }
    });
    final OperationResult resultString = staticMethod(
      'Weather',
      'getForecast',
      args: <String, dynamic>{
        'coords': coords,
        'result': result.id,
        'listener': listener.id,
      },
    );
    final GemError errCode = GemErrorExtension.fromCode(resultString['result']);
    if (errCode != GemError.success) {
      onCompleteCallback(errCode, <LocationForecast>[]);
    }
    return listener;
  }

  /// Async gets forecast weather for a list of coordinates and timestamps.
  ///
  /// **Parameters**
  ///
  /// * **IN** *hours* The number of hours for which the forecast is requested (value should be <= 240).
  /// * **IN** *onCompleteCallback* The callback which will be called when the operation completes.
  ///   * Will be called with [GemError.success] error and non-empty locationForecasts upon success.
  ///   * Will be called with [GemError.invalidInput] error and empty locationForecasts if the coordinates list is empty or if the number of hours is negative.
  ///   * Will be called with [GemError.resourceMissing] error and empty locationForecasts if the internal engine resource is missing
  ///   * Will be called with [GemError.outOfRange] error and empty locationForecasts if number of coordinates or the number of hours is greater than the maximum allowed.
  ///   * Will be called with other [GemError] values and empty locationForecasts on other errors
  ///
  /// **Returns**
  ///
  /// * [ProgressListener] for the operation progress
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static ProgressListener getHourlyForecast({
    required final int hours,
    required final List<Coordinates> coords,
    required final void Function(
      GemError error,
      List<LocationForecast> locationForecasts,
    ) onCompleteCallback,
  }) {
    final LocationForecastList result = LocationForecastList.create();
    final EventDrivenProgressListener listener = EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(listener.id, listener);

    listener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(listener.id);
      if (err == 0) {
        onCompleteCallback(GemErrorExtension.fromCode(err), result.getJson());
        result.dispose();
      } else {
        onCompleteCallback(
          GemErrorExtension.fromCode(err),
          <LocationForecast>[],
        );
      }
    });
    final OperationResult resultString = staticMethod(
      'Weather',
      'getHourlyForecast',
      args: <String, dynamic>{
        'hours': hours,
        'coords': coords,
        'result': result.id,
        'listener': listener.id,
      },
    );
    final GemError errCode = GemErrorExtension.fromCode(resultString['result']);
    if (errCode != GemError.success) {
      onCompleteCallback(errCode, <LocationForecast>[]);
    }
    return listener;
  }

  /// Async gets forecast weather for a list of coordinates and timestamps.
  ///
  /// **Parameters**
  ///
  /// * **IN** *days* The number of days for which the forecast is requested (value should be <= 10).
  /// * **IN** *coords* The coordinates list for which the forecast is requested.
  /// * **IN** *onCompleteCallback* The callback which will be called when the operation completes.
  ///   * Will be called with [GemError.success] error and non-empty locationForecasts upon success.
  ///   * Will be called with [GemError.invalidInput] error and empty locationForecasts if the coordinates list is empty or if the number of days is negative.
  ///   * Will be called with [GemError.resourceMissing] error and empty locationForecasts if the internal engine resource is missing
  ///   * Will be called with [GemError.outOfRange] error and empty locationForecasts if number of coordinates or the number of days is greater than the maximum allowed.
  ///   * Will be called with other [GemError] values and empty locationForecasts on other errors
  ///
  /// **Returns**
  ///
  /// * [ProgressListener] for the operation progress
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static ProgressListener getDailyForecast({
    required final int days,
    required final List<Coordinates> coords,
    required final void Function(
      GemError error,
      List<LocationForecast> locationForecasts,
    ) onCompleteCallback,
  }) {
    final LocationForecastList result = LocationForecastList.create();
    final EventDrivenProgressListener listener = EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(listener.id, listener);

    listener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(listener.id);
      if (err == 0) {
        onCompleteCallback(GemErrorExtension.fromCode(err), result.getJson());
        result.dispose();
      } else {
        onCompleteCallback(
          GemErrorExtension.fromCode(err),
          <LocationForecast>[],
        );
      }
    });
    final OperationResult resultString = staticMethod(
      'Weather',
      'getDailyForecast',
      args: <String, dynamic>{
        'days': days,
        'coords': coords,
        'result': result.id,
        'listener': listener.id,
      },
    );
    final GemError errCode = GemErrorExtension.fromCode(resultString['result']);
    if (errCode != GemError.success) {
      onCompleteCallback(errCode, <LocationForecast>[]);
    }
    return listener;
  }

  /// Cancel an async operation
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener* Operation progress listener.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void cancel(final ProgressListener listener) {
    staticMethod(
      'Weather',
      'cancel',
      args: <String, dynamic>{'listener': listener.id},
    );
  }

  /// Get limit of number of coordinates per request
  ///
  /// **Returns**
  ///
  /// * The maximum number of coordinates that can be requested in a single call.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static int get maxCoordinatesPerRequest {
    final OperationResult retString = staticMethod(
      'Weather',
      'getMaxCoordinatesPerRequest',
    );
    return retString['result'];
  }

  /// Get limits of number of days per request
  ///
  /// **Returns**
  ///
  /// * The maximum number of days that can be requested in a single call to [getDailyForecast].
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static int get maxDayForDailyForecast {
    final OperationResult retString = staticMethod(
      'Weather',
      'getMaxDayForDailyForecast',
    );

    return retString['result'];
  }

  /// Get limits of number of hours per request
  ///
  /// **Returns**
  ///
  /// * The maximum number of hours that can be requested in a single call to [getHourlyForecast].
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static int get maxHoursForHourlyForecast {
    final OperationResult retString = staticMethod(
      'Weather',
      'getMaxHoursForHourlyForecast',
    );
    return retString['result'];
  }

  /// Get the transfer statistics
  ///
  /// **Returns**
  ///
  /// * The transfer statistics
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static TransferStatistics get transferStatistics {
    final OperationResult resultString = objectMethod(
      0,
      'Weather',
      'getTransferStatistics',
    );

    return TransferStatistics.init(resultString['result']);
  }
}

/// Coordinates with duration
///
/// {@category Weather}
class WeatherDurationCoordinates {
  WeatherDurationCoordinates({
    required this.coordinates,
    required this.duration,
  });

  /// Coordinates where the duration is requested
  final Coordinates coordinates;

  /// The delay between the current time and the requested time
  final Duration duration;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['coords'] = coordinates;
    // Internally uses the same structure as TimeDistanceCoordinate.toJson()
    json['distance'] = 0;
    json['stamp'] = duration.inSeconds;
    return json;
  }
}

/// Weather parameter data
///
/// {@category Weather}
class Parameter {
  Parameter({
    required this.type,
    required this.value,
    required this.name,
    required this.unit,
  });

  factory Parameter.fromJson(final Map<String, dynamic> json) {
    return Parameter(
      type: json['type'],
      value: json['value'],
      name: json['name'],
      unit: json['unit'],
    );
  }

  /// Type. Check [PredefinedParameterTypeValues] for possible values
  String type;

  /// Value
  double value;

  /// Name translated according to the current SDK language
  String name;

  /// Unit
  String unit;
}

/// Weather conditions for a given timestamp
///
/// {@category Weather}
class Conditions {
  Conditions({
    required this.type,
    required this.stamp,
    required this.description,
    required this.daylight,
    required this.params,
    required this.img,
  });

  factory Conditions.fromJson(final Map<String, dynamic> json) {
    return Conditions(
      type: json['type'],
      stamp: DateTime.fromMillisecondsSinceEpoch(json['stamp'], isUtc: true),
      description: json['description'],
      daylight: DaylightExtension.fromId(json['daylight']),
      params: (json['params'] as List<dynamic>)
          .map((final dynamic categoryJson) => Parameter.fromJson(categoryJson))
          .toList(),
      img: Img.init(json['img']),
    );
  }

  /// Type. For possible values see [PredefinedParameterTypeValues]
  String type;

  /// Datetime for condition (UTC).
  DateTime stamp;

  /// Image representation
  Uint8List get image => img.getRenderableImageBytes()!;

  /// Description translated according to the current SDK language
  String description;

  /// Daylight condition
  Daylight daylight;

  /// Parameter list
  List<Parameter> params;

  /// The conditions image
  Img img;
}

/// Weather forecast for a given geographic location
///
/// {@category Weather}
class LocationForecast {
  LocationForecast({
    required this.updated,
    required this.coord,
    required this.forecast,
  });

  factory LocationForecast.fromJson(final Map<String, dynamic> json) {
    return LocationForecast(
      updated: DateTime.fromMillisecondsSinceEpoch(
        json['updated'],
        isUtc: true,
      ),
      coord: Coordinates.fromJson(json['coord']),
      forecast: (json['forecast'] as List<dynamic>)
          .map(
            (final dynamic categoryJson) => Conditions.fromJson(categoryJson),
          )
          .toList(),
    );
  }

  /// Forecast update datetime (UTC).
  DateTime updated;

  /// Geographic location
  Coordinates coord;

  /// Forecast data
  List<Conditions> forecast;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['updated'] = updated.millisecondsSinceEpoch;
    json['coord'] = coord;
    json['forecast'] = forecast;
    return json;
  }
}

/// Common values for [Parameter.type]
///
/// Note: Not all parameters are applicable to every type of forecast.
///
/// {@category Weather}
abstract class PredefinedParameterTypeValues {
  /// Air quality
  ///
  /// Example:
  ///   * [Parameter.value] = 8
  ///   * [Parameter.unit] = ''
  static const String airQuality = 'AirQuality';

  /// Dew point
  ///
  /// Example:
  ///   * [Parameter.value] = 10
  ///   * [Parameter.unit] = '°C'
  static const String dewPoint = 'DewPoint';

  /// Feels like
  ///
  /// Example:
  ///   * [Parameter.value] = 10
  ///   * [Parameter.unit] = '°C'
  static const String feelsLike = 'FeelsLike';

  /// Humidity
  ///
  /// Example:
  ///   * [Parameter.value] = 50
  ///   * [Parameter.unit] = '%'
  static const String humidity = 'Humidity';

  /// Humidity
  ///
  /// Example:
  ///   * [Parameter.value] = 51010
  ///   * [Parameter.unit] = 'mb'
  static const String pressure = 'Pressure';

  /// Sunrise
  ///
  /// Example:
  ///   * [Parameter.value] = 1699027963 (UNIX timestamp - seconds after 1 Jan 1970)
  ///   * [Parameter.unit] = ''
  static const String sunRise = 'Sunrise';

  /// Sunset
  ///
  /// Example:
  ///   * [Parameter.value] = 1699027963 (UNIX timestamp - seconds after 1 Jan 1970)
  ///   * [Parameter.unit] = ''
  static const String sunSet = 'Sunset';

  /// Temperature
  ///
  /// Example:
  ///   * [Parameter.value] = 14
  ///   * [Parameter.unit] = '°C'
  static const String temperature = 'Temperature';

  /// UV index
  ///
  /// Example:
  ///   * [Parameter.value] = 8
  ///   * [Parameter.unit] = ''
  static const String uv = 'UV';

  /// Visibility
  ///
  /// Example:
  ///   * [Parameter.value] = 10
  ///   * [Parameter.unit] = 'km'
  static const String visibility = 'Visibility';

  /// Wind direction
  ///
  /// Example:
  ///   * [Parameter.value] = 0 (0 = North, 90 = East, 180 = South, 270 = West)
  ///   * [Parameter.unit] = '°'
  static const String windDirection = 'WindDirection';

  /// Wind speed
  ///
  /// Example:
  ///   * [Parameter.value] = 15
  ///   * [Parameter.unit] = 'km/h'
  static const String windSpeed = 'WindSpeed';

  /// Low
  ///
  /// Example:
  ///   * [Parameter.value] = -5
  ///   * [Parameter.unit] = '°C'
  static const String temperatureLow = 'TemperatureLow';

  /// High
  ///
  /// Example:
  ///   * [Parameter.value] = 25
  ///   * [Parameter.unit] = '°C'
  static const String temperatureHigh = 'TemperatureHigh';
}
