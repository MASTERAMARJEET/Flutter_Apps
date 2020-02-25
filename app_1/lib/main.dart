import 'package:flutter/material.dart';

import './question.dart';
import './answer.dart';

void main() => runApp(TheApp());

class TheApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _listIndex = 0;
  var _answerIndex = 1;

  var details = [
    {
      'question': 'Are you ready to get started with the App?',
      'answer': ['No, Not yet', 'Yes!!..']
    },
    {
      'question': 'What would you like to do with this App?',
      'answer': ['Alarm', 'Daily Planner', 'Both']
    },
  ];
  void _answerQuestion() {
    print((details[_listIndex]['answer'] as List<String>).elementAt(_answerIndex));
    if (_answerIndex + _listIndex !=0 ){
    setState(() {
      _listIndex = 1;
    }
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.teal,
        extendBody: true,
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text('App_1', style: TextStyle(fontSize: 32)),
        //   backgroundColor: Colors.purple,
        // ),
        drawer: Drawer(),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Question(
              details[_listIndex]['question'],
            ),
            ...(details[_listIndex]['answer'] as List<String>).map((ans) {
              return Answer(_answerQuestion, ans);
            }).toList(),
            // for (_answerIndex = 0, ){
            // Answer(_answerQuestion, (details[_listIndex]['answer'] as List<String>).elementAt(0)),
            // }
          ],
        ),
      ),
    );
  }
}
