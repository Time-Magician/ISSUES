import 'package:json_annotation/json_annotation.dart';

part 'Friend.g.dart';

@JsonSerializable()
class Friend {
  int userId;
  String name;
  String username;
  String gender;
  String tel;
  String email;

  Friend(this.userId, this.name, this.username, this.gender, this.tel, this.email);

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);
  Map<String, dynamic> toJson() => _$FriendToJson(this);

}
