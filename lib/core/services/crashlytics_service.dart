import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crashlytics_service.g.dart';

@Riverpod(keepAlive: true)
CrashlyticsService crashlyticsService(Ref ref) {
  return CrashlyticsService();
}

/// Firebase Crashlyticsのエラー通知ラッパーサービス
class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Crashlyticsを初期化し、エラーハンドラを設定
  Future<void> initialize() async {
    // Flutterフレームワーク内のエラーをキャッチ
    FlutterError.onError = _crashlytics.recordFlutterFatalError;

    // Flutterフレームワーク外の非同期エラーをキャッチ
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      // debugモードではフレームワークにもエラーを処理させる（赤いエラー画面を表示）
      // releaseモードでは処理済みとしてアプリ継続
      return !kDebugMode;
    };
  }

  /// エラーを記録
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(exception, stack, fatal: fatal);
  }

  /// ユーザー識別子を設定
  Future<void> setUserIdentifier(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  /// カスタムキーを設定
  Future<void> setCustomKey(String key, Object value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  /// ログメッセージを記録
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }
}
