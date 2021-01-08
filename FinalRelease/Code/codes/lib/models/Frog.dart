import 'dart:math';

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

  static String randomFrogName() =>
      familyName[(new Random()).nextInt(13)]+firstName[(new Random()).nextInt(18)];
  static String randomSchoolName() =>
      schoolName[(new Random()).nextInt(12)];
}

List<String> level = ["学前班","一年级","二年级","三年级","四年级","五年级","六年级","初一","初二","初三","高一","高二","高三","大一","大二","大三","大四","毕业"];
List<String> familyName = ["张","王","赵","周","李","朱","沈","陈","江","刘","黄","吴","郑"];
List<String> firstName = ["桂花","铁柱","翠花","二狗","建国","小明","大嘴","素芬","彩霞","美丽","福贵","俊杰","云龙","建强","壮壮","小虎","小华","萍萍"];
List<String> schoolName = ["氢化大学","蛙省理工","蛙东师范","浇通大学","负蛋大学","业级大学","溅桥大学","蛤湖大学","Stanfrog","电子蝌大","蛤工大","Berklake"];
