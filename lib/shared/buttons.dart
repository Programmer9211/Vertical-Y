import 'package:flutter/material.dart';

class SignupLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50,
      minWidth: 200,
      onPressed: () {},
      color: Color.fromRGBO(0, 245, 206, 1.0),
      child: Text(
        "Sign-Up",
        style: TextStyle(
          fontSize: 24,
          color: Color.fromRGBO(91, 87, 113, 1.0),
        ),
      ),
      shape: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20), topLeft: Radius.circular(20))),
    );
  }
}
