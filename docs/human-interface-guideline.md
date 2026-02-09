# Human Interface Guidelines (iOS)

本プロジェクトは Apple Human Interface Guidelines に準拠した Cupertino ベースの UI を採用する。

## 使用するウィジェット

Material ウィジェットではなく、Cupertino ウィジェットを優先する。

| 用途 | Cupertino（使う） | Material（使わない） |
|------|-------------------|---------------------|
| アプリルート | `CupertinoApp` | `MaterialApp` |
| テーマ | `CupertinoThemeData` | `ThemeData` |
| 画面構造 | `CupertinoPageScaffold` | `Scaffold` |
| ナビゲーションバー | `CupertinoNavigationBar` | `AppBar` |
| タブバー | `CupertinoTabBar` | `BottomNavigationBar` |
| ボタン | `CupertinoButton` | `ElevatedButton` |
| テキスト入力 | `CupertinoTextField` | `TextField` |
| スイッチ | `CupertinoSwitch` | `Switch` |
| セグメント | `CupertinoSlidingSegmentedControl` | `SegmentedButton` |
| ダイアログ | `CupertinoAlertDialog` | `AlertDialog` |
| アクションシート | `CupertinoActionSheet` | `BottomSheet` |
| ローディング | `CupertinoActivityIndicator` | `CircularProgressIndicator` |
| ページ遷移 | `CupertinoPageRoute` | `MaterialPageRoute` |

## 設計指針

- **明瞭性**: コンテンツが主役。UI は情報を引き立てる
- **従順性**: UI はコンテンツを補助するが、主張しすぎない
- **奥行き**: 階層構造を使い、コンテキストを提供する

## アイコン

`CupertinoIcons` を使用する（`Icons` ではなく）。

```dart
Icon(CupertinoIcons.settings)  // OK
Icon(Icons.settings)            // NG
```
