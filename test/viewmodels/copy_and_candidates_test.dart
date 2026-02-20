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

  group('T-6.1: 候補リスト生成', () {
    test('5件の候補が生成される', () async {
      final state = await container.read(
        passwordGeneratorViewModelProvider.future,
      );

      expect(state.candidates.length, 5);
      for (final candidate in state.candidates) {
        expect(candidate.length, 16);
        expect(candidate, isNotEmpty);
      }
    });
  });

  group('T-6.2: メインの生成で候補も再生成される', () {
    test('generate() でメインパスワードと候補がすべて再生成される', () async {
      final state1 = await container.read(
        passwordGeneratorViewModelProvider.future,
      );
      final oldPassword = state1.password;
      final oldCandidates = List<String>.from(state1.candidates);

      final notifier = container.read(
        passwordGeneratorViewModelProvider.notifier,
      );
      await notifier.generate();

      final state2 = await container.read(
        passwordGeneratorViewModelProvider.future,
      );

      // メインパスワードが再生成される
      expect(state2.password, isNot(equals(oldPassword)));
      // 候補も再生成される
      expect(state2.candidates.length, 5);
      // 候補が異なることを確認（乱数なので確率的にほぼ確実に異なる）
      final hasChanged = state2.candidates.asMap().entries.any(
        (e) => e.value != oldCandidates[e.key],
      );
      expect(hasChanged, true);
    });
  });

  group('候補の再生成', () {
    test('regenerateCandidates() で候補のみ再生成される', () async {
      final state1 = await container.read(
        passwordGeneratorViewModelProvider.future,
      );
      final mainPassword = state1.password;

      final notifier = container.read(
        passwordGeneratorViewModelProvider.notifier,
      );
      await notifier.regenerateCandidates();

      final state2 = await container.read(
        passwordGeneratorViewModelProvider.future,
      );

      // メインパスワードは変わらない
      expect(state2.password, equals(mainPassword));
      // 候補は再生成される
      expect(state2.candidates.length, 5);
    });
  });
}
