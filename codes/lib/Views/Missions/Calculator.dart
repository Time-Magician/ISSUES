import 'package:flutter/material.dart';
import 'package:quiz_view/quiz_view.dart';

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '计算题'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: QuizView(
            image: Container(
              width: 150,
              height: 150,
              child: Image.network(
                  "https://yt3.ggpht.com/a/AATXAJyPMywRmD62sfK-1CXjwF0YkvrvnmaaHzs4uw=s900-c-k-c0xffffffff-no-rj-mo"),
            ),
            showCorrect: true,
            tagBackgroundColor: Colors.blue,
            tagColor: Colors.black,
            questionTag: "计算题",
            answerColor: Colors.white,
            answerBackgroundColor: Color.fromARGB(255, 255, 0, 111),
            questionColor: Colors.white,
            backgroundColor: Color.fromARGB(255, 111, 0, 255),
            width: 500,
            height: 600,
            question: "Which is the best framework for app development?",
            rightAnswer: "Flutter",
            wrongAnswers: ["Fluttor", "Flitter"],
            onRightAnswer: () => print("Right"),
            onWrongAnswer: () => print("Wrong"),
          )),
    );
  }
}