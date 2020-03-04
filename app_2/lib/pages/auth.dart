import 'package:flutter/material.dart';

import './home.dart';

class AuthenticatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      extendBody: true,
      appBar: AppBar(
        title: Text(
          'Authenticate Yourself!',
          textScaleFactor: 1.5,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(7.5)),
          color: Theme.of(context).primaryColor,
          onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MyHomePage())),
          child: Text('LOGIN', textScaleFactor: 1.5, style: TextStyle(color: Colors.white,)),
        ),
      ),
    );
  }
}
