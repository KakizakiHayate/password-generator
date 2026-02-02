import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  return AuthService();
}

/// 匿名認証専用の簡易認証サービス
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 現在のユーザーを取得
  User? get currentUser => _auth.currentUser;

  /// 現在のユーザーIDを取得（未ログイン時はnull）
  String? get userId => _auth.currentUser?.uid;

  /// 認証済みかどうか
  bool get isAuthenticated => _auth.currentUser != null;

  /// 認証状態の変更を監視するStream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// 匿名でサインイン
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  /// サインアウト
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// 認証を確保（未認証の場合は匿名サインイン）
  Future<void> ensureAuthenticated() async {
    if (!isAuthenticated) {
      await signInAnonymously();
    }
  }
}
