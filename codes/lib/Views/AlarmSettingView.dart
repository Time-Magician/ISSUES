import 'dart:math';

import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:day_picker/day_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../Utils/Adapt.dart';
import '../common/global.dart';
import 'package:demo5/models/index.dart';

const List<String> audios = [
  "audio1",
  "audio2",
  "audio3",
  "audio4",
  "audio5"
];

List<MissionItem> missionList = [
  MissionItem("算术题","assets/image/math.png","闹钟响起时会出现一道数学题，填写正确答案之后就能关闭闹钟。"),
  MissionItem("唱歌","assets/image/music.png","闹钟响起时需要对着麦克风唱歌，跟唱15秒之后就能关闭闹钟。"),
  MissionItem("小游戏","assets/image/game.png","闹钟响起时需要玩连连看、消消乐等小游戏，获得足够的积分之后就能关闭闹钟。"),
  MissionItem("指定物品拍照","assets/image/camera.png","闹钟响起后，需要拍一张指定物品的照片并上传，识别正确后就能关闭闹钟。"),
  MissionItem("随机任务","assets/image/random.png","闹钟任务会从任务库中随机指定，完成对应任务之后即可关闭闹钟。"),
  MissionItem("摇晃手机","assets/image/shake.png","闹钟响起后需要连续不断快速摇晃手机，达到一定次数后即可关闭闹钟。"),
];

AlarmInfo newAlarmInfo;

class AlarmSettingWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AlarmSetting();
  }

}

class AlarmSetting extends State<AlarmSettingWidget>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AlarmInfo alarmInfo = ModalRoute.of(context).settings.arguments;
    Adapt.onepx();

    newAlarmInfo = new AlarmInfo(
      alarmInfo.alarmId,
      alarmInfo.label,
      alarmInfo.repeat,
      alarmInfo.time,
      alarmInfo.mission,
      alarmInfo.audio,
      alarmInfo.vibration,
      true,
    );

    void cancelAlarm(AlarmInfo alarmInfo) async {
      TimeOfDay time = alarmInfo.time;
      String data = await Global.methodChannel.invokeMethod("cancelAlarm",{"hour":time.hour,"minute":time.minute,"alarmIndex":""});
      print("data: $data");
    }

    void saveSettings(){
      if(alarmInfo.isOpen){
        cancelAlarm(alarmInfo);
      }
      Navigator.of(context).pop(newAlarmInfo);
    }



    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {Navigator.of(context).pop()}),
        title: Text('闹钟设置'),
        actions: <Widget>[
          new MaterialButton(
            child: Text(
              "保存",
              style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(36)),
            ),
            onPressed: (() => {
              saveSettings()
            }),
          ),
        ],
      ),
      body: Settings(alarmInfo: alarmInfo),
    );
  }
}

class Settings extends StatefulWidget{
  final alarmInfo;
  const Settings({Key key, this.alarmInfo}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MySettings();
  }
}

class MySettings extends State<Settings>{
  TimeOfDay _time;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _time = widget.alarmInfo.time;
  }

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
    newAlarmInfo.time = newTime;
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:SingleChildScrollView(
            child:Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  GestureDetector(
                      onTap: (() => {
                        Navigator.of(context).push(
                          showPicker(
                            is24HrFormat: true,
                            context: context,
                            value: _time,
                            onChange: onTimeChanged,
                          ),
                        )
                      }),
                      child: Container(
                          height: ScreenUtil().setHeight(180),
                          margin: EdgeInsets.fromLTRB(0, ScreenUtil().setWidth(100), 0, ScreenUtil().setWidth(100)),
                          child:Text(
                            timeToString(_time),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(140), fontFamily: "Miriam"),
                          )
                      )
                  ),
                  OrderTitle(title: "标签", icon: Icons.loyalty, subtitle: widget.alarmInfo.label, onClick: "label"),
                  OrderTitle(title: "铃声", icon: Icons.audiotrack, subtitle: widget.alarmInfo.audio, onClick: "audio"),
                  OrderTitle(title: "重复", icon: Icons.calendar_today, subtitle: generateRepeat(widget.alarmInfo.repeat), onClick: "repeat"),
                  OrderTitle(title: "振动", icon: Icons.notifications_active, subtitle: widget.alarmInfo.vibration == true?"是":"否", onClick: "vibration"),
                  OrderTitle(title: "任务", icon: Icons.games, subtitle: widget.alarmInfo.mission, onClick: "mission"),
                ],
              ),
            )
        )
    );
  }
}

class OrderTitle extends StatefulWidget{
  final title;
  final subtitle;
  final icon;
  final onClick;
  const OrderTitle({Key key, this.title, this.subtitle, this.icon, this.onClick}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyOrderTitle();
  }

}

class MyOrderTitle extends State<OrderTitle>{
  String label = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    label = widget.subtitle;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      // margin: EdgeInsets.only(top:10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom:BorderSide(width: 1,color:Colors.black12)
          )
      ),
      child: GestureDetector(
        onTap: () {
          switch(widget.onClick){
            case "label": labelSetting(context, label);break;
            case "audio": audioSetting(context, label);break;
            case "repeat": repeatSetting(context, label);break;
            case "vibration": vibrationSetting(context, label);break;
            case "mission": missionSetting(context, label);break;
            default: break;
          }
        },
        child: ListTile(
          leading: Icon(widget.icon),
          title:Text(widget.title),
          subtitle: Text(label),
          trailing: Icon(Icons.arrow_right),
        ),
      )
    );
  }

  void labelSetting (context, String oldLabel){
    String newLabel = oldLabel;

    EasyDialog(
      fogOpacity: 0.12,
      width: ScreenUtil().setWidth(600),
      height: ScreenUtil().setWidth(380),
      closeButton: false,
      title: Text(
        "标签",
        style: TextStyle(fontSize: ScreenUtil().setSp(40)),
      ),
      contentList: [
        Container(
          width: ScreenUtil().setWidth(540),
          margin: EdgeInsets.fromLTRB(0, ScreenUtil().setWidth(10), 0, ScreenUtil().setWidth(30)),
          child: TextField(
              controller: new TextEditingController(text: oldLabel),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.loyalty, color: Colors.grey),
              ),
              maxLines: 1,
              onChanged: (v) {
                newLabel = v;
              }
          ),
        ),
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(180),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(newLabel);
                  },
                  child: Text(
                    "CANCEL",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(180),
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      label = newLabel;
                    });
                    newAlarmInfo.label = newLabel;
                    Navigator.of(context).pop(newLabel);
                  },
                  child: Text(
                    "SAVE",
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

  void audioSetting(context, String oldAudio) {
    String newAudio = oldAudio;

    EasyDialog(
        fogOpacity: 0.12,
        width: ScreenUtil().setWidth(600),
        height: ScreenUtil().setWidth(720),
        closeButton: false,
        title: Text(
          "铃声",
          style: TextStyle(fontSize: ScreenUtil().setSp(40)),
      ),
      contentList: [
        Container(
          height: ScreenUtil().setWidth(480),
          child: SingleChildScrollView(
            child: RadioButtonGroup(
                labels: audios,
                onSelected: (String selected){
                  newAudio = selected;
                  Global.audioCache1.play(selected+".mp3");
                }
            ),
          ),
        ),
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(180),
                child: FlatButton(
                  onPressed: () {
                    Global.advancedPlayer1.release();
                    Navigator.of(context).pop(newAudio);
                  },
                  child: Text(
                    "CANCEL",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(180),
                child: FlatButton(
                  onPressed: () {
                    Global.advancedPlayer1.release();
                    setState(() {
                      label = newAudio;
                    });
                    newAlarmInfo.audio = newAudio;
                    Navigator.of(context).pop(newAudio);
                  },
                  child: Text(
                    "SAVE",
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

  void repeatSetting(context, String oldRepeat){
    String newRepeat = "";
    List<String> selects = chineseToEnglish(regenerateRepeat(oldRepeat));

    EasyDialog(
        fogOpacity: 0.12,
        width: ScreenUtil().setWidth(660),
        height: ScreenUtil().setWidth(360),
        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        closeButton: false,
        title: Text(
          "重复",
           style: TextStyle(fontSize: ScreenUtil().setSp(40)),
        ),
        contentList: [
            Container(
              width: ScreenUtil().setWidth(640),
              child: SelectWeekDays(
                padding: 0,
                border: true,
                boxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(60.0)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    colors: [const Color(0xFF57BDBF), const Color(0xFF2F9DE2)],
                    tileMode:
                    TileMode.repeated, // repeats the gradient over the canvas
                  ),
                ),
                onSelect: (values) { // <== Callback to handle the selected days
                  selects = values;
                },
              ),
            ),
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                      width: ScreenUtil().setWidth(180),
                      child: FlatButton(
                        onPressed: () {

                          Navigator.of(context).pop(newRepeat);
                        },
                        child: Text(
                          "CANCEL",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(180),
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          label = generateRepeat(englishToChinese(selects));
                        });
                        newAlarmInfo.repeat = englishToChinese(selects);
                        Navigator.of(context).pop(newRepeat);
                      },
                      child: Text(
                        "SAVE",
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

  void vibrationSetting(context, String oldSwitch){
    int vibrationOn = oldSwitch == "是"? 1:0;

    EasyDialog(
      fogOpacity: 0.12,
      width: ScreenUtil().setWidth(600),
      height: ScreenUtil().setWidth(320),
      closeButton: false,
      title: Text(
        "振动",
        style: TextStyle(fontSize: ScreenUtil().setSp(40)),
      ),
      contentList: [
        Container(
          child: ToggleSwitch(
            minWidth: ScreenUtil().setWidth(180.0),
            cornerRadius: ScreenUtil().setWidth(40.0),
            activeBgColors: [Colors.blue,Colors.red],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            labels: ['ON', 'OFF'],
            icons: [Icons.check, Icons.clear],
            initialLabelIndex: 1-vibrationOn,
            onToggle: (index) {
              vibrationOn = (1 - index) ;
            },
          ),
        ),
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(180),
                child: FlatButton(
                  onPressed: () {

                    Navigator.of(context).pop(vibrationOn);
                  },
                  child: Text(
                    "CANCEL",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(180),
                child: FlatButton(
                  onPressed: () {
                    if(vibrationOn == 1) setState(() {
                      label = "是";
                    });
                    else setState(() {
                      label = "否";
                    });
                    newAlarmInfo.vibration = vibrationOn == 1;
                    Navigator.of(context).pop(vibrationOn);
                  },
                  child: Text(
                    "SAVE",
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

  void missionSetting(context, String oldMission){
    int missionSelected = findMission(oldMission);

    EasyDialog(
      fogOpacity: 0.12,
      width: ScreenUtil().setWidth(600),
      height: ScreenUtil().setWidth(980),
      closeButton: false,
      title: Text(
        "任务",
        style: TextStyle(fontSize: ScreenUtil().setSp(40)),
      ),
      contentList: [
        Container(
          width: ScreenUtil().setWidth(600),
          height: ScreenUtil().setWidth(720),
          child:Swiper(
            index: missionSelected,
            itemBuilder: (BuildContext context, int index) {
              return MissionCard(
                title: missionList[index].title,
                image: missionList[index].image,
                description: missionList[index].description,
              );
            },
            itemCount: 6,
            viewportFraction: 0.8,
            scale: 0.9,
            onIndexChanged: (index){
              missionSelected = index;
            },
          )
        ),
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(180),
                child: FlatButton(
                  onPressed: () {

                    Navigator.of(context).pop(missionSelected);
                  },
                  child: Text(
                    "CANCEL",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(180),
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      label = missionList[missionSelected].title;
                    });
                    newAlarmInfo.mission = label;
                    Navigator.of(context).pop(missionSelected);
                  },
                  child: Text(
                    "SAVE",
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
}

class MissionCard extends StatefulWidget{
  final image;
  final title;
  final description;
  const MissionCard({Key key, this.image, this.title, this.description}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyMissionCard();
  }

}

class MyMissionCard extends State<MissionCard>{


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, ScreenUtil().setWidth(32)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(16.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, ScreenUtil().setWidth(10.0)), //阴影xy轴偏移量
                blurRadius: ScreenUtil().setWidth(20.0), //阴影模糊程度
                spreadRadius: ScreenUtil().setWidth(2.0) //阴影扩散程度
            )
          ],
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: ScreenUtil().setWidth(400),
              height: ScreenUtil().setHeight(360),
              child: Image.asset(
                widget.image,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(400),
            margin: EdgeInsets.fromLTRB(0, ScreenUtil().setWidth(5), 0, ScreenUtil().setWidth(5)),
            height: ScreenUtil().setWidth(80),
            alignment: Alignment.center,
            child: Text(
              widget.title,
              style: TextStyle(fontSize: ScreenUtil().setSp(56)),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(400),
            height: ScreenUtil().setWidth(160),
            alignment: Alignment.center,
            child: Text(
              widget.description,
              style: TextStyle(fontSize: ScreenUtil().setSp(28)),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

}

class MissionItem{
  String title;
  String image;
  String description;

  MissionItem(String title, String image, String description){
    this.title = title;
    this.image = image;
    this.description = description;
  }
}

String generateRepeat(List<String> repeat){
  String repeatStr = "";
  if(repeat.isEmpty){
    repeatStr = "从不";
  } else if(repeat.length == 7){
    repeatStr = "每天";
  } else {
    repeat.forEach((element) {
      repeatStr += element + " ";
    });
  }
  return repeatStr;
}

List<String> regenerateRepeat(String repeat){
  List<String> repeatList = new List<String>();
  if(repeat == "每天"){
    repeatList = ["周一","周二","周三","周四","周五","周六","周日"];
  } else {
    repeatList = repeat.split(" ");
  }
  return repeatList;
}

List<String> englishToChinese(List<String> repeat){
  List<String> repeatCN = new List<String>();
  repeat.forEach((element) {
    switch(element){
      case "Monday": repeatCN.add("周一");break;
      case "Tuesday": repeatCN.add("周二");break;
      case "Wednesday": repeatCN.add("周三");break;
      case "Thursday": repeatCN.add("周四");break;
      case "Friday": repeatCN.add("周五");break;
      case "Saturday": repeatCN.add("周六");break;
      case "Sunday": repeatCN.add("周日");break;
    }
  });
  return repeatCN;
}

List<String> chineseToEnglish(List<String> repeat){
  List<String> repeatEN = new List<String>();
  repeat.forEach((element) {
    switch(element){
      case "周一": repeatEN.add("Monday");break;
      case "周二": repeatEN.add("Tuesday");break;
      case "周三": repeatEN.add("Wednesday");break;
      case "周四": repeatEN.add("Thursday");break;
      case "周五": repeatEN.add("Friday");break;
      case "周六": repeatEN.add("Saturday");break;
      case "周日": repeatEN.add("Sunday");break;
    }
  });
  return repeatEN;
}

int findMission(String mission){
  int idx = 0;
  missionList.forEach((element) {
    if(element.title.compareTo(mission) == 0) idx = missionList.indexOf(element);
  });
  return idx;
}

