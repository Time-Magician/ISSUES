// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Frog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Frog _$FrogFromJson(Map<String, dynamic> json) {
  return Frog(
      json['frogId'] as int,
      json['name'] as String,
      json['level'] as int,
      json['exp'] as int,
      json['isGraduated'] == null
          ? null
          : Frog.intToBool(json['isGraduated'] as int),
      json['graduateDate'] as String,
      json['school'] as String);
}

Map<String, dynamic> _$FrogToJson(Frog instance) => <String, dynamic>{
      'frogId': instance.frogId,
      'name': instance.name,
      'level': instance.level,
      'exp': instance.exp,
      'isGraduated': instance.isGraduated == null
          ? null
          : Frog.boolToInt(instance.isGraduated),
      'graduateDate': instance.graduateDate,
      'school': instance.school
    };
