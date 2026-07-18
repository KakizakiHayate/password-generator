import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../viewmodels/password_generator_viewmodel.dart';

/// 記号カスタム選択モーダル画面
///
/// [initialSymbols] が渡された場合はそれを初期値として使用し、
/// 「完了」時に `pop(Map<String, bool>)` で結果を返す。
/// [initialSymbols] が渡されない場合は ViewModel から読み取り、
/// 「完了」時に ViewModel に直接保存する（従来の動作）。
class SymbolSelectionScreen extends ConsumerStatefulWidget {
  const SymbolSelectionScreen({super.key, this.initialSymbols});

  /// 外部から渡す初期記号選択状態（カスタマイズシートから開く場合に使用）
  final Map<String, bool>? initialSymbols;

  @override
  ConsumerState<SymbolSelectionScreen> createState() =>
      _SymbolSelectionScreenState();
}

class _SymbolSelectionScreenState extends ConsumerState<SymbolSelectionScreen> {
  /// ローカルの記号選択状態（モーダル内で編集し、完了時に保存）
  late Map<String, bool> _symbols;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialSymbols case final initial?) {
      _symbols = Map<String, bool>.from(initial);
    } else {
      final initialState = ref.read(passwordGeneratorViewModelProvider).value;
      if (initialState == null) return;
      _symbols = Map<String, bool>.from(initialState.settings.customSymbols);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAllSelected = _symbols.values.every((v) => v);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.symbolSelectionTitle),
        automaticallyImplyLeading: false,
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
                  _symbols.updateAll((_, _) => newValue);
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

    if (widget.initialSymbols != null) {
      // カスタマイズシートから開かれた場合: 結果を返す
      Navigator.of(context).pop(_symbols);
    } else {
      // 直接開かれた場合: ViewModelに保存（従来の動作）
      ref
          .read(passwordGeneratorViewModelProvider.notifier)
          .updateCustomSymbols(_symbols);
      Navigator.of(context).pop();
    }
  }
}
