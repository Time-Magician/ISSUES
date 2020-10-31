import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class UserState with ChangeNotifier{
  String userName='陈二狗';
  String name='陈满分';
  String passWord='thisispassword';
  String email='2891@sjtu.edu.cn';
  String gender='男性';
  bool isLogin=false;


  void logIn(){
    notifyListeners();
  }

  void setUserName(String newUserName){
    this.userName=newUserName;
    notifyListeners();
  }

  void setEmail(String newEmail){
    this.email=newEmail;
    notifyListeners();
  }

  void setGender(String newGender){
    this.gender=newGender;
    notifyListeners();
  }
}
