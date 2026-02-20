import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../models/password_strength.dart';
import '../../viewmodels/password_generator_viewmodel.dart';
import 'symbol_selection_screen.dart';

/// メイン画面
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// スライダー操作中の一時的な値（null の場合は設定値を使用）
  double? _sliderValue;

  /// 候補セクションの展開状態
  bool _isCandidatesExpanded = false;

  /// コピーフィードバック中のタイマー管理
  /// キー: 'main' or 候補のインデックス文字列
  final Map<String, Timer> _copiedTimers = {};

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

  @override
  void dispose() {
    for (final timer in _copiedTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  Future<void> _copyToClipboard(String text, String key) async {
    await Clipboard.setData(ClipboardData(text: text));
    await HapticFeedback.mediumImpact();
    // 同じキーの既存タイマーをキャンセル
    _copiedTimers[key]?.cancel();
    _copiedTimers[key] = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _copiedTimers.remove(key);
        });
      }
    });
    setState(() {});
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
          // パスワード表示エリア（タップでコピー）
          _PasswordDisplayCard(
            password: state.password,
            strength: state.strength,
            l10n: l10n,
            isCopied: _copiedTimers.containsKey('main'),
            onTap: () => _copyToClipboard(state.password, 'main'),
          ),
          const SizedBox(height: 16),

          // 候補セクション
          _buildCandidatesSection(state, l10n),
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

  Widget _buildCandidatesSection(
    PasswordGeneratorState state,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        // 折りたたみトグル
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            setState(() {
              _isCandidatesExpanded = !_isCandidatesExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.viewOtherCandidates,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 4),
              Icon(
                _isCandidatesExpanded
                    ? CupertinoIcons.chevron_up
                    : CupertinoIcons.chevron_down,
                size: 14,
              ),
            ],
          ),
        ),

        // 展開時の候補リスト
        if (_isCandidatesExpanded) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CupertinoColors.systemGrey4),
            ),
            child: Column(
              children: [
                ...state.candidates.asMap().entries.map((entry) {
                  final key = 'candidate_${entry.key}';
                  final isCopied = _copiedTimers.containsKey(key);
                  return _buildCandidateRow(
                    entry.value,
                    key,
                    isCopied,
                    l10n,
                    isLast: entry.key == state.candidates.length - 1,
                  );
                }),
                // 候補を再生成ボタン
                CupertinoButton(
                  onPressed: () {
                    ref
                        .read(passwordGeneratorViewModelProvider.notifier)
                        .regenerateCandidates();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.refresh, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        l10n.regenerateCandidates,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCandidateRow(
    String password,
    String key,
    bool isCopied,
    AppLocalizations l10n, {
    required bool isLast,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  password,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontFamilyFallback: ['monospace'],
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                onPressed: isCopied
                    ? null
                    : () => _copyToClipboard(password, key),
                child: Text(
                  isCopied ? l10n.copiedMessage : l10n.copyButton,
                  style: TextStyle(
                    fontSize: 13,
                    color: isCopied
                        ? CupertinoColors.systemGrey
                        : CupertinoTheme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(height: 0.5, color: CupertinoColors.systemGrey4),
          ),
      ],
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
        showCupertinoModalPopup<void>(
          context: context,
          builder: (_) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const SymbolSelectionScreen(),
          ),
        );
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
    required this.isCopied,
    required this.onTap,
  });

  final String password;
  final PasswordStrength strength;
  final AppLocalizations l10n;
  final bool isCopied;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CupertinoColors.systemGrey4),
        ),
        child: Column(
          children: [
            // パスワード表示（等幅フォント）/ コピーフィードバック
            if (isCopied)
              Text(
                l10n.copiedMessage,
                style: const TextStyle(
                  fontSize: 18,
                  color: CupertinoColors.systemGreen,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              )
            else
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
