import 'package:flutter/material.dart';

import '../time_details.dart';

class SetAlarmPage extends StatefulWidget {
  final List<String> _detail;

  SetAlarmPage(this._detail);

  @override
  _SetAlarmPageState createState() => _SetAlarmPageState();
}

class _SetAlarmPageState extends State<SetAlarmPage> {
  final hourList =
      List<String>.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
  final minuteList =
      List<String>.generate(60, (i) => (i + 1).toString().padLeft(2, '0'));
  final periodList = ['am', 'pm'];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.grey[350],
        extendBody: true,
        appBar: AppBar(
          title: Text(
            'Set Alarm',
            textScaleFactor: 1.5,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TimeDetail('Set Hour', hourList, widget._detail, 0),
              TimeDetail('Set Minutes', minuteList, widget._detail, 2),
              TimeDetail('Set Period', periodList, widget._detail, 4),
              FloatingActionButton(
                  child: Icon(Icons.add, size: 45),
                  onPressed: () =>
                      setState((){ 
                        Navigator.pop(context, widget._detail);})),
            ],
          ),
        ),
      ),
    );
  }
}
