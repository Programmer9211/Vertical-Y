import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40), borderSide: BorderSide.none),
      elevation: 10,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              "Vertical Y",
              style: TextStyle(
                  color: Color.fromRGBO(0, 245, 206, 1.0),
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "' A Question To You All '",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
        height: 90,
        width: 300,
        decoration: BoxDecoration(
            color: Color.fromRGBO(91, 87, 113, 1.0),
            border:
                Border.all(color: Color.fromRGBO(0, 220, 179, 1.0), width: 3),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(10))),
      ),
    );
  }
}
