import 'package:flutter/material.dart';

class NameSettingView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
        title: Text('修改姓名'),
      ),
      body: TextFormField(
        enabled: false,
        decoration: InputDecoration(
          helperText: '你的姓名在你注册时已经与账号绑定，无法再进行修改',
          border: OutlineInputBorder(
            borderSide:BorderSide(width: 10,color: Colors.white), borderRadius:BorderRadius.circular(10)
          )
        ),
      )
    );
  }
}
