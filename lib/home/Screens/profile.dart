import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:not_whatsapp/services/auth.dart';
import 'package:not_whatsapp/shared/const.dart';
import 'package:path/path.dart' as Path;

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('profile');

  File image;

  Future chooseImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    User user = auth.currentUser;

    Reference reference = FirebaseStorage.instance
        .ref()
        .child('profilePhoto/${Path.basename(image.path)}');

    UploadTask uploadTask = reference.putFile(image);
    print("Uploading............................");
    await uploadTask.whenComplete(() {
      reference.getDownloadURL().then((fileURL) async {
        _collectionReference
            .doc(auth.currentUser.uid)
            .update({'image': fileURL});
        await user
            .updateProfile(photoURL: fileURL)
            .then((value) => print('URL ADDED -------------------------'));
      });
    });
  }

  final controller = TextEditingController();

  void onTapped(String collection) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromRGBO(220, 220, 230, 1.0),
        title: Column(
          children: [
            Text(
              "EDIT ${collection.toUpperCase()}",
              style: TextStyle(color: Colors.black),
            ),
            TextFormField(
              controller: controller,
            ),
            RaisedButton(
                color: Color.fromRGBO(0, 245, 206, 1.0),
                child: Text("Save"),
                onPressed: () {
                  _collectionReference
                      .doc(auth.currentUser.uid)
                      .update({'$collection': controller.text});
                  Navigator.pop(context);
                  controller.clear();
                }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _collectionReference.snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> asyncsnapshot) {
            if (asyncsnapshot.hasData) {
              return StreamBuilder<DocumentSnapshot>(
                  stream: _collectionReference
                      .doc(auth.currentUser.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      profilesnap = snapshot.data;

                      return SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.symmetric(),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: CircleAvatar(
                                        radius: 80,
                                        backgroundColor:
                                            Color.fromRGBO(0, 245, 206, 1.0),
                                        child: CircleAvatar(
                                            radius: 75,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(75),
                                              child: snapshot.data['image'] ==
                                                      ""
                                                  ? IconButton(
                                                      icon: Icon(Icons.add_a_photo, color: Color.fromRGBO(0, 245, 206, 1.0),size: 30),
                                                      onPressed: () {
                                                        chooseImage();
                                                      },
                                                    )
                                                  : Image.network(
                                                      snapshot.data['image']),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "${auth.currentUser.displayName}",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              Divider(
                                thickness: 2,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 10),
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width /
                                        1.165,
                                    child: Text(
                                      "${snapshot.data['bio']}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      onTapped('bio');
                                    },
                                    child: Text(
                                      "Edit",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 2,
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "About Me",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      InfoTile(
                                        icon: Icons.language,
                                        title: snapshot.data['education'],
                                        onTapped: () {
                                          onTapped('education');
                                        },
                                      ),
                                      InfoTile(
                                        icon: Icons.location_on,
                                        title: snapshot.data['Location'],
                                        onTapped: () {
                                          onTapped('Location');
                                        },
                                      ),
                                      InfoTile(
                                        icon: Icons.work,
                                        title: snapshot.data['profession'],
                                        onTapped: () {
                                          onTapped('profession');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  });
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTapped;

  InfoTile({this.icon, this.title, this.onTapped});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Color.fromRGBO(101, 97, 125, 1.0),
              ),
              SizedBox(
                width: width / 20,
              ),
              Container(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onTapped,
          child: Text(
            "Edit",
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
