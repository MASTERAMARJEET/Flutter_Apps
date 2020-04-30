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
                radius: screenWidth - 100.0,
                useMagnifier: true,
                backgroundColor: null,
                // offAxisFraction: 1.0,
                magnification: 1.125,
                looping: true,
                itemExtent: 50.0,
                onSelectedItemChanged: (int state) {
                  print(state);
                },
                children: widgetList)));
  }
}
