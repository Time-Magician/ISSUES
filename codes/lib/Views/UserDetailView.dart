import 'package:flutter/material.dart';
const DetailItem=['用户名','姓名','性别','电子邮箱','密码'];
const _name="zhuYicheng";
class UserDetailView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人中心'),
      ),
      // body:ListView.builder(
      //     itemCount: DetailItem.length*2,
      //     itemBuilder:(context,i){
      //       if(i.isOdd)return new Divider();
      //       var index = i~/2;
      //       return ListTile(
      //         title: Text(DetailItem[index]),
      //         trailing: Icon(Icons.arrow_right),
      //       );
      //     }),
      body: Center(
        child:Text(
        'Hello, $_name! How are you?',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40),
      )),
    );
  }

}
