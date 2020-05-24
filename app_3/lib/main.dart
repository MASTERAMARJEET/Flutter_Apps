import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './custom_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final widgetList =
      List<Widget>.generate(60, (i) => Text((i).toString().padLeft(2, '0')));

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: CustomPicker(
            radius: screenWidth,
            looping: true,
            squeeze: 1.25,
            markerRadius: 20.0,
            itemExtent: 50.0,
            onSelectedItemChanged: (int state) {
              print(state);
            },
            children: widgetList),
      ),
    );
  }
}
