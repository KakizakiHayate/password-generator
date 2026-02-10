import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';

/// ホーム画面
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.appTitle)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.homeGreeting, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 32),
            CupertinoButton.filled(
              onPressed: () => context.goNamed('settings-test'),
              child: Text(l10n.firestoreTestButton),
            ),
          ],
        ),
      ),
    );
  }
}
