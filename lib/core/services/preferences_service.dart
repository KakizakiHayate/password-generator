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

  // ============================================================
  // 静的フィールドとメソッド（DIコンテナ構築前に使用）
  // ============================================================

  static SharedPreferences? _staticPrefs;

  /// 静的初期化（main.dart等で一度だけ呼び出す）
  static Future<void> initializeStatic() async {
    _staticPrefs ??= await SharedPreferences.getInstance();
  }

  /// 文字列を読み取る（静的メソッド）
  static String? readString(String key) {
    assert(
      _staticPrefs != null,
      'PreferencesService.initializeStatic() must be called first',
    );
    return _staticPrefs!.getString(key);
  }

  /// 真偽値を読み取る（静的メソッド）
  static bool readBool(String key, {bool defaultValue = false}) {
    assert(
      _staticPrefs != null,
      'PreferencesService.initializeStatic() must be called first',
    );
    return _staticPrefs!.getBool(key) ?? defaultValue;
  }

  /// 整数を読み取る（静的メソッド）
  static int? readInt(String key) {
    assert(
      _staticPrefs != null,
      'PreferencesService.initializeStatic() must be called first',
    );
    return _staticPrefs!.getInt(key);
  }

  // ============================================================
  // インスタンスメソッド（initialize()後に使用）
  // ============================================================

  /// インスタンス初期化（アプリ起動時に一度だけ呼び出す）
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

  /// 文字列を保存
  Future<bool> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  /// 文字列を取得
  String? getString(String key) {
    return _preferences.getString(key);
  }

  /// 真偽値を保存
  Future<bool> setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  /// 真偽値を取得
  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  /// 整数を保存
  Future<bool> setInt(String key, int value) {
    return _preferences.setInt(key, value);
  }

  /// 整数を取得
  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  /// 浮動小数点数を保存
  Future<bool> setDouble(String key, double value) {
    return _preferences.setDouble(key, value);
  }

  /// 浮動小数点数を取得
  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  /// 文字列リストを保存
  Future<bool> setStringList(String key, List<String> value) {
    return _preferences.setStringList(key, value);
  }

  /// 文字列リストを取得
  List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  /// キーを削除
  Future<bool> remove(String key) {
    return _preferences.remove(key);
  }

  /// すべてのキーを削除
  Future<bool> clear() {
    return _preferences.clear();
  }

  /// キーが存在するか確認
  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }
}
