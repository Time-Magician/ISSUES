import 'dart:async';

import 'package:demo5/common/global.dart';
import 'package:demo5/index.dart';
import 'package:dio/dio.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class Blow extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyBlow();
  }

}

class MyBlow extends State<Blow> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF75CCE8),
      resizeToAvoidBottomPadding: false,
      body: WillPopScope(
        onWillPop: () async{
          return false;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ScreenUtil().setWidth(720),
              height: ScreenUtil().setWidth(280),
              child: Information(),
            ),
            Expanded(
              child: Container(
                width: ScreenUtil().setWidth(720),
                child: BlowGame(),
              ),
            )
          ],
        ),
      )
    );
  }
}

class Information extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyInformation();
  }

}

class MyInformation extends State<Information>{

  @override
  Widget build(BuildContext context) {
    DateTime dateTime= DateTime.now();
    // TODO: implement build
    return Row(
      children: [
        Container(
          width: ScreenUtil().setWidth(360),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dateTime.month.toString()+"月"+dateTime.day.toString()+"日",
                  style: TextStyle(fontSize: ScreenUtil().setSp(48)),
                  textAlign: TextAlign.left,
                ),
                Text(
                  dateTime.hour.toString()+" : "+(dateTime.minute<10?"0"+dateTime.minute.toString():dateTime.minute.toString()),
                  style: TextStyle(fontSize: ScreenUtil().setSp(70), fontFamily: "Miriam"),
                  textAlign: TextAlign.left,
                )
              ],
            ),
          ),
        ),
        Container(
          width: ScreenUtil().setWidth(360),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: ScreenUtil().setWidth(320),
                    child: Row(
                      children: [
                        Icon(
                            Icons.lightbulb_outline
                        ),
                        Text(
                          "TIPS",
                          style: TextStyle(fontSize: ScreenUtil().setSp(30), fontFamily: "Miriam"),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    )
                ),
                Container(
                  width: ScreenUtil().setWidth(320),
                  child: Text(
                    "小青蛙和朋友们的气球漏气了，快帮它们把气球吹大吧！",
                    style: TextStyle(fontSize: ScreenUtil().setSp(27)),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class BlowGame extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyBlowGame();
  }

}

class MyBlowGame extends State<BlowGame>{
  double balloonSize;
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    balloonSize = ScreenUtil().setWidth(200);
    timer= new Timer.periodic(
        Duration(milliseconds: 1000), (timer){
          if(balloonSize > 210){
            setState(() {
              balloonSize = balloonSize - ScreenUtil().setWidth(10);

            });
          }
    });
    Global.methodChannel.setMethodCallHandler((call) {
      if(call.method == "highPitch")
        highPitch();
    });
    startRecord();
  }

  void startRecord() async {
    var result = await Global.methodChannel.invokeMethod("startAudioSensor");
    print(result);
    if (result == "retry"){
      await Global.methodChannel.invokeMethod("startAudioSensor");
    }
  }

  void stopRecord() async {
    await Global.methodChannel.invokeMethod("stopAudioSensor");
  }

  void highPitch() {
    if(balloonSize >= ScreenUtil().setWidth(600)){
      stopRecord();
      success();
      return;
    }
    setState(() {
      balloonSize = balloonSize + ScreenUtil().setWidth(25);
    });
  }

  updateFrog() async{
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    String url = "http://10.0.2.2:9000/study-service/user/"+Global.userId.toString()+"/frog";
    FormData formData = FormData.fromMap({"name":Global.frog.name,"level":Global.frog.level,"exp":Global.frog.exp,"is_graduated":Global.frog.isGraduated,"graduate_date":Global.frog.graduateDate,"school":Global.frog.school});
    dio.put(url,data: formData);
  }

  void success(){
    if(Global.frog.level < 17){
      int exp = 10;
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
      width: ScreenUtil().setWidth(600),
      height: ScreenUtil().setWidth(360),
      closeButton: false,
      title: Text(
        "好样的！",
        style: TextStyle(fontSize: ScreenUtil().setSp(40)),
      ),
      description: Text(
        "你已经成功地帮小动物们吹大了气球，赶快起床吧！",
        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
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
                    timer.cancel();
                    Global.advancedPlayer1.release();
                    Navigator.pushNamedAndRemoveUntil(context, "HomePage",(Route route) =>false);
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
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "用力对着麦克风吹气！",
                style: TextStyle(fontSize: ScreenUtil().setSp(56)),
              ),
            ]
          ),
        ),
        Container(
          width: ScreenUtil().setWidth(720),
          height: ScreenUtil().setWidth(600),
          child: Center(
            child: Container(
              width: ScreenUtil().setWidth(600),
              height: ScreenUtil().setWidth(600),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/image/balloonTarget.png"),
                  fit: BoxFit.contain,
                ),
              ),
              child: Center(
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: balloonSize,
                    height: ScreenUtil().setWidth(600),
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                        "assets/image/balloon.png"
                    )
                ),
              ),
            ),
          ),
        ),
        Container(
          width: ScreenUtil().setWidth(720),
          height: ScreenUtil().setWidth(360),
          child: Image.asset("assets/image/balloonAnimals.png"),
        ),
        Container(
          width: ScreenUtil().setWidth(720),
          height: ScreenUtil().setWidth(100),
        )
      ],
    );
  }

}

