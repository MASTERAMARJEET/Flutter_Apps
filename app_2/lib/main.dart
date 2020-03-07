import 'package:flutter/material.dart';

import './pages/auth.dart';
import './pages/home.dart';
import './pages/alarm.dart';
import './pages/not_ready.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.cyan.shade200,
      ),
      home: AuthenticatePage(),
      routes: {
        '/home': (BuildContext context) => HomePage(),
        '/alarm_manager': (BuildContext context) => AlarmPage(),
        '/not_ready' : (BuildContext context) => NotReadyPage(),
      },
    );
  }
}
