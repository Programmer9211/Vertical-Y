import 'package:flutter/material.dart';
import 'package:not_whatsapp/authen/authenticate.dart';
import 'package:not_whatsapp/authen/register.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool showSign = true;
  void toggleView() {
    setState(() {
      showSign = !showSign;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSign) {
      return Authenticate(toggleView: toggleView);
    } else {
      return SignUp(toggleView: toggleView);
    }
  }
}
