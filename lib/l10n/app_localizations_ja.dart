// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'パスワードジェネレーター';

  @override
  String get strengthWeak => '弱い';

  @override
  String get strengthFair => '普通';

  @override
  String get strengthStrong => '強い';

  @override
  String get strengthVeryStrong => '非常に強い';

  @override
  String get crackTimePrefix => '解読推定:';

  @override
  String get characterCount => '文字数';

  @override
  String get uppercaseLabel => '大文字(A-Z)';

  @override
  String get lowercaseLabel => '小文字(a-z)';

  @override
  String get numbersLabel => '数字(0-9)';

  @override
  String get symbolsLabel => '記号';

  @override
  String get excludeAmbiguousLabel => '紛らわしい文字を除外';

  @override
  String get customizeSymbolsLabel => '記号をカスタム選択';

  @override
  String get generateButton => '生成する';

  @override
  String get symbolSelectionTitle => '記号の選択';

  @override
  String get doneButton => '完了';

  @override
  String get selectAllSymbols => 'すべて選択';

  @override
  String get deselectAllSymbols => 'すべて解除';

  @override
  String get symbolSelectionError => '記号を1つ以上選択してください';

  @override
  String get copiedMessage => 'コピーしました';

  @override
  String get copyButton => 'コピー';

  @override
  String get viewOtherCandidates => '他の候補を見る';

  @override
  String get regenerateCandidates => '候補を再生成';

  @override
  String get appInfoTitle => '情報';

  @override
  String get aboutApp => 'アプリについて';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get homeGreeting => 'Hello Starter Kit';

  @override
  String get firestoreTestButton => 'Firestore動作テスト';

  @override
  String get settingsTestTitle => 'Firestore動作テスト';

  @override
  String get settingsTestDescription => 'Firestore動作確認';

  @override
  String get settingsTestGuide =>
      '設定を変更して「保存」ボタンを押すと、Firestoreに保存されます。\nアプリを再起動しても設定が保持されることを確認できます。';

  @override
  String get firestoreCurrentValues => 'Firestoreの現在値（リアルタイム）';

  @override
  String get labelDisplayName => '表示名';

  @override
  String get labelNotification => '通知';

  @override
  String get labelDarkMode => 'ダークモード';

  @override
  String get labelLanguage => '言語';

  @override
  String get labelDocumentId => 'ドキュメントID';

  @override
  String get on => 'ON';

  @override
  String get off => 'OFF';

  @override
  String get editSettings => '設定を変更';

  @override
  String get placeholderDisplayName => '表示名を入力してください';

  @override
  String get switchNotification => '通知を有効にする';

  @override
  String get switchDarkMode => 'ダークモードを有効にする';

  @override
  String get languageJa => '日本語';

  @override
  String get languageEn => 'English';

  @override
  String get saveToFirestore => 'Firestoreに保存';

  @override
  String get individualUpdateTest => '個別更新テスト';

  @override
  String get toggleNotification => '通知トグル';

  @override
  String get toggleDarkMode => 'ダークモードトグル';

  @override
  String get savedToFirestore => 'Firestoreに保存しました';

  @override
  String saveError(String error) {
    return '保存エラー: $error';
  }

  @override
  String get notificationUpdated => '通知設定を更新しました';

  @override
  String get darkModeUpdated => 'ダークモード設定を更新しました';

  @override
  String errorMessage(String error) {
    return 'エラー: $error';
  }

  @override
  String get reload => '再読み込み';
}
