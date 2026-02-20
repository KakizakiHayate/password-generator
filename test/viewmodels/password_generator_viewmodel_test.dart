import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/core/services/analytics_service.dart';
import 'package:password_generator/core/services/auth_service.dart';
import 'package:password_generator/core/services/firestore_service.dart';
import 'package:password_generator/models/password_strength.dart';
import 'package:password_generator/services/password_generator_service.dart';
import 'package:password_generator/services/password_strength_service.dart';
import 'package:password_generator/services/settings_service.dart';
import 'package:password_generator/services/user_service.dart';
import 'package:password_generator/viewmodels/password_generator_viewmodel.dart';

/// テスト用の Analytics サービス（何もしない）
class FakeAnalyticsService implements AnalyticsService {
  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// テスト用の認証サービス
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
  late ProviderContainer container;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    final firestoreService = FirestoreService(firestore: fakeFirestore);

    container = ProviderContainer(
      overrides: [
        firestoreServiceProvider.overrideWithValue(firestoreService),
        authServiceProvider.overrideWithValue(FakeAuthService()),
        analyticsServiceProvider.overrideWithValue(FakeAnalyticsService()),
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
  });

  tearDown(() {
    container.dispose();
  });

  group('T-11.3: 設定復元後にパスワード自動生成', () {
    test('初期ビルド時にデフォルト設定でパスワードが自動生成される', () async {
      final state = await container.read(
        passwordGeneratorViewModelProvider.future,
      );

      expect(state.password, isNotEmpty);
      expect(state.password.length, 16);
      expect(state.settings.length, 16);
      expect(state.settings.useUppercase, true);
      expect(state.settings.useLowercase, true);
      expect(state.settings.useNumbers, true);
      expect(state.settings.useSymbols, true);
      expect(state.strength.level, StrengthLevel.veryStrong);
    });
  });

  group('生成ボタン', () {
    test('generate() で新しいパスワードが生成される', () async {
      final state1 = await container.read(
        passwordGeneratorViewModelProvider.future,
      );
      final password1 = state1.password;

      final notifier = container.read(
        passwordGeneratorViewModelProvider.notifier,
      );
      await notifier.generate();

      final state2 = await container.read(
        passwordGeneratorViewModelProvider.future,
      );
      expect(state2.password, isNotEmpty);
      expect(state2.password.length, 16);
      // 乱数なので同じパスワードの可能性は極めて低いが、長さと非空のみ検証
      expect(state2.password, isNot(equals(password1)));
    });
  });

  group('設定変更', () {
    test('文字数変更で設定が保存されパスワードが再生成される', () async {
      await container.read(passwordGeneratorViewModelProvider.future);

      final notifier = container.read(
        passwordGeneratorViewModelProvider.notifier,
      );
      await notifier.updateLength(24);

      final state = await container.read(
        passwordGeneratorViewModelProvider.future,
      );
      expect(state.settings.length, 24);
      expect(state.password.length, 24);

      // Firestoreに保存されていることを確認
      final doc = await fakeFirestore
          .collection('settings')
          .doc('test-user-123')
          .get();
      expect(doc.data()?['length'], 24);
    });

    test('大文字トグルOFFで設定が更新される', () async {
      await container.read(passwordGeneratorViewModelProvider.future);

      final notifier = container.read(
        passwordGeneratorViewModelProvider.notifier,
      );
      await notifier.toggleUppercase();

      final state = await container.read(
        passwordGeneratorViewModelProvider.future,
      );
      expect(state.settings.useUppercase, false);
      expect(state.password, isNotEmpty);
    });

    test('小文字トグルOFFで設定が更新される', () async {
      await container.read(passwordGeneratorViewModelProvider.future);

      final notifier = container.read(
        passwordGeneratorViewModelProvider.notifier,
      );
      await notifier.toggleLowercase();

      final state = await container.read(
        passwordGeneratorViewModelProvider.future,
      );
      expect(state.settings.useLowercase, false);
    });

    test('数字トグルOFFで設定が更新される', () async {
      await container.read(passwordGeneratorViewModelProvider.future);

      final notifier = container.read(
        passwordGeneratorViewModelProvider.notifier,
      );
      await notifier.toggleNumbers();

      final state = await container.read(
        passwordGeneratorViewModelProvider.future,
      );
      expect(state.settings.useNumbers, false);
    });

    test('記号トグルOFFで設定が更新される', () async {
      await container.read(passwordGeneratorViewModelProvider.future);

      final notifier = container.read(
        passwordGeneratorViewModelProvider.notifier,
      );
      await notifier.toggleSymbols();

      final state = await container.read(
        passwordGeneratorViewModelProvider.future,
      );
      expect(state.settings.useSymbols, false);
    });

    test('最後の文字種はOFFにできない（T-1.5）', () async {
      await container.read(passwordGeneratorViewModelProvider.future);

      final notifier = container.read(
        passwordGeneratorViewModelProvider.notifier,
      );

      // 3つOFFにして数字のみONにする
      await notifier.toggleUppercase();
      await notifier.toggleLowercase();
      await notifier.toggleSymbols();

      // 数字のみON
      var state = await container.read(
        passwordGeneratorViewModelProvider.future,
      );
      expect(state.settings.useNumbers, true);
      expect(state.settings.useUppercase, false);
      expect(state.settings.useLowercase, false);
      expect(state.settings.useSymbols, false);

      // 最後のトグルをOFFにしようとする → 防止される
      await notifier.toggleNumbers();

      state = await container.read(passwordGeneratorViewModelProvider.future);
      expect(state.settings.useNumbers, true);
    });

    test('紛らわしい文字除外トグルで設定が更新される', () async {
      await container.read(passwordGeneratorViewModelProvider.future);

      final notifier = container.read(
        passwordGeneratorViewModelProvider.notifier,
      );
      await notifier.toggleExcludeAmbiguous();

      final state = await container.read(
        passwordGeneratorViewModelProvider.future,
      );
      expect(state.settings.excludeAmbiguous, true);
    });
  });

  group('強度計算', () {
    test('生成のたびに強度が更新される', () async {
      await container.read(passwordGeneratorViewModelProvider.future);

      final notifier = container.read(
        passwordGeneratorViewModelProvider.notifier,
      );

      // 文字数を短くして強度が変わることを確認
      await notifier.updateLength(4);

      final state = await container.read(
        passwordGeneratorViewModelProvider.future,
      );
      expect(state.strength.entropy, lessThan(28));
      expect(state.strength.level, StrengthLevel.weak);
      expect(state.strength.crackTimeDisplay, isNotEmpty);
    });
  });
}
