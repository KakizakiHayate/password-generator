import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/services/firestore_service.dart';
import '../models/generator_settings.dart';

part 'settings_service.g.dart';

@Riverpod(keepAlive: true)
SettingsService settingsService(Ref ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return SettingsService(firestoreService: firestoreService);
}

/// 設定の保存・復元サービス
///
/// Firestore の `settings/{userId}` ドキュメントを管理する。
class SettingsService {
  SettingsService({required FirestoreService firestoreService})
    : _firestoreService = firestoreService;

  final FirestoreService _firestoreService;

  static const _collectionName = 'settings';

  /// 設定を読み込む。存在しない場合はデフォルト値で作成して返す。
  Future<GeneratorSettings> loadOrCreate(String userId) async {
    final data = await _firestoreService.getTopLevelDocument(
      _collectionName,
      userId,
    );

    if (data == null) {
      const defaults = GeneratorSettings();
      await save(userId, defaults);
      return defaults;
    }

    return GeneratorSettings.fromJson(data);
  }

  /// 設定を保存する。
  Future<void> save(String userId, GeneratorSettings settings) async {
    await _firestoreService.setTopLevelDocument(
      _collectionName,
      userId,
      settings.toJson(),
    );
  }

  /// 設定の一部フィールドを更新する。
  Future<void> update(String userId, Map<String, dynamic> fields) async {
    await _firestoreService.updateTopLevelDocument(
      _collectionName,
      userId,
      fields,
    );
  }
}
