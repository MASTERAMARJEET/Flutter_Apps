import 'package:flutter/material.dart';

class NotReadyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        widthFactor: 10.0,
        child: Text(
          'Sorry!\nPage is not built yet!\nCome Back Later',
          textScaleFactor: 2.5,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
