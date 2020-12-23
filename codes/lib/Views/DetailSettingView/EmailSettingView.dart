import 'dart:async';

import 'package:demo5/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:demo5/states/index.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class EmailSettingView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyEmailSettingView();
  }

}

class MyEmailSettingView extends State<EmailSettingView>{
  var userModel;
  int countDown;
  Timer timer;
  TextEditingController ctrl1;
  TextEditingController ctrl2;
  bool initFlag = false;

  final _fieldKey=GlobalKey<FormFieldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countDown = 0;
    if(Global.profile.user.email == null || Global.profile.user.email == ""){
      initFlag = true;
    }
  }

  Future<bool> updateEmail(String email, String verifyCode) async {
    if(verifyCode.isEmpty || verifyCode == ""){
      Fluttertoast.showToast(
          msg: "验证码不能为空",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return false;
    }
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    FormData formData = FormData.fromMap({"email": email, "verifyCode":verifyCode});
    String url = "http://10.0.2.2:9000/user-service/user/"+Global.userId.toString()+"/email";
    Response response = await dio.patch(url, data: formData);
    if(response.data["status"] == 0){
      userModel.email = email;
      Fluttertoast.showToast(
          msg: "邮箱绑定成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return true;
    } else if(response.data["status"] == -1){
      Fluttertoast.showToast(
          msg: "验证码错误",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return false;
    }
    return false;

  }

  void getVeriCode(String email) async {
    if(!emailValidator(email)) return;
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    String url = "http://10.0.2.2:9000/user-service/verify/email";
    FormData formData = FormData.fromMap({'email':email});
    Response response = await dio.post(url,data:formData);
    print(response.data["status"]);
    if(response.data["status"] == 0){
      Fluttertoast.showToast(
          msg: "验证码已发送",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  void myCountDown() {
    setState(() {
      countDown = 60;
    });
    timer = new Timer.periodic(
        Duration(milliseconds: 1000), (timer) {
      if (countDown == 0) {
        timer.cancel();
        return;
      }
      setState(() {
        countDown --;
      });
    });
  }

  bool emailValidator(String val){
    if(isNull(val)){
      Fluttertoast.showToast(
          msg: "输入的邮箱不能为空",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return false;
    }
    if(!isEmail(val)){
      Fluttertoast.showToast(
          msg: "邮箱格式不正确",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return false;
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    userModel = context.watch<UserModel>();
    if(ctrl1 == null){
      ctrl1 = new TextEditingController(text: Global.profile.user.email);
      ctrl2 = new TextEditingController();
    }
    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
        title: Text('修改邮箱'),
        actions: <Widget>[
          MaterialButton(
            child: Text(
              "保存",
              style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(36)),
            ),
            onPressed: ()async{
              if(!initFlag)
                Navigator.pop(context);
              if(await updateEmail(ctrl1.text, ctrl2.text))
                Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        width: ScreenUtil().setWidth(720),
        child: Column(
            children:<Widget>[
              Row(
                children: [
                  Container(
                      width: ScreenUtil().setWidth(110),
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(10)),
                      child: Text(
                        "邮箱",
                        style: TextStyle(fontSize: ScreenUtil().setSp(32)),
                      )
                  ),
                  Container(
                    width: ScreenUtil().setWidth(550),
                    child: TextField(
                      controller: ctrl1,
                      enabled: initFlag,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                          border: OutlineInputBorder(
                              borderSide:BorderSide(width: ScreenUtil().setWidth(36),color: Colors.white), borderRadius:BorderRadius.circular(ScreenUtil().setWidth(10))
                          )
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), ScreenUtil().setWidth(20), ScreenUtil().setWidth(20), ScreenUtil().setWidth(10),),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                      width: ScreenUtil().setWidth(110),
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(10)),
                      child: Text(
                        "验证码",
                        style: TextStyle(fontSize: ScreenUtil().setSp(32)),
                      )
                  ),
                  Container(
                    width: ScreenUtil().setWidth(320),
                    child: TextField(
                      controller: ctrl2,
                      enabled: initFlag,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20), top:ScreenUtil().setWidth(10)),
                          border: OutlineInputBorder(
                              borderSide:BorderSide(width: ScreenUtil().setWidth(36),color: Colors.white), borderRadius:BorderRadius.circular(ScreenUtil().setWidth(10))
                          )
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), ScreenUtil().setWidth(10), ScreenUtil().setWidth(10), ScreenUtil().setWidth(20)),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(210),
                    margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), ScreenUtil().setWidth(10), ScreenUtil().setWidth(20), ScreenUtil().setWidth(20)),
                    child: countDown == 0?OutlineButton(
                      highlightedBorderColor: Colors.green,
                      onPressed: () {
                        if(initFlag){
                          getVeriCode(ctrl1.text);
                          myCountDown();
                        }
                      },
                      child: Text(
                          "获取验证码"
                      ),
                    ):OutlineButton(
                      highlightedBorderColor: Colors.blue,
                      onPressed: null,
                      child: Text(
                          countDown.toString()
                      ),
                    ),
                  )
                ],
              ),
              initFlag? Text("每个用户只允许在初始时绑定邮箱，绑定后将不能更改。"):Text('你的邮箱已经绑定，无法再进行修改')
            ]
        ),
      )
    );
  }
}
