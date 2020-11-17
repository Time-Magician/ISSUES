// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) {
  return Settings(
      _$enumDecodeNullable(_$soundSettingOptionEnumMap, json['soundSetting']),
      (json['taskSetting'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'soundSetting': _$soundSettingOptionEnumMap[instance.soundSetting],
      'taskSetting': instance.taskSetting
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

const _$soundSettingOptionEnumMap = <soundSettingOption, dynamic>{
  soundSettingOption.normal: 'normal',
  soundSettingOption.mute: 'mute',
  soundSettingOption.vibrate: 'vibrate',
  soundSettingOption.systemPreferences: 'systemPreferences'
};
