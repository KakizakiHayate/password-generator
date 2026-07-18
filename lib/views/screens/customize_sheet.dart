import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../models/generator_settings.dart';
import '../../services/password_generator_service.dart';
import '../../viewmodels/password_generator_viewmodel.dart';
import 'symbol_selection_screen.dart';

/// パスワード生成設定のカスタマイズシート
///
/// 設定変更はすべてローカルで管理し、「完了」時のみ ViewModel に反映する。
/// スワイプダウンや戻る操作では変更を破棄する。
/// pop 時に `true` を返した場合のみ設定が適用される。
class CustomizeSheet extends ConsumerStatefulWidget {
  const CustomizeSheet({super.key});

  @override
  ConsumerState<CustomizeSheet> createState() => _CustomizeSheetState();
}

class _CustomizeSheetState extends ConsumerState<CustomizeSheet> {
  static const double _modalHeightRatio = 0.6;

  // ローカル設定状態
  late int _length;
  late bool _useUppercase;
  late bool _useLowercase;
  late bool _useNumbers;
  late bool _useSymbols;
  late bool _excludeAmbiguous;
  late Map<String, bool> _customSymbols;

  /// スライダー操作中の一時的な値
  double? _sliderValue;

  @override
  void initState() {
    super.initState();
    final state = ref.read(passwordGeneratorViewModelProvider).value;
    if (state == null) return;
    _length = state.settings.length;
    _useUppercase = state.settings.useUppercase;
    _useLowercase = state.settings.useLowercase;
    _useNumbers = state.settings.useNumbers;
    _useSymbols = state.settings.useSymbols;
    _excludeAmbiguous = state.settings.excludeAmbiguous;
    _customSymbols = Map<String, bool>.from(state.settings.customSymbols);
  }

  GeneratorSettings get _localSettings => GeneratorSettings(
    length: _length,
    useUppercase: _useUppercase,
    useLowercase: _useLowercase,
    useNumbers: _useNumbers,
    useSymbols: _useSymbols,
    excludeAmbiguous: _excludeAmbiguous,
    customSymbols: _customSymbols,
  );

  /// 文字種トグルをOFFにできるか判定する
  bool _canToggleOff(ToggleType toggle) {
    final svc = ref.read(passwordGeneratorServiceProvider);
    return svc.canToggleOff(_localSettings, toggle);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sliderValue = _sliderValue ?? _length.toDouble();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.customizeLabel),
        automaticallyImplyLeading: false,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(_localSettings),
          child: Text(l10n.doneButton),
        ),
        automaticBackgroundVisibility: false,
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            _buildSliderSection(sliderValue, l10n),
            const SizedBox(height: 16),
            _buildToggleSection(l10n),
            const SizedBox(height: 8),
            _buildSettingRow(
              label: l10n.excludeAmbiguousLabel,
              value: _excludeAmbiguous,
              onChanged: (_) {
                setState(() {
                  _excludeAmbiguous = !_excludeAmbiguous;
                });
              },
            ),
            const SizedBox(height: 4),
            _buildCustomSymbolsLink(l10n),
          ],
        ),
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
              setState(() {
                _length = value.round();
                _sliderValue = null;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSection(AppLocalizations l10n) {
    return Column(
      children: [
        _buildSettingRow(
          label: l10n.uppercaseLabel,
          value: _useUppercase,
          onChanged: (_) {
            if (_useUppercase && !_canToggleOff(ToggleType.useUppercase)) {
              return;
            }
            setState(() => _useUppercase = !_useUppercase);
          },
        ),
        _buildSettingRow(
          label: l10n.lowercaseLabel,
          value: _useLowercase,
          onChanged: (_) {
            if (_useLowercase && !_canToggleOff(ToggleType.useLowercase)) {
              return;
            }
            setState(() => _useLowercase = !_useLowercase);
          },
        ),
        _buildSettingRow(
          label: l10n.numbersLabel,
          value: _useNumbers,
          onChanged: (_) {
            if (_useNumbers && !_canToggleOff(ToggleType.useNumbers)) return;
            setState(() => _useNumbers = !_useNumbers);
          },
        ),
        _buildSettingRow(
          label: l10n.symbolsLabel,
          value: _useSymbols,
          onChanged: (_) {
            if (_useSymbols && !_canToggleOff(ToggleType.useSymbols)) return;
            setState(() => _useSymbols = !_useSymbols);
          },
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
          Text(label, style: CupertinoTheme.of(context).textTheme.textStyle),
          CupertinoSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildCustomSymbolsLink(AppLocalizations l10n) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 8),
      onPressed: () async {
        final result = await showCupertinoModalPopup<Map<String, bool>>(
          context: context,
          builder: (_) => SizedBox(
            height: MediaQuery.of(context).size.height * _modalHeightRatio,
            child: SymbolSelectionScreen(initialSymbols: _customSymbols),
          ),
        );
        if (result != null) {
          setState(() {
            _customSymbols = result;
          });
        }
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
