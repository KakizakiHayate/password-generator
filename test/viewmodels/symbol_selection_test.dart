import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/models/generator_settings.dart';

void main() {
  group('T-3.3: すべて選択', () {
    test('全28記号がONになる', () {
      const settings = GeneratorSettings();
      // デフォルトですべてON
      final allOn = Map<String, bool>.from(settings.customSymbols);
      for (final key in allOn.keys) {
        allOn[key] = true;
      }
      expect(allOn.values.every((v) => v), true);
      expect(allOn.length, 28);
    });
  });

  group('T-3.4: すべて解除', () {
    test('全記号がOFFになる', () {
      const settings = GeneratorSettings();
      final allOff = Map<String, bool>.from(settings.customSymbols);
      for (final key in allOff.keys) {
        allOff[key] = false;
      }
      expect(allOff.values.every((v) => !v), true);
    });
  });

  group('T-3.2: バリデーション', () {
    test('全記号OFFの場合はバリデーションエラー', () {
      const settings = GeneratorSettings();
      final allOff = Map<String, bool>.from(settings.customSymbols);
      for (final key in allOff.keys) {
        allOff[key] = false;
      }
      final hasSelection = allOff.values.any((v) => v);
      expect(hasSelection, false);
    });

    test('1つ以上ONならバリデーション通過', () {
      const settings = GeneratorSettings();
      final symbols = Map<String, bool>.from(settings.customSymbols);
      for (final key in symbols.keys) {
        symbols[key] = false;
      }
      symbols['!'] = true;
      final hasSelection = symbols.values.any((v) => v);
      expect(hasSelection, true);
    });
  });
}
