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
  SharedPreferences? _prefs;

  /// 遅延初期化
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// SharedPreferencesインスタンスを取得（初期化済みであること）
  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw StateError(
        'PreferencesService is not initialized. Call initialize() first.',
      );
    }
    return _prefs!;
  }

  // ============================================================
  // 静的メソッド（main.dart等、DIコンテナ構築前に使用）
  // ============================================================

  /// 文字列を読み取る（静的メソッド）
  static Future<String?> readString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// 真偽値を読み取る（静的メソッド）
  static Future<bool> readBool(String key, {bool defaultValue = false}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  /// 整数を読み取る（静的メソッド）
  static Future<int?> readInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // ============================================================
  // インスタンスメソッド（遅延初期化後に使用）
  // ============================================================

  /// 文字列を保存
  Future<bool> setString(String key, String value) async {
    await initialize();
    return _preferences.setString(key, value);
  }

  /// 文字列を取得
  Future<String?> getString(String key) async {
    await initialize();
    return _preferences.getString(key);
  }

  /// 真偽値を保存
  Future<bool> setBool(String key, bool value) async {
    await initialize();
    return _preferences.setBool(key, value);
  }

  /// 真偽値を取得
  Future<bool?> getBool(String key) async {
    await initialize();
    return _preferences.getBool(key);
  }

  /// 整数を保存
  Future<bool> setInt(String key, int value) async {
    await initialize();
    return _preferences.setInt(key, value);
  }

  /// 整数を取得
  Future<int?> getInt(String key) async {
    await initialize();
    return _preferences.getInt(key);
  }

  /// 浮動小数点数を保存
  Future<bool> setDouble(String key, double value) async {
    await initialize();
    return _preferences.setDouble(key, value);
  }

  /// 浮動小数点数を取得
  Future<double?> getDouble(String key) async {
    await initialize();
    return _preferences.getDouble(key);
  }

  /// 文字列リストを保存
  Future<bool> setStringList(String key, List<String> value) async {
    await initialize();
    return _preferences.setStringList(key, value);
  }

  /// 文字列リストを取得
  Future<List<String>?> getStringList(String key) async {
    await initialize();
    return _preferences.getStringList(key);
  }

  /// キーを削除
  Future<bool> remove(String key) async {
    await initialize();
    return _preferences.remove(key);
  }

  /// すべてのキーを削除
  Future<bool> clear() async {
    await initialize();
    return _preferences.clear();
  }

  /// キーが存在するか確認
  Future<bool> containsKey(String key) async {
    await initialize();
    return _preferences.containsKey(key);
  }
}
