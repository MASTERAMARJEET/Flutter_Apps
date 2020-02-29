import 'package:flutter/material.dart';

import './card_manager.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.black,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      extendBody: true,
      appBar: AppBar(
        title: Text(
          'Alarm Yourself!',
          textScaleFactor: 1.5,
        ),
        centerTitle: true,
      ),
      body: Manager(),
    );
  }
}
