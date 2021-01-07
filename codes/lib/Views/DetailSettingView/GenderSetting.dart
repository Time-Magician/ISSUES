import 'package:demo5/common/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_select/smart_select.dart';
import 'package:provider/provider.dart';
import 'package:demo5/states/index.dart';

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

  void updateGender(String gender) async {
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    FormData formData = FormData.fromMap({"gender": gender});
    String url = "http://"+Global.url+":9000/user-service/user/"+Global.userId.toString()+"/gender";
    Response response = await dio.patch(url, data: formData);

    if(response.data["status"] == 0){
      Fluttertoast.showToast(
          msg: "信息更新成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModel>();
    return Scaffold(
      appBar:AppBar(
        title: Text('修改性别'),
        actions: <Widget>[
          MaterialButton(
            child: Text(
              "保存",
              style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(36)),
            ),
            onPressed:(){
              userModel.gender = genderValue;
              updateGender(genderValue);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: GenderSelect(callback:(val)=>onChange(val),value:userModel.gender)
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
      modalType: S2ModalType.bottomSheet,
      value: value,
      onChange: (state)
        {setState(() => value = state.value);
        widget.callback(state.value);
      },
    );
  }

}
