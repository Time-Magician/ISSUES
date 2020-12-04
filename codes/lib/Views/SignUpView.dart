import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../common/global.dart';

class SignUpView extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MySignUpView();
  }
}

class MySignUpView extends State<SignUpView>{
  String password = "";
  bool pwdMatch = true;
  String tel = "";
  String verifyCode = "";
  int countDown = 0;
  Timer timer;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: signUpBody(context),
      ),
    );
  }

  signUpBody(context) => SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[signUpHeader(), signUpFields(context)],
    ),
  );

  signUpHeader() => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Image.asset("assets/image/Froglogo.png", width: ScreenUtil().setWidth(80),),
      SizedBox(
        height: ScreenUtil().setHeight(20.0),
      ),
      Text(
        "Sign Up to Use ISSUES!",
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.green),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(10.0),
      )
    ],
  );

  signUpFields(context) => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10.0), horizontal: ScreenUtil().setWidth(60.0)),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(11),
              WhitelistingTextInputFormatter.digitsOnly
            ],
            maxLines: 1,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.perm_identity, color: Colors.green),
                hintText: "请输入手机号",
                labelText: "手机号",
                labelStyle: TextStyle(color: Colors.green),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green, //边框颜色为绿色
                      width: ScreenUtil().setWidth(10), //宽度为5
                    ))
            ),
            onChanged: (text)=>{
              this.setState(() {
                tel = text;
              })
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10.0), horizontal: ScreenUtil().setHeight(60.0)),
          width: ScreenUtil().setWidth(720),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: ScreenUtil().setWidth(420),
                child: TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  maxLines: 1,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.check_circle_outline, color: Colors.green),
                    hintText: "请输入验证码",
                    labelText: "验证码",
                    labelStyle: TextStyle(color: Colors.green),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green, //边框颜色为绿色
                          width: ScreenUtil().setWidth(10), //宽度为5
                        )),
                  ),
                  onChanged: (text)=>{
                    this.setState(() {
                      verifyCode = text;
                    })
                  },
                ),
              ),
              Container(
                child: countDown == 0?OutlineButton(
                  highlightedBorderColor: Colors.green,
                  onPressed: () {
                    getVeriCode();
                    myCountDown();
                  },
                  child: Text(
                      "获取验证码"
                  ),
                ):OutlineButton(
                  highlightedBorderColor: Colors.green,
                  onPressed: null,
                  child: Text(
                      countDown.toString()
                  ),
                ),
              )
            ],
      ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10.0), horizontal: ScreenUtil().setHeight(60.0)),
          child: TextField(
            maxLines: 1,
            obscureText: true,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline, color: Colors.green),
                hintText: "请输入密码",
                labelText: "密码",
                labelStyle: TextStyle(color: Colors.green),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green, //边框颜色为绿色
                      width: ScreenUtil().setWidth(10), //宽度为5
                    ))
            ),
            onChanged: (text)=>{
              this.setState(() {
                password = text;
              })
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10.0), horizontal: ScreenUtil().setHeight(60.0)),
          child: TextField(
            maxLines: 1,
            obscureText: true,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline, color: pwdMatch?Colors.green:Colors.red),
                hintText: "请再次输入密码",
                labelText: "确认密码",
                labelStyle: TextStyle(color: pwdMatch?Colors.green:Colors.red),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: pwdMatch?Colors.green:Colors.red, //边框颜色为绿色
                      width: ScreenUtil().setWidth(10), //宽度为5
                    ))
            ),
            onChanged: (text)=>{
              if(text != password){
                this.setState(() {
                  pwdMatch = false;
                })
              } else {
                this.setState(() {
                  pwdMatch = true;
                })
              }
            },
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(60.0),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: ScreenUtil().setHeight(60.0)),
          width: double.infinity,
          child: RaisedButton(
            padding: EdgeInsets.all(ScreenUtil().setWidth(24.0)),
            shape: StadiumBorder(),
            child: Text(
              "立 即 注 册",
              style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),
            ),
            color: Colors.green,
            onPressed: () async {
              bool flag = await signUpNow();
              if(flag) {
                timer.cancel();
                Navigator.pushNamed(context, "Login");
              }
            },
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(10.0),
        ),
      ],
    ),
  );

  Future<bool> signUpNow() async {
    if(pwdMatch == false) return false;
    Dio dio = new Dio();
    Map form = new Map<String, dynamic>();
    form["tel"] = tel;
    form["verifyCode"] = verifyCode;
    form["password"] = password;


    String url = "http://10.0.2.2:9000/user-service/register";
    Response response = await dio.post(url, queryParameters: form);
    print(response.data["status"]);

    return response.data["status"];
  }

  void getVeriCode() async {
    if(tel.isEmpty) return;
    Dio dio = new Dio();
    String url = "http://10.0.2.2:9000/user-service/verify?tel="+tel;
    Response response = await dio.post(url);
    print(response.data["status"]);
  }

  void myCountDown() {
      setState(() {
        countDown = 60;
      });
      timer = new Timer.periodic(
          Duration(milliseconds: 1000), (timer){
            if(countDown == 0){
              timer.cancel();
              return;
            }
            setState(() {
              countDown --;
            });
      });

    return;
  }

}