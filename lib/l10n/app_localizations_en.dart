// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Password Generator';

  @override
  String get strengthWeak => 'Weak';

  @override
  String get strengthFair => 'Fair';

  @override
  String get strengthStrong => 'Strong';

  @override
  String get strengthVeryStrong => 'Very Strong';

  @override
  String get crackTimePrefix => 'Est. crack time:';

  @override
  String get characterCount => 'Length';

  @override
  String get uppercaseLabel => 'Uppercase (A-Z)';

  @override
  String get lowercaseLabel => 'Lowercase (a-z)';

  @override
  String get numbersLabel => 'Numbers (0-9)';

  @override
  String get symbolsLabel => 'Symbols';

  @override
  String get excludeAmbiguousLabel => 'Exclude ambiguous characters';

  @override
  String get customizeSymbolsLabel => 'Customize symbols';

  @override
  String get generateButton => 'Generate';

  @override
  String get symbolSelectionTitle => 'Symbol Selection';

  @override
  String get doneButton => 'Done';

  @override
  String get selectAllSymbols => 'Select All';

  @override
  String get deselectAllSymbols => 'Deselect All';

  @override
  String get symbolSelectionError => 'Please select at least one symbol';

  @override
  String get copiedMessage => 'Copied';

  @override
  String get copyButton => 'Copy';

  @override
  String get viewOtherCandidates => 'View other candidates';

  @override
  String get regenerateCandidates => 'Regenerate candidates';

  @override
  String get homeGreeting => 'Hello Starter Kit';

  @override
  String get firestoreTestButton => 'Firestore Test';

  @override
  String get settingsTestTitle => 'Firestore Test';

  @override
  String get settingsTestDescription => 'Firestore Verification';

  @override
  String get settingsTestGuide =>
      'Change settings and tap \"Save\" to store them in Firestore.\nSettings persist even after restarting the app.';

  @override
  String get firestoreCurrentValues => 'Current Firestore Values (Real-time)';

  @override
  String get labelDisplayName => 'Display Name';

  @override
  String get labelNotification => 'Notification';

  @override
  String get labelDarkMode => 'Dark Mode';

  @override
  String get labelLanguage => 'Language';

  @override
  String get labelDocumentId => 'Document ID';

  @override
  String get on => 'ON';

  @override
  String get off => 'OFF';

  @override
  String get editSettings => 'Edit Settings';

  @override
  String get placeholderDisplayName => 'Enter display name';

  @override
  String get switchNotification => 'Enable notifications';

  @override
  String get switchDarkMode => 'Enable dark mode';

  @override
  String get languageJa => 'Japanese';

  @override
  String get languageEn => 'English';

  @override
  String get saveToFirestore => 'Save to Firestore';

  @override
  String get individualUpdateTest => 'Individual Update Test';

  @override
  String get toggleNotification => 'Toggle Notification';

  @override
  String get toggleDarkMode => 'Toggle Dark Mode';

  @override
  String get savedToFirestore => 'Saved to Firestore';

  @override
  String saveError(String error) {
    return 'Save error: $error';
  }

  @override
  String get notificationUpdated => 'Notification setting updated';

  @override
  String get darkModeUpdated => 'Dark mode setting updated';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get reload => 'Reload';
}
