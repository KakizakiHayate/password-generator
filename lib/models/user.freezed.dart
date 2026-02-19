// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

/// アカウント作成日時
 DateTime get createdAt;/// 累計パスワード生成回数
 int get generationCount;/// レビュー依頼を表示済みか
 bool get reviewPromptShown;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.generationCount, generationCount) || other.generationCount == generationCount)&&(identical(other.reviewPromptShown, reviewPromptShown) || other.reviewPromptShown == reviewPromptShown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,createdAt,generationCount,reviewPromptShown);

@override
String toString() {
  return 'User(createdAt: $createdAt, generationCount: $generationCount, reviewPromptShown: $reviewPromptShown)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 DateTime createdAt, int generationCount, bool reviewPromptShown
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? createdAt = null,Object? generationCount = null,Object? reviewPromptShown = null,}) {
  return _then(_self.copyWith(
createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,generationCount: null == generationCount ? _self.generationCount : generationCount // ignore: cast_nullable_to_non_nullable
as int,reviewPromptShown: null == reviewPromptShown ? _self.reviewPromptShown : reviewPromptShown // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime createdAt,  int generationCount,  bool reviewPromptShown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.createdAt,_that.generationCount,_that.reviewPromptShown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime createdAt,  int generationCount,  bool reviewPromptShown)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.createdAt,_that.generationCount,_that.reviewPromptShown);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime createdAt,  int generationCount,  bool reviewPromptShown)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.createdAt,_that.generationCount,_that.reviewPromptShown);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({required this.createdAt, this.generationCount = 0, this.reviewPromptShown = false});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

/// アカウント作成日時
@override final  DateTime createdAt;
/// 累計パスワード生成回数
@override@JsonKey() final  int generationCount;
/// レビュー依頼を表示済みか
@override@JsonKey() final  bool reviewPromptShown;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.generationCount, generationCount) || other.generationCount == generationCount)&&(identical(other.reviewPromptShown, reviewPromptShown) || other.reviewPromptShown == reviewPromptShown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,createdAt,generationCount,reviewPromptShown);

@override
String toString() {
  return 'User(createdAt: $createdAt, generationCount: $generationCount, reviewPromptShown: $reviewPromptShown)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 DateTime createdAt, int generationCount, bool reviewPromptShown
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? createdAt = null,Object? generationCount = null,Object? reviewPromptShown = null,}) {
  return _then(_User(
createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,generationCount: null == generationCount ? _self.generationCount : generationCount // ignore: cast_nullable_to_non_nullable
as int,reviewPromptShown: null == reviewPromptShown ? _self.reviewPromptShown : reviewPromptShown // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
