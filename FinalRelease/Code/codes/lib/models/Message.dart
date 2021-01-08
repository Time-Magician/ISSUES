import 'package:json_annotation/json_annotation.dart';

import '../index.dart';
part 'Message.g.dart';

@JsonSerializable()
class Message {
  String id;
  int senderId;
  int receiverId;
  String type;
  String time;
  int status;
  String details;

  Message(this.id, this.senderId, this.receiverId, this.type, this.time, this.status, this.details);

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}