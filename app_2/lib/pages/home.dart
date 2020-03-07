import 'package:flutter/material.dart';

import '../home_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Colors.blue, Colors.cyanAccent],
            stops: <double>[0.2, 1.0],
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150.0,
              child: Center(
                  child: Text(
                'Choose!',
                textScaleFactor: 3.0,
              )),
            ),
            GridView.count(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(10.0),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                HomeCard('Alarm'),
                HomeCard('Utility'),
                HomeCard('Schedule'),
                HomeCard('Performance'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
