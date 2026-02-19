import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/generator_settings.dart';

part 'password_generator_service.g.dart';

@Riverpod(keepAlive: true)
PasswordGeneratorService passwordGeneratorService(Ref ref) {
  return PasswordGeneratorService();
}

/// 紛らわしい文字のセット
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

/// 大文字の文字セット
const String _uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

/// 小文字の文字セット
const String _lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';

/// 数字の文字セット
const String _digitChars = '0123456789';

/// パスワード生成サービス
///
/// 文字種フィルタ（F-01）、紛らわしい文字の除外（F-02）、
/// カスタム記号選択（F-03）を1つのサービスとして提供する。
class PasswordGeneratorService {
  final Random _random = Random.secure();

  /// 設定に基づいてパスワードを生成する
  ///
  /// 有効な文字種から各1文字以上を保証する。
  String generate(GeneratorSettings settings) {
    final charPools = _buildCharPools(settings);

    if (charPools.isEmpty) {
      throw StateError('有効な文字種がありません');
    }

    final length = settings.length.clamp(4, 128);

    // 各文字種から最低1文字を確保
    final required = <String>[];
    for (final pool in charPools) {
      required.add(pool[_random.nextInt(pool.length)]);
    }

    // 残りの文字を全プールから選択
    final allChars = charPools.join();
    final remaining = <String>[];
    for (var i = required.length; i < length; i++) {
      remaining.add(allChars[_random.nextInt(allChars.length)]);
    }

    // 必須文字と残りを結合してシャッフル
    final result = [...required, ...remaining];
    _shuffle(result);

    return result.join();
  }

  /// 最後の1つの文字種をOFFにできないか判定する
  ///
  /// 現在ONになっている文字種が1つだけの場合、
  /// そのトグルをOFFにすることを防止する。
  bool canToggleOff(GeneratorSettings settings, String toggleName) {
    final activeCount = _countActiveToggles(settings);
    final isCurrentlyOn = _isToggleOn(settings, toggleName);

    // 現在ONで、かつONが1つしかない場合はOFFにできない
    return !(isCurrentlyOn && activeCount <= 1);
  }

  /// 有効な文字種の数をカウントする
  int _countActiveToggles(GeneratorSettings settings) {
    var count = 0;
    if (settings.useUppercase) count++;
    if (settings.useLowercase) count++;
    if (settings.useNumbers) count++;
    if (settings.useSymbols) count++;
    return count;
  }

  /// 指定されたトグルがONかどうかを返す
  bool _isToggleOn(GeneratorSettings settings, String toggleName) {
    return switch (toggleName) {
      'useUppercase' => settings.useUppercase,
      'useLowercase' => settings.useLowercase,
      'useNumbers' => settings.useNumbers,
      'useSymbols' => settings.useSymbols,
      _ => false,
    };
  }

  /// 設定に基づいて文字プールのリストを構築する
  List<String> _buildCharPools(GeneratorSettings settings) {
    final pools = <String>[];

    if (settings.useUppercase) {
      pools.add(_filterAmbiguous(_uppercaseChars, settings.excludeAmbiguous));
    }
    if (settings.useLowercase) {
      pools.add(_filterAmbiguous(_lowercaseChars, settings.excludeAmbiguous));
    }
    if (settings.useNumbers) {
      pools.add(_filterAmbiguous(_digitChars, settings.excludeAmbiguous));
    }
    if (settings.useSymbols) {
      final symbolPool = _buildSymbolPool(settings);
      if (symbolPool.isNotEmpty) {
        pools.add(symbolPool);
      }
    }

    // 空のプールを除外
    return pools.where((pool) => pool.isNotEmpty).toList();
  }

  /// 記号プールを構築する
  String _buildSymbolPool(GeneratorSettings settings) {
    final buffer = StringBuffer();
    for (final entry in settings.customSymbols.entries) {
      if (!entry.value) continue;
      if (settings.excludeAmbiguous && _ambiguousChars.contains(entry.key)) {
        continue;
      }
      buffer.write(entry.key);
    }
    return buffer.toString();
  }

  /// 紛らわしい文字を除外する
  String _filterAmbiguous(String chars, bool exclude) {
    if (!exclude) return chars;
    final buffer = StringBuffer();
    for (var i = 0; i < chars.length; i++) {
      if (!_ambiguousChars.contains(chars[i])) {
        buffer.write(chars[i]);
      }
    }
    return buffer.toString();
  }

  /// Fisher-Yates シャッフル
  void _shuffle(List<String> list) {
    for (var i = list.length - 1; i > 0; i--) {
      final j = _random.nextInt(i + 1);
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }
}
