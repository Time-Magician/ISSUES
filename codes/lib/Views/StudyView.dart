import 'dart:math';

import 'package:dio/dio.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import '../Class/StudyInfo.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import '../common/global.dart';
import 'package:demo5/index.dart';

StudyInfo studyInfo = new StudyInfo(Global.frog, false);
AudioCache audioPlayer;
AudioPlayer advancedPlayer1 = new AudioPlayer();
AudioCache audioCache1= new AudioCache(prefix: "audios/",fixedPlayer: advancedPlayer1);
MethodChannel platform = const MethodChannel('Channel');

class StudyView extends StatefulWidget {
  final blockNavi;
  const StudyView({Key key, this.blockNavi}) : super(key: key);

  @override
  createState() => new MyStudyView();
}

class MyStudyView extends State<StudyView> {
  int totalTime = 0;
  int exp = 70;

  _updateTime(int end) {
    setState(() {
      totalTime = end;
    });
  }

  _showDiploma(){
    Navigator.pushNamed(context, "Diplomas");
  }

  _startEndStudy(){
    studyInfo.isStudying = !studyInfo.isStudying;
    this.setState(() {

    });
    widget.blockNavi();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ignore: missing_return
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF75CCE8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "ISSUES",
            style: TextStyle(fontSize: ScreenUtil().setSp(60.0), fontFamily: 'Knewave'),
          ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.school),
            tooltip: 'Show Diplomas',
            onPressed: _showDiploma,
          ),
        ],
      ),
      body:Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(700),
                height: ScreenUtil().setWidth(160),
                child: ProgressBlock()
            ),
            Expanded(
              child: Container(
                  child: FrogBlock(updateTime:  (end) => _updateTime(end))
              ),
            ),
            Container(
                width: ScreenUtil().setWidth(720),
                height: ScreenUtil().setWidth(168),
                child: TimerBlock(totalTime: this.totalTime, onDone: () => _startEndStudy())
            ),
            Container(
                width: ScreenUtil().setWidth(560),
                height: ScreenUtil().setWidth(120),
                margin: EdgeInsets.fromLTRB(0, 0, 0, ScreenUtil().setWidth(20)),
                child: BtnBlock(onPress: () => _startEndStudy())
            ),
          ]
      ),
    );
  }
}

class ProgressBlock extends StatefulWidget{
  const ProgressBlock({Key key}) : super(key: key);

  @override
  createState() => new MyProgressBlock();
}

class MyProgressBlock extends State<ProgressBlock>{
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
            children: <Widget>[
              Container(
                  width: ScreenUtil().setWidth(280),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Global.frog.name+" Lv "+level[Global.frog.level],
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(32.0),
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        Global.frog.level<=12?"正在备考 "+Global.frog.school:"正在修读 "+Global.frog.school,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28.0),
                          color: Colors.black,
                        ),
                      )
                    ],
                  )
              ),
              Container(
                  width: ScreenUtil().setWidth(380),
                  height: ScreenUtil().setWidth(36),
                  child: FAProgressBar(
                    backgroundColor: Colors.white,
                    currentValue: Global.frog.exp,
                    maxValue: 100,
                    changeColorValue: 60,
                    displayText: '%',
                  )
              ),]
        )
    );
  }
}

class FrogBlock extends StatefulWidget{
  final updateTime;
  const FrogBlock({Key key, this.updateTime}) : super(key: key);

  @override
  createState() => new MyFrogBlock();
}

class MyFrogBlock extends State<FrogBlock>{

  void _updateLabels(int init, int end, int a) {
    // print(end);
    if(!studyInfo.isStudying)
      widget.updateTime(end);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            backgroundColor: const Color(0xFF75CCE8),
            body: Center(
              child: Container(
                  child: studyInfo.isStudying?
                  Container(
                      padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(12), ScreenUtil().setWidth(12), ScreenUtil().setWidth(12), ScreenUtil().setWidth(12)),
                      child: LayoutBuilder(
                        builder: (context, constrains){
                            return new CircularProfileAvatar(
                              '',
                              child: Image.asset(
                                  Global.frog.level < 7?
                                  'assets/image/frogStudy1.png' :(
                                      Global.frog.level < 10?
                                      'assets/image/frogStudy2.png':(
                                          Global.frog.level < 13?
                                          'assets/image/frogStudy3.png':
                                          'assets/image/frogStudy4.png'
                                      )),
                              ), //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                              radius: ScreenUtil().setWidth(constrains.maxHeight < constrains.maxWidth? constrains.maxHeight-25:constrains.maxWidth-25), // sets radius, default 50.0
                              backgroundColor: Color(0xFF75CCE8), // sets background color, default Colors.white
                              borderWidth: ScreenUtil().setWidth(25),  // sets border, default 0.0// sets initials text, set your own style, default Text('')
                              borderColor: Color.fromRGBO(255, 255, 255, 1.0), // sets border color, default Colors.white// sets elevation (shadow of the profile picture), default value is 0.0//sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent// allow widget to cache image against provided url// sets on tap// setting it true will show initials text above profile picture, default false
                            );
                        })
                  ) : SingleCircularSlider(
                    120, 0,
                    height: ScreenUtil().setWidth(600.0),
                    width: ScreenUtil().setWidth(600.0),
                    handlerColor: Color.fromRGBO(255, 255, 255, 1.0),
                    baseColor: Color.fromRGBO(255, 255, 255, 0.3),
                    selectionColor: Color.fromRGBO(255, 255, 255, 0.5),
                    onSelectionChange:  _updateLabels,
                    child: ClipOval( //圆形头像
                      child: Image.asset(
                        Global.frog.level < 7?
                        'assets/image/frogPlay1.png' :(
                            Global.frog.level < 10?
                            'assets/image/frogPlay2.png':(
                                Global.frog.level < 13?
                                'assets/image/frogPlay3.png':
                                'assets/image/frogPlay4.png'
                            )),
                      ),
                    ),
                  )
              ),
            )
        )
    );
  }
}

class TimerBlock extends StatefulWidget{
  final int totalTime;
  final onDone;
  const TimerBlock({Key key, this.totalTime, this.onDone}) : super(key: key);

  @override
  createState() => new MyTimerBlock();
}

class MyTimerBlock extends State<TimerBlock>{
  int totalMinute;
  int hourLeft;
  int minuteLeft;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String getMinute(){
    if(this.minuteLeft < 10)
      return "0"+this.minuteLeft.toString();
    else
      return this.minuteLeft.toString();
  }

  String getHour(){
    if(this.hourLeft < 10)
      return "0"+this.hourLeft.toString();
    else
      return this.hourLeft.toString();
  }

  updateFrog() async{
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    String url = "http://10.0.2.2:9000/study-service/user/"+Global.userId.toString()+"/frog";
    FormData formData = FormData.fromMap({"name":Global.frog.name,"level":Global.frog.level,"exp":Global.frog.exp,"is_graduated":Global.frog.isGraduated,"graduate_date":Global.frog.graduateDate,"school":Global.frog.school});
    dio.put(url,data: formData);
  }

  void onDone(){
    getEndTime();
    if(Global.frog.level < 17){
      int exp = totalMinute ~/ 1;
      Global.frog.exp += exp;
      if(Global.frog.exp >= 100) {
        Global.frog.exp -= 100;
        Global.frog.level += 1;
        if(Global.frog.level == 17){
          Global.frog.exp = 100;
          Global.frog.isGraduated = true;
        }
      }
      Global.saveFrog();
      updateFrog();
    }

    EasyDialog(
      fogOpacity: 0.12,
      width: ScreenUtil().setWidth(640),
      height: ScreenUtil().setWidth(320),
      closeButton: false,
      title: Text(
        "完成学习",
        style: TextStyle(fontSize: ScreenUtil().setSp(40)),
      ),
      description: Text(
          "你的小青蛙已经成功完成了 $totalMinute 分钟的学习！",
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
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
    endLockService();
    widget.onDone();
    putRequestAddStudyRecord(totalMinute);
  }

  @override
  Widget build(BuildContext context) {
    totalMinute = widget.totalTime;
    minuteLeft = widget.totalTime%60;
    hourLeft = widget.totalTime~/60;

    return Center(
      child: Container(
          height: ScreenUtil().setWidth(140),
          child: studyInfo.isStudying?
          Container(
            width: ScreenUtil().setWidth(600),
            alignment: Alignment.center,
            child: SlideCountdownClock(
              duration: Duration(minutes: totalMinute),
              slideDirection: SlideDirection.Up,
              separator: ":",
              textStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(96), fontFamily: "Miriam"
              ),
              shouldShowDays: false,
              onDone: onDone,
            ),
          ) :Container(
            width: ScreenUtil().setWidth(600),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  getHour(),
                  style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(96), fontFamily: "Miriam"),
                ),
                SizedBox(width: ScreenUtil().setWidth(6)),
                Text(":",style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(96), fontFamily: "Miriam")),
                SizedBox(width: ScreenUtil().setWidth(6)),
                Text(
                  getMinute(),
                  style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(96), fontFamily: "Miriam"),
                ),
                SizedBox(width: ScreenUtil().setWidth(6)),
                Text(":",style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(96), fontFamily: "Miriam")),
                SizedBox(width: ScreenUtil().setWidth(6)),
                Text("00",style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(96), fontFamily: "Miriam"))
              ],
            ),
          )
      ),
    );
  }
}

class BtnBlock extends StatefulWidget{
  final onPress;
  BtnBlock({Key key, this.onPress}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyBtnBlock();
  }
}

class MyBtnBlock extends State<BtnBlock>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // audioCache1.load('audio3.mp3');
  }

  void endStudy(){
    EasyDialog(
      fogOpacity: 0.12,
      width: ScreenUtil().setWidth(640),
      height: ScreenUtil().setWidth(320),
      closeButton: false,
      title: Text(
        "终止学习",
        style: TextStyle(fontSize: ScreenUtil().setSp(40)),
      ),
      description: Text(
          "您确定要终止学习吗？您将不会得到任何经验值。"
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
                    endLockService();
                    Navigator.of(context).pop();
                    widget.onPress();
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      SizedBox(
          child: studyInfo.isStudying? RaisedButton(
            textTheme: ButtonTextTheme.accent,
            color: Colors.deepOrangeAccent,
            highlightColor: Colors.deepPurpleAccent,
            splashColor: const Color(0xFF33539E),
            colorBrightness: Brightness.dark,
            onPressed: endStudy,
            child: Text(
              '终 止 学 习',
              style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(56)),
            ),
          ) : RaisedButton(
            textTheme: ButtonTextTheme.accent,
            color: const Color(0xFF33539E),
            highlightColor: Colors.deepPurpleAccent,
            splashColor: Colors.deepOrangeAccent,
            colorBrightness: Brightness.dark,
            onPressed: () {
              //TODO
              getStartTime();
              startLockService();
              widget.onPress();
            },
            child: Text(
              '开 始 学 习',
              style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(56)),
            ),
          ));
  }
}

Future<Null> startLockService() async {
  try {
    final result = await platform.invokeMethod("startStudy");
    // batteryLevel = 'Battery level at $result % .';
  } on PlatformException catch (e) {
    print('${e.message}');
  }

}

void getStartTime(){
  DateTime dateTime= DateTime.now();
  Global.studyStartTime = dateTimeToString(dateTime);
}

void getEndTime(){
  DateTime dateTime= DateTime.now();
  Global.studyEndTime = dateTimeToString(dateTime);
}

String dateTimeToString(DateTime date){
  int year = date.year;
  int month = date.month;
  int day = date.day;

  String ret = year.toString()+"-"+month.toString()+"-"+day.toString();
  print(ret);
  return ret;
}

void putRequestAddStudyRecord(int duration) async {
  Dio dio = new Dio();
  dio.options.headers["authorization"] = "Bearer "+Global.token;
  FormData formData = FormData.fromMap({'start_time': Global.studyStartTime, 'end_time': Global.studyEndTime, 'frog_id': Global.frog.frogId, 'duration': duration});
  String url ="http://10.0.2.2:9000/study-service/user/"+Global.userId.toString()+"/studyRecord";
  Response response = await dio
      .put(url, data: formData);
  var result = response.data.toString();
  print(result);
}

Future<Null> endLockService() async {
  try {
    final result = await platform.invokeMethod("stopStudy");
    // batteryLevel = 'Battery level at $result % .';
  } on PlatformException catch (e) {
    print('${e.message}');
  }

}



