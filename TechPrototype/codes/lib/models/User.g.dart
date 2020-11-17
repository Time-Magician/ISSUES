// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      json['userName'] as String,
      json['name'] as String,
      json['email'] as String,
      json['gender'] as String,
      json['password'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userName': instance.userName,
      'name': instance.name,
      'password': instance.password,
      'email': instance.email,
      'gender': instance.gender
    };
