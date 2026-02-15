import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/l10n/app_localizations.dart';
import 'package:password_generator/views/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CupertinoApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeScreen(),
        ),
      ),
    );

    // ローカライズの解決を待つ
    await tester.pumpAndSettle();

    expect(find.text('Flutter Starter Kit'), findsOneWidget);
    expect(find.text('Hello Starter Kit'), findsOneWidget);
  });
}
