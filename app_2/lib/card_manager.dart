import 'package:flutter/material.dart';

import './card.dart';

class Manager extends StatefulWidget {
  @override
  _ManagerState createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  List<String> _alarmList = [];

  void _productadder() {
    setState(() {
      _alarmList.add('7:00 am');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: RaisedButton(
            child: Text(
              'Set New Alarm',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            onPressed: _productadder,
            color: Theme.of(context).primaryColor,
            elevation: 20.0,
          ),
        ),
        Expanded(child: AlarmCard(_alarmList)),
      ],
    );
  }
}
