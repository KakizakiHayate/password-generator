import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/models/generator_settings.dart';

void main() {
  group('GeneratorSettings', () {
    /// T-4.1: GeneratorSettings をデフォルトで生成する
    test('T-4.1: デフォルト値がドキュメント通り', () {
      const settings = GeneratorSettings();

      // 文字数16
      expect(settings.length, 16);
      // 全トグルON
      expect(settings.useUppercase, true);
      expect(settings.useLowercase, true);
      expect(settings.useNumbers, true);
      expect(settings.useSymbols, true);
      // 除外OFF
      expect(settings.excludeAmbiguous, false);
      // 全28記号ON
      expect(settings.customSymbols.length, 28);
      for (final entry in settings.customSymbols.entries) {
        expect(entry.value, true, reason: '記号 "${entry.key}" がデフォルトで true');
      }
    });

    test('対象28記号がすべて含まれている', () {
      const settings = GeneratorSettings();
      const expectedSymbols = [
        '!',
        '@',
        '#',
        r'$',
        '%',
        '^',
        '&',
        '*',
        '(',
        ')',
        '-',
        '_',
        '=',
        '+',
        '[',
        ']',
        '{',
        '}',
        ';',
        ':',
        ',',
        '.',
        '<',
        '>',
        '?',
        '/',
        '~',
        '|',
      ];

      for (final symbol in expectedSymbols) {
        expect(
          settings.customSymbols.containsKey(symbol),
          true,
          reason: '記号 "$symbol" が含まれている',
        );
      }
      expect(settings.customSymbols.length, expectedSymbols.length);
    });

    test('fromJson / toJson が正しく動作する', () {
      const settings = GeneratorSettings(
        length: 24,
        useUppercase: false,
        useLowercase: true,
        useNumbers: false,
        useSymbols: true,
        excludeAmbiguous: true,
      );

      final json = settings.toJson();
      final restored = GeneratorSettings.fromJson(json);

      expect(restored.length, 24);
      expect(restored.useUppercase, false);
      expect(restored.useLowercase, true);
      expect(restored.useNumbers, false);
      expect(restored.useSymbols, true);
      expect(restored.excludeAmbiguous, true);
    });

    test('customSymbols の fromJson / toJson が正しく動作する', () {
      const settings = GeneratorSettings();
      final modified = settings.copyWith(
        customSymbols: {...settings.customSymbols, '!': false, '@': false},
      );

      final json = modified.toJson();
      final restored = GeneratorSettings.fromJson(json);

      expect(restored.customSymbols['!'], false);
      expect(restored.customSymbols['@'], false);
      expect(restored.customSymbols['#'], true);
    });

    test('copyWith で値を変更できる', () {
      const settings = GeneratorSettings();
      final updated = settings.copyWith(length: 32, useUppercase: false);

      expect(updated.length, 32);
      expect(updated.useUppercase, false);
      // 変更していない値は維持される
      expect(updated.useLowercase, true);
      expect(updated.useNumbers, true);
    });
  });
}
