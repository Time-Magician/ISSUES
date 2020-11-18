import 'dart:math';

import 'package:demo5/common/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import '../Class/StudyInfo.dart';
import 'package:demo5/models/Frog.dart';

List<StudyInfo> studyInfo = [
  StudyInfo(Frog(1, "陈大狗", 15, 100, true, "2020/06/22", "氢化大学"), false),
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
      if(call.method == "test")
        print(call.arguments);
      String _id = call.arguments;
      int id = int.parse(_id);
      int index = Global.alarmList.indexWhere((element) => element.alarmId == id);
      String mission = Global.alarmList[index].mission;
      Global.audioCache1.loop(Global.alarmList[index].audio+".mp3");
      switch(mission){
        case "算术题": Navigator.pushNamed(context, "Arithmetic");break;
        case "小游戏": Navigator.pushNamed(context, "Game");break;
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
            title: Text('荣誉室'),
        ),
        body:ListView.builder(
            itemCount: studyInfo.length,
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
                                            studyInfo[widget.index].frog.name,
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
                                      "于 "+studyInfo[widget.index].frog.graduateDate,
                                      style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(40), fontFamily: "KeShi"),
                                      textAlign: TextAlign.right,
                                    ) ,
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(440),
                                    child: Text(
                                      "毕业于 "+studyInfo[widget.index].frog.school,
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