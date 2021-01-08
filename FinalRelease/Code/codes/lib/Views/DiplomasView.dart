import 'dart:math';

import 'package:demo5/common/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import '../Class/StudyInfo.dart';
import 'package:demo5/models/Frog.dart';

List<Frog> frogList = [
];

class DiplomasWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyDiplomasView();
  }
}

class MyDiplomasView extends State<DiplomasWidget>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

    frogList.clear();
    getFrogList();
  }

  void getFrogList() async {
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    String url = "http://10.0.2.2:9000/study-service/user/"+Global.userId.toString()+"/frogs/graduated";
    Response response = await dio.get(url);
    response.data.forEach((element) {
      Frog frog = Frog.fromJson(element);
      frogList.add(frog);
    });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF75CCE8),
        appBar: AppBar(
            title: Text('荣誉室'),
        ),
        body:ListView.builder(
            itemCount: frogList.length,
            itemBuilder: (BuildContext context,int index) {
            return new Diploma(index: index);
        },
      ));
  }
}

class Diploma extends StatefulWidget{
  final index;
  const Diploma({Key key, this.index}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyDiploma();
  }
}

class MyDiploma extends State<Diploma>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: Card(
            margin: EdgeInsets.fromLTRB(0, ScreenUtil().setHeight(20), 0, ScreenUtil().setWidth(20)),
            elevation: ScreenUtil().setWidth(40.0),  //设置阴影
            child: Container(
              width: ScreenUtil().setWidth(680),
              height: ScreenUtil().setWidth(480),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8DC),
                border: Border.all(color: const Color(0xFFFFF8DC), width: ScreenUtil().setWidth(6)),//边框
              ),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFFFD700), width: ScreenUtil().setWidth(6)),//边框
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        "※~※~毕 ※ 业 ※ 证 ※ 书~※~※",
                        style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(48)),
                      ),
                    ),
                    Container(
                        width: ScreenUtil().setWidth(640),
                        margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0, 0, 0),
                        height: ScreenUtil().setWidth(320),
                        child: Row(
                          children: <Widget>[
                            Container(
                                width: ScreenUtil().setWidth(160),
                                height: ScreenUtil().setWidth(200),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFFFD700), width: ScreenUtil().setWidth(6)),//边框
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF08080),
                                    border: Border.all(color: const Color(0xFFFFFACD), width: ScreenUtil().setWidth(6)),//边框
                                  ),
                                  child: ClipRect(//圆形头像
                                    child: Image.asset(
                                      "assets/image/frogGraduate.png",
                                      width: ScreenUtil().setWidth(160.0),
                                    ),
                                  ),
                                )
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(30), 0, 0, 0),
                              width: ScreenUtil().setWidth(440),
                              height: ScreenUtil().setWidth(320),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                      width: ScreenUtil().setWidth(440),
                                      height: ScreenUtil().setWidth(100),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            frogList[widget.index].name,
                                            style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(56), fontFamily: "KeShi",  decoration: TextDecoration.underline,),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            " 同学",
                                            style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(40), fontFamily: "KeShi"),
                                            textAlign: TextAlign.left,
                                          )
                                        ],
                                      ),
                                  ),
                                  Container(
                                      width: ScreenUtil().setWidth(440),
                                      height: ScreenUtil().setWidth(120),
                                      child: Text(
                                        "学习专注，作息规律\n品学兼优，成绩优异",
                                        style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(40), fontFamily: "KeShi"),
                                        textAlign: TextAlign.center,
                                      )
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(440),
                                    child: Text(
                                      "于 "+frogList[widget.index].graduateDate,
                                      style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(40), fontFamily: "KeShi"),
                                      textAlign: TextAlign.right,
                                    ) ,
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(440),
                                    child: Text(
                                      "毕业于 "+frogList[widget.index].school,
                                      style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(40), fontFamily: "KeShi"),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        "※~※~※~※~※~※~※~※~※~※",
                        style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(48)),
                      ),
                    ),
                  ],
                ),
              )
            ),
       )
    );
  }

}