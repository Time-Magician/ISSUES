import 'package:flutter/material.dart';
import 'package:demo5/Utils/UIdata.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      Image.asset("assets/image/Froglogo.png", width: 100,),
      SizedBox(
        height: 30.0,
      ),
      Text(
        "Welcome to ISSUES",
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.green),
      ),
      SizedBox(
        height: 5.0,
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
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
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
                   width: 5, //宽度为5
                 ))
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
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
                      width: 5, //宽度为5
                    ))
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
          width: double.infinity,
          child: RaisedButton(
            padding: EdgeInsets.all(12.0),
            shape: StadiumBorder(),
            child: Text(
              "登录",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
            onPressed: () {
              Navigator.pushNamed(context,"HomePage");
            },
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          "SIGN UP FOR AN ACCOUNT",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}
