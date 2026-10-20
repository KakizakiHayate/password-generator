# Gitルール

## ブランチ戦略

| ブランチ | 用途 | マージ先 |
|---------|------|---------|
| `develop` | 開発ブランチ（デフォルト） | - |
| `feature/*` | 機能開発 | `develop` |
| `fix/*` | バグ修正 | `develop` |
| `chore/*` | 雑務・設定変更 | `develop` |
| `release/{x.y.z+n}` | リリース用のバージョン更新 | `develop` |
| `main` | 配布済みの状態 | - |

### ルール

- `develop` / `main` への直接コミットは禁止（PR 経由のみ）
- 機能開発は `develop` から `feature/{issue番号}-{概要}` ブランチを作成
- 通常の PR は `develop` に向けて作成する
- `release/` はリリース時のバージョン更新専用。通常の開発には使わない

## リリースとタグ

1. 前回のリリースタグを確認する: `git tag --list 'v[0-9]*' --sort=-v:refname | head -1`
2. 前回タグから `develop` までの差分でリリース内容を確認する: `git log <前回タグ>..origin/develop --oneline`
3. `develop` の最新から `release/{x.y.z+n}` を作成する（例: `release/1.0.2+3`。`pubspec.yaml` の `version` と同じ形式）
4. `release` ブランチで `pubspec.yaml` のバージョン・ビルド番号を更新してコミットし、`develop` 向けの PR を作成する
   - ビルド番号は App Store Connect で使用済みの番号より大きくする（`builds.list` で確認）
5. `release` ブランチからビルド・アップロード・審査提出を行う
6. 提出したビルドのコミットにタグ `v{x.y.z+n}`（例: `v1.0.2+3`）を付けて push する
7. release PR は **merge commit** で `develop` にマージする（squash するとタグのコミットが `develop` の履歴から外れるため）
8. `main` を配布した `release` ブランチの最新に進める（`git push origin origin/release/{x.y.z+n}:main`）

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

- 通常の PR は squash merge を使用する（release PR だけは merge commit）
- マージ後、feature ブランチは削除する
- 1 タスク = 1 PR を原則とする
