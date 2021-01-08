import 'dart:async';
import 'dart:math';

import 'package:demo5/common/global.dart';
import 'package:dio/dio.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class Game2 extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyGame2();
  }

}

class MyGame2 extends State<Game2>{
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
                    "太空猫猫正在做恶作剧捉弄小青蛙，快来帮小青蛙抓住太空猫猫们吧！",
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

class MyLittleGame extends State<LittleGame> {
  List<bool> flipped;
  int score;
  int last;
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flipped = [
      true, false, false, false,
      false, false, false, false,
      false, false, false, false,
      false, false, false, false
    ];
    score = 0;
    last = 0;
    timer= new Timer.periodic(
        Duration(milliseconds: 500), (timer){
          setState(() {
            flipped[last] = false;
            last = (new Random()).nextInt(16);
            flipped[last] = true;

          });
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
        "你已经成功地终结了太空猫猫的恶作剧，赶紧起床吧！",
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

  void onTap(int idx){
    if(!flipped[idx]) return;
    else{
      setState(() {
        score++;
        flipped[idx] = false;
        // last = (new Random()).nextInt(16);
        // flipped[last] = true;
      });
    }
    if(score == 10){
      timer.cancel();
      success();
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
                  "已抓住 " + score.toString() + "/10",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(70), fontFamily: "Miriam"),
                )
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => onTap(0),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[0]?
                        Image.asset("assets/image/portCat.png"):
                        Image.asset("assets/image/port.png")
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onTap(1),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[1]?
                        Image.asset("assets/image/portCat.png"):
                        Image.asset("assets/image/port.png")
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onTap(2),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[2]?
                        Image.asset("assets/image/portCat.png"):
                        Image.asset("assets/image/port.png")
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onTap(3),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[3]?
                        Image.asset("assets/image/portCat.png"):
                        Image.asset("assets/image/port.png")
                    ),
                  )
                ],
              )
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => onTap(4),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[4]?
                        Image.asset("assets/image/portCat.png"):
                        Image.asset("assets/image/port.png")
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onTap(5),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[5]?
                        Image.asset("assets/image/portCat.png"):
                        Image.asset("assets/image/port.png")
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onTap(6),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[6]?
                        Image.asset("assets/image/portCat.png"):
                        Image.asset("assets/image/port.png")
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onTap(7),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[7]?
                        Image.asset("assets/image/portCat.png"):
                        Image.asset("assets/image/port.png")
                    ),
                  )
                ],
              )
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => onTap(8),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[8]?
                        Image.asset("assets/image/portCat.png"):
                        Image.asset("assets/image/port.png")
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onTap(9),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[9]?
                        Image.asset("assets/image/portCat.png"):
                        Image.asset("assets/image/port.png")
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onTap(10),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[10]?
                        Image.asset("assets/image/portCat.png"):
                        Image.asset("assets/image/port.png")
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onTap(11),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[11]?
                        Image.asset("assets/image/portCat.png"):
                        Image.asset("assets/image/port.png")
                    ),
                  )
                ],
              )
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => onTap(12),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[12]?
                        Image.asset("assets/image/portCat.png"):
                        Image.asset("assets/image/port.png")
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onTap(13),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[13]?
                        Image.asset("assets/image/portCat.png"):
                        Image.asset("assets/image/port.png")
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onTap(14),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[14]?
                        Image.asset("assets/image/portCat.png"):
                        Image.asset("assets/image/port.png")
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onTap(15),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[15]?
                        Image.asset("assets/image/portCat.png"):
                        Image.asset("assets/image/port.png")
                    ),
                  )
                ],
              )
            ],
          ),
          Container(
            width: ScreenUtil().setWidth(720),
            height: ScreenUtil().setWidth(80),
          )
        ]);
  }
}