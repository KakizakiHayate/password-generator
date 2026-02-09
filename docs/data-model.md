# データモデル設計

## スキーマ

<!-- TODO: 新規プロジェクト作成時に記入してください -->

### Firestore データ構造

```
users/
  {userId}/
    settings/
      default          # ユーザー設定（テンプレート実装例）
    <!-- TODO: プロジェクト固有のコレクションを追記 -->
```

### データモデル

<!-- TODO: Freezed モデルの定義を記載してください -->

| モデル | ファイル | フィールド |
|-------|---------|----------|
| <!-- TODO --> | `lib/models/` | <!-- TODO --> |

## CRUD

<!-- TODO: 各モデルの CRUD 操作を記載してください -->

| 操作 | メソッド | 説明 |
|------|---------|------|
| 作成 | `addDocument` | <!-- TODO --> |
| 読取 | `getDocuments` | <!-- TODO --> |
| 更新 | `updateDocument` | <!-- TODO --> |
| 削除 | `deleteDocument` | <!-- TODO --> |
