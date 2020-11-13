import 'dart:convert';
import 'package:demo5/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo5/models/Profile.dart';

class Global {
  static SharedPreferences _prefs;
  static Profile profile;
  static var methodChannel;

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }else{
      rootBundle.loadString('jsons/profile.json').then((String value){
        Map<String,dynamic> tmp = jsonDecode(value);
        profile = Profile.fromJson(tmp);
      });
      rootBundle.loadString('jsons/user.json').then((String value){
        Map<String,dynamic> tmp = jsonDecode(value);
        profile.user = User.fromJson(tmp);
      });
      rootBundle.loadString('jsons/settings.json').then((String value){
        Map<String,dynamic> tmp = jsonDecode(value);
        profile.settings = Settings.fromJson(tmp);
      });
    }
    methodChannel = MethodChannel("Channel");
  }
  static saveProfile() =>
      _prefs.setString("profile", jsonEncode(profile.toJson()));
}
