import 'package:flutter/material.dart';

import '../card_manager.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
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
