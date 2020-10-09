import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class AlarmSettingWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AlarmSetting();
  }

}

class AlarmSetting extends State<AlarmSettingWidget>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('闹钟设置'),
        actions: <Widget>[
          new MaterialButton(
            child: Text(
              "保存",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: (() => {
              Navigator.pop(context)
            }),
          ),
        ],
      ),
      body: Settings(),
    );
  }
}

class Settings extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MySettings();
  }
}

class MySettings extends State<Settings>{
  TimeOfDay _time = TimeOfDay.now();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Center(
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
              OrderTitle(title: "标签", icon: Icons.loyalty, subtitle: "起床"),
              OrderTitle(title: "铃声", icon: Icons.audiotrack, subtitle: "audio1"),
              OrderTitle(title: "重复", icon: Icons.calendar_today, subtitle: "每天"),
              OrderTitle(title: "振动", icon: Icons.notifications_active, subtitle: "是"),
              OrderTitle(title: "任务", icon: Icons.games, subtitle: "算术题"),
            ],
          ),
        )
    );
  }
}

class OrderTitle extends StatelessWidget{
  final title;
  final subtitle;
  final icon;
  const OrderTitle({Key key, this.title, this.subtitle, this.icon}) : super(key: key);

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
      child: ListTile(
        leading: Icon(this.icon),
        title:Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }
}