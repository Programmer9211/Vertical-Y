import 'package:flutter/material.dart';
import 'package:not_whatsapp/authen/authentication.dart';
import 'package:not_whatsapp/home/home.dart';
import 'package:not_whatsapp/services/auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
      return Authentication();
    } else {
      return Home();
    }
  }
}
