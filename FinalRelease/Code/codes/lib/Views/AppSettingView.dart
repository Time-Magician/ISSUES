import 'package:demo5/index.dart';
import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:provider/provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class AppSettingView extends StatefulWidget{
  @override
  createState()=> new MyAppSettingView();
}

class MyAppSettingView extends State<AppSettingView>{
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var settingModel = context.watch<SettingsModel>();
    return SettingsScreen(
        title: '应用设置',
        children: <Widget>[
          StudyModelSetting(studyModeSettingValue: settingModel.studyModeSetting),
          StyleSetting(styleSettingValue: settingModel.styleSetting),
          TaskSetting(taskSettingValue: settingModel.taskSetting),
          WhiteListSetting(whiteListSettingValue: settingModel.whiteListSetting),
      ],
    );
  }
}

class TaskSetting extends StatefulWidget{
  final taskSettingValue;
  TaskSetting({Key key,this.taskSettingValue}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return new MyTaskSetting();
  }
}

class MyTaskSetting extends State<TaskSetting>{
  List<S2Choice<String>> taskOptions=[
    S2Choice<String>(value:'Arithmetic',title:'算术题'),
    S2Choice<String>(value:'Blow',title:'吹气'),
    S2Choice<String>(value:'TakePhoto',title:'指定物品拍照'),
    S2Choice<String>(value:'Game1',title:'小游戏-配对'),
    S2Choice<String>(value:'Game2',title:'小游戏-捉猫猫'),
    S2Choice<String>(value:'Game3',title:'小游戏-分类'),
    S2Choice<String>(value:'Shake',title:'摇晃手机')
  ];

  @override
  Widget build(BuildContext context) {
    var settingModel = context.watch<SettingsModel>();
    return SmartSelect<String>.multiple(
        title:'随机任务设置',
        value: widget.taskSettingValue,
        choiceConfig:S2ChoiceConfig(
          type:S2ChoiceType.chips
        ),
        modalType: S2ModalType.bottomSheet,
        onChange: (state){
          settingModel.taskSetting=state.value;
          // print(Global.profile.settings.taskSetting);
        },
        choiceItems:taskOptions,
    );
  }
}

class StudyModelSetting extends StatefulWidget{
  final studyModeSettingValue;
  StudyModelSetting({Key key,this.studyModeSettingValue}):super(key:key);
  @override
  createState()=> new MyStudyModelSetting();
}

class MyStudyModelSetting extends State<StudyModelSetting>{
  void initState(){
    super.initState();
  }
  List<S2Choice<studyModeSettingOption>> studyModeSettingOptions=[
    S2Choice<studyModeSettingOption>(value:studyModeSettingOption.normal,title:'普通模式'),
    S2Choice<studyModeSettingOption>(value:studyModeSettingOption.focus,title:'专注模式'),
    S2Choice<studyModeSettingOption>(value:studyModeSettingOption.tomato,title:'番茄学习法'),
  ];
  Widget build(BuildContext context){
    var settingModel = context.watch<SettingsModel>();
    return SmartSelect<studyModeSettingOption>.single(
        title:'学习模式',
        choiceItems:studyModeSettingOptions,
        modalType: S2ModalType.bottomSheet,
        value: widget.studyModeSettingValue == null?studyModeSettingOption.normal:widget.studyModeSettingValue,
        onChange: (state) {
          settingModel.studyModeSetting=state.value;
      },
    );
  }
}

class StyleSetting extends StatefulWidget{
  final styleSettingValue;
  StyleSetting({Key key,this.styleSettingValue}):super(key:key);
  @override
  createState()=> new MyStyleSetting();
}

class MyStyleSetting extends State<StyleSetting>{
  void initState(){
    super.initState();
  }
  List<S2Choice<styleSettingOption>> styleSettingOptions=[
    S2Choice<styleSettingOption>(value:styleSettingOption.classic,title:'经典主题'),
    S2Choice<styleSettingOption>(value:styleSettingOption.nighttime,title:'夜间主题'),
  ];
  Widget build(BuildContext context){
    var settingModel = context.watch<SettingsModel>();
    return SmartSelect<styleSettingOption>.single(
      title:'主题',
      choiceItems: styleSettingOptions,
      modalType: S2ModalType.bottomSheet,
      value: widget.styleSettingValue == null?styleSettingOption.classic:widget.styleSettingValue,
      onChange: (state) {
        settingModel.styleSetting=state.value;
      },
    );
  }
}

class WhiteListSetting extends StatefulWidget{
  final whiteListSettingValue;
  WhiteListSetting({Key key,this.whiteListSettingValue}):super(key:key);
  @override
  createState()=> new MyWhiteListSetting();
}

class MyWhiteListSetting extends State<WhiteListSetting>{
  Map<String, String> appList;
  List<S2Choice<String>> whiteListOptions=[];

  void initState(){
    super.initState();
    getAppList();
    Global.methodChannel.setMethodCallHandler((call) async {
      if(call.method == "appList"){
        // print(call.arguments);
        whiteListOptions=[];

        call.arguments.forEach((key, value) {
          whiteListOptions.add(S2Choice<String>(value:key,title:value));
        });
        setState(() {

        });
        return;
      }
    });
  }

  void getAppList() async {
    Global.methodChannel.invokeMethod("getApplicationList");
  }

  Widget build(BuildContext context){
    var settingModel = context.watch<SettingsModel>();
    return SmartSelect<String>.multiple(
      title:'白名单',
      value: widget.whiteListSettingValue,
      choiceConfig:S2ChoiceConfig(
          type:S2ChoiceType.chips
      ),
      modalType: S2ModalType.fullPage,
      choiceType: S2ChoiceType.switches,
      modalFilter: true,
      modalFilterAuto: true,
      onChange: (state){
        settingModel.whiteListSetting=state.value;
      },
      choiceItems: whiteListOptions,
    );
  }
}
