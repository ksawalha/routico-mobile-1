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
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/sense/logupload_listener.dart';

/// Uploads a .gm or .mp4 recording to the Magic Lane servers.
/// Used for bug reports.
///
/// {@category Core}
class LogUploader extends GemAutoreleaseObject {
  /// Log uploader constructor
  ///
  /// **Parameters**
  ///
  /// * **IN** *onLogStatusChangedCallback* Callback to be called when the log status changes.
  ///   * **IN** *error*	The error code of the upload
  ///   * **IN** *logPath*	The path to the log file to upload
  ///   * **IN** *status*	The status of the log upload
  ///   * **IN** *progress*	The progress of the log upload
  ///
  /// If the upload is successful, the error code will be [GemError.success]. It it will be different from [GemError.success] status and progress will be null.
  LogUploader({
    required final void Function(
      GemError error,
      String logPath,
      LogUploaderState? status,
      int? progress,
    ) onLogStatusChangedCallback,
  }) {
    _logUploadListener = LogUploadListener(
      onLogStatusChangedCallback:
          (final String logPath, final int status, final int progress) {
        if (status < 0) {
          onLogStatusChangedCallback(
            GemErrorExtension.fromCode(status),
            logPath,
            null,
            null,
          );
        }
        onLogStatusChangedCallback(
          GemError.success,
          logPath,
          LogUploaderStateExtension.fromId(status),
          progress,
        );
      },
    );
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, Object>{
        'class': 'LogUploader',
        'args': _logUploadListener.pointerId,
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    _pointerId = decodedVal['result'];

    GemKitPlatform.instance.registerEventHandler(
      _logUploadListener.pointerId,
      _logUploadListener,
    );

    super.registerAutoReleaseObject(_pointerId);
  }
  late LogUploadListener _logUploadListener;
  dynamic _pointerId;

  /// Start an upload operation
  ///
  /// Events about this operation are notified via the callback method given at [LogUploader] creation.
  ///
  /// **Parameters**
  ///
  /// * **IN** *logPath*	The path to the log file to upload
  /// * **IN** *userName*	The user name to associate with the log
  /// * **IN** *userMail*	The user email to associate with the log
  /// * **IN** *details*	Additional details to associate with the log
  /// * **IN** *externalFiles*	List of paths to external files to upload with the log
  ///
  /// **Returns**
  ///
  /// * [GemError.success] On success.
  /// * [GemError.required] If the email was not provided.
  /// * [GemError.internalAbort] If the updater could not be initialized.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError upload({
    required final String logPath,
    required final String userName,
    required final String userMail,
    final String details = '',
    final List<String> externalFiles = const <String>[],
  }) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogUploader',
      'upload',
      args: <String, Object>{
        'logPath': logPath,
        'userName': userName,
        'userMail': userMail,
        'details': details,
        'externalFiles': externalFiles,
      },
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }

  /// Cancel an upload operation
  ///
  /// Events about this operation are notified via the callback method given at [LogUploader] creation.
  ///
  /// **Parameters**
  ///
  /// * **IN** *logPath*	The path to the log file to upload
  ///
  /// **Returns**
  ///
  /// * [GemError.success] On success.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError cancel({required final String logPath}) {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'LogUploader',
      'cancel',
      args: logPath,
    );

    return GemErrorExtension.fromCode(resultString['result']);
  }
}
