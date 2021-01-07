import 'package:demo5/common/global.dart';
import 'package:demo5/states/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class NameSettingView extends StatelessWidget{

  Future<void> updateName(String name) async {
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    FormData formData = FormData.fromMap({"name": name});
    String url = "http://"+Global.url+":9000/user-service/user/"+Global.userId.toString()+"/name";
    Response response = await dio.patch(url, data: formData);

    if(response.data["status"] == 0){
      Fluttertoast.showToast(
          msg: "用户名更新成功",
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
    TextEditingController ctrl = new TextEditingController(text:userModel.name);

    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
        title: Text('修改姓名'),
        actions: <Widget>[
          MaterialButton(
            child: Text(
              "保存",
              style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(36)),
            ),
            onPressed: (){
              userModel.name = ctrl.text;
              updateName(ctrl.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),

      body: Column(
          children:<Widget>[
            Container(
              child: TextField(
                controller: ctrl,
                enabled: ctrl.text == ""? true:false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 25,top:20),
                  border: OutlineInputBorder(
                    borderSide:BorderSide(width: 10,color: Colors.white), borderRadius:BorderRadius.circular(10)
                  )
                ),
              ),
              padding: EdgeInsets.only(top:10,left: 10,right: 10),
            ),
            ctrl.text == ""? Text("每个用户只允许在初始时设置姓名，设置后将不能更改。"):Text('你的姓名已经绑定，无法再进行修改')
          ]
      )
    );
  }
}
