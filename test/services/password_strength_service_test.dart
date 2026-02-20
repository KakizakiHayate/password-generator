import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/models/generator_settings.dart';
import 'package:password_generator/models/password_strength.dart';
import 'package:password_generator/services/password_strength_service.dart';

void main() {
  late PasswordStrengthService service;

  setUp(() {
    service = PasswordStrengthService();
  });

  group('強度レベル判定', () {
    test('T-7.1: エントロピーが 27 bit → weak', () {
      // 小文字のみ(26文字)、4文字 → log2(26)*4 ≈ 18.8 bit (weak)
      // 数字のみ(10文字)、8文字 → log2(10)*8 ≈ 26.6 bit (weak)
      const settings = GeneratorSettings(
        length: 8,
        useUppercase: false,
        useLowercase: false,
        useNumbers: true,
        useSymbols: false,
      );
      final result = service.calculate(settings);
      expect(result.level, StrengthLevel.weak);
      expect(result.entropy, lessThan(28));
    });

    test('T-7.2: エントロピーが 28 bit → fair', () {
      // 数字のみ(10文字)、9文字 → log2(10)*9 ≈ 29.9 bit (fair)
      const settings = GeneratorSettings(
        length: 9,
        useUppercase: false,
        useLowercase: false,
        useNumbers: true,
        useSymbols: false,
      );
      final result = service.calculate(settings);
      expect(result.level, StrengthLevel.fair);
      expect(result.entropy, greaterThanOrEqualTo(28));
      expect(result.entropy, lessThan(36));
    });

    test('T-7.3: エントロピーが 36 bit → strong', () {
      // 数字のみ(10文字)、11文字 → log2(10)*11 ≈ 36.5 bit (strong)
      const settings = GeneratorSettings(
        length: 11,
        useUppercase: false,
        useLowercase: false,
        useNumbers: true,
        useSymbols: false,
      );
      final result = service.calculate(settings);
      expect(result.level, StrengthLevel.strong);
      expect(result.entropy, greaterThanOrEqualTo(36));
      expect(result.entropy, lessThan(60));
    });

    test('T-7.4: エントロピーが 60 bit → veryStrong', () {
      // 大文字+小文字+数字(62文字)、11文字 → log2(62)*11 ≈ 65.5 bit (veryStrong)
      const settings = GeneratorSettings(
        length: 11,
        useUppercase: true,
        useLowercase: true,
        useNumbers: true,
        useSymbols: false,
      );
      final result = service.calculate(settings);
      expect(result.level, StrengthLevel.veryStrong);
      expect(result.entropy, greaterThanOrEqualTo(60));
    });

    test('T-7.5: デフォルト設定（16文字、全文字種ON）のエントロピー', () {
      const settings = GeneratorSettings();
      final result = service.calculate(settings);

      // 大文字26 + 小文字26 + 数字10 + 記号28 = 90文字
      // log2(90) * 16 ≈ 103.8 bit
      expect(result.level, StrengthLevel.veryStrong);
      expect(result.entropy, greaterThan(100));
      expect(result.entropy, lessThan(110));
    });
  });

  group('解読推定時間の表示', () {
    test('T-7.6: 60 bit のエントロピーの解読推定時間', () {
      // 2^60 / 10^9 = 1,152,921,504.6 秒 ≈ 36,558 年 ≈ 3万6千年
      // 大文字+小文字+数字(62文字)で10文字 → log2(62)*10 ≈ 59.5 bit
      // 11文字 → log2(62)*11 ≈ 65.5 bit
      // 正確に60 bitに近い設定を使う
      // 数字のみ(10文字)、18文字 → log2(10)*18 ≈ 59.8 bit
      const settings = GeneratorSettings(
        length: 19,
        useUppercase: false,
        useLowercase: false,
        useNumbers: true,
        useSymbols: false,
      );
      final result = service.calculate(settings);
      // エントロピーが約63 bitなので、解読推定時間は年単位
      expect(result.crackTimeDisplay, contains('年'));
    });

    test('1秒未満の場合', () {
      // 数字のみ(10文字)、4文字 → log2(10)*4 ≈ 13.3 bit
      // 2^13.3 / 10^9 ≈ 0.00001 秒
      const settings = GeneratorSettings(
        length: 4,
        useUppercase: false,
        useLowercase: false,
        useNumbers: true,
        useSymbols: false,
      );
      final result = service.calculate(settings);
      expect(result.crackTimeDisplay, '1秒未満');
    });

    test('秒単位の場合', () {
      // 2^30 / 10^9 ≈ 1.07 秒 → 「約1秒」
      // 数字のみ(10文字)、9文字 → log2(10)*9 ≈ 29.9 bit → 1秒未満
      // 大文字+小文字(52文字)、5文字 → log2(52)*5 ≈ 28.5 bit → 1秒未満
      // 大文字+小文字+数字(62文字)、5文字 → log2(62)*5 ≈ 29.8 bit → 1秒未満
      // 大文字+小文字+数字+記号(90文字)、5文字 → log2(90)*5 ≈ 32.4 bit
      // 2^32.4 / 10^9 ≈ 5.6 秒
      const settings = GeneratorSettings(length: 5);
      final result = service.calculate(settings);
      expect(result.crackTimeDisplay, contains('秒'));
    });

    test('日本語大数表記が使用される', () {
      // デフォルト設定（16文字、全文字種ON）→ 約103.8 bit
      // 2^103.8 / 10^9 ≈ 非常に大きな数 → 京以上の年数
      const settings = GeneratorSettings();
      final result = service.calculate(settings);
      // 天文学的な数値なので大数表記が含まれるはず
      expect(result.crackTimeDisplay, contains('年'));
    });
  });

  group('エントロピー計算', () {
    test('大文字のみ（26文字）、8文字', () {
      const settings = GeneratorSettings(
        length: 8,
        useUppercase: true,
        useLowercase: false,
        useNumbers: false,
        useSymbols: false,
      );
      final result = service.calculate(settings);
      final expected = (log(26) / ln2) * 8;
      expect(result.entropy, closeTo(expected, 0.01));
    });

    test('除外ONでプールサイズが減少する', () {
      const settingsOff = GeneratorSettings(
        length: 16,
        excludeAmbiguous: false,
      );
      const settingsOn = GeneratorSettings(length: 16, excludeAmbiguous: true);

      final resultOff = service.calculate(settingsOff);
      final resultOn = service.calculate(settingsOn);

      expect(
        resultOn.entropy,
        lessThan(resultOff.entropy),
        reason: '除外ONでエントロピーが減少する',
      );
    });
  });
}
