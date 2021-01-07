import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:demo5/index.dart';
import 'package:demo5/models/Message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:dio/dio.dart';

class MessageView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyMessageView();
  }

}

class MyMessageView extends State<MessageView>{
  List<dynamic> messages = [];
  String id = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessage();
  }

  void getMessage() async {
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    String url ="http://"+Global.url+":9000/user-service/user/"+Global.userId.toString()+"/messages";
    Response response = await dio
        .get(url);
    print(response.data["data"]);
    List<Message> tmpList = [];
    response.data["data"].forEach((item) {
      tmpList.add(Message.fromJson(item));
    });
    setState(() {
      messages = tmpList;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("消息"),
        ),
        backgroundColor: const Color(0xFF75CCE8),
        body: Center(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (BuildContext context,int index) {
              return new MessageCard(message: messages[index]);
            },
          ),
        )
    );
  }

}

class MessageCard extends StatefulWidget{
  final message;
  const MessageCard({Key key, this.message}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyMessageCard();
  }

}

class MyMessageCard extends State<MessageCard>{
  AlarmInfo alarmInfo;

  void refuse(){
    setState(() {
      widget.message.status = 1;
    });
    checkMessage(widget.message.id);
  }

  void ack(){
    setState(() {
      widget.message.status = 1;
    });
    checkMessage(widget.message.id);
    if(widget.message.type == "好友申请")
      addFriend(widget.message.senderId);
    else if(widget.message.type == "闹钟设置")
      addAlarm();
  }

  void checkMessage(String id) async {
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    String url ="http://"+Global.url+":9000/user-service/user/"+Global.userId.toString()+"/messages/"+id;
    Response response = await dio
        .put(url);
    print(response.data["data"]);
  }

  void addFriend(int senderId) async {
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    String url ="http://"+Global.url+":9000/user-service/user/"+Global.userId.toString()+"/friends/"+senderId.toString();
    Response response = await dio
        .post(url);
    print(response.data["data"]);
  }
  
  String getAlarmInfo(String details){
    AlarmInfo alarmInfo = AlarmInfo.fromJson(jsonDecode(details));
    setState(() {
      this.alarmInfo = alarmInfo;
    });
    return "你的好友想为你设置一个 "+AlarmInfo.timeToJson(alarmInfo.time)+" 的闹钟，需要通过完成 "+alarmInfo.mission+" 来解锁，是否接受该请求？";
  }

  void addAlarm() async {
    var id = await Global.db.insert("alarms", alarmInfo.toJson());
    print("add alarm: $id");
    Global.alarmList.add(alarmInfo);
    alarmInfo.alarmId = id;
    setState(() {
    });
    TimeOfDay time = alarmInfo.time;
    int timeSpan = Global.nextAlarmTime(time.hour, time.minute, alarmInfo.repeat);
    Global.methodChannel.invokeMethod("startAlarm",{"hour":time.hour,"minute":time.minute,"alarmIndex":id.toString(),"timeSpan":timeSpan});

    int userId = Global.userId;
    int alarmId = alarmInfo.alarmId;
    String label = alarmInfo.label;
    String repeat = AlarmInfo.repeatToJson(alarmInfo.repeat);
    String mission = alarmInfo.mission;
    String audio = alarmInfo.audio;
    String _time = AlarmInfo.timeToJson(time)+":00";

    postRequestCreateAlarm(userId, alarmId, label, repeat, _time, mission, audio);

  }

  void postRequestCreateAlarm(int userId,int alarmId,String label,String repeat,String time,String mission ,String audio) async {
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    FormData formData = FormData.fromMap({'label': label, 'repeat': repeat, 'time': time, 'mission': mission, 'audio': audio});
    String url ="http://"+Global.url+":9000/alarm-service/user/"+userId.toString()+"/alarm/"+alarmId.toString();
    Response response = await dio
        .post(url, data: formData);
    var result = response.data.toString();
    print(result);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 20.0,
      margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15), ScreenUtil().setHeight(20), ScreenUtil().setWidth(15), ScreenUtil().setHeight(20)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: ScreenUtil().setWidth(80),
            width: ScreenUtil().setWidth(690),
            child: Row(
              children: [
                Container(
                  height: ScreenUtil().setWidth(80),
                  width: ScreenUtil().setWidth(490),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(50), 0, 0, 0),
                  child: Text(
                      widget.message.type,
                      style: TextStyle(fontSize: ScreenUtil().setSp(36),color: Colors.black54),
                    ),
                ),
                Container(
                  height: ScreenUtil().setWidth(80),
                  width: ScreenUtil().setWidth(200),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(30), 0),
                  child: Text(
                    widget.message.time,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: ScreenUtil().setSp(24) ),
                  ),
                )
              ],
            )
          ),
          Container(
            width: ScreenUtil().setWidth(690),
            constraints: BoxConstraints(
              minHeight: ScreenUtil().setWidth(120),
            ),
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), ScreenUtil().setWidth(5), ScreenUtil().setWidth(20), ScreenUtil().setWidth(5)),
            margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15), ScreenUtil().setWidth(5), ScreenUtil().setWidth(15), ScreenUtil().setWidth(5)),
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.indigo, width: ScreenUtil().setWidth(5)),
                  bottom: BorderSide(color: Colors.indigo, width: ScreenUtil().setWidth(5))
              ),//边框
            ),
            child: Text(
              widget.message.type == "好友申请"?widget.message.details:getAlarmInfo(widget.message.details),
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: ScreenUtil().setSp(32) ),
            ),
          ),
          Container(
            height: ScreenUtil().setWidth(80),
            width: ScreenUtil().setWidth(690),
            child: Row(
              children: [
                Container(
                  width: ScreenUtil().setWidth(290),
                  height: ScreenUtil().setWidth(80),
                  child: Row(
                    children: [
                      Radio(
                        value:1,
                        groupValue: widget.message.status == 0?1:0,
                        activeColor: Colors.redAccent,
                        onChanged:(v){
                        },
                      ),
                      Text(
                        widget.message.status == 0?"未读":"已读",
                        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                      ),
                    ],
                  )
                ),
                Container(
                  width: ScreenUtil().setWidth(200),
                  height: ScreenUtil().setWidth(80),
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), ScreenUtil().setWidth(5), ScreenUtil().setWidth(20), ScreenUtil().setWidth(10)),
                  child: widget.message.status == 0?RaisedButton(
                    child: Text(
                      '拒绝',
                      style: TextStyle(fontSize: ScreenUtil().setSp(28), color: Colors.white),
                    ),
                    onPressed: (){
                      refuse();
                    },
                    color: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20))
                    ),
                  ):null,
                ),
                Container(
                  width: ScreenUtil().setWidth(200),
                  height: ScreenUtil().setWidth(80),
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), ScreenUtil().setWidth(5), ScreenUtil().setWidth(20), ScreenUtil().setWidth(10)),
                  child: widget.message.status == 0?RaisedButton(
                    child: Text(
                        '同意',
                      style: TextStyle(fontSize: ScreenUtil().setSp(28), color: Colors.white),
                    ),
                    onPressed: (){
                      ack();
                    },
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20))
                    ),
                  ):null,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}