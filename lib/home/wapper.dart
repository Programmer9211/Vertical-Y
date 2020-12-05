import 'package:flutter/material.dart';
import 'package:not_whatsapp/authen/authenticate.dart';
import 'package:not_whatsapp/authen/authentication.dart';
import 'package:not_whatsapp/home/home.dart';
import 'package:not_whatsapp/models/userData.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authentication();
    } else {
      return Home();
    }
  }
}
