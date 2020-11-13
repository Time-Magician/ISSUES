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

StudyInfo studyInfo = new StudyInfo(new Frog("陈二狗", 15, 78, false, "", "氢化大学"), false);
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
      if(call.method == "test")
        print(call.arguments);
      audioCache1.play('audio1.mp3');
      Navigator.pushNamed(context, "Diplomas");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF75CCE8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('学习哇'),
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
                        studyInfo.frog.name+" Lv "+level[studyInfo.frog.level],
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(32.0),
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        studyInfo.frog.level<=12?"正在备考 "+studyInfo.frog.school:"正在修读 "+studyInfo.frog.school,
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
                    currentValue: studyInfo.frog.exp,
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
                                'assets/image/frog2.png',
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
                        'assets/image/frog2.png',
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

  void onDone(){
    endLockService();
    widget.onDone();
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

Future<Null> endLockService() async {
  try {
    final result = await platform.invokeMethod("stopStudy");
    // batteryLevel = 'Battery level at $result % .';
  } on PlatformException catch (e) {
    print('${e.message}');
  }

}



