import 'package:demo5/Class/UserState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserNameSettingView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var userState=context.watch<UserState>();
    TextEditingController ctrl = new TextEditingController(text:userState.userName);

    return Scaffold(
      appBar:AppBar(
        title: Text('修改用户名'),
        actions: <Widget>[
          OutlineButton(
            child: Text('保存'),
            textColor: Colors.white,
            onPressed:(){
              userState.setUserName(ctrl.text);
              Navigator.pop(context);
            },
          )
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
