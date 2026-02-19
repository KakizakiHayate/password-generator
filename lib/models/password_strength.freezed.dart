// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_strength.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PasswordStrength {

/// 強度レベル
 StrengthLevel get level;/// エントロピー（ビット数）
 double get entropy;/// 解読推定時間の表示テキスト
 String get crackTimeDisplay;
/// Create a copy of PasswordStrength
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasswordStrengthCopyWith<PasswordStrength> get copyWith => _$PasswordStrengthCopyWithImpl<PasswordStrength>(this as PasswordStrength, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordStrength&&(identical(other.level, level) || other.level == level)&&(identical(other.entropy, entropy) || other.entropy == entropy)&&(identical(other.crackTimeDisplay, crackTimeDisplay) || other.crackTimeDisplay == crackTimeDisplay));
}


@override
int get hashCode => Object.hash(runtimeType,level,entropy,crackTimeDisplay);

@override
String toString() {
  return 'PasswordStrength(level: $level, entropy: $entropy, crackTimeDisplay: $crackTimeDisplay)';
}


}

/// @nodoc
abstract mixin class $PasswordStrengthCopyWith<$Res>  {
  factory $PasswordStrengthCopyWith(PasswordStrength value, $Res Function(PasswordStrength) _then) = _$PasswordStrengthCopyWithImpl;
@useResult
$Res call({
 StrengthLevel level, double entropy, String crackTimeDisplay
});




}
/// @nodoc
class _$PasswordStrengthCopyWithImpl<$Res>
    implements $PasswordStrengthCopyWith<$Res> {
  _$PasswordStrengthCopyWithImpl(this._self, this._then);

  final PasswordStrength _self;
  final $Res Function(PasswordStrength) _then;

/// Create a copy of PasswordStrength
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? entropy = null,Object? crackTimeDisplay = null,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as StrengthLevel,entropy: null == entropy ? _self.entropy : entropy // ignore: cast_nullable_to_non_nullable
as double,crackTimeDisplay: null == crackTimeDisplay ? _self.crackTimeDisplay : crackTimeDisplay // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PasswordStrength].
extension PasswordStrengthPatterns on PasswordStrength {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PasswordStrength value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PasswordStrength() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PasswordStrength value)  $default,){
final _that = this;
switch (_that) {
case _PasswordStrength():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PasswordStrength value)?  $default,){
final _that = this;
switch (_that) {
case _PasswordStrength() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StrengthLevel level,  double entropy,  String crackTimeDisplay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PasswordStrength() when $default != null:
return $default(_that.level,_that.entropy,_that.crackTimeDisplay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StrengthLevel level,  double entropy,  String crackTimeDisplay)  $default,) {final _that = this;
switch (_that) {
case _PasswordStrength():
return $default(_that.level,_that.entropy,_that.crackTimeDisplay);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StrengthLevel level,  double entropy,  String crackTimeDisplay)?  $default,) {final _that = this;
switch (_that) {
case _PasswordStrength() when $default != null:
return $default(_that.level,_that.entropy,_that.crackTimeDisplay);case _:
  return null;

}
}

}

/// @nodoc


class _PasswordStrength implements PasswordStrength {
  const _PasswordStrength({required this.level, required this.entropy, required this.crackTimeDisplay});
  

/// 強度レベル
@override final  StrengthLevel level;
/// エントロピー（ビット数）
@override final  double entropy;
/// 解読推定時間の表示テキスト
@override final  String crackTimeDisplay;

/// Create a copy of PasswordStrength
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PasswordStrengthCopyWith<_PasswordStrength> get copyWith => __$PasswordStrengthCopyWithImpl<_PasswordStrength>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PasswordStrength&&(identical(other.level, level) || other.level == level)&&(identical(other.entropy, entropy) || other.entropy == entropy)&&(identical(other.crackTimeDisplay, crackTimeDisplay) || other.crackTimeDisplay == crackTimeDisplay));
}


@override
int get hashCode => Object.hash(runtimeType,level,entropy,crackTimeDisplay);

@override
String toString() {
  return 'PasswordStrength(level: $level, entropy: $entropy, crackTimeDisplay: $crackTimeDisplay)';
}


}

/// @nodoc
abstract mixin class _$PasswordStrengthCopyWith<$Res> implements $PasswordStrengthCopyWith<$Res> {
  factory _$PasswordStrengthCopyWith(_PasswordStrength value, $Res Function(_PasswordStrength) _then) = __$PasswordStrengthCopyWithImpl;
@override @useResult
$Res call({
 StrengthLevel level, double entropy, String crackTimeDisplay
});




}
/// @nodoc
class __$PasswordStrengthCopyWithImpl<$Res>
    implements _$PasswordStrengthCopyWith<$Res> {
  __$PasswordStrengthCopyWithImpl(this._self, this._then);

  final _PasswordStrength _self;
  final $Res Function(_PasswordStrength) _then;

/// Create a copy of PasswordStrength
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? entropy = null,Object? crackTimeDisplay = null,}) {
  return _then(_PasswordStrength(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as StrengthLevel,entropy: null == entropy ? _self.entropy : entropy // ignore: cast_nullable_to_non_nullable
as double,crackTimeDisplay: null == crackTimeDisplay ? _self.crackTimeDisplay : crackTimeDisplay // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
