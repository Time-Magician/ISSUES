import 'package:flutter/material.dart';

class EmailSettingView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
        title: Text('修改邮箱'),
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
        keyboardType: TextInputType.emailAddress,
        decoration:InputDecoration(
            helperText: '你的邮箱进行修改时，需要你输入密码验证本人的身份',
            helperStyle: TextStyle(
                fontSize: 16
            )
        ),
      )
    );
  }
}
