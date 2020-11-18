import 'package:json_annotation/json_annotation.dart';

import '../index.dart';
part 'AlarmInfo.g.dart';

@JsonSerializable()
class AlarmInfo {
  int alarmId;
  String label;
  @JsonKey(fromJson: jsonToRepeat, toJson: repeatToJson)
  List<String> repeat;
  @JsonKey(fromJson: jsonToTime, toJson: timeToJson)
  TimeOfDay time;
  String mission;
  String audio;
  @JsonKey(fromJson: intToBool, toJson: boolToInt)
  bool vibration;
  @JsonKey(fromJson: intToBool, toJson: boolToInt)
  bool isOpen;

  AlarmInfo(this.alarmId, this.label, this.repeat, this.time, this.mission, this.audio, this.vibration, this.isOpen);

  factory AlarmInfo.fromJson(Map<String, dynamic> json) => _$AlarmInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AlarmInfoToJson(this);

  static String timeToJson(TimeOfDay time) =>
    time.hour.toString() + ":" + time.minute.toString();
  static TimeOfDay jsonToTime(String time) =>
      TimeOfDay(hour: int.parse(time.split(":")[0]),minute: int.parse(time.split(':')[1]));
  static String repeatToJson(List<String> repeat) {
      String result = "";
      repeat.forEach((element) {
        result = result + element + " ";
      });
      return result.trim();
  }
  static List<String> jsonToRepeat(String repeat) =>
      repeat.split(" ");
  static bool intToBool(int vibration) =>
      vibration==1?true:false;
  static int boolToInt(bool vibration) =>
      vibration?1:0;
}