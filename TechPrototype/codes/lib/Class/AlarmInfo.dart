import 'package:flutter/material.dart';

class AlarmInfo {
  String label;
  List<String> repeat;
  TimeOfDay time;
  String mission;
  String audio;
  bool vibration;
  bool isOpen;

  AlarmInfo(String label, List<String> repeat, TimeOfDay time, String mission, String audio, bool vibration, bool isOpen):
        label = label,
        repeat = repeat,
        time = time,
        mission = mission,
        audio = audio,
        vibration = false,
        isOpen = isOpen;
}
