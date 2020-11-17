import 'package:json_annotation/json_annotation.dart';
part 'Settings.g.dart';

enum soundSettingOption{
  normal,mute,vibrate,systemPreferences
}
@JsonSerializable()
class Settings{
  soundSettingOption soundSetting;
  List<String> taskSetting;
  Settings(this.soundSetting,this.taskSetting);

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
