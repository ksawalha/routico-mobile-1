import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/contentstore/content_types.dart';

/// Configuration for auto update
///
/// {@category Core}
class AutoUpdateSettings {
  /// Constructor for initializing the auto-update settings
  /// with default values.
  const AutoUpdateSettings({
    this.isAutoUpdateForRoadMapEnabled = true,
    this.isAutoUpdateForViewStyleHighResEnabled = true,
    this.isAutoUpdateForViewStyleLowResEnabled = true,
    this.isAutoUpdateForHumanVoiceEnabled = false,
    this.isAutoUpdateForComputerVoiceEnabled = false,
    this.isAutoUpdateForCarModelEnabled = false,
    this.isAutoUpdateForResourcesEnabled = true,
    this.onAutoUpdateComplete,
  });

  /// Factory constructor to create an instance where all update options are disabled.
  factory AutoUpdateSettings.allDisabled({
    void Function(ContentType type, GemError error)? onAutoUpdateComplete,
  }) {
    return AutoUpdateSettings(
      isAutoUpdateForRoadMapEnabled: false,
      isAutoUpdateForViewStyleHighResEnabled: false,
      isAutoUpdateForViewStyleLowResEnabled: false,
      isAutoUpdateForResourcesEnabled: false,
      onAutoUpdateComplete: onAutoUpdateComplete,
    );
  }

  /// Factory constructor to create an instance where all update options are enabled.
  factory AutoUpdateSettings.allEnabled({
    void Function(ContentType type, GemError error)? onAutoUpdateComplete,
  }) {
    return AutoUpdateSettings(
      isAutoUpdateForHumanVoiceEnabled: true,
      isAutoUpdateForComputerVoiceEnabled: true,
      isAutoUpdateForCarModelEnabled: true,
      onAutoUpdateComplete: onAutoUpdateComplete,
    );
  }

  /// Whether the update for the road maps is enabled
  final bool isAutoUpdateForRoadMapEnabled;

  /// Whether the update for the map styles high resolution is enabled
  final bool isAutoUpdateForViewStyleHighResEnabled;

  /// Whether the update for the map styles low resolution is enabled
  final bool isAutoUpdateForViewStyleLowResEnabled;

  /// Whether the update for the human voices is enabled
  final bool isAutoUpdateForHumanVoiceEnabled;

  /// Whether the update for the computer voices is enabled
  final bool isAutoUpdateForComputerVoiceEnabled;

  /// Whether the update for the car models is enabled
  final bool isAutoUpdateForCarModelEnabled;

  /// Whether the update for the resources (icons, translations) is enabled
  final bool isAutoUpdateForResourcesEnabled;

  /// Callback to be called when an auto update is completed
  ///
  /// Provides the content type and the error code
  final void Function(ContentType type, GemError error)? onAutoUpdateComplete;

  /// Determines if updates are allowed for a given content type.
  ///
  /// Returns `true` if the content type is enabled for auto-update,
  /// otherwise returns `false`.
  bool isUpdateAllowedForType(final ContentType type) {
    switch (type) {
      case ContentType.roadMap:
        return isAutoUpdateForRoadMapEnabled;
      case ContentType.viewStyleHighRes:
        return isAutoUpdateForViewStyleHighResEnabled;
      case ContentType.viewStyleLowRes:
        return isAutoUpdateForViewStyleLowResEnabled;
      case ContentType.humanVoice:
        return isAutoUpdateForHumanVoiceEnabled;
      case ContentType.computerVoice:
        return isAutoUpdateForComputerVoiceEnabled;
      case ContentType.carModel:
        return isAutoUpdateForCarModelEnabled;
      case ContentType.unknown:
        return false;
    }
  }
}
