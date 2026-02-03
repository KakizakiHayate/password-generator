import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_service.g.dart';

@Riverpod(keepAlive: true)
PreferencesService preferencesService(Ref ref) {
  return PreferencesService();
}

/// SharedPreferencesのラッパーサービス
class PreferencesService {
  static SharedPreferences? _prefs;

  /// アプリケーション起動時に一度だけ呼び出す
  static Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// SharedPreferencesインスタンスを取得（初期化済みであること）
  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw StateError('PreferencesService.initialize() must be called first');
    }
    return _prefs!;
  }

  // ============================================================
  // 静的メソッド（DIコンテナ構築前に使用）
  // ============================================================

  /// 文字列を読み取る（静的メソッド）
  static String? readString(String key) {
    return _instance.getString(key);
  }

  /// 真偽値を読み取る（静的メソッド）
  static bool readBool(String key, {bool defaultValue = false}) {
    return _instance.getBool(key) ?? defaultValue;
  }

  /// 整数を読み取る（静的メソッド）
  static int? readInt(String key) {
    return _instance.getInt(key);
  }

  // ============================================================
  // インスタンスメソッド（Riverpod経由で使用）
  // ============================================================

  /// 文字列を保存
  Future<bool> setString(String key, String value) {
    return _instance.setString(key, value);
  }

  /// 文字列を取得
  String? getString(String key) {
    return _instance.getString(key);
  }

  /// 真偽値を保存
  Future<bool> setBool(String key, bool value) {
    return _instance.setBool(key, value);
  }

  /// 真偽値を取得
  bool? getBool(String key) {
    return _instance.getBool(key);
  }

  /// 整数を保存
  Future<bool> setInt(String key, int value) {
    return _instance.setInt(key, value);
  }

  /// 整数を取得
  int? getInt(String key) {
    return _instance.getInt(key);
  }

  /// 浮動小数点数を保存
  Future<bool> setDouble(String key, double value) {
    return _instance.setDouble(key, value);
  }

  /// 浮動小数点数を取得
  double? getDouble(String key) {
    return _instance.getDouble(key);
  }

  /// 文字列リストを保存
  Future<bool> setStringList(String key, List<String> value) {
    return _instance.setStringList(key, value);
  }

  /// 文字列リストを取得
  List<String>? getStringList(String key) {
    return _instance.getStringList(key);
  }

  /// キーを削除
  Future<bool> remove(String key) {
    return _instance.remove(key);
  }

  /// すべてのキーを削除
  Future<bool> clear() {
    return _instance.clear();
  }

  /// キーが存在するか確認
  bool containsKey(String key) {
    return _instance.containsKey(key);
  }
}
