
import 'dart:convert';

import 'package:demo5/models/index.dart';
import 'package:demo5/common/global.dart';
import 'package:dio/dio.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FriendsView extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FriendList(title: '好友');
  }
}

class FriendList extends StatefulWidget {
  FriendList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyFriendList createState() => MyFriendList();
}

class MyFriendList extends State<FriendList> {
  SlidableController slidableController;

  List<Friend> friendList = [];

  @protected
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    super.initState();
    getFriendList();
  }

  void getFriendList() async {
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    String url ="http://10.0.2.2:9000/user-service/user/"+Global.userId.toString()+"/friends";
    Response response = await dio
        .get(url);
    List<Friend> tmpList = [];
    // print(response);
    response.data["data"].forEach((item) {
      tmpList.add(Friend.fromJson(item));
    });
    setState(() {
        friendList = tmpList;
    });
  }

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
    });
  }

  void addFriend(){
    String searchInfo = "";
    EasyDialog(
      fogOpacity: 0.12,
      width: ScreenUtil().setWidth(600),
      height: ScreenUtil().setWidth(400),
      closeButton: false,
      title: Text(
        "添加好友",
        style: TextStyle(fontSize: ScreenUtil().setSp(40)),
      ),
      contentList: [
        Container(
          width: ScreenUtil().setWidth(540),
          margin: EdgeInsets.fromLTRB(0, ScreenUtil().setWidth(10), 0, ScreenUtil().setWidth(30)),
          child: TextField(
              controller: new TextEditingController(text: searchInfo),
              decoration: InputDecoration(
                hintText: "请输入手机号/邮箱",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
              maxLines: 1,
              onChanged: (v) {
                searchInfo = v;
              }
          ),
        ),
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(180),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "取消",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(180),
                child: FlatButton(
                  onPressed: () {
                    goAddFriend(searchInfo);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "添加",
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

  void goAddFriend(String identifier) async {
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    FormData formData = FormData.fromMap({"sender_id":Global.userId, "identifier":identifier});
    String url ="http://10.0.2.2:9000/user-service/user";
    Response response = await dio
        .post(url, data:formData);
    print(response.data["status"]);
    if(response.data["status"] == -1){
      Fluttertoast.showToast(
          msg: "用户不存在，请检查输入",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      Fluttertoast.showToast(
          msg: "好友请求已发送",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return getSlidableWithLists(context, index);
          },
          itemCount: friendList.length,
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => addFriend(),
        child: Icon(Icons.add),
        ),
      );
  }

  Widget getSlidableWithLists(
      BuildContext context, int index) {
    var item = friendList[index];
    return Slidable(
      key: Key(item.name),
      controller: slidableController,
      direction: Axis.horizontal,
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.2,
      child: FriendListItem(friendList[index]),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '设置闹钟',
          color: Colors.green,
          icon: Icons.alarm_add,
          onTap: () => addAlarm(index),
          closeOnTap: false,
        ),
        IconSlideAction(
          caption: '删除好友',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => deleteFriend(index),
        ),
      ],
    );
  }

  void addAlarm(index) async {
      final result = await Navigator.pushNamed(context,"AlarmSetting",arguments:
        AlarmInfo(null ,"闹钟", [], TimeOfDay.now(), "算术题", "audio1", true, false),
      );

      if(result.runtimeType != AlarmInfo) return;
      AlarmInfo newAlarmInfo = result as AlarmInfo;

      Map<String, dynamic> alarmJson = newAlarmInfo.toJson();
      Dio dio = new Dio();
      dio.options.headers["authorization"] = "Bearer "+Global.token;
      FormData formData = FormData.fromMap({"sender_id":Global.userId, "type":"闹钟设置", "detail":jsonEncode(alarmJson)});
      String url ="http://10.0.2.2:9000/user-service/user/"+friendList[index].userId.toString()+"/messages";
      Response response = await dio
          .post(url, data:formData);
      print(response.data["status"]);
      if(response.data["status"] == 0){
        Fluttertoast.showToast(
            msg: "闹钟请求已发送",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
  }

  void deleteFriend(index){
    EasyDialog(
      fogOpacity: 0.12,
      width: ScreenUtil().setWidth(600),
      height: ScreenUtil().setWidth(280),
      closeButton: false,
      title: Text(
        "删除好友",
        style: TextStyle(fontSize: ScreenUtil().setSp(40)),
      ),
      description: Text(
        "你确定要删除好友吗？",
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
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "取消",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(180),
                child: FlatButton(
                  onPressed: () {
                    goDeleteFriend(index);
                    Navigator.of(context).pop();
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

  void goDeleteFriend(index) async {
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer "+Global.token;
    String url ="http://10.0.2.2:9000/user-service/user/"+Global.userId.toString()+"/friends/"+friendList[index].userId.toString();
    Response response = await dio
        .delete(url);
    print(response.data["data"]);
    setState(() {
      friendList.removeAt(index);
    });
  }

}

class FriendListItem extends StatelessWidget {
  FriendListItem(this.item);
  final Friend item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
      Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
          ? Slidable.of(context)?.open()
          : Slidable.of(context)?.close(),
      child: Container(
        color: Colors.white24,

        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text('${item.name == ""?" ":item.name[0]}'),
            foregroundColor: Colors.white,
          ),
          title: Text(item.name == ""? item.username:item.name),
          subtitle: Text(item.email),
        ),
      ),
    );
  }

}