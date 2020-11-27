import 'package:demo5/Views/LoginView.dart';
import 'package:demo5/Views/Missions/TakePhoto.dart';
import 'Views/Missions/Blow.dart';
import 'Views/Missions/Game.dart';
import 'Views/Missions/Game2.dart';
import 'Views/Missions/Game3.dart';
import 'Views/Missions/Shake.dart';
import 'index.dart';
import 'package:provider/provider.dart';
import 'Views/index.dart';
import 'Views/DetailSettingView/index.dart';
import 'Views/Missions/Arithmetic.dart';
import 'states/index.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart'
    as flutterSettingsScreens;

void main() async {
  await flutterSettingsScreens.Settings.init();
  Global.init().then((e)=>
      runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserModel()),
          ChangeNotifierProvider(create: (_) => SettingsModel()),
        ],
        child: new MyApp(),
      ))
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
        routes: {
          "StudyRoom": (context) => StudyRoomWidget(),
          "Diplomas": (context) => DiplomasWidget(),
          "AlarmSetting": (context) => AlarmSettingWidget(),
          "HomePage": (context) => BottomNavigationWidget(),
          "UserDetail": (context) => UserDetailView(),
          "FriendPage": (context) => FriendsView(),
          "UserNameSetting": (context) => UserNameSettingView(),
          "NameSetting": (context) => NameSettingView(),
          "EmailSetting": (context) => EmailSettingView(),
          "PasswordSetting": (context) => PasswordSettingView(),
          "GenderSetting": (context) => GenderSettingView(),
          "AppSetting": (context) => AppSettingView(),
          "Arithmetic":(context)=>Arithmetic(),
          "Game":(context)=>Game(),
          "Game2":(context)=>Game2(),
          "Game3":(context)=>Game3(),
          "Shake":(context)=>Shake(),
          "Blow":(context)=>Blow(),
          "TakePhoto":(context)=>TakePhoto(),
          "/": (context) => LoginView(),
        });
  }
}
