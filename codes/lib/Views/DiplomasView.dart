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
        backgroundColor: Colors.teal,
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
              height: 210,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: GradientColors.sunrise,
                  ),
                ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Text(
                      "毕 业 证 书",
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                  ),
                  Container(
                    width: 320,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                    height: 150,
                    child: Row(
                      children: <Widget>[
                        ClipOval( //圆形头像
                          child: Image.network(
                            'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg',
                            width: 80.0,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                          width: 220,
                          height: 140,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                width: 220,
                                child: Text(
                                    "陈二狗 同学",
                                    style: TextStyle(color: Colors.black, fontSize: 24),
                                    textAlign: TextAlign.left,
                                  )
                              ),
                              Container(
                                width: 220,
                                child: Text(
                                  "学习专注，作息规律\n品学兼优，成绩优异",
                                  style: TextStyle(color: Colors.black, fontSize: 16,),
                                  textAlign: TextAlign.center,
                                )
                              ),
                              Container(
                                width: 220,
                                child: Text(
                                  "于 2020/09/30",
                                  style: TextStyle(color: Colors.black, fontSize: 16,),
                                  textAlign: TextAlign.right,
                                ) ,
                              ),
                              Container(
                                width: 220,
                                child: Text(
                                  "毕业于 氢化大学",
                                  style: TextStyle(color: Colors.black, fontSize: 16,),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                  ))
                ],
              ),
            ),
       )
    );
  }

}