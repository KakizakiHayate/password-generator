import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../l10n/app_localizations.dart';
import '../../models/generator_settings.dart';
import '../../models/password_strength.dart';
import '../../viewmodels/password_generator_viewmodel.dart';
import 'app_info_screen.dart';
import 'customize_sheet.dart';

/// メイン画面
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const double _modalHeightRatio = 0.6;

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
            showCupertinoModalPopup<void>(
              context: context,
              builder: (_) => SizedBox(
                height: MediaQuery.of(context).size.height * _modalHeightRatio,
                child: const AppInfoScreen(),
              ),
            );
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

  Future<void> _checkReviewPrompt(PasswordGeneratorViewModel notifier) async {
    final shouldShow = await notifier.shouldShowReviewPrompt();
    if (!shouldShow) return;

    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
    await notifier.markReviewPromptShown();
  }

  Future<void> _copyToClipboard(String text, String key) async {
    await Clipboard.setData(ClipboardData(text: text));
    await HapticFeedback.mediumImpact();
    ref.read(passwordGeneratorViewModelProvider.notifier).logPasswordCopied();
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
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // パスワード表示エリア
                    _PasswordDisplayCard(
                      password: state.password,
                      strength: state.strength,
                      l10n: l10n,
                      isCopied: _copiedTimers.containsKey('main'),
                      onCopy: () => _copyToClipboard(state.password, 'main'),
                    ),
                    const SizedBox(height: 24),

                    // TODO: 候補セクションは将来的に再表示する
                    // _buildCandidatesSection(state, l10n),

                    // 生成するボタン
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        onPressed: () async {
                          final notifier = ref.read(
                            passwordGeneratorViewModelProvider.notifier,
                          );
                          await notifier.generate();
                          await _checkReviewPrompt(notifier);
                        },
                        child: Text(l10n.generateButton),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // カスタマイズリンク
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        final result =
                            await showCupertinoModalPopup<GeneratorSettings>(
                              context: context,
                              builder: (_) => SizedBox(
                                height:
                                    MediaQuery.of(context).size.height *
                                    _modalHeightRatio,
                                child: const CustomizeSheet(),
                              ),
                            );
                        if (result != null) {
                          final notifier = ref.read(
                            passwordGeneratorViewModelProvider.notifier,
                          );
                          await notifier.applySettings(result);
                          await _checkReviewPrompt(notifier);
                        }
                      },
                      child: Text(
                        l10n.customizeLabel,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ignore: unused_element
  Widget _buildCandidatesSection(
    PasswordGeneratorState state,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
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
}

/// パスワード表示 + 強度バー + コピーボタンのカード
class _PasswordDisplayCard extends StatelessWidget {
  const _PasswordDisplayCard({
    required this.password,
    required this.strength,
    required this.l10n,
    required this.isCopied,
    required this.onCopy,
  });

  final String password;
  final PasswordStrength strength;
  final AppLocalizations l10n;
  final bool isCopied;
  final VoidCallback onCopy;

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
          const SizedBox(height: 12),

          // コピーボタン
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            minimumSize: Size.zero,
            onPressed: isCopied ? null : onCopy,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCopied
                      ? CupertinoIcons.checkmark
                      : CupertinoIcons.doc_on_doc,
                  size: 16,
                  color: isCopied
                      ? CupertinoColors.systemGreen
                      : CupertinoTheme.of(context).primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  isCopied ? l10n.copiedMessage : l10n.copyButton,
                  style: TextStyle(
                    fontSize: 14,
                    color: isCopied
                        ? CupertinoColors.systemGreen
                        : CupertinoTheme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

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
