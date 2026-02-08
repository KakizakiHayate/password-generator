# Fastlane セットアップ手順

## 前提条件

- Apple Developer Program に加入済み
- Xcode がインストール済み
- Ruby 3.x がインストール済み

## 1. Fastlane のインストール

```bash
cd ios
bundle install
```

## 2. 認証情報の設定（.env ファイル）

認証情報はリポジトリにコミットせず、`.env` ファイルで管理する。

```bash
cd ios/fastlane
cp .env.example .env
```

`.env` を開き、実際の値を入力する：

```bash
APP_IDENTIFIER=com.yourcompany.yourapp       # Bundle ID
APPLE_ID=your@email.com                      # Apple ID
TEAM_ID=XXXXXXXXXX                           # Apple Developer Team ID
ITC_TEAM_ID=XXXXXXXXXX                       # App Store Connect Team ID
MATCH_GIT_URL=https://github.com/your-username/certificates.git
MATCH_PASSWORD=your-match-passphrase         # 初回match実行時に設定
FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD=xxxx-xxxx-xxxx-xxxx  # account.apple.com で生成

# App Store審査チームへの連絡先（releaseレーン使用時に必要）
REVIEW_FIRST_NAME=Your First Name
REVIEW_LAST_NAME=Your Last Name
REVIEW_PHONE_NUMBER=+81 9000000000
REVIEW_EMAIL=your@email.com
REVIEW_NOTES=
```

### アプリ用パスワードの生成方法

`fastlane release` でのIPAアップロードに必要。

1. [account.apple.com](https://account.apple.com) にログイン
2. 「サインインとセキュリティ」→「アプリ用パスワード」
3. 「+」でパスワードを生成（名前は「fastlane」など任意）
4. 生成されたパスワードを `.env` の `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` に設定

> `.env` は `.gitignore` に含まれているため、リポジトリにはコミットされません。

### Team ID の確認方法

1. [Apple Developer](https://developer.apple.com/account) にログイン
2. Membership の画面で Team ID を確認

### App Store Connect Team ID の確認方法

App Store Connect > ユーザーとアクセス で確認

## 3. Fastlane Match のセットアップ（証明書管理）

### 3.1 証明書管理用のプライベートリポジトリを作成

```bash
gh repo create certificates --private
```

作成後、`.env` の `MATCH_GIT_URL` にリポジトリのURLを設定する。

### 3.2 証明書の初回生成

```bash
cd ios
bundle exec fastlane match appstore
```

初回実行時に以下を聞かれる：

- **Passphrase**: 証明書を暗号化するパスワード（`.env` の `MATCH_PASSWORD` に控えておくこと）

## 4. メタデータの設定

`ios/fastlane/metadata/` 配下のファイルを編集する：

```
ios/fastlane/metadata/
├── ja/
│   ├── name.txt           # アプリ名（日本語）
│   ├── description.txt    # 説明文
│   ├── keywords.txt       # キーワード（カンマ区切り）
│   ├── release_notes.txt  # リリースノート
│   ├── privacy_url.txt    # プライバシーポリシーURL
│   └── support_url.txt    # サポートURL
└── en-US/
    ├── name.txt           # アプリ名（英語）
    ├── description.txt
    ├── keywords.txt
    ├── release_notes.txt
    ├── privacy_url.txt
    └── support_url.txt
```

> 審査チームへの連絡先情報は個人情報のため、`.env` ファイルで管理する（`REVIEW_*` 項目）。

## 5. ローカルでの実行

### TestFlight 配信

```bash
cd ios
bundle exec fastlane beta
```

### App Store Connect アップロード（審査提出は手動）

```bash
cd ios
bundle exec fastlane release
```

実行後、App Store Connect で確認し、手動で「審査に提出」を行う。

## 6. テンプレートから新規プロジェクトを作成した場合

このテンプレートをクローンして新しいアプリを作成する際、以下のファイルを変更する必要がある。

### 必ず変更するもの

| ファイル | 変更内容 |
|---------|---------|
| `ios/fastlane/.env` | `.env.example` をコピーし、自分のアプリの認証情報を入力 |
| `ios/fastlane/metadata/ja/name.txt` | アプリ名（日本語） |
| `ios/fastlane/metadata/en-US/name.txt` | アプリ名（英語） |
| `ios/fastlane/metadata/ja/description.txt` | アプリ説明文（日本語） |
| `ios/fastlane/metadata/en-US/description.txt` | アプリ説明文（英語） |
| `ios/fastlane/metadata/ja/keywords.txt` | 検索キーワード（日本語） |
| `ios/fastlane/metadata/en-US/keywords.txt` | 検索キーワード（英語） |
| `ios/fastlane/metadata/*/privacy_url.txt` | プライバシーポリシーURL |
| `ios/fastlane/metadata/*/support_url.txt` | サポートURL |

### リリースごとに変更するもの

| ファイル | 変更内容 |
|---------|---------|
| `pubspec.yaml` | `version: x.y.z+n`（バージョン番号とビルド番号） |
| `ios/fastlane/metadata/*/release_notes.txt` | リリースノート |
