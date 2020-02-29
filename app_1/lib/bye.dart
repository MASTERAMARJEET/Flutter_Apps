import 'package:flutter/material.dart';

class Bye extends StatelessWidget {
  final Function reset;

  Bye(this.reset);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          'Thank You for your response ! \n\n\nBye',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        FlatButton(onPressed: reset, child: Text('Give Another Response'))
      ],
    );
  }
}
