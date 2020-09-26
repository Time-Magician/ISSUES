import 'package:flutter/material.dart';

class StudyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('学习哇'),
      ),
      body:ListView(
        children: <Widget>[
            _topHeader(),
            btnCircle(),
        ],
      ) ,
    );
  }
}
Widget _topHeader(){
  return Container(
    child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top:80.0),
          child: ClipOval( //圆形头像
            child: Image.network(
              'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg',
              width: 240.0,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget btnCircle(){
  return
    SizedBox(
        height: 50,
        width: 50,
        child: RaisedButton(
          textTheme: ButtonTextTheme.accent,
          color: Colors.teal,
          highlightColor: Colors.deepPurpleAccent,
          splashColor: Colors.deepOrangeAccent,
          colorBrightness: Brightness.dark,
          onPressed: () {
            //TODO
          },
          child: Text(
            '学习',
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
        ));
}

