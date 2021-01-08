// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) {
  return Settings(
      _$enumDecodeNullable(
          _$studyModeSettingOptionEnumMap, json['studyModeSetting']),
      _$enumDecodeNullable(_$styleSettingOptionEnumMap, json['styleSetting']),
      (json['taskSetting'] as List)?.map((e) => e as String)?.toList(),
      (json['whiteListSetting'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'studyModeSetting':
          _$studyModeSettingOptionEnumMap[instance.studyModeSetting],
      'styleSetting': _$styleSettingOptionEnumMap[instance.styleSetting],
      'taskSetting': instance.taskSetting,
      'whiteListSetting': instance.whiteListSetting
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$studyModeSettingOptionEnumMap = <studyModeSettingOption, dynamic>{
  studyModeSettingOption.normal: 'normal',
  studyModeSettingOption.focus: 'focus',
  studyModeSettingOption.tomato: 'tomato'
};

const _$styleSettingOptionEnumMap = <styleSettingOption, dynamic>{
  styleSettingOption.classic: 'classic',
  styleSettingOption.nighttime: 'nighttime'
};
