import 'package:demo5/common/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:validators/validators.dart';
import 'package:demo5/states/index.dart';

class PasswordSettingView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyPasswordSettingView();
  }

}
class MyPasswordSettingView extends State<PasswordSettingView>{

  TextEditingController oldPwdCtrl=new TextEditingController();
  TextEditingController newPwdCtrl=new TextEditingController();
  TextEditingController newPwdCfmCtrl=new TextEditingController();
  bool oldPwdVisible=false;
  bool newPwdVisible=false;
  bool newPwdCfmVisible=false;
  final _formKey=GlobalKey<FormState>();

  String newPwdValidator(String val){
    if(!isLength(val, 6,20)&&!isNull(val))
      return "你的密码长度应该在6-20位之间";
    return null;
  }

  String newPwdCfmValidator(String val){
    if(!equals(val,newPwdCtrl.text))
      return  "你输入的密码与前面的密码不一致";
    return null;
  }

  Future<bool> updatePassword() async {
    if(!equals(newPwdCfmCtrl.text, newPwdCtrl.text)){
      Fluttertoast.showToast(
          msg: "两次输入密码不一致",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return false;
    }
    if(newPwdCtrl.text.length < 6 || newPwdCtrl.text.length > 20){
      Fluttertoast.showToast(
          msg: "密码的长度不符合要求",
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
    String url = "http://10.0.2.2:9000/user-service/user/"+Global.userId.toString()+"/password";
    FormData formData = FormData.fromMap({'oldPassword':oldPwdCtrl.text, "newPassword":newPwdCtrl.text});
    Response response = await dio.patch(url, data:formData);
    print(response.data["status"]);
    if(response.data["status"] == 0){
      Fluttertoast.showToast(
          msg: "密码已更新",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
        title: Text('修改密码'),
        actions: <Widget>[
          MaterialButton(
            child: Text(
              "保存",
              style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(36)),
            ),
            onPressed: () async {
              if(await updatePassword())
                Navigator.pop(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
            key:_formKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                Container(
                  child: TextFormField(
                    controller: oldPwdCtrl,
                    obscureText: !oldPwdVisible,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      hintText: '请输入你的旧密码',
                      helperText: '你的旧密码将会帮助我们确认你的身份',
                      helperStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                          mainAxisSize: MainAxisSize.min, // added line
                          children:<Widget>[
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: ()=>oldPwdCtrl.clear(),
                            ),

                            IconButton(
                              icon: Icon(oldPwdVisible?Icons.visibility:Icons.visibility_off),
                              onPressed: ()=>setState(() {
                                oldPwdVisible=!oldPwdVisible;
                              }),
                            )
                          ]
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  padding: EdgeInsets.only(
                      top:ScreenUtil().setWidth(20),
                      left:ScreenUtil().setWidth(20),
                      right:ScreenUtil().setWidth(20)
                  ),
                ),

                Container(
                  child:
                  TextFormField(
                    controller: newPwdCtrl,
                    obscureText: !newPwdVisible,
                    validator: (val)=>newPwdValidator(val),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      hintText: '请输入你的新密码',
                      helperText: '新密码将会重置你的密码',
                      helperStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      border: OutlineInputBorder(),
                      suffixIcon:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                          mainAxisSize: MainAxisSize.min, // added line
                          children:<Widget>[
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: ()=>newPwdCtrl.clear(),
                            ),

                            IconButton(
                              icon: Icon(newPwdVisible?Icons.visibility:Icons.visibility_off),
                              onPressed: ()=>setState(() {
                                newPwdVisible=!newPwdVisible;
                              }),
                            )
                          ]
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(
                      top:ScreenUtil().setWidth(20),
                      left:ScreenUtil().setWidth(20),
                      right:ScreenUtil().setWidth(20)
                  ),
                ),

                Container(
                  child:
                  TextFormField(
                    validator: (val)=>newPwdCfmValidator(val),
                    obscureText: !newPwdCfmVisible,
                    controller: newPwdCfmCtrl,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      hintText: '请再次输入你的新密码',
                      helperText: '两次输入的密码应该保持一致',
                      helperStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      suffixIcon:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                          mainAxisSize: MainAxisSize.min, // added line
                          children:<Widget>[
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: ()=>newPwdCfmCtrl.clear(),
                            ),

                            IconButton(
                              icon: Icon(newPwdCfmVisible?Icons.visibility:Icons.visibility_off),
                              onPressed: ()=>setState(() {
                                newPwdCfmVisible=!newPwdCfmVisible;
                              }),
                            )
                          ]
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  padding: EdgeInsets.only(
                      top:ScreenUtil().setWidth(20),
                      left:ScreenUtil().setWidth(20),
                      right:ScreenUtil().setWidth(20)
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}
