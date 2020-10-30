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
import 'Views/AppSettingView.dart';
import 'Class/SettingInfo.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as flutterSettingsScreens;

void main() async{
  await flutterSettingsScreens.Settings.init();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=>UserState()),
          ChangeNotifierProvider(create: (_)=>SettingInfo()),
        ],
        child: new MyApp(),
      )

      // ChangeNotifierProvider(
      //   create: (context) => UserState(),
      //   child: new MyApp(),
      // )

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
        "AppSetting":(context)=>AppSettingView(),
        "/":(context) => LoginView(),


      }
    );
  }
}



