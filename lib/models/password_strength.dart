import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_strength.freezed.dart';

/// 強度レベルの閾値（エントロピー基準）:
/// - weak:       < 28 bit
/// - fair:       28〜35 bit
/// - strong:     36〜59 bit
/// - veryStrong: 60 bit〜
///
/// 解読推定時間の攻撃速度前提: 10億回/秒（1×10⁹）
enum StrengthLevel { weak, fair, strong, veryStrong }

/// パスワード強度の計算結果
///
/// Firestore には保存せず、生成のたびに算出する（メモリのみ）。
@freezed
sealed class PasswordStrength with _$PasswordStrength {
  const factory PasswordStrength({
    /// 強度レベル
    required StrengthLevel level,

    /// エントロピー（ビット数）
    required double entropy,

    /// 解読推定時間の表示テキスト
    required String crackTimeDisplay,
  }) = _PasswordStrength;
}
