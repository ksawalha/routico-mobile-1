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

import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/lists.dart';
import 'package:gem_kit/src/core/task_handler.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/search/search_preferences.dart';

/// Search service class
///
/// {@category Places}
abstract class SearchService {
  /// Search using text and geographic area as discriminants.
  ///
  /// **Parameters**
  ///
  /// * **IN** *textFilter* The text filter.
  /// * **IN** *referenceCoordinates* The reference position. Results will be relevant to this position.
  /// * **IN** *onCompleteCallback* Will be invoked when the search operation is completed, providing the search results and an error code.
  ///   * [GemError.success] and a non-empty list of landmarks if the search was successfully completed
  ///   * [GemError.reducedResult] and a non-empty list of landmarks if the search was successfully completed but only a subset of results were returned
  ///   * [GemError.invalidInput] if the search input is invalid, e.g. referenceCoordinates are invalids
  ///   * [GemError.cancel] if the search was canceled by the user
  ///   * [GemError.noMemory] if the search engine couldn't allocate the necessary memory for the operation
  ///   * [GemError.operationTimeout] if the search was executed on the online service and the operation took too much time to complete ( usually more than 1 min, depending on the server overload state )
  ///   * [GemError.networkFailed] if the search was executed on the online service and the operation failed due to bad network connection
  /// * **IN** *preferences* The search preferences. Optional.
  /// * **IN** *locationHint* The location hint. The search will be restricted to the provided geographic area. Optional.
  ///
  /// **Returns**
  ///
  /// * Associated [TaskHandler] for this operation if the search can be started otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler? search(
    final String textFilter,
    final Coordinates referenceCoordinates,
    final void Function(GemError err, List<Landmark> results)
        onCompleteCallback, {
    SearchPreferences? preferences,
    final RectangleGeographicArea? locationHint,
  }) {
    preferences ??= SearchPreferences();

    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
    final LandmarkList results = LandmarkList();

    progListener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);

      if (err == GemError.success.code || err == GemError.reducedResult.code) {
        onCompleteCallback(GemErrorExtension.fromCode(err), results.toList());
      } else {
        onCompleteCallback(GemErrorExtension.fromCode(err), <Landmark>[]);
      }
    });

    final String resultString = GemKitPlatform.instance.callObjectMethod(
      jsonEncode(<String, Object>{
        'id': 0,
        'class': 'SearchService',
        'method': 'search',
        'args': <String, dynamic>{
          'results': results.pointerId,
          'listener': progListener.id,
          'textFilter': textFilter,
          'referenceCoordinates': referenceCoordinates,
          'preferences': preferences.pointerId,
          if (locationHint != null) 'locationHint': locationHint,
        },
      }),
    );

    final dynamic decodedVal = jsonDecode(resultString);
    final GemError errorCode = GemErrorExtension.fromCode(decodedVal['result']);

    if (errorCode != GemError.success) {
      onCompleteCallback(errorCode, <Landmark>[]);
      return null;
    }

    return TaskHandlerImpl(progListener.id);
  }

  /// Get details for the given landmark list.
  ///
  /// The main purpose of this method is to populate the details for a landmark provided by selecting a landmark from
  /// the upper zoom level of the map. Other types of landmarks (such as the ones provided by search) are already up-to-date.
  /// Does not work with user created landmarks.
  ///
  /// **Parameters**
  ///
  /// * **IN** *results* The landmark list for which the landmarks details are searched.
  /// * **IN** *onCompleteCallback* Will be invoked when the search operation is completed, providing the error code.
  ///
  /// If the landmarks in list already have the details populated, the function will return [GemError.upToDate].
  ///   * [GemError.success] if the search was successfully completed
  ///   * [GemError.invalidated] if the landmark provided is invalid (ex: user created landmark)
  ///   * [GemError.upToDate] if the landmark already has all the details.
  ///
  /// **Returns**
  ///
  /// * Associated [TaskHandler] for this operation if the search can be started otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler? searchLandmarkDetails(
    final List<Landmark> results,
    final void Function(GemError err) onCompleteCallback,
  ) {
    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);

    progListener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);

      if (err == GemError.success.code || err == GemError.reducedResult.code) {
        onCompleteCallback(GemErrorExtension.fromCode(err));
      } else {
        onCompleteCallback(GemErrorExtension.fromCode(err));
      }
    });

    final LandmarkList resultsList = LandmarkList();
    results.forEach(resultsList.add);

    final String resultString = GemKitPlatform.instance.callObjectMethod(
      jsonEncode(<String, Object>{
        'id': 0,
        'class': 'SearchService',
        'method': 'searchLandmarkDetails',
        'args': <String, dynamic>{
          'results': resultsList.pointerId,
          'listener': progListener.id,
        },
      }),
    );

    final dynamic decodedVal = jsonDecode(resultString);
    final GemError errorCode = GemErrorExtension.fromCode(decodedVal['result']);

    if (errorCode != GemError.success) {
      onCompleteCallback(errorCode);
      return null;
    }

    return TaskHandlerImpl(progListener.id);
  }

  /// Cancel specific request identified by the task handler.
  ///
  /// **Parameters**
  ///
  /// * **IN** *taskHandler* The task handler associated with the request to be canceled.
  ///
  /// **Returns**
  ///
  /// * Associated [TaskHandler] for this operation if the search can be started otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void cancelSearch(final TaskHandler taskHandler) {
    taskHandler as TaskHandlerImpl;
    GemKitPlatform.instance.callObjectMethod(
      jsonEncode(<String, dynamic>{
        'id': 0,
        'class': 'SearchService',
        'method': 'cancelSearch',
        'args': taskHandler.id,
      }),
    );
  }

  /// Search for landmarks along the specified route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The target route.
  /// * **IN** *textFilter* The text filter. Optional.
  /// * **IN** *preferences* The search preferences. Optional.
  /// * **IN** *onCompleteCallback* Will be invoked when the search operation is completed, providing the search results and an error code.
  ///   * [GemError.success] and a non-empty list of landmarks if the search was successfully completed
  ///   * [GemError.reducedResult] and a non-empty list of landmarks if the search was successfully completed but only a subset of results were returned
  ///   * [GemError.invalidInput] if the search input is invalid, e.g. referenceCoordinates are invalids
  ///   * [GemError.cancel] if the search was canceled by the user
  ///   * [GemError.noMemory] if the search engine couldn't allocate the necessary memory for the operation
  ///   * [GemError.operationTimeout] if the search was executed on the online service and the operation took too much time to complete ( usually more than 1 min, depending on the server overload state )
  ///   * [GemError.networkFailed] if the search was executed on the online service and the operation failed due to bad network connection
  ///
  /// **Returns**
  ///
  /// * Associated [TaskHandler] for this operation if the search can be started otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler? searchAlongRoute(
    final Route route,
    final void Function(GemError err, List<Landmark> results)
        onCompleteCallback, {
    final String? textFilter,
    SearchPreferences? preferences,
  }) {
    preferences ??= SearchPreferences();

    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
    final LandmarkList results = LandmarkList();

    progListener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);

      if (err == GemError.success.code || err == GemError.reducedResult.code) {
        onCompleteCallback(GemErrorExtension.fromCode(err), results.toList());
      } else {
        onCompleteCallback(GemErrorExtension.fromCode(err), <Landmark>[]);
      }
    });

    final String resultString = GemKitPlatform.instance.callObjectMethod(
      jsonEncode(<String, Object>{
        'id': 0,
        'class': 'SearchService',
        'method': 'searchAlongRoute',
        'args': <String, dynamic>{
          'results': results.pointerId,
          'listener': progListener.id,
          'route': route.pointerId,
          if (textFilter != null) 'textFilter': textFilter,
          'preferences': preferences.pointerId,
        },
      }),
    );

    final dynamic decodedVal = jsonDecode(resultString);
    final GemError errorCode = GemErrorExtension.fromCode(decodedVal['result']);

    if (errorCode != GemError.success) {
      onCompleteCallback(errorCode, <Landmark>[]);
      return null;
    }

    return TaskHandlerImpl(progListener.id);
  }

  /// Get list of landmarks in the given geographic area.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area* The search target area.
  /// * **IN** *referenceCoordinates* The reference position. Results will be relevant to this position.
  /// * **IN** *onCompleteCallback* Will be invoked when the search operation is completed, providing the search results and an error code.
  ///   * [GemError.success] and a non-empty list of landmarks if the search was successfully completed
  ///   * [GemError.reducedResult] and a non-empty list of landmarks if the search was successfully completed but only a subset of results were returned
  ///   * [GemError.cancel] if the search was canceled by the user
  ///   * [GemError.noMemory] if the search engine couldn't allocate the necessary memory for the operation
  ///   * [GemError.operationTimeout] if the search was executed on the online service and the operation took too much time to complete ( usually more than 1 min, depending on the server overload state )
  ///   * [GemError.networkFailed] if the search was executed on the online service and the operation failed due to bad network connection
  /// * **IN** *textFilter* The optional text filter. Optional.
  /// * **IN** *preferences* The search preferences. Optional.
  ///
  /// **Returns**
  ///
  /// * Associated [TaskHandler] for this operation if the search can be started otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler? searchInArea(
    final RectangleGeographicArea area,
    final Coordinates referenceCoordinates,
    final void Function(GemError err, List<Landmark> results)
        onCompleteCallback, {
    final String textFilter = '',
    SearchPreferences? preferences,
  }) {
    preferences ??= SearchPreferences();

    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
    final LandmarkList results = LandmarkList();

    progListener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);

      if (err == GemError.success.code || err == GemError.reducedResult.code) {
        onCompleteCallback(GemErrorExtension.fromCode(err), results.toList());
      } else {
        onCompleteCallback(GemErrorExtension.fromCode(err), <Landmark>[]);
      }
    });

    final String resultString = GemKitPlatform.instance.callObjectMethod(
      jsonEncode(<String, Object>{
        'id': 0,
        'class': 'SearchService',
        'method': 'searchInArea',
        'args': <String, dynamic>{
          'results': results.pointerId,
          'listener': progListener.id,
          'textFilter': textFilter,
          'referenceCoordinates': referenceCoordinates,
          'preferences': preferences.pointerId,
          'area': area,
        },
      }),
    );

    final dynamic decodedVal = jsonDecode(resultString);
    final GemError errorCode = GemErrorExtension.fromCode(decodedVal['result']);

    if (errorCode != GemError.success) {
      onCompleteCallback(errorCode, <Landmark>[]);
      return null;
    }

    return TaskHandlerImpl(progListener.id);
  }

  /// Get list of landmarks for specific coordinates.
  ///
  /// **Parameters**
  ///
  /// * **IN** *position* The position.
  /// * **IN** *onCompleteCallback* Will be invoked when the search operation is completed, providing the search results and an error code.
  ///   * [GemError.success] and a non-empty list of landmarks if the search was successfully completed
  ///   * [GemError.reducedResult] and a non-empty list of landmarks if the search was successfully completed but only a subset of results were returned
  ///   * [GemError.invalidInput] if the search input is invalid, e.g. referenceCoordinates are invalids
  ///   * [GemError.cancel] if the search was canceled by the user
  ///   * [GemError.noMemory] if the search engine couldn't allocate the necessary memory for the operation
  ///   * [GemError.operationTimeout] if the search was executed on the online service and the operation took too much time to complete ( usually more than 1 min, depending on the server overload state )
  ///   * [GemError.networkFailed] if the search was executed on the online service and the operation failed due to bad network connection
  /// * **IN** *textFilter* The text filter. Optional.
  /// * **IN** *preferences* The search preferences. Optional.
  ///
  /// **Returns**
  ///
  /// * Associated [TaskHandler] for this operation if the search can be started otherwise null.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler? searchAroundPosition(
    final Coordinates position,
    final void Function(GemError err, List<Landmark> results)
        onCompleteCallback, {
    final String? textFilter,
    SearchPreferences? preferences,
  }) {
    preferences ??= SearchPreferences();

    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
    final LandmarkList results = LandmarkList();

    progListener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);

      if (err == GemError.success.code || err == GemError.reducedResult.code) {
        onCompleteCallback(GemErrorExtension.fromCode(err), results.toList());
      } else {
        onCompleteCallback(GemErrorExtension.fromCode(err), <Landmark>[]);
      }
    });

    final String resultString = GemKitPlatform.instance.callObjectMethod(
      jsonEncode(<String, Object>{
        'id': 0,
        'class': 'SearchService',
        'method': 'searchAroundPosition',
        'args': <String, dynamic>{
          'results': results.pointerId,
          'listener': progListener.id,
          'position': position,
          if (textFilter != null) 'textFilter': textFilter,
          'preferences': preferences.pointerId,
        },
      }),
    );

    final dynamic decodedVal = jsonDecode(resultString);
    final GemError errorCode = GemErrorExtension.fromCode(decodedVal['result']);

    if (errorCode != GemError.success) {
      onCompleteCallback(errorCode, <Landmark>[]);
      return null;
    }

    return TaskHandlerImpl(progListener.id);
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
      'SearchService',
      'getTransferStatistics',
    );

    return TransferStatistics.init(resultString['result']);
  }
}
