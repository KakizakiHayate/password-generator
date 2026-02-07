// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userSettingsStreamHash() =>
    r'096f5fcb479226193866637ff4ad7accfd3ef31a';

/// リアルタイム監視用のProvider
///
/// Copied from [userSettingsStream].
@ProviderFor(userSettingsStream)
final userSettingsStreamProvider =
    AutoDisposeStreamProvider<UserSettings>.internal(
      userSettingsStream,
      name: r'userSettingsStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userSettingsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserSettingsStreamRef = AutoDisposeStreamProviderRef<UserSettings>;
String _$userSettingsViewModelHash() =>
    r'6e62e27f7d10f50644c3ade944d0d43921012a43';

/// ユーザー設定のViewModel
///
/// FirestoreServiceを使用してFirestoreとやり取りします。
///
/// Copied from [UserSettingsViewModel].
@ProviderFor(UserSettingsViewModel)
final userSettingsViewModelProvider =
    AutoDisposeAsyncNotifierProvider<
      UserSettingsViewModel,
      UserSettings
    >.internal(
      UserSettingsViewModel.new,
      name: r'userSettingsViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userSettingsViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserSettingsViewModel = AutoDisposeAsyncNotifier<UserSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
