import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum soundSettingOption{
  normal,mute,vibrate,systemPreferences
}

class SettingInfo with ChangeNotifier{
    SharedPreferences storage;
    soundSettingOption soundSetting=soundSettingOption.systemPreferences;
    List<String> taskSetting=['photo','math','sing','game'];
    void init()async{
      storage = await SharedPreferences.getInstance();
      soundSetting = soundSettingOption.values[storage.getInt('soundSetting')];
      taskSetting = storage.getStringList('taskSetting');
    }
    void setSound(soundSettingOption _soundSetting){
      this.soundSetting=_soundSetting;
      storage.setInt('soundSetting', _soundSetting.index);
      notifyListeners();
    }

    void setTask(List<String> _taskSetting){
      this.taskSetting=_taskSetting;
      storage.setStringList('taskSetting', _taskSetting);
    }
}
