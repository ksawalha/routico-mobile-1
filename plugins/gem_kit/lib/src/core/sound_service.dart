// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

import 'package:gem_kit/src/core/sound_playing_listener.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:meta/meta.dart';

/// Alert severity type
///
/// {@category Core}
enum AlertSeverity {
  /// Information
  information,

  /// Warning
  warning,
}

/// @nodoc
extension AlertSeverityExtension on AlertSeverity {
  int get id {
    switch (this) {
      case AlertSeverity.information:
        return 0;
      case AlertSeverity.warning:
        return 2;
    }
  }

  static AlertSeverity fromId(int id) {
    switch (id) {
      case 0:
        return AlertSeverity.information;
      case 2:
        return AlertSeverity.warning;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Sound service class used to play text to speech
///
/// {@category Core}
abstract class SoundPlayingService {
  /// Play TTS text
  ///
  /// **Parameters**
  ///
  /// * **IN** *text* Text to be played
  /// * **IN** *severity* The severity
  static void playText(
    String text, {
    AlertSeverity severity = AlertSeverity.information,
  }) {
    staticMethod('SoundService', 'playText', args: <String, dynamic>{
      'text': text,
      'severity': severity.id,
    });
  }

  /// Play sound
  ///
  /// **Parameters**
  ///
  /// * **IN** *soundId* Sound id
  static void playSound(dynamic soundId) {
    staticMethod('SoundService', 'playSound', args: soundId);
  }

  /// Set warnings volume
  ///
  /// Between 0 and 10
  ///
  /// **Parameters**
  ///
  /// * **IN** *volume* Volume
  static set warningsVolume(int volume) {
    staticMethod('SoundService', 'setWarningsVolume', args: volume);
  }

  /// Get warnings volume
  ///
  /// Between 0 and 10
  ///
  /// **Returns**
  ///
  /// * **IN** *volume* Volume
  static int get warningsVolume {
    final OperationResult result = staticMethod(
      'SoundService',
      'getWarningsVolume',
    );

    return result['result'];
  }

  /// Set voice volume
  ///
  /// Between 0 and 10
  ///
  /// **Parameters**
  ///
  /// * **IN** *volume* Volume
  static set voiceVolume(int volume) {
    staticMethod('SoundService', 'setVoiceVolume', args: volume);
  }

  /// Get voice volume
  ///
  /// Between 0 and 10
  ///
  /// **Returns**
  ///
  /// * The volume used for voice
  static int get voiceVolume {
    final OperationResult result = staticMethod(
      'SoundService',
      'getVoiceVolume',
    );
    return result['result'];
  }

  /// Sets the SDK to automatically play TTS instructions automatically.
  ///
  /// **Returns**
  ///
  /// * True if the SDK will play TTS instructions automatically, false otherwise
  static set canPlaySounds(bool canPlaySound) {
    staticMethod('SoundService', 'setCanPlaySounds', args: canPlaySound);
  }

  /// Gets the SDK to automatically play TTS instructions automatically.
  ///
  /// **Returns**
  ///
  /// * True if the SDK will play TTS instructions automatically, false otherwise
  static bool get canPlaySounds {
    final OperationResult result = staticMethod(
      'SoundService',
      'getCanPlaySound',
    );
    return result['result'];
  }

  /// Cancel playing navigation sounds
  static void cancelNavigationSoundsPlaying() {
    staticMethod('SoundService', 'cancelNavigationSoundsPlaying');
  }

  /// Set audio output type
  static set audioOutput(AudioOutput audioOutput) {
    staticMethod('SoundService', 'setAudioOutput', args: audioOutput.id);
  }

  /// Get audio output type
  static AudioOutput get audioOutput {
    final OperationResult result = staticMethod(
      'SoundService',
      'getAudioOutput',
    );
    return AudioOutputExtension.fromId(result['result']);
  }

  /// Set call timing delay in ms
  ///
  /// Only relevant when the audio is played as BT phone call
  static set callTimingDelay(int delay) {
    staticMethod('SoundService', 'setCallTimingDelay', args: delay);
  }

  /// Get call timing delay in ms
  static int get callTimingDelay {
    final OperationResult result = staticMethod(
      'SoundService',
      'getCallTimingDelay',
    );
    return result['result'];
  }

  /// Get the sound playing listener
  ///
  /// A single [SoundPlayingListener] instance is created since the initalization until the release of the SDK.
  static SoundPlayingListener get soundPlayingListener {
    if (_cachedListener != null) {
      return _cachedListener!;
    }

    final OperationResult result = staticMethod(
      'SoundService',
      'getSoundPlayingListener',
    );
    _cachedListener = SoundPlayingListener.init(result['result']);
    GemKitPlatform.instance
        .registerEventHandler(_cachedListener!.id, _cachedListener!);

    return _cachedListener!;
  }

  static SoundPlayingListener? _cachedListener;

  /// @nodoc
  ///
  /// The API user should not call this method
  @internal
  static void reset() {
    _cachedListener = null;
  }
}

/// Audio output type
enum AudioOutput {
  /// Output on speaker if device is NOT connected to Bluetooth A2DP.
  ///
  /// Output on Bluetooth A2DP if device is connected to Bluetooth A2DP
  automatic,

  /// Output on Bluetooth as phone call.
  bluetoothAsPhoneCall,

  /// Output only on speaker
  speaker,
}

/// @nodoc
extension AudioOutputExtension on AudioOutput {
  int get id {
    switch (this) {
      case AudioOutput.automatic:
        return 0;
      case AudioOutput.bluetoothAsPhoneCall:
        return 1;
      case AudioOutput.speaker:
        return 2;
    }
  }

  static AudioOutput fromId(int id) {
    switch (id) {
      case 0:
        return AudioOutput.automatic;
      case 1:
        return AudioOutput.bluetoothAsPhoneCall;
      case 2:
        return AudioOutput.speaker;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}
