import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';

class GenderSettingView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
        title: Text('修改性别'),
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
      body: GenderSelect()
    );
  }
}

class GenderSelect extends StatefulWidget{
  @override
  createState()=> new _GenderSelectState();
}

class _GenderSelectState extends State<GenderSelect>{
  int value;
  List<S2Choice<int>> genderOptions=[
    S2Choice<int>(value:1,title:'男性'),
    S2Choice<int>(value:2,title:'女性'),
    S2Choice<int>(value:3,title:'其他'),
  ];
  @override
  Widget build(BuildContext context) {
    return SmartSelect<int>.single(
      title:'性别',
      choiceItems:genderOptions,
      value: value,
      
      onChange: (state) => setState(() => value = state.value),
    );
  }

}
