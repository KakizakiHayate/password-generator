import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_service.g.dart';

@Riverpod(keepAlive: true)
FirestoreService firestoreService(Ref ref) {
  return FirestoreService();
}

/// Firestoreの汎用サービス
///
/// ユーザーデータの保存・取得を簡単に行えるラッパーを提供します。
/// コレクション構造: users/{userId}/{subcollection}/{docId}
/// トップレベルコレクション: {collectionName}/{docId}
class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Firestoreインスタンスを取得（テスト用）
  FirebaseFirestore get instance => _firestore;

  // ============================================================
  // ユーザードキュメント操作
  // ============================================================

  /// ユーザードキュメントの参照を取得
  DocumentReference<Map<String, dynamic>> userDoc(String userId) {
    return _firestore.collection('users').doc(userId);
  }

  /// ユーザーデータを取得
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    final doc = await userDoc(userId).get();
    return doc.data();
  }

  /// ユーザーデータを保存（マージモード）
  Future<void> setUserData(
    String userId,
    Map<String, dynamic> data, {
    bool merge = true,
  }) async {
    await userDoc(userId).set(data, SetOptions(merge: merge));
  }

  /// ユーザーデータを更新
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    await userDoc(userId).update(data);
  }

  // ============================================================
  // サブコレクション操作（ユーザーごとのデータ）
  // ============================================================

  /// ユーザーのサブコレクション参照を取得
  CollectionReference<Map<String, dynamic>> userCollection(
    String userId,
    String collectionName,
  ) {
    return userDoc(userId).collection(collectionName);
  }

  /// ドキュメントを追加（IDは自動生成）
  Future<DocumentReference<Map<String, dynamic>>> addDocument(
    String userId,
    String collectionName,
    Map<String, dynamic> data,
  ) async {
    final dataWithTimestamp = {
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    return userCollection(userId, collectionName).add(dataWithTimestamp);
  }

  /// ドキュメントを保存（ID指定）
  Future<void> setDocument(
    String userId,
    String collectionName,
    String docId,
    Map<String, dynamic> data, {
    bool merge = true,
  }) async {
    developer.log(
      '[DEBUG] setDocument: users/$userId/$collectionName/$docId',
      name: 'FirestoreService',
    );
    developer.log('[DEBUG] data: $data', name: 'FirestoreService');
    final dataWithTimestamp = {
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
      if (!merge) 'createdAt': FieldValue.serverTimestamp(),
    };
    await userCollection(
      userId,
      collectionName,
    ).doc(docId).set(dataWithTimestamp, SetOptions(merge: merge));
    developer.log('[DEBUG] setDocument 完了', name: 'FirestoreService');
  }

  /// ドキュメントを取得
  Future<Map<String, dynamic>?> getDocument(
    String userId,
    String collectionName,
    String docId,
  ) async {
    final doc = await userCollection(userId, collectionName).doc(docId).get();
    if (!doc.exists) return null;
    final data = doc.data();
    if (data == null) return null;
    return {'id': doc.id, ...data};
  }

  /// ドキュメントを更新
  Future<void> updateDocument(
    String userId,
    String collectionName,
    String docId,
    Map<String, dynamic> data,
  ) async {
    final dataWithTimestamp = {
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await userCollection(
      userId,
      collectionName,
    ).doc(docId).update(dataWithTimestamp);
  }

  /// ドキュメントを削除
  Future<void> deleteDocument(
    String userId,
    String collectionName,
    String docId,
  ) async {
    await userCollection(userId, collectionName).doc(docId).delete();
  }

  /// コレクション内の全ドキュメントを取得
  Future<List<Map<String, dynamic>>> getDocuments(
    String userId,
    String collectionName, {
    Query<Map<String, dynamic>> Function(
      CollectionReference<Map<String, dynamic>>,
    )?
    queryBuilder,
  }) async {
    Query<Map<String, dynamic>> query = userCollection(userId, collectionName);
    if (queryBuilder != null) {
      query = queryBuilder(userCollection(userId, collectionName));
    }
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  /// コレクションをリアルタイムで監視
  Stream<List<Map<String, dynamic>>> watchDocuments(
    String userId,
    String collectionName, {
    Query<Map<String, dynamic>> Function(
      CollectionReference<Map<String, dynamic>>,
    )?
    queryBuilder,
  }) {
    Query<Map<String, dynamic>> query = userCollection(userId, collectionName);
    if (queryBuilder != null) {
      query = queryBuilder(userCollection(userId, collectionName));
    }
    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList(),
    );
  }

  /// 単一ドキュメントをリアルタイムで監視
  Stream<Map<String, dynamic>?> watchDocument(
    String userId,
    String collectionName,
    String docId,
  ) {
    return userCollection(userId, collectionName).doc(docId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) return null;
      final data = snapshot.data();
      if (data == null) return null;
      return {'id': snapshot.id, ...data};
    });
  }

  // ============================================================
  // トップレベルコレクション操作
  // ============================================================

  /// トップレベルコレクションのドキュメント参照を取得
  DocumentReference<Map<String, dynamic>> topLevelDoc(
    String collectionName,
    String docId,
  ) {
    return _firestore.collection(collectionName).doc(docId);
  }

  /// トップレベルコレクションのドキュメントを取得
  Future<Map<String, dynamic>?> getTopLevelDocument(
    String collectionName,
    String docId,
  ) async {
    final doc = await topLevelDoc(collectionName, docId).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  /// トップレベルコレクションのドキュメントを保存（マージモード）
  Future<void> setTopLevelDocument(
    String collectionName,
    String docId,
    Map<String, dynamic> data, {
    bool merge = true,
  }) async {
    await topLevelDoc(
      collectionName,
      docId,
    ).set(data, SetOptions(merge: merge));
  }

  /// トップレベルコレクションのドキュメントを更新
  Future<void> updateTopLevelDocument(
    String collectionName,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await topLevelDoc(collectionName, docId).update(data);
  }

  // ============================================================
  // バッチ操作
  // ============================================================

  /// バッチ書き込みを実行
  Future<void> runBatch(void Function(WriteBatch batch) operations) async {
    final batch = _firestore.batch();
    operations(batch);
    await batch.commit();
  }

  // ============================================================
  // トランザクション
  // ============================================================

  /// トランザクションを実行
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) handler,
  ) async {
    return _firestore.runTransaction(handler);
  }
}
