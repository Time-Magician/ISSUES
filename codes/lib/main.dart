import 'package:demo5/Views/LoginView.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';
import 'Views/AlarmSettingView.dart';
import 'Views/BottomNavigatorView.dart';
import 'Views/UserDetailView.dart';
import 'Views/DiplomasView.dart';
import 'Views/FriendsView.dart';
import 'Views/FriendsView.dart';
import 'Views/StudyView.dart';
import 'Views/StudyRoomView.dart';
import 'Views/DetailSettingView/GenderSetting.dart';
import 'Views/DetailSettingView/UserNameSettingView.dart';
import 'Views/DetailSettingView/NameSettingView.dart';
import 'Views/DetailSettingView/EmailSettingView.dart';
import 'Views/DetailSettingView/PasswordSettingView.dart';
import 'Class/UserState.dart';

void main() {
  runApp(
      ChangeNotifierProvider(
        create: (context) => UserState(),
        child: new MyApp(),
      )

  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '闹钟',
      theme: new ThemeData(
        primaryColor: Colors.indigo,
      ),
      routes:{
        "StudyRoom":(context) => StudyRoomWidget(),
        "Diplomas":(context) => DiplomasWidget(),
        "AlarmSetting":(context) => AlarmSettingWidget(),
        "HomePage":(context) => BottomNavigationWidget(),
        "UserDetail":(context) => UserDetailView(),
        "FriendPage":(context)=>FriendsView(),
        "UserNameSetting":(context)=>UserNameSettingView(),
        "NameSetting":(context)=>NameSettingView(),
        "EmailSetting":(context)=>EmailSettingView(),
        "PasswordSetting":(context)=>PasswordSettingView(),
        "GenderSetting":(context)=>GenderSettingView(),
        "/":(context) => LoginView(),

      }
    );
  }
}
