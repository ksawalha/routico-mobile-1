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
import 'package:gem_kit/map.dart';
import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/loggers/app_logger.dart';
import 'package:logging/logging.dart';

/// Social report listener
///
/// {@category Routes & Navigation}
class SocialReportListener extends EventHandler {
  /// Creates a Social report listener and sets the callback.
  ///
  /// **Parameters**
  ///
  /// * **IN** *onReportUpdated* See [registerOnReportUpdated] for more information about usage.
  factory SocialReportListener({
    final void Function(OverlayItem item)? onReportUpdated,
  }) {
    final SocialReportListener listener = SocialReportListener._create();

    if (onReportUpdated != null) {
      listener._onReportUpdated = onReportUpdated;
    }

    return listener;
  }

  SocialReportListener.init(this.id);
  void Function(OverlayItem item)? _onReportUpdated;

  dynamic id;

  static SocialReportListener _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, Object>{
        'class': 'SocialReportListener',
        'args': <dynamic, dynamic>{},
      }),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return SocialReportListener.init(decodedVal['result']);
  }

  /// Notification called when a "comment" or "thumb" is added or when the details are updated
  ///
  /// **Parameters**
  ///
  /// * **IN** *report* The report overlay item
  void registerOnReportUpdated(
    final void Function(OverlayItem report)? onReportUpdated,
  ) {
    _onReportUpdated = onReportUpdated;
  }

  @override
  FutureOr<void> dispose() {}

  @override
  void handleEvent(final Map<dynamic, dynamic> arguments) {
    final String eventSubtype = arguments['event_subtype'];

    switch (eventSubtype) {
      case 'onReportUpdated':
        if (_onReportUpdated != null) {
          final OverlayItem report = OverlayItem.init(
            arguments['report'],
          );
          _onReportUpdated!(report);
        }

      default:
        gemSdkLogger.log(
          Level.WARNING,
          'Unknown event subtype: $eventSubtype in SocialReportListener',
        );
    }
  }
}
