import 'package:gem_kit/src/gem_kit_platform_interface.dart';

/// ISO code variants
///
/// {@category Core}
enum ISOCodeType {
  ///< Invalid ISO code
  invalid,

  ///< 2 letter ISO code
  iso_2,

  ///< 3 letter ISO code
  iso_3,
}

/// @nodoc
extension ISOCodeTypeExtension on ISOCodeType {
  int get id {
    switch (this) {
      case ISOCodeType.invalid:
        return -1;
      case ISOCodeType.iso_2:
        return 0;
      case ISOCodeType.iso_3:
        return 1;
    }
  }

  static ISOCodeType fromId(final int id) {
    switch (id) {
      case -1:
        return ISOCodeType.invalid;
      case 0:
        return ISOCodeType.iso_2;
      case 1:
        return ISOCodeType.iso_3;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// ISO codes conversions class. It performs language & country conversions iso2 to iso3 / iso3 to iso2
///
/// {@category Core}
abstract class ISOCodeConversions {
  /// Convert country iso code ( ISO2 <-> ISO3 )
  ///
  /// **Parameters**
  ///
  /// * **IN** *code* The country ISO code to be converted
  /// * **IN** *type* The result country ISO code type
  ///
  /// **Returns**
  ///
  /// * The converted country ISO code.
  static String convertCountryIso(String code, ISOCodeType type) {
    final OperationResult resultString = staticMethod(
      'ISOCodeConversions',
      'convertCountryIso',
      args: <String, dynamic>{
        'code': code,
        'type': type.id,
      },
    );

    final String result = resultString['result'];

    return result;
  }

  /// Convert language iso code ( ISO2 <-> ISO3 )
  ///
  /// **Parameters**
  ///
  /// * **IN** *code* The language ISO code to be converted
  /// * **IN** *type* The result language ISO code type
  ///
  /// **Returns**
  ///
  /// * The converted language ISO code.
  static String convertLanguageIso(String code, ISOCodeType type) {
    final OperationResult resultString = staticMethod(
      'ISOCodeConversions',
      'convertLanguageIso',
      args: <String, dynamic>{
        'code': code,
        'type': type.id,
      },
    );

    final String result = resultString['result'];

    return result;
  }
}
