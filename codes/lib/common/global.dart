import 'dart:convert';
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
  static Database db;
  static var methodChannel;
  static AudioPlayer advancedPlayer1 = new AudioPlayer();
  static AudioCache audioCache1= new AudioCache(prefix: "audios/",fixedPlayer: advancedPlayer1);
  static List<AlarmInfo> alarmList = [
    // AlarmInfo(1, "起床", ["周一", "周二", "周三", "周四", "周五"],TimeOfDay(hour: 6, minute: 30),"算术题","audio1",true,false),
    // AlarmInfo(2, "班级会议", ["周三"],TimeOfDay(hour: 21, minute: 30),"随机任务","audio3",true,false),
    // AlarmInfo(3, "高数作业DDL", ["周日"],TimeOfDay(hour: 23, minute: 30),"小游戏","audio5",true,false)
  ];
  static List<String> missionRouteList = [
    "Game",
    "Arithmetic",
    "TakePhoto",
    "Shake"
  ];

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    var _frog = _prefs.getString("frog");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
        frog = Frog.fromJson(jsonDecode(_frog));
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
      rootBundle.loadString('jsons/frog.json').then((String value){
        Map<String,dynamic> tmp = jsonDecode(value);
        frog = Frog.fromJson(tmp);
      });
    }
    methodChannel = MethodChannel("Channel");

    initDB();
  }
  static saveProfile() =>
      _prefs.setString("profile", jsonEncode(profile.toJson()));

  static saveFrog() =>
      _prefs.setString("frog", jsonEncode(frog.toJson()));

  static void initDB() async {
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
        });

    initList();
  }

  static void initList() async {
    List<Map<String, dynamic>> maps = await db.query("alarms");
    maps.forEach((element) {
      print(element);
      AlarmInfo alarmInfo = AlarmInfo.fromJson(element);
      alarmList.add(alarmInfo);
    });
  }
}
