import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/services/analytics_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/crashlytics_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    // 1. 認証を確保
    final authService = ref.read(authServiceProvider);
    await authService.ensureAuthenticated();

    // 2. ユーザーIDをAnalytics/Crashlyticsに設定
    final userId = authService.userId;
    if (userId != null) {
      final analyticsService = ref.read(analyticsServiceProvider);
      final crashlyticsService = ref.read(crashlyticsServiceProvider);

      await analyticsService.setUserId(userId);
      await crashlyticsService.setUserIdentifier(userId);
    }

    // 3. Crashlyticsを初期化（エラーハンドラを設定）
    final crashlyticsService = ref.read(crashlyticsServiceProvider);
    await crashlyticsService.initialize();
  }

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
