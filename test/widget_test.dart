import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/core/services/auth_service.dart';
import 'package:password_generator/core/services/firestore_service.dart';
import 'package:password_generator/l10n/app_localizations.dart';
import 'package:password_generator/services/password_generator_service.dart';
import 'package:password_generator/services/password_strength_service.dart';
import 'package:password_generator/services/settings_service.dart';
import 'package:password_generator/services/user_service.dart';
import 'package:password_generator/views/screens/home_screen.dart';

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
  testWidgets('HomeScreen displays correctly', (WidgetTester tester) async {
    final fakeFirestore = FakeFirebaseFirestore();
    final firestoreService = FirestoreService(firestore: fakeFirestore);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          firestoreServiceProvider.overrideWithValue(firestoreService),
          authServiceProvider.overrideWithValue(FakeAuthService()),
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
        child: const CupertinoApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeScreen(),
        ),
      ),
    );

    // 非同期ViewModel読み込みを待つ（pumpAndSettleはActivityIndicatorで止まるため pump を使用）
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // ナビゲーションバーのタイトル（テスト環境はデフォルト英語ロケール）
    expect(find.text('Password Generator'), findsOneWidget);
    // 生成ボタン
    expect(find.text('Generate'), findsOneWidget);
  });
}
