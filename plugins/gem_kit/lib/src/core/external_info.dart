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
import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/core/holders.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Service for creating [ExternalInfo] objects
///
/// {@category Places}
abstract class ExternalInfoService {
  /// Checks if the landmark has Wikipedia info
  ///
  /// Requests all the wikipedia info at once (page title/url, page summary, and list of pictures - only urls of the pictures) - returns true if request successfully made, false if something went wrong.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmark* [Landmark] for which the check will be done.
  ///
  /// **Returns**
  ///
  /// * True if the landmark has Wikipedia info, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static bool hasWikiInfo(Landmark landmark) {
    return _checkWikiInfo(landmark).$1;
  }

  static (bool, ExternalInfo) _checkWikiInfo(Landmark landmark) {
    final ExternalInfo externalInfo = ExternalInfo._create();
    final OperationResult resultString = objectMethod(
      externalInfo.pointerId,
      'ExternalInfo',
      'hasWikiInfo',
      args: landmark.pointerId,
    );

    return (resultString['result'], externalInfo);
  }

  /// Requests Wikipedia info for a landmark
  ///
  /// The result will be provided as a [ExternalInfo] object
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmark* [Landmark] for which the request will be done.
  /// * **IN** *onWikiDataAvailable*  callback to be triggered after the wikipedia request is done.
  ///   * It will be called with [GemError.success] and the external info object on success.
  ///   * It will be called with [GemError.invalidInput] error and null info if the landmark does not have Wikipedia info
  ///   * It will be called with [GemError.connection] error and null info if connection is not available or restricted
  ///   * It will be called with [GemError.notFound] error and null info if wikipedia info is not found for the landmark
  ///   * It will be called with [GemError.general] error and null info on other errors
  ///
  /// **Returns**
  ///
  /// * An [EventHandler] that can be used to cancel the request.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static EventHandler? requestWikiInfo(
    Landmark landmark, {
    required void Function(GemError err, ExternalInfo? extraInfo) onComplete,
  }) {
    final (bool hasWikiInfo, ExternalInfo externalInfo) = _checkWikiInfo(
      landmark,
    );
    if (!hasWikiInfo) {
      onComplete(GemError.invalidInput, null);
      return null;
    }

    final ExternalInfoHandler wikiListener = ExternalInfoHandler(
      externalInfo: externalInfo,
    );

    wikiListener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(wikiListener.id);
      final GemError error = GemErrorExtension.fromCode(err);
      if (error == GemError.success) {
        onComplete(error, externalInfo);
      } else {
        onComplete(error, null);
      }
    });
    GemKitPlatform.instance.registerEventHandler(wikiListener.id, wikiListener);

    Future<void>.delayed(const Duration(milliseconds: 100), () async {
      for (int i = 0; i < 30; i++) {
        if (externalInfo.wikiPageUrl.isNotEmpty) {
          break;
        }

        await Future<void>.delayed(const Duration(milliseconds: 50));
      }

      objectMethod(
        externalInfo.pointerId,
        'ExternalInfo',
        'requestWikiInfo',
        args: <String, dynamic>{
          'first': landmark.pointerId,
          'second': wikiListener.id,
        },
      );
    });

    return wikiListener;
  }

  /// Cancel a Wikipedia request for any reason.
  ///
  /// **Parameters**
  ///
  /// * **IN** *operationHandler* [EventHandler] to cancel.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void cancelWikiInfo(EventHandler operationHandler) {
    if (operationHandler is! ExternalInfoHandler) {
      ApiErrorServiceImpl.apiErrorAsInt = -1;
      return;
    }

    operationHandler.cancelWikiInfo();
  }
}

/// ExternalInfo object
///
/// Provides wikipedia information for a landmark.
///
/// This class can't be instantiated directly. Instead, use the [ExternalInfoService.requestWikiInfo] method to obtain an instance via the callback.
///
/// {@category Places}
class ExternalInfo extends GemAutoreleaseObject {
  @internal
  ExternalInfo.init(final int id, final int mapId)
      : _pointerId = id,
        _mapId = mapId {
    super.registerAutoReleaseObject(_pointerId);
  }
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  static ExternalInfo _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'ExternalInfo'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    final ExternalInfo retVal = ExternalInfo.init(decodedVal['result'], 0);
    return retVal;
  }

  /// Get Wikipedia image description directly, without notifier.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Index of the image to get the description of.
  ///
  /// **Returns**
  ///
  /// * The image description if the index is valid, empty string otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String getWikiImageDescription(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ExternalInfo',
      'getWikiImageDescription',
      args: index,
    );

    return resultString['result'];
  }

  /// Get the count of the images on the Wikipedia page.
  ///
  /// **Returns**
  ///
  /// * The count of the images on the Wikipedia page
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  @Deprecated('Use imagesCount instead.')
  int getWikiImagesCount() {
    return imagesCount;
  }

  /// Get the count of the images on the Wikipedia page.
  ///
  /// **Returns**
  ///
  /// * The count of the images on the Wikipedia page
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get imagesCount {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ExternalInfo',
      'getWikiImagesCount',
    );

    return resultString['result'];
  }

  /// Get Wikipedia image title directly, without notifier.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Index of the image to get the title of.
  ///
  /// **Returns**
  ///
  /// * The image title if the index is valid, empty string otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String getWikiImageTitle(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ExternalInfo',
      'getWikiImageTitle',
      args: index,
    );

    return resultString['result'];
  }

  /// Get Wikipedia image URL directly, without notifier.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Index of the image to get the URL of.
  ///
  /// **Returns**
  ///
  /// * The image URL if the index is valid, empty string otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String getWikiImageUrl(final int index) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ExternalInfo',
      'getWikiImageURL',
      args: index,
    );

    return resultString['result'];
  }

  /// Get Wikipedia page summary (text).
  ///
  /// **Returns**
  ///
  /// * The Wikipedia page summary
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  @Deprecated('Use wikiPageDescription instead.')
  String getWikiPageDescription() {
    return wikiPageDescription;
  }

  /// Get Wikipedia page summary (text).
  ///
  /// **Returns**
  ///
  /// * The Wikipedia page summary
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get wikiPageDescription {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ExternalInfo',
      'getWikiPageDescription',
    );

    return resultString['result'];
  }

  /// Get Wikipedia page language.
  ///
  /// **Returns**
  ///
  /// * The Wikipedia page language
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  @Deprecated('Use wikiPageLanguage instead.')
  String getWikiPageLanguage() {
    return wikiPageLanguage;
  }

  /// Get Wikipedia page language.
  ///
  /// **Returns**
  ///
  /// * The Wikipedia page language
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get wikiPageLanguage {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ExternalInfo',
      'getWikiPageLanguage',
    );

    return resultString['result'];
  }

  /// Get Wikipedia page title.
  ///
  /// Get the Wikipedia page title in the requested language.
  ///
  /// **Returns**
  ///
  /// * The Wikipedia page title
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  @Deprecated('Use wikiPageTitle instead.')
  String getWikiPageTitle() {
    return wikiPageTitle;
  }

  /// Get Wikipedia page title.
  ///
  /// Get the Wikipedia page title in the requested language.
  ///
  /// **Returns**
  ///
  /// * The Wikipedia page title
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get wikiPageTitle {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ExternalInfo',
      'getWikiPageTitle',
    );

    return resultString['result'];
  }

  /// Get Wikipedia page URL.
  ///
  /// **Returns**
  ///
  /// * The Wikipedia page URL
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  @Deprecated('Use wikiPageUrl instead.')
  String getWikiPageUrl() {
    return wikiPageUrl;
  }

  /// Get Wikipedia page URL.
  ///
  /// **Returns**
  ///
  /// * The Wikipedia page URL
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  String get wikiPageUrl {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'ExternalInfo',
      'getWikiPageURL',
    );

    return resultString['result'];
  }

  /// Get info on one Wikipedia image.
  ///
  /// **Parameters**
  ///
  /// * **IN** *imageId* The image index
  /// * **IN** *onComplete* Callback to be called when the request is completed
  ///   * It will be called with [GemError.success] and the image info on success.
  ///   * It will be called with [GemError.general] error and null on invalid input
  ///
  /// **Returns**
  ///
  /// * [ProgressListener] for the operation progress if it could be started, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  ProgressListener? requestWikiImageInfo({
    required int imageIndex,
    required void Function(GemError error, String? imageInfo) onComplete,
  }) {
    final StringHolder result = StringHolder();
    final EventDrivenProgressListener listener = EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(listener.id, listener);

    listener.registerOnCompleteWithDataCallback((
      final int err,
      final String hint,
      final Map<dynamic, dynamic> json,
    ) {
      GemKitPlatform.instance.unregisterEventHandler(listener.id);
      if (err == 0) {
        onComplete(GemErrorExtension.fromCode(err), result.value);
      } else {
        onComplete(GemErrorExtension.fromCode(err), null);
      }
      result.dispose();
    });

    objectMethod(
      _pointerId,
      'ExternalInfo',
      'requestWikiImageInfo',
      args: <String, dynamic>{
        'progressListener': listener.id,
        'nImageIdx': imageIndex,
        'strImageInfo': result.pointerId,
      },
    );

    final GemError err = ApiErrorService.apiError;
    if (err != GemError.success) {
      GemKitPlatform.instance.unregisterEventHandler(listener.id);
      onComplete(err, null);
      return null;
    }

    return listener;
  }

  /// Cancel a specific Wikipedia image info request via [requestWikiImageInfo].
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener* [ProgressListener] to cancel
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  void cancelWikiImageInfoRequest(ProgressListener listener) {
    staticMethod(
      'ExternalInfo',
      'cancelWikiImageInfoRequest',
      args: listener.id,
    );
  }
}
