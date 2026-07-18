import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/core/services/auth_service.dart';
import 'package:password_generator/core/services/firestore_service.dart';
import 'package:password_generator/models/user_settings.dart';
import 'package:password_generator/viewmodels/user_settings_viewmodel.dart';

/// テスト用の認証サービス（既存の password_generator_viewmodel_test.dart と同一パターン）
class FakeAuthService implements AuthService {
  @override
  String? get userId => 'test-user-123';

  @override
  bool get isAuthenticated => true;

  @override
  Future<void> ensureAuthenticated() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        firestoreServiceProvider.overrideWithValue(firestoreService),
        authServiceProvider.overrideWithValue(FakeAuthService()),
      ],
    );
  }

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
  });

  group('UserSettingsViewModel.build', () {
    test('T-U.1: settingsドキュメントが存在しない場合、デフォルト値を返す', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      final settings = await container.read(
        userSettingsViewModelProvider.future,
      );

      expect(settings.displayName, '');
      expect(settings.notificationsEnabled, true);
      expect(settings.darkModeEnabled, false);
      expect(settings.language, 'ja');
    });

    test('T-U.2: 保存済みドキュメントがある場合、その値を復元する', () async {
      await firestoreService.setDocument('test-user-123', 'settings', 'default', {
        'displayName': '柿崎',
        'notificationsEnabled': false,
        'darkModeEnabled': true,
        'language': 'en',
      });

      final container = createContainer();
      addTearDown(container.dispose);

      final settings = await container.read(
        userSettingsViewModelProvider.future,
      );

      expect(settings.displayName, '柿崎');
      expect(settings.notificationsEnabled, false);
      expect(settings.darkModeEnabled, true);
      expect(settings.language, 'en');
    });
  });

  group('UserSettingsViewModel 更新系メソッド', () {
    test('T-U.3: updateNotificationEnabledでFirestoreに即時反映される', () async {
      // updateDocument は既存ドキュメントの部分更新のため、
      // 先に saveSettings でドキュメントを作成しておく必要がある
      // （ドキュメント未作成のまま呼ぶと FakeFirestore/not-found になる）
      await firestoreService.setDocument('test-user-123', 'settings', 'default', {
        'displayName': '',
        'notificationsEnabled': true,
        'darkModeEnabled': false,
        'language': 'ja',
      });

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(userSettingsViewModelProvider.future);
      await container
          .read(userSettingsViewModelProvider.notifier)
          .updateNotificationEnabled(false);

      final data = await firestoreService.getDocument(
        'test-user-123',
        'settings',
        'default',
      );
      expect(data?['notificationsEnabled'], false);
    });

    test('T-U.4: saveSettingsで一括保存され、再読み込みで反映される', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(userSettingsViewModelProvider.future);
      await container
          .read(userSettingsViewModelProvider.notifier)
          .saveSettings(
            const UserSettings(
              displayName: 'テスト太郎',
              notificationsEnabled: false,
              darkModeEnabled: true,
              language: 'en',
            ),
          );

      final updated = await container.read(
        userSettingsViewModelProvider.future,
      );
      expect(updated.displayName, 'テスト太郎');
      expect(updated.language, 'en');
    });
  });

  group('userSettingsStreamProvider', () {
    test('T-U.5: Firestoreの変更がストリーム経由で流れる', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      final sub = container.listen(
        userSettingsStreamProvider,
        (previous, next) {},
      );
      addTearDown(sub.close);

      await firestoreService.setDocument('test-user-123', 'settings', 'default', {
        'displayName': 'ストリーム更新',
        'notificationsEnabled': true,
        'darkModeEnabled': false,
        'language': 'ja',
      });

      // ストリームが最新値に到達するまで待機
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final value = container.read(userSettingsStreamProvider).valueOrNull;
      expect(value?.displayName, 'ストリーム更新');
    });
  });
}
