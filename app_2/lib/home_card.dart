import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final _text;

  HomeCard(this._text);

  @override
  Widget build(BuildContext context) {

    void _whichPage() {
      if (_text == 'Alarm') {
        Navigator.pushNamed(context, '/alarm_manager');
      }
      else {
        Navigator.pushNamed(context, '/not_ready');
      }

    }

    return Card(
      child: ListTile(
        onTap: _whichPage,
        title: Center(
          child: Text(
            _text,
            textAlign: TextAlign.center,
            textScaleFactor: 1.5,
          ),
        ),
      ),
    );
  }
}
