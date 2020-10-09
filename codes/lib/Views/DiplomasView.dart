import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

class DiplomasWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyDiplomasView();
  }
}

class MyDiplomasView extends State<DiplomasWidget>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF75CCE8),
        appBar: AppBar(
            title: Text('荣誉室'),
        ),
        body:ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context,int index) {
            return new Diploma();
        },
      ));
  }
}

class Diploma extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyDiploma();
  }
}

class MyDiploma extends State<Diploma>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: Card(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            elevation: 20.0,  //设置阴影
            child: Container(
              width: 380,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8DC),
                border: Border.all(color: const Color(0xFFFFF8DC), width: 3),//边框
              ),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFFFD700), width: 3),//边框
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        "🐸🐸毕🐸业🐸证🐸书🐸🐸",
                        style: TextStyle(color: Colors.black, fontSize: 28),
                      ),
                    ),
                    Container(
                        width: 320,
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        height: 160,
                        child: Row(
                          children: <Widget>[
                            Container(
                                width: 80,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFFFD700), width: 3),//边框
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF08080),
                                    border: Border.all(color: const Color(0xFFFFFACD), width: 3),//边框
                                  ),
                                  child: ClipRect(//圆形头像
                                    child: Image.asset(
                                      "assets/image/frog3.png",
                                      width: 80.0,
                                    ),
                                  ),
                                )
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                              width: 220,
                              height: 145,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                      width: 220,
                                      height: 40,
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "陈二狗",
                                            style: TextStyle(color: Colors.black, fontSize: 28, fontFamily: "KeShi",  decoration: TextDecoration.underline,),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            " 同学",
                                            style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: "KeShi"),
                                            textAlign: TextAlign.left,
                                          )
                                        ],
                                      ),
                                  ),
                                  Container(
                                      width: 220,
                                      height: 55,
                                      child: Text(
                                        "学习专注，作息规律\n品学兼优，成绩优异",
                                        style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: "KeShi"),
                                        textAlign: TextAlign.center,
                                      )
                                  ),
                                  Container(
                                    width: 220,
                                    child: Text(
                                      "于 2020/09/30",
                                      style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: "KeShi"),
                                      textAlign: TextAlign.right,
                                    ) ,
                                  ),
                                  Container(
                                    width: 220,
                                    child: Text(
                                      "毕业于 氢化大学",
                                      style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: "KeShi"),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        "🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸",
                        style: TextStyle(color: Colors.black, fontSize: 28),
                      ),
                    ),
                  ],
                ),
              )
            ),
       )
    );
  }

}