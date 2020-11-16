import 'dart:io';
import 'dart:math';
import 'package:demo5/index.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';

List<String> targetList = ["杯子","书","水龙头","灯","鞋","牙刷","笔","扫把","垃圾桶","插座"];

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
  String path;
  String target;
  bool correctFlag = false;

  Future takePhoto() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        haveTaken = true;
        _image = File(pickedFile.path);
        path = pickedFile.path;
      } else {
        print('No image selected.');
      }
    });
  }

  void freshTarget(){
    setState(() {
      target = targetList[(new Random()).nextInt(10)];
    });
  }

  void imageClassify(String path, Function stopLoading) async {
    if(path.isEmpty){
      emptyAlert();
      return;
    }
    if(Platform.isAndroid) {
      List<dynamic> data = await Global.methodChannel.invokeMethod("imageClassify",{"image":path});
      print(data);
      stopLoading();
      checkAccuracy(data);
    }
  }

  void checkAccuracy(List<dynamic> data){
    data.forEach((element)  {
      if(element.contains(target)){
        setState(() {
          correctFlag = true;
        });
      }
    });
    if(correctFlag)
      success();
    else
      failed();
  }

  void emptyAlert(){
    EasyDialog(
      fogOpacity: 0.12,
      width: ScreenUtil().setWidth(600),
      height: ScreenUtil().setWidth(360),
      closeButton: false,
      title: Text(
        "照片呢？",
        style: TextStyle(fontSize: ScreenUtil().setSp(40)),
      ),
      description: Text(
        "你还没有拍照片哦！快去找找对应的物品把它拍下来吧！",
        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
      ),
      contentList: [
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(180),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "确认",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ]
        )
      ],
    ).show(context);
  }

  void success(){
    EasyDialog(
      fogOpacity: 0.12,
      width: ScreenUtil().setWidth(600),
      height: ScreenUtil().setWidth(360),
      closeButton: false,
      title: Text(
        "好样的！",
        style: TextStyle(fontSize: ScreenUtil().setSp(40)),
      ),
      description: Text(
        "你已经成功地拍到了要求的物品，赶紧起床吧！",
        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
      ),
      contentList: [
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(180),
                child: FlatButton(
                  onPressed: () {
                    Global.advancedPlayer1.release();
                    Navigator.pushReplacementNamed(context, "HomePage");
                  },
                  child: Text(
                    "确认",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ]
        )
      ],
    ).show(context);
  }

  void failed(){
    EasyDialog(
      fogOpacity: 0.12,
      width: ScreenUtil().setWidth(600),
      height: ScreenUtil().setWidth(360),
      closeButton: false,
      title: Text(
        "出错啦！",
        style: TextStyle(fontSize: ScreenUtil().setSp(40)),
      ),
      description: Text(
        "你拍到的物品似乎不符合要求哦！重新试试吧！",
        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
      ),
      contentList: [
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(180),
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _image = null;
                      haveTaken = false;
                      path = "";
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "再拍一次",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ]
        )
      ],
    ).show(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    target = targetList[(new Random()).nextInt(10)];
    path = "";
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
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: ScreenUtil().setWidth(100),
              ),
              Text(
                target,
                style: TextStyle(fontSize: ScreenUtil().setSp(70)),
              ),
              Container(
                width: ScreenUtil().setWidth(100),
                child: IconButton(
                  icon: Icon(Icons.loop),
                  onPressed: () => freshTarget(),
                  color: Colors.white,
                  iconSize: ScreenUtil().setSp(56),
                ),
              )
            ],
          ),
        ),
        Row(
          children: [
            Container(
              width: ScreenUtil().setWidth(240),
              height: ScreenUtil().setWidth(600),
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
              height: ScreenUtil().setWidth(600),
              child: Image.asset("assets/image/animalsRight.png"),
            )
          ],
        ),
        Container(
          width: ScreenUtil().setWidth(720),
          height: ScreenUtil().setWidth(100),
          child: Container(
              width: ScreenUtil().setWidth(240),
              height: ScreenUtil().setWidth(100),
              child: Center(
                child: Container(
                  child: ArgonButton(
                    width: ScreenUtil().setWidth(200),
                    height: ScreenUtil().setWidth(120),
                    borderRadius: 5.0,
                    color: Color(0xFF7866FE),
                    child: Text(
                      "提 交",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    loader: Container(
                      padding: EdgeInsets.all(10),
                      child: SpinKitRing(
                        color: Colors.white,
                        // size: loaderWidth ,
                      ),
                    ),
                    onTap:(startLoading, stopLoading, btnState){
                      if (btnState == ButtonState.Idle) {
                        startLoading();
                        imageClassify(path, stopLoading);
                      }
                    },
                  ),
                ),
              )
          ),
        ),
        // Container(
        //   width: ScreenUtil().setWidth(720),
        //   height: ScreenUtil().setWidth(20),
        // )
      ],
    );
  }

}