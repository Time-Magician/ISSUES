// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friend _$FriendFromJson(Map<String, dynamic> json) {
  return Friend(
      json['userId'] as int,
      json['name'] as String,
      json['username'] as String,
      json['gender'] as String,
      json['tel'] as String,
      json['email'] as String);
}

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'username': instance.username,
      'gender': instance.gender,
      'tel': instance.tel,
      'email': instance.email
    };
