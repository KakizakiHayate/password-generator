import 'package:flutter/widgets.dart';

import '../core/services/analytics_service.dart';

/// GoRouter の画面遷移を Analytics に記録する NavigatorObserver
class AnalyticsRouteObserver extends NavigatorObserver {
  AnalyticsRouteObserver({required this.analyticsService});

  final AnalyticsService analyticsService;

  void _sendScreenView(Route<dynamic>? route) {
    final screenName = route?.settings.name;
    if (screenName != null) {
      analyticsService.logScreenView(screenName: screenName);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _sendScreenView(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _sendScreenView(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _sendScreenView(newRoute);
  }
}
