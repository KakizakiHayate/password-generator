import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/cupertino_toast.dart';
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
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Firestore動作テスト'),
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
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Firestore動作確認',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '設定を変更して「保存」ボタンを押すと、Firestoreに保存されます。\n'
                          'アプリを再起動しても設定が保持されることを確認できます。',
                          style: TextStyle(fontSize: 14),
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
                      color: CupertinoColors.systemGreen.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Firestoreの現在値（リアルタイム）',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('表示名', settings.displayName),
                        _buildInfoRow(
                          '通知',
                          settings.notificationsEnabled ? 'ON' : 'OFF',
                        ),
                        _buildInfoRow(
                          'ダークモード',
                          settings.darkModeEnabled ? 'ON' : 'OFF',
                        ),
                        _buildInfoRow('言語', settings.language),
                        if (settings.id case final id?)
                          _buildInfoRow('ドキュメントID', id),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 設定変更フォーム
                  const Text(
                    '設定を変更',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  CupertinoTextField(
                    controller: _displayNameController,
                    placeholder: '表示名を入力してください',
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 通知スイッチ
                  _buildSwitchRow(
                    '通知を有効にする',
                    _notificationsEnabled,
                    (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),

                  // ダークモードスイッチ
                  _buildSwitchRow(
                    'ダークモードを有効にする',
                    _darkModeEnabled,
                    (value) {
                      setState(() {
                        _darkModeEnabled = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // 言語選択
                  const Text('言語', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoSlidingSegmentedControl<String>(
                      groupValue: _language,
                      children: const {
                        'ja': Text('日本語'),
                        'en': Text('English'),
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
                      child: const Text('Firestoreに保存'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 区切り線
                  Container(height: 0.5, color: CupertinoColors.separator),
                  const SizedBox(height: 16),

                  // 個別更新テスト
                  const Text(
                    '個別更新テスト',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      CupertinoButton(
                        onPressed: () =>
                            _updateNotification(!settings.notificationsEnabled),
                        child: const Text('通知トグル'),
                      ),
                      CupertinoButton(
                        onPressed: () =>
                            _updateDarkMode(!settings.darkModeEnabled),
                        child: const Text('ダークモードトグル'),
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
                Text('エラー: $error'),
                const SizedBox(height: 16),
                CupertinoButton(
                  onPressed: () => ref.invalidate(userSettingsStreamProvider),
                  child: const Text('再読み込み'),
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
        showCupertinoToast(context, 'Firestoreに保存しました');
      }
    } catch (e) {
      if (mounted) {
        showCupertinoToast(context, '保存エラー: $e', isError: true);
      }
    }
  }

  Future<void> _updateNotification(bool enabled) async {
    final viewModel = ref.read(userSettingsViewModelProvider.notifier);
    try {
      await viewModel.updateNotificationEnabled(enabled);
      if (mounted) {
        showCupertinoToast(context, '通知設定を更新しました');
      }
    } catch (e) {
      if (mounted) {
        showCupertinoToast(context, 'エラー: $e', isError: true);
      }
    }
  }

  Future<void> _updateDarkMode(bool enabled) async {
    final viewModel = ref.read(userSettingsViewModelProvider.notifier);
    try {
      await viewModel.updateDarkModeEnabled(enabled);
      if (mounted) {
        showCupertinoToast(context, 'ダークモード設定を更新しました');
      }
    } catch (e) {
      if (mounted) {
        showCupertinoToast(context, 'エラー: $e', isError: true);
      }
    }
  }
}
