import 'package:flutter/material.dart';
import 'dart:convert';

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

class AlarmInfoStorage {
  String label;
  String repeat;
  String time;
  String mission;
  String audio;
  bool vibration;
  bool isOpen;

  AlarmInfoStorage(String label, String repeat, String time, String mission, String audio, bool vibration, bool isOpen):
        label = label,
        repeat = repeat,
        time = time,
        mission = mission,
        audio = audio,
        vibration = false,
        isOpen = isOpen;

}

AlarmInfo fromStorage(AlarmInfoStorage alarmInfoStorage) {
  String label = alarmInfoStorage.label;
  List<String> repeat = alarmInfoStorage.repeat.split(' ');
  TimeOfDay time = TimeOfDay(hour: int.parse(alarmInfoStorage.time.split(":")[0]),minute: int.parse(alarmInfoStorage.time.split(':')[1]));
  String mission = alarmInfoStorage.mission;
  String audio = alarmInfoStorage.audio;
  bool vibration = false;
  bool isOpen = alarmInfoStorage.isOpen;

  return AlarmInfo(label, repeat, time, mission, audio, vibration, isOpen);
}

AlarmInfoStorage toStorage(AlarmInfo alarmInfo) {
  String label = alarmInfo.label;
  String repeat = JsonEncoder().convert(alarmInfo.repeat);
  String time = alarmInfo.time.hour.toString() + ":" + alarmInfo.time.minute.toString();
  String mission = alarmInfo.mission;
  String audio = alarmInfo.audio;
  bool vibration = false;
  bool isOpen = alarmInfo.isOpen;

  return AlarmInfoStorage(label, repeat, time, mission, audio, vibration, isOpen);
}