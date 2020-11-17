import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class UserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('个人中心'),
      ),
      body: ListView(
        children: <Widget>[
          _topHeader(),
          OrderTitle(
              title: "个人信息",
              icon: Icons.assignment_ind,
              router: "UserDetail"),
          OrderTitle(
              title: "设置",
              icon: Icons.settings,
              router:"AppSetting"
          ),
          OrderTitle(title: "我的好友", icon: Icons.group, router: "FriendPage"),
          OrderTitle(title: "关于一心", icon: Icons.favorite),
        ],
      ),
    );
  }
}

Widget _topHeader() {
  return Container(
    padding: EdgeInsets.all(ScreenUtil().setWidth(40.0)),
    color: Colors.blueAccent,
    child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(40.0)),
          child: ClipOval(
            //圆形头像
            child: Image.asset(
              'assets/image/cat.jpg',
              width: ScreenUtil().setWidth(160.0),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(20.0)),
          child: Text("Chen Ergou", style: TextStyle(color: Colors.white)),
        )
      ],
    ),
  );
}

class OrderTitle extends StatelessWidget {
  final title;
  final icon;
  final router;
  const OrderTitle({Key key, this.title, this.router, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

        // margin: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: ScreenUtil().setWidth(2), color: Colors.black12))),
        child: GestureDetector(
          onTap: (() => {Navigator.pushNamed(context, router)}),
          child: ListTile(
            leading: Icon(this.icon),
            title: Text(title),
            trailing: Icon(Icons.arrow_right),
          ),
        ));
  }
}
