import 'package:demo5/models/Frog.dart';
import 'package:flutter/material.dart';


class StudyInfo{
  Frog frog;
  bool isStudying;

  StudyInfo(Frog frog, bool isStudying):
      frog = frog,
      isStudying = isStudying;
}
