import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/core/services/analytics_service.dart';
import 'package:password_generator/core/services/auth_service.dart';
import 'package:password_generator/core/services/firestore_service.dart';
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
  late UserService userService;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    final firestoreService = FirestoreService(firestore: fakeFirestore);
    userService = UserService(firestoreService: firestoreService);

    container = ProviderContainer(
      overrides: [
        firestoreServiceProvider.overrideWithValue(firestoreService),
        authServiceProvider.overrideWithValue(FakeAuthService()),
        analyticsServiceProvider.overrideWithValue(FakeAnalyticsService()),
        settingsServiceProvider.overrideWithValue(
          SettingsService(firestoreService: firestoreService),
        ),
        userServiceProvider.overrideWithValue(userService),
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

  group('T-10.1: レビュー依頼表示条件（generationCount=3, reviewPromptShown=false）', () {
    test('shouldShowReviewPrompt が true を返す', () async {
      // ユーザードキュメント作成
      await userService.createDefault('test-user-123');
      // generationCount を 3 にする
      await userService.incrementGenerationCount('test-user-123');
      await userService.incrementGenerationCount('test-user-123');
      await userService.incrementGenerationCount('test-user-123');

      // ViewModel初期化
      await container.read(passwordGeneratorViewModelProvider.future);
      final notifier = container.read(
        passwordGeneratorViewModelProvider.notifier,
      );

      final shouldShow = await notifier.shouldShowReviewPrompt();
      expect(shouldShow, true);
    });
  });

  group('T-10.2: レビュー依頼非表示（generationCount=3, reviewPromptShown=true）', () {
    test('shouldShowReviewPrompt が false を返す', () async {
      await userService.createDefault('test-user-123');
      await userService.incrementGenerationCount('test-user-123');
      await userService.incrementGenerationCount('test-user-123');
      await userService.incrementGenerationCount('test-user-123');
      await userService.markReviewPromptShown('test-user-123');

      await container.read(passwordGeneratorViewModelProvider.future);
      final notifier = container.read(
        passwordGeneratorViewModelProvider.notifier,
      );

      final shouldShow = await notifier.shouldShowReviewPrompt();
      expect(shouldShow, false);
    });
  });

  group('T-10.3: レビュー依頼非表示（generationCount=2）', () {
    test('shouldShowReviewPrompt が false を返す', () async {
      await userService.createDefault('test-user-123');
      await userService.incrementGenerationCount('test-user-123');
      await userService.incrementGenerationCount('test-user-123');

      await container.read(passwordGeneratorViewModelProvider.future);
      final notifier = container.read(
        passwordGeneratorViewModelProvider.notifier,
      );

      final shouldShow = await notifier.shouldShowReviewPrompt();
      expect(shouldShow, false);
    });
  });

  group('生成時の generationCount インクリメント', () {
    test('generate() で generationCount が増加する', () async {
      await userService.createDefault('test-user-123');

      await container.read(passwordGeneratorViewModelProvider.future);
      final notifier = container.read(
        passwordGeneratorViewModelProvider.notifier,
      );

      await notifier.generate();

      final user = await userService.get('test-user-123');
      expect(user?.generationCount, 1);
    });
  });
}
