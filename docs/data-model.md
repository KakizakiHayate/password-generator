# データモデル設計

> **対象フェーズ: フェーズ1（MVP）のみ**

---

## Firestore データ構造

2つのトップレベルコレクションで構成する。関心の分離として「ユーザー自体のデータ」と「ユーザーの設定」を別コレクションに分ける。

```
users/                                  # ユーザーエンティティ
  {userId}
    createdAt: Timestamp                  # アカウント作成日時
    generationCount: int                  # 累計パスワード生成回数
    reviewPromptShown: bool               # レビュー依頼表示済みフラグ

settings/                               # 設定エンティティ
  {userId}
    length: int                           # 文字数（4〜128）
    useUppercase: bool                    # 大文字トグル
    useLowercase: bool                    # 小文字トグル
    useNumbers: bool                      # 数字トグル
    useSymbols: bool                      # 記号トグル
    excludeAmbiguous: bool                # 紛らわしい文字の除外
    customSymbols: Map<String, bool>      # 各記号のON/OFF
```

### コレクション設計の根拠

| 判断基準 | users | settings |
|---------|-------|----------|
| **概念** | ユーザー自体の状態 | ユーザーの設定・プリファレンス |
| **更新タイミング** | パスワード生成時（generationCount++） | 設定変更時（即時保存） |
| **将来の拡張** | ユーザープロファイル情報等 | テーマ、通知設定等 |

### ドキュメント ID

両コレクションとも **Firebase Auth の匿名認証で発行される `userId`** をドキュメント ID として使用する。`users/{userId}` と `settings/{userId}` は同一ユーザーを指す。

---

## データモデル（Freezed）

### User

ユーザーエンティティ。アプリの内部状態を保持する。

| フィールド | 型 | デフォルト | 説明 |
|-----------|-----|----------|------|
| `createdAt` | `DateTime` | 初回起動時の現在時刻 | アカウント作成日時 |
| `generationCount` | `int` | 0 | 累計パスワード生成回数。F-10（レビュー依頼）の判定に使用 |
| `reviewPromptShown` | `bool` | false | レビュー依頼を表示済みか。true の場合は再表示しない |

**ファイル**: `lib/models/user.dart`

```dart
@freezed
class User with _$User {
  const factory User({
    required DateTime createdAt,
    @Default(0) int generationCount,
    @Default(false) bool reviewPromptShown,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

---

### GeneratorSettings

設定エンティティ。ユーザーが操作するすべての生成設定を保持する。

| フィールド | 型 | デフォルト | 説明 |
|-----------|-----|----------|------|
| `length` | `int` | 16 | パスワード文字数（範囲: 4〜128） |
| `useUppercase` | `bool` | true | 大文字 (A-Z) を含む |
| `useLowercase` | `bool` | true | 小文字 (a-z) を含む |
| `useNumbers` | `bool` | true | 数字 (0-9) を含む |
| `useSymbols` | `bool` | true | 記号を含む |
| `excludeAmbiguous` | `bool` | false | 紛らわしい文字（oO0, lI1 等）を除外する |
| `customSymbols` | `Map<String, bool>` | 全て true | 各記号の ON/OFF 状態 |

**ファイル**: `lib/models/generator_settings.dart`

```dart
@freezed
class GeneratorSettings with _$GeneratorSettings {
  const factory GeneratorSettings({
    @Default(16) int length,
    @Default(true) bool useUppercase,
    @Default(true) bool useLowercase,
    @Default(true) bool useNumbers,
    @Default(true) bool useSymbols,
    @Default(false) bool excludeAmbiguous,
    @Default(_defaultCustomSymbols) Map<String, bool> customSymbols,
  }) = _GeneratorSettings;

  factory GeneratorSettings.fromJson(Map<String, dynamic> json) =>
      _$GeneratorSettingsFromJson(json);
}
```

---

### PasswordStrength（メモリのみ・永続化なし）

パスワード強度の計算結果。Firestore には保存せず、生成のたびに算出する。

| フィールド | 型 | 説明 |
|-----------|-----|------|
| `level` | `StrengthLevel` | 強度レベル（弱い / 普通 / 強い / 非常に強い）。閾値: < 28bit: weak / 28〜35bit: fair / 36〜59bit: strong / 60bit〜: veryStrong |
| `entropy` | `double` | エントロピー（ビット数） |
| `crackTimeDisplay` | `String` | 解読推定時間の表示テキスト。攻撃速度の前提: 10億回/秒（1×10⁹） |

**ファイル**: `lib/models/password_strength.dart`

```dart
/// 強度レベルの閾値（エントロピー基準）:
/// - weak:       < 28 bit
/// - fair:       28〜35 bit
/// - strong:     36〜59 bit
/// - veryStrong: 60 bit〜
///
/// 解読推定時間の攻撃速度前提: 10億回/秒（1×10⁹）
enum StrengthLevel { weak, fair, strong, veryStrong }

@freezed
class PasswordStrength with _$PasswordStrength {
  const factory PasswordStrength({
    required StrengthLevel level,
    required double entropy,
    required String crackTimeDisplay,
  }) = _PasswordStrength;
}
```

---

## CRUD

### users コレクション

| 操作 | タイミング | メソッド | 説明 |
|------|----------|---------|------|
| **作成** | 初回起動時（匿名認証後） | `setDocument` | `createdAt` に現在時刻を設定し、デフォルト値で作成 |
| **読取** | パスワード生成時 | `getDocument` | `generationCount` を取得してレビュー依頼の判定に使用 |
| **更新** | パスワード生成時 | `updateDocument` | `generationCount` をインクリメント。レビュー表示後に `reviewPromptShown` を true に更新 |
| **削除** | MVPでは不要 | — | — |

### settings コレクション

| 操作 | タイミング | メソッド | 説明 |
|------|----------|---------|------|
| **作成** | 初回起動時 | `setDocument` | 全フィールドをデフォルト値で作成 |
| **読取** | アプリ起動時 | `getDocument` | 保存済みの設定を復元し、その設定でパスワードを自動生成する |
| **更新** | 設定変更時（即時） | `updateDocument` | 変更されたフィールドのみ更新（保存ボタン不要） |
| **削除** | MVPでは不要 | — | — |

---

## 初回起動時のフロー

```
1. Firebase 匿名認証 → userId 取得
2. users/{userId} ドキュメントの存在確認
   ├─ 存在しない（初回起動）
   │   ├─ users/{userId} をデフォルト値で作成
   │   └─ settings/{userId} をデフォルト値で作成
   └─ 存在する（2回目以降）
       └─ settings/{userId} を読み取り → 設定復元
3. 復元した設定（または初回デフォルト値）でパスワードを自動生成
```

---

## Firestore セキュリティルール（参考）

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // ユーザーデータ: 本人のみ読み書き可能
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // 設定データ: 本人のみ読み書き可能
    match /settings/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```
