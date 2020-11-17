import 'package:demo5/index.dart';
import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:provider/provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class AppSettingView extends StatefulWidget{
  @override
  createState()=> new _AppSettingViewState();
}

class _AppSettingViewState extends State<AppSettingView>{
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var settingModel = context.watch<SettingsModel>();
    return SettingsScreen(
        title: '应用设置',
        children: <Widget>[
          StudyModelSoundSetting(soundSettingValue: settingModel.soundSetting),
          TaskSetting(taskSettingValue:settingModel.taskSetting)
      ],
    );
  }
}

class TaskSetting extends StatefulWidget{
  final taskSettingValue;
  TaskSetting({Key key,this.taskSettingValue}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return new _TaskSettingState();
  }

}
class _TaskSettingState extends State<TaskSetting>{
  List<S2Choice<String>> taskOptions=[
    S2Choice<String>(value:'math',title:'算术题'),
    S2Choice<String>(value:'sing',title:'唱歌'),
    S2Choice<String>(value:'photo',title:'拍照'),
    S2Choice<String>(value:'game',title:'小游戏')
  ];
  @override
  Widget build(BuildContext context) {
    var settingModel = context.watch<SettingsModel>();
    return SmartSelect<String>.multiple(
        title:'任务设置',
        value: widget.taskSettingValue,
        choiceConfig:S2ChoiceConfig(
          type:S2ChoiceType.chips
        ),
        modalType: S2ModalType.bottomSheet,
        onChange: (state){
          settingModel.taskSetting=state.value;
        },
        choiceItems:taskOptions,
    );
  }

}
class StudyModelSoundSetting extends StatefulWidget{
  final soundSettingValue;
  StudyModelSoundSetting({Key key,this.soundSettingValue}):super(key:key);
  @override
  createState()=> new _StudyModelSoundSettingState();
}
class _StudyModelSoundSettingState extends State<StudyModelSoundSetting>{
  void initState(){
    super.initState();
  }
  List<S2Choice<soundSettingOption>> soundSettingOptions=[
    S2Choice<soundSettingOption>(value:soundSettingOption.normal,title:'正常'),
    S2Choice<soundSettingOption>(value:soundSettingOption.vibrate,title:'震动'),
    S2Choice<soundSettingOption>(value:soundSettingOption.mute,title:'静音'),
    S2Choice<soundSettingOption>(value:soundSettingOption.systemPreferences,title:'系统预设'),
  ];
  Widget build(BuildContext context){
    var settingModel = context.watch<SettingsModel>();
    return SmartSelect<soundSettingOption>.single(
        title:'铃声模式',
        choiceItems:soundSettingOptions,
        modalType: S2ModalType.bottomSheet,
        value: widget.soundSettingValue,
        onChange: (state) {
          settingModel.soundSetting=state.value;
      },
    );
  }
}
