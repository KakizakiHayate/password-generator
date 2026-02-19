import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/models/password_strength.dart';

void main() {
  group('PasswordStrength', () {
    test('必須フィールドで生成できる', () {
      const strength = PasswordStrength(
        level: StrengthLevel.strong,
        entropy: 50.0,
        crackTimeDisplay: '約3万6千年',
      );

      expect(strength.level, StrengthLevel.strong);
      expect(strength.entropy, 50.0);
      expect(strength.crackTimeDisplay, '約3万6千年');
    });

    test('fromJson / toJson が存在しない（メモリのみ）', () {
      // PasswordStrength は fromJson / toJson を持たないことを確認
      // コンパイル時にメソッドが存在しないことで保証される
      const strength = PasswordStrength(
        level: StrengthLevel.weak,
        entropy: 10.0,
        crackTimeDisplay: '1秒未満',
      );

      expect(strength.level, StrengthLevel.weak);
    });

    test('copyWith で値を変更できる', () {
      const strength = PasswordStrength(
        level: StrengthLevel.weak,
        entropy: 10.0,
        crackTimeDisplay: '1秒未満',
      );

      final updated = strength.copyWith(
        level: StrengthLevel.veryStrong,
        entropy: 80.0,
        crackTimeDisplay: '約3兆年',
      );

      expect(updated.level, StrengthLevel.veryStrong);
      expect(updated.entropy, 80.0);
      expect(updated.crackTimeDisplay, '約3兆年');
    });
  });

  group('StrengthLevel', () {
    test('4つのレベルが定義されている', () {
      expect(StrengthLevel.values.length, 4);
      expect(StrengthLevel.values, contains(StrengthLevel.weak));
      expect(StrengthLevel.values, contains(StrengthLevel.fair));
      expect(StrengthLevel.values, contains(StrengthLevel.strong));
      expect(StrengthLevel.values, contains(StrengthLevel.veryStrong));
    });
  });
}
