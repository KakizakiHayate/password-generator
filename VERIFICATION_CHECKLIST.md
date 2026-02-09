# テンプレート検証チェックリスト

新規プロジェクトとしてクローン・セットアップ後、テンプレートが正しく機能するかを確認するためのチェックリストです。

---

## 1. リネーム完了確認

パッケージ名・Bundle ID・表示名のリネームが漏れなく完了しているかを確認してください。

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 1-1 | `flutter_fast_starter` がコード内に残っていない | `grep -r "flutter_fast_starter" lib/ test/ pubspec.yaml` で 0 件 | |
| 1-2 | `pubspec.yaml` の `name` がリネームされている | `head -1 pubspec.yaml` | |
| 1-3 | カスタム lint パッケージがリネームされている | ディレクトリ名・`pubspec.yaml` の name・本体 `pubspec.yaml` の参照 | |
| 1-4 | iOS Bundle ID がリネームされている | `grep PRODUCT_BUNDLE_IDENTIFIER ios/Runner.xcodeproj/project.pbxproj` | |
| 1-5 | Android applicationId がリネームされている | `android/app/build.gradle.kts` の `applicationId` を確認 | |
| 1-6 | iOS 表示名がリネームされている | `ios/Runner/Info.plist` の `CFBundleDisplayName` / `CFBundleName` | |
| 1-7 | Android 表示名がリネームされている | `android/app/src/main/AndroidManifest.xml` の `android:label` | |
| 1-8 | Bundle ID が `com.h.dev.{キャメルケース}` 形式になっている | iOS / Android 両方を確認 | |

## 2. Firebase セットアップ

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 2-1 | Firebase プロジェクトが作成されている | `firebase projects:list` で対象プロジェクトが表示される | |
| 2-2 | `firebase_options.dart` が生成されている | `lib/firebase_options.dart` が存在し、正しいプロジェクト ID が記載 | |
| 2-3 | 匿名認証が有効化されている（手動） | Firebase コンソール → Authentication → ログイン方法 → 匿名が有効 | |
| 2-4 | Firestore Database が作成されている（手動） | Firebase コンソール → Firestore Database にデータベースが存在 | |

## 3. アプリ起動・認証

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 3-1 | アプリが正常に起動する | `flutter run` でエラーなく起動 | |
| 3-2 | 匿名認証が自動実行される | Firebase コンソール → Authentication にユーザーが追加されている | |

## 4. Firestore CRUD（設定テスト画面）

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 4-1 | ホーム画面から設定テスト画面に遷移できる | 「Firestore動作テスト」ボタンをタップ | |
| 4-2 | 表示名を保存できる | テキスト入力 →「Firestoreに保存」→ リアルタイムデータ表示に反映 | |
| 4-3 | 通知・ダークモードのトグルが保存される | スイッチ切り替え → 保存 → リアルタイム表示に反映 | |
| 4-4 | 言語選択が保存される | 日本語/English を選択 → 保存 → リアルタイム表示に反映 | |
| 4-5 | 個別更新が即時反映される | 「個別更新テスト」のトグルボタンをタップ → リアルタイム表示に反映 | |
| 4-6 | Firebase コンソールでデータが確認できる | Firestore → `users/{userId}/settings/default` にドキュメントが存在 | |

## 5. Analytics・Crashlytics

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 5-1 | Analytics がデバッグモードでログ出力される | `flutter run` 中のコンソールに Analytics ログが表示される | |
| 5-2 | Crashlytics が初期化されている | アプリ起動時にエラーハンドラが登録される（起動エラーなし） | |

## 6. PreferencesService

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 6-1 | 初期化が完了している | アプリ起動時にエラーが出ない | |
| 6-2 | Provider 経由ですぐ使える設計になっている | `ref.read(preferencesServiceProvider)` で取得 → `setString` / `getString` 等が呼べる | |

## 7. ビルド・静的解析・テスト

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 7-1 | 依存関係が取得できる | `flutter pub get` が成功 | |
| 7-2 | 静的解析がエラー 0 件 | `dart analyze` を実行（info は許容） | |
| 7-3 | テストが全パスする | `flutter test`（6テスト） | |
| 7-4 | iOS シミュレータでビルド・起動できる | `flutter run` | |
| 7-5 | コード生成が動作する | `dart run build_runner build --delete-conflicting-outputs` で `.g.dart` / `.freezed.dart` が生成される | |

## 8. プラットフォーム固有設定

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 8-1 | Podfile に Firestore プリコンパイル設定がある | `ios/Podfile` に `FirebaseFirestore` の `invertase/firestore-ios-sdk-frameworks` 参照 | |
| 8-2 | iOS minimum version が適切 | `ios/Podfile` の `platform :ios` の値を確認 | |
| 8-3 | Android minSdk が適切 | `android/app/build.gradle.kts` の `minSdk` を確認 | |
| 8-4 | 必要な依存パッケージが揃っている | `pubspec.yaml` に firebase_core, firebase_auth, cloud_firestore, firebase_analytics, firebase_crashlytics, flutter_riverpod, freezed_annotation, shared_preferences 等が含まれる | |
| 8-5 | dev_dependencies にコード生成ツールが揃っている | `pubspec.yaml` に build_runner, riverpod_generator, freezed, json_serializable, custom_lint が含まれる | |

## 9. CI（GitHub Actions）

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 9-1 | `ci.yml` が存在する | `.github/workflows/ci.yml` | |
| 9-2 | Lint Check ジョブが pass する | PR 作成 → `gh pr checks` で確認 | |
| 9-3 | Test ジョブが pass する | PR 作成 → `gh pr checks` で確認 | |
| 9-4 | ダミー `firebase_options.dart` の生成が動作する | CI ログでエラーがないこと | |
| 9-5 | カスタム lint の依存関係取得が動作する | CI ログで `custom_lint` 関連エラーがないこと | |

## 10. Fastlane

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 10-1 | `ios/fastlane/Fastfile` が存在する | ファイル確認 | |
| 10-2 | `ios/fastlane/Appfile` が存在する | ファイル確認 | |
| 10-3 | `ios/fastlane/Matchfile` が存在する | ファイル確認 | |
| 10-4 | `ios/fastlane/.env.example` が存在する | ファイル確認 | |
| 10-5 | `bundle install` が成功する | `cd ios && bundle install` | |
| 10-6 | メタデータ（ja / en-US）が存在する | `ios/fastlane/metadata/` 配下を確認 | |
| 10-7 | `.env` が `.gitignore` に含まれている | `.gitignore` を確認 | |

## 11. Makefile

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 11-1 | `Makefile` が存在する | ファイル確認 | |
| 11-2 | `make help` が動作する | コマンド実行 | |
| 11-3 | `make lint` が動作する | コマンド実行 | |
| 11-4 | `make test` が動作する | コマンド実行 | |
| 11-5 | `make check` が動作する | コマンド実行（lint + test 一括） | |

## 12. ドキュメント

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 12-1 | `README.md` が存在し、セットアップ手順が記載されている | ファイル確認 | |
| 12-2 | `CLAUDE.md` が存在する | ファイル確認 | |
| 12-3 | `docs/` に必要なドキュメントが揃っている | 下記14ファイルが存在するか確認 | |

### `docs/` に含まれるべきファイル

| ファイル | 存在 |
|---------|------|
| `architecture.md` | |
| `build-and-test.md` | |
| `data-model.md` | |
| `fastlane-setup.md` | |
| `features.md` | |
| `git-rules.md` | |
| `human-interface-guideline.md` | |
| `implementation-guide.md` | |
| `mvp-requirement.md` | |
| `reusable-components.md` | |
| `screens.md` | |
| `self-review-checklist.md` | |
| `target-user.md` | |
| `test-cases.md` | |

### `docs/` の記載内容

ドキュメントが「存在する」だけでなく、テンプレートとして必要な内容が記載されているかを確認してください。

#### テンプレート共通（クローン時点で内容があるべき）

| # | ファイル | 必要な内容 | 結果 |
|---|---------|-----------|------|
| 12-4 | `architecture.md` | ディレクトリ構成、レイヤー責務、依存関係の方向 | |
| 12-5 | `build-and-test.md` | ビルドコマンド、テスト実行方法、CI との関係 | |
| 12-6 | `git-rules.md` | ブランチ戦略（main/develop/feature）、コミットメッセージ規約、マージルール | |
| 12-7 | `self-review-checklist.md` | PR 作成前のチェック項目（CLAUDE.md Phase 3 で参照されている） | |
| 12-8 | `implementation-guide.md` | 新機能追加の手順（Model → Service → ViewModel → View の順序） | |
| 12-9 | `reusable-components.md` | テンプレートに含まれる再利用可能なサービス・ウィジェット一覧 | |
| 12-10 | `fastlane-setup.md` | Fastlane のセットアップ・実行手順 | |
| 12-11 | `human-interface-guideline.md` | Cupertino UI の設計指針、使用すべきウィジェットの一覧 | |

#### プロジェクト固有（新規プロジェクト作成時に記入する。テンプレートでは TODO やプレースホルダーがあるべき）

| # | ファイル | 必要な内容 | 結果 |
|---|---------|-----------|------|
| 12-12 | `mvp-requirement.md` | MVP の機能要件、技術スタック。TODO プレースホルダーがあるか | |
| 12-13 | `target-user.md` | ターゲットユーザーのペルソナ、課題、コアバリュー。TODO プレースホルダーがあるか | |
| 12-14 | `screens.md` | 画面一覧、UI 構成、画面遷移図。TODO プレースホルダーがあるか | |
| 12-15 | `features.md` | 機能一覧と詳細仕様。TODO プレースホルダーがあるか | |
| 12-16 | `data-model.md` | データモデル定義、Firestore スキーマ。TODO プレースホルダーがあるか | |
| 12-17 | `test-cases.md` | テストケーステンプレート（ID・テストケース・期待結果のテーブル例）。TODO プレースホルダーがあるか | |

## 13. CLAUDE.md と実装の整合性

CLAUDE.md はテンプレートの設計書として機能するため、記載内容と実装が一致しているかを確認してください。

### フォルダ構成

| # | 確認内容 | CLAUDE.md の記載 | 結果 |
|---|---------|-----------------|------|
| 13-1 | `core/providers/service_providers.dart` が存在するか | フォルダ構成に記載あり | |
| 13-2 | `core/theme/cupertino_theme.dart` が存在するか | フォルダ構成に記載あり | |
| 13-3 | `core/services/` に記載されたサービスが揃っているか | `analytics_service.dart`, `auth_service.dart`, `crashlytics_service.dart` | |
| 13-4 | `core/services/` に CLAUDE.md 未記載のサービスが含まれていないか | `firestore_service.dart`, `preferences_service.dart` が実装にはあるが構成図に未記載 | |
| 13-5 | `routing/app_router.dart` が存在するか | フォルダ構成に記載あり | |
| 13-6 | `validators/` ディレクトリが存在するか | フォルダ構成に記載あり | |
| 13-7 | `services/`（ドメイン固有）ディレクトリが存在するか | フォルダ構成に記載あり | |
| 13-8 | `providers/`（ドメイン固有）ディレクトリが存在するか | フォルダ構成に記載あり | |

### 技術仕様との整合性

| # | 確認内容 | CLAUDE.md の記載 | 結果 |
|---|---------|-----------------|------|
| 13-9 | `CupertinoApp` を使っているか | 「CupertinoApp + CupertinoThemeData」 | |
| 13-10 | `go_router` が実装されているか | ルーティング例に `GoRouter` の記載あり | |
| 13-11 | `flutter_localizations` が実装されているか | 「日本語/英語、flutter_localizations使用」 | |
| 13-12 | `main.dart` が `UncontrolledProviderScope` を使っているか | main.dart 構成例に記載あり | |

### 「含まれる共通機能」テーブルとの整合性

| # | 確認内容 | CLAUDE.md の状態 | 結果 |
|---|---------|-----------------|------|
| 13-13 | Firebase Core が実装済みか | 実装済み | |
| 13-14 | Analytics が実装済みか | 実装済み | |
| 13-15 | Crashlytics が実装済みか | 実装済み | |
| 13-16 | Auth（匿名認証）が実装済みか | 実装済み | |
| 13-17 | Firestore が実装済みか | 実装済み | |
| 13-18 | SharedPreferences が実装済みか | 実装済み | |
| 13-19 | Riverpod が実装済みか | 実装済み | |
| 13-20 | Cupertino テーマの状態が正しいか | 未実装 | |
| 13-21 | go_router の状態が正しいか | 未実装 | |
| 13-22 | 多言語対応の状態が正しいか | 未実装 | |
| 13-23 | setup.sh の状態が正しいか | 未実装 | |

### ViewModel 実装パターンとの整合性

| # | 確認内容 | CLAUDE.md の記載 | 結果 |
|---|---------|-----------------|------|
| 13-24 | ViewModel が `@riverpod class` で実装されているか | パターン例に記載 | |
| 13-25 | `ref.invalidateSelf()` で状態更新しているか | パターン例に記載 | |
| 13-26 | リアルタイム監視用の Stream Provider があるか | `xxxStream` パターンに記載 | |
| 13-27 | Firestore データ構造が `users/{userId}/{subcollection}` になっているか | データ構造に記載 | |

### 開発ルール

| # | 確認内容 | CLAUDE.md の記載 | 結果 |
|---|---------|-----------------|------|
| 13-28 | `docs/` 内の参照先ファイルが全て存在するか | ドキュメント参照セクションにリンクあり | |
| 13-29 | `docs/self-review-checklist.md` に具体的な項目が記載されているか | Phase 3 で参照 | |
| 13-30 | `docs/git-rules.md` に具体的なルールが記載されているか | ブランチルールセクションで参照 | |

## 14. MVVM + Riverpod アーキテクチャ

### レイヤー分離

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 14-1 | Model が `lib/models/` に配置されている | ディレクトリ確認 | |
| 14-2 | Model が freezed で実装されている | `@freezed` アノテーション、`.freezed.dart` / `.g.dart` が存在 | |
| 14-3 | Model に `fromJson` ファクトリがある | JSON シリアライズ対応 | |
| 14-4 | ViewModel が `lib/viewmodels/` に配置されている | ディレクトリ確認 | |
| 14-5 | ViewModel が `@riverpod class` で実装されている | riverpod codegen を使用 | |
| 14-6 | ViewModel が Service 層のみに依存している（View に依存していない） | import 文を確認 | |
| 14-7 | View が `lib/views/screens/` に配置されている | ディレクトリ確認 | |
| 14-8 | View が `ConsumerWidget` または `ConsumerStatefulWidget` を継承している | クラス定義を確認 | |
| 14-9 | View が ViewModel の Provider を `ref.watch` / `ref.read` で参照している | UI コードを確認 | |
| 14-10 | Service が `lib/core/services/` に配置されている | ディレクトリ確認 | |

### Riverpod の使い方

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 14-11 | Provider が `@Riverpod` / `@riverpod` で定義されている | codegen を使用（手書き Provider ではない） | |
| 14-12 | keepAlive なサービスは `@Riverpod(keepAlive: true)` になっている | サービス層の Provider を確認 | |
| 14-13 | `main.dart` で `ProviderContainer` + `UncontrolledProviderScope` を使っている | 初期化パターンを確認 | |
| 14-14 | `ref.invalidateSelf()` で ViewModel の状態を更新している | ViewModel の更新メソッドを確認 | |
| 14-15 | リアルタイム監視用の Stream Provider がある | `watchDocuments` を使った Provider が存在 | |

### サービスの再利用しやすさ

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 14-16 | `FirestoreService` が汎用的に使える | 新しいコレクション名を渡すだけで CRUD できる設計か | |
| 14-17 | `AuthService` が他サービスから参照しやすい | `ref.read(authServiceProvider).userId!` で取得できるか | |
| 14-18 | `PreferencesService` がすぐ使える | Provider 経由で `set/get` メソッドが呼べるか | |
| 14-19 | `AnalyticsService` が簡単に呼べる | Provider 経由で `logEvent` 等が1行で呼べるか | |
| 14-20 | `CrashlyticsService` が簡単に呼べる | Provider 経由で `recordError` 等が1行で呼べるか | |

## 15. コード品質・Lint

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 15-1 | `analysis_options.yaml` に厳格なルールが設定されている | ファイル確認 | |
| 15-2 | コード生成ファイルが除外設定されている | `*.g.dart`, `*.freezed.dart` が exclude に含まれる | |
| 15-3 | `flutter analyze` が実行できる | `flutter analyze` を実行してエラー 0 件 | |
| 15-4 | カスタム lint パッケージが存在する | `{プロジェクト名}_lints/` ディレクトリが存在 | |
| 15-5 | `custom_lint` プラグインが有効化されている | `analysis_options.yaml` で `plugins: [custom_lint]` | |
| 15-6 | `dart run custom_lint` が実行できる | コマンド実行してエラーがないこと | |
| 15-7 | `avoid_deep_nesting` ルールが機能する | 3重以上のネストを書くと警告が出ること | |
| 15-8 | `avoid_force_unwrap` ルールが機能する | `!` 強制アンラップを書くと警告が出ること | |
| 15-9 | `make lint` で analyze + custom_lint が一括実行される | `make lint` を実行 | |
| 15-10 | `make lint-fix` で自動修正が動作する | `make lint-fix` を実行 | |

## 16. セキュリティ（.gitignore）

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 16-1 | `firebase_options.dart` が gitignore されている | `.gitignore` を確認 | |
| 16-2 | `GoogleService-Info.plist` が gitignore されている | `.gitignore` を確認 | |
| 16-3 | `google-services.json` が gitignore されている | `.gitignore` を確認 | |
| 16-4 | `ios/fastlane/.env` が gitignore されている | `.gitignore` を確認 | |

## 17. UI 構成（CLAUDE.md との整合性）

CLAUDE.md に「UIはCupertino（iOS風）ベース」と定義されているため、以下を確認してください。

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 17-1 | `CupertinoApp` が使われている（`MaterialApp` ではない） | `lib/main.dart` を確認 | |
| 17-2 | `CupertinoThemeData` でテーマが定義されている | `lib/main.dart` または `lib/core/theme/` を確認 | |
| 17-3 | 画面が `CupertinoPageScaffold` を使っている | `lib/views/screens/` のウィジェットを確認 | |
| 17-4 | ナビゲーションが Cupertino 系（`CupertinoNavigationBar` 等）を使っている | 画面のAppBarを確認 | |
| 17-5 | 入力系が Cupertino 系（`CupertinoTextField`, `CupertinoSwitch` 等）を使っている | 設定テスト画面のウィジェットを確認 | |

## 18. アセット・ツール

| # | 確認内容 | 確認方法 | 結果 |
|---|---------|---------|------|
| 18-1 | プレースホルダーアイコンのソース画像が存在する | `assets/icon/app_icon.png` が存在 | |
| 18-2 | アイコン生成ツールが動作する | `dart tool/generate_placeholder_icon.dart` を実行 | |
| 18-3 | `flutter_launcher_icons` の設定が `pubspec.yaml` にある | `flutter_launcher_icons:` セクションを確認 | |
| 18-4 | `flutter_launcher_icons` でアイコン生成が動作する | `dart run flutter_launcher_icons` を実行 | |
| 18-5 | iOS アプリアイコンが生成されている | `ios/Runner/Assets.xcassets/AppIcon.appiconset/` に画像ファイルが存在 | |
| 18-6 | Android アプリアイコンが生成されている | `android/app/src/main/res/mipmap-*/` にアイコンファイルが存在 | |
