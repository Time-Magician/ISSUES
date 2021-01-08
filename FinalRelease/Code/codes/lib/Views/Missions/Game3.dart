import 'dart:math';

import 'package:demo5/index.dart';
import 'package:dio/dio.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:tcard/tcard.dart';

class Game3 extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyGame3();
  }

}

class MyGame3 extends State<Game3>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: const Color(0xFF75CCE8),
        resizeToAvoidBottomPadding: false,
        body:WillPopScope(
            onWillPop: () async{
              return false;
            },
            child:Column(
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
                    child: LittleGame(),
                  ),)
              ],
            ))
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
                    "小动物们需要按照不同的种类分到不同的班级，帮助老师给它们分分类吧！",
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

class LittleGame extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyLittleGame();
  }

}

class MyLittleGame extends State<LittleGame>{
  List<int> kind = [0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1];
  List<Image> images = [
    Image.asset("assets/image/animal1.png"),
    Image.asset("assets/image/animal2.png"),
    Image.asset("assets/image/animal3.png"),
    Image.asset("assets/image/animal4.png"),
    Image.asset("assets/image/animal5.png"),
    Image.asset("assets/image/animal6.png"),
    Image.asset("assets/image/animal8.png"),
    Image.asset("assets/image/animal9.png"),
    Image.asset("assets/image/animal10.png"),
    Image.asset("assets/image/animal11.png"),
    Image.asset("assets/image/animal13.png"),
    Image.asset("assets/image/animal14.png"),
    Image.asset("assets/image/animal17.png"),
    Image.asset("assets/image/animal19.png"),
    Image.asset("assets/image/animal20.png"),
  ];
  int target;
  bool flag = true;
  TCardController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    randomizeList();
    target = (new Random()).nextInt(10)%2;
    _controller = TCardController();
  }

  void randomizeList(){
    for(int i = 0; i < 15; i++){
      var temp = images[i];
      var tempk = kind[i];
      var randomIndex = (new Random()).nextInt(15);
      images[i] = images[randomIndex];
      kind[i] = kind[randomIndex];
      images[randomIndex] = temp;
      kind[randomIndex] = tempk;
    }
  }

  void swipeRight(int idx){
    // print(kind[idx]);
    // print(images[idx].image);
    if(kind[idx] != target){
      setState(() {
        flag = false;
      });
    }
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
      int exp = 15;
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
        "你已经成功地为每个小动物分好了班级！",
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

  void failed(){
    EasyDialog(
      fogOpacity: 0.12,
      width: ScreenUtil().setWidth(600),
      height: ScreenUtil().setWidth(360),
      closeButton: false,
      title: Text(
        "出错啦！",
        style: TextStyle(fontSize: ScreenUtil().setSp(40)),
      ),
      description: Text(
        "某些小动物没有进入到正确的班级哦，再尝试一次吧！",
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
                    randomizeList();
                    _controller.reset();
                    Navigator.of(context).pop();
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

  void onEnd(){
    if(flag){
      success();
    } else {
      failed();
    }
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                target == 0?"请找到哺乳动物":"请找到非哺乳动物",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(70), fontFamily: "Miriam"),
              )
            ],
          ),
        ),
        Row(
          children: [
            Container(
                width: ScreenUtil().setWidth(120),
                height: ScreenUtil().setWidth(600),
                color: Colors.red,
                child: Center(
                  child: Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: ScreenUtil().setSp(80),
                  ),
                ),
            ),
            Container(
              width: ScreenUtil().setWidth(480),
              height: ScreenUtil().setWidth(600),
              child: TCard(
                controller: _controller,
                cards: images,
                size: Size(240, 600),
                onForward: (index, info) {
                  print(index);
                  if (info.direction == SwipDirection.Right) {
                    swipeRight(index-1);
                  }
                },
                onEnd: onEnd,
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                width: ScreenUtil().setWidth(120),
                height: ScreenUtil().setWidth(600),
                color: Colors.green,
                child: Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: ScreenUtil().setSp(80),
                  ),
                )
            )
          ],
        ),
        Container(
            width: ScreenUtil().setWidth(720),
            height: ScreenUtil().setWidth(200),
          ),
      ]);
  }

}



