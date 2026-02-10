import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ja, this message translates to:
  /// **'Flutter Starter Kit'**
  String get appTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In ja, this message translates to:
  /// **'Hello Starter Kit'**
  String get homeGreeting;

  /// No description provided for @firestoreTestButton.
  ///
  /// In ja, this message translates to:
  /// **'Firestore動作テスト'**
  String get firestoreTestButton;

  /// No description provided for @settingsTestTitle.
  ///
  /// In ja, this message translates to:
  /// **'Firestore動作テスト'**
  String get settingsTestTitle;

  /// No description provided for @settingsTestDescription.
  ///
  /// In ja, this message translates to:
  /// **'Firestore動作確認'**
  String get settingsTestDescription;

  /// No description provided for @settingsTestGuide.
  ///
  /// In ja, this message translates to:
  /// **'設定を変更して「保存」ボタンを押すと、Firestoreに保存されます。\nアプリを再起動しても設定が保持されることを確認できます。'**
  String get settingsTestGuide;

  /// No description provided for @firestoreCurrentValues.
  ///
  /// In ja, this message translates to:
  /// **'Firestoreの現在値（リアルタイム）'**
  String get firestoreCurrentValues;

  /// No description provided for @labelDisplayName.
  ///
  /// In ja, this message translates to:
  /// **'表示名'**
  String get labelDisplayName;

  /// No description provided for @labelNotification.
  ///
  /// In ja, this message translates to:
  /// **'通知'**
  String get labelNotification;

  /// No description provided for @labelDarkMode.
  ///
  /// In ja, this message translates to:
  /// **'ダークモード'**
  String get labelDarkMode;

  /// No description provided for @labelLanguage.
  ///
  /// In ja, this message translates to:
  /// **'言語'**
  String get labelLanguage;

  /// No description provided for @labelDocumentId.
  ///
  /// In ja, this message translates to:
  /// **'ドキュメントID'**
  String get labelDocumentId;

  /// No description provided for @on.
  ///
  /// In ja, this message translates to:
  /// **'ON'**
  String get on;

  /// No description provided for @off.
  ///
  /// In ja, this message translates to:
  /// **'OFF'**
  String get off;

  /// No description provided for @editSettings.
  ///
  /// In ja, this message translates to:
  /// **'設定を変更'**
  String get editSettings;

  /// No description provided for @placeholderDisplayName.
  ///
  /// In ja, this message translates to:
  /// **'表示名を入力してください'**
  String get placeholderDisplayName;

  /// No description provided for @switchNotification.
  ///
  /// In ja, this message translates to:
  /// **'通知を有効にする'**
  String get switchNotification;

  /// No description provided for @switchDarkMode.
  ///
  /// In ja, this message translates to:
  /// **'ダークモードを有効にする'**
  String get switchDarkMode;

  /// No description provided for @languageJa.
  ///
  /// In ja, this message translates to:
  /// **'日本語'**
  String get languageJa;

  /// No description provided for @languageEn.
  ///
  /// In ja, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @saveToFirestore.
  ///
  /// In ja, this message translates to:
  /// **'Firestoreに保存'**
  String get saveToFirestore;

  /// No description provided for @individualUpdateTest.
  ///
  /// In ja, this message translates to:
  /// **'個別更新テスト'**
  String get individualUpdateTest;

  /// No description provided for @toggleNotification.
  ///
  /// In ja, this message translates to:
  /// **'通知トグル'**
  String get toggleNotification;

  /// No description provided for @toggleDarkMode.
  ///
  /// In ja, this message translates to:
  /// **'ダークモードトグル'**
  String get toggleDarkMode;

  /// No description provided for @savedToFirestore.
  ///
  /// In ja, this message translates to:
  /// **'Firestoreに保存しました'**
  String get savedToFirestore;

  /// No description provided for @saveError.
  ///
  /// In ja, this message translates to:
  /// **'保存エラー: {error}'**
  String saveError(String error);

  /// No description provided for @notificationUpdated.
  ///
  /// In ja, this message translates to:
  /// **'通知設定を更新しました'**
  String get notificationUpdated;

  /// No description provided for @darkModeUpdated.
  ///
  /// In ja, this message translates to:
  /// **'ダークモード設定を更新しました'**
  String get darkModeUpdated;

  /// No description provided for @errorMessage.
  ///
  /// In ja, this message translates to:
  /// **'エラー: {error}'**
  String errorMessage(String error);

  /// No description provided for @reload.
  ///
  /// In ja, this message translates to:
  /// **'再読み込み'**
  String get reload;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
