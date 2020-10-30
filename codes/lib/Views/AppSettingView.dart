import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:demo5/Class/SettingInfo.dart';
import 'package:provider/provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class AppSettingView extends StatefulWidget{
  @override
  createState()=> new _AppSettingViewState();
}

class _AppSettingViewState extends State<AppSettingView>{
  @override
  Widget build(BuildContext context) {
    var _settingInfo = context.watch<SettingInfo>();
    _settingInfo.init();
    return SettingsScreen(
        title: '应用设置',
        children: <Widget>[
          StudyModelSoundSetting(settingInfo: _settingInfo),
          TaskSetting(settingInfo:_settingInfo)
      ],
    );
  }
}
class TaskSetting extends StatelessWidget{
  final settingInfo;
  TaskSetting({this.settingInfo}):super();
  List<S2Choice<String>> taskOptions=[
    S2Choice<String>(value:'math',title:'算术题'),
    S2Choice<String>(value:'sing',title:'唱歌'),
    S2Choice<String>(value:'photo',title:'拍照'),
    S2Choice<String>(value:'game',title:'小游戏')
  ];
  @override
  Widget build(BuildContext context) {
    return SmartSelect<String>.multiple(
        title:'任务设置',
        value: settingInfo.taskSetting,
        choiceConfig:S2ChoiceConfig(
          type:S2ChoiceType.chips
        ),
        modalType: S2ModalType.bottomSheet,
        onChange: (state){
          settingInfo.setTask(state.value);
        },
        choiceItems:taskOptions,
    );
  }

}
class StudyModelSoundSetting extends StatefulWidget{
  final settingInfo;
  StudyModelSoundSetting({Key key,this.settingInfo}):super(key:key);
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
    return SmartSelect<soundSettingOption>.single(
        title:'铃声模式',
        choiceItems:soundSettingOptions,
        modalType: S2ModalType.bottomSheet,
        value: widget.settingInfo.soundSetting,
        onChange: (state) {
          widget.settingInfo.setSound(state.value);
      },
    );
  }
}
