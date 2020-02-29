import 'package:flutter/material.dart';

import './query.dart';
import './bye.dart';

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

  final _details = const [
    {
      'question': 'Are you ready to get started with the App?',
      'answer': [
        {'txt': 'No, Not yet', 'position': 0},
        {'txt': 'Yes!!..', 'position': 1},
      ]
    },
    {
      'question': 'What would you like to do with this App?',
      'answer': [
        {'txt': 'Alarm', 'position': 0},
        {'txt': 'Daily Planner', 'position': 1},
        {'txt': 'Both', 'position': 2},
      ]
    },
  ];
  void _answerQuestion(int _answerIndex) {
    print((_details[_listIndex]['answer']
        as List<Map<String, Object>>)[_answerIndex]['position']);
    if (_answerIndex + _listIndex != 0 && _listIndex < _details.length) {
      setState(() {
        _listIndex += 1;
      });
    }
  }
  void _reset(){
    setState(() {
    _listIndex = 0;
    });
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
        body: _listIndex < _details.length
            ? Query(_answerQuestion, _details, _listIndex)
            : Bye(_reset),
      ),
    );
  }
}
