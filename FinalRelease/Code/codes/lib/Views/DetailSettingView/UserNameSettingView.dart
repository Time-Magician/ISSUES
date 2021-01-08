import 'package:demo5/common/global.dart';
import 'package:demo5/states/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class UserNameSettingView extends StatelessWidget{
  void updateUsername(String username) async {
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    FormData formData = FormData.fromMap({"username":username});
    String url = "http://10.0.2.2:9000/user-service/user/"+Global.userId.toString()+"/username";
    Response response = await dio.patch(url, data: formData);

    if(response.data["status"] == 0){
      Fluttertoast.showToast(
          msg: "用户名更新成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var userModel=context.watch<UserModel>();
    TextEditingController ctrl = new TextEditingController(text:userModel.userName);

    return Scaffold(
      appBar:AppBar(
        title: Text('修改用户名'),
        actions: <Widget>[
          MaterialButton(
            child: Text(
              "保存",
              style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(36)),
            ),
            onPressed: (){
                userModel.userName = ctrl.text;
                updateUsername(ctrl.text);
                Navigator.pop(context);
            },
          ),
        ],
      ),
      body: TextField(
        controller: ctrl,
        keyboardType: TextInputType.text,
        decoration:InputDecoration(
          helperText: '你的名字将会在社交系统中对外显示。',
          helperStyle: TextStyle(
              fontSize: 16
          ),
          contentPadding: EdgeInsets.only(left: 25,top:20),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: ()=>ctrl.clear(),
          ),

        ),
      )
    );
  }
}
