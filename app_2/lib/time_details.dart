import 'package:flutter/material.dart';

class TimeDetail extends StatefulWidget {
  final String _detailString;
  final List<String> _detailList;
  final int _index;
  final List<String> outputInfo;

  TimeDetail(
      this._detailString, this._detailList, this.outputInfo, this._index);

  @override
  _TimeDetailState createState() => _TimeDetailState();
}

class _TimeDetailState extends State<TimeDetail> {
  String _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.white,
      child: Container(
        child: ListTile(
          title: Text(
            widget._detailString,
            textScaleFactor: 2.0,
          ),
          trailing: DropdownButton<String>(
            items: widget._detailList.map((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val),
              );
            }).toList(),
            onChanged: (String val) {
              setState(() {
                _selectedValue = val;
                this.widget.outputInfo[this.widget._index] = val;
              });
            },
            hint: Text(widget._detailString),
            value: _selectedValue,
          ),
        ),
        margin: EdgeInsets.symmetric(vertical: 30.0),
      ),
    );
  }
}
