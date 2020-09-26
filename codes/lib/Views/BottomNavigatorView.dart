import 'package:flutter/material.dart';
import 'AlarmView.dart';

class BottomNavigationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomNavigationWidgetState();
}

class BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  final _bottomNavigationColor = Colors.indigo;
  int _currentIndex = 0;
  List<Widget> pages = List();

  @override
  void initState() {
    pages
      ..add(AlarmView())
      ..add(AlarmView())
      ..add(AlarmView());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
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
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.shifting,
      ),
    );
  }
}