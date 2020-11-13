import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'dart:math';


class Arithmetic extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyArithmetic();
  }

}

class MyArithmetic extends State<Arithmetic>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF75CCE8),
        resizeToAvoidBottomPadding: false,
        body:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ScreenUtil().setWidth(720),
              height: ScreenUtil().setWidth(240),
              child: Information(),
            ),
            Container(
              width: ScreenUtil().setWidth(720),
              height: ScreenUtil().setWidth(240),
              child: Question(),
            ),
            Expanded(
              child: Container(
                width: ScreenUtil().setWidth(720),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/image/arithmetic.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            )
          ],
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
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.left,
                ),
                Text(
                  dateTime.hour.toString()+" : "+dateTime.minute.toString(),
                  style: TextStyle(fontSize: 40, fontFamily: "Miriam"),
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
                        style: TextStyle(fontSize: 16, fontFamily: "Miriam"),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                ),
                Container(
                  width: ScreenUtil().setWidth(320),
                  child: Text(
                    "小青蛙正在上数学课，帮助它们计算出正确的答案吧！",
                    style: TextStyle(fontSize: 16),
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

class Question extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyQuestion();
  }

}

class MyQuestion extends State<Question>{
  var x1;
  var x2;
  var x3;
  var sum;

  void checkAnswer(value){
    if(value == sum.toString())
      EasyDialog(
        fogOpacity: 0.12,
        width: ScreenUtil().setWidth(600),
        height: ScreenUtil().setWidth(300),
        closeButton: false,
        title: Text(
          "好样的！",
          style: TextStyle(fontSize: ScreenUtil().setSp(40)),
        ),
        description: Text(
          "你已经成功地帮助小青蛙们解出了这道问题，赶紧起床吧！",
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
                      Navigator.pushReplacementNamed(context, "HomePage");
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
    x1 = new Random().nextInt(100);
    x2 = new Random().nextInt(100);
    x3 = new Random().nextInt(100);
    sum = x1 + x2 + x3;
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                x1.toString()+" + ",
                style: TextStyle(fontSize: 36, fontFamily: "Miriam"),
              )     ,
              Text(
                x2.toString()+" + ",
                style: TextStyle(fontSize: 36, fontFamily: "Miriam"),
              ),
              Text(
                x3.toString()+" = ",
                style: TextStyle(fontSize: 36, fontFamily: "Miriam"),
              ),
              Container(
                width: ScreenUtil().setWidth(100),
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 36, fontFamily: "Miriam"),
                  onChanged: (value) => checkAnswer(value),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}