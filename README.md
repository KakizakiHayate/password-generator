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
# 1. クローン（develop ブランチを指定）
git clone -b develop <repository-url> my-app
cd my-app

# 2. セットアップスクリプトを実行（パッケージ名・Bundle ID・表示名を自動変更）
make setup
# または: ./setup.sh

# 3. Firebase 設定（自分の Firebase プロジェクトに接続）
flutterfire configure

# 4. 実行
flutter run
```

## 新規プロジェクト立ち上げチェックリスト

### Part 1: 自動セットアップ

セットアップスクリプトが以下をすべて自動で行います。

```bash
make setup
# 対話モード: プロジェクト名と表示名を聞かれます
# 非対話モード: ./setup.sh my_todo_app "My Todo App"
```

**スクリプトが実行する内容:**

| # | 処理 | 対象ファイル |
|---|------|-------------|
| 1 | pubspec.yaml のパッケージ名・説明を変更 | `pubspec.yaml` |
| 2 | lib/ と test/ の import を一括置換 | `lib/**/*.dart`, `test/**/*.dart` |
| 3 | カスタム lint パッケージのリネーム | `flutter_fast_starter_lints/` → `{名前}_lints/` |
| 4 | iOS Bundle ID を置換 | `ios/Runner.xcodeproj/project.pbxproj` |
| 5 | Android Bundle ID を置換 | `android/app/build.gradle.kts` |
| 6 | Android MainActivity のパッケージ名・ディレクトリを変更 | `android/app/src/main/kotlin/...` |
| 7 | アプリ表示名を変更 | `ios/Runner/Info.plist`, `AndroidManifest.xml` |
| 8 | import 順序を自動修正（`dart fix --apply`） | `lib/`, `test/` |
| 9 | 依存関係を取得（`flutter pub get`） | - |
| 10 | Firebase プロジェクトを作成（`firebase projects:create`） | - |
| 11 | FlutterFire で Firebase を接続（`flutterfire configure`） | `lib/firebase_options.dart` |
| 12 | 静的解析（`flutter analyze`） | - |
| 13 | テスト実行（`flutter test`） | - |

Bundle ID は `com.h.dev.{プロジェクト名のキャメルケース}` の形式で自動生成されます。
Firebase プロジェクト ID はプロジェクト名のケバブケース（例: `my_todo_app` → `my-todo-app`）で自動生成されます。

> **注意:** Step 10-11 は `firebase` / `flutterfire` CLI が必要です。未インストールの場合はスキップされます。

#### 不要な実装例の削除

テンプレートに含まれる MVVM 実装例が不要な場合は削除してください。

```bash
rm -f lib/models/user_settings.dart lib/models/user_settings.freezed.dart lib/models/user_settings.g.dart
rm -f lib/viewmodels/user_settings_viewmodel.dart lib/viewmodels/user_settings_viewmodel.g.dart
rm -f lib/views/screens/settings_test_screen.dart
# lib/main.dart から SettingsTestScreen への参照を手動で削除
```

#### CI の検証

```bash
# GitHub にリポジトリを作成して push
gh repo create <リポジトリ名> --private --source=. --push

# main ブランチを作成して push（CI のターゲットブランチとして必要）
git checkout -b main
git push -u origin main

# develop ブランチに戻り、PR を作成して CI をトリガー
git checkout develop
gh pr create --base main --head develop --title "Initial setup" --body "セットアップ検証用"

# CI の結果を確認（Lint Check・Test ともに pass であること）
gh pr checks <PR番号> --watch
```

### Part 2: 手動（セットアップスクリプト完了後に必要な作業）

#### 2-1. Firebase コンソールでの有効化

セットアップスクリプトが Firebase プロジェクトの作成と FlutterFire の接続を自動で行いますが、以下は Firebase コンソール（https://console.firebase.google.com）での手動操作が必要です。

**Authentication（匿名認証）:**
1. Firebase コンソール → 作成したプロジェクトを開く
2. 左メニュー「Authentication」→「始める」
3. 「ログイン方法」タブ →「匿名」を有効にする

**Firestore Database:**
1. 左メニュー「Firestore Database」→「データベースの作成」
2. テストモードで開始（本番前にセキュリティルールを設定）

#### 2-2. `lib/main.dart` の編集

`SettingsTestScreen` への参照を削除し、アプリ固有のホーム画面に変更してください。

#### 2-3. Fastlane の設定

```bash
cp ios/fastlane/.env.example ios/fastlane/.env
```

`.env` に以下を記入（Apple Developer アカウントの情報が必要）:

- `APPLE_ID` — Apple ID
- `TEAM_ID` — Developer Team ID
- `APP_IDENTIFIER` — Bundle ID

#### 2-4. その他

- [ ] この README.md をアプリ固有の内容に書き換え
- [ ] `CLAUDE.md` の「Project Overview」セクションを書き換え

### 検証チェックリスト

すべての作業完了後、以下を確認してください。

| # | 確認項目 | コマンド / 方法 |
|---|---------|----------------|
| 1 | 依存関係が取得できる | `flutter pub get` |
| 2 | 静的解析がエラー0件 | `dart analyze` |
| 3 | テストが全パス | `flutter test` |
| 4 | CI が pass | `gh pr checks <PR番号>` |
| 5 | Fastlane がインストールできる | `cd ios && bundle install` |
| 6 | アプリが起動する | `flutter run` |
| 7 | Firestore CRUD が動作する | 設定テスト画面で確認 |

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
| `make setup` | 新規プロジェクトのセットアップ（リネーム・検証） |
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
├── firebase_options.dart            # Firebase 設定（自動生成、gitignore 対象）
├── core/
│   ├── constants/                   # AppSpacing 等の定数
│   ├── providers/                   # 共通 Provider（サービス層の DI）
│   ├── services/                    # Auth, Analytics, Crashlytics, Firestore, Preferences
│   ├── theme/                       # Cupertino テーマ設定
│   ├── utils/                       # ユーティリティ関数
│   └── widgets/                     # 共通ウィジェット（CupertinoToast 等）
├── models/                          # Freezed データモデル
├── viewmodels/                      # ViewModel（Riverpod codegen）
├── views/
│   ├── screens/                     # 画面
│   └── widgets/                     # 画面固有ウィジェット
├── services/                        # ドメイン固有サービス
├── providers/                       # ドメイン固有 Provider
├── routing/                         # ルーティング（go_router）
└── validators/                      # バリデーション
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
