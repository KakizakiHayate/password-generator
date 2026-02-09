# Gitルール

## ブランチ戦略

| ブランチ | 用途 | マージ先 |
|---------|------|---------|
| `main` | リリースブランチ | - |
| `develop` | 開発ブランチ | `main` |
| `feature/*` | 機能開発 | `develop` |
| `fix/*` | バグ修正 | `develop` |

### ルール

- `main` / `develop` への直接コミットは禁止（PR 経由のみ）
- 機能開発は `develop` から `feature/{issue番号}-{概要}` ブランチを作成
- PR は `develop` に向けて作成する
- `main` へのマージは `develop` からのみ

## コミットメッセージ規約

```
<type>: <概要>
```

### type 一覧

| type | 用途 |
|------|------|
| `feat` | 新機能 |
| `fix` | バグ修正 |
| `refactor` | リファクタリング（機能変更なし） |
| `docs` | ドキュメントのみの変更 |
| `test` | テストの追加・修正 |
| `chore` | ビルド・CI・依存関係等の変更 |

### 例

```
feat: ユーザー設定画面の追加
fix: Firestore書き込み時のnullエラーを修正
docs: README.mdのセットアップ手順を更新
```

## マージルール

- PR は squash merge を使用する
- マージ後、feature ブランチは削除する
- 1 タスク = 1 PR を原則とする
