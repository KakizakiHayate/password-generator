import 'package:flutter/cupertino.dart';
import 'package:flutter_fast_starter/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomePage displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: CupertinoApp(home: HomePage())),
    );

    expect(find.text('Flutter Starter Kit'), findsOneWidget);
    expect(find.text('Hello Starter Kit'), findsOneWidget);
  });
}
