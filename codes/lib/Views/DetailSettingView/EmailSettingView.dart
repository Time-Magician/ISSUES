import 'package:flutter/material.dart';
import 'package:demo5/Class/UserState.dart';
import 'package:provider/provider.dart';

class EmailSettingView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    var userState = context.watch<UserState>();
    TextEditingController ctrl = new TextEditingController(text: userState.email);

    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
        title: Text('修改邮箱'),
        actions: <Widget>[
          OutlineButton(
            child: Text('保存'),
            textColor: Colors.white,
            onPressed:(){
              userState.setEmail(ctrl.text);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.emailAddress,
        decoration:InputDecoration(
          contentPadding: EdgeInsets.only(left: 25,top:20),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: ()=>ctrl.clear(),
          ),
          helperText: '你的邮箱进行修改时，需要你输入密码验证本人的身份',
          helperStyle: TextStyle(
              fontSize: 16
          )
        ),
      )
    );
  }
}
