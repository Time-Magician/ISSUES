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
  String get userName => _profile.user.username;
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
    _profile.user.username = userName;
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
  set name(String name){
    _profile.user.name = name;
    notifyListeners();
  }
}


class SettingsModel extends ProfileChangeNotifier {
  List<String> get taskSetting => _profile.settings.taskSetting;
  List<String> get whiteListSetting => _profile.settings.whiteListSetting;
  styleSettingOption get styleSetting => _profile.settings.styleSetting;
  studyModeSettingOption get studyModeSetting => _profile.settings.studyModeSetting;

  set taskSetting(List<String> taskSetting){
    _profile.settings.taskSetting = taskSetting;
    notifyListeners();
  }

  set styleSetting(styleSettingOption styleSetting){
    _profile.settings.styleSetting = styleSetting;
    notifyListeners();
  }

  set whiteListSetting(List<String> whiteListSetting){
    _profile.settings.whiteListSetting = whiteListSetting;
    notifyListeners();
  }

  set studyModeSetting(studyModeSettingOption studySetting){
    _profile.settings.studyModeSetting = studySetting;
    notifyListeners();
  }
}
