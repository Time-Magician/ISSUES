import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:demo5/states/index.dart';

class PasswordSettingView extends StatefulWidget{
  _PasswordSettingViewState createState() => _PasswordSettingViewState();
}
class _PasswordSettingViewState extends State<PasswordSettingView>{

  TextEditingController oldPwdCtrl=new TextEditingController();
  TextEditingController newPwdCtrl=new TextEditingController();
  TextEditingController newPwdCfmCtrl=new TextEditingController();
  bool oldPwdVisible=false;
  bool newPwdVisible=false;
  bool newPwdCfmVisible=false;
  final _formKey=GlobalKey<FormState>();

  String newPwdValidator(String val){
    if(!isLength(val, 6,20)&&!isNull(val))
      return "你的密码长度应该在6-20位之间";
    return null;
  }

  String newPwdCfmValidator(String val){
    if(!equals(val,newPwdCtrl.text))
      return  "你输入的密码与前面的密码不一致";
    return null;
  }
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
      body: Form(
        key:_formKey,
        autovalidate: true,
        child: Column(
          children: <Widget>[
            Container(
              child:
                TextFormField(
                  controller: oldPwdCtrl,
                  obscureText: !oldPwdVisible,
                  decoration: InputDecoration(
                    hintText: '请输入你的旧密码',
                    helperText: '你的旧密码将会帮助我们确认你的身份',
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                      mainAxisSize: MainAxisSize.min, // added line
                      children:<Widget>[
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: ()=>oldPwdCtrl.clear(),
                        ),

                        IconButton(
                          icon: Icon(oldPwdVisible?Icons.visibility:Icons.visibility_off),
                          onPressed: ()=>setState(() {
                            oldPwdVisible=!oldPwdVisible;
                          }),
                        )
                      ]
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

              padding: EdgeInsets.only(top:20,left:10,right:10),
            ),

            Container(
              child:
                TextFormField(
                  controller: newPwdCtrl,
                  obscureText: !newPwdVisible,
                  validator: (val)=>newPwdValidator(val),
                  decoration: InputDecoration(
                    hintText: '请输入你的新密码',
                    helperText: '新密码将会重置你的密码',
                    border: OutlineInputBorder(),
                    suffixIcon:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                      mainAxisSize: MainAxisSize.min, // added line
                      children:<Widget>[
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: ()=>newPwdCtrl.clear(),
                        ),

                        IconButton(
                          icon: Icon(newPwdVisible?Icons.visibility:Icons.visibility_off),
                          onPressed: ()=>setState(() {
                            newPwdVisible=!newPwdVisible;
                          }),
                        )
                      ]
                    ),
                  ),
                ),

              padding: EdgeInsets.only(top:20,left:10,right:10),
            ),

            Container(
              child:
              TextFormField(
                validator: (val)=>newPwdCfmValidator(val),
                obscureText: !newPwdCfmVisible,
                controller: newPwdCfmCtrl,
                decoration: InputDecoration(
                  hintText: '请再次输入你的新密码',
                  helperText: '两次输入的密码应该保持一致',
                  suffixIcon:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                      mainAxisSize: MainAxisSize.min, // added line
                      children:<Widget>[
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: ()=>newPwdCfmCtrl.clear(),
                        ),

                        IconButton(
                          icon: Icon(newPwdCfmVisible?Icons.visibility:Icons.visibility_off),
                          onPressed: ()=>setState(() {
                            newPwdCfmVisible=!newPwdCfmVisible;
                          }),
                        )
                      ]
                  ),
                  border: OutlineInputBorder(),
                ),
              ),

              padding: EdgeInsets.only(top:20,left:10,right:10),
            )
          ],
        )
      )
    );
  }
}
