import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/models/user.dart';

void main() {
  group('User', () {
    test('デフォルト値で生成できる', () {
      final now = DateTime.now();
      final user = User(createdAt: now);

      expect(user.createdAt, now);
      expect(user.generationCount, 0);
      expect(user.reviewPromptShown, false);
    });

    test('fromJson / toJson が正しく動作する', () {
      final now = DateTime(2026, 2, 19, 12, 0, 0);
      final user = User(
        createdAt: now,
        generationCount: 5,
        reviewPromptShown: true,
      );

      final json = user.toJson();
      final restored = User.fromJson(json);

      expect(restored.createdAt, now);
      expect(restored.generationCount, 5);
      expect(restored.reviewPromptShown, true);
    });

    test('toJson の出力が期待通りのキーを含む', () {
      final now = DateTime(2026, 1, 1);
      final user = User(createdAt: now);
      final json = user.toJson();

      expect(json.containsKey('createdAt'), true);
      expect(json.containsKey('generationCount'), true);
      expect(json.containsKey('reviewPromptShown'), true);
    });

    test('copyWith で値を変更できる', () {
      final now = DateTime.now();
      final user = User(createdAt: now);
      final updated = user.copyWith(
        generationCount: 10,
        reviewPromptShown: true,
      );

      expect(updated.generationCount, 10);
      expect(updated.reviewPromptShown, true);
      expect(updated.createdAt, now);
    });
  });
}
