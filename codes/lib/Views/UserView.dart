import 'package:flutter/material.dart';

class UserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('个人中心'),
      ),
      body:ListView(
        children: <Widget>[
           _topHeader(),
          OrderTitle(str: "个人信息设置"),
          OrderTitle(str: "趣味闹钟设置"),
          OrderTitle(str: "深度学习设置"),
          OrderTitle(str: "社交与好友设置"),
          OrderTitle(str: "音效与通知设置"),
          OrderTitle(str: "关于一心"),
        ],
      ) ,
    );
  }
}

Widget _topHeader(){
  return Container(
    padding: EdgeInsets.all(20.0),
    color: Colors.blueAccent,
    child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top:20.0),
          child: ClipOval( //圆形头像
            child: Image.network(
              'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg',
              width: 80.0,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top:10.0),
          child: Text("Chen Ergou",style: TextStyle(color:Colors.white)),
        )
      ],
    ),
  );
}

class OrderTitle extends StatelessWidget{
  final str;
  const OrderTitle({Key key, this.str}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      // margin: EdgeInsets.only(top:10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom:BorderSide(width: 1,color:Colors.black12)
          )
      ),
      child: ListTile(
        leading: Icon(Icons.list),
        title:Text(str),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }
}
