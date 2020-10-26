import 'package:demo5/Views/LoginView.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
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

void main() => runApp(new MyApp());

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

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  final _saved = new Set<WordPair>();

  Widget _buildSuggestions(){
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i){
        if(i.isOdd) return new Divider();
        final index = i ~/ 2;
        if(index >= _suggestions.length){
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }

  Widget _buildRow(WordPair pair){
    final alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style:_biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: (){
        setState(() {
          if (alreadySaved){
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      }
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context){
          final tiles = _saved.map(
              (pair) {
                return new ListTile(
                  title: new Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
          );
          final divided = ListTile
            .divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    // final wordPair = new WordPair.random();
    // return new Text(wordPair.asPascalCase);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
