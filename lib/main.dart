import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/services/analytics_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/crashlytics_service.dart';
import 'core/services/preferences_service.dart';
import 'core/theme/cupertino_theme.dart';
import 'firebase_options.dart';
import 'views/screens/settings_test_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ProviderContainerを作成し、アプリ起動前の初期化処理を実行
  final container = ProviderContainer();
  await _initializeServices(container);

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

/// アプリ起動前のサービス初期化処理
Future<void> _initializeServices(ProviderContainer container) async {
  // 0. ローカルストレージを初期化
  await PreferencesService.initialize();

  // 1. 認証を確保
  final authService = container.read(authServiceProvider);
  await authService.ensureAuthenticated();

  final crashlyticsService = container.read(crashlyticsServiceProvider);

  // 2. ユーザーIDをAnalytics/Crashlyticsに設定
  // 3. Crashlyticsを初期化（エラーハンドラを設定）
  // 上記2,3を並行して実行
  final futures = <Future<void>>[crashlyticsService.initialize()];

  final userId = authService.userId;
  if (userId != null) {
    final analyticsService = container.read(analyticsServiceProvider);
    futures.addAll([
      analyticsService.setUserId(userId),
      crashlyticsService.setUserIdentifier(userId),
    ]);
  }

  await Future.wait(futures);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Flutter Starter Kit',
      theme: appTheme,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Flutter Starter Kit'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Hello Starter Kit', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 32),
            CupertinoButton.filled(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<void>(
                    builder: (context) => const SettingsTestScreen(),
                  ),
                );
              },
              child: const Text('Firestore動作テスト'),
            ),
          ],
        ),
      ),
    );
  }
}
