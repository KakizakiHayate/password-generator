// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeneratorSettings _$GeneratorSettingsFromJson(Map<String, dynamic> json) =>
    _GeneratorSettings(
      length: (json['length'] as num?)?.toInt() ?? 16,
      useUppercase: json['useUppercase'] as bool? ?? true,
      useLowercase: json['useLowercase'] as bool? ?? true,
      useNumbers: json['useNumbers'] as bool? ?? true,
      useSymbols: json['useSymbols'] as bool? ?? true,
      excludeAmbiguous: json['excludeAmbiguous'] as bool? ?? false,
      customSymbols:
          (json['customSymbols'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          _defaultCustomSymbols,
    );

Map<String, dynamic> _$GeneratorSettingsToJson(_GeneratorSettings instance) =>
    <String, dynamic>{
      'length': instance.length,
      'useUppercase': instance.useUppercase,
      'useLowercase': instance.useLowercase,
      'useNumbers': instance.useNumbers,
      'useSymbols': instance.useSymbols,
      'excludeAmbiguous': instance.excludeAmbiguous,
      'customSymbols': instance.customSymbols,
    };
