import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/services/analytics_service.dart';
import '../core/services/auth_service.dart';
import '../models/generator_settings.dart';
import '../models/password_strength.dart';
import '../services/password_generator_service.dart';
import '../services/password_strength_service.dart';
import '../services/settings_service.dart';
import '../services/user_service.dart';

part 'password_generator_viewmodel.g.dart';

/// メイン画面の状態
class PasswordGeneratorState {
  const PasswordGeneratorState({
    required this.password,
    required this.settings,
    required this.strength,
    this.candidates = const [],
  });

  final String password;
  final GeneratorSettings settings;
  final PasswordStrength strength;

  /// 5件の候補パスワード
  final List<String> candidates;
}

/// メイン画面の ViewModel
///
/// パスワード生成・設定変更・強度計算を管理する。
/// 設定変更時は自動保存と自動再生成を行う。
@riverpod
class PasswordGeneratorViewModel extends _$PasswordGeneratorViewModel {
  @override
  Future<PasswordGeneratorState> build() async {
    final auth = ref.watch(authServiceProvider);
    final settingsService = ref.read(settingsServiceProvider);

    final userId = auth.userId;
    if (userId == null) {
      throw StateError('User not authenticated');
    }

    final settings = await settingsService.loadOrCreate(userId);
    return _generateState(settings);
  }

  static const _candidateCount = 5;
  static const _reviewPromptThreshold = 3;

  PasswordGeneratorState _generateState(GeneratorSettings settings) {
    final generatorService = ref.read(passwordGeneratorServiceProvider);
    final strengthService = ref.read(passwordStrengthServiceProvider);

    final password = generatorService.generate(settings);
    final strength = strengthService.calculate(settings);
    final candidates = List.generate(
      _candidateCount,
      (_) => generatorService.generate(settings),
    );

    return PasswordGeneratorState(
      password: password,
      settings: settings,
      strength: strength,
      candidates: candidates,
    );
  }

  Future<void> _saveAndRegenerate(
    GeneratorSettings settings, {
    String? changeType,
  }) async {
    final auth = ref.read(authServiceProvider);
    final settingsService = ref.read(settingsServiceProvider);

    final userId = auth.userId;
    if (userId == null) return;

    await settingsService.save(userId, settings);
    if (changeType != null) {
      ref
          .read(analyticsServiceProvider)
          .logEvent(
            name: 'settings_changed',
            parameters: {'change_type': changeType},
          );
    }
    state = AsyncData(_generateState(settings));
  }

  /// パスワードを再生成する（設定は変更しない）
  ///
  /// generationCount をインクリメントし、Analytics イベントを送信する。
  Future<void> generate() async {
    final current = state.valueOrNull;
    if (current == null) return;

    final auth = ref.read(authServiceProvider);
    final userId = auth.userId;
    if (userId != null) {
      final userSvc = ref.read(userServiceProvider);
      await userSvc.incrementGenerationCount(userId);
      ref.read(analyticsServiceProvider).logEvent(name: 'password_generated');
    }

    state = AsyncData(_generateState(current.settings));
  }

  /// レビュー依頼を表示すべきかを判定する
  ///
  /// generationCount が 3 かつ reviewPromptShown が false の場合に true を返す。
  Future<bool> shouldShowReviewPrompt() async {
    final auth = ref.read(authServiceProvider);
    final userId = auth.userId;
    if (userId == null) return false;

    final userSvc = ref.read(userServiceProvider);
    final user = await userSvc.get(userId);
    if (user == null) return false;

    return user.generationCount >= _reviewPromptThreshold &&
        !user.reviewPromptShown;
  }

  /// レビュー依頼表示済みとしてマークする
  Future<void> markReviewPromptShown() async {
    final auth = ref.read(authServiceProvider);
    final userId = auth.userId;
    if (userId == null) return;

    final userSvc = ref.read(userServiceProvider);
    await userSvc.markReviewPromptShown(userId);
  }

  /// 文字数を変更する
  Future<void> updateLength(int length) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final newSettings = current.settings.copyWith(length: length);
    await _saveAndRegenerate(newSettings, changeType: 'length');
  }

  /// 大文字トグルを切り替える
  Future<void> toggleUppercase() async {
    final current = state.valueOrNull;
    if (current == null) return;

    if (current.settings.useUppercase) {
      final svc = ref.read(passwordGeneratorServiceProvider);
      if (!svc.canToggleOff(current.settings, ToggleType.useUppercase)) return;
    }

    final newSettings = current.settings.copyWith(
      useUppercase: !current.settings.useUppercase,
    );
    await _saveAndRegenerate(newSettings, changeType: 'uppercase');
  }

  /// 小文字トグルを切り替える
  Future<void> toggleLowercase() async {
    final current = state.valueOrNull;
    if (current == null) return;

    if (current.settings.useLowercase) {
      final svc = ref.read(passwordGeneratorServiceProvider);
      if (!svc.canToggleOff(current.settings, ToggleType.useLowercase)) return;
    }

    final newSettings = current.settings.copyWith(
      useLowercase: !current.settings.useLowercase,
    );
    await _saveAndRegenerate(newSettings, changeType: 'lowercase');
  }

  /// 数字トグルを切り替える
  Future<void> toggleNumbers() async {
    final current = state.valueOrNull;
    if (current == null) return;

    if (current.settings.useNumbers) {
      final svc = ref.read(passwordGeneratorServiceProvider);
      if (!svc.canToggleOff(current.settings, ToggleType.useNumbers)) return;
    }

    final newSettings = current.settings.copyWith(
      useNumbers: !current.settings.useNumbers,
    );
    await _saveAndRegenerate(newSettings, changeType: 'numbers');
  }

  /// 記号トグルを切り替える
  Future<void> toggleSymbols() async {
    final current = state.valueOrNull;
    if (current == null) return;

    if (current.settings.useSymbols) {
      final svc = ref.read(passwordGeneratorServiceProvider);
      if (!svc.canToggleOff(current.settings, ToggleType.useSymbols)) return;
    }

    final newSettings = current.settings.copyWith(
      useSymbols: !current.settings.useSymbols,
    );
    await _saveAndRegenerate(newSettings, changeType: 'symbols');
  }

  /// 紛らわしい文字除外トグルを切り替える
  Future<void> toggleExcludeAmbiguous() async {
    final current = state.valueOrNull;
    if (current == null) return;

    final newSettings = current.settings.copyWith(
      excludeAmbiguous: !current.settings.excludeAmbiguous,
    );
    await _saveAndRegenerate(newSettings, changeType: 'exclude_ambiguous');
  }

  /// 候補のみ再生成する（メインパスワードは変更しない）
  Future<void> regenerateCandidates() async {
    final current = state.valueOrNull;
    if (current == null) return;

    final generatorService = ref.read(passwordGeneratorServiceProvider);
    final candidates = List.generate(
      _candidateCount,
      (_) => generatorService.generate(current.settings),
    );

    state = AsyncData(
      PasswordGeneratorState(
        password: current.password,
        settings: current.settings,
        strength: current.strength,
        candidates: candidates,
      ),
    );
  }

  /// パスワードコピーの Analytics イベントを送信する
  void logPasswordCopied() {
    ref.read(analyticsServiceProvider).logEvent(name: 'password_copied');
  }

  /// 設定を一括適用する（カスタマイズシートの「完了」時に使用）
  Future<void> applySettings(GeneratorSettings settings) async {
    await _saveAndRegenerate(settings, changeType: 'apply_settings');
  }

  /// カスタム記号の選択状態を更新する
  Future<void> updateCustomSymbols(Map<String, bool> symbols) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final newSettings = current.settings.copyWith(customSymbols: symbols);
    await _saveAndRegenerate(newSettings, changeType: 'custom_symbols');
  }
}
