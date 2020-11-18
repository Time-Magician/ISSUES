import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
// import '../Class/AlarmInfo.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/global.dart';
import 'package:sqflite/sqflite.dart';
import 'package:demo5/models/index.dart';
import 'dart:io';



List<AlarmInfo> _alarmList = Global.alarmList;

// List<AlarmInfoStorage> _alarmStoredList = [
//   toStorage(_alarmList[0]),
//   toStorage(_alarmList[1]),
//   toStorage(_alarmList[2]),
// ];




class AlarmView extends StatefulWidget {
  @override
  createState() => new AlarmList();
}

class AlarmList extends State<AlarmView> {
  int alarmCount;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ignore: missing_return
    Global.methodChannel.setMethodCallHandler((call) {
      if(call.method == "test")
        print(call.arguments);
      String _id = call.arguments;
      int id = int.parse(_id);
      int index = Global.alarmList.indexWhere((element) => element.alarmId == id);
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

  void addAlarm() async {
    final result = await Navigator.pushNamed(context,"AlarmSetting",arguments:
      AlarmInfo(null ,"闹钟", [], TimeOfDay.now(), "算术题", "audio1", true, false),
    );

    if(result.runtimeType != AlarmInfo) return;

    AlarmInfo newAlarmInfo = result as AlarmInfo;

    var id = await Global.db.insert("alarms", newAlarmInfo.toJson());
    print("add alarm: $id");
    newAlarmInfo.alarmId = id;
    _alarmList.add(newAlarmInfo);

    setState(() {

    });

    TimeOfDay time = newAlarmInfo.time;
    String data = await Global.methodChannel.invokeMethod("startAlarm",{"hour":time.hour,"minute":time.minute,"alarmIndex":id.toString()});
    print("data: $data");

  }

  void deleteAlarm(int alarmId){
    print("delete alarm: $alarmId");
    Global.db.delete("alarms", where: "alarmId = ?", whereArgs: [alarmId]);
    this.setState(() {

    });
  }
  
  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "ISSUES",
            style: TextStyle(fontSize: ScreenUtil().setSp(60.0), fontFamily: 'Knewave'),
          ),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.add_alarm),
                tooltip: 'Add Alarm',
                onPressed: addAlarm,
            ),
          ],
        ),
        backgroundColor: const Color(0xFF75CCE8),
        body: ListView.builder(
          itemCount: _alarmList.length,
          itemBuilder: (BuildContext context,int index) =>
            AlarmWidget(alarmIndex: index, callbackFunc: deleteAlarm,)
          ,
        ),

    );
  }
}

class AlarmWidget extends StatefulWidget{
  final Function callbackFunc;
  final int alarmIndex;
  const AlarmWidget({Key key, this.alarmIndex, this.callbackFunc}) : super(key: key);

  @override
  createState() => new Alarm();

}

class Alarm extends State<AlarmWidget> with TickerProviderStateMixin {
  String repeat = "";
  bool isAnimated = false;
  AlarmInfo alarmInfo;
  double deleteButtonWidth;
  bool refreshFlag = false;
  double horizontalMove = 0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    deleteButtonWidth = 0;
  }

  void _switchAlarm(isOpen){
    bool isOpen = this.alarmInfo.isOpen? false : true;
    alarmInfo.isOpen = isOpen;
    _alarmList[widget.alarmIndex].isOpen = isOpen;

    setState(() {
    });
    int hour = _alarmList[widget.alarmIndex].time.hour;
    int minute = _alarmList[widget.alarmIndex].time.minute;
    int id = _alarmList[widget.alarmIndex].alarmId;

    setAlarm(hour, minute, isOpen, id);
  }

  String timeToString(TimeOfDay time){
    int hour = time.hour;
    int minute = time.minute;
    String hourS;
    String minuteS;

    if(hour < 10)
      hourS = "0"+hour.toString();
    else
      hourS = hour.toString();

    if(minute < 10)
      minuteS = "0"+minute.toString();
    else
      minuteS = minute.toString();

    return hourS + ":" + minuteS;
  }

  void editAlarm() async {
    final result = await Navigator.pushNamed(
        context,"AlarmSetting",
        arguments:_alarmList[widget.alarmIndex]
    );

    if(result.runtimeType != AlarmInfo) return;

    AlarmInfo newAlarmInfo = result as AlarmInfo;
    this.setState(() {
      alarmInfo = newAlarmInfo;
    });

    _alarmList[widget.alarmIndex] = newAlarmInfo;
    int alarmId = newAlarmInfo.alarmId;
    await Global.db.update("alarms", newAlarmInfo.toJson(), where: "alarmId = ?", whereArgs: [alarmId]);
    print("update alarm: $alarmId");

    if(newAlarmInfo.isOpen){
      TimeOfDay time = newAlarmInfo.time;
      String data = await Global.methodChannel.invokeMethod("startAlarm",{"hour":time.hour,"minute":time.minute,"alarmIndex":alarmId.toString()});
      print("data: $data");
    }
  }

  void cancelAlarm(int index)async{
    TimeOfDay time = _alarmList[index].time;
    int id = _alarmList[index].alarmId;
    String data = await Global.methodChannel.invokeMethod("cancelAlarm",{"hour":time.hour,"minute":time.minute,"alarmIndex":id.toString()});
    print("data: $data");
  }

  void deleteAlarm(){
    EasyDialog(
      fogOpacity: 0.12,
      width: ScreenUtil().setWidth(660),
      height: ScreenUtil().setHeight(280),
      closeButton: false,
      title: Text(
        "删除闹钟",
        style: TextStyle(fontSize: ScreenUtil().setSp(40)),
      ),
      description: Text(
        "您确定要删除闹钟吗？",
        style: TextStyle(fontSize: ScreenUtil().setSp(32)),
      ),
      contentList: [
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(180),
                child: FlatButton(
                  onPressed: () {
                    zoomAlarm();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "取消",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(180),
                child: FlatButton(
                  onPressed: () {
                    if(_alarmList[widget.alarmIndex].isOpen) cancelAlarm(widget.alarmIndex);
                    int id = _alarmList[widget.alarmIndex].alarmId;
                    _alarmList.removeAt(widget.alarmIndex);
                    widget.callbackFunc(id);
                    this.setState(() {
                    });
                    zoomAlarm();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "确认",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ]
        )
      ],
    ).show(context);
  }

  void zoomAlarm(){
    if(!isAnimated){
      zoomInAlarm();
    } else {
      zoomOutAlarm();
    }
  }

  void zoomInAlarm(){
    setState(() {
      isAnimated = true;
      deleteButtonWidth = ScreenUtil().setWidth(80);
    });
  }

  void zoomOutAlarm(){
    setState(() {
      isAnimated = false;
      deleteButtonWidth = 0;
    });
  }

  void setAlarm(int hour,int minute,bool isOpen,int id) async{
    if(Platform.isAndroid) {

      // ignore: missing_return

      if(isOpen){
      String data = await Global.methodChannel.invokeMethod("startAlarm",{"hour":hour,"minute":minute,"alarmIndex":id.toString()});
      print("data: $data");
      }else{
        String data = await Global.methodChannel.invokeMethod("cancelAlarm",{"hour":hour,"minute":minute,"alarmIndex":id.toString()});
        print("data: $data");
      }
    }
  }

  @override
  Widget build(BuildContext context){
    repeat = "";
    alarmInfo = _alarmList[widget.alarmIndex];

    if(alarmInfo.repeat.isEmpty){
      repeat = "从不";
    } else if(alarmInfo.repeat.length == 7){
      repeat = "每天";
    } else {
      alarmInfo.repeat.forEach((element) {
        repeat += element + " ";
      });
    }

    return Center(
      child: GestureDetector(
        onTap: (() => {
          editAlarm()
        }),
        onLongPress: (() => {
          zoomAlarm()
        }),
        onHorizontalDragUpdate: ((DragUpdateDetails details) {
          // print(details.globalPosition);
          horizontalMove += ScreenUtil().setWidth(details.delta.dx);
          if(horizontalMove > 50 && !isAnimated){
            zoomInAlarm();
            horizontalMove = 0;
          } else if(horizontalMove < -50){
            zoomOutAlarm();
            horizontalMove = 0;
          }
          return;
        }),
        child: Container(
          width: ScreenUtil().setWidth(690),
          height: ScreenUtil().setHeight(320),
          margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15), ScreenUtil().setHeight(10), ScreenUtil().setWidth(15), 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: deleteButtonWidth,
                height: ScreenUtil().setHeight(320),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: IconButton(
                  icon: Icon(Icons.alarm_off),
                  color: Colors.red,
                  iconSize: ScreenUtil().setWidth(50),
                  onPressed: () => {
                    deleteAlarm()
                  },
                ),
              ),
              AnimatedContainer(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                duration: Duration(milliseconds: 200),
                width: isAnimated?ScreenUtil().setWidth(610):ScreenUtil().setWidth(690),
                height: ScreenUtil().setHeight(320),
                child: Card(
                  margin: EdgeInsets.fromLTRB(0, ScreenUtil().setHeight(10), 0, ScreenUtil().setHeight(10)),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: isAnimated?ScreenUtil().setWidth(570):ScreenUtil().setWidth(650),
                        height: ScreenUtil().setHeight(60),
                        margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), ScreenUtil().setHeight(10),ScreenUtil().setWidth(20), 0),
                        child: Text(
                          alarmInfo.label,
                          textAlign: TextAlign.left,
                          maxLines:1,
                          overflow:TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ScreenUtil().setWidth(40.0),
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: isAnimated?ScreenUtil().setWidth(610):ScreenUtil().setWidth(690),
                        height: ScreenUtil().setHeight(150),
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                width: isAnimated?ScreenUtil().setWidth(442):ScreenUtil().setWidth(522),
                                height: ScreenUtil().setHeight(120),
                                margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(30), ScreenUtil().setHeight(15), ScreenUtil().setWidth(10), ScreenUtil().setHeight(15)),
                                alignment: Alignment.centerLeft,
                                child: new Text(
                                  timeToString(alarmInfo.time),
                                  style: TextStyle(fontSize: ScreenUtil().setSp(84.0), fontFamily: 'Miriam'),
                                ),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                child: new Switch(value: alarmInfo.isOpen, onChanged: _switchAlarm),
                                width: ScreenUtil().setWidth(128),
                                height: ScreenUtil().setHeight(150),
                              )
                            ]
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: isAnimated?ScreenUtil().setWidth(610):ScreenUtil().setWidth(690),
                        height: ScreenUtil().setHeight(60),
                        margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0, ScreenUtil().setWidth(20), ScreenUtil().setHeight(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: Text(
                                  repeat,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(32.0),
                                    color: Colors.cyan,
                                  ),
                                )
                            ),
                            VerticalDivider(
                              color: Colors.black54,
                              width: ScreenUtil().setWidth(20),
                            ),
                            Container(
                                child: Text(
                                  alarmInfo.mission,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(32.0),
                                    color: Colors.cyan,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    ));
  }
}

