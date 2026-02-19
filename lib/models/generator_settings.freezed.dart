// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generator_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeneratorSettings {

/// パスワード文字数（範囲: 4〜128）
 int get length;/// 大文字 (A-Z) を含む
 bool get useUppercase;/// 小文字 (a-z) を含む
 bool get useLowercase;/// 数字 (0-9) を含む
 bool get useNumbers;/// 記号を含む
 bool get useSymbols;/// 紛らわしい文字（oO0, lI1 等）を除外する
 bool get excludeAmbiguous;/// 各記号の ON/OFF 状態
 Map<String, bool> get customSymbols;
/// Create a copy of GeneratorSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneratorSettingsCopyWith<GeneratorSettings> get copyWith => _$GeneratorSettingsCopyWithImpl<GeneratorSettings>(this as GeneratorSettings, _$identity);

  /// Serializes this GeneratorSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneratorSettings&&(identical(other.length, length) || other.length == length)&&(identical(other.useUppercase, useUppercase) || other.useUppercase == useUppercase)&&(identical(other.useLowercase, useLowercase) || other.useLowercase == useLowercase)&&(identical(other.useNumbers, useNumbers) || other.useNumbers == useNumbers)&&(identical(other.useSymbols, useSymbols) || other.useSymbols == useSymbols)&&(identical(other.excludeAmbiguous, excludeAmbiguous) || other.excludeAmbiguous == excludeAmbiguous)&&const DeepCollectionEquality().equals(other.customSymbols, customSymbols));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,length,useUppercase,useLowercase,useNumbers,useSymbols,excludeAmbiguous,const DeepCollectionEquality().hash(customSymbols));

@override
String toString() {
  return 'GeneratorSettings(length: $length, useUppercase: $useUppercase, useLowercase: $useLowercase, useNumbers: $useNumbers, useSymbols: $useSymbols, excludeAmbiguous: $excludeAmbiguous, customSymbols: $customSymbols)';
}


}

/// @nodoc
abstract mixin class $GeneratorSettingsCopyWith<$Res>  {
  factory $GeneratorSettingsCopyWith(GeneratorSettings value, $Res Function(GeneratorSettings) _then) = _$GeneratorSettingsCopyWithImpl;
@useResult
$Res call({
 int length, bool useUppercase, bool useLowercase, bool useNumbers, bool useSymbols, bool excludeAmbiguous, Map<String, bool> customSymbols
});




}
/// @nodoc
class _$GeneratorSettingsCopyWithImpl<$Res>
    implements $GeneratorSettingsCopyWith<$Res> {
  _$GeneratorSettingsCopyWithImpl(this._self, this._then);

  final GeneratorSettings _self;
  final $Res Function(GeneratorSettings) _then;

/// Create a copy of GeneratorSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? length = null,Object? useUppercase = null,Object? useLowercase = null,Object? useNumbers = null,Object? useSymbols = null,Object? excludeAmbiguous = null,Object? customSymbols = null,}) {
  return _then(_self.copyWith(
length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int,useUppercase: null == useUppercase ? _self.useUppercase : useUppercase // ignore: cast_nullable_to_non_nullable
as bool,useLowercase: null == useLowercase ? _self.useLowercase : useLowercase // ignore: cast_nullable_to_non_nullable
as bool,useNumbers: null == useNumbers ? _self.useNumbers : useNumbers // ignore: cast_nullable_to_non_nullable
as bool,useSymbols: null == useSymbols ? _self.useSymbols : useSymbols // ignore: cast_nullable_to_non_nullable
as bool,excludeAmbiguous: null == excludeAmbiguous ? _self.excludeAmbiguous : excludeAmbiguous // ignore: cast_nullable_to_non_nullable
as bool,customSymbols: null == customSymbols ? _self.customSymbols : customSymbols // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}

}


/// Adds pattern-matching-related methods to [GeneratorSettings].
extension GeneratorSettingsPatterns on GeneratorSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeneratorSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeneratorSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeneratorSettings value)  $default,){
final _that = this;
switch (_that) {
case _GeneratorSettings():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeneratorSettings value)?  $default,){
final _that = this;
switch (_that) {
case _GeneratorSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int length,  bool useUppercase,  bool useLowercase,  bool useNumbers,  bool useSymbols,  bool excludeAmbiguous,  Map<String, bool> customSymbols)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeneratorSettings() when $default != null:
return $default(_that.length,_that.useUppercase,_that.useLowercase,_that.useNumbers,_that.useSymbols,_that.excludeAmbiguous,_that.customSymbols);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int length,  bool useUppercase,  bool useLowercase,  bool useNumbers,  bool useSymbols,  bool excludeAmbiguous,  Map<String, bool> customSymbols)  $default,) {final _that = this;
switch (_that) {
case _GeneratorSettings():
return $default(_that.length,_that.useUppercase,_that.useLowercase,_that.useNumbers,_that.useSymbols,_that.excludeAmbiguous,_that.customSymbols);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int length,  bool useUppercase,  bool useLowercase,  bool useNumbers,  bool useSymbols,  bool excludeAmbiguous,  Map<String, bool> customSymbols)?  $default,) {final _that = this;
switch (_that) {
case _GeneratorSettings() when $default != null:
return $default(_that.length,_that.useUppercase,_that.useLowercase,_that.useNumbers,_that.useSymbols,_that.excludeAmbiguous,_that.customSymbols);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeneratorSettings implements GeneratorSettings {
  const _GeneratorSettings({this.length = 16, this.useUppercase = true, this.useLowercase = true, this.useNumbers = true, this.useSymbols = true, this.excludeAmbiguous = false, final  Map<String, bool> customSymbols = _defaultCustomSymbols}): _customSymbols = customSymbols;
  factory _GeneratorSettings.fromJson(Map<String, dynamic> json) => _$GeneratorSettingsFromJson(json);

/// パスワード文字数（範囲: 4〜128）
@override@JsonKey() final  int length;
/// 大文字 (A-Z) を含む
@override@JsonKey() final  bool useUppercase;
/// 小文字 (a-z) を含む
@override@JsonKey() final  bool useLowercase;
/// 数字 (0-9) を含む
@override@JsonKey() final  bool useNumbers;
/// 記号を含む
@override@JsonKey() final  bool useSymbols;
/// 紛らわしい文字（oO0, lI1 等）を除外する
@override@JsonKey() final  bool excludeAmbiguous;
/// 各記号の ON/OFF 状態
 final  Map<String, bool> _customSymbols;
/// 各記号の ON/OFF 状態
@override@JsonKey() Map<String, bool> get customSymbols {
  if (_customSymbols is EqualUnmodifiableMapView) return _customSymbols;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_customSymbols);
}


/// Create a copy of GeneratorSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeneratorSettingsCopyWith<_GeneratorSettings> get copyWith => __$GeneratorSettingsCopyWithImpl<_GeneratorSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeneratorSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeneratorSettings&&(identical(other.length, length) || other.length == length)&&(identical(other.useUppercase, useUppercase) || other.useUppercase == useUppercase)&&(identical(other.useLowercase, useLowercase) || other.useLowercase == useLowercase)&&(identical(other.useNumbers, useNumbers) || other.useNumbers == useNumbers)&&(identical(other.useSymbols, useSymbols) || other.useSymbols == useSymbols)&&(identical(other.excludeAmbiguous, excludeAmbiguous) || other.excludeAmbiguous == excludeAmbiguous)&&const DeepCollectionEquality().equals(other._customSymbols, _customSymbols));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,length,useUppercase,useLowercase,useNumbers,useSymbols,excludeAmbiguous,const DeepCollectionEquality().hash(_customSymbols));

@override
String toString() {
  return 'GeneratorSettings(length: $length, useUppercase: $useUppercase, useLowercase: $useLowercase, useNumbers: $useNumbers, useSymbols: $useSymbols, excludeAmbiguous: $excludeAmbiguous, customSymbols: $customSymbols)';
}


}

/// @nodoc
abstract mixin class _$GeneratorSettingsCopyWith<$Res> implements $GeneratorSettingsCopyWith<$Res> {
  factory _$GeneratorSettingsCopyWith(_GeneratorSettings value, $Res Function(_GeneratorSettings) _then) = __$GeneratorSettingsCopyWithImpl;
@override @useResult
$Res call({
 int length, bool useUppercase, bool useLowercase, bool useNumbers, bool useSymbols, bool excludeAmbiguous, Map<String, bool> customSymbols
});




}
/// @nodoc
class __$GeneratorSettingsCopyWithImpl<$Res>
    implements _$GeneratorSettingsCopyWith<$Res> {
  __$GeneratorSettingsCopyWithImpl(this._self, this._then);

  final _GeneratorSettings _self;
  final $Res Function(_GeneratorSettings) _then;

/// Create a copy of GeneratorSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? length = null,Object? useUppercase = null,Object? useLowercase = null,Object? useNumbers = null,Object? useSymbols = null,Object? excludeAmbiguous = null,Object? customSymbols = null,}) {
  return _then(_GeneratorSettings(
length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int,useUppercase: null == useUppercase ? _self.useUppercase : useUppercase // ignore: cast_nullable_to_non_nullable
as bool,useLowercase: null == useLowercase ? _self.useLowercase : useLowercase // ignore: cast_nullable_to_non_nullable
as bool,useNumbers: null == useNumbers ? _self.useNumbers : useNumbers // ignore: cast_nullable_to_non_nullable
as bool,useSymbols: null == useSymbols ? _self.useSymbols : useSymbols // ignore: cast_nullable_to_non_nullable
as bool,excludeAmbiguous: null == excludeAmbiguous ? _self.excludeAmbiguous : excludeAmbiguous // ignore: cast_nullable_to_non_nullable
as bool,customSymbols: null == customSymbols ? _self._customSymbols : customSymbols // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}


}

// dart format on
