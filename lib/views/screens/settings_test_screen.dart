import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore動作テスト'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: settingsStream.when(
        data: (settings) {
          _syncFromSettings(settings);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.blue.shade50,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
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
                ),
                const SizedBox(height: 24),
                Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
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
                ),
                const SizedBox(height: 24),
                const Text(
                  '設定を変更',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _displayNameController,
                  decoration: const InputDecoration(
                    labelText: '表示名',
                    border: OutlineInputBorder(),
                    hintText: '名前を入力してください',
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('通知を有効にする'),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('ダークモードを有効にする'),
                  value: _darkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      _darkModeEnabled = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                const Text('言語', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'ja', label: Text('日本語')),
                    ButtonSegment(value: 'en', label: Text('English')),
                  ],
                  selected: {_language},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _language = newSelection.first;
                    });
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => _saveSettings(settings),
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'Firestoreに保存',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 32),
                const Text(
                  '個別更新テスト',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          _updateNotification(!settings.notificationsEnabled),
                      child: const Text('通知トグル'),
                    ),
                    ElevatedButton(
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('エラー: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(userSettingsStreamProvider),
                child: const Text('再読み込み'),
              ),
            ],
          ),
        ),
      ),
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
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveSettings(UserSettings currentSettings) async {
    final messenger = ScaffoldMessenger.of(context);
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
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Firestoreに保存しました'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('保存エラー: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _updateNotification(bool enabled) async {
    final messenger = ScaffoldMessenger.of(context);
    final viewModel = ref.read(userSettingsViewModelProvider.notifier);
    try {
      await viewModel.updateNotificationEnabled(enabled);
      if (mounted) {
        messenger.showSnackBar(const SnackBar(content: Text('通知設定を更新しました')));
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('エラー: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _updateDarkMode(bool enabled) async {
    final messenger = ScaffoldMessenger.of(context);
    final viewModel = ref.read(userSettingsViewModelProvider.notifier);
    try {
      await viewModel.updateDarkModeEnabled(enabled);
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('ダークモード設定を更新しました')),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('エラー: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
