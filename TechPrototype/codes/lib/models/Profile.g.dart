// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile()
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..token = json['token'] as String
    ..theme = json['theme'] as num
    ..settings = json['settings'] == null
        ? null
        : Settings.fromJson(json['settings'] as Map<String, dynamic>)
    ..lastLogin = json['lastLogin'] as String
    ..locale = json['locale'] as String;
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
      'theme': instance.theme,
      'settings': instance.settings,
      'lastLogin': instance.lastLogin,
      'locale': instance.locale
    };
