import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';

class StudyRoomWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyStudyRoomWidget();
  }

}

class MyStudyRoomWidget extends State<StudyRoomWidget>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xFF75CCE8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('自习室'),
      ),
      body: StudyRoom(),
    );
  }
}

class StudyRoom extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyStudyRoom();
  }
}

class MyStudyRoom extends State<StudyRoom>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(

              child: SizedBox(
                  height: ScreenUtil().setHeight(320),
                  width: ScreenUtil().setWidth(640),
                  child: RaisedButton(
                      textTheme: ButtonTextTheme.accent,
                      color: const Color(0xFF33539E),
                      highlightColor: Colors.deepPurpleAccent,
                      splashColor: Colors.deepOrangeAccent,
                      colorBrightness: Brightness.dark,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(16))
                      ),
                      onPressed: () {
                        //TODO
                        Navigator.pushNamed(context, "Camera");
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.business,
                            size: ScreenUtil().setWidth(128),
                            color: Colors.white,
                          ),
                          Text(
                            '公 共 自 习 室',
                            style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(72)),
                          ),
                        ],
                      )
                  )),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, ScreenUtil().setHeight(80), 0, 0),
            child: SizedBox(
                height: ScreenUtil().setHeight(320),
                width: ScreenUtil().setWidth(640),
                child: RaisedButton(
                    textTheme: ButtonTextTheme.accent,
                    color: const Color(0xFF26A65B),
                    highlightColor: Colors.deepPurpleAccent,
                    splashColor: Colors.deepOrangeAccent,
                    colorBrightness: Brightness.dark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(16))
                    ),
                    onPressed: () {
                      //TODO
                      Navigator.pushNamed(context, "Test");
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.people,
                          size: ScreenUtil().setWidth(128),
                          color: Colors.white,
                        ),
                        Text(
                          '小 组 学 习 室',
                          style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(72)),
                        ),
                      ],
                    )
                )),
          )
        ],
      ),
    );
  }
  void startService() async{
    if(Platform.isAndroid) {
      var methodChannel = MethodChannel("com.example.demo5");
      String data = await methodChannel.invokeMethod("startService");
      print("data: $data");
    }
  }
}

