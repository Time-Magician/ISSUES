import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:day_picker/day_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../Class/AlarmInfo.dart';

const List<String> audios = [
"Audio 1",
"Audio 2",
"Audio 3",
"Audio 4",
"Audio 5",
"二狗汪汪叫",
];

List<MissionItem> missionList = [
  MissionItem("算术题","assets/image/math.png","闹钟响起时会出现一道数学题，填写正确答案之后就能关闭闹钟。"),
  MissionItem("唱歌","assets/image/music.png","闹钟响起时需要对着麦克风唱歌，跟唱15秒之后就能关闭闹钟。"),
  MissionItem("小游戏","assets/image/game.png","闹钟响起时需要玩连连看、消消乐等小游戏，获得足够的积分之后就能关闭闹钟。"),
  MissionItem("指定物品拍照","assets/image/camera.png","闹钟响起后，需要拍一张指定物品的照片并上传，识别正确后就能关闭闹钟。"),
  MissionItem("随机任务","assets/image/random.png","闹钟任务会从任务库中随机指定，完成对应任务之后即可关闭闹钟。"),
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
    // alarmInfo = ModalRoute.of(context).settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    AlarmInfo alarmInfo = ModalRoute.of(context).settings.arguments;


    newAlarmInfo = new AlarmInfo(
      alarmInfo.label,
      alarmInfo.repeat,
      alarmInfo.time,
      alarmInfo.mission,
      alarmInfo.audio,
      alarmInfo.vibration,
      alarmInfo.isOpen
    );

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
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: (() => {
              Navigator.of(context).pop(newAlarmInfo)
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

  void setLabel(String newLabel){
    print("sss");
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
                          height: 100,
                          margin: EdgeInsets.fromLTRB(0, 50, 0, 50),
                          child:Text(
                            timeToString(_time),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 80, fontFamily: "Miriam"),
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
      width: 330,
      height: 190,
      closeButton: false,
      title: Text(
        "标签",
        style: TextStyle(fontSize: 20),
      ),
      contentList: [
        Container(
          width: 270,
          margin: EdgeInsets.fromLTRB(0, 5, 0, 15),
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
                width: 90,
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
                width: 90,
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
        width: 330,
        height: 360,
        closeButton: false,
        title: Text(
          "铃声",
          style: TextStyle(fontSize: 20),
      ),
      contentList: [
        Container(
          height: 240,
          child: SingleChildScrollView(
            child: RadioButtonGroup(
                picked: oldAudio,
                labels: audios,
                onSelected: (String selected) => {newAudio = selected}
            ),
          ),
        ),
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 90,
                child: FlatButton(
                  onPressed: () {
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
                width: 90,
                child: FlatButton(
                  onPressed: () {
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
    String newRepeat = oldRepeat;
    List<String> selects = chineseToEnglish(regenerateRepeat(oldRepeat));

    EasyDialog(
        fogOpacity: 0.12,
        width: 350,
        height: 180,
        closeButton: false,
        title: Text(
          "重复",
           style: TextStyle(fontSize: 20),
        ),
        contentList: [
            Container(
              child: SelectWeekDays(
                padding: 0,
                border: true,
                boxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
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
                      width: 90,
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
                    width: 90,
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
      width: 330,
      height: 160,
      closeButton: false,
      title: Text(
        "振动",
        style: TextStyle(fontSize: 20),
      ),
      contentList: [
        Container(
          child: ToggleSwitch(
            minWidth: 90.0,
            cornerRadius: 20.0,
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
                width: 90,
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
                width: 90,
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
      width: 330,
      height: 480,
      closeButton: false,
      title: Text(
        "任务",
        style: TextStyle(fontSize: 20),
      ),
      contentList: [
        Container(
          width: 330,
          height: 360,
          child:Swiper(
            index: missionSelected,
            itemBuilder: (BuildContext context, int index) {
              return MissionCard(
                title: missionList[index].title,
                image: missionList[index].image,
                description: missionList[index].description,
              );
            },
            itemCount: 5,
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
                width: 90,
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
                width: 90,
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
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 5.0), //阴影xy轴偏移量
                blurRadius: 10.0, //阴影模糊程度
                spreadRadius: 1.0 //阴影扩散程度
            )
          ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 240,
            height: 200,
            child: Image.asset(
              widget.image,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: 200,
            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            height: 40,
            alignment: Alignment.center,
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 28),
            ),
          ),
          Container(
            width: 200,
            height: 80,
            alignment: Alignment.center,
            child: Text(
              widget.description,
              style: TextStyle(fontSize: 16),
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
  if(repeat.length == 7){
    repeatStr = "每天";
  }else {
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

