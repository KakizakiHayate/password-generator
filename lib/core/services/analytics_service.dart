import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  return AnalyticsService();
}

/// Firebase Analyticsのラッパーサービス
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// 画面表示を記録
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (kDebugMode) {
      debugPrint('[Analytics] デバッグモードのためスキップ: logScreenView($screenName)');
      return;
    }
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  /// カスタムイベントを記録
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (kDebugMode) {
      debugPrint('[Analytics] デバッグモードのためスキップ: logEvent($name, $parameters)');
      return;
    }
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  /// ユーザーIDを設定
  Future<void> setUserId(String? userId) async {
    if (kDebugMode) {
      debugPrint('[Analytics] デバッグモードのためスキップ: setUserId($userId)');
      return;
    }
    await _analytics.setUserId(id: userId);
  }

  /// ユーザープロパティを設定
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    if (kDebugMode) {
      debugPrint('[Analytics] デバッグモードのためスキップ: setUserProperty($name, $value)');
      return;
    }
    await _analytics.setUserProperty(name: name, value: value);
  }
}
