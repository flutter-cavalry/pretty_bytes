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

double _log10(num x) => log(x) / ln10;

var _removeTrailingZerosRegex = RegExp(r'([.]*0)(?!.*\d)');

String _toLocaleString(double number, String? locale,
    int? minimumFractionDigits, int? maximumFractionDigits) {
  if (locale == null &&
      minimumFractionDigits == null &&
      maximumFractionDigits == null) {
    return number.toString().replaceAll(_removeTrailingZerosRegex, '');
  }
  final effectiveLocale = locale ?? 'en_US';
  final formatter = NumberFormat(null, effectiveLocale);
  if (minimumFractionDigits != null) {
    formatter.minimumFractionDigits = minimumFractionDigits;
  }
  if (maximumFractionDigits != null) {
    formatter.maximumFractionDigits = maximumFractionDigits;
  }
  if (locale == null) {
    formatter.turnOffGrouping();
  }
  return formatter.format(number);
}

/// Converts [number] bytes to a human readable string.
///
/// ```dart
/// prettyBytes(1024); // 1 KB
/// prettyBytes(1000000); // 1 MB
/// ```
///
/// [signed] Include plus sign for positive numbers. If the value is exactly
/// zero a space character is prepended instead for better alignment.
/// Default: `false`.
///
/// [locale] A [BCP 47 language tag](https://en.wikipedia.org/wiki/IETF_language_tag)
/// (for example `en`, `de`). When `null` the output is not localized.
/// Default: `null`.
///
/// [bits] Format the number as bits instead of bytes. Default: `false`.
///
/// [binary] Use binary (1024) prefixes instead of SI (1000) prefixes.
/// Default: `false`.
///
/// [minimumFractionDigits] Minimum number of fraction digits to display.
/// Default: `null`.
///
/// [maximumFractionDigits] Maximum number of fraction digits to display.
/// Default: `null`.
///
String prettyBytes(
  int number, {
  bool? signed,
  String? locale,
  bool? bits,
  bool? binary,
  int? minimumFractionDigits,
  int? maximumFractionDigits,
}) {
  final UNITS = (bits == true)
      ? (binary == true ? BIBIT_UNITS : BIT_UNITS)
      : (binary == true ? BIBYTE_UNITS : BYTE_UNITS);

  if (signed == true && number == 0) {
    return ' 0 ${UNITS[0]}';
  }

  final isNegative = number < 0;
  final prefix = isNegative ? '-' : (signed == true ? '+' : '');

  var numberValue = (number < 0 ? -number : number).toDouble();

  if (numberValue < 1) {
    final numberStr = _toLocaleString(
        numberValue, locale, minimumFractionDigits, maximumFractionDigits);
    return prefix + numberStr + ' ' + UNITS[0];
  }

  final base = binary == true ? 1024 : 1000;
  var exponent = min(
          (binary == true
                  ? log(numberValue) / log(base)
                  : _log10(numberValue) / 3)
              .floorToDouble(),
          (UNITS.length - 1).toDouble())
      .toInt();

  numberValue /= pow(base, exponent);

  if (numberValue < 1 && exponent > 0) {
    numberValue *= base;
    exponent -= 1;
  }

  if (minimumFractionDigits == null && maximumFractionDigits == null) {
    final minimumPrecision = max(3, numberValue.floor().toString().length);
    numberValue = double.parse(numberValue.toStringAsPrecision(minimumPrecision));
    if (numberValue >= base && exponent < UNITS.length - 1) {
      numberValue /= base;
      exponent += 1;
    }
  }

  final numberStr = _toLocaleString(
      numberValue, locale, minimumFractionDigits, maximumFractionDigits);

  final unit = UNITS[exponent];

  return prefix + numberStr + ' ' + unit;
}



