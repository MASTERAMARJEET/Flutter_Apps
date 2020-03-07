import 'package:flutter/material.dart';

import '../time_details.dart';

class SetAlarmPage extends StatelessWidget {
  final List<String> _detail;

  SetAlarmPage(this._detail);

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
        backgroundColor: Theme.of(context).accentColor,
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
              TimeDetail('Set Hour', hourList, _detail, 0),
              TimeDetail('Set Minutes', minuteList, _detail, 2),
              TimeDetail('Set Period', periodList, _detail, 4),
              FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.add,
                    size: 45,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context, _detail)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
