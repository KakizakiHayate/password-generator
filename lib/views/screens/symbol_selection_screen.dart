import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../viewmodels/password_generator_viewmodel.dart';

/// 記号カスタム選択モーダル画面
class SymbolSelectionScreen extends ConsumerStatefulWidget {
  const SymbolSelectionScreen({super.key});

  @override
  ConsumerState<SymbolSelectionScreen> createState() =>
      _SymbolSelectionScreenState();
}

class _SymbolSelectionScreenState extends ConsumerState<SymbolSelectionScreen> {
  /// ローカルの記号選択状態（モーダル内で編集し、完了時に保存）
  late Map<String, bool> _symbols;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncState = ref.watch(passwordGeneratorViewModelProvider);

    // 初回ビルド時にViewModelの状態から記号選択を初期化
    if (!_isInitialized) {
      final state = asyncState.valueOrNull;
      if (state != null) {
        _symbols = Map<String, bool>.from(state.settings.customSymbols);
        _isInitialized = true;
      }
    }

    if (!_isInitialized) {
      return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(),
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    final isAllSelected = _symbols.values.every((v) => v);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.symbolSelectionTitle),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _onDone,
          child: Text(l10n.doneButton),
        ),
        automaticBackgroundVisibility: false,
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // すべて選択 / すべて解除ボタン
            CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 8),
              onPressed: () {
                setState(() {
                  final newValue = !isAllSelected;
                  for (final key in _symbols.keys) {
                    _symbols[key] = newValue;
                  }
                  _errorMessage = null;
                });
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  isAllSelected
                      ? l10n.deselectAllSymbols
                      : l10n.selectAllSymbols,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // エラーメッセージ
            if (_errorMessage case final message?)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: CupertinoColors.systemRed,
                    fontSize: 14,
                  ),
                ),
              ),

            // チップグリッド
            _buildChipGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChipGrid(BuildContext context) {
    final symbols = _symbols.keys.toList();
    final accentColor = CupertinoTheme.of(context).primaryColor;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: symbols.map((symbol) {
        final isOn = _symbols[symbol] ?? false;
        return GestureDetector(
          onTap: () {
            setState(() {
              _symbols[symbol] = !isOn;
              _errorMessage = null;
            });
          },
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isOn ? accentColor : CupertinoColors.systemGrey5,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              symbol,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isOn ? CupertinoColors.white : CupertinoColors.label,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _onDone() {
    final l10n = AppLocalizations.of(context);
    final hasSelection = _symbols.values.any((v) => v);

    if (!hasSelection) {
      setState(() {
        _errorMessage = l10n.symbolSelectionError;
      });
      return;
    }

    // ViewModelに保存
    ref
        .read(passwordGeneratorViewModelProvider.notifier)
        .updateCustomSymbols(_symbols);

    Navigator.of(context).pop();
  }
}
