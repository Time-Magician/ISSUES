import 'package:flutter/material.dart';

class AlarmView extends StatefulWidget {
  @override
  createState() => new AlarmList();
}

class AlarmList extends State<AlarmView> {
  final _alarmList = new Set<AlarmInfo>();

  void addAlarm(){
    Navigator.pushNamed(context,"AlarmSetting");
  }
  
  @override
  Widget build(BuildContext context){
    _alarmList.clear();
    _alarmList.add(new AlarmInfo());
    _alarmList.add(new AlarmInfo());
    _alarmList.add(new AlarmInfo());
    _alarmList.add(new AlarmInfo());
    _alarmList.add(new AlarmInfo());
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
          itemBuilder: (BuildContext context,int index) {
            return new AlarmWidget();
          },
        ),

    );
  }
}

class AlarmWidget extends StatefulWidget{
  @override
  createState() => new Alarm();

}

class Alarm extends State<AlarmWidget> {
  AlarmInfo alarmInfo = new AlarmInfo();

  void _switchAlarm(isOpen){
    // bool isOpen = this.alarmInfo.isOpen? false : true;
    this.alarmInfo.isOpen = isOpen;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context){
    return Center(
      child: GestureDetector(
        onTap: (() => {
          Navigator.pushNamed(
              context,"AlarmSetting"
          )
        }),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Text(
                  this.alarmInfo.name,
                  textAlign: TextAlign.left,
                  maxLines:1,
                  overflow:TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 24.0,
                      color: Colors.black45,
                  ),
                ),
                width: 360,
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: new Text(
                        this.alarmInfo.time,
                        style: const TextStyle(fontSize: 42.0, fontFamily: 'Miriam'),
                    ),
                    width: 300,
                    margin: EdgeInsets.fromLTRB(15, 5, 5, 10),
                  ),
                  Container(
                    child: new Switch(value: this.alarmInfo.isOpen, onChanged: _switchAlarm),
                    width: 64,
                  )
                ]
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        this.alarmInfo.date,
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
                          this.alarmInfo.job,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.cyan,
                          ),
                        )
                    ),
                  ],
                ),
                width: 360,
                height: 30,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              ),
            ],
          ),
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        ),
    ));
  }
}

class AlarmInfo {
  String name;
  String date;
  String time;
  String job;
  bool isOpen;

  AlarmInfo({this.name = "起床", this.date = "周一 周三", this.time = "06:30", this.job = "计算题", this.isOpen = false});
}