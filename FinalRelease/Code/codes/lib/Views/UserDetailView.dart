import 'package:demo5/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/screenutil.dart';

var itemValuePair=new Map.from({"用户名":"陈二狗","姓名":"陈零蛋","性别":"男","电子邮箱":"haha@sjtu.edu.cn","密码":"******"});

class UserDetailView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人中心'),
      ),
      body:
          Consumer<UserModel>(
            builder:(context,userModel,child){
              User user = userModel.user;
              return
                ListView(
                  children: <Widget>[
                    _DetailItem(item: '用户名', value: user.username, router: 'UserNameSetting'),
                    _DetailItem(item: '姓名', value: user.name, router: 'NameSetting'),
                    _DetailItem(item: '性别', value: user.gender, router: 'GenderSetting'),
                    _DetailItem(item: '电子邮箱',
                        value: user.email,
                        router: 'EmailSetting'),
                    _DetailItem(
                        item: '密码', value: '********', router: 'PasswordSetting'),
                  ]
                );
            }
          )
    );
  }

}
class _DetailItem extends StatelessWidget{
  final item;
  final value;
  final router;
  const _DetailItem({Key key,this.item,this.value,this.router}):super(key:key);

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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item),
                  Text(value)
                ],
              ),
              trailing: Icon(Icons.arrow_right),
          ),
        ));
  }
}
