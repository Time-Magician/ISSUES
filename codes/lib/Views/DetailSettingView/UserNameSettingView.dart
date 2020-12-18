import 'package:demo5/states/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

class UserNameSettingView extends StatelessWidget{
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
