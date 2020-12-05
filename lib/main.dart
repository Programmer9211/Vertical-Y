import 'package:flutter/material.dart';
import 'package:not_whatsapp/home/wapper.dart';
import 'package:not_whatsapp/models/userData.dart';
import 'package:not_whatsapp/services/auth.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(Myapp());
}


class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
    child:
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Wrapper(),
    ),
    );
  }
}
