import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class StudyView extends StatefulWidget {
  @override
  createState() => new MyStudyView();
}

class MyStudyView extends State<StudyView> {
  int totalTime = 0;
  int exp = 70;

  _updateTime(int end) {
    setState(() {
      totalTime = end;
    });
  }

  _showDiploma(){
    Navigator.pushNamed(context, "Diplomas");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('学习哇'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.school),
            tooltip: 'Show Diplomas',
            onPressed: _showDiploma,
          ),
        ],
      ),
      body:Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                width: 320,
                height: 60,
                child: ProgressBlock(exp: this.exp)
            ),
            Container(
                width: 720,
                height: 320,
                child: FrogBlock(updateTime:  (end) => _updateTime(end))
            ),
            Container(
                width: 720,
                height: 84,
                child: TimerBlock(totalTime: this.totalTime)
            ),
            Container(
                width: 280,
                height: 60,
                child: btnBlock()
            ),
          ]
      ),
    );
  }
}

class ProgressBlock extends StatefulWidget{
  final exp;
  const ProgressBlock({Key key, this.exp}) : super(key: key);

  @override
  createState() => new MyProgressBlock();
}

class MyProgressBlock extends State<ProgressBlock>{
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
            children: <Widget>[
              Container(
                  width: 80,
                  child:Text(
                    "Lv 一年级",
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black45,
                    ),
                  )
              ),
              Container(
                  width: 240,
                  height: 20,
                  child: FAProgressBar(
                    backgroundColor: Colors.white,
                    currentValue: widget.exp,
                    maxValue: 100,
                    changeColorValue: 60,
                    displayText: '%',
                  )
              ),]
        )
    );
  }
}

class FrogBlock extends StatefulWidget{
  final updateTime;
  const FrogBlock({Key key, this.updateTime}) : super(key: key);

  @override
  createState() => new MyFrogBlock();
}

class MyFrogBlock extends State<FrogBlock>{
  void _updateLabels(int init, int end, int a) {
    // print(end);
    widget.updateTime(end);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            backgroundColor: Colors.teal,
            body: Center(
              child: Container(
                  child: SingleCircularSlider(
                    120, 0,
                    height: 300.0,
                    width: 300.0,
                    baseColor: Color.fromRGBO(255, 255, 255, 0.3),
                    selectionColor: Color.fromRGBO(255, 255, 255, 0.5),
                    onSelectionChange:  _updateLabels,
                    child: ClipOval( //圆形头像
                      child: Image.network(
                        'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg',
                        width: 240.0,
                      ),
                    ),
                  )
              ),
            )
        )
    );
  }
}

class TimerBlock extends StatefulWidget{
  final int totalTime;
  const TimerBlock({Key key, this.totalTime}) : super(key: key);

  @override
  createState() => new MyTimerBlock();
}

class MyTimerBlock extends State<TimerBlock>{
  int totalMinute;
  int secondsLeft;
  int minuteLeft;

  @override
  void initState() {
    // TODO: implement initState
    totalMinute = widget.totalTime;
    minuteLeft = widget.totalTime;
    secondsLeft = 0;
    super.initState();
  }

  String getMinute(){
    if(widget.totalTime < 10)
      return "0"+widget.totalTime.toString()+":";
    else
      return widget.totalTime.toString()+":";
  }

  String getSecond(){
    if(this.secondsLeft < 10)
      return "0"+this.secondsLeft.toString();
    else
      return this.secondsLeft.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 80,
        width: 50,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:  getMinute(),
            style: TextStyle(color: Colors.black, fontSize: 48, fontFamily: "Miriam"),
            children: <TextSpan>[
              TextSpan(
                text: getSecond(),
                style: TextStyle(color: Colors.black, fontSize: 48, fontFamily: "Miriam"),
              ),
            ],
          ),
        )
    );
  }
}

Widget btnBlock(){
  return
    SizedBox(
        height: 48,
        width: 50,
        child: RaisedButton(
          textTheme: ButtonTextTheme.accent,
          color: Colors.cyan,
          highlightColor: Colors.deepPurpleAccent,
          splashColor: Colors.deepOrangeAccent,
          colorBrightness: Brightness.dark,
          onPressed: () {
            //TODO
          },
          child: Text(
            '开始学习',
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
        ));
}

