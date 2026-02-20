import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/l10n/app_localizations.dart';
import 'package:password_generator/models/generator_settings.dart';
import 'package:password_generator/models/password_strength.dart';
import 'package:password_generator/viewmodels/password_generator_viewmodel.dart';
import 'package:password_generator/views/screens/symbol_selection_screen.dart';

/// テスト用の ViewModel（即座に状態を返す）
class _FakePasswordGeneratorViewModel extends PasswordGeneratorViewModel {
  @override
  Future<PasswordGeneratorState> build() async =>
      const PasswordGeneratorState(
        password: 'TestPassword!',
        settings: GeneratorSettings(),
        strength: PasswordStrength(
          entropy: 80.0,
          level: StrengthLevel.veryStrong,
          crackTimeDisplay: '1000年',
        ),
      );
}

/// Provider を事前ロードし、SymbolSelectionScreen を表示するテストアプリ
Future<ProviderContainer> _pumpTestApp(WidgetTester tester) async {
  final container = ProviderContainer(
    overrides: [
      passwordGeneratorViewModelProvider.overrideWith(
        _FakePasswordGeneratorViewModel.new,
      ),
    ],
  );
  addTearDown(container.dispose);

  // Provider を事前ロード（initState で .value! が成功するように）
  await tester.runAsync(() async {
    await container.read(passwordGeneratorViewModelProvider.future);
  });

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const CupertinoApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('ja'),
        home: SymbolSelectionScreen(),
      ),
    ),
  );
  await tester.pump();
  return container;
}

void main() {
  group('T-3.3: すべて選択', () {
    testWidgets('全28記号がチップとして表示される', (tester) async {
      await _pumpTestApp(tester);

      // デフォルトの28記号が表示されることを確認
      const settings = GeneratorSettings();
      for (final symbol in settings.customSymbols.keys) {
        expect(find.text(symbol), findsOneWidget);
      }
    });

    testWidgets('「すべて解除」→「すべて選択」でチップが切り替わる', (tester) async {
      await _pumpTestApp(tester);

      // デフォルトはすべてONなので「すべて解除」が表示される
      expect(find.text('すべて解除'), findsOneWidget);

      // 「すべて解除」をタップ
      await tester.tap(find.text('すべて解除'));
      await tester.pump();

      // 「すべて選択」に変わる
      expect(find.text('すべて選択'), findsOneWidget);

      // 「すべて選択」をタップ
      await tester.tap(find.text('すべて選択'));
      await tester.pump();

      // 「すべて解除」に戻る
      expect(find.text('すべて解除'), findsOneWidget);
    });
  });

  group('T-3.4: すべて解除', () {
    testWidgets('すべて解除後に「完了」でエラーが表示される', (tester) async {
      await _pumpTestApp(tester);

      // すべて解除
      await tester.tap(find.text('すべて解除'));
      await tester.pump();

      // 完了ボタンをタップ
      await tester.tap(find.text('完了'));
      await tester.pump();

      // エラーメッセージが表示される
      expect(find.text('記号を1つ以上選択してください'), findsOneWidget);
    });
  });

  group('T-3.2: バリデーション', () {
    testWidgets('個別記号のタップでON/OFFが切り替わる', (tester) async {
      await _pumpTestApp(tester);

      // 「!」記号をタップ → OFFに
      await tester.tap(find.text('!'));
      await tester.pump();

      // 再度タップ → ONに戻る
      await tester.tap(find.text('!'));
      await tester.pump();

      // エラーが表示されない（正常状態）
      expect(find.text('記号を1つ以上選択してください'), findsNothing);
    });
  });
}
