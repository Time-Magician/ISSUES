import 'dart:math';
import 'dart:typed_data';

import 'package:demo5/common/global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';

class StudyRoomWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyStudyRoomWidget();
  }
}

class MyStudyRoomWidget extends State<StudyRoomWidget>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xFF75CCE8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "ISSUES",
          style: TextStyle(fontSize: ScreenUtil().setSp(60.0), fontFamily: 'Knewave'),
        ),
      ),
      body: StudyRoom(),
    );
  }
}

class StudyRoom extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyStudyRoom();
  }
}

class MyStudyRoom extends State<StudyRoom>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Global.methodChannel.setMethodCallHandler((call) {
      if(call.method != "test")
        return;
      print(call.arguments);
      String _id = call.arguments;
      int id = int.parse(_id);
      int index = Global.alarmList.indexWhere((element) => element.alarmId == id);

      int hour = Global.alarmList[index].time.hour;
      int minute = Global.alarmList[index].time.minute;
      List<String> repeat= Global.alarmList[index].repeat;

      if(repeat.isEmpty || repeat[0]==''){
        Global.alarmList[index].isOpen=!Global.alarmList[index].isOpen;
      }
      else {
        int timeSpan = Global.nextAlarmTime(hour, minute, repeat);
        Global.methodChannel.invokeMethod("startAlarm", {
          "hour": hour,
          "minute": minute,
          "alarmIndex": id.toString(),
          "timeSpan": timeSpan
        });
      }

      String mission = Global.alarmList[index].mission;
      Global.audioCache1.loop(Global.alarmList[index].audio+".mp3");
      switch(mission){
        case "算术题": Navigator.pushNamed(context, "Arithmetic");break;
        case "小游戏": Navigator.pushNamed(context, "Game");break;
        case "指定物品拍照": Navigator.pushNamed(context, "TakePhoto");break;
        case "摇晃手机": Navigator.pushNamed(context, "Shake");break;
        case "随机任务": Navigator.pushNamed(context, Global.missionRouteList[(new Random()).nextInt(4)]);break;
        default: break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              child: SizedBox(
                  height: ScreenUtil().setHeight(320),
                  width: ScreenUtil().setWidth(640),
                  child: RaisedButton(
                      textTheme: ButtonTextTheme.accent,
                      color: const Color(0xFF33539E),
                      highlightColor: Colors.deepPurpleAccent,
                      splashColor: Colors.deepOrangeAccent,
                      colorBrightness: Brightness.dark,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(16))
                      ),
                      onPressed: () {
                        //TODO
                        Navigator.pushNamed(context, "Blow");
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.business,
                            size: ScreenUtil().setWidth(128),
                            color: Colors.white,
                          ),
                          Text(
                            '公 共 自 习 室',
                            style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(72)),
                          ),
                        ],
                      )
                  )),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, ScreenUtil().setHeight(80), 0, 0),
            child: SizedBox(
                height: ScreenUtil().setHeight(320),
                width: ScreenUtil().setWidth(640),
                child: RaisedButton(
                    textTheme: ButtonTextTheme.accent,
                    color: const Color(0xFF26A65B),
                    highlightColor: Colors.deepPurpleAccent,
                    splashColor: Colors.deepOrangeAccent,
                    colorBrightness: Brightness.dark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(16))
                    ),
                    onPressed: () {
                      //TODO
                      // Navigator.pushNamed(context, "Game3");
                      Global.saveHasLogin(false);
                      Global.hasLogin = false;
                      Global.clearDB();
                      Navigator.pushNamed(context, "Login");
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.people,
                          size: ScreenUtil().setWidth(128),
                          color: Colors.white,
                        ),
                        Text(
                          '小 组 学 习 室',
                          style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(72)),
                        ),
                      ],
                    )
                )),
          )
        ],
      ),
    );
  }
}

