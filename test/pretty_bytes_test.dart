import 'package:pretty_bytes/pretty_bytes.dart';
import 'package:test/test.dart';

void main() {
  test('converts bytes to human readable strings', () {
    expect(prettyBytes(0), '0 B');
    expect(prettyBytes(10), '10 B');
    expect(prettyBytes(10), '10 B');
    expect(prettyBytes(999), '999 B');
    expect(prettyBytes(1001), '1 KB');
    expect(prettyBytes(10000000000000000), '10 PB');
    // expect(prettyBytes(1e30), '1000000 YB');
  });

  test('supports negative number', () {
    expect(prettyBytes(-10), '-10 B');
    expect(prettyBytes(-999), '-999 B');
    expect(prettyBytes(-1001), '-1 KB');
  });

  test('locale option', () {
    expect(prettyBytes(-1001, locale: 'de'), '-1 KB');
    expect(prettyBytes(1001, locale: 'de'), '1 KB');
    expect(prettyBytes(10, locale: 'de'), '10 B');

    expect(prettyBytes(-1001, locale: 'en'), '-1 KB');
    expect(prettyBytes(1001, locale: 'en'), '1 KB');
    expect(prettyBytes(10, locale: 'en'), '10 B');

    expect(
        prettyBytes(
          -1001,
        ),
        '-1 KB');
    expect(
        prettyBytes(
          1001,
        ),
        '1 KB');
    expect(
        prettyBytes(
          10,
        ),
        '10 B');
  });

  test('signed option', () {
    expect(prettyBytes(42, signed: true), '+42 B');
    expect(prettyBytes(-13, signed: true), '-13 B');
    expect(prettyBytes(0, signed: true), ' 0 B');
  });

  test('bits option', () {
    expect(prettyBytes(0, bits: true), '0 b');
    expect(prettyBytes(10, bits: true), '10 b');
    expect(prettyBytes(999, bits: true), '999 b');
    expect(prettyBytes(1001, bits: true), '1 Kbit');
    expect(prettyBytes(1001, bits: true), '1 Kbit');
    expect(prettyBytes(10000000000000000, bits: true), '10 Pbit');
  });

  test('binary option', () {
    expect(prettyBytes(0, binary: true), '0 B');
    expect(prettyBytes(4, binary: true), '4 B');
    expect(prettyBytes(10, binary: true), '10 B');
    expect(prettyBytes(999, binary: true), '999 B');
    expect(prettyBytes(1025, binary: true), '1 KiB');
    expect(prettyBytes(1001, binary: true), '1001 B');
    expect(prettyBytes(10000000000000000, binary: true), '8.88 PiB');
  });

  test('bits and binary option', () {
    expect(prettyBytes(0, bits: true, binary: true), '0 b');
    expect(prettyBytes(4, bits: true, binary: true), '4 b');
    expect(prettyBytes(10, bits: true, binary: true), '10 b');
    expect(prettyBytes(999, bits: true, binary: true), '999 b');
    expect(prettyBytes(1025, bits: true, binary: true), '1 Kibit');
    expect(prettyBytes(1000000, bits: true, binary: true), '977 Kibit');
  });

  test('binary: false uses decimal base', () {
    expect(prettyBytes(1000, binary: false), '1 KB');
    expect(prettyBytes(1024, binary: false), '1.02 KB');
  });

  test('fraction digits options', () {
    expect(prettyBytes(1900, minimumFractionDigits: 3, locale: 'en'), '1.900 KB');
    expect(prettyBytes(1920, maximumFractionDigits: 1, locale: 'en'), '1.9 KB');
    expect(prettyBytes(1900, minimumFractionDigits: 3), '1.900 KB');
  });
}
