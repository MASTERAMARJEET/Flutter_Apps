import 'dart:ui';

import 'package:flutter/material.dart';

class AlarmCard extends StatelessWidget {
  final List<String> _alarmList;
  Widget _idle;

  AlarmCard(this._alarmList);

  Widget _cardBuilder(BuildContext context, int _index) {
    return Card(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 25.0),
        child: ListTile(
          leading: Icon(
            Icons.add_alarm,
            size: 40,
          ),
          title: Text(
            _alarmList[_index],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {},
            iconSize: 40,
          ),
        ),
      ),
    );
  }

  Widget _renderwidget() {
    if (_alarmList.length > 0) {
      _idle = ListView.builder(
        itemBuilder: _cardBuilder,
        itemCount: _alarmList.length,
      );
    } else {
      _idle = Center(
        child: Text(
          'No Alarm Set.\n CLick on \'Set New Alarm\' to set one.',
          textAlign: TextAlign.center,
          textScaleFactor: 1.4,
        ),
      );
    }

    return _idle;
  }

  @override
  Widget build(BuildContext context) {
    return _renderwidget();
  }
}
