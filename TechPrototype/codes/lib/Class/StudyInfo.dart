import 'package:flutter/material.dart';

class StudyInfo{
  Frog frog;
  bool isStudying;

  StudyInfo(Frog frog, bool isStudying):
      frog = frog,
      isStudying = isStudying;
}

class Frog {
  String name;
  int level;
  int exp;
  bool isGraduated;
  String graduateDate;
  String school;

  Frog(String name, int level, int exp, bool isGraduated, String graduateDate, String school) :
      name = name,
      level = level,
      exp = exp,
      isGraduated = isGraduated,
      graduateDate = graduateDate,
      school = school;
}

List<String> level = ["学前班","一年级","二年级","三年级","四年级","五年级","六年级","初一","初二","初三","高一","高二","高三","大一","大二","大三","大四"];
