import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/core/services/firestore_service.dart';
import 'package:password_generator/models/generator_settings.dart';
import 'package:password_generator/services/settings_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late SettingsService settingsService;
  const userId = 'test-user-123';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    settingsService = SettingsService(firestoreService: firestoreService);
  });

  group('T-4.1: 初回起動時のデフォルト設定', () {
    test('settingsドキュメントが存在しない場合、デフォルト値で作成される', () async {
      final settings = await settingsService.loadOrCreate(userId);

      expect(settings.length, 16);
      expect(settings.useUppercase, true);
      expect(settings.useLowercase, true);
      expect(settings.useNumbers, true);
      expect(settings.useSymbols, true);
      expect(settings.excludeAmbiguous, false);
      expect(settings.customSymbols.values.every((v) => v), true);
      expect(settings.customSymbols.length, 28);
    });
  });

  group('T-4.2: 設定の即時保存', () {
    test('設定を変更するとFirestoreに即時保存される', () async {
      await settingsService.loadOrCreate(userId);
      const updated = GeneratorSettings(length: 20);
      await settingsService.save(userId, updated);

      final doc = await fakeFirestore.collection('settings').doc(userId).get();
      expect(doc.exists, true);
      final data = doc.data();
      expect(data, isNotNull);
      expect(data?['length'], 20);
    });
  });

  group('T-4.3: 保存済み設定の復元', () {
    test('保存時の設定値が正しく復元される', () async {
      const original = GeneratorSettings(
        length: 24,
        useUppercase: false,
        useLowercase: true,
        useNumbers: false,
        useSymbols: true,
        excludeAmbiguous: true,
      );
      await settingsService.save(userId, original);

      final restored = await settingsService.loadOrCreate(userId);

      expect(restored.length, 24);
      expect(restored.useUppercase, false);
      expect(restored.useLowercase, true);
      expect(restored.useNumbers, false);
      expect(restored.useSymbols, true);
      expect(restored.excludeAmbiguous, true);
    });
  });
}
