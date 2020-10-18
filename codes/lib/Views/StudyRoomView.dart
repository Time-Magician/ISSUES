import 'package:flutter/material.dart';

class StudyRoomWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyStudyRoomWidget();
  }

}

class MyStudyRoomWidget extends State<StudyRoomWidget>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xFF75CCE8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('自习室'),
      ),
      body: StudyRoom(),
    );
  }
}

class StudyRoom extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyStudyRoom();
  }
}

class MyStudyRoom extends State<StudyRoom>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: SizedBox(
                height: 180,
                width: 360,
                child: RaisedButton(
                  textTheme: ButtonTextTheme.accent,
                  color: const Color(0xFF33539E),
                  highlightColor: Colors.deepPurpleAccent,
                  splashColor: Colors.deepOrangeAccent,
                  colorBrightness: Brightness.dark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  onPressed: () {
                    //TODO
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.business,
                        size: 64,
                        color: Colors.white,
                      ),
                      Text(
                        '公 共 自 习 室',
                        style: TextStyle(color: Colors.white, fontSize: 42),
                      ),
                    ],
                  )
                )),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: SizedBox(
                height: 180,
                width: 360,
                child: RaisedButton(
                    textTheme: ButtonTextTheme.accent,
                    color: const Color(0xFF26A65B),
                    highlightColor: Colors.deepPurpleAccent,
                    splashColor: Colors.deepOrangeAccent,
                    colorBrightness: Brightness.dark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    onPressed: () {
                      //TODO
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.people,
                          size: 64,
                          color: Colors.white,
                        ),
                        Text(
                          '小 组 学 习 室',
                          style: TextStyle(color: Colors.white, fontSize: 42),
                        ),
                      ],
                    )
                )),
          )
        ],
      ),
    );
  }

}

