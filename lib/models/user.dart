import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// ユーザーエンティティ
///
/// アプリの内部状態を保持する。
/// Firestore の `users/{userId}` に保存される。
@freezed
sealed class User with _$User {
  const factory User({
    /// アカウント作成日時
    required DateTime createdAt,

    /// 累計パスワード生成回数
    @Default(0) int generationCount,

    /// レビュー依頼を表示済みか
    @Default(false) bool reviewPromptShown,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
