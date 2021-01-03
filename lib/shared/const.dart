import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Dialogs.dart';

const textfieldDecor = InputDecoration(
  labelStyle: TextStyle(color: Color.fromRGBO(0, 245, 206, 1.0)),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(0, 245, 206, 1.0), width: 2.0),
  ),
);

const textPostField = InputDecoration(
  labelStyle: TextStyle(color: Color.fromRGBO(0, 245, 206, 1.0)),
);

DocumentSnapshot dspostid;
DocumentSnapshot profilesnap;
DocumentSnapshot dspostuserid;

List<String> followersUid = List<String>();

void checks(BuildContext context) async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
    }
  } on SocketException catch (_) {
    showDialog(
        context: context,
        builder: (context) => AlertMessage(
              title: "Connection",
              content: "Check Your Network Connection",
            ));
  }
}
