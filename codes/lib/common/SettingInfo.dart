import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum soundSettingOption{
  normal,mute,vibrate,systemPreferences
}

class SettingInfo with ChangeNotifier{
    SharedPreferences storage;
    soundSettingOption soundSetting;
    List<String> taskSetting;
    Future<void> init()async{
      storage = await SharedPreferences.getInstance();
      int index = storage.getInt('soundSetting');
      soundSetting = (index == null ?soundSettingOption.systemPreferences: soundSettingOption.values[index]);
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
      notifyListeners();
    }
}
