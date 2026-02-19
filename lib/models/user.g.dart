// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  createdAt: DateTime.parse(json['createdAt'] as String),
  generationCount: (json['generationCount'] as num?)?.toInt() ?? 0,
  reviewPromptShown: json['reviewPromptShown'] as bool? ?? false,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'createdAt': instance.createdAt.toIso8601String(),
  'generationCount': instance.generationCount,
  'reviewPromptShown': instance.reviewPromptShown,
};
