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
          OrderTitle(title: "个人信息", icon: Icons.assignment_ind),
          OrderTitle(title: "设置", icon: Icons.settings),
          OrderTitle(title: "我的好友", icon: Icons.group, router: "FriendPage"),
          OrderTitle(title: "关于一心", icon: Icons.favorite),
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
  final title;
  final icon;
  final router;
  const OrderTitle({Key key, this.title, this.router, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      // margin: EdgeInsets.only(top:10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom:BorderSide(width: 1,color:Colors.black12)
          )
      ),
      child: GestureDetector(
          onTap: (() => {
            Navigator.pushNamed(context, router)
          }),
          child: ListTile(
              leading: Icon(this.icon),
              title:Text(title),
              trailing: Icon(Icons.arrow_right),
      ),
    ));
  }
}
