import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/l10n/app_localizations.dart';
import 'package:password_generator/models/generator_settings.dart';
import 'package:password_generator/models/password_strength.dart';
import 'package:password_generator/viewmodels/password_generator_viewmodel.dart';
import 'package:password_generator/views/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen displays correctly', (WidgetTester tester) async {
    const testState = PasswordGeneratorState(
      password: 'TestPassword123!',
      settings: GeneratorSettings(),
      strength: PasswordStrength(
        level: StrengthLevel.veryStrong,
        entropy: 80.0,
        crackTimeDisplay: '1,000 years',
      ),
      candidates: [
        'Candidate1!',
        'Candidate2@',
        'Candidate3#',
        'Candidate4\$',
        'Candidate5%',
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          passwordGeneratorViewModelProvider.overrideWith(() {
            return _FakePasswordGeneratorViewModel(testState);
          }),
        ],
        child: const CupertinoApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeScreen(),
        ),
      ),
    );

    // 非同期ViewModel読み込みを待つ
    await tester.pump();
    await tester.pump();

    // パスワード表示（メインコンテンツ領域）
    expect(find.text('TestPassword123!'), findsOneWidget);
    // CupertinoActivityIndicator が存在しない（ロード完了）
    expect(find.byType(CupertinoActivityIndicator), findsNothing);
    // CupertinoSlider が存在する（設定セクション）
    expect(find.byType(CupertinoSlider), findsOneWidget);
  });
}

/// テスト用の ViewModel（Firestoreアクセス不要）
class _FakePasswordGeneratorViewModel extends PasswordGeneratorViewModel {
  _FakePasswordGeneratorViewModel(this._state);
  final PasswordGeneratorState _state;

  @override
  Future<PasswordGeneratorState> build() async => _state;
}
