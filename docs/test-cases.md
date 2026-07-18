# テストケース一覧（実装ベース）

## 概要

- このドキュメントは **2026-07-18 時点で実装済みのテスト**を自動抽出した目録です。
- 旧版（設計時の予定表）は git 履歴を参照してください。
- 正本（テスト設計方針）: `~/.claude/docs/flutter-test-design.md`
- 分類はケース単位です。`test()` は Unit、`testWidgets()` は Widget、`integration_test/` 配下は種別を問わず Integration として数えるため、1つのファイルが複数の章に登場することがあります。
- サマリー表と準拠チェックの件数は**「有効」のみ**を数えます（skip / placeholder は除外）。

| 層 | ファイル数 | 有効ケース数 | skip | placeholder |
|---|---|---|---|---|
| 1. Unit | 14 | 83 | 0 | 0 |
| 2. Widget | 3 | 7 | 0 | 0 |
| 3. Integration | 1 | 1 | 0 | 0 |
| 4. E2E (Maestro) | 0 | 0 | 0 | 0 |
| **合計** | **18** | **91** | **0** | **0** |

> ファイル数は層ごとの実ファイル数です。同じファイルが複数の層を含む場合、合計は実ファイル数より多くなります。

## 1. Unit Test

### 1.1 Service（`test/core/services/`）

1 ファイル / 7 有効ケース

| ID | テストケース | 状態 | ファイル |
|---|---|---|---|
| T-1.1.1 | 静的メソッド > T-P.1: readString/readBoolは未設定時にデフォルト値を返す | 有効 | `test/core/services/preferences_service_test.dart` |
| T-1.1.2 | インスタンスメソッド > T-P.2: setString/getStringで文字列を保存・取得できる | 有効 | `test/core/services/preferences_service_test.dart` |
| T-1.1.3 | インスタンスメソッド > T-P.3: setBool/getBoolで真偽値を保存・取得できる | 有効 | `test/core/services/preferences_service_test.dart` |
| T-1.1.4 | インスタンスメソッド > T-P.4: setInt/getIntで整数を保存・取得できる | 有効 | `test/core/services/preferences_service_test.dart` |
| T-1.1.5 | インスタンスメソッド > T-P.5: containsKeyで存在確認ができる | 有効 | `test/core/services/preferences_service_test.dart` |
| T-1.1.6 | インスタンスメソッド > T-P.6: removeでキーを削除できる | 有効 | `test/core/services/preferences_service_test.dart` |
| T-1.1.7 | インスタンスメソッド > T-P.7: clearで全キーを削除できる | 有効 | `test/core/services/preferences_service_test.dart` |

### 1.2 Model（`test/models/`）

3 ファイル / 13 有効ケース

| ID | テストケース | 状態 | ファイル |
|---|---|---|---|
| T-1.2.1 | GeneratorSettings > T-4.1: デフォルト値がドキュメント通り | 有効 | `test/models/generator_settings_test.dart` |
| T-1.2.2 | GeneratorSettings > 対象28記号がすべて含まれている | 有効 | `test/models/generator_settings_test.dart` |
| T-1.2.3 | GeneratorSettings > fromJson / toJson が正しく動作する | 有効 | `test/models/generator_settings_test.dart` |
| T-1.2.4 | GeneratorSettings > customSymbols の fromJson / toJson が正しく動作する | 有効 | `test/models/generator_settings_test.dart` |
| T-1.2.5 | GeneratorSettings > copyWith で値を変更できる | 有効 | `test/models/generator_settings_test.dart` |
| T-1.2.6 | PasswordStrength > 必須フィールドで生成できる | 有効 | `test/models/password_strength_test.dart` |
| T-1.2.7 | PasswordStrength > fromJson / toJson が存在しない（メモリのみ） | 有効 | `test/models/password_strength_test.dart` |
| T-1.2.8 | PasswordStrength > copyWith で値を変更できる | 有効 | `test/models/password_strength_test.dart` |
| T-1.2.9 | StrengthLevel > 4つのレベルが定義されている | 有効 | `test/models/password_strength_test.dart` |
| T-1.2.10 | User > デフォルト値で生成できる | 有効 | `test/models/user_test.dart` |
| T-1.2.11 | User > fromJson / toJson が正しく動作する | 有効 | `test/models/user_test.dart` |
| T-1.2.12 | User > toJson の出力が期待通りのキーを含む | 有効 | `test/models/user_test.dart` |
| T-1.2.13 | User > copyWith で値を変更できる | 有効 | `test/models/user_test.dart` |

### 1.3 Routing（`test/routing/`）

1 ファイル / 5 有効ケース

| ID | テストケース | 状態 | ファイル |
|---|---|---|---|
| T-1.3.1 | AnalyticsRouteObserver > クラスが正しくインスタンス化できる | 有効 | `test/routing/analytics_route_observer_test.dart` |
| T-1.3.2 | AnalyticsRouteObserver ロジック > didPush は画面名を logScreenView に渡す | 有効 | `test/routing/analytics_route_observer_test.dart` |
| T-1.3.3 | AnalyticsRouteObserver ロジック > didPop は前の画面名を logScreenView に渡す | 有効 | `test/routing/analytics_route_observer_test.dart` |
| T-1.3.4 | AnalyticsRouteObserver ロジック > didReplace は新しい画面名を logScreenView に渡す | 有効 | `test/routing/analytics_route_observer_test.dart` |
| T-1.3.5 | AnalyticsRouteObserver ロジック > 画面名が null の場合は logScreenView を呼ばない | 有効 | `test/routing/analytics_route_observer_test.dart` |

### 1.4 Service（`test/services/`）

4 ファイル / 31 有効ケース

| ID | テストケース | 状態 | ファイル |
|---|---|---|---|
| T-1.4.1 | パスワード生成エンジン（F-01） > T-1.1: デフォルト設定（16文字、全文字種ON）で生成する | 有効 | `test/services/password_generator_service_test.dart` |
| T-1.4.2 | パスワード生成エンジン（F-01） > T-1.2: 文字数を4、全文字種ONで生成する | 有効 | `test/services/password_generator_service_test.dart` |
| T-1.4.3 | パスワード生成エンジン（F-01） > T-1.3: 文字数を128で生成する | 有効 | `test/services/password_generator_service_test.dart` |
| T-1.4.4 | パスワード生成エンジン（F-01） > T-1.4: 大文字のみONで生成する | 有効 | `test/services/password_generator_service_test.dart` |
| T-1.4.5 | パスワード生成エンジン（F-01） > T-1.5: 最後の1つの文字種をOFFにしようとする | 有効 | `test/services/password_generator_service_test.dart` |
| T-1.4.6 | パスワード生成エンジン（F-01） > T-1.5 補足: 複数ONの場合はOFFにできる | 有効 | `test/services/password_generator_service_test.dart` |
| T-1.4.7 | パスワード生成エンジン（F-01） > T-1.6: 同じ設定で2回生成する | 有効 | `test/services/password_generator_service_test.dart` |
| T-1.4.8 | 紛らわしい文字の除外（F-02） > T-2.1: 除外ONで生成する（全文字種ON、十分な文字数） | 有効 | `test/services/password_generator_service_test.dart` |
| T-1.4.9 | 紛らわしい文字の除外（F-02） > T-2.2: 除外ON + 数字のみONで生成する | 有効 | `test/services/password_generator_service_test.dart` |
| T-1.4.10 | 特殊文字のカスタム選択（F-03） > T-3.1: ! @ # の3記号のみONにして記号トグルONで生成する | 有効 | `test/services/password_generator_service_test.dart` |
| T-1.4.11 | 特殊文字のカスタム選択（F-03） > T-3.2: 全記号OFFの状態で生成しようとする | 有効 | `test/services/password_generator_service_test.dart` |
| T-1.4.12 | エッジケース > 小文字のみONで生成する | 有効 | `test/services/password_generator_service_test.dart` |
| T-1.4.13 | エッジケース > 数字のみONで生成する | 有効 | `test/services/password_generator_service_test.dart` |
| T-1.4.14 | 強度レベル判定 > T-7.1: エントロピーが 27 bit → weak | 有効 | `test/services/password_strength_service_test.dart` |
| T-1.4.15 | 強度レベル判定 > T-7.2: エントロピーが 28 bit → fair | 有効 | `test/services/password_strength_service_test.dart` |
| T-1.4.16 | 強度レベル判定 > T-7.3: エントロピーが 36 bit → strong | 有効 | `test/services/password_strength_service_test.dart` |
| T-1.4.17 | 強度レベル判定 > T-7.4: エントロピーが 60 bit → veryStrong | 有効 | `test/services/password_strength_service_test.dart` |
| T-1.4.18 | 強度レベル判定 > T-7.5: デフォルト設定（16文字、全文字種ON）のエントロピー | 有効 | `test/services/password_strength_service_test.dart` |
| T-1.4.19 | 解読推定時間の表示 > T-7.6: 60 bit のエントロピーの解読推定時間 | 有効 | `test/services/password_strength_service_test.dart` |
| T-1.4.20 | 解読推定時間の表示 > 1秒未満の場合 | 有効 | `test/services/password_strength_service_test.dart` |
| T-1.4.21 | 解読推定時間の表示 > 秒単位の場合 | 有効 | `test/services/password_strength_service_test.dart` |
| T-1.4.22 | 解読推定時間の表示 > 日本語大数表記が使用される | 有効 | `test/services/password_strength_service_test.dart` |
| T-1.4.23 | エントロピー計算 > 大文字のみ（26文字）、8文字 | 有効 | `test/services/password_strength_service_test.dart` |
| T-1.4.24 | エントロピー計算 > 除外ONでプールサイズが減少する | 有効 | `test/services/password_strength_service_test.dart` |
| T-1.4.25 | T-4.1: 初回起動時のデフォルト設定 > settingsドキュメントが存在しない場合、デフォルト値で作成される | 有効 | `test/services/settings_service_test.dart` |
| T-1.4.26 | T-4.2: 設定の即時保存 > 設定を変更するとFirestoreに即時保存される | 有効 | `test/services/settings_service_test.dart` |
| T-1.4.27 | T-4.3: 保存済み設定の復元 > 保存時の設定値が正しく復元される | 有効 | `test/services/settings_service_test.dart` |
| T-1.4.28 | T-11.1: 初回起動フロー > usersドキュメントが存在しない場合、デフォルト値で作成される | 有効 | `test/services/user_service_test.dart` |
| T-1.4.29 | T-11.2: 2回目以降の起動 > usersドキュメントが存在する場合、読み取りできる | 有効 | `test/services/user_service_test.dart` |
| T-1.4.30 | generationCount のインクリメント > generationCount が正しくインクリメントされる | 有効 | `test/services/user_service_test.dart` |
| T-1.4.31 | reviewPromptShown の更新 > reviewPromptShown が true に更新される | 有効 | `test/services/user_service_test.dart` |

### 1.5 開発ツール（`test/tool/`）

1 ファイル / 5 有効ケース

| ID | テストケース | 状態 | ファイル |
|---|---|---|---|
| T-1.5.1 | generatePng > 1024x1024のPNGバイナリを生成する | 有効 | `test/tool/generate_placeholder_icon_test.dart` |
| T-1.5.2 | generatePng > IHDRチャンクに正しい画像サイズが含まれる | 有効 | `test/tool/generate_placeholder_icon_test.dart` |
| T-1.5.3 | generatePng > 異なるサイズで生成できる | 有効 | `test/tool/generate_placeholder_icon_test.dart` |
| T-1.5.4 | saveIcon > 指定パスにPNGファイルを保存する | 有効 | `test/tool/generate_placeholder_icon_test.dart` |
| T-1.5.5 | saveIcon > 親ディレクトリが存在しない場合でも作成して保存する | 有効 | `test/tool/generate_placeholder_icon_test.dart` |

### 1.6 ViewModel（`test/viewmodels/`）

4 ファイル / 22 有効ケース

| ID | テストケース | 状態 | ファイル |
|---|---|---|---|
| T-1.6.1 | T-6.1: 候補リスト生成 > 5件の候補が生成される | 有効 | `test/viewmodels/copy_and_candidates_test.dart` |
| T-1.6.2 | T-6.2: メインの生成で候補も再生成される > generate() でメインパスワードと候補がすべて再生成される | 有効 | `test/viewmodels/copy_and_candidates_test.dart` |
| T-1.6.3 | 候補の再生成 > regenerateCandidates() で候補のみ再生成される | 有効 | `test/viewmodels/copy_and_candidates_test.dart` |
| T-1.6.4 | T-11.3: 設定復元後にパスワード自動生成 > 初期ビルド時にデフォルト設定でパスワードが自動生成される | 有効 | `test/viewmodels/password_generator_viewmodel_test.dart` |
| T-1.6.5 | 生成ボタン > generate() で新しいパスワードが生成される | 有効 | `test/viewmodels/password_generator_viewmodel_test.dart` |
| T-1.6.6 | 設定変更 > 文字数変更で設定が保存されパスワードが再生成される | 有効 | `test/viewmodels/password_generator_viewmodel_test.dart` |
| T-1.6.7 | 設定変更 > 大文字トグルOFFで設定が更新される | 有効 | `test/viewmodels/password_generator_viewmodel_test.dart` |
| T-1.6.8 | 設定変更 > 小文字トグルOFFで設定が更新される | 有効 | `test/viewmodels/password_generator_viewmodel_test.dart` |
| T-1.6.9 | 設定変更 > 数字トグルOFFで設定が更新される | 有効 | `test/viewmodels/password_generator_viewmodel_test.dart` |
| T-1.6.10 | 設定変更 > 記号トグルOFFで設定が更新される | 有効 | `test/viewmodels/password_generator_viewmodel_test.dart` |
| T-1.6.11 | 設定変更 > 最後の文字種はOFFにできない（T-1.5） | 有効 | `test/viewmodels/password_generator_viewmodel_test.dart` |
| T-1.6.12 | 設定変更 > 紛らわしい文字除外トグルで設定が更新される | 有効 | `test/viewmodels/password_generator_viewmodel_test.dart` |
| T-1.6.13 | 強度計算 > 生成のたびに強度が更新される | 有効 | `test/viewmodels/password_generator_viewmodel_test.dart` |
| T-1.6.14 | T-10.1: レビュー依頼表示条件（generationCount=3, reviewPromptShown=false） > shouldShowReviewPrompt が true を返す | 有効 | `test/viewmodels/review_prompt_test.dart` |
| T-1.6.15 | T-10.2: レビュー依頼非表示（generationCount=3, reviewPromptShown=true） > shouldShowReviewPrompt が false を返す | 有効 | `test/viewmodels/review_prompt_test.dart` |
| T-1.6.16 | T-10.3: レビュー依頼非表示（generationCount=2） > shouldShowReviewPrompt が false を返す | 有効 | `test/viewmodels/review_prompt_test.dart` |
| T-1.6.17 | 生成時の generationCount インクリメント > generate() で generationCount が増加する | 有効 | `test/viewmodels/review_prompt_test.dart` |
| T-1.6.18 | UserSettingsViewModel.build > T-U.1: settingsドキュメントが存在しない場合、デフォルト値を返す | 有効 | `test/viewmodels/user_settings_viewmodel_test.dart` |
| T-1.6.19 | UserSettingsViewModel.build > T-U.2: 保存済みドキュメントがある場合、その値を復元する | 有効 | `test/viewmodels/user_settings_viewmodel_test.dart` |
| T-1.6.20 | UserSettingsViewModel 更新系メソッド > T-U.3: updateNotificationEnabledでFirestoreに即時反映される | 有効 | `test/viewmodels/user_settings_viewmodel_test.dart` |
| T-1.6.21 | UserSettingsViewModel 更新系メソッド > T-U.4: saveSettingsで一括保存され、再読み込みで反映される | 有効 | `test/viewmodels/user_settings_viewmodel_test.dart` |
| T-1.6.22 | userSettingsStreamProvider > T-U.5: Firestoreの変更がストリーム経由で流れる | 有効 | `test/viewmodels/user_settings_viewmodel_test.dart` |

## 2. Widget Test

### 2.1 ViewModel（`test/viewmodels/`）

1 ファイル / 4 有効ケース

| ID | テストケース | 状態 | ファイル |
|---|---|---|---|
| T-2.1.1 | T-3.3: すべて選択 > 全28記号がチップとして表示される | 有効 | `test/viewmodels/symbol_selection_test.dart` |
| T-2.1.2 | T-3.3: すべて選択 > 「すべて解除」→「すべて選択」でチップが切り替わる | 有効 | `test/viewmodels/symbol_selection_test.dart` |
| T-2.1.3 | T-3.4: すべて解除 > すべて解除後に「完了」でエラーが表示される | 有効 | `test/viewmodels/symbol_selection_test.dart` |
| T-2.1.4 | T-3.2: バリデーション > 個別記号のタップでON/OFFが切り替わる | 有効 | `test/viewmodels/symbol_selection_test.dart` |

### 2.2 画面（`test/views/screens/`）

1 ファイル / 2 有効ケース

| ID | テストケース | 状態 | ファイル |
|---|---|---|---|
| T-2.2.1 | T-S.1: デフォルト設定（未保存状態）で各項目が表示される | 有効 | `test/views/screens/settings_test_screen_test.dart` |
| T-2.2.2 | T-S.2: 保存ボタンを押すとFirestoreに反映されトーストが表示される | 有効 | `test/views/screens/settings_test_screen_test.dart` |

### 2.3 ルート（`test/`）

1 ファイル / 1 有効ケース

| ID | テストケース | 状態 | ファイル |
|---|---|---|---|
| T-2.3.1 | HomeScreen displays correctly | 有効 | `test/widget_test.dart` |

## 3. Integration Test

### 3.1 integration_test（`integration_test/`）

1 ファイル / 1 有効ケース

| ID | テストケース | 状態 | ファイル |
|---|---|---|---|
| T-3.1.1 | T-Int.1: 匿名認証ユーザーの設定変更がFirestoreに永続化され、次回のViewModel再構築時に復元される | 有効 | `integration_test/anonymous_auth_settings_sync_flow_test.dart` |

- 複数機能連携の有無: **あり（軽度）**。判断根拠 — `pubspec.yaml` に Firebase Auth / Cloud Firestore があり、「匿名認証 → Firestore 上のユーザー設定の読み書き」という外部サービスをまたぐ動線が実在するため。新規の Integration Test は `PasswordGeneratorViewModel.build()` の匿名認証→Firestore 設定同期を検証している（AuthService/AnalyticsService はフェイク、設定サービスは `fake_cloud_firestore` 注入で本番 Firestore 不使用、UI 画面は経由せず `ProviderContainer` で駆動）。

## 4. E2E Test (Maestro)

**実装なし**（`.maestro/` ディレクトリ自体が存在しない（クリティカルフロー非該当のため作成せず））。

## 5. テスト設計準拠チェック

判定記号: ✅ 充足 / ⚠️ 要確認・部分的 / ❌ 未充足

### 5.1 Unit Test

| 項目 | 内容 |
|---|---|
| 必須条件 | ロジック層がある限り必須（正本 3.1） |
| 母集団の定義 | `lib/` 配下で、ディレクトリが `models` / `viewmodels` / `services` / `repositories` / `usecases` のいずれか、またはファイル名が `*_model.dart` / `*_viewmodel.dart` / `*_service.dart` / `*_repository.dart` / `*_usecase.dart`。生成物（`*.g.dart` / `*.freezed.dart` / `*.gr.dart`）と `lib/backup/` は除外 |
| 現状 | ロジック 15 ファイル中、同名の `*_test.dart` に機械マッチしたのは **10**。有効ケース 83 件 |
| 判定 | ✅ ロジック層に Unit テストが実装されている（有効 83 件）。Phase B で `user_settings_viewmodel` / `preferences_service` の Unit テストを追加。下記5ファイルは機械マッチせず**対応不明**（うち3ファイルは別名テストから参照あり） |

対応不明（5ファイル）:

- `lib/core/services/analytics_service.dart`
- `lib/core/services/auth_service.dart`
- `lib/core/services/crashlytics_service.dart`
- `lib/core/services/firestore_service.dart`
- `lib/models/user_settings.dart`

> 補足: `analytics_service.dart` / `auth_service.dart` / `firestore_service.dart` は ViewModel 側のテストから参照されており、モック経由で間接的に検証されている。残る `crashlytics_service.dart` はどのテストからも参照されておらず、`FirebaseCrashlytics.instance` を直接使う具象クラスで注入口が無いため、lib/ 変更なしにはテストできないと Phase B で判断されている（下記ギャップ）。

### 5.2 Widget Test

| 項目 | 内容 |
|---|---|
| 必須条件 | 画面がある限り必須（正本 3.1） |
| 母集団の定義 | `lib/` 配下の `*_screen.dart` / `*_page.dart` / `*_view.dart`、および `screens/` / `pages/` 配下の画面 Widget。生成物・`lib/backup/`・パスに `debug` / `dev` を含む開発用画面は除外 |
| 現状 | 画面 5 中、同名の `*_test.dart` に機械マッチしたのは **1**。有効ケース 7 件 |
| 判定 | ⚠️ Phase B で `settings_test_screen` の Widget テストを追加。残る4画面のうち `home_screen` は `test/widget_test.dart`、`symbol_selection_screen` は `test/viewmodels/symbol_selection_test.dart` から参照されており実質カバーの可能性が高いが、`app_info_screen` / `customize_sheet` は未着手 |

対応不明（4画面）:

- `lib/views/screens/app_info_screen.dart` — どのテストからも参照されていない。着手時に存在した大規模な進行中 dev 変更（lib/ を含む53ファイル）の影響を避けるため Phase B では未着手
- `lib/views/screens/customize_sheet.dart` — どのテストからも参照されていない（同上）
- `lib/views/screens/home_screen.dart` — `test/widget_test.dart` から参照されるが、テスト名が画面名と揃っておらず機械判定できない
- `lib/views/screens/symbol_selection_screen.dart` — `test/viewmodels/symbol_selection_test.dart` から参照されるが、同様に機械判定できない

### 5.3 Integration Test

| 項目 | 内容 |
|---|---|
| 必須条件 | 複数機能の連携がある場合は必須（正本 3.2） |
| 現状 | 1 ファイル / 1 ケース実装済み・実機 green（Phase B で `integration_test/` を新設）。`anonymous_auth_settings_sync_flow_test.dart` |
| 判定 | ✅ 匿名認証 → Firestore 設定同期という連携を検証する Integration Test が新規作成され実機 green（1 ケース）。連携範囲は限定的だが層としては充足 |

### 5.4 E2E Test (Maestro)

| 項目 | 内容 |
|---|---|
| 必須条件 | クリティカルフロー（金銭喪失 / 復元不能なデータ喪失 / 法務・審査影響）がある場合は必須（正本 3.3） |
| 現状 | 実装なし（`.maestro/` が存在しない） |
| 判定 | ✅ 正本 3.3 の基準に照らしてクリティカルフローに該当する機能が無く、E2E は不要 |

クリティカルフローの該当状況:

| フロー | 該当 | E2E |
|---|---|---|
| 課金 | ❌ 非該当 | `purchases_flutter` 等の課金 SDK を導入していない |
| 認証 | 匿名認証のみ（`signInAnonymously`） | 仕様 5.4 により「認証E2E必須」には該当させない。ログイン画面・実アカウントは存在しない |
| 初回起動・オンボーディング | ❌ 非該当 | オンボーディング画面・利用規約同意フローが存在しない |
| 復元不能なデータ削除 | ❌ 非該当 | 退会・アカウント削除・一括削除機能が存在しない |
| お問い合わせ送信 | ❌ 非該当 | `app_info_screen` から `url_launcher` で外部フォームを開くのみ（アプリ内送信ではない） |

### ギャップ一覧

1. **大規模な進行中 dev 変更（lib/ を含む53ファイル）が着手時から未コミットで存在** — このため `app_info_screen` / `customize_sheet` / `home_screen` / `symbol_selection_screen` の Widget テスト追加は、その dev 作業のマージ後に行うべきと判断し見送られた（オーケストレーター・発注者への報告事項）（5.2）
2. **`crashlytics_service.dart` が lib/ 変更なしにはテストできない** — `FirebaseCrashlytics.instance` を直接使う具象クラスで注入口が無く、`mocktail`/`mockito` も未導入。インターフェース抽出等の lib/ 変更が必要（5.1）
3. **`app_info_screen` / `customize_sheet` の Widget テストが無い** — 上記 dev 変更の影響を避けるため未着手（5.2）
