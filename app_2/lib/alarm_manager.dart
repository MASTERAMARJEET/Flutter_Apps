import 'package:flutter/material.dart';

import './alarm_card.dart';

class Manager extends StatefulWidget {
  @override
  _ManagerState createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  List<List<String>> _alarmList = [];

  void _alarmAdder() =>
      setState(() => _alarmList.add(['07', ':', '00', ' ', 'am']));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.all(7.5)),
        Container(
          child: RaisedButton(
            child: Text(
              'Set New Alarm',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            onPressed: _alarmAdder,
            color: Theme.of(context).primaryColor,
            elevation: 20.0,
          ),
        ),
        Expanded(child: AlarmCard(_alarmList)),
      ],
    );
  }
}
