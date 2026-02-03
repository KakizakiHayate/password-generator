import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/services/analytics_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/crashlytics_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

  // 2. ユーザーIDをAnalytics/Crashlyticsに設定
  final userId = authService.userId;
  if (userId != null) {
    final analyticsService = container.read(analyticsServiceProvider);
    final crashlyticsService = container.read(crashlyticsServiceProvider);

    await analyticsService.setUserId(userId);
    await crashlyticsService.setUserIdentifier(userId);
  }

  // 3. Crashlyticsを初期化（エラーハンドラを設定）
  final crashlyticsService = container.read(crashlyticsServiceProvider);
  await crashlyticsService.initialize();
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
      body: const Center(
        child: Text(
          'Hello Starter Kit',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
