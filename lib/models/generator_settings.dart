import 'package:freezed_annotation/freezed_annotation.dart';

part 'generator_settings.freezed.dart';
part 'generator_settings.g.dart';

/// 28記号のデフォルトマップ（全て true）
const Map<String, bool> _defaultCustomSymbols = {
  '!': true,
  '@': true,
  '#': true,
  r'$': true,
  '%': true,
  '^': true,
  '&': true,
  '*': true,
  '(': true,
  ')': true,
  '-': true,
  '_': true,
  '=': true,
  '+': true,
  '[': true,
  ']': true,
  '{': true,
  '}': true,
  ';': true,
  ':': true,
  ',': true,
  '.': true,
  '<': true,
  '>': true,
  '?': true,
  '/': true,
  '~': true,
  '|': true,
};

/// 設定エンティティ
///
/// ユーザーが操作するすべてのパスワード生成設定を保持する。
/// Firestore の `settings/{userId}` に保存される。
@freezed
sealed class GeneratorSettings with _$GeneratorSettings {
  const factory GeneratorSettings({
    /// パスワード文字数（範囲: 4〜128）
    @Default(16) int length,

    /// 大文字 (A-Z) を含む
    @Default(true) bool useUppercase,

    /// 小文字 (a-z) を含む
    @Default(true) bool useLowercase,

    /// 数字 (0-9) を含む
    @Default(true) bool useNumbers,

    /// 記号を含む
    @Default(true) bool useSymbols,

    /// 紛らわしい文字（oO0, lI1 等）を除外する
    @Default(false) bool excludeAmbiguous,

    /// 各記号の ON/OFF 状態
    @Default(_defaultCustomSymbols) Map<String, bool> customSymbols,
  }) = _GeneratorSettings;

  factory GeneratorSettings.fromJson(Map<String, dynamic> json) =>
      _$GeneratorSettingsFromJson(json);
}
