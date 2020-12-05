import 'package:flutter/material.dart';
import 'package:not_whatsapp/services/auth.dart';
import 'package:not_whatsapp/shared/buttons.dart';
import 'package:not_whatsapp/shared/const.dart';
import 'package:not_whatsapp/shared/logo.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = '';
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(101, 97, 125, 1.0),
        elevation: 0.0,
        title: Text(
          "New Account",
          style:
              TextStyle(fontSize: 24, color: Color.fromRGBO(0, 245, 206, 1.0)),
        ),
        actions: [
          FlatButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(
                Icons.supervisor_account,
                color: Colors.white,
              ),
              label: Text(
                "Login",
                style: TextStyle(
                    fontSize: 18, color: Color.fromRGBO(0, 245, 206, 1.0)),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(101, 97, 125, 1.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(height: 30),
              Logo(),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: TextFormField(
                    decoration: textfieldDecor.copyWith(
                  labelText: "Full Name",
                )),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 10),
                      child: TextFormField(
                        decoration: textfieldDecor.copyWith(labelText: "Email"),
                        validator: (value) =>
                            value.isEmpty ? "Enter an Email" : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 10),
                      child: TextFormField(
                        decoration: textfieldDecor.copyWith(
                          labelText: "New Password",
                        ),
                        validator: (value) => value.length < 6
                            ? "Enter a Password 6 Char Long"
                            : null,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
                child: TextFormField(
                    decoration: textfieldDecor.copyWith(
                  labelText: "Something About you",
                )),
              ),
              SizedBox(height: 30),
              MaterialButton(
                height: 50,
                minWidth: 200,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      loading = true;
                    });
                    dynamic result = await _authService
                        .registerWithemailpassword(email, password);
                    if (result == null) {
                      setState(() {
                        loading = false;
                        error = "Error Not Valid Email";
                      });
                    }
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
              SizedBox(height: 40),
              Text(
                "Created By 3Divyanshu \u{1f47b}",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
