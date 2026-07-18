import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/core/services/auth_service.dart';
import 'package:password_generator/core/services/firestore_service.dart';
import 'package:password_generator/l10n/app_localizations.dart';
import 'package:password_generator/views/screens/settings_test_screen.dart';

/// テスト用の認証サービス（既存テストと同一パターン）
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

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        firestoreServiceProvider.overrideWithValue(firestoreService),
        authServiceProvider.overrideWithValue(FakeAuthService()),
      ],
      child: const CupertinoApp(
        locale: Locale('ja'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SettingsTestScreen(),
      ),
    );
  }

  testWidgets('T-S.1: デフォルト設定（未保存状態）で各項目が表示される', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Firestore動作テスト'), findsOneWidget);
    expect(find.text('Firestoreの現在値（リアルタイム）'), findsOneWidget);
    expect(find.widgetWithText(CupertinoButton, 'Firestoreに保存'), findsOneWidget);
  });

  testWidgets('T-S.2: 保存ボタンを押すとFirestoreに反映されトーストが表示される', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(CupertinoTextField), '柿崎');
    await tester.pump();

    // 保存ボタンはスクロール可能領域の下部にあり、テストのデフォルト画面サイズでは
    // 画面外に位置するため、タップ前にスクロールして可視範囲に入れる
    final saveButton = find.widgetWithText(CupertinoButton, 'Firestoreに保存');
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();

    await tester.tap(saveButton);
    await tester.pump();
    await tester.pump();

    expect(find.text('Firestoreに保存しました'), findsOneWidget);

    final data = await firestoreService.getDocument(
      'test-user-123',
      'settings',
      'default',
    );
    expect(data?['displayName'], '柿崎');
  });
}
