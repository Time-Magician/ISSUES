import 'package:flutter/material.dart';
import 'package:demo5/states/index.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class EmailSettingView extends StatelessWidget{
  final _fieldKey=GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {

    var userModel = context.watch<UserModel>();
    TextEditingController ctrl = new TextEditingController(text: userModel.email);
    String emailValidator(String val){
      if(isNull(val))
        return '你的邮箱地址不能为空';
      if(!isEmail(val))
        return '你输入的邮箱地址不符合格式';
      return null;
    }
    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
        title: Text('修改邮箱'),
        actions: <Widget>[
          OutlineButton(
            child: Text('保存'),
            textColor: Colors.white,
            onPressed:(){
              if(_fieldKey.currentState.validate()){
                userModel.email = ctrl.text;
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: TextFormField(
        key:_fieldKey,
        controller: ctrl,
        autovalidate:true,
        validator: (val)=>emailValidator(val),
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
