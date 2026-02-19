import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/generator_settings.dart';
import '../models/password_strength.dart';

part 'password_strength_service.g.dart';

@Riverpod(keepAlive: true)
PasswordStrengthService passwordStrengthService(Ref ref) {
  return PasswordStrengthService();
}

/// 紛らわしい文字のセット（除外対象）
const Set<String> _ambiguousChars = {
  'o',
  'O',
  '0',
  'l',
  'I',
  '1',
  '|',
  '`',
  "'",
  '"',
};

/// 攻撃速度: 10億回/秒（1×10⁹）
const double _attacksPerSecond = 1e9;

/// パスワード強度計算サービス
///
/// エントロピー計算、強度レベル判定、解読推定時間の算出を行う。
class PasswordStrengthService {
  /// 設定に基づいてパスワード強度を計算する
  PasswordStrength calculate(GeneratorSettings settings) {
    final poolSize = _calculatePoolSize(settings);
    final entropy = _calculateEntropy(poolSize, settings.length);
    final level = _determineLevel(entropy);
    final crackTimeDisplay = _formatCrackTime(entropy);

    return PasswordStrength(
      level: level,
      entropy: entropy,
      crackTimeDisplay: crackTimeDisplay,
    );
  }

  /// 文字プールサイズを計算する
  int _calculatePoolSize(GeneratorSettings settings) {
    var size = 0;

    if (settings.useUppercase) {
      size += _countFiltered('ABCDEFGHIJKLMNOPQRSTUVWXYZ', settings);
    }
    if (settings.useLowercase) {
      size += _countFiltered('abcdefghijklmnopqrstuvwxyz', settings);
    }
    if (settings.useNumbers) {
      size += _countFiltered('0123456789', settings);
    }
    if (settings.useSymbols) {
      size += _countSymbols(settings);
    }

    return size;
  }

  /// 紛らわしい文字を除外した後の文字数をカウントする
  int _countFiltered(String chars, GeneratorSettings settings) {
    if (!settings.excludeAmbiguous) return chars.length;
    var count = 0;
    for (var i = 0; i < chars.length; i++) {
      if (!_ambiguousChars.contains(chars[i])) {
        count++;
      }
    }
    return count;
  }

  /// 有効な記号の数をカウントする
  int _countSymbols(GeneratorSettings settings) {
    var count = 0;
    for (final entry in settings.customSymbols.entries) {
      if (entry.value) {
        if (settings.excludeAmbiguous && _ambiguousChars.contains(entry.key)) {
          continue;
        }
        count++;
      }
    }
    return count;
  }

  /// エントロピー（ビット数）を計算する
  ///
  /// 計算式: log2(文字プールサイズ) × 文字数
  double _calculateEntropy(int poolSize, int length) {
    if (poolSize <= 0) return 0;
    return (log(poolSize) / ln2) * length;
  }

  /// エントロピーから強度レベルを判定する
  ///
  /// - weak:       < 28 bit
  /// - fair:       28〜35 bit
  /// - strong:     36〜59 bit
  /// - veryStrong: 60 bit〜
  StrengthLevel _determineLevel(double entropy) {
    if (entropy < 28) return StrengthLevel.weak;
    if (entropy < 36) return StrengthLevel.fair;
    if (entropy < 60) return StrengthLevel.strong;
    return StrengthLevel.veryStrong;
  }

  /// 解読推定時間を日本語で表示する
  ///
  /// 攻撃速度: 10億回/秒（1×10⁹）
  /// 最大単位1つで簡潔に表示する。
  String _formatCrackTime(double entropy) {
    if (entropy <= 0) return '1秒未満';

    // 2^entropy / attacksPerSecond = 解読にかかる秒数
    final totalSeconds = pow(2, entropy) / _attacksPerSecond;

    if (totalSeconds < 1) return '1秒未満';

    // 秒 → 分 → 時間 → 日 → 年 の順で最大単位を決定
    const secondsPerMinute = 60.0;
    const secondsPerHour = 3600.0;
    const secondsPerDay = 86400.0;
    const secondsPerYear = 365.25 * secondsPerDay;

    if (totalSeconds < secondsPerMinute) {
      return '約${totalSeconds.round()}秒';
    }
    if (totalSeconds < secondsPerHour) {
      return '約${(totalSeconds / secondsPerMinute).round()}分';
    }
    if (totalSeconds < secondsPerDay) {
      return '約${(totalSeconds / secondsPerHour).round()}時間';
    }
    if (totalSeconds < secondsPerYear) {
      return '約${(totalSeconds / secondsPerDay).round()}日';
    }

    // 年数を計算
    final years = totalSeconds / secondsPerYear;
    return '約${_formatLargeNumber(years)}年';
  }

  /// 大きな数値を日本語の大数表記でフォーマットする
  ///
  /// 万・億・兆・京 を使用する。
  String _formatLargeNumber(double value) {
    if (value < 1) return '1';

    // 京（10^16）以上
    if (value >= 1e16) {
      final kei = value / 1e16;
      if (kei >= 10000) {
        // 京を超える場合はさらに大きな単位は使わず、京で表記
        return '${_formatWithSubUnit(kei)}京';
      }
      return '${_formatWithSubUnit(kei)}京';
    }

    // 兆（10^12）以上
    if (value >= 1e12) {
      final cho = value / 1e12;
      return '${_formatWithSubUnit(cho)}兆';
    }

    // 億（10^8）以上
    if (value >= 1e8) {
      final oku = value / 1e8;
      return '${_formatWithSubUnit(oku)}億';
    }

    // 万（10^4）以上
    if (value >= 1e4) {
      final man = value / 1e4;
      return '${_formatWithSubUnit(man)}万';
    }

    // 万未満
    return value.round().toString();
  }

  /// サブユニット付きのフォーマット（例: 3万6千）
  String _formatWithSubUnit(double value) {
    final intPart = value.floor();

    if (intPart >= 1000) {
      // 千の位以上の場合は再帰的に大数表記
      return _formatLargeNumber(value);
    }

    final remainder = value - intPart;

    if (intPart == 0) {
      // 0.x の場合
      final subValue = (remainder * 10).round();
      if (subValue > 0) {
        return '$subValue千';
      }
      return '1';
    }

    // 小数部分を千の位に変換
    final senValue = (remainder * 10).round();
    if (senValue > 0) {
      return '$intPart万$senValue千';
    }

    return intPart.toString();
  }
}
