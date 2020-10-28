import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:provider/provider.dart';
import 'package:demo5/Class/UserState.dart';

class GenderSettingView extends StatefulWidget{
  @override
  _GenderSettingViewState createState()=>_GenderSettingViewState();
}

class _GenderSettingViewState extends State<GenderSettingView>{
  String genderValue;
  void onChange(val){
    setState(() {
      genderValue=val;
    });
  }

  @override
  Widget build(BuildContext context) {
    var userState = context.watch<UserState>();
    return Scaffold(
      appBar:AppBar(
        title: Text('修改性别'),
        actions: <Widget>[
          OutlineButton(
            child: Text('保存'),
            textColor: Colors.white,
            onPressed:(){
              userState.setGender(genderValue);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: GenderSelect(callback:(val)=>onChange(val),value:userState.gender)
    );
  }
}

class GenderSelect extends StatefulWidget{
  final callback;
  final value;
  GenderSelect({Key key,this.callback,this.value}):super(key:key);

  @override
  createState()=> new _GenderSelectState();
}

class _GenderSelectState extends State<GenderSelect>{
  String value;
  void initState(){
    super.initState();
    setState(() {
      value=widget.value;
    });
  }
  List<S2Choice<String>> genderOptions=[
    S2Choice<String>(value:'男性',title:'男性'),
    S2Choice<String>(value:'女性',title:'女性'),
    S2Choice<String>(value:'其他',title:'其他'),
  ];
  @override
  Widget build(BuildContext context) {
    return SmartSelect<String>.single(
      title:'性别',
      choiceItems:genderOptions,
      value: value,
      onChange: (state)
        {setState(() => value = state.value);
        widget.callback(state.value);
      },
    );
  }

}
