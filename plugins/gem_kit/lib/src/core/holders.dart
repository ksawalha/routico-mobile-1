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
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// @nodoc
@internal
class StringHolder extends GemAutoreleaseObject {
  factory StringHolder() {
    return _create();
  }

  StringHolder.init(final int id) : _pointerId = id {
    super.registerAutoReleaseObject(_pointerId);
  }

  String get value {
    final OperationResult resultString = objectMethod(
      _pointerId,
      'StringHolderFlutter',
      'value',
    );
    return resultString['result'];
  }

  static StringHolder _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'StringHolderFlutter'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return StringHolder.init(decodedVal['result']);
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, Object>{
        'class': 'StringHolderFlutter',
        'id': _pointerId,
      }),
    );
  }

  final int _pointerId;
  int get pointerId => _pointerId;
}

/// @nodoc
@internal
class ExternalInfoHandler extends EventDrivenProgressListener {
  ExternalInfoHandler({required ExternalInfo externalInfo})
      : _externalInfo = externalInfo,
        super();

  final ExternalInfo _externalInfo;

  void cancelWikiInfo() {
    objectMethod(_externalInfo.pointerId, 'ExternalInfo', 'cancelWikiInfo');
  }
}
