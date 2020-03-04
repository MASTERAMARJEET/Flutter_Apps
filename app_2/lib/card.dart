import 'dart:ui';

import 'package:flutter/material.dart';

import './pages/alarm_setter.dart';

class AlarmCard extends StatefulWidget {
  final List<List<String>> _alarmList;

  AlarmCard(this._alarmList);

  @override
  _AlarmCardState createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  Widget _idle;

  void _updater(List<String> _value, int _index) {
    setState(() {
      widget._alarmList[_index] = _value;
    });
  }

  Widget _cardBuilder(BuildContext context, int _index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 30.0),
          child: ListTile(
            leading: Icon(
              Icons.add_alarm,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              widget._alarmList[_index].join(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.mode_edit),
              onPressed: () => Navigator.push<List<String>>(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SetAlarmPage(widget._alarmList[_index])))
                  .then((List<String> value) => _updater(value, _index)),
              iconSize: 45,
               color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderwidget() {
    if (widget._alarmList.length > 0) {
      _idle = ListView.builder(
        itemBuilder: _cardBuilder,
        itemCount: widget._alarmList.length,
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
