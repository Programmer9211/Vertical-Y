import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:not_whatsapp/services/auth.dart';
import 'package:not_whatsapp/shared/const.dart';
import 'package:path/path.dart' as Path;
import 'package:not_whatsapp/home/Screens/ViewProfile.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('profile');

  File image;
  QuerySnapshot followersnap;
  QuerySnapshot followingsnap;

  @override
  void initState() {
    super.initState();
    getFollower();
  }

  void getFollower() async {
    await FirebaseFirestore.instance
        .collection('profile')
        .doc(profilesnap.data()['uid'])
        .collection('followers')
        .get()
        .then((value) => setState(() {
              followersnap = value;
            }));

    await FirebaseFirestore.instance
        .collection('profile')
        .doc(profilesnap.data()['uid'])
        .collection('following')
        .get()
        .then((value) => setState(() {
              followingsnap = value;
            }));
  }

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

  void onSelected() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              backgroundColor: Color.fromRGBO(101, 97, 125, 1.0),
              title: Container(
                height: MediaQuery.of(context).size.height / 10,
                width: MediaQuery.of(context).size.width / 1.8,
                child: Column(
                  children: [
                    Expanded(
                      child: FlatButton(
                          textColor: Color.fromRGBO(0, 245, 206, 1.0),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewProfilePhoto(
                                        title: auth.currentUser.displayName,
                                        url: auth.currentUser.photoURL == null
                                            ? null
                                            : auth.currentUser.photoURL,
                                        asset: auth.currentUser.photoURL == null
                                            ? "assets/search.png"
                                            : null,
                                      ))),
                          child: Text('View Profile')),
                    ),
                    Expanded(
                      child: FlatButton(
                          textColor: Color.fromRGBO(0, 245, 206, 1.0),
                          onPressed: () => chooseImage(),
                          child: Text("Change Profile")),
                    ),
                  ],
                ),
              ),
            ));
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

  Widget infoTile() {
    return Container(
      height: MediaQuery.of(context).size.height / 10,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Text(
                    "${profilesnap.data()['posts']}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text("Post", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ViewFollowers(
                            followersnap: followersnap,
                            title: "Followers",
                            uid: profilesnap.data()['uid'])));
              },
              child: Container(
                child: Column(
                  children: [
                    Text(
                      "${profilesnap.data()['followers']}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text("Followers", style: TextStyle(fontSize: 16))
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ViewFollowers(
                            followersnap: followingsnap,
                            title: "Following",
                            uid: profilesnap.data()['uid'])));
              },
              child: Container(
                child: Column(
                  children: [
                    Text(
                      "${profilesnap.data()['following']}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text("Following", style: TextStyle(fontSize: 16))
                  ],
                ),
              ),
            ),
          ),
        ],
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
                                          backgroundImage: snapshot
                                                      .data['image'] ==
                                                  ""
                                              ? AssetImage("assets/search.png")
                                              : NetworkImage(
                                                  snapshot.data['image']),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.photo,
                                              size: 30,
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                            ),
                                            onPressed: onSelected,
                                          ),
                                        ),
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
                              infoTile(),
                              Divider(height: 0.2),
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
