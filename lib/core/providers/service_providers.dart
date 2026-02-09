// 共通サービスの Provider を一括 export するバレルファイル
//
// 使用例:
// import 'package:flutter_fast_starter/core/providers/service_providers.dart';
// final auth = ref.read(authServiceProvider);

export '../services/analytics_service.dart' show analyticsServiceProvider;
export '../services/auth_service.dart' show authServiceProvider;
export '../services/crashlytics_service.dart' show crashlyticsServiceProvider;
export '../services/firestore_service.dart' show firestoreServiceProvider;
export '../services/preferences_service.dart' show preferencesServiceProvider;
