import 'dart:convert';

import 'package:demo5/index.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    Global.saveHasLogin(false);
    Global.hasLogin = false;
    Global.clearDB();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: true);
    return Scaffold(
      backgroundColor: const Color(0xFF75CCE8),
      body: WillPopScope(
        onWillPop: () async{
          return false;
        },
        child: Center(
          child: loginBody(context),
        ),
      )
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
      Image.asset("assets/image/login.png", width: ScreenUtil().setWidth(240)),
      SizedBox(
        height: ScreenUtil().setHeight(20.0),
      ),
      Text(
        "ISSUES",
        style: TextStyle(fontSize: ScreenUtil().setSp(70), fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Knewave'),
      ),
      // SizedBox(
      //   height: ScreenUtil().setHeight(10.0),
      // ),
      // Text(
      //   "Sign in to continue",
      //   style: TextStyle(color: Colors.white),
      // ),
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
              prefixIcon: Icon(Icons.perm_identity, color: Colors.black54),
              hintText: "请输入手机号",
              hintStyle: TextStyle(color: Colors.black54),
              labelText: "手机号",
              labelStyle: TextStyle(color: Colors.black54),
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
                prefixIcon: Icon(Icons.lock_outline, color: Colors.black54),
                hintText: "请输入密码",
                labelText: "密码",
                labelStyle: TextStyle(color: Colors.black54),
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
              } else {
                Fluttertoast.showToast(
                    msg: "账号或密码错误 TAT",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.redAccent,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
              // Navigator.pushNamed(context,"HomePage");
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
            style: TextStyle(color: Colors.black54),
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
    print(response.data);
    if(response.data["status"] == 0){
      Global.saveHasLogin(true);
      Global.saveToken(response.data["extraInfo"]["access_token"]);
      Global.saveUserId(response.data["data"]["userId"]);
      User user = new User(
        response.data["data"]["userId"],
        response.data["data"]["username"],
        response.data["data"]["name"],
        response.data["data"]["email"],
        response.data["data"]["gender"],
        password
      );
      Global.profile.user = user;
      Global.saveProfile();
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
    String url = "http://10.0.2.2:9000/study-service/user/"+userId.toString()+"/frogs/candidate";
    Response response = await dio.get(url);
    print(response.data);
    if(response.data == ""){
      url = "http://10.0.2.2:9000/study-service/user/"+userId.toString()+"/frogs";
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
    String url = "http://10.0.2.2:9000/study-service/user/"+userId.toString()+"/frogs";

  }

}
