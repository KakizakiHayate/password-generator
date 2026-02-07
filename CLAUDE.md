# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

<!-- ===========================================
  このCLAUDE.mdはテンプレートです。
  新規プロジェクト作成時は「Project Overview」セクションのみ書き換えてください。
  それ以外のセクション（アーキテクチャ、開発ルール等）はそのまま使用できます。
=========================================== -->

## Project Overview

<!-- TODO: 新規プロジェクト作成時にこのセクションを書き換えてください -->

**個人開発用Flutterスターターキット（テンプレートプロジェクト）**

### 目的
新しいFlutterアプリを開発する際に、このプロジェクトをクローンして使用することで、共通機能の実装時間を削減し、開発を高速化する。

### 使い方
1. このリポジトリをクローンして新しいプロジェクト名でコピー
2. セットアップスクリプトを実行（プロジェクト名、バンドルID、Firebase設定を自動化）
3. すぐにアプリ固有の機能開発を開始できる

### このプロジェクトに機能を追加する判断基準
- **追加すべき**: 複数のアプリで共通して使う機能、毎回同じコードを書く機能
- **追加しない**: 特定のアプリにしか使わない機能

---

## 技術仕様

### 対象プラットフォーム
- iOS
- Android

### UI
- **基本**: Cupertino（iOS風）ベース
- **テーマ**: CupertinoApp + CupertinoThemeData
- Apple Human Interface Guidelinesに準拠

### 多言語対応
- 日本語（デフォルト）
- 英語
- flutter_localizations使用

---

## アーキテクチャ（MVVM + Riverpod）

### フォルダ構成
```
lib/
├── main.dart                    # エントリーポイント
├── firebase_options.dart        # Firebase設定（自動生成、gitignore対象）
│
├── core/                        # 共通基盤（アプリ横断で再利用）
│   ├── constants/               # 定数（スペーシング、URL等）
│   ├── providers/               # 共通Provider（サービス層のDI）
│   │   └── service_providers.dart
│   ├── services/                # 共通サービス
│   │   ├── analytics_service.dart
│   │   ├── auth_service.dart
│   │   └── crashlytics_service.dart
│   ├── theme/                   # テーマ設定
│   │   └── cupertino_theme.dart
│   ├── utils/                   # ユーティリティ関数
│   └── widgets/                 # 共通ウィジェット
│
├── models/                      # データモデル（freezed使用）
│
├── viewmodels/                  # ViewModel（riverpod codegen）
│   └── xxx_viewmodel.dart
│
├── views/
│   ├── screens/                 # 画面
│   │   └── xxx_screen.dart
│   └── widgets/                 # 画面固有ウィジェット
│
├── services/                    # ドメイン固有サービス（データ永続化等）
│
├── providers/                   # ドメイン固有Provider
│
├── routing/                     # ルーティング
│   └── app_router.dart          # go_router設定
│
└── validators/                  # バリデーション
```

### レイヤー責務

| レイヤー | 責務 | 例 |
|---------|------|-----|
| View (screens/) | UI表示、ユーザー入力受付 | CupertinoPageScaffold, CupertinoListTile |
| ViewModel (viewmodels/) | UIロジック、状態管理 | @riverpod class + AsyncNotifier |
| Service (services/) | ビジネスロジック、データ永続化 | CRUD操作、API通信 |
| Model (models/) | データ構造 | freezed + json_serializable |

### ViewModel実装パターン（riverpod codegen）

```dart
// ViewModel定義（@riverpod codegenを使用）
@riverpod
class XxxViewModel extends _$XxxViewModel {
  @override
  Future<List<Xxx>> build() async {
    final firestore = ref.watch(firestoreServiceProvider);
    final auth = ref.watch(authServiceProvider);
    final data = await firestore.getDocuments(auth.userId!, 'xxx');
    return data.map(Xxx.fromJson).toList();
  }

  Future<void> addItem(Xxx item) async {
    final firestore = ref.read(firestoreServiceProvider);
    final auth = ref.read(authServiceProvider);
    await firestore.addDocument(auth.userId!, 'xxx', item.toJson());
    ref.invalidateSelf();
  }

  Future<void> updateItem(String id, Map<String, dynamic> data) async {
    final firestore = ref.read(firestoreServiceProvider);
    final auth = ref.read(authServiceProvider);
    await firestore.updateDocument(auth.userId!, 'xxx', id, data);
    ref.invalidateSelf();
  }

  Future<void> deleteItem(String id) async {
    final firestore = ref.read(firestoreServiceProvider);
    final auth = ref.read(authServiceProvider);
    await firestore.deleteDocument(auth.userId!, 'xxx', id);
    ref.invalidateSelf();
  }
}

// リアルタイム監視用のProvider
@riverpod
Stream<List<Xxx>> xxxStream(Ref ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  final auth = ref.watch(authServiceProvider);
  return firestore
      .watchDocuments(auth.userId!, 'xxx')
      .map((docs) => docs.map(Xxx.fromJson).toList());
}
```

**Firestoreデータ構造:**
```
users/
  {userId}/
    settings/
      default          # ユーザー設定
    tasks/
      {taskId}         # タスクドキュメント
    {other_collection}/
      {docId}          # その他のデータ
```

### ルーティング（go_router）

```dart
final appRouterProvider = Provider<GoRouter>((ref) {
  final analyticsService = ref.watch(analyticsServiceProvider);

  return GoRouter(
    initialLocation: '/',
    observers: [AnalyticsRouteObserver(analyticsService: analyticsService)],
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      // 他のルート...
    ],
  );
});
```

### main.dart構成

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final container = ProviderContainer();
  await _initializeServices(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return CupertinoApp.router(
      theme: /* CupertinoThemeData */,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', 'JP'),
        Locale('en', 'US'),
      ],
      routerConfig: router,
    );
  }
}
```

---

## 含まれる共通機能

### Firebase連携
| 機能 | 状態 | 説明 |
|------|------|------|
| Firebase Core | 実装済み | Firebase初期化 |
| Analytics | 実装済み | イベント追跡、ユーザーID設定 |
| Crashlytics | 実装済み | クラッシュレポート、エラーハンドリング |
| Auth（匿名認証） | 実装済み | 匿名ユーザー自動作成 |
| Firestore | 実装済み | クラウドデータベース、汎用サービス |

### ローカルストレージ
| 機能 | 状態 | 説明 |
|------|------|------|
| SharedPreferences | 実装済み | キーバリュー保存のラッパー |

### 状態管理
| 機能 | 状態 | 説明 |
|------|------|------|
| Riverpod | 実装済み | Provider設定、コード生成対応 |

### UI/UX
| 機能 | 状態 | 説明 |
|------|------|------|
| Cupertinoテーマ | 未実装 | iOS風UIテーマ |
| go_router | 未実装 | 宣言的ルーティング + Analytics連携 |

### 国際化（i18n）
| 機能 | 状態 | 説明 |
|------|------|------|
| 多言語対応 | 未実装 | 日本語/英語切り替え |

### セットアップ自動化
| 機能 | 状態 | 説明 |
|------|------|------|
| setup.sh | 未実装 | プロジェクト名、バンドルID、Firebase設定の自動化 |

---

## Claudeへの指示

### 機能追加の提案時
このプロジェクトはテンプレートなので、新機能を提案する際は以下を考慮すること：
1. **汎用性**: 複数のアプリで使える機能か？
2. **再利用性**: コードがそのまま流用できる形か？
3. **設定の柔軟性**: プロジェクト固有の値はセットアップ時に変更可能か？

### コード実装時
- サービスクラスはRiverpodのProviderとして実装
- ViewModelはriverpod codegen（@riverpod class）を使用
- デバッグモードとリリースモードの挙動を分ける
- ハードコードされた値は避け、設定可能にする
- UIはCupertino系ウィジェットを優先

---

## ドキュメント参照（必須）

実装時は必ず以下のドキュメントを参照すること。

### 画面実装時
- [docs/screens.md](docs/screens.md) - 画面一覧・UI構成

### 機能実装時
- [docs/features.md](docs/features.md) - 機能一覧・詳細仕様

### モデル・データ層実装時
- [docs/data-model.md](docs/data-model.md) - データモデル設計

### UIデザイン判断時
曖昧な仕様がある場合、以下の優先順で参照して判断すること：
1. [docs/human-interface-guideline.md](docs/human-interface-guideline.md) - Apple HIG
2. [docs/target-user.md](docs/target-user.md) - ターゲットユーザー
3. [docs/mvp-requirement.md](docs/mvp-requirement.md) - プロジェクト方針

---

## Issue作成ルール（必須）

### 詳細なIssueを作成する場合

詳細なタスク内容を記載するIssueには、**必ずテストケースを含めること**。

#### テストケース作成時の参照ドキュメント

- [docs/test-cases.md](docs/test-cases.md) - テストケース一覧

#### 記載フォーマット例

```markdown
## テストケース

### 1. 〇〇機能
| ID | テストケース | 期待結果 |
|----|-------------|---------|
| T-1.1 | 〇〇を入力する | △△が表示される |
| T-1.2 | □□ボタンを押す | ◇◇が実行される |

### 2. バリデーション
| ID | テストケース | 期待結果 |
|----|-------------|---------|
| T-2.1 | 空欄で送信 | エラーメッセージ表示 |
```

#### 簡易Issueの場合
「詳細は後で入力」のような簡易Issueは、**実装着手前に詳細化すること**。

---

## 質問ルール（必須）

ユーザーに質問・確認をする際は、以下のルールに従うこと。

### 1. 質問の構成

- **最初に質問の総数を宣言する**（例: 「3点確認させてください。」）
- **1つずつ順番に質問する**（一度に複数の質問をまとめない）
- 前の質問の回答を受けてから次の質問に進む

### 2. 質問の具体性（5W2Hを意識）

曖昧な質問はしない。以下を明確にして質問すること：

| 要素 | 内容 | 悪い例 | 良い例 |
|------|------|--------|--------|
| **What** | 何について | 「エラーが出ますか？」 | 「Firestore書き込み時にPermission Deniedエラーが出ますか？」 |
| **Who** | 誰が対象か | 「ユーザーの問題です」 | 「匿名認証済みユーザーが初回起動時に発生する問題です」 |
| **When** | いつ発生するか | 「たまに起きます」 | 「アプリをバックグラウンドから復帰した直後に発生します」 |
| **Where** | どこで | 「画面で起きます」 | 「設定画面（SettingsScreen）の保存ボタン押下時に発生します」 |
| **Why** | なぜ聞くのか | （理由なし） | 「この選択により、データ構造が大きく変わるためお聞きします」 |
| **How** | どのように | 「対応しますか？」 | 「A案: Firestoreのルールを変更 / B案: Cloud Functionsで処理」 |
| **How much** | 規模・影響範囲 | 「影響あります」 | 「この変更で3ファイル・約50行の修正が必要です」 |

### 3. 選択肢の提示

すべての質問に選択肢を付けること：

```
2点確認させてください。

【質問 1/2】データの保存先をどちらにしますか？

- **A. Firestore（推奨）** — リアルタイム同期が必要な場合。既存のFirestoreServiceをそのまま利用可能
- **B. SharedPreferences** — ローカルのみで十分な場合。実装はシンプルだが端末間同期不可

上記以外の方法があればお知らせください。
```

### 4. 推奨の明示

- 選択肢の中でAIが推奨するものに **「（推奨）」** を付ける
- 推奨する理由を1文で添える
- 推奨がない場合（どちらでも同等）は、その旨を明記する

---

## TDD（テスト駆動開発）

本プロジェクトでは **TDD（Test-Driven Development）** を採用する。

### Red → Green → Refactor サイクル

```
① Red（赤）    ② Green（緑）    ③ Refactor（改善）
   失敗     →     成功      →      改善       → ①に戻る
```

| ステップ | 内容 | やること |
|---------|------|----------|
| **① Red** | テストを書く → **失敗する** | 実装前にテストコードを書く。まだ実装がないので失敗する |
| **② Green** | 最小限のコードを書く → **成功する** | テストが通る最小限の実装を書く。完璧でなくてよい |
| **③ Refactor** | コードを改善 → **成功のまま** | テストが通ったままコードを整理・改善する |

### TDDの実践例

```dart
// ① Red: まずテストを書く（この時点で実装はない → 失敗）
test('Itemを作成できる', () {
  final item = Item(id: '123', label: 'テスト', text: 'テスト内容');
  expect(item.label, 'テスト');
});

// ② Green: テストが通る最小限の実装を書く
class Item {
  final String id;
  final String label;
  final String text;
  Item({required this.id, required this.label, required this.text});
}

// ③ Refactor: コードを改善（freezed化、copyWith追加など）
```

### TDDを適用する範囲

| 対象 | TDD適用 |
|------|--------|
| Model（データクラス） | ○ |
| ViewModel（ビジネスロジック） | ○ |
| Service（データ永続化） | ○ |
| View（UIウィジェット） | △（Widget Testは任意） |

---

## 実装ワークフロー

### Phase 1: 実装前チェック（必須）

実装を開始する前に、以下を確認する：

| # | チェック項目 | 確認内容 |
|---|-------------|----------|
| 1 | **要件の明確さ** | Issueに曖昧な要件がないか？不明点があればユーザーに確認する |
| 2 | **テストケースの存在** | Issueにテストケース（ID付きテーブル）が記載されているか？ |

**テストケースがない場合:** 実装前にユーザーへ報告し、テストケースを作成してもらうか、自分で作成して承認を得る。

---

### Phase 1.5: テストコード作成（TDD - Red）

Issueのテストケースに基づいて、**実装前に**テストコードを書く。

```bash
# テストファイル配置場所
test/
├── models/          # Modelのテスト
├── viewmodels/      # ViewModelのテスト
└── services/        # Serviceのテスト
```

**この時点でテストを実行すると失敗する（Red）** → 正常

---

### Phase 2: 実装（TDD - Green）

テストが通る最小限のコードを実装する。

```bash
# テスト実行で成功を確認
flutter test test/models/xxx_test.dart
```

**すべてのテストが通ったら（Green）** → Phase 2.5へ

---

### Phase 2.5: リファクタリング（TDD - Refactor）

テストが通ったまま、コードを改善する：

- 変数名・メソッド名の改善
- 重複コードの削除
- 可読性の向上

```bash
# リファクタリング後もテストが通ることを確認
flutter test
```

---

### Phase 3: PR作成前チェック（必須）

実装が完了したら、PR作成前に以下を**順番に**実行する。

#### 1. セルフレビューチェック

[docs/self-review-checklist.md](docs/self-review-checklist.md) の項目を確認する：

| カテゴリ | 主なチェック項目 |
|---------|-----------------|
| **Branch** | `develop`から派生、`feature/*` 形式 |
| **PR作成** | 1タスク1PR、エビデンス添付 |
| **命名規則** | PascalCase(クラス)、camelCase(変数)、snake_case(ファイル)、Bool型は`is`接頭辞 |
| **共通化** | 共通コードは`core/`へ、モジュール固有はモジュール内 |
| **コメント** | `// TODO:`形式、複雑なロジックに意図説明 |
| **その他** | ネスト2重以内、メソッド40行以内、強制アンラップ禁止、タイポなし |

違反がある場合は修正してから次へ進む。

#### 2. 自動チェックコマンド

```bash
# 1. コードフォーマット
dart format lib/ test/

# 2. 静的解析
flutter analyze

# 3. カスタムLint
dart run custom_lint

# 4. 全テスト実行
flutter test
```

- フォーマット・Lintエラーがある場合は、**自動的に修正してOK**（ユーザー確認不要）
- テストが失敗した場合は、修正してから次へ進む

**すべて通過したら** コミット・PR作成へ進む。

---

### Phase 4: PR作成後チェック（必須）

PRを作成した後、以下を確認する：

```bash
gh pr checks <PR番号>        # GitHub Actionsの結果
gh api repos/{owner}/{repo}/pulls/<PR番号>/comments  # レビューコメント
```

- GitHub Actionsが失敗している場合、エラー内容を確認して修正
- レビューコメントがある場合：
  - **必ずユーザーに内容を報告する**
  - **修正内容を説明し、ユーザーの承認を得てから修正を行う**

---

### Phase 5: PRマージ（「PR #XXをマージして」と言われた場合）

以下の手順を実行する：

```bash
# 1. ローカル変更があればstash
git stash

# 2. PRのブランチに切り替え
git checkout <ブランチ名>

# 3. ターゲットブランチ（通常はdevelop）の最新を取り込む
git fetch origin
git merge origin/develop

# 4. コンフリクトがあれば解決してコミット
# コンフリクトがなければそのままプッシュ
git push origin <ブランチ名>

# 5. PRをsquashマージしてブランチ削除
gh pr merge <PR番号> --squash --delete-branch

# 6. developブランチに切り替えて最新を取得
git checkout develop && git pull origin develop

# 7. マージ済みブランチの削除確認
git branch -d <ブランチ名> 2>/dev/null || echo "ローカルブランチは既に削除済み"
git push origin --delete <ブランチ名> 2>/dev/null || echo "リモートブランチは既に削除済み"
```

マージ完了後、次のタスク候補を提案する。

---

## バグ対応ワークフロー

バグ報告を受けた場合、**いきなり修正せず**、以下の手順で対応する。

### Step 1: 調査（必須）

まず原因を特定するための調査を行う：

```
1. バグの再現条件を確認
2. 関連するソースコードを読む
3. データフロー・状態遷移を追跡
4. 類似のバグや関連するIssue/PRがないか確認
```

### Step 2: 判断分岐

調査結果に基づいて、以下のいずれかを選択する：

| 状況 | アクション |
|------|-----------|
| **原因が特定でき、自信を持って修正できる** | → 修正内容をユーザーに提案し、承認後に修正 |
| **原因の候補はあるが確信が持てない** | → デバッグログ追加を提案（Step 3へ） |
| **原因がまったく分からない** | → 調査で分かったことを報告し、追加情報をユーザーに求める |

### Step 3: デバッグログ追加の提案

確信が持てない場合、以下の形式でデバッグログ追加を提案する：

```markdown
## 調査結果
- 確認したファイル: `lib/xxx.dart`, `lib/yyy.dart`
- 現時点の仮説: 〇〇が△△のタイミングで□□になっている可能性

## デバッグログ追加の提案
以下の箇所にログを追加して、実際の動作を確認させてください：

1. `lib/xxx.dart:XX行目` - 〇〇の値を確認
2. `lib/yyy.dart:YY行目` - △△のタイミングを確認
```

**ユーザーの承認後**、デバッグログを追加し、ユーザーに再現手順の実行を依頼する。

---

## ブランチルール

[docs/git-rules.md](docs/git-rules.md) を参照。
