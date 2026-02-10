import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/services/analytics_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/crashlytics_service.dart';
import 'core/services/preferences_service.dart';
import 'core/theme/cupertino_theme.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'routing/app_router.dart';

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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return CupertinoApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: appTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
