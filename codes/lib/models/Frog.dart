import 'package:json_annotation/json_annotation.dart';

part 'Frog.g.dart';

@JsonSerializable()
class Frog {
  int frogId;
  String name;
  int level;
  int exp;
  @JsonKey(fromJson: intToBool, toJson: boolToInt)
  bool isGraduated;
  String graduateDate;
  String school;

  Frog(this.frogId, this.name, this.level, this.exp, this.isGraduated, this.graduateDate, this.school);

  factory Frog.fromJson(Map<String, dynamic> json) => _$FrogFromJson(json);
  Map<String, dynamic> toJson() => _$FrogToJson(this);

  static bool intToBool(int isGraduate) =>
      isGraduate==1?true:false;
  static int boolToInt(bool isGraduate) =>
      isGraduate?1:0;
}

List<String> level = ["学前班","一年级","二年级","三年级","四年级","五年级","六年级","初一","初二","初三","高一","高二","高三","大一","大二","大三","大四","毕业"];
