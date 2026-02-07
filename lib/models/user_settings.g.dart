// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) =>
    _UserSettings(
      id: json['id'] as String?,
      displayName: json['displayName'] as String? ?? '',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      darkModeEnabled: json['darkModeEnabled'] as bool? ?? false,
      language: json['language'] as String? ?? 'ja',
    );

Map<String, dynamic> _$UserSettingsToJson(_UserSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'notificationsEnabled': instance.notificationsEnabled,
      'darkModeEnabled': instance.darkModeEnabled,
      'language': instance.language,
    };
