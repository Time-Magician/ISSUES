import 'dart:math';

import 'package:demo5/common/global.dart';

import 'StudyRoomView.dart';
import 'package:flutter/material.dart';
import 'AlarmView.dart';
import 'UserView.dart';
import 'StudyView.dart';

class BottomNavigationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomNavigationWidgetState();
}

class BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  final _bottomNavigationColor = Colors.indigo;
  int _currentIndex = 0;
  List<Widget> pages = List();
  bool isStudying = false;

  startEndStudy(){
    setState(() {
      isStudying = !isStudying;
    });
    print(isStudying);
  }

  @override
  void initState() {
    pages
      ..add(AlarmView())
      ..add(StudyView(blockNavi: () => startEndStudy()))
      ..add(UserView())
      ..add(StudyRoomWidget());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async{
          return false;
        },
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.access_alarm,
                color: _bottomNavigationColor,
              ),
              title: Text(
                '闹钟',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.local_library,
                color: _bottomNavigationColor,
              ),
              title: Text(
                '学习',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_box,
                color: _bottomNavigationColor,
              ),
              title: Text(
                '我的',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance,
                color: _bottomNavigationColor,
              ),
              title: Text(
                '自习室',
                style: TextStyle(color: _bottomNavigationColor),
              )),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          if(!isStudying)
            setState(() {
              _currentIndex = index;
            });
        },
        type: BottomNavigationBarType.shifting,
      ),
    );
  }
}