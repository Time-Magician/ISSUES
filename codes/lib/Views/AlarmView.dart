import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import '../Class/AlarmInfo.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'dart:io';
import 'package:flutter/services.dart';


List<AlarmInfo> _alarmList = [
  AlarmInfo("起床", ["周一","周二","周三","周四","周五"],TimeOfDay(hour: 6, minute: 30),"算术题","二狗汪汪叫",true,true),
  AlarmInfo("班级会议", ["周三"],TimeOfDay(hour: 21, minute: 30),"随机任务","Audio 3",true,false),
  AlarmInfo("高数作业DDL", ["周日"],TimeOfDay(hour: 23, minute: 30),"小游戏","Audio 2",true,false),
  AlarmInfo("起床", ["周一","周二"],TimeOfDay(hour: 7, minute: 30),"算术题","Audio 1",true,false),
  AlarmInfo("起床", ["周一","周二"],TimeOfDay(hour: 8, minute: 30),"算术题","二狗汪汪叫",true,false)
];

class AlarmView extends StatefulWidget {
  @override
  createState() => new AlarmList();
}

class AlarmList extends State<AlarmView> {
  int alarmCount;

  void addAlarm() async {
    final result = await Navigator.pushNamed(context,"AlarmSetting",arguments:
      AlarmInfo("闹钟", ["周一"], TimeOfDay.now(), "算术题", "二狗汪汪叫", true, true),
    );

    if(result.runtimeType != AlarmInfo) return;

    AlarmInfo newAlarmInfo = result as AlarmInfo;
    _alarmList.add(newAlarmInfo);
    setState(() {

    });
  }

  void deleteAlarm(){
    print("delete");
    this.setState(() {

    });
  }
  
  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
          title: Text('闹钟'),
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
    // bool isOpen = this.alarmInfo.isOpen? false : true;
    alarmInfo.isOpen = isOpen;
    _alarmList[widget.alarmIndex].isOpen = isOpen;
    setState(() {
    });
    int hour= _alarmList[widget.alarmIndex].time.hour;
    int minute=_alarmList[widget.alarmIndex].time.minute;
    startAlarm(hour,minute);
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
        arguments: _alarmList[widget.alarmIndex]
    );

    if(result.runtimeType != AlarmInfo) return;

    AlarmInfo newAlarmInfo = result as AlarmInfo;
    this.setState(() {
      alarmInfo = newAlarmInfo;
    });
    print(newAlarmInfo.repeat);
    _alarmList[widget.alarmIndex] = alarmInfo;
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
                    _alarmList.removeAt(widget.alarmIndex);
                    widget.callbackFunc();
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

  void startAlarm(int hour,int minute) async{
    if(Platform.isAndroid) {
      var methodChannel = MethodChannel("com.example.demo5");
      String data = await methodChannel.invokeMethod("startAlarm",{"hour":hour,"minute":minute});
      print("data: $data");
    }
  }

  @override
  Widget build(BuildContext context){
    repeat = "";
    alarmInfo = _alarmList[widget.alarmIndex];

    if(alarmInfo.repeat.length == 7){
      repeat = "每天";
    }else {
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

