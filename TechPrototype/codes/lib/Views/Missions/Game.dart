import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'dart:math';
import '../../common/global.dart';

List<Image> trees = [
  Image.asset("assets/image/tree1.png"),
  Image.asset("assets/image/tree2.png"),
  Image.asset("assets/image/tree3.png"),
  Image.asset("assets/image/tree4.png"),
  Image.asset("assets/image/tree1.png"),
  Image.asset("assets/image/tree2.png"),
  Image.asset("assets/image/tree3.png"),
  Image.asset("assets/image/tree4.png"),
  Image.asset("assets/image/tree1.png"),
  Image.asset("assets/image/tree2.png"),
  Image.asset("assets/image/tree3.png"),
  Image.asset("assets/image/tree4.png"),
  Image.asset("assets/image/tree1.png"),
  Image.asset("assets/image/tree2.png"),
  Image.asset("assets/image/tree3.png"),
  Image.asset("assets/image/tree4.png"),
];
List<Image> animals = [
  Image.asset("assets/image/animal1.png"),
  Image.asset("assets/image/animal1.png"),
  Image.asset("assets/image/animal2.png"),
  Image.asset("assets/image/animal2.png"),
  Image.asset("assets/image/animal3.png"),
  Image.asset("assets/image/animal3.png"),
  Image.asset("assets/image/animal4.png"),
  Image.asset("assets/image/animal4.png"),
  Image.asset("assets/image/animal5.png"),
  Image.asset("assets/image/animal5.png"),
  Image.asset("assets/image/animal6.png"),
  Image.asset("assets/image/animal6.png"),
  Image.asset("assets/image/animal7.png"),
  Image.asset("assets/image/animal7.png"),
  Image.asset("assets/image/animal8.png"),
  Image.asset("assets/image/animal8.png"),
];

class Game extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyGame();
  }

}

class MyGame extends State<Game>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    randomizeList(animals);
    randomizeList(trees);
  }

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
                  child: LittleGame(),
              ),)
            ],
          ))
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
                    "小青蛙和伙伴们都在玩捉迷藏，找到两个相同的动物来抓住它们吧！",
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

class LittleGame extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyLittleGame();
  }

}

class MyLittleGame extends State<LittleGame>{
  List<bool> flipped;
  List<int> pair;
  int score;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flipped = [
      false, false, false, false,
      false, false, false, false,
      false, false, false, false,
      false, false, false, false
    ];
    pair = [];
    score = 0;
  }

  void flip(index){
    if(pair.length >= 2) return;
    if(flipped[index]) return;
    setState(() {
      flipped[index] = true;
      pair.add(index);
    });
    checkMatched();
  }

  void checkMatched(){
    if(pair.length < 2) return;
    if(animals[pair[0]].image == animals[pair[1]].image){
      pair.clear();
      setState(() {
        score += 1;
      });
      if(score == 8)
        success();
    }
    else {
      new Future.delayed(Duration(milliseconds: 500),(){
        setState(() {
          flipped[pair[0]] = false;
          flipped[pair[1]] = false;
          pair.clear();
        });
      });
    }
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
        "你已经成功地找到了所有小动物们，赶紧起床吧！",
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "已找到 "+score.toString()+"/8",
                  style: TextStyle(fontSize: ScreenUtil().setSp(70), fontFamily: "Miriam"),
                )
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => flip(0),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[0]?
                        animals[0]:
                        trees[0]
                    ),
                  ),
                  GestureDetector(
                    onTap: () => flip(1),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[1]?
                        animals[1]:
                        trees[1]
                    ),
                  ),
                  GestureDetector(
                    onTap: () => flip(2),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[2]?
                        animals[2]:
                        trees[2]
                    ),
                  ),
                  GestureDetector(
                    onTap: () => flip(3),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[3]?
                        animals[3]:
                        trees[3]
                    ),
                  )
                ],
              )
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => flip(4),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[4]?
                        animals[4]:
                        trees[4]
                    ),
                  ),
                  GestureDetector(
                    onTap: () => flip(5),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[5]?
                        animals[5]:
                        trees[5]
                    ),
                  ),
                  GestureDetector(
                    onTap: () => flip(6),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[6]?
                        animals[6]:
                        trees[6]
                    ),
                  ),
                  GestureDetector(
                    onTap: () => flip(7),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[7]?
                        animals[7]:
                        trees[7]
                    ),
                  )
                ],
              )
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => flip(8),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[8]?
                        animals[8]:
                        trees[8]
                    ),
                  ),
                  GestureDetector(
                    onTap: () => flip(9),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[9]?
                        animals[9]:
                        trees[9]
                    ),
                  ),
                  GestureDetector(
                    onTap: () => flip(10),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[10]?
                        animals[10]:
                        trees[10]
                    ),
                  ),
                  GestureDetector(
                    onTap: () => flip(11),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[11]?
                        animals[11]:
                        trees[11]
                    ),
                  )
                ],
              )
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => flip(12),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[12]?
                        animals[12]:
                        trees[12]
                    ),
                  ),
                  GestureDetector(
                    onTap: () => flip(13),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[13]?
                        animals[13]:
                        trees[13]
                    ),
                  ),
                  GestureDetector(
                    onTap: () => flip(14),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[14]?
                        animals[14]:
                        trees[14]
                    ),
                  ),
                  GestureDetector(
                    onTap: () => flip(15),
                    child: Container(
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: this.flipped[15]?
                        animals[15]:
                        trees[15]
                    ),
                  )
                ],
              )
            ],
          ),
          Container(
            width: ScreenUtil().setWidth(720),
            height: ScreenUtil().setWidth(80),
          )
        ],
      );
  }

}

void randomizeList(List<Image> list){
  for(int i = 0; i < 16; i++){
    var temp = list[i];
    var randomIndex = (new Random()).nextInt(16);
    list[i] = list[randomIndex];
    list[randomIndex] = temp;
  }
}
