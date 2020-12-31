import 'package:flutter/material.dart';
import 'package:not_whatsapp/services/auth.dart';
import 'package:not_whatsapp/shared/const.dart';
import 'package:not_whatsapp/shared/logo.dart';

class Authenticate extends StatefulWidget {
  final Function toggleView;
  Authenticate({this.toggleView});
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  BuildContext dialogcontxt;

  String email1 = "";
  String password1 = "";
  String error1 = "";
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(101, 97, 125, 1.0),
          elevation: 0.0,
          title: Text(
            "Login",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(0, 245, 206, 1.0),
            ),
          ),
          actions: [
            FlatButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
              label: Text(
                "New",
                style: TextStyle(
                    color: Color.fromRGBO(0, 245, 206, 1.0),
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color.fromRGBO(101, 97, 125, 1.0),
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Logo(),
                SizedBox(height: 60),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          decoration:
                              textfieldDecor.copyWith(labelText: "Email"),
                          validator: (value) =>
                              value.isEmpty ? "Enter a valid Email" : null,
                          onChanged: (val) {
                            setState(() {
                              email1 = val;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          obscureText: true,
                          decoration:
                              textfieldDecor.copyWith(labelText: "Password"),
                          validator: (value) => value.length < 6
                              ? "Enter a Password 6 char long"
                              : null,
                          onChanged: (val) {
                            setState(() {
                              password1 = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                MaterialButton(
                  height: 50,
                  minWidth: 200,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            dialogcontxt = context;
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          });

                      signIn(email1, password1, context, _scaffoldkey,
                          dialogcontxt);
                    }
                  },
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
                          bottomRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                ),
                SizedBox(height: 50),
                InkWell(
                  onTap: () {},
                  child: Text(
                    "Forgot Password ??",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 245, 206, 1.0), fontSize: 16),
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  "Created By 3Divyanshu and Aditya \u{1f47b}",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ));
  }
}
