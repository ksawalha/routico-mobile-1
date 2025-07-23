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
import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/map/overlays.dart';
import 'package:gem_kit/src/routing/social_report_listener.dart';
import 'package:meta/meta.dart';

/// Social Overlays allows the reporting and retrieval of social events
///
/// {@category Routes & Navigation}
abstract class SocialOverlay {
  /// Report a social event.
  ///
  /// **Parameters**
  ///
  /// * **IN** *prepareId* Prepared report operation id ( returned by a call to [prepareReporting] )
  /// * **IN** *categId* Report category id
  /// * **IN** *description* Report description text
  /// * **IN** *snapshot* Report snapshot image
  /// * **IN** *format* Report snapshot image format
  /// * **IN** *params* Report parameters. They must follow the structure returned by
  /// `SocialReportsOverlayCategory.parameters.find(PredefinedOverlayGenericParametersIds.keyVals)`
  /// * **IN** *onComplete* callback to be called when the request is completed with the error code:
  ///   * [GemError.invalidInput] - categId is not a valid social report category id / params are ill-formed / snapshot is an invalid image
  ///   * [GemError.suspended] - report rate limit exceeded
  ///   * [GemError.expired] - prepared report id not found or is expired ( too old )
  ///   * [GemError.notFound] - no accurate sense data source position to complete
  ///   * [GemError.success] - report submitted successfully
  ///
  /// **Returns**
  ///
  /// * The operation progress listener if the operation could be started, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static EventHandler? report({
    required final int prepareId,
    required final int categId,
    final String description = '',
    final Uint8List? snapshot,
    final ImageFileFormat? format,
    final ParameterList? params,
    final void Function(GemError error)? onComplete,
  }) {
    if ((snapshot == null) != (format == null)) {
      onComplete?.call(GemError.invalidInput);
      return null;
    }

    dynamic gemImage;
    if (snapshot != null) {
      gemImage = GemKitPlatform.instance.createGemImage(
        snapshot,
        format!.id,
      );
    }
    try {
      final EventDrivenProgressListener progListener =
          EventDrivenProgressListener();
      GemKitPlatform.instance.registerEventHandler(
        progListener.id,
        progListener,
      );

      progListener.registerOnCompleteWithDataCallback((final int err, _, __) {
        GemKitPlatform.instance.unregisterEventHandler(progListener.id);
        onComplete?.call(GemErrorExtension.fromCode(err));
      });

      final OperationResult result = staticMethod(
        'SocialOverlay',
        'report',
        args: <String, dynamic>{
          'prepareId': prepareId,
          'categId': categId,
          'description': description,
          'snapshot': gemImage ?? 0,
          'params': params != null ? params.pointerId : 0,
          'listener': progListener.id,
        },
      );
      final int id = result['result'];
      final GemError error = GemErrorExtension.fromCode(id);

      if (error != GemError.scheduled) {
        GemKitPlatform.instance.unregisterEventHandler(progListener.id);
        onComplete?.call(error);
        return null;
      }

      return progListener;
    } finally {
      if (gemImage != null) {
        GemKitPlatform.instance.deleteCPointer(gemImage);
      }
    }
  }

  /// Prepare reporting based on custom coordinates
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* Report coordinates
  /// * **IN** *categId* Report category id, default = 0. If != 0, a dry run test is performed to check if the given category id can be reported.
  ///
  /// **Returns if in dry run mode ( category id != 0 )**
  ///
  /// * [GemError.suspended].id report rate limit exceeded
  /// * [GemError.invalidInput].id  categId id not a valid social report category id
  /// * [GemError.accessDenied].id social report overlay category doesn't allow custom coordinates reporting, call prepareReporting with DataSource instead
  ///
  /// **Returns if in preparing run mode ( category id == 0 )**
  ///
  /// * [GemError.suspended].id report rate limit exceeded
  /// * value > 0 the prepared operation id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static int prepareReportingCoords(
    final Coordinates coords, {
    final int categId = 0,
  }) {
    final OperationResult result = staticMethod(
      'SocialOverlay',
      'prepareReportingCoords',
      args: <String, dynamic>{'coords': coords, 'categId': categId},
    );
    return result['result'];
  }

  /// Prepare reporting based on the current datasource used by [PositionService]
  ///
  /// **Parameters**
  ///
  /// * **IN** *categId* Report category id, default = 0. If != 0, a dry run test is performed to check if the given category id can be reported.
  ///
  /// **Returns if in dry run mode ( category id != 0 )**
  ///
  /// * [GemError.suspended].id report rate limit exceeded
  /// * [GemError.invalidInput].id  categId id not a valid social report category id
  /// * [GemError.notFound].id no valid data source position for reporting
  /// * [GemError.required].id no valid data source type for reporting, must be DataSourceType.live
  ///
  /// **Returns if preparing mode ( category id == 0 )**
  ///
  /// * [GemError.suspended].id report rate limit exceeded
  /// * [GemError.notFound].id no valid data source position for reporting
  /// * value > 0 the prepared operation id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static int prepareReporting({final int categId = 0}) {
    final OperationResult result = staticMethod(
      'SocialOverlay',
      'prepareReporting',
      args: <String, dynamic>{'categId': categId},
    );
    return result['result'];
  }

  /// Confirm an existing report as in effect.
  ///
  /// **Parameters**
  ///
  /// * **IN** *item* The report overlay item
  /// * **IN** *onComplete* Callback to be called when the request is completed, provides the error code:
  ///   * [GemError.invalidInput] - invalid item ( not a social report overlay item ) or item is not a result of alarm notification
  ///   * [GemError.accessDenied] - already confirmed or denied
  ///   * [GemError.success] - report confirmed
  ///
  /// **Returns**
  ///
  /// * The operation handler if the operation could be started, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static EventHandler? confirmReport(
    final OverlayItem item, {
    final void Function(GemError error)? onComplete,
  }) {
    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);

    progListener.registerOnCompleteWithDataCallback((final int err, _, __) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);
      onComplete?.call(GemErrorExtension.fromCode(err));
    });

    final OperationResult result = staticMethod(
      'SocialOverlay',
      'confirmReport',
      args: <String, dynamic>{
        'item': item.pointerId,
        'listener': progListener.id,
      },
    );

    final GemError errorCode = GemErrorExtension.fromCode(result['result']);

    if (errorCode != GemError.scheduled) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);
      onComplete?.call(errorCode);
      return null;
    }

    return progListener;
  }

  /// Deny an existing report as not in effect anymore.
  ///
  /// **Parameters**
  ///
  /// * **IN** *item* The report overlay item
  /// * **IN** *onComplete* Callback to be called when the request is completed, provides the error code:
  ///   * [GemError.invalidInput] - invalid item ( not a social report overlay item ) or item is not a result of alarm notification
  ///   * [GemError.accessDenied] - already confirmed or denied
  ///   * [GemError.success] - report denied
  ///
  /// **Returns**
  ///
  /// * The operation handler if the operation could be started, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static EventHandler? denyReport(
    final OverlayItem item, {
    final void Function(GemError error)? onComplete,
  }) {
    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);

    progListener.registerOnCompleteWithDataCallback((final int err, _, __) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);
      onComplete?.call(GemErrorExtension.fromCode(err));
    });

    final OperationResult result = staticMethod(
      'SocialOverlay',
      'denyReport',
      args: <String, dynamic>{
        'item': item.pointerId,
        'listener': progListener.id,
      },
    );

    final GemError errorCode = GemErrorExtension.fromCode(result['result']);

    if (errorCode != GemError.scheduled) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);
      onComplete?.call(errorCode);
      return null;
    }

    return progListener;
  }

  /// Delete an owned report.
  ///
  /// **Parameters**
  ///
  /// * **IN** *item* The report overlay item
  /// * **IN** *onComplete* Callback to be called when the request is completed, provides the error code:
  ///   * [GemError.invalidInput] - invalid item ( not a social report overlay item ) or item is not a result of alarm notification
  ///   * [GemError.accessDenied] - already confirmed or denied
  ///   * [GemError.success] - report deleted
  ///
  /// **Returns**
  ///
  /// * The operation handler if the operation could be started, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static EventHandler? deleteReport(
    final OverlayItem item, {
    final void Function(GemError error)? onComplete,
  }) {
    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);

    progListener.registerOnCompleteWithDataCallback((final int err, _, __) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);
      onComplete?.call(GemErrorExtension.fromCode(err));
    });

    final OperationResult result = staticMethod(
      'SocialOverlay',
      'deleteReport',
      args: <String, dynamic>{
        'item': item.pointerId,
        'listener': progListener.id,
      },
    );

    final GemError errorCode = GemErrorExtension.fromCode(result['result']);

    if (errorCode != GemError.scheduled) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);
      onComplete?.call(errorCode);
      return null;
    }

    return progListener;
  }

  /// Update an existing report parameters.
  ///
  /// **Parameters**
  ///
  /// * **IN** *item* The report overlay item
  /// * **IN** *params* Report parameters. They must follow the structure returned by
  /// `SocialReportsOverlayCategory.parameters.find(PredefinedOverlayGenericParametersIds.keyVals)`
  /// * **IN** *onComplete* Callback to be called when the request is completed, provides the error code:
  ///   * [GemError.invalidInput] - invalid item ( not a social report overlay item ) or parameters are ill formatted
  ///   * [GemError.success] - report updated
  ///
  /// **Returns**
  ///
  /// * The operation handler if the operation could be started, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static EventHandler? updateReport({
    required final OverlayItem item,
    required final SearchableParameterList params,
    void Function(GemError error)? onComplete,
  }) {
    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);

    progListener.registerOnCompleteWithDataCallback((final int err, _, __) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);
      onComplete?.call(GemErrorExtension.fromCode(err));
    });

    final OperationResult result = staticMethod(
      'SocialOverlay',
      'updateReport',
      args: <String, dynamic>{
        'item': item.pointerId,
        'listener': progListener.id,
        'params': params.pointerId,
      },
    );

    final GemError error = GemErrorExtension.fromCode(result['result']);
    if (error != GemError.scheduled) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);
      onComplete?.call(error);
      return null;
    }

    return progListener;
  }

  /// Add a comment to report.
  ///
  /// **Parameters**
  ///
  /// * **IN** *item* The report overlay item
  /// * **IN** *comment* The comment
  /// * **IN** *onComplete* Callback to be called when the request is completed, provides the error code:
  ///   * [GemError.invalidInput] - invalid item ( not a social report overlay item ) or item is not a result of alarm notification
  ///   * [GemError.connectionRequired] - no internet connection available
  ///   * [GemError.busy] - another add comment operation is in progress
  ///   * [GemError.success] - comment added
  ///
  /// **Returns**
  ///
  /// * The operation handler if the operation could be started, null otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static EventHandler? addComment({
    required final OverlayItem item,
    required final String comment,
    void Function(GemError error)? onComplete,
  }) {
    final EventDrivenProgressListener progListener =
        EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);

    progListener.registerOnCompleteWithDataCallback((final int err, _, __) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);
      onComplete?.call(GemErrorExtension.fromCode(err));
    });

    final OperationResult result = staticMethod(
      'SocialOverlay',
      'addComment',
      args: <String, dynamic>{
        'item': item.pointerId,
        'comment': comment,
        'listener': progListener.id,
      },
    );

    final GemError error = GemErrorExtension.fromCode(result['result']);
    if (error != GemError.scheduled) {
      GemKitPlatform.instance.unregisterEventHandler(progListener.id);
      onComplete?.call(error);
      return null;
    }

    return progListener;
  }

  /// Cancel an Social Overlay operation.
  ///
  /// **Parameters**
  ///
  /// * **IN** *handler* The operation handler
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static void cancel(EventHandler handler) {
    staticMethod(
      'SocialOverlay',
      'cancel',
      args: (handler as ProgressListener).id,
    );
  }

  /// Get social reports overlay info.
  ///
  /// **Returns**
  ///
  /// * [SocialReportsOverlayInfo] - social reports overlay info
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static SocialReportsOverlayInfo get reportsOverlayInfo {
    final OperationResult result = staticMethod(
      'SocialOverlay',
      'getReportsOverlayInfo',
    );

    return SocialReportsOverlayInfo.init(result['result']);
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
      'SocialOverlay',
      'getTransferStatistics',
    );

    return TransferStatistics.init(resultString['result']);
  }

  /// Register the given listener for the given report item
  ///
  /// **Parameters**
  ///
  /// * **IN** *report* The report overlay item
  /// * **IN** *listener* The listener
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.invalidInput] if the report does not belong to Social Reports Overlay
  /// * [GemError.exist] if the listener is already registered for the report
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static GemError registerReportListener(
    OverlayItem report,
    SocialReportListener listener,
  ) {
    GemKitPlatform.instance.registerEventHandler(
      listener.id,
      listener,
    );

    final OperationResult res = staticMethod(
      'SocialOverlay',
      'registerReportListener',
      args: <String, dynamic>{
        'first': report.pointerId,
        'second': listener.id,
      },
    );

    return GemErrorExtension.fromCode(res['result']);
  }

  /// Unregister the given listener for the given report item
  ///
  /// **Parameters**
  ///
  /// * **IN** *report* The report overlay item
  /// * **IN** *listener* The listener
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  /// * [GemError.invalidInput] if the report does not belong to Social Reports Overlay
  /// * [GemError.notFound] if the listener is not registered for the report
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static GemError unregisterReportListener(
    OverlayItem report,
    SocialReportListener listener,
  ) {
    final OperationResult res = staticMethod(
      'SocialOverlay',
      'unregisterReportListener',
      args: <String, dynamic>{
        'first': report.pointerId,
        'second': listener.id,
      },
    );

    return GemErrorExtension.fromCode(res['result']);
  }
}

/// Social reports overlay category provides information about social reports categories
///
/// This class should not be instantiated directly. Instead, use the [SocialOverlay.reportsOverlayInfo] getter to obtain an instance.
///
/// {@category Routes & Navigation}
class SocialReportsOverlayInfo extends OverlayInfo {
  @internal
  SocialReportsOverlayInfo.init(super.id) : super.init();

  /// Get categories list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *country* The country ISO code for which the list is retrieved. Use empty String for generic country
  ///
  /// **Returns**
  ///
  /// * The list of categories
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<SocialReportsOverlayCategory> getSocialReportsCategories({
    final String country = '',
  }) {
    final OperationResult operationResult = objectMethod(
      pointerId,
      'SocialReportsOverlayInfo',
      'getSocialReportsCategories',
      args: country,
    );

    final List<dynamic> list = operationResult['result'];
    return list
        .map(
          (final dynamic categoryJson) =>
              SocialReportsOverlayCategory.fromJson(categoryJson),
        )
        .toList();
  }

  /// Get the overlay category by id
  ///
  /// **Parameters**
  ///
  /// * **IN** *categId* The category id
  /// * **IN** *country* The country ISO code for which the list is retrieved. Use empty String for generic country
  ///
  /// **Returns**
  ///
  /// * The [OverlayCategory] if category is found
  /// * null if the category is not found
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  OverlayCategory? getSocialReportsCategory(
    final int categId, {
    final String country = '',
  }) {
    final OperationResult result = objectMethod(
      pointerId,
      'SocialReportsOverlayInfo',
      'getSocialReportsCategory',
      args: <String, dynamic>{'categId': categId, 'country': country},
    );
    if (result['result']['uid'] == 0) {
      return null;
    }
    return OverlayCategory.fromJson(result['result']);
  }

  @override
  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, Object>{
        'class': 'SocialReportsOverlayInfo',
        'id': pointerId,
      }),
    );
  }
}

/// Report category parameter keys
///
/// {@category Routes & Navigation}
abstract class PredefinedCategoryParameterKeys {
  /// String
  static const String reportCategName = 'categ_name';

  /// int
  static const String reportCategId = 'categ_id';

  /// String
  static const String reportCategKVTypeInteger = 'integer';

  /// String
  static const String reportCategKVTypeDouble = 'double';

  /// String
  static const String reportCategKVTypeString = 'string';

  /// String
  static const String reportCategCurrency = 'currency';

  /// int ( minutes )
  static const String reportCategValidity = 'validity_mins';

  /// String
  static const String reportCategNameTTS = 'tts';
}

/// Report parameter keys
///
/// {@category Routes & Navigation}
abstract class PredefinedReportParameterKeys {
  /// String
  static const String reportCategNameTTS = 'tts';

  /// int ( minutes )
  static const String reportCategValidity = 'validity_mins';

  /// string
  static const String reportDescription = 'description';

  /// LargeInteger
  static const String reportOwnerId = 'owner_id';

  /// String
  static const String reportOwnerName = 'owner_name';

  /// bool
  static const String reportOwnReport = 'own_report';

  /// int
  static const String reportScore = 'score';

  /// int timestamp ( seconds )
  static const String reportCreateTimeUTC = 'create_stamp_utc';

  /// int timestamp ( seconds )
  static const String reportUpdateTimeUTC = 'update_stamp_utc';

  /// int timestamp ( seconds )
  static const String reportExpireTimeUTC = 'expire_stamp_utc';

  /// bool
  static const String reportHasSnapshot = 'has_snapshot';

  /// double
  static const String reportDirection = 'direction_';

  /// double
  static const String reportDirection1 = 'direction_1';

  /// double
  static const String reportDirection2 = 'direction_2';

  /// bool
  static const String reportAllowThumb = 'allow_thumb';

  /// bool
  static const String reportAllowUpdate = 'allow_update';

  /// bool
  static const String reportAllowDelete = 'allow_delete';

  /// String
  static const String reportCurrency = 'currency';

  /// List
  static const String reportComment = 'comments';

  /// String
  static const String reportCommentUserIcon = 'user_icon';

  /// String
  static const String reportCommentUserName = 'sender_name';

  /// String
  static const String reportCommentText = 'payload';

  /// int timestamp ( seconds )
  static const String reportCommentTimeUTC = 'stamp';
}
