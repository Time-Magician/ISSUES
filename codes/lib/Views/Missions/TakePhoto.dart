import 'dart:io';

import 'package:demo5/index.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:image_picker/image_picker.dart';

class TakePhoto extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyTakePhoto();
  }

}

class MyTakePhoto extends State<TakePhoto>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: const Color(0xFF75CCE8),
        resizeToAvoidBottomPadding: false,
        body:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ScreenUtil().setWidth(720),
              height: ScreenUtil().setWidth(280),
              child: Information(),
            ),
            Expanded(
              child: Container(
                width: ScreenUtil().setWidth(720),
                child: PhotoMission(),
              ),)
          ],
        )
    );;
  }

}

class Information extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyInformation();
  }

}

class MyInformation extends State<Information>{

  @override
  Widget build(BuildContext context) {
    DateTime dateTime= DateTime.now();
    // TODO: implement build
    return Row(
      children: [
        Container(
          width: ScreenUtil().setWidth(360),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dateTime.month.toString()+"月"+dateTime.day.toString()+"日",
                  style: TextStyle(fontSize: ScreenUtil().setSp(48)),
                  textAlign: TextAlign.left,
                ),
                Text(
                  dateTime.hour.toString()+" : "+(dateTime.minute<10?"0"+dateTime.minute.toString():dateTime.minute.toString()),
                  style: TextStyle(fontSize: ScreenUtil().setSp(70), fontFamily: "Miriam"),
                  textAlign: TextAlign.left,
                )
              ],
            ),
          ),
        ),
        Container(
          width: ScreenUtil().setWidth(360),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: ScreenUtil().setWidth(320),
                    child: Row(
                      children: [
                        Icon(
                            Icons.lightbulb_outline
                        ),
                        Text(
                          "TIPS",
                          style: TextStyle(fontSize: ScreenUtil().setSp(30), fontFamily: "Miriam"),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    )
                ),
                Container(
                  width: ScreenUtil().setWidth(320),
                  child: Text(
                    "小青蛙和同学们要拍合照啦，快帮帮它们找到要求出镜的物品吧！",
                    style: TextStyle(fontSize: ScreenUtil().setSp(27)),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

}

class PhotoMission extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyPhotoMission();
  }

}

class MyPhotoMission extends State<PhotoMission>{
  File _image;
  final picker = ImagePicker();
  bool haveTaken = false;

  Future takePhoto() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        haveTaken = true;
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "请找到",
          style: TextStyle(fontSize: ScreenUtil().setSp(48)),
        ),
        Text(
          "陈二狗",
          style: TextStyle(fontSize: ScreenUtil().setSp(70)),
        ),
        Row(
          children: [
            Container(
              width: ScreenUtil().setWidth(240),
              height: ScreenUtil().setWidth(640),
              child: Image.asset("assets/image/animalsLeft.png"),
            ),
            Column(
              children: [
                Container(
                  width: ScreenUtil().setWidth(240),
                  height: ScreenUtil().setWidth(72),
                ),
                Container(
                    width: ScreenUtil().setWidth(240),
                    height: ScreenUtil().setWidth(368),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/image/photoBorder.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(
                      child:
                      Container(
                        width: ScreenUtil().setWidth(210),
                        height: ScreenUtil().setWidth(320),
                        child: Center(
                          child: this.haveTaken?
                              Image.file(_image)
                              :IconButton(
                                icon: Icon(Icons.add_a_photo),
                                onPressed: () => takePhoto(),
                                color: Colors.white,
                                iconSize: 30,
                              ),
                        ),
                      ),
                    )
                ),

              ],
            ),
            Container(
              width: ScreenUtil().setWidth(240),
              height: ScreenUtil().setWidth(640),
              child: Image.asset("assets/image/animalsRight.png"),
            )
          ],
        ),
        Container(
          width: ScreenUtil().setWidth(720),
          height: ScreenUtil().setWidth(100),
          child: Container(
              width: ScreenUtil().setWidth(240),
              height: ScreenUtil().setWidth(240),
              child: Center(
                child: Container(
                  width: ScreenUtil().setWidth(200),
                  height: ScreenUtil().setWidth(120),
                  child: RaisedButton(
                    textTheme: ButtonTextTheme.accent,
                    color: const Color(0xFF33539E),
                    highlightColor: Colors.deepPurpleAccent,
                    splashColor: Colors.deepOrangeAccent,
                    colorBrightness: Brightness.dark,
                    onPressed: () {
                      //TODO

                    },
                    child: Text(
                      '提交',
                      style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(36)),
                    ),
                  ),
                ),
              )
          ),
        )
      ],
    );
  }

}