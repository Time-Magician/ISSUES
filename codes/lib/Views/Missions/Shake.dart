import 'package:demo5/Views/StudyView.dart';
import 'package:demo5/index.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_screenutil/screenutil.dart';
import '../../common/global.dart';



class Shake extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyShake();
  }

}

class MyShake extends State<Shake>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: const Color(0xFF75CCE8),
        resizeToAvoidBottomPadding: false,
        body:WillPopScope(
          onWillPop: () async{
            return false;
          },
          child:Column(
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
                  child: ShakeMission(),
                ),)
            ],
          )
        )
    );
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
                    "小青蛙们都躲到了树上，连续摇晃手机来帮助青蛙妈妈把它们都找回来吧！",
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

class ShakeMission extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyShakeMission();
  }

}

class MyShakeMission extends State<ShakeMission>{
  int progress;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    progress = 0;
    startShakeListener();
    Global.methodChannel.setMethodCallHandler((call) {
      if(call.method == "shake")
        shake();
    });
  }

  Future<Null> startShakeListener() async {
    final result = await Global.methodChannel.invokeMethod("shakeListen");

  }

  Future<Null> stopShakeListener() async {
    final result = await Global.methodChannel.invokeMethod("stopShakeListen");

  }

  void shake(){
    if(progress >= 100){
      Global.advancedPlayer1.release();
      stopShakeListener();
      success();
    }
    setState(() {
      progress += 2;
    });
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
        "你已经让所有小青蛙从树上下来了，赶紧起床吧！",
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
                    Navigator.pushNamedAndRemoveUntil(context, "HomePage",(Route route) =>false);
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          width: ScreenUtil().setWidth(720),
          height: ScreenUtil().setWidth(120),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                this.progress>20?
                  (this.progress>40?
                    (this.progress>60?
                      (this.progress>80?
                          "就快成功了！"
                          :"已经成功一大半了！")
                        :"加油！加油！")
                      :"再加把劲！")
                    :"继续摇晃！",
                style: TextStyle(fontSize: ScreenUtil().setSp(70)),
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: ScreenUtil().setWidth(570),
                    height: ScreenUtil().setWidth(600),
                    child: Image.asset("assets/image/bigTree.png"),
                  ),
                  Row(
                    children: [
                      Container(
                          width: ScreenUtil().setWidth(190),
                          height: ScreenUtil().setWidth(190),
                          child: this.progress >= 30?
                          Image.asset("assets/image/frogChiLeft.png"):
                          Container()
                      ),
                      Container(
                        width: ScreenUtil().setWidth(190),
                        height: ScreenUtil().setWidth(190),
                        child: Image.asset("assets/image/frogMa.png"),
                      ),
                      Container(
                          width: ScreenUtil().setWidth(190),
                          height: ScreenUtil().setWidth(190),
                          child: this.progress >= 60?
                          Image.asset("assets/image/frogChiRight.png"):
                          Container()
                      )
                    ],
                  )
                ],
              ),
              Container(
                width: ScreenUtil().setWidth(150),
                height: ScreenUtil().setWidth(720),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(60),
                      height: ScreenUtil().setWidth(600),
                      child: FAProgressBar(
                        backgroundColor: Colors.white,
                        currentValue: this.progress,
                        maxValue: 100,
                        changeColorValue: 60,
                        size: ScreenUtil().setWidth(60),
                        direction: Axis.vertical,
                        displayText: '%',
                        verticalDirection: VerticalDirection.up,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

}