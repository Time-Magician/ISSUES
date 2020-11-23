import 'package:json_annotation/json_annotation.dart';
part 'User.g.dart';

@JsonSerializable()
class User{
  int userId;
  String username;
  final String name;
  String password;
  String email;
  String gender;
  User(this.userId, this.username,this.name,this.email,this.gender,this.password);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
