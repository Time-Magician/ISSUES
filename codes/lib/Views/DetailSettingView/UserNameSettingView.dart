import 'package:flutter/material.dart';

class UserNameSettingView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
        title: Text('修改用户名'),
        actions: <Widget>[
          OutlineButton(
            child: Text('保存'),
            textColor: Colors.white,
            onPressed:(){
              return null;
            },
          )
        ],
      ),
      body: TextFormField(
        keyboardType: TextInputType.text,
        decoration:InputDecoration(
          helperText: '你的名字将会在社交系统中对外显示。',
          helperStyle: TextStyle(
            fontSize: 16
          )
        ),
      )
    );
  }
}