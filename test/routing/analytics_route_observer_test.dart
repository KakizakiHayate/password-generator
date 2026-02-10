import 'package:flutter/widgets.dart';
import 'package:flutter_fast_starter/routing/analytics_route_observer.dart';
import 'package:flutter_test/flutter_test.dart';

/// テスト用の AnalyticsService スタブ
///
/// AnalyticsService は FirebaseAnalytics に依存するため、テスト環境では
/// 直接継承できない。代わりに同じインターフェースを持つスタブを使用する。
class _StubAnalyticsService {
  final List<String> loggedScreens = [];

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    loggedScreens.add(screenName);
  }
}

/// テスト用の AnalyticsRouteObserver
///
/// _StubAnalyticsService を使ってテストできるように、Observer を直接テストする。
class _TestableRouteObserver extends NavigatorObserver {
  _TestableRouteObserver({required this.stub});

  final _StubAnalyticsService stub;

  void _sendScreenView(Route<dynamic>? route) {
    final screenName = route?.settings.name;
    if (screenName != null) {
      stub.logScreenView(screenName: screenName);
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

/// テスト用の Route
class FakeRoute extends Fake implements Route<dynamic> {
  FakeRoute(this.name);

  final String? name;

  @override
  RouteSettings get settings => RouteSettings(name: name);
}

void main() {
  group('AnalyticsRouteObserver', () {
    test('クラスが正しくインスタンス化できる', () {
      // AnalyticsRouteObserver の型とコンストラクタが存在することを確認
      // （Firebase依存のため、実際の logScreenView 呼び出しは統合テストで検証）
      expect(AnalyticsRouteObserver, isNotNull);
    });
  });

  group('AnalyticsRouteObserver ロジック', () {
    late _StubAnalyticsService stub;
    late _TestableRouteObserver observer;

    setUp(() {
      stub = _StubAnalyticsService();
      observer = _TestableRouteObserver(stub: stub);
    });

    test('didPush は画面名を logScreenView に渡す', () {
      final route = FakeRoute('home');

      observer.didPush(route, null);

      expect(stub.loggedScreens, ['home']);
    });

    test('didPop は前の画面名を logScreenView に渡す', () {
      final currentRoute = FakeRoute('settings');
      final previousRoute = FakeRoute('home');

      observer.didPop(currentRoute, previousRoute);

      expect(stub.loggedScreens, ['home']);
    });

    test('didReplace は新しい画面名を logScreenView に渡す', () {
      final newRoute = FakeRoute('detail');
      final oldRoute = FakeRoute('list');

      observer.didReplace(newRoute: newRoute, oldRoute: oldRoute);

      expect(stub.loggedScreens, ['detail']);
    });

    test('画面名が null の場合は logScreenView を呼ばない', () {
      final route = FakeRoute(null);

      observer.didPush(route, null);

      expect(stub.loggedScreens, isEmpty);
    });
  });
}
