# Flutter Fast Starter

個人開発用 Flutter スターターキット。
クローンして新しいアプリ開発を高速に始めるためのテンプレートプロジェクト。

## すぐに使えるもの

クローン後、Firebase を接続するだけで以下がすべて動作します。

### サービス一覧

| サービス | Provider | 用途 |
|---------|----------|------|
| `AuthService` | `authServiceProvider` | 匿名認証（自動サインイン） |
| `AnalyticsService` | `analyticsServiceProvider` | 画面表示・カスタムイベント記録 |
| `CrashlyticsService` | `crashlyticsServiceProvider` | エラー自動収集・ログ記録 |
| `FirestoreService` | `firestoreServiceProvider` | Firestore CRUD・リアルタイム監視 |
| `PreferencesService` | `preferencesServiceProvider` | ローカルストレージ |

### 使い方（コード例）

```dart
// Firestore にドキュメントを追加
final firestore = ref.read(firestoreServiceProvider);
final auth = ref.read(authServiceProvider);
await firestore.addDocument(auth.userId!, 'tasks', {'title': 'Buy milk'});

// Firestore をリアルタイム監視
final stream = firestore.watchDocuments(auth.userId!, 'tasks');

// Analytics イベント記録
final analytics = ref.read(analyticsServiceProvider);
await analytics.logScreenView(screenName: 'HomeScreen');

// ローカル保存
final prefs = ref.read(preferencesServiceProvider);
await prefs.setString('theme', 'dark');
final theme = prefs.getString('theme');
```

> `AnalyticsService` は `kDebugMode` 時にイベント送信をスキップし、コンソールにログ出力します。

### 実装例

テンプレートには MVVM パターンの実装例が含まれています。

| ファイル | 役割 |
|---------|------|
| `lib/models/user_settings.dart` | Freezed データモデル |
| `lib/viewmodels/user_settings_viewmodel.dart` | ViewModel（Riverpod codegen） |
| `lib/views/screens/settings_test_screen.dart` | Firestore 動作確認画面 |

## セットアップ

### 前提条件

- Flutter SDK ^3.10.7
- Xcode（iOS ビルド用）
- Ruby（Fastlane 用）

### 手順

```bash
# 1. クローン
git clone <repository-url> my-app
cd my-app

# 2. 依存関係インストール
flutter pub get

# 3. Firebase 設定（自分の Firebase プロジェクトに接続）
flutterfire configure

# 4. 実行
flutter run
```

## 新規プロジェクト立ち上げチェックリスト

以下の例では、パッケージ名 `my_todo_app`、Bundle ID `com.example.mytodo`、表示名 `My Todo App` として記載しています。

### 1. パッケージ名の変更

- [ ] `pubspec.yaml` — `name: flutter_fast_starter` を `name: my_todo_app` に変更
- [ ] `pubspec.yaml` — `description` をアプリの説明に変更
- [ ] `lib/` と `test/` の全 `.dart` ファイル — `package:flutter_fast_starter` を `package:my_todo_app` に一括置換

```bash
# 一括置換コマンド（macOS）
find lib test -name '*.dart' -exec sed -i '' 's/package:flutter_fast_starter/package:my_todo_app/g' {} +
```

### 2. アプリ ID の変更

- [ ] `android/app/build.gradle.kts` — `applicationId` と `namespace` を変更
- [ ] `ios/Runner.xcodeproj/project.pbxproj` — `PRODUCT_BUNDLE_IDENTIFIER` を一括置換（6箇所: Runner 3箇所 + RunnerTests 3箇所）

```bash
# Android（build.gradle.kts を手動編集）
# namespace = "com.example.mytodo"
# applicationId = "com.example.mytodo"

# iOS Bundle ID の一括置換（macOS）
sed -i '' 's/com.h.dev.flutterFastStarter/com.example.mytodo/g' ios/Runner.xcodeproj/project.pbxproj
```

### 3. 表示名の変更

- [ ] `ios/Runner/Info.plist` — `CFBundleDisplayName` と `CFBundleName` を変更
- [ ] `android/app/src/main/AndroidManifest.xml` — `android:label` を変更
- [ ] `lib/main.dart` — `MaterialApp` の `title` を変更

### 4. Firebase の再接続

- [ ] `flutterfire configure` を実行して自分の Firebase プロジェクトに接続

### 5. Fastlane の設定

- [ ] `ios/fastlane/.env.example` → `.env` にコピーし、自分の Apple ID 等を記入

### 6. 不要な実装例の削除

- [ ] `lib/models/user_settings.dart`（+ `.freezed.dart`, `.g.dart`）
- [ ] `lib/viewmodels/user_settings_viewmodel.dart`（+ `.g.dart`）
- [ ] `lib/views/screens/settings_test_screen.dart`
- [ ] `lib/main.dart` から `SettingsTestScreen` への参照を削除

### 7. その他

- [ ] この README.md をアプリ固有の内容に書き換え
- [ ] `CLAUDE.md` の「Project Overview」セクションを書き換え

## 新機能の追加方法

### MVVM モジュールの追加

CLAUDE.md に記載のアーキテクチャに従って実装します。

```
lib/
├── models/           # Freezed データモデル
├── viewmodels/       # ViewModel（@riverpod class）
├── views/
│   ├── screens/      # 画面
│   └── widgets/      # 画面固有ウィジェット
└── services/         # ドメイン固有サービス
```

### データモデルの作成（Freezed）

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
sealed class Todo with _$Todo {
  const factory Todo({
    String? id,
    required String title,
    @Default(false) bool completed,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
```

コード生成の実行:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 開発コマンド（Makefile）

`make help` で全コマンドを確認できます。

| コマンド | 説明 |
|---------|------|
| `make run` | デバッグ実行 |
| `make get` | 依存関係取得 |
| `make clean` | キャッシュクリア + pub get |
| `make lint` | flutter analyze + custom_lint |
| `make lint-fix` | 自動修正 |
| `make test` | ユニットテスト実行 |
| `make check` | lint + test 一括実行 |
| `make ci` | CI パイプライン（lint + test + build） |

## CI（GitHub Actions）

PR 作成時に自動で以下が実行されます（`.github/workflows/ci.yml`）。

| ジョブ | 内容 |
|-------|------|
| Lint | `flutter analyze` + `custom_lint` |
| Test | `flutter test` |

## iOS デプロイ（Fastlane）

TestFlight / App Store へのデプロイを自動化できます。

| レーン | 用途 |
|-------|------|
| `fastlane ios beta` | TestFlight にアップロード |
| `fastlane ios release` | App Store Connect にアップロード |

### Fastlane セットアップ

```bash
cd ios
cp fastlane/.env.example fastlane/.env
# .env に Apple ID、Team ID 等を記入
bundle install
bundle exec fastlane ios beta
```

> `.env` には認証情報が含まれるため、Git にはコミットしません（`.gitignore` で除外済み）。

## プロジェクト構成

```
lib/
├── main.dart                        # エントリーポイント
├── firebase_options.dart            # Firebase 設定（自動生成）
├── core/
│   ├── constants/                   # AppSpacing 等の定数
│   ├── services/                    # Auth, Analytics, Crashlytics, Firestore, Preferences
│   ├── ui/                          # 共通 UI コンポーネント（将来追加）
│   └── utils/                       # ユーティリティ関数（将来追加）
├── models/                          # Freezed データモデル
├── viewmodels/                      # ViewModel（Riverpod codegen）
├── views/
│   └── screens/                     # 画面
└── ui/
    ├── theme/                       # テーマ設定（将来追加）
    └── widgets/                     # 共通ウィジェット（将来追加）
```

## ドキュメント

まずアーキテクチャと実装ガイドを読むことを推奨します。

| 優先度 | ファイル | 内容 |
|-------|---------|------|
| 1 | [CLAUDE.md](CLAUDE.md) | アーキテクチャ・開発ルール・ViewModel パターン |
| 2 | [docs/implementation-guide.md](docs/implementation-guide.md) | 実装手順ガイド |
| 3 | [docs/screens.md](docs/screens.md) | 画面定義 |
| 3 | [docs/features.md](docs/features.md) | 機能定義 |
| 3 | [docs/data-model.md](docs/data-model.md) | データモデル |
| - | [docs/git-rules.md](docs/git-rules.md) | Git ルール |
| - | [docs/build-and-test.md](docs/build-and-test.md) | ビルド・テスト |
| - | [docs/self-review-checklist.md](docs/self-review-checklist.md) | セルフレビューチェックリスト |
| - | [docs/test-cases.md](docs/test-cases.md) | テストケース |
| - | [docs/human-interface-guideline.md](docs/human-interface-guideline.md) | HIG ガイドライン |
| - | [docs/target-user.md](docs/target-user.md) | ターゲットユーザー |
| - | [docs/mvp-requirement.md](docs/mvp-requirement.md) | MVP 要件 |
| - | [docs/reusable-components.md](docs/reusable-components.md) | 再利用コンポーネント |
