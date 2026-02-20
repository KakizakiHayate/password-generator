// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_generator_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$passwordGeneratorViewModelHash() =>
    r'43e23a0f9946f3cb8592bbb21382d8b686abd91c';

/// メイン画面の ViewModel
///
/// パスワード生成・設定変更・強度計算を管理する。
/// 設定変更時は自動保存と自動再生成を行う。
///
/// Copied from [PasswordGeneratorViewModel].
@ProviderFor(PasswordGeneratorViewModel)
final passwordGeneratorViewModelProvider =
    AutoDisposeAsyncNotifierProvider<
      PasswordGeneratorViewModel,
      PasswordGeneratorState
    >.internal(
      PasswordGeneratorViewModel.new,
      name: r'passwordGeneratorViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$passwordGeneratorViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PasswordGeneratorViewModel =
    AutoDisposeAsyncNotifier<PasswordGeneratorState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
