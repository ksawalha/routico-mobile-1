// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

/// Script variants
///
/// {@category Core}
enum ScriptVariant {
  /// Native
  native,

  /// Transcription
  transcription,

  /// Transliteration
  transliteration,
}

/// @nodoc
///
/// {@category Core}
extension ScriptVariantExtension on ScriptVariant {
  int get id {
    switch (this) {
      case ScriptVariant.native:
        return 0;
      case ScriptVariant.transcription:
        return 256;
      case ScriptVariant.transliteration:
        return 512;
    }
  }

  static ScriptVariant fromId(final int id) {
    switch (id) {
      case 0:
        return ScriptVariant.native;
      case 256:
        return ScriptVariant.transcription;
      case 512:
        return ScriptVariant.transliteration;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Complete language specification.
///
/// {@category Core}
class Language {
  Language({
    this.name = '',
    this.languagecode = '',
    this.regioncode = '',
    this.scriptcode = '',
    this.scriptvariant = ScriptVariant.native,
  });

  factory Language.fromJson(final Map<String, dynamic> json) {
    return Language(
      name: json['name'] ?? '',
      languagecode: json['languagecode'] ?? '',
      regioncode: json['regioncode'] ?? '',
      scriptcode: json['scriptcode'] ?? '',
      scriptvariant: ScriptVariantExtension.fromId(
        json['scriptvariant'] ?? ScriptVariant.native.id,
      ),
    );
  }

  /// Language name.
  String name;

  /// ISO 639-3 three letter language code.
  String languagecode;

  /// ISO 3166-1 three letter region code.
  String regioncode;

  /// ISO 15924 four letter script code.
  String scriptcode;

  /// Script variant.
  ScriptVariant scriptvariant;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['languagecode'] = languagecode;
    json['regioncode'] = regioncode;
    json['scriptcode'] = scriptcode;
    json['scriptvariant'] = scriptvariant.id;
    return json;
  }

  @override
  bool operator ==(covariant final Language other) {
    if (identical(this, other)) {
      return true;
    }

    return other.name == name &&
        other.languagecode == languagecode &&
        other.regioncode == regioncode &&
        other.scriptcode == scriptcode;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        languagecode.hashCode ^
        regioncode.hashCode ^
        scriptcode.hashCode;
  }
}
