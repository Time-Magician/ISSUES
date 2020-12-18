import 'dart:convert';
import 'package:demo5/Views/AlarmView.dart';
import 'package:demo5/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:demo5/models/Profile.dart';
import 'package:sqflite/sqflite.dart';

class Global {
  static SharedPreferences _prefs;
  static Profile profile;
  static Frog frog;
  static bool hasLogin;
  static String token;
  static int userId;
  static Database db;
  static var methodChannel;
  static AudioPlayer advancedPlayer1 = new AudioPlayer();
  static AudioCache audioCache1= new AudioCache(prefix: "audios/",fixedPlayer: advancedPlayer1);
  static List<AlarmInfo> alarmList = [];
  static List<AlarmInfo> webAlarmList = [];
  static List<String> missionRouteList = [
    "Game1",
    "Game2",
    "Game3",
    "Arithmetic",
    "TakePhoto",
    "Shake",
    "Blow"
  ];

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    var _frog = _prefs.getString("frog");
    bool _hasLogin = _prefs.getBool("hasLogin");
    int _userId = _prefs.getInt("userId");
    String _token = _prefs.getString("token");
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
    if(_hasLogin == null){
      hasLogin = false;
    }
    else{
      hasLogin = _hasLogin;
    }
    if(_userId != null){
      userId = _userId;
    }
    else{
      userId = null;
    }
    if(_token != null){
      token = _token;
    }
    else{
      token = null;
    }
    if(_frog != null){
      frog = Frog.fromJson(jsonDecode(_frog));
    }
    else{
      frog = null;
    }
    methodChannel = MethodChannel("Channel");

    initDB();
  }
  static saveProfile() =>
      _prefs.setString("profile", jsonEncode(profile.toJson()));

  static saveFrog() =>
      _prefs.setString("frog", jsonEncode(frog.toJson()));

  static saveHasLogin(bool flag){
     _prefs.setBool("hasLogin", flag);
  }

  static saveToken(String token){
    _prefs.setString("token", token);
  }

  static saveAlarm(AlarmInfo alarm){
    db.insert("alarms", alarm.toJson());
  }

  static saveUserId(int userId){
    _prefs.setInt("userId", userId);
  }

  static Future<void> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'local.db';

    //根据数据库文件路径和数据库版本号创建数据库表
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE alarms (
            alarmId INTEGER PRIMARY KEY autoincrement,
            label TEXT,
            repeat TEXT,
            time TEXT,
            mission TEXT,
            audio TEXT,
            vibration BOOL,
            isOpen BOOL)
          ''');
          print("create table alarm");
        });

    initList();
  }
  
  static void clearDB() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'local.db';

    //根据数据库文件路径和数据库版本号创建数据库表
    db.execute('''
            DELETE FROM alarms WHERE alarmId > 0
          ''');
    print("drop table alarms");
  }
  
  static void initList() async {
    print("initial list");
    List<Map<String, dynamic>> maps = await db.query("alarms");
    maps.forEach((element) {
      print(element);
      AlarmInfo alarmInfo = AlarmInfo.fromJson(element);
      alarmList.add(alarmInfo);
    });
  }

  static int nextAlarmTime(int targetHour, int targetMinute, List<String> repeat){
    bool hasPassed = true;
    var today = DateTime.now();
    int weekday = today.weekday;
    int hour = today.hour;
    int minute = today.minute;

    if(hour < targetHour || (hour == targetHour && minute < targetMinute)){
      hasPassed = false;
    }

    List<int> repeatDays = [];
    if (repeat.isEmpty || repeat[0] == ""){
      if(hasPassed){
        return 1;
      }
      else
        return 0;
    }
    else{
      repeat.forEach((element) {
        switch(element){
          case "周一": repeatDays.add(1); break;
          case "周二": repeatDays.add(2); break;
          case "周三": repeatDays.add(3); break;
          case "周四": repeatDays.add(4); break;
          case "周五": repeatDays.add(5); break;
          case "周六": repeatDays.add(6); break;
          case "周日": repeatDays.add(7); break;
          default: break;
        }
      });
      if(repeatDays.contains(weekday)&& !hasPassed){
        return 0;
      }
      else{
        int returnValue = 0;
        for(int i= weekday%7+1;i!=weekday;i=i%7+1){
          returnValue++;
          if(repeatDays.contains(i)){
            return returnValue;
          }
        }
        if(repeatDays.contains(weekday)&& hasPassed){
          return 7;
        }
        else {
          return 8;
        }
      }
    }
  }
}
