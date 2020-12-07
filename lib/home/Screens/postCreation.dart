import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:not_whatsapp/services/auth.dart';

class CreatePost extends StatefulWidget {
  CollectionReference newsrefs;

  CreatePost(this.newsrefs);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  static final TimeOfDay timenow = TimeOfDay.now();
  static final DateTime dateTime = DateTime.now();
  final TextEditingController title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(101, 97, 125, 1.0),
        iconTheme: IconThemeData(color: Color.fromRGBO(0, 245, 206, 1.0)),
      ),
      backgroundColor: Color.fromRGBO(101, 97, 125, 1.0),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(0, 245, 206, 1.0), width: 5),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Text(
                    "Create New Post",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(0, 245, 206, 1.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Let The People Know About Your Perspective",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: TextField(
                  controller: title,
                  maxLines: 8,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(0, 245, 206, 1.0), width: 4.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    height: 100,
                    minWidth: 130,
                    shape: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(0, 245, 206, 1.0), width: 2.0),
                    ),
                    child: Text(
                      "Upload",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 245, 206, 1.0)),
                    ),
                    onPressed: () {
                      widget.newsrefs.doc().set({
                        'title': "${title.text}",
                        'name': "${auth.currentUser.displayName}",
                        'order': dateTime,
                        'time': timenow.format(context),
                        'date': dateTime.toString().split(' ')[0],
                        'uid': auth.currentUser.uid,
                        'likes': 0,
                        'dislikes': 0
                      });

                      title.clear();
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  MaterialButton(
                    height: 100,
                    minWidth: 130,
                    shape: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(0, 245, 206, 1.0), width: 2.0),
                    ),
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 245, 206, 1.0)),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Made with ❤ By Aditya & Divyanshu",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
