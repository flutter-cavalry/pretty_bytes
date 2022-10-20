// ignore_for_file: constant_identifier_names, prefer_interpolation_to_compose_strings, non_constant_identifier_names

import 'dart:math';

import 'package:intl/intl.dart';

const BYTE_UNITS = [
  'B',
  'KB',
  'MB',
  'GB',
  'TB',
  'PB',
  'EB',
  'ZB',
  'YB',
];

const BIBYTE_UNITS = [
  'B',
  'KiB',
  'MiB',
  'GiB',
  'TiB',
  'PiB',
  'EiB',
  'ZiB',
  'YiB',
];

const BIT_UNITS = [
  'b',
  'Kbit',
  'Mbit',
  'Gbit',
  'Tbit',
  'Pbit',
  'Ebit',
  'Zbit',
  'Ybit',
];

const BIBIT_UNITS = [
  'b',
  'Kibit',
  'Mibit',
  'Gibit',
  'Tibit',
  'Pibit',
  'Eibit',
  'Zibit',
  'Yibit',
];

double log10(num x) => log(x) / ln10;

var removeTrailingZerosRegex = RegExp(r'([.]*0)(?!.*\d)');

String toLocaleString(double number, String? locale, int? minimumFractionDigits,
    int? maximumFractionDigits) {
  if (locale == null) {
    return number.toString().replaceAll(removeTrailingZerosRegex, '');
  }
  var formatter = NumberFormat(null, locale);
  if (maximumFractionDigits != null) {
    formatter.minimumFractionDigits = minimumFractionDigits!;
  }
  if (minimumFractionDigits != null) {
    formatter.maximumFractionDigits = maximumFractionDigits!;
  }
  return formatter.format(number);
}

String prettyBytes(
  double number, {

  /// Include plus sign for positive numbers. If the difference is exactly zero a space character will be prepended instead for better alignment.
  /// Default: false.
  bool? signed,

  /// - If `null`: Output won't be localized.
  /// - If `string`: Expects a [BCP 47 language tag](https://en.wikipedia.org/wiki/IETF_language_tag) (For example: `en`, `de`, …)
  /// @default null
  String? locale,

  /// Format the number as [bits](https://en.wikipedia.org/wiki/Bit) instead of [bytes](https://en.wikipedia.org/wiki/Byte). This can be useful when, for example, referring to [bit rate](https://en.wikipedia.org/wiki/Bit_rate).
  /// Default: false.
  /// @example
  /// ```
  /// prettyBytes(1337, bits: true);
  /// //=> '1.34 kbit'
  /// ```
  bool? bits,

  /// Format the number using the [Binary Prefix](https://en.wikipedia.org/wiki/Binary_prefix) instead of the [SI Prefix](https://en.wikipedia.org/wiki/SI_prefix). This can be useful for presenting memory amounts. However, this should not be used for presenting file sizes.
  /// Default: false.
  /// @example
  /// ```
  /// prettyBytes(1000, binary: true);
  /// //=> '1000 bit'
  /// prettyBytes(1024, binary: true);
  /// //=> '1 kiB'
  /// ```
  bool? binary,

  /// The minimum number of fraction digits to display.
  /// If neither `minimumFractionDigits` or `maximumFractionDigits` are set, the default behavior is to round to 3 significant digits.
  /// @default null
  /// ```
  /// // Show the number with at least 3 fractional digits
  /// prettyBytes(1900, {minimumFractionDigits: 3});
  /// //=> '1.900 kB'
  /// prettyBytes(1900);
  /// //=> '1.9 kB'
  /// ```
  int? minimumFractionDigits,

  /// The maximum number of fraction digits to display.
  /// If neither `minimumFractionDigits` or `maximumFractionDigits` are set, the default behavior is to round to 3 significant digits.
  /// @default null
  /// ```
  /// // Show the number with at most 1 fractional digit
  /// prettyBytes(1920, {maximumFractionDigits: 1});
  /// //=> '1.9 kB'
  /// prettyBytes(1920);
  /// //=> '1.92 kB'
  /// ```
  int? maximumFractionDigits,
}) {
  var UNITS = (bits == true)
      ? (binary == true ? BIBIT_UNITS : BIT_UNITS)
      : (binary == true ? BIBYTE_UNITS : BYTE_UNITS);

  if (signed == true && number == 0) {
    return ' 0 ${UNITS[0]}';
  }

  var isNegative = number < 0;
  var prefix = isNegative ? '-' : (signed == true ? '+' : '');

  if (isNegative) {
    number = -number;
  }

  if (number < 1) {
    var numberStr = toLocaleString(
        number, locale, minimumFractionDigits, maximumFractionDigits);
    return prefix + numberStr + ' ' + UNITS[0];
  }

  var exponent = min(
          (binary != null ? log(number) / log(1024) : log10(number) / 3)
              .floorToDouble(),
          (UNITS.length - 1).toDouble())
      .toInt();
  number /= pow(binary != null ? 1024 : 1000, exponent);
  if (minimumFractionDigits == null && maximumFractionDigits == null) {
    number = double.parse(number.toStringAsPrecision(3));
  }

  var numberStr = toLocaleString(
      number, locale, minimumFractionDigits, maximumFractionDigits);

  var unit = UNITS[exponent];

  return prefix + numberStr + ' ' + unit;
}
