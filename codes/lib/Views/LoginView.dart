import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/AlarmInfo.dart';
import '../common/global.dart';
import 'package:dio/dio.dart';
import '../models/Frog.dart';
import 'package:flutter_screenutil/screenutil.dart';

class LoginView extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyLoginView();
  }
}

class MyLoginView extends State<LoginView>{
  String user = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: loginBody(context),
      ),
    );
  }

  loginBody(context) => SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[loginHeader(), loginFields(context)],
    ),
  );

  loginHeader() => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Image.asset("assets/image/Froglogo.png", width: ScreenUtil().setWidth(200),),
      SizedBox(
        height: ScreenUtil().setHeight(60.0),
      ),
      Text(
        "Welcome to ISSUES",
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.green),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(10.0),
      ),
      Text(
        "Sign in to continue",
        style: TextStyle(color: Colors.grey),
      ),
    ],
  );

  loginFields(context) => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(32.0), horizontal: ScreenUtil().setWidth(60.0)),
          child: TextField(
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
                  )),
            ),
            onChanged: (text){
              setState(() {
                user = text;
              });
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: ScreenUtil().setHeight(60.0)),
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
            onChanged: (text){
              setState(() {
                password = text;
              });
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
              "登录",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
            onPressed: () async {
              // initAlarmList();
              bool flag = await Login();
              if(flag){
                Navigator.pushNamed(context,"HomePage");
              }
            },
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(10.0),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, "SignUp"),
          child: Text(
            "立即注册",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    ),
  );

  // ignore: non_constant_identifier_names
  Future<bool> Login() async{
    print(user);
    print(password);
    Dio dio = new Dio();

    String url = "http://10.0.2.2:9000/user-service/login?credentials="+user+"&password="+password+"&client_id=issuesApp&client_secret=sjtu";
    Response response = await dio.get(url);
    // print(response.data["extraInfo"]["access_token"]);
    if(response.data["status"] == 0){
      Global.saveHasLogin(true);
      Global.saveToken(response.data["extraInfo"]["access_token"]);
      Global.saveUserId(response.data["data"]["userId"]);
      Global.token = response.data["extraInfo"]["access_token"];
      Global.hasLogin = true;
      Global.userId = response.data["data"]["userId"];

      await initAlarmList(response.data["data"]["userId"]);
      await initFrog(response.data["data"]["userId"]);
      return Global.hasLogin;
    }
    else
      return Global.hasLogin;
  }

  Future<void> initAlarmList(int userId) async {
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    String url = "http://10.0.2.2:9000/alarm-service/user/"+userId.toString()+"/alarms";
    Response response = await dio.get(url);
    Global.alarmList = [];
    await Global.initDB();
    response.data.forEach((element) {
      AlarmInfo alarm = AlarmInfo.fromJson(element);
      alarm.vibration = false;
      alarm.isOpen = false;
      Global.saveAlarm(alarm);
      Global.alarmList.add(alarm);
    });
  }

  Future<void> initFrog(int userId) async {
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    String url = "http://10.0.2.2:9000/study-service/user/"+userId.toString()+"/frog";
    Response response = await dio.get(url);
    print(response.data);
    if(response.data == ""){
      url = "http://10.0.2.2:9000/study-service/user/"+userId.toString()+"/frog";
      FormData formData = FormData.fromMap({"name":Frog.randomFrogName(),"level":0,"exp":0,"is_graduated":false,"graduate_date":"","school":Frog.randomSchoolName()});
      response = await dio.post(url,data:formData);
      Frog _frog = Frog(response.data["frogId"],response.data["name"] , response.data["level"], response.data["exp"], response.data["graduated"], response.data["graduateDate"], response.data["school"]);
      Global.frog = _frog;
      Global.saveFrog();
    }
    else{
    Frog _frog = Frog(response.data["frogId"],response.data["name"] , response.data["level"], response.data["exp"], response.data["graduated"], response.data["graduateDate"], response.data["school"]);
    Global.frog = _frog;
    Global.saveFrog();
    }
  }

  Future<void> createFirstFrog(int userId) async {
    Dio dio = new Dio();
    String url = "http://10.0.2.2:9000/study-service/user/"+userId.toString()+"/frog";

  }

}
