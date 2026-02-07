import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

/// ユーザー設定モデル（Firestore保存用の例）
///
/// このモデルはテンプレートの使用例として提供されています。
/// 実際のプロジェクトでは、このファイルを参考に
/// 独自のモデルを作成してください。
///
/// 注意: createdAt/updatedAtはFirestoreServiceが自動で
/// FieldValue.serverTimestamp()を設定するため、モデルには含めていません。
@freezed
sealed class UserSettings with _$UserSettings {
  const factory UserSettings({
    /// ドキュメントID（Firestoreから取得時に設定）
    String? id,

    /// 表示名
    @Default('') String displayName,

    /// 通知設定
    @Default(true) bool notificationsEnabled,

    /// ダークモード設定
    @Default(false) bool darkModeEnabled,

    /// 言語設定（ja, en など）
    @Default('ja') String language,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}
