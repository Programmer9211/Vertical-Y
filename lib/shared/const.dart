import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
