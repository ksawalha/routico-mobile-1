import 'dart:async';
import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

/// Specifies the type of media the sound engine is currently playing
///
/// {@category Core}
enum SoundPlayType {
  /// There is nothing playing
  none,

  /// A custom text-to-speech message is playing.
  text,

  /// A sound file is being played.
  file,

  /// A predefined alert file is being played.
  alert,

  /// A navigation sound is being played.
  navigationSound,

  /// A sound identified by a specific ID is being played.
  soundById,
}

/// @nodoc
extension SoundPlayTypeExtension on SoundPlayType {
  int get id {
    switch (this) {
      case SoundPlayType.none:
        return 0;
      case SoundPlayType.text:
        return 1;
      case SoundPlayType.file:
        return 2;
      case SoundPlayType.alert:
        return 3;
      case SoundPlayType.navigationSound:
        return 4;
      case SoundPlayType.soundById:
        return 5;
    }
  }

  static SoundPlayType fromId(int id) {
    switch (id) {
      case 0:
        return SoundPlayType.none;
      case 1:
        return SoundPlayType.text;
      case 2:
        return SoundPlayType.file;
      case 3:
        return SoundPlayType.alert;
      case 4:
        return SoundPlayType.navigationSound;
      case 5:
        return SoundPlayType.soundById;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Listener for events related to computer/human TTS events.
///
/// A single sound event can be played by the SDK at any given time
///
/// {@category Core}
class SoundPlayingListener extends EventHandler {
  // ignore: unused_element
  SoundPlayingListener._() : id = -1;

  SoundPlayingListener.init(this.id);
  int id;
  void Function(int newVolume)? _onVolumeChangedByKeys;
  void Function()? _onStart;
  void Function(GemError error)? _onStop;

  /// Register to events regarding volume changes made by the user using the volume keys
  ///
  /// **Parameters**
  ///
  /// * **IN** *newVolume* The new volume
  void registerOnVolumeChangedByKeys(
    final void Function(int newVolume) callback,
  ) {
    _onVolumeChangedByKeys = callback;
  }

  /// Register to events regarding the start of a play sound action
  ///
  /// Addiitonal informations regarding the played sound can be obtained via the [soundPlayType], [soundPlayContent] and [soundPlayFileName] getters.
  void registerOnStart(final void Function()? callback) {
    _onStart = callback;
  }

  /// Register to events regarding the stop of a play sound action
  void registerOnStop(final void Function(GemError error)? callback) {
    _onStop = callback;
  }

  /// The type of the sound played by the engine
  SoundPlayType get soundPlayType {
    final OperationResult result = objectMethod(
      id,
      'SoundPlayingListener',
      'getSoundPlayType',
    );
    return SoundPlayTypeExtension.fromId(result['result']);
  }

  /// The content of the sound played by the engine
  ///
  /// Depending on the [soundPlayType], the content can be:
  ///   - Null string in case of [SoundPlayType.none], [SoundPlayType.file] or [SoundPlayType.alert]
  ///   - The TTS message in case of [SoundPlayType.text]
  ///   - The string transciption of the sound in case of [SoundPlayType.navigationSound] or [SoundPlayType.soundById]
  String? get soundPlayContent {
    final OperationResult result = objectMethod(
      id,
      'SoundPlayingListener',
      'getSoundPlayContent',
    );
    final String stringRes = result['result'];
    if (stringRes.isEmpty) {
      return null;
    }
    return stringRes;
  }

  /// The name of the sound file played by the engine
  ///
  /// Depending on the [soundPlayType], the path is:
  ///   - Null string in case of [SoundPlayType.none], [SoundPlayType.navigationSound] or [SoundPlayType.soundById]
  ///   - The file name in case of [SoundPlayType.file] or [SoundPlayType.alert]
  String? get soundPlayFileName {
    final OperationResult result = objectMethod(
      id,
      'SoundPlayingListener',
      'getSoundPlayPath',
    );
    final String stringRes = result['result'];
    if (stringRes.isEmpty) {
      return null;
    }
    return stringRes;
  }

  @override
  FutureOr<void> dispose() {}

  @override
  void handleEvent(Map<dynamic, dynamic> arguments) {
    final String eventSubtype = arguments['event_subtype'];

    switch (eventSubtype) {
      case 'onVolumeChangedByKeys':
        if (_onVolumeChangedByKeys != null) {
          _onVolumeChangedByKeys!(arguments['newVolume']);
        }
      case 'startEvent':
        if (_onStart != null) {
          _onStart!();
        }
      case 'completeEvent':
        if (_onStop != null) {
          _onStop!(GemErrorExtension.fromCode(arguments['reason']));
        }
    }
  }
}
