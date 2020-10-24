import 'package:flutter/material.dart';
import '../Class/AlarmInfo.dart';
import 'package:easy_dialog/easy_dialog.dart';


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
    _alarmList[widget.alarmIndex] = alarmInfo;
  }

  void deleteAlarm(){
    EasyDialog(
      fogOpacity: 0.12,
      width: 330,
      height: 140,
      closeButton: false,
      title: Text(
        "删除闹钟",
        style: TextStyle(fontSize: 20),
      ),
      description: Text(
        "您确定要删除闹钟吗？"
      ),
      contentList: [
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 90,
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
                width: 90,
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
      deleteButtonWidth = 40;
    });
  }

  void zoomOutAlarm(){
    setState(() {
      isAnimated = false;
      deleteButtonWidth = 0;
    });
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
          horizontalMove += details.delta.dx;
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
          width: 400,
          margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: deleteButtonWidth,
                height: 100,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: IconButton(
                  icon: Icon(Icons.alarm_off),
                  color: Colors.red,
                  iconSize: 28,
                  onPressed: () => {
                    deleteAlarm()
                  },
                ),
              ),
              AnimatedContainer(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                duration: Duration(milliseconds: 200),
                width: isAnimated?350:390,
                child: Card(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: isAnimated?340:380,
                        child: Text(
                          alarmInfo.label,
                          textAlign: TextAlign.left,
                          maxLines:1,
                          overflow:TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 24.0,
                            color: Colors.black45,
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: isAnimated?340:380,
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                width: isAnimated?256:296,
                                child: new Text(
                                  timeToString(alarmInfo.time),
                                  style: const TextStyle(fontSize: 46.0, fontFamily: 'Miriam'),
                                ),
                                margin: EdgeInsets.fromLTRB(15, 7.5, 5, 7.5),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                child: new Switch(value: alarmInfo.isOpen, onChanged: _switchAlarm),
                                width: 64,
                              )
                            ]
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: isAnimated?340:380,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: Text(
                                  repeat,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.cyan,
                                  ),
                                )
                            ),
                            VerticalDivider(
                              color: Colors.black45,
                              width: 20,
                            ),
                            Container(
                                child: Text(
                                  alarmInfo.mission,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.cyan,
                                  ),
                                )
                            ),
                          ],
                        ),
                        height: 30,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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

