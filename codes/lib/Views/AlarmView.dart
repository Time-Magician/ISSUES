import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:easy_dialog/easy_dialog.dart';
import '../common/global.dart';
import 'package:demo5/models/index.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart';



List<AlarmInfo> _alarmList = Global.alarmList;

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
    _alarmList = Global.alarmList;
    Global.methodChannel.setMethodCallHandler((call) {
      if(call.method != "test")
         return;
      print(call.arguments);
      String _id = call.arguments;
      int id = int.parse(_id);
      int index = Global.alarmList.indexWhere((element) => element.alarmId == id);
      String mission = Global.alarmList[index].mission;

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

      Global.audioCache1.loop(Global.alarmList[index].audio+".mp3");
      switch(mission){
        case "算术题": Navigator.pushNamed(context, "Arithmetic");break;
        case "小游戏": Navigator.pushNamed(context, "Game"+((new Random()).nextInt(3)+1).toString());break;
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
    int timeSpan = Global.nextAlarmTime(time.hour, time.minute, newAlarmInfo.repeat);
    Global.methodChannel.invokeMethod("startAlarm",{"hour":time.hour,"minute":time.minute,"alarmIndex":id.toString(),"timeSpan":timeSpan});

    int userId = Global.userId;
    int alarmId = newAlarmInfo.alarmId;
    String label = newAlarmInfo.label;
    String repeat = AlarmInfo.repeatToJson(newAlarmInfo.repeat);
    String mission = newAlarmInfo.mission;
    String audio = newAlarmInfo.audio;
    String _time = AlarmInfo.timeToJson(time)+":00";

    postRequestCreateAlarm(userId, alarmId, label, repeat, _time, mission, audio);

  }

  void postRequestCreateAlarm(int userId,int alarmId,String label,String repeat,String time,String mission ,String audio) async {
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    FormData formData = FormData.fromMap({'label': label, 'repeat': repeat, 'time': time, 'mission': mission, 'audio': audio});
    String url ="http://10.0.2.2:9000/alarm-service/user/"+userId.toString()+"/alarm/"+alarmId.toString();
    Response response = await dio
        .post(url, data: formData);
    var result = response.data.toString();
    print(result);
    setState(() {});
  }

  void deleteAlarm(int alarmId){
    print("delete alarm: $alarmId");
    Global.db.delete("alarms", where: "alarmId = ?", whereArgs: [alarmId]);
    this.setState(() {
    });
    int userId=Global.userId;
    deleteRequestDeleteAlarm(alarmId, userId);
  }

  void deleteRequestDeleteAlarm(int alarmId, int userId) async{
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    FormData formData = FormData.fromMap({'user_id': userId, 'alarm_id': alarmId});
    String url ="http://10.0.2.2:9000/alarm-service/user/"+userId.toString()+"/alarm/"+alarmId.toString();
    Response response = await dio
        .delete(url, data: formData);
    var result = response.data.toString();
    print(result);
    setState(() {});
  }

  @override
  Widget build(BuildContext context){
    List<AlarmInfo> _alarmList = Global.alarmList;
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: true);
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

  void _switchAlarm(isOpen) async{
    bool isOpen = this.alarmInfo.isOpen? false : true;
    alarmInfo.isOpen = isOpen;
    _alarmList[widget.alarmIndex].isOpen = isOpen;

    setState(() {
    });

    int alarmId = _alarmList[widget.alarmIndex].alarmId;
    await Global.db.update("alarms", _alarmList[widget.alarmIndex].toJson(), where: "alarmId = ?", whereArgs: [alarmId]);
    print("update alarm: $alarmId");

    int hour = _alarmList[widget.alarmIndex].time.hour;
    int minute = _alarmList[widget.alarmIndex].time.minute;
    int id = _alarmList[widget.alarmIndex].alarmId;
    List<String> repeat = _alarmList[widget.alarmIndex].repeat;

    int timeSpan = Global.nextAlarmTime(hour, minute, repeat);

    switchAlarm(hour, minute, isOpen, id, timeSpan);
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
      int timeSpan = Global.nextAlarmTime(time.hour, time.minute, newAlarmInfo.repeat);
      Global.methodChannel.invokeMethod("startAlarm",{"hour":time.hour,"minute":time.minute,"alarmIndex":alarmId.toString(),"timeSpan":timeSpan});
    }

    int userId=Global.userId;
    int _alarmId = newAlarmInfo.alarmId;
    String label = newAlarmInfo.label;
    String repeat = AlarmInfo.repeatToJson(newAlarmInfo.repeat);
    String mission = newAlarmInfo.mission;
    String audio = newAlarmInfo.audio;
    String _time = AlarmInfo.timeToJson(newAlarmInfo.time)+":00";

    putRequestUpdateAlarm(userId, alarmId, label, repeat, _time, mission, audio);
  }

  void putRequestUpdateAlarm(int userId,int alarmId,String label,String repeat,String time,String mission ,String audio) async {
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    FormData formData = FormData.fromMap({'user_id': userId, 'alarm_id': alarmId, 'label': label, 'repeat': repeat, 'time': time, 'mission': mission, 'audio': audio});
    String url ="http://10.0.2.2:9000/alarm-service/user/"+userId.toString()+"/alarm/"+alarmId.toString();
    Response response = await dio
        .put(url, data: formData);
    var result = response.data.toString();
    print(result);
    setState(() {});
  }

  void cancelAlarm(int index)async{
    TimeOfDay time = _alarmList[index].time;
    int id = _alarmList[index].alarmId;
    Global.methodChannel.invokeMethod("cancelAlarm",{"hour":time.hour,"minute":time.minute,"alarmIndex":id.toString()});

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

  void switchAlarm(int hour,int minute,bool isOpen,int id,int timeSpan) async{
    if(Platform.isAndroid) {
      // ignore: missing_return
      if(isOpen){

      String data = await Global.methodChannel.invokeMethod("startAlarm",{"hour":hour,"minute":minute,"alarmIndex":id.toString(),"timeSpan":timeSpan});
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
    if(alarmInfo.repeat.isEmpty || alarmInfo.repeat[0] == ""){
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

