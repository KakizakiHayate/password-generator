# 再利用可能コンポーネント一覧

テンプレートに含まれる、すぐに使えるサービスとウィジェット。

## サービス

| サービス | Provider | 用途 |
|---------|----------|------|
| `AuthService` | `authServiceProvider` | 匿名認証（自動サインイン）、ユーザーID取得 |
| `AnalyticsService` | `analyticsServiceProvider` | 画面表示・カスタムイベント記録（デバッグモードではコンソール出力） |
| `CrashlyticsService` | `crashlyticsServiceProvider` | エラー自動収集・ログ記録 |
| `FirestoreService` | `firestoreServiceProvider` | Firestore CRUD・リアルタイム監視（汎用） |
| `PreferencesService` | `preferencesServiceProvider` | SharedPreferences ラッパー |

### 使い方

```dart
// バレルファイルから一括 import
import 'package:flutter_fast_starter/core/providers/service_providers.dart';

// Firestore にドキュメントを追加
final firestore = ref.read(firestoreServiceProvider);
final auth = ref.read(authServiceProvider);
await firestore.addDocument(auth.userId!, 'tasks', {'title': 'Buy milk'});

// リアルタイム監視
final stream = firestore.watchDocuments(auth.userId!, 'tasks');

// Analytics イベント記録
final analytics = ref.read(analyticsServiceProvider);
await analytics.logScreenView(screenName: 'HomeScreen');

// ローカル保存
final prefs = ref.read(preferencesServiceProvider);
await prefs.setString('theme', 'dark');
```

## ウィジェット

| ウィジェット | パス | 用途 |
|------------|------|------|
| `showCupertinoToast` | `core/widgets/cupertino_toast.dart` | Cupertino スタイルのトースト通知 |

## 定数

| クラス | パス | 内容 |
|-------|------|------|
| `AppSpacing` | `core/constants/app_spacing.dart` | スペーシング定数（xs, sm, md, lg, xl, xxl, section） |

## テーマ

| 定数 | パス | 内容 |
|------|------|------|
| `appTheme` | `core/theme/cupertino_theme.dart` | Cupertino テーマ定義 |
