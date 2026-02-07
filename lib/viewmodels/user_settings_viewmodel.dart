import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/services/auth_service.dart';
import '../core/services/firestore_service.dart';
import '../models/user_settings.dart';

part 'user_settings_viewmodel.g.dart';

/// ユーザー設定のViewModel
///
/// FirestoreServiceを使用してFirestoreとやり取りします。
@riverpod
class UserSettingsViewModel extends _$UserSettingsViewModel {
  @override
  Future<UserSettings> build() async {
    final firestore = ref.watch(firestoreServiceProvider);
    final userId = _requireUserId();
    final data = await firestore.getDocument(
      userId,
      'settings',
      'default',
    );
    return data != null ? UserSettings.fromJson(data) : const UserSettings();
  }

  /// 認証済みユーザーIDを取得（未認証時はエラー）
  String _requireUserId() {
    final auth = ref.read(authServiceProvider);
    final userId = auth.userId;
    if (userId == null) {
      throw StateError('User must be authenticated');
    }
    return userId;
  }

  /// 表示名を更新
  Future<void> updateDisplayName(String displayName) async {
    final firestore = ref.read(firestoreServiceProvider);
    final userId = _requireUserId();
    await firestore.updateDocument(
      userId,
      'settings',
      'default',
      {'displayName': displayName},
    );
    ref.invalidateSelf();
  }

  /// 通知設定を更新
  Future<void> updateNotificationEnabled(bool enabled) async {
    final firestore = ref.read(firestoreServiceProvider);
    final userId = _requireUserId();
    await firestore.updateDocument(
      userId,
      'settings',
      'default',
      {'notificationsEnabled': enabled},
    );
    ref.invalidateSelf();
  }

  /// ダークモード設定を更新
  Future<void> updateDarkModeEnabled(bool enabled) async {
    final firestore = ref.read(firestoreServiceProvider);
    final userId = _requireUserId();
    await firestore.updateDocument(
      userId,
      'settings',
      'default',
      {'darkModeEnabled': enabled},
    );
    ref.invalidateSelf();
  }

  /// 言語設定を更新
  Future<void> updateLanguage(String language) async {
    final firestore = ref.read(firestoreServiceProvider);
    final userId = _requireUserId();
    await firestore.updateDocument(
      userId,
      'settings',
      'default',
      {'language': language},
    );
    ref.invalidateSelf();
  }

  /// 設定を一括保存
  Future<void> saveSettings(UserSettings settings) async {
    final firestore = ref.read(firestoreServiceProvider);
    final userId = _requireUserId();
    await firestore.setDocument(
      userId,
      'settings',
      'default',
      settings.toJson(),
    );
    ref.invalidateSelf();
  }
}

/// リアルタイム監視用のProvider
@riverpod
Stream<UserSettings> userSettingsStream(Ref ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  final auth = ref.watch(authServiceProvider);
  final userId = auth.userId;
  if (userId == null) {
    return Stream.value(const UserSettings());
  }
  return firestore
      .watchDocument(userId, 'settings', 'default')
      .map((data) =>
          data != null ? UserSettings.fromJson(data) : const UserSettings());
}
