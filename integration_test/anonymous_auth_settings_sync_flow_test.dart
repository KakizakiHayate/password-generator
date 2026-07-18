import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:password_generator/core/services/analytics_service.dart';
import 'package:password_generator/core/services/auth_service.dart';
import 'package:password_generator/core/services/firestore_service.dart';
import 'package:password_generator/models/generator_settings.dart';
import 'package:password_generator/services/password_generator_service.dart';
import 'package:password_generator/services/password_strength_service.dart';
import 'package:password_generator/services/settings_service.dart';
import 'package:password_generator/services/user_service.dart';
import 'package:password_generator/viewmodels/password_generator_viewmodel.dart';

/// 匿名認証 → Firestore設定同期のIntegration Test（v4 3.4-4）。
///
/// `docs/test-cases.md` 5.3 は「匿名認証 → Firestore 設定同期という連携は
/// 実在するため該当。ただし範囲は限定的で、優先度は低い」と判定している。
/// 発注者指示により、この1本のみを範囲限定で作成する。
///
/// 対象は `PasswordGeneratorViewModel.build()`
/// （`lib/viewmodels/password_generator_viewmodel.dart`）: 匿名認証済みユーザーの
/// `userId` を使って `SettingsService.loadOrCreate` → 設定変更のたびに
/// `SettingsService.save` → 次回 `build()` 再構築時に保存済み設定が復元される、
/// という複数コンポーネント（AuthService/SettingsService/FirestoreService）を
/// またぐ連携を検証する。
///
/// 実機/シミュレーターでの実行が必要な理由: `integration_test` パッケージは
/// 実際の Flutter エンジン上でウィジェットバインディングを初期化するため。
///
/// UI（`home_screen.dart`/新設の`customize_sheet.dart`）を経由しない理由:
/// 着手時点でこれらの画面は大規模な進行中の本開発作業（多言語化・UI再構成）の
/// 影響下にあり、構造が確定していないため。本テストは進行中作業の影響を
/// 受けない ViewModel/Service 層のみを対象とし、`ProviderContainer` を通じて
/// 実際の非同期処理・状態遷移・Firestore永続化を検証する。
///
/// 本番外部データ保護（4-5章）: `AuthService`/`AnalyticsService`は実Firebaseへの
/// 書き込みを避けるためフェイクに差し替える。`SettingsService`/`UserService`は
/// `fake_cloud_firestore`を注入した実サービスを使う（本番Firestoreには一切触れない）。
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const uid = 'integration-test-uid';

  ProviderContainer buildContainer(FirestoreService firestoreService) {
    return ProviderContainer(
      overrides: [
        firestoreServiceProvider.overrideWithValue(firestoreService),
        authServiceProvider.overrideWithValue(_FakeAuthService()),
        analyticsServiceProvider.overrideWithValue(_FakeAnalyticsService()),
        settingsServiceProvider.overrideWithValue(
          SettingsService(firestoreService: firestoreService),
        ),
        userServiceProvider.overrideWithValue(
          UserService(firestoreService: firestoreService),
        ),
        passwordGeneratorServiceProvider.overrideWithValue(
          PasswordGeneratorService(),
        ),
        passwordStrengthServiceProvider.overrideWithValue(
          PasswordStrengthService(),
        ),
      ],
    );
  }

  testWidgets(
    'T-Int.1: 匿名認証ユーザーの設定変更がFirestoreに永続化され、'
    '次回のViewModel再構築時に復元される',
    (tester) async {
      final fakeFirestore = FakeFirebaseFirestore();
      final firestoreService = FirestoreService(firestore: fakeFirestore);

      // ---- 1回目のセッション: デフォルト設定を確認し、文字数と大文字設定を変更 ----
      final firstContainer = buildContainer(firestoreService);
      addTearDown(firstContainer.dispose);

      final initialState = await firstContainer.read(
        passwordGeneratorViewModelProvider.future,
      );
      expect(initialState.settings.length, 16);
      expect(initialState.settings.useUppercase, true);

      final notifier = firstContainer.read(
        passwordGeneratorViewModelProvider.notifier,
      );
      await notifier.updateLength(24);
      await notifier.toggleUppercase();

      final updatedState = firstContainer.read(
        passwordGeneratorViewModelProvider,
      ).value!;
      expect(updatedState.settings.length, 24);
      expect(updatedState.settings.useUppercase, false);

      // Firestoreに実際に永続化されたことを直接確認する
      final doc = await fakeFirestore.collection('settings').doc(uid).get();
      expect(doc.exists, isTrue);
      expect(doc.data()?['length'], 24);
      expect(doc.data()?['useUppercase'], false);

      // ---- 2回目のセッション（アプリ再起動相当）: 新しいContainer/ViewModelで
      //      保存済み設定が復元されることを確認する ----
      final secondContainer = buildContainer(firestoreService);
      addTearDown(secondContainer.dispose);

      final restoredState = await secondContainer.read(
        passwordGeneratorViewModelProvider.future,
      );
      expect(restoredState.settings.length, 24);
      expect(restoredState.settings.useUppercase, false);
      // 復元された設定に基づいてパスワードが自動生成されている
      expect(restoredState.password.length, 24);
    },
  );
}

class _FakeAuthService implements AuthService {
  @override
  String? get userId => 'integration-test-uid';

  @override
  bool get isAuthenticated => true;

  @override
  Future<void> ensureAuthenticated() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAnalyticsService implements AnalyticsService {
  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
