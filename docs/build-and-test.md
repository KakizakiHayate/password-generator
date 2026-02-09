# ビルド・テスト手順

## コマンド

### 基本コマンド

| コマンド | 説明 |
|---------|------|
| `flutter pub get` | 依存関係の取得 |
| `flutter run` | デバッグ実行 |
| `flutter build ios` | iOS リリースビルド |
| `flutter build apk` | Android リリースビルド |
| `flutter test` | 全テスト実行 |
| `dart analyze` | 静的解析 |
| `dart format lib/ test/` | コードフォーマット |

### コード生成

```bash
dart run build_runner build --delete-conflicting-outputs
```

Freezed モデルや Riverpod codegen の `.g.dart` / `.freezed.dart` を生成する。

### Makefile（推奨）

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

## CI との関係

GitHub Actions（`.github/workflows/ci.yml`）で PR 作成時に自動実行される。

| ジョブ | 内容 |
|-------|------|
| Lint Check | `flutter analyze` + `dart run custom_lint` |
| Test | `flutter test` |

CI ではダミーの `firebase_options.dart` を自動生成するため、Firebase の設定がなくてもビルドが通る。
