import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final Function handler;
  final String answerText;

  Answer(this.handler, this.answerText);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(2),
      child: RaisedButton(
        onPressed: handler,
        child: Text(
          answerText,
          style: TextStyle(fontSize: 24),
        ),
        color: Colors.tealAccent,
        padding: EdgeInsets.all(20),
      ),
    );
  }
}
