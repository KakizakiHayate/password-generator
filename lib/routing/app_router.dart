import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/services/analytics_service.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/settings_test_screen.dart';
import 'analytics_route_observer.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final analyticsService = ref.watch(analyticsServiceProvider);

  return GoRouter(
    initialLocation: '/',
    observers: [AnalyticsRouteObserver(analyticsService: analyticsService)],
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) =>
            const CupertinoPage(child: HomeScreen()),
      ),
      GoRoute(
        path: '/settings-test',
        name: 'settings-test',
        pageBuilder: (context, state) =>
            const CupertinoPage(child: SettingsTestScreen()),
      ),
    ],
  );
}
