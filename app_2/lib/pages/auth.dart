import 'package:flutter/material.dart';

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
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(7.5)),
          color: Theme.of(context).primaryColor,
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          child: Text('LOGIN',
              textScaleFactor: 1.5,
              style: TextStyle(
                color: Colors.white,
              )),
        ),
      ),
    );
  }
}
