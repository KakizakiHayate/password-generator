import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/services/firestore_service.dart';
import '../models/user.dart';

part 'user_service.g.dart';

@Riverpod(keepAlive: true)
UserService userService(Ref ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return UserService(firestoreService: firestoreService);
}

/// ユーザーデータ管理サービス
///
/// Firestore の `users/{userId}` ドキュメントを管理する。
class UserService {
  UserService({required FirestoreService firestoreService})
    : _firestoreService = firestoreService;

  final FirestoreService _firestoreService;

  static const _collectionName = 'users';

  /// ユーザードキュメントが存在するか確認する。
  Future<bool> exists(String userId) async {
    final data = await _firestoreService.getTopLevelDocument(
      _collectionName,
      userId,
    );
    return data != null;
  }

  /// デフォルト値でユーザードキュメントを作成する。
  Future<void> createDefault(String userId) async {
    final user = User(createdAt: DateTime.now());
    await _firestoreService.setTopLevelDocument(
      _collectionName,
      userId,
      user.toJson(),
      merge: false,
    );
  }

  /// ユーザーデータを取得する。
  Future<User?> get(String userId) async {
    final data = await _firestoreService.getTopLevelDocument(
      _collectionName,
      userId,
    );
    if (data == null) return null;
    return User.fromJson(data);
  }

  /// generationCount をインクリメントする。
  Future<void> incrementGenerationCount(String userId) async {
    final user = await get(userId);
    if (user == null) return;
    await _firestoreService.updateTopLevelDocument(_collectionName, userId, {
      'generationCount': user.generationCount + 1,
    });
  }

  /// reviewPromptShown を true に更新する。
  Future<void> markReviewPromptShown(String userId) async {
    await _firestoreService.updateTopLevelDocument(_collectionName, userId, {
      'reviewPromptShown': true,
    });
  }
}
