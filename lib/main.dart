import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/services/analytics_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/crashlytics_service.dart';
import 'firebase_options.dart';
import 'views/screens/settings_test_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ProviderContainerを作成し、アプリ起動前の初期化処理を実行
  final container = ProviderContainer();
  await _initializeServices(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

/// アプリ起動前のサービス初期化処理
Future<void> _initializeServices(ProviderContainer container) async {
  // 1. 認証を確保
  final authService = container.read(authServiceProvider);
  await authService.ensureAuthenticated();

  final crashlyticsService = container.read(crashlyticsServiceProvider);

  // 2. ユーザーIDをAnalytics/Crashlyticsに設定
  // 3. Crashlyticsを初期化（エラーハンドラを設定）
  // 上記2,3を並行して実行
  final futures = <Future<void>>[
    crashlyticsService.initialize(),
  ];

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
    return MaterialApp(
      title: 'Flutter Starter Kit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Starter Kit'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Hello Starter Kit', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsTestScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.science),
              label: const Text('Firestore動作テスト'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
