# CLAUDE.md
This file provides guidance to Claude Code when working with code in this repository.

## Project Overview

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
- 画面実装: docs/screens.md
- 機能実装: docs/features.md
- データ層: docs/data-model.md

## Issue作成ルール
詳細なIssueには必ずテストケースを含めること。

## 実装ワークフロー (TDD)
Red(テスト作成) -> Green(実装) -> Refactor のサイクルを厳守。

## ブランチルール
docs/git-rules.md を参照。
