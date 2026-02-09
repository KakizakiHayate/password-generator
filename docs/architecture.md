# アーキテクチャ設計

## ディレクトリ構成

```
lib/
├── main.dart                    # エントリーポイント
├── firebase_options.dart        # Firebase設定（自動生成、gitignore対象）
│
├── core/                        # 共通基盤（アプリ横断で再利用）
│   ├── constants/               # 定数（スペーシング、URL等）
│   ├── providers/               # 共通Provider（サービス層のバレルファイル）
│   ├── services/                # 共通サービス（Auth, Analytics, Crashlytics, Firestore, Preferences）
│   ├── theme/                   # Cupertinoテーマ設定
│   ├── utils/                   # ユーティリティ関数
│   └── widgets/                 # 共通ウィジェット（CupertinoToast等）
│
├── models/                      # データモデル（Freezed）
├── viewmodels/                  # ViewModel（@riverpod class）
├── views/
│   ├── screens/                 # 画面
│   └── widgets/                 # 画面固有ウィジェット
│
├── services/                    # ドメイン固有サービス
├── providers/                   # ドメイン固有Provider
├── routing/                     # ルーティング（go_router）
└── validators/                  # バリデーション
```

## 責務

| レイヤー | 責務 | 例 |
|---------|------|-----|
| View (`views/screens/`) | UI表示、ユーザー入力受付 | `CupertinoPageScaffold`, `CupertinoListTile` |
| ViewModel (`viewmodels/`) | UIロジック、状態管理 | `@riverpod class` + `AsyncNotifier` |
| Service (`core/services/`, `services/`) | ビジネスロジック、データ永続化 | CRUD操作、API通信 |
| Model (`models/`) | データ構造 | Freezed + json_serializable |

## 依存関係の方向

```
View → ViewModel → Service → Model
         ↓
    Provider (DI)
```

- View は ViewModel のみに依存する（Service を直接呼ばない）
- ViewModel は Service 層のみに依存する（View に依存しない）
- Service は Model に依存する
- Provider（Riverpod）で依存性を注入する
