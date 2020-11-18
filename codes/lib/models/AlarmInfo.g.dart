// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlarmInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlarmInfo _$AlarmInfoFromJson(Map<String, dynamic> json) {
  return AlarmInfo(
      json['alarmId'] as int,
      json['label'],
      json['repeat'] == null ? null : AlarmInfo.jsonToRepeat(json['repeat']),
      json['time'] == null ? null : AlarmInfo.jsonToTime(json['time']),
      json['mission'],
      json['audio'],
      json['vibration'] == null
          ? null
          : AlarmInfo.intToBool(json['vibration'] as int),
      json['isOpen'] == null
          ? null
          : AlarmInfo.intToBool(json['isOpen'] as int));
}

Map<String, dynamic> _$AlarmInfoToJson(AlarmInfo instance) => <String, dynamic>{
      'alarmId': instance.alarmId,
      'label': instance.label,
      'repeat': instance.repeat == null
          ? null
          : AlarmInfo.repeatToJson(instance.repeat),
      'time':
          instance.time == null ? null : AlarmInfo.timeToJson(instance.time),
      'mission': instance.mission,
      'audio': instance.audio,
      'vibration': instance.vibration == null
          ? null
          : AlarmInfo.boolToInt(instance.vibration),
      'isOpen':
          instance.isOpen == null ? null : AlarmInfo.boolToInt(instance.isOpen)
    };
