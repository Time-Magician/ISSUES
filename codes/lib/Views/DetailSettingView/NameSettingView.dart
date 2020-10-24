import 'package:demo5/Class/UserState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NameSettingView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    var userState = context.watch<UserState>();
    TextEditingController ctrl = new TextEditingController(text:userState.name);

    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
        title: Text('修改姓名'),
      ),
      body: Column(
          children:<Widget>[
            Container(
              child: TextField(
                controller: ctrl,
                enabled: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 25,top:20),
                  helperText: '你的姓名在你注册时已经与账号绑定，无法再进行修改',
                  border: OutlineInputBorder(
                    borderSide:BorderSide(width: 10,color: Colors.white), borderRadius:BorderRadius.circular(10)
                  )
                ),
              ),
              padding: EdgeInsets.only(top:10,left: 10,right: 10),
            ),
            Text('你的姓名在你注册时已经与账号绑定，无法再进行修改')
          ]
      )
    );
  }
}
