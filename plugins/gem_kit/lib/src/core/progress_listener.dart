// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'package:meta/meta.dart';

/// Interface for implementing progress of async operations (routing, search)
///
/// {@category Core}
abstract class ProgressListener {
  /// Called when the operation is completed
  ///
  /// **Parameters**
  ///
  /// * **IN** *err* The error code
  /// * **IN** *hint* Additional information about the completion
  /// * **IN** *json* Additional data for the completion
  void registerOnCompleteWithDataCallback(
    final void Function(int err, String hint, Map<dynamic, dynamic> json)
        callback,
  );

  /// Called when the progress is updated with the progress on requested operation
  ///
  /// Parameter value will be between 0 and the value returned by [progressMultiplier].
  ///
  /// **Parameters**
  ///
  /// * **IN** *progress* The progress value
  void registerOnProgressCallback(final void Function(int progress) callback);

  /// Called if the status of the operation is changed.
  ///
  /// **Parameters**
  ///
  /// * **IN** *status* The new status
  void registerOnNotifyStatusChanged(final void Function(int status) callback);

  /// Get the progress multiplier.
  ///
  /// SDK uses floating point values in the 0, 1 closed interval for the progress on operations. The values received in the [notifyProgress] notification are integers obtained by multiplying the internal floating point value with the value returned by [progressMultiplier].
  /// By default, this function returns 100 so that the progress values that may be received will be between 0 and 100.
  ///
  /// **Returns**
  ///
  /// * The progress multiplier
  int get progressMultiplier;

  /// The interval in ms to receive progress updates
  ///
  /// SDK uses this interval to notify the progress Default is 200ms (5 times per second).
  ///
  /// **Returns**
  ///
  /// * The progress interval in milliseconds
  int get notifyProgressInterval;

  /// Sets the interval at which progress notifications are sent.
  ///
  /// The parameter specifies the duration between each progress
  /// notification. It must be a non-negative duration in milliseconds.
  /// The default value is 200ms.
  set notifyProgressInterval(final int ms);

  @internal
  void notifyProgress(final int progress);

  @internal
  void notifyStatusChanged(final int status);

  @internal
  void notifyStart(final bool hasProgress);

  @internal
  void notifyCompleteWithData(
    final int err,
    final String hint,
    final Map<dynamic, dynamic> json,
  ) {
    notifyComplete(err, hint);
  }

  @internal
  void notifyComplete(final int err, final String hint);

  int _pointerId = 0;
  dynamic get id => _pointerId;
  set id(final dynamic id) => _pointerId = id;
}
