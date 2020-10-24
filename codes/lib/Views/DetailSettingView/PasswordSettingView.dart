import 'package:flutter/material.dart';

class PasswordSettingView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
        title: Text('修改密码'),
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
      body: Text("nihao"),
    );
  }
}
