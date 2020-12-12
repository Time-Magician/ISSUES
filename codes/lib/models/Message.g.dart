// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(json['id'], json['senderId'] as int, json['receiverId'] as int,
      json['type'], json['time'], json['status'] as int, json['details']);
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'type': instance.type,
      'time': instance.time,
      'status': instance.status,
      'details': instance.details
    };
