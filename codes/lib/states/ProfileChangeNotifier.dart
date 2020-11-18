import '../models/index.dart';
import '../index.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;
  @override
  void notifyListeners() {
    Global.saveProfile(); //保存Profile变更
    super.notifyListeners(); //通知依赖的Widget更新
  }
}

class UserModel extends ProfileChangeNotifier {
  User get user => _profile.user;
  String get userName => _profile.user.userName;
  String get name => _profile.user.name;
  String get email  => _profile.user.email;
  String get gender => _profile.user.gender;
  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => user != null;

  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set user(User user) {
      _profile.user = user;
      print("Wo");
      notifyListeners();
  }
  set userName(String userName){
    _profile.user.userName = userName;
    notifyListeners();
  }
  set email (String email){
    _profile.user.email = email;
    notifyListeners();
  }
  set gender(String gender){
    _profile.user.gender = gender;
    notifyListeners();
  }
}


class SettingsModel extends ProfileChangeNotifier {
  List<String> get taskSetting => _profile.settings.taskSetting;
  soundSettingOption get soundSetting => _profile.settings.soundSetting;

  set taskSetting(List<String> taskSetting){
    _profile.settings.taskSetting = taskSetting;
    notifyListeners();
  }

  set soundSetting(soundSettingOption soundSetting){
    _profile.settings.soundSetting = soundSetting;
    notifyListeners();
  }
}
