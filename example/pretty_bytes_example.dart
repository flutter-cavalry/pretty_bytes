// ignore_for_file: avoid_print

import 'package:pretty_bytes/pretty_bytes.dart';

void main() {
  print(prettyBytes(5000));
  // 5 KB

  print(prettyBytes(5000, signed: true));
  // +5 KB

  print(prettyBytes(5000, bits: true));
  // 5 Kbit

  print(prettyBytes(1025, binary: true));
  // 1 KiB

  print(prettyBytes(0.4, locale: 'de'));
  // 0,4 B
}
