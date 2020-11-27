import 'package:flutter/material.dart';
import '../Class/AlarmInfo.dart';
import '../common/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/screenutil.dart';

class LoginView extends StatelessWidget {
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
              hintText: "Enter your username",
              labelText: "用户名/手机号",
              labelStyle: TextStyle(color: Colors.green),
              focusedBorder: OutlineInputBorder(
                 borderSide: BorderSide(
                   color: Colors.green, //边框颜色为绿色
                   width: ScreenUtil().setWidth(10), //宽度为5
                 )),
            ),
            onSubmitted: (text){
              user = text;
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
                hintText: "Enter your password",
                labelText: "密码",
                labelStyle: TextStyle(color: Colors.green),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green, //边框颜色为绿色
                      width: ScreenUtil().setWidth(10), //宽度为5
                    ))
            ),
            onSubmitted: (text){
              password = text;},
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
            onPressed: () {
              // initAlarmList();
              Login();
              if(Global.hasLogin){
               Navigator.pushNamed(context,"HomePage");
              }
            },
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(10.0),
        ),
        Text(
          "SIGN UP FOR AN ACCOUNT",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );

  // ignore: non_constant_identifier_names
  void Login() async{
    print(user);
    print(password);
    Dio dio = new Dio();

    String url = "http://10.0.2.2:9000/user-service/login?credentials="+user+"&client_id=issuesApp&client_secret=sjtu&password="+password+"&grant_type=password";
    print(url);
    Response response = await dio.get(url);
    print(response.data["status"]);
    if(response.data["status"] == 0){
      Global.saveHasLogin(true);
      Global.hasLogin = true;
    }
  }

  void initAlarmList() async {
    Dio dio = new Dio();
    String url ="http://10.0.2.2:9000/alarm-service/alarm/getAlarmList/"+"1";
    Response response = await dio.get(url);
    List<dynamic> maps= response.data;
    // maps.forEach((element) {
    //   print(element);
    //   AlarmInfo alarmInfo = AlarmInfo.fromJson(element);
    //   Global.webAlarmList.add(alarmInfo);
    // });
    print(maps);
  }
}
