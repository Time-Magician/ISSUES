import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class SignUpView extends StatelessWidget {
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
            maxLines: 1,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.perm_identity, color: Colors.green),
                hintText: "请输入用户名",
                labelText: "用户名",
                labelStyle: TextStyle(color: Colors.green),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green, //边框颜色为绿色
                      width: ScreenUtil().setWidth(10), //宽度为5
                    ))
            ),
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
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10.0), horizontal: ScreenUtil().setHeight(60.0)),
          child: TextField(
            maxLines: 1,
            obscureText: true,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline, color: Colors.green),
                hintText: "请再次输入密码",
                labelText: "确认密码",
                labelStyle: TextStyle(color: Colors.green),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green, //边框颜色为绿色
                      width: ScreenUtil().setWidth(10), //宽度为5
                    ))
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10.0), horizontal: ScreenUtil().setHeight(60.0)),
          child: TextField(
            maxLines: 1,
            obscureText: true,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail_outline, color: Colors.green),
                hintText: "请输入邮箱",
                labelText: "邮箱",
                labelStyle: TextStyle(color: Colors.green),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green, //边框颜色为绿色
                      width: ScreenUtil().setWidth(10), //宽度为5
                    ))
            ),
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
            onPressed: () {
              signUpNow();
            },
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(10.0),
        ),
      ],
    ),
  );

  signUpNow() async {

  }
}