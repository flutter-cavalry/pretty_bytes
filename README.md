# pretty_bytes

[![Build Status](https://github.com/flutter-cavalry/pretty_bytes/workflows/Build/badge.svg)](https://github.com/flutter-cavalry/pretty_bytes/actions)

Dart port of [pretty-bytes](https://github.com/sindresorhus/pretty-bytes).

## Usage

```dart
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
```
