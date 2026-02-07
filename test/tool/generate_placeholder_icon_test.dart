import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_placeholder_icon.dart' as icon_generator;

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('icon_test_');
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('generatePng', () {
    test('1024x1024のPNGバイナリを生成する', () {
      final bytes = icon_generator.generatePng(
        width: 1024,
        height: 1024,
        r: 0,
        g: 122,
        b: 255,
      );

      // PNG signature
      expect(bytes.sublist(0, 8), [137, 80, 78, 71, 13, 10, 26, 10]);
      expect(bytes.length, greaterThan(0));
    });

    test('IHDRチャンクに正しい画像サイズが含まれる', () {
      final bytes = icon_generator.generatePng(
        width: 1024,
        height: 1024,
        r: 0,
        g: 122,
        b: 255,
      );

      // IHDRチャンクは signature(8bytes) + length(4bytes) の後
      // offset 8: length (4 bytes)
      // offset 12: 'IHDR' (4 bytes)
      // offset 16: width (4 bytes, big-endian)
      // offset 20: height (4 bytes, big-endian)
      // IHDR type
      expect(bytes.sublist(12, 16), 'IHDR'.codeUnits);

      // width = 1024, height = 1024
      final width = ByteData.sublistView(bytes, 16).getUint32(0);
      final height = ByteData.sublistView(bytes, 20).getUint32(0);
      expect(width, 1024);
      expect(height, 1024);
    });

    test('異なるサイズで生成できる', () {
      final bytes = icon_generator.generatePng(
        width: 512,
        height: 512,
        r: 255,
        g: 0,
        b: 0,
      );

      final width = ByteData.sublistView(bytes, 16).getUint32(0);
      final height = ByteData.sublistView(bytes, 20).getUint32(0);
      expect(width, 512);
      expect(height, 512);
    });
  });

  group('saveIcon', () {
    test('指定パスにPNGファイルを保存する', () {
      final outputPath = '${tempDir.path}/test_icon.png';

      icon_generator.saveIcon(
        outputPath: outputPath,
        width: 1024,
        height: 1024,
        r: 0,
        g: 122,
        b: 255,
      );

      final file = File(outputPath);
      expect(file.existsSync(), isTrue);

      final bytes = file.readAsBytesSync();
      expect(bytes.sublist(0, 8), [137, 80, 78, 71, 13, 10, 26, 10]);
    });

    test('親ディレクトリが存在しない場合でも作成して保存する', () {
      final outputPath = '${tempDir.path}/nested/dir/test_icon.png';

      icon_generator.saveIcon(
        outputPath: outputPath,
        width: 1024,
        height: 1024,
        r: 0,
        g: 122,
        b: 255,
      );

      final file = File(outputPath);
      expect(file.existsSync(), isTrue);
    });
  });
}
