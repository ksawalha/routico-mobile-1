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

import 'package:gem_kit/content_store.dart';
import 'package:gem_kit/core.dart';
import 'package:gem_kit/map.dart';
import 'package:gem_kit/src/core/gem_autorelease_object.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// @nodoc
class GemList<T> extends GemAutoreleaseObject implements Iterable<T> {
  GemList(this._pointerId, this._className, this._initializer);

  GemList.init(this._pointerId, this._className, this._initializer) {
    super.registerAutoReleaseObject(_pointerId);
  }
  final dynamic _pointerId;
  dynamic get pointerId => _pointerId;
  final T Function(dynamic) _initializer;
  final String _className;

  @override
  Iterator<T> get iterator =>
      GenericIterator<T>(_pointerId, size(), _className, _initializer);

  int size() {
    final OperationResult resultString = objectMethod(
      _pointerId,
      _className,
      'size',
    );

    return resultString['result'];
  }

  T operator [](final int index) => at(index);
  T at(final int position) {
    if (position > length - 1) {
      throw RangeError.range(position, 0, length - 1, 'Index out of bounds');
    } else {
      final OperationResult resultString = objectMethod(
        _pointerId,
        _className,
        'at',
        args: position,
      );

      return _initializer(resultString['result']);
    }
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
      jsonEncode(<String, dynamic>{'class': _className, 'id': _pointerId}),
    );
  }

  @override
  bool any(final bool Function(T element) test) {
    for (final T item in this) {
      if (test(item)) {
        return true;
      }
    }
    return false;
  }

  @override
  Iterable<R> cast<R>() {
    return toList().cast<R>();
  }

  @override
  bool contains(final Object? element) {
    for (final T route in this) {
      if (route == element) {
        return true;
      }
    }
    return false;
  }

  @override
  T elementAt(final int index) {
    if (index < 0 || index >= length) {
      throw RangeError.index(index, this);
    }
    return at(index)!;
  }

  @override
  bool every(final bool Function(T element) test) {
    for (final T item in this) {
      if (!test(item)) {
        return false;
      }
    }
    return true;
  }

  @override
  Iterable<R> expand<R>(
    final Iterable<R> Function(T element) toElements,
  ) sync* {
    for (final T element in this) {
      yield* toElements(element);
    }
  }

  @override
  T get first {
    if (isEmpty) {
      throw StateError('No elements');
    }
    return at(0)!;
  }

  @override
  T firstWhere(
    final bool Function(T element) test, {
    final T Function()? orElse,
  }) {
    for (final T item in this) {
      if (test(item)) {
        return item;
      }
    }
    if (orElse != null) {
      return orElse();
    }
    throw StateError('No matching element');
  }

  @override
  R fold<R>(
    final R initialValue,
    final R Function(R previousValue, T element) combine,
  ) {
    R result = initialValue;
    for (final T route in this) {
      result = combine(result, route);
    }
    return result;
  }

  @override
  Iterable<T> followedBy(final Iterable<T> other) {
    return <T>[...this, ...other];
  }

  @override
  void forEach(final void Function(T element) action) {
    // ignore: prefer_foreach
    for (final T item in this) {
      action(item);
    }
  }

  @override
  bool get isEmpty => length == 0;

  @override
  bool get isNotEmpty => length > 0;

  @override
  String join([final String separator = '']) {
    return toList().join(separator);
  }

  @override
  T get last {
    if (isEmpty) {
      throw StateError('No elements');
    }
    return at(length - 1)!;
  }

  @override
  T lastWhere(
    final bool Function(T element) test, {
    final T Function()? orElse,
  }) {
    for (int i = length - 1; i >= 0; i--) {
      final T item = at(i);
      if (test(item)) {
        return item;
      }
    }
    if (orElse != null) {
      return orElse();
    }
    throw StateError('No matching element');
  }

  @override
  int get length => size();

  @override
  T reduce(final T Function(T value, T element) combine) {
    if (isEmpty) {
      throw StateError('No elements');
    }
    T result = first;
    for (int i = 1; i < length; i++) {
      result = combine(result, at(i)!);
    }
    return result;
  }

  @override
  T get single {
    if (length != 1) {
      throw StateError('Not a single element');
    }
    return first;
  }

  @override
  T singleWhere(
    final bool Function(T element) test, {
    final T Function()? orElse,
  }) {
    T? result;
    for (final T item in this) {
      if (test(item)) {
        if (result != null) {
          throw StateError('More than one matching element');
        }
        result = item;
      }
    }
    if (result != null) {
      return result;
    }
    if (orElse != null) {
      return orElse();
    }
    throw StateError('No matching element');
  }

  @override
  Iterable<T> skip(final int count) {
    throw UnimplementedError();
  }

  @override
  Iterable<T> skipWhile(final bool Function(T value) test) {
    throw UnimplementedError();
  }

  @override
  Iterable<T> take(final int count) {
    throw UnimplementedError();
  }

  @override
  Iterable<T> takeWhile(final bool Function(T value) test) {
    throw UnimplementedError();
  }

  @override
  List<T> toList({final bool growable = true}) {
    final List<T> list = <T>[];
    // ignore: prefer_foreach
    for (final T item in this) {
      list.add(item);
    }
    return list;
  }

  @override
  Set<T> toSet() {
    final Set<T> set = <T>{};
    // ignore: prefer_foreach
    for (final T item in this) {
      set.add(item);
    }
    return set;
  }

  @override
  Iterable<T> where(final bool Function(T element) test) {
    return <T>[
      for (final T item in this)
        if (test(item)) item,
    ];
  }

  @override
  Iterable<U> whereType<U>() {
    return toList().whereType<U>();
  }

  @override
  Iterable<R> map<R>(final R Function(T e) toElement) {
    final List<R> result = <R>[];
    for (final T route in this) {
      result.add(toElement(route));
    }
    return result;
  }
}

/// @nodoc
class GenericIterator<T> implements Iterator<T> {
  GenericIterator(
    this._listId,
    this._currentSize,
    this._className,
    this._initializer,
  );
  final dynamic _listId;

  int _currentIndex = -1;
  final int _currentSize;
  final String _className;
  final T Function(dynamic) _initializer;

  @override
  T get current {
    if (_currentIndex == -1) {
      throw StateError('No current element');
    }
    if (_currentIndex >= _currentSize) {
      throw StateError('No more elements');
    }

    final OperationResult resultString = objectMethod(
      _listId,
      _className,
      'at',
      args: _currentIndex,
    );

    return _initializer(resultString['result']);
  }

  @override
  bool moveNext() {
    _currentIndex++;
    return _currentIndex < _currentSize;
  }
}

/// @nodoc
class LandmarkList extends GemList<Landmark> {
  factory LandmarkList() {
    return LandmarkList._create();
  }

  factory LandmarkList.fromJsonList(final List<LandmarkJson> landmarks) {
    return _fromLandmarkListJson(landmarks);
  }

  factory LandmarkList.fromList(final List<Landmark> landmarks) {
    final LandmarkList landmarkList = LandmarkList();
    landmarks.forEach(landmarkList.add);
    return landmarkList;
  }

  @internal
  LandmarkList.init(final dynamic id)
      : super(id, 'LandmarkList', (final dynamic data) => Landmark.init(data));

  static LandmarkList _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'LandmarkList'}),
    );
    final Map<String, dynamic> decodedVal = jsonDecode(resultString);
    return LandmarkList.init(decodedVal['result']);
  }

  void add(final Landmark landmmark) {
    objectMethod(
      pointerId,
      'LandmarkList',
      'push_back',
      args: landmmark.pointerId,
    );
  }

  static LandmarkList _fromLandmarkListJson(
    final List<LandmarkJson> landmarks,
  ) {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, Object>{'class': 'LandmarkList', 'args': landmarks}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return LandmarkList.init(decodedVal['result']);
  }

  @override
  List<Landmark> toList({final bool growable = true}) {
    final OperationResult result = objectMethod(
      pointerId,
      'LandmarkList',
      'toList',
    );

    return (result['result'] as List<dynamic>)
        .map((dynamic e) => Landmark.init(e))
        .toList(growable: growable);
  }
}

/// @nodoc
class LandmarkPositionList extends GemList<LandmarkPosition> {
  factory LandmarkPositionList() {
    return LandmarkPositionList._create();
  }

  factory LandmarkPositionList.fromList(
    final List<LandmarkPosition> landmarks,
  ) {
    final LandmarkPositionList landmarkList = LandmarkPositionList();
    landmarks.forEach(landmarkList.add);
    return landmarkList;
  }

  @internal
  LandmarkPositionList.init(final dynamic id)
      : super(
          id,
          'LandmarkPositionList',
          (final dynamic data) => LandmarkPosition.init(data),
        ) {
    super.registerAutoReleaseObject(id);
  }

  static LandmarkPositionList _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'LandmarkPositionList'}),
    );
    final Map<String, dynamic> decodedVal = jsonDecode(resultString);
    return LandmarkPositionList.init(decodedVal['result']);
  }

  void add(final LandmarkPosition landmmark) {
    objectMethod(
      pointerId,
      'LandmarkPositionList',
      'push_back',
      args: landmmark.id,
    );
  }
}

/// @nodoc
class OverlayItemList extends GemList<OverlayItem> {
  factory OverlayItemList() {
    return OverlayItemList._create();
  }

  factory OverlayItemList.fromList(final List<OverlayItem> landmarks) {
    final OverlayItemList landmarkList = OverlayItemList();
    landmarks.forEach(landmarkList.add);
    return landmarkList;
  }

  OverlayItemList.init(final dynamic id)
      : super(
          id,
          'OverlayItemList',
          (final dynamic data) => OverlayItem.init(data),
        ) {
    super.registerAutoReleaseObject(id);
  }

  static OverlayItemList _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'OverlayItemList'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return OverlayItemList.init(decodedVal['result']);
  }

  void add(final OverlayItem overlayItem) {
    objectMethod(
      pointerId,
      'OverlayItemList',
      'push_back',
      args: overlayItem.pointerId,
    );
  }

  @override
  List<OverlayItem> toList({final bool growable = true}) {
    final OperationResult result = objectMethod(
      pointerId,
      'OverlayItemList',
      'toList',
    );

    return (result['result'] as List<dynamic>)
        .map((dynamic e) => OverlayItem.init(e))
        .toList(growable: growable);
  }
}

/// @nodoc
class RouteList extends GemList<Route> {
  factory RouteList() {
    return RouteList._create();
  }

  factory RouteList.fromList(final List<Route> routes) {
    final RouteList routeList = RouteList._create();
    routes.forEach(routeList.add);
    return routeList;
  }

  @internal
  RouteList.init(final int id)
      : super(id, 'RouteList', (final dynamic data) => Route.init(data)) {
    super.registerAutoReleaseObject(id);
  }

  static RouteList _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'RouteList'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return RouteList.init(decodedVal['result']);
  }

  void add(final Route route) {
    objectMethod(pointerId, 'RouteList', 'push_back', args: route.pointerId);
  }

  @override
  List<Route> toList({final bool growable = true}) {
    final OperationResult result = objectMethod(
      pointerId,
      'RouteList',
      'toList',
    );

    return (result['result'] as List<dynamic>)
        .map((dynamic e) => Route.init(e))
        .toList(growable: growable);
  }
}

/// @nodoc
class RouteInstructionList extends GemList<RouteInstruction> {
  factory RouteInstructionList() {
    return RouteInstructionList._create();
  }

  @internal
  RouteInstructionList.init(final int id)
      : super(
          id,
          'RouteInstructionList',
          (final dynamic data) => RouteInstruction.init(data),
        ) {
    super.registerAutoReleaseObject(id);
  }
  static RouteInstructionList _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'RouteInstructionList'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return RouteInstructionList.init(decodedVal['result']);
  }

  @override
  List<RouteInstruction> toList({final bool growable = true}) {
    final OperationResult result = objectMethod(
      pointerId,
      'RouteInstructionList',
      'toList',
    );

    return (result['result'] as List<dynamic>)
        .map((dynamic e) => RouteInstruction.init(e))
        .toList(growable: growable);
  }
}

/// @nodoc
class RouteSegmentList extends GemList<RouteSegment> {
  factory RouteSegmentList() {
    return RouteSegmentList.create();
  }

  @internal
  RouteSegmentList.init(final int id)
      : super(
          id,
          'RouteSegmentList',
          (final dynamic data) => RouteSegment.init(data),
        ) {
    super.registerAutoReleaseObject(id);
  }

  static RouteSegmentList create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'RouteSegmentList'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return RouteSegmentList.init(decodedVal['result']);
  }

  @override
  List<RouteSegment> toList({final bool growable = true}) {
    final OperationResult result = objectMethod(
      pointerId,
      'RouteSegmentList',
      'toList',
    );

    return (result['result'] as List<dynamic>)
        .map((dynamic e) => RouteSegment.init(e))
        .toList(growable: growable);
  }
}

/// @nodoc
class OverlayItemPositionList extends GemList<OverlayItemPosition> {
  factory OverlayItemPositionList() {
    return OverlayItemPositionList._create();
  }

  factory OverlayItemPositionList.fromList(
    final List<OverlayItemPosition> landmarks,
  ) {
    final OverlayItemPositionList landmarkList = OverlayItemPositionList();
    landmarks.forEach(landmarkList.add);
    return landmarkList;
  }

  OverlayItemPositionList.init(final dynamic id)
      : super(
          id,
          'OverlayItemPositionList',
          (final dynamic data) => OverlayItemPosition.init(data),
        ) {
    super.registerAutoReleaseObject(id);
  }

  static OverlayItemPositionList _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'OverlayItemPositionList'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return OverlayItemPositionList.init(decodedVal['result']);
  }

  void add(final OverlayItemPosition overlayItemPosition) {
    objectMethod(
      pointerId,
      'OverlayItemPositionList',
      'push_back',
      args: overlayItemPosition.pointerId,
    );
  }

  @override
  List<OverlayItemPosition> toList({final bool growable = true}) {
    final OperationResult result = objectMethod(
      pointerId,
      'OverlayItemPositionList',
      'toList',
    );

    return (result['result'] as List<dynamic>)
        .map((dynamic e) => OverlayItemPosition.init(e))
        .toList(growable: growable);
  }
}

/// @nodoc
class MarkerMatchList extends GemList<MarkerMatch> {
  factory MarkerMatchList() {
    return MarkerMatchList._create();
  }

  MarkerMatchList.init(final dynamic id)
      : super(
          id,
          'MarkerMatchList',
          (final dynamic data) => MarkerMatch.init(data),
        ) {
    super.registerAutoReleaseObject(id);
  }

  static MarkerMatchList _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'MarkerMatchList'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return MarkerMatchList.init(decodedVal['result']);
  }

  @override
  List<MarkerMatch> toList({final bool growable = true}) {
    final OperationResult result = objectMethod(
      pointerId,
      'MarkerMatchList',
      'toList',
    );

    return (result['result'] as List<dynamic>)
        .map((dynamic e) => MarkerMatch.init(e))
        .toList(growable: growable);
  }
}

/// @nodoc
class MarkerList extends GemList<Marker> {
  factory MarkerList() {
    return MarkerList._create();
  }

  factory MarkerList.fromList(final List<MarkerList> landmarks) {
    final MarkerList landmarkList = MarkerList();
    landmarks.forEach(landmarkList.add);
    return landmarkList;
  }

  MarkerList.init(final dynamic id)
      : super(id, 'MarkerList', (final dynamic data) => Marker.init(data)) {
    super.registerAutoReleaseObject(id);
  }

  static MarkerList _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'MarkerList'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return MarkerList.init(decodedVal['result']);
  }

  void add(final MarkerList landmmark) {
    objectMethod(
      pointerId,
      'MarkerList',
      'push_back',
      args: landmmark.pointerId,
    );
  }

  @override
  List<Marker> toList({final bool growable = true}) {
    final OperationResult result = objectMethod(
      pointerId,
      'MarkerList',
      'toList',
    );

    return (result['result'] as List<dynamic>)
        .map((dynamic e) => Marker.init(e))
        .toList(growable: growable);
  }
}

/// @nodoc
class TrafficEventList extends GemList<TrafficEvent> {
  factory TrafficEventList() {
    return TrafficEventList._create();
  }

  @internal
  TrafficEventList.init(final int id)
      : super(
          id,
          'TrafficEventList',
          (final dynamic data) => TrafficEvent.init(data),
        ) {
    super.registerAutoReleaseObject(id);
  }

  static TrafficEventList _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, dynamic>{'class': 'TrafficEventList'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return TrafficEventList.init(decodedVal['result']);
  }

  @override
  List<TrafficEvent> toList({final bool growable = true}) {
    final OperationResult result = objectMethod(
      pointerId,
      'TrafficEventList',
      'toList',
    );

    return (result['result'] as List<dynamic>)
        .map((dynamic e) => TrafficEvent.init(e))
        .toList(growable: growable);
  }
}

/// @nodoc
class RouteTrafficEventList extends GemList<RouteTrafficEvent> {
  factory RouteTrafficEventList() {
    return RouteTrafficEventList._create();
  }

  @internal
  RouteTrafficEventList.init(final int id)
      : super(
          id,
          'RouteTrafficEventList',
          (final dynamic data) => RouteTrafficEvent.init(data),
        ) {
    super.registerAutoReleaseObject(id);
  }
  static RouteTrafficEventList _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'RouteTrafficEventList'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return RouteTrafficEventList.init(decodedVal['result']);
  }

  @override
  List<RouteTrafficEvent> toList({final bool growable = true}) {
    final OperationResult result = objectMethod(
      pointerId,
      'TrafficEventList',
      'toList',
    );

    return (result['result'] as List<dynamic>)
        .map((dynamic e) => RouteTrafficEvent.init(e))
        .toList(growable: growable);
  }
}

/// @nodoc
class LandmarkCategoryList extends GemList<LandmarkCategory> {
  factory LandmarkCategoryList() {
    return LandmarkCategoryList._create();
  }

  @internal
  LandmarkCategoryList.init(final dynamic id)
      : super(
          id,
          'LandmarkCategoryList',
          (final dynamic data) => LandmarkCategory.init(data),
        );

  static LandmarkCategoryList _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'LandmarkCategoryList'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return LandmarkCategoryList.init(decodedVal['result']);
  }

  void add(final LandmarkCategory category) => objectMethod(
        pointerId,
        'LandmarkCategoryList',
        'push_back',
        args: category.pointerId,
      );

  @override
  List<LandmarkCategory> toList({final bool growable = true}) {
    final OperationResult result = objectMethod(
      pointerId,
      'LandmarkCategoryList',
      'toList',
    );

    return (result['result'] as List<dynamic>)
        .map((dynamic e) => LandmarkCategory.init(e))
        .toList(growable: growable);
  }
}

/// @nodoc
class ContentStoreItemList extends GemList<ContentStoreItem> {
  factory ContentStoreItemList({final dynamic id = 0, final int mapId = 0}) {
    if (id == 0 && mapId == 0) {
      return ContentStoreItemList._create();
    } else {
      return ContentStoreItemList.init(id);
    }
  }

  @internal
  ContentStoreItemList.init(final dynamic id)
      : super(
          id,
          'ContentStoreItemList',
          (final dynamic data) => ContentStoreItem.init(data),
        );

  static ContentStoreItemList _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'ContentStoreItemList'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return ContentStoreItemList.init(decodedVal['result']);
  }

  @override
  List<ContentStoreItem> toList({final bool growable = true}) {
    final OperationResult result = objectMethod(
      pointerId,
      'ContentStoreItemList',
      'toList',
    );

    return (result['result'] as List<dynamic>)
        .map((dynamic e) => ContentStoreItem.init(e))
        .toList(growable: growable);
  }
}

/// @nodoc
class SignpostItemList extends GemList<SignpostItem> {
  factory SignpostItemList() {
    return SignpostItemList._create();
  }

  @internal
  SignpostItemList.init(final int id)
      : super(
          id,
          'SignpostItemList',
          (final dynamic data) => SignpostItem.init(data),
        ) {
    super.registerAutoReleaseObject(id);
  }
  static SignpostItemList _create() {
    final String resultString = GemKitPlatform.instance.callCreateObject(
      jsonEncode(<String, String>{'class': 'SignpostItemList'}),
    );
    final dynamic decodedVal = jsonDecode(resultString);
    return SignpostItemList.init(decodedVal['result']);
  }

  @override
  List<SignpostItem> toList({final bool growable = true}) {
    final OperationResult result = objectMethod(
      pointerId,
      'SignpostItemList',
      'toList',
    );

    return (result['result'] as List<dynamic>)
        .map((dynamic e) => SignpostItem.init(e))
        .toList(growable: growable);
  }
}
