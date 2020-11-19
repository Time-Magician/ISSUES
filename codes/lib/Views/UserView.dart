import 'dart:math';

import 'package:demo5/common/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class UserView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Global.methodChannel.setMethodCallHandler((call) {
      if(call.method != "test")
        return;
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "ISSUES",
            style: TextStyle(fontSize: ScreenUtil().setSp(60.0), fontFamily: 'Knewave'),
          ),
      ),
      body: ListView(
        children: <Widget>[
          _topHeader(),
          OrderTitle(
              title: "个人信息",
              icon: Icons.assignment_ind,
              router: "UserDetail"),
          OrderTitle(
              title: "设置",
              icon: Icons.settings,
              router:"AppSetting"
          ),
          OrderTitle(title: "我的好友", icon: Icons.group, router: "FriendPage"),
          OrderTitle(title: "关于一心", icon: Icons.favorite),
        ],
      ),
    );
  }
}

Widget _topHeader() {
  return Container(
    padding: EdgeInsets.all(ScreenUtil().setWidth(40.0)),
    color: Colors.blueAccent,
    child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(40.0)),
          child: ClipOval(
            //圆形头像
            child: Image.asset(
              'assets/image/cat.jpg',
              width: ScreenUtil().setWidth(160.0),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(20.0)),
          child: Text("Chen Ergou", style: TextStyle(color: Colors.white)),
        )
      ],
    ),
  );
}

class OrderTitle extends StatelessWidget {
  final title;
  final icon;
  final router;
  const OrderTitle({Key key, this.title, this.router, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

        // margin: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: ScreenUtil().setWidth(2), color: Colors.black12))),
        child: GestureDetector(
          onTap: (() => {Navigator.pushNamed(context, router)}),
          child: ListTile(
            leading: Icon(this.icon),
            title: Text(title),
            trailing: Icon(Icons.arrow_right),
          ),
        ));
  }
}
