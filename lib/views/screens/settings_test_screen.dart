import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/cupertino_toast.dart';
import '../../l10n/app_localizations.dart';
import '../../models/user_settings.dart';
import '../../viewmodels/user_settings_viewmodel.dart';

/// Firestore動作確認用の設定テスト画面
class SettingsTestScreen extends ConsumerStatefulWidget {
  const SettingsTestScreen({super.key});

  @override
  ConsumerState<SettingsTestScreen> createState() => _SettingsTestScreenState();
}

class _SettingsTestScreenState extends ConsumerState<SettingsTestScreen> {
  final _displayNameController = TextEditingController();
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _language = 'ja';
  bool _initialized = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  /// Firestoreのデータでローカルステートを同期
  void _syncFromSettings(UserSettings settings) {
    if (!_initialized) {
      _initialized = true;
      _displayNameController.text = settings.displayName;
      _notificationsEnabled = settings.notificationsEnabled;
      _darkModeEnabled = settings.darkModeEnabled;
      _language = settings.language;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsStream = ref.watch(userSettingsStreamProvider);

    // ストリーム更新時にローカルステートを同期
    ref.listen(userSettingsStreamProvider, (previous, next) {
      final settings = next.valueOrNull;
      if (settings != null && !_initialized) {
        setState(() {
          _syncFromSettings(settings);
        });
      }
    });

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.settingsTestTitle),
      ),
      child: SafeArea(
        child: settingsStream.when(
          data: (settings) {
            _syncFromSettings(settings);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 説明セクション
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.settingsTestDescription,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.settingsTestGuide,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // リアルタイムデータ表示
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGreen.withValues(
                        alpha: 0.08,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.firestoreCurrentValues,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          l10n.labelDisplayName,
                          settings.displayName,
                        ),
                        _buildInfoRow(
                          l10n.labelNotification,
                          settings.notificationsEnabled ? l10n.on : l10n.off,
                        ),
                        _buildInfoRow(
                          l10n.labelDarkMode,
                          settings.darkModeEnabled ? l10n.on : l10n.off,
                        ),
                        _buildInfoRow(l10n.labelLanguage, settings.language),
                        if (settings.id case final id?)
                          _buildInfoRow(l10n.labelDocumentId, id),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 設定変更フォーム
                  Text(
                    l10n.editSettings,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CupertinoTextField(
                    controller: _displayNameController,
                    placeholder: l10n.placeholderDisplayName,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 通知スイッチ
                  _buildSwitchRow(
                    l10n.switchNotification,
                    _notificationsEnabled,
                    (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),

                  // ダークモードスイッチ
                  _buildSwitchRow(l10n.switchDarkMode, _darkModeEnabled, (
                    value,
                  ) {
                    setState(() {
                      _darkModeEnabled = value;
                    });
                  }),
                  const SizedBox(height: 16),

                  // 言語選択
                  Text(
                    l10n.labelLanguage,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoSlidingSegmentedControl<String>(
                      groupValue: _language,
                      children: {
                        'ja': Text(l10n.languageJa),
                        'en': Text(l10n.languageEn),
                      },
                      onValueChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _language = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 保存ボタン
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      onPressed: () => _saveSettings(settings),
                      child: Text(l10n.saveToFirestore),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 区切り線
                  Container(height: 0.5, color: CupertinoColors.separator),
                  const SizedBox(height: 16),

                  // 個別更新テスト
                  Text(
                    l10n.individualUpdateTest,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      CupertinoButton(
                        onPressed: () =>
                            _updateNotification(!settings.notificationsEnabled),
                        child: Text(l10n.toggleNotification),
                      ),
                      CupertinoButton(
                        onPressed: () =>
                            _updateDarkMode(!settings.darkModeEnabled),
                        child: Text(l10n.toggleDarkMode),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  color: CupertinoColors.destructiveRed,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(l10n.errorMessage('$error')),
                const SizedBox(height: 16),
                CupertinoButton(
                  onPressed: () => ref.invalidate(userSettingsStreamProvider),
                  child: Text(l10n.reload),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        CupertinoSwitch(value: value, onChanged: onChanged),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _saveSettings(UserSettings currentSettings) async {
    final l10n = AppLocalizations.of(context);
    final viewModel = ref.read(userSettingsViewModelProvider.notifier);

    final newSettings = currentSettings.copyWith(
      displayName: _displayNameController.text,
      notificationsEnabled: _notificationsEnabled,
      darkModeEnabled: _darkModeEnabled,
      language: _language,
    );

    try {
      await viewModel.saveSettings(newSettings);
      if (mounted) {
        showCupertinoToast(context, l10n.savedToFirestore);
      }
    } catch (e) {
      if (mounted) {
        showCupertinoToast(context, l10n.saveError('$e'), isError: true);
      }
    }
  }

  Future<void> _updateNotification(bool enabled) async {
    final l10n = AppLocalizations.of(context);
    final viewModel = ref.read(userSettingsViewModelProvider.notifier);
    try {
      await viewModel.updateNotificationEnabled(enabled);
      if (mounted) {
        showCupertinoToast(context, l10n.notificationUpdated);
      }
    } catch (e) {
      if (mounted) {
        showCupertinoToast(context, l10n.errorMessage('$e'), isError: true);
      }
    }
  }

  Future<void> _updateDarkMode(bool enabled) async {
    final l10n = AppLocalizations.of(context);
    final viewModel = ref.read(userSettingsViewModelProvider.notifier);
    try {
      await viewModel.updateDarkModeEnabled(enabled);
      if (mounted) {
        showCupertinoToast(context, l10n.darkModeUpdated);
      }
    } catch (e) {
      if (mounted) {
        showCupertinoToast(context, l10n.errorMessage('$e'), isError: true);
      }
    }
  }
}
