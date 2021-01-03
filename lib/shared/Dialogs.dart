import 'package:flutter/material.dart';
import 'package:not_whatsapp/services/auth.dart';

class LogOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(101, 97, 125, 1.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        "Logout",
        style: TextStyle(color: Color.fromRGBO(0, 245, 206, 1.0)),
      ),
      content: Text(
        "Do you really want to logout ?",
        style: TextStyle(
            color: Color.fromRGBO(0, 245, 206, 1.0),
            fontWeight: FontWeight.w500),
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
          textColor: Color.fromRGBO(0, 245, 206, 1.0),
        ),
        FlatButton(
          onPressed: () => signout(context),
          child: Text("OK"),
          textColor: Color.fromRGBO(0, 245, 206, 1.0),
        )
      ],
    );
  }
}

class AlertMessage extends StatelessWidget {
  final String title;
  final String content;

  AlertMessage({this.content, this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(101, 97, 125, 1.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        title,
        style: TextStyle(color: Color.fromRGBO(0, 245, 206, 1.0)),
      ),
      content: Text(
        content,
        style: TextStyle(
            color: Color.fromRGBO(0, 245, 206, 1.0),
            fontWeight: FontWeight.w500),
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
          textColor: Color.fromRGBO(0, 245, 206, 1.0),
        ),
      ],
    );
  }
}
