import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../models/password_strength.dart';
import '../../viewmodels/password_generator_viewmodel.dart';

/// メイン画面
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// スライダー操作中の一時的な値（null の場合は設定値を使用）
  double? _sliderValue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncState = ref.watch(passwordGeneratorViewModelProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.appTitle),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            // Issue #8 で実装
          },
          child: const Icon(CupertinoIcons.gear),
        ),
      ),
      child: asyncState.when(
        data: (state) => _buildContent(context, state, l10n),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, _) =>
            Center(child: Text(l10n.errorMessage(error.toString()))),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    PasswordGeneratorState state,
    AppLocalizations l10n,
  ) {
    final sliderValue = _sliderValue ?? state.settings.length.toDouble();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // パスワード表示エリア
          _PasswordDisplayCard(
            password: state.password,
            strength: state.strength,
            l10n: l10n,
          ),
          const SizedBox(height: 24),

          // 文字数スライダー
          _buildSliderSection(sliderValue, l10n),
          const SizedBox(height: 16),

          // 文字種トグル群
          _buildToggleSection(state, l10n),
          const SizedBox(height: 8),

          // 紛らわしい文字除外
          _buildSettingRow(
            label: l10n.excludeAmbiguousLabel,
            value: state.settings.excludeAmbiguous,
            onChanged: (_) {
              ref
                  .read(passwordGeneratorViewModelProvider.notifier)
                  .toggleExcludeAmbiguous();
            },
          ),
          const SizedBox(height: 4),

          // 記号カスタム選択リンク
          _buildCustomSymbolsLink(l10n),
          const SizedBox(height: 24),

          // 生成するボタン
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed: () {
                ref
                    .read(passwordGeneratorViewModelProvider.notifier)
                    .generate();
              },
              child: Text(l10n.generateButton),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSection(double sliderValue, AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.characterCount, style: const TextStyle(fontSize: 16)),
            Text(
              sliderValue.round().toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: CupertinoSlider(
            value: sliderValue,
            min: 4,
            max: 128,
            divisions: 124,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
            },
            onChangeEnd: (value) {
              ref
                  .read(passwordGeneratorViewModelProvider.notifier)
                  .updateLength(value.round());
              setState(() {
                _sliderValue = null;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSection(
    PasswordGeneratorState state,
    AppLocalizations l10n,
  ) {
    final notifier = ref.read(passwordGeneratorViewModelProvider.notifier);

    return Column(
      children: [
        _buildSettingRow(
          label: l10n.uppercaseLabel,
          value: state.settings.useUppercase,
          onChanged: (_) => notifier.toggleUppercase(),
        ),
        _buildSettingRow(
          label: l10n.lowercaseLabel,
          value: state.settings.useLowercase,
          onChanged: (_) => notifier.toggleLowercase(),
        ),
        _buildSettingRow(
          label: l10n.numbersLabel,
          value: state.settings.useNumbers,
          onChanged: (_) => notifier.toggleNumbers(),
        ),
        _buildSettingRow(
          label: l10n.symbolsLabel,
          value: state.settings.useSymbols,
          onChanged: (_) => notifier.toggleSymbols(),
        ),
      ],
    );
  }

  Widget _buildSettingRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          CupertinoSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildCustomSymbolsLink(AppLocalizations l10n) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 8),
      onPressed: () {
        // Issue #6 で実装
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.customizeSymbolsLabel,
            style: const TextStyle(fontSize: 16),
          ),
          const Icon(
            CupertinoIcons.chevron_right,
            size: 18,
            color: CupertinoColors.systemGrey,
          ),
        ],
      ),
    );
  }
}

/// パスワード表示 + 強度バーのカード
class _PasswordDisplayCard extends StatelessWidget {
  const _PasswordDisplayCard({
    required this.password,
    required this.strength,
    required this.l10n,
  });

  final String password;
  final PasswordStrength strength;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey4),
      ),
      child: Column(
        children: [
          // パスワード表示（等幅フォント）
          Text(
            password,
            style: const TextStyle(
              fontFamily: 'Courier',
              fontFamilyFallback: ['monospace'],
              fontSize: 18,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // 強度バー + テキストラベル
          Row(
            children: [
              Expanded(child: _StrengthBar(level: strength.level)),
              const SizedBox(width: 12),
              Text(
                _strengthText(strength.level),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _strengthColor(strength.level),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 解読推定時間
          Text(
            '${l10n.crackTimePrefix} ${strength.crackTimeDisplay}',
            style: const TextStyle(
              fontSize: 13,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }

  String _strengthText(StrengthLevel level) {
    return switch (level) {
      StrengthLevel.weak => l10n.strengthWeak,
      StrengthLevel.fair => l10n.strengthFair,
      StrengthLevel.strong => l10n.strengthStrong,
      StrengthLevel.veryStrong => l10n.strengthVeryStrong,
    };
  }

  Color _strengthColor(StrengthLevel level) {
    return switch (level) {
      StrengthLevel.weak => CupertinoColors.systemRed,
      StrengthLevel.fair => CupertinoColors.systemOrange,
      StrengthLevel.strong => CupertinoColors.systemYellow,
      StrengthLevel.veryStrong => CupertinoColors.systemGreen,
    };
  }
}

/// 4分割のセグメント強度バー
class _StrengthBar extends StatelessWidget {
  const _StrengthBar({required this.level});

  final StrengthLevel level;

  @override
  Widget build(BuildContext context) {
    final activeCount = switch (level) {
      StrengthLevel.weak => 1,
      StrengthLevel.fair => 2,
      StrengthLevel.strong => 3,
      StrengthLevel.veryStrong => 4,
    };

    final color = switch (level) {
      StrengthLevel.weak => CupertinoColors.systemRed,
      StrengthLevel.fair => CupertinoColors.systemOrange,
      StrengthLevel.strong => CupertinoColors.systemYellow,
      StrengthLevel.veryStrong => CupertinoColors.systemGreen,
    };

    return Row(
      children: List.generate(4, (index) {
        final isActive = index < activeCount;
        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
            decoration: BoxDecoration(
              color: isActive ? color : CupertinoColors.systemGrey4,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
