import 'package:json_annotation/json_annotation.dart';
part 'Settings.g.dart';

enum studyModeSettingOption{
  normal, focus, tomato
}
enum styleSettingOption{
  classic, nighttime
}

@JsonSerializable()
class Settings{
  studyModeSettingOption studyModeSetting;
  styleSettingOption styleSetting;
  List<String> taskSetting;
  List<String> whiteListSetting;
  Settings(this.studyModeSetting, this.styleSetting, this.taskSetting, this.whiteListSetting);

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
