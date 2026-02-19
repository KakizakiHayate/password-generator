import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/models/generator_settings.dart';
import 'package:password_generator/services/password_generator_service.dart';

void main() {
  late PasswordGeneratorService service;

  setUp(() {
    service = PasswordGeneratorService();
  });

  group('パスワード生成エンジン（F-01）', () {
    test('T-1.1: デフォルト設定（16文字、全文字種ON）で生成する', () {
      const settings = GeneratorSettings();
      final password = service.generate(settings);

      expect(password.length, 16);
      expect(password.contains(RegExp(r'[A-Z]')), true, reason: '大文字を含む');
      expect(password.contains(RegExp(r'[a-z]')), true, reason: '小文字を含む');
      expect(password.contains(RegExp(r'[0-9]')), true, reason: '数字を含む');
      expect(password.contains(RegExp(r'[^A-Za-z0-9]')), true, reason: '記号を含む');
    });

    test('T-1.2: 文字数を4、全文字種ONで生成する', () {
      const settings = GeneratorSettings(length: 4);
      final password = service.generate(settings);

      expect(password.length, 4);
      expect(password.contains(RegExp(r'[A-Z]')), true, reason: '大文字を含む');
      expect(password.contains(RegExp(r'[a-z]')), true, reason: '小文字を含む');
      expect(password.contains(RegExp(r'[0-9]')), true, reason: '数字を含む');
      expect(password.contains(RegExp(r'[^A-Za-z0-9]')), true, reason: '記号を含む');
    });

    test('T-1.3: 文字数を128で生成する', () {
      const settings = GeneratorSettings(length: 128);
      final password = service.generate(settings);

      expect(password.length, 128);
    });

    test('T-1.4: 大文字のみONで生成する', () {
      const settings = GeneratorSettings(
        useUppercase: true,
        useLowercase: false,
        useNumbers: false,
        useSymbols: false,
      );
      final password = service.generate(settings);

      expect(password.length, 16);
      expect(password.contains(RegExp(r'^[A-Z]+$')), true, reason: 'A-Zのみで構成');
    });

    test('T-1.5: 最後の1つの文字種をOFFにしようとする', () {
      // 大文字のみONの状態で、大文字をOFFにしようとする
      const settings = GeneratorSettings(
        useUppercase: true,
        useLowercase: false,
        useNumbers: false,
        useSymbols: false,
      );

      expect(service.canToggleOff(settings, 'useUppercase'), false);
    });

    test('T-1.5 補足: 複数ONの場合はOFFにできる', () {
      const settings = GeneratorSettings();

      expect(service.canToggleOff(settings, 'useUppercase'), true);
      expect(service.canToggleOff(settings, 'useLowercase'), true);
      expect(service.canToggleOff(settings, 'useNumbers'), true);
      expect(service.canToggleOff(settings, 'useSymbols'), true);
    });

    test('T-1.6: 同じ設定で2回生成する', () {
      const settings = GeneratorSettings();
      final password1 = service.generate(settings);
      final password2 = service.generate(settings);

      // 乱数性の確認（極めて低い確率で同一になる可能性はあるが、実質的に異なる）
      expect(password1 != password2, true, reason: '異なるパスワードが生成される');
    });
  });

  group('紛らわしい文字の除外（F-02）', () {
    test('T-2.1: 除外ONで生成する（全文字種ON、十分な文字数）', () {
      const settings = GeneratorSettings(length: 128, excludeAmbiguous: true);

      // 複数回生成して紛らわしい文字が含まれないことを確認
      for (var i = 0; i < 10; i++) {
        final password = service.generate(settings);
        const ambiguous = ['o', 'O', '0', 'l', 'I', '1', '|', '`', "'", '"'];
        for (final char in ambiguous) {
          expect(
            password.contains(char),
            false,
            reason: '紛らわしい文字 "$char" が含まれない',
          );
        }
      }
    });

    test('T-2.2: 除外ON + 数字のみONで生成する', () {
      const settings = GeneratorSettings(
        length: 128,
        useUppercase: false,
        useLowercase: false,
        useNumbers: true,
        useSymbols: false,
        excludeAmbiguous: true,
      );

      for (var i = 0; i < 10; i++) {
        final password = service.generate(settings);
        // 0 と 1 が除外され、2-9 のみで構成される
        expect(
          password.contains(RegExp(r'^[2-9]+$')),
          true,
          reason: '2-9のみで構成される',
        );
      }
    });
  });

  group('特殊文字のカスタム選択（F-03）', () {
    test('T-3.1: ! @ # の3記号のみONにして記号トグルONで生成する', () {
      const settings = GeneratorSettings(
        length: 128,
        useUppercase: false,
        useLowercase: false,
        useNumbers: false,
        useSymbols: true,
        customSymbols: {
          '!': true,
          '@': true,
          '#': true,
          r'$': false,
          '%': false,
          '^': false,
          '&': false,
          '*': false,
          '(': false,
          ')': false,
          '-': false,
          '_': false,
          '=': false,
          '+': false,
          '[': false,
          ']': false,
          '{': false,
          '}': false,
          ';': false,
          ':': false,
          ',': false,
          '.': false,
          '<': false,
          '>': false,
          '?': false,
          '/': false,
          '~': false,
          '|': false,
        },
      );

      for (var i = 0; i < 10; i++) {
        final password = service.generate(settings);
        // パスワードの記号部分が ! @ # のみで構成される
        expect(
          password.contains(RegExp(r'^[!@#]+$')),
          true,
          reason: '! @ # のみで構成される',
        );
      }
    });

    test('T-3.2: 全記号OFFの状態で生成しようとする', () {
      // 全記号OFFの場合、記号プールが空になる
      // 記号トグルONでも記号が選択されていなければ記号なしで生成される
      // （UIレベルでモーダルの「完了」を押せないようにする）
      const settings = GeneratorSettings(
        useUppercase: true,
        useLowercase: false,
        useNumbers: false,
        useSymbols: true,
        customSymbols: {
          '!': false,
          '@': false,
          '#': false,
          r'$': false,
          '%': false,
          '^': false,
          '&': false,
          '*': false,
          '(': false,
          ')': false,
          '-': false,
          '_': false,
          '=': false,
          '+': false,
          '[': false,
          ']': false,
          '{': false,
          '}': false,
          ';': false,
          ':': false,
          ',': false,
          '.': false,
          '<': false,
          '>': false,
          '?': false,
          '/': false,
          '~': false,
          '|': false,
        },
      );

      // 記号プールが空でも他の文字種があれば生成可能
      final password = service.generate(settings);
      expect(password.isNotEmpty, true);
      // 大文字のみで構成される（記号プールが空のため）
      expect(
        password.contains(RegExp(r'^[A-Z]+$')),
        true,
        reason: '記号プールが空のため大文字のみ',
      );
    });
  });

  group('エッジケース', () {
    test('小文字のみONで生成する', () {
      const settings = GeneratorSettings(
        useUppercase: false,
        useLowercase: true,
        useNumbers: false,
        useSymbols: false,
      );
      final password = service.generate(settings);

      expect(password.contains(RegExp(r'^[a-z]+$')), true, reason: 'a-zのみで構成');
    });

    test('数字のみONで生成する', () {
      const settings = GeneratorSettings(
        useUppercase: false,
        useLowercase: false,
        useNumbers: true,
        useSymbols: false,
      );
      final password = service.generate(settings);

      expect(password.contains(RegExp(r'^[0-9]+$')), true, reason: '0-9のみで構成');
    });
  });
}
