import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:not_whatsapp/home/Screens/ChatRoom.dart';
import 'package:not_whatsapp/models/Notifications.dart';
import 'package:not_whatsapp/services/auth.dart';

class ViewProfile extends StatefulWidget {
  final QuerySnapshot snap;

  ViewProfile({this.snap});

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  bool showabout = false;
  bool isNotify = false;

  DocumentReference followerefrence;
  DocumentReference followingrefrence;
  CollectionReference collection =
      FirebaseFirestore.instance.collection('profile');

  Map<String, dynamic> data;
  QuerySnapshot followersnap;
  QuerySnapshot followingsnap;
  int followers;

  @override
  void initState() {
    followerefrence = FirebaseFirestore.instance
        .collection('followers')
        .doc(auth.currentUser.uid + ":" + widget.snap.docs[0]['uid']);

    followingrefrence = FirebaseFirestore.instance
        .collection('following')
        .doc(auth.currentUser.uid + ":" + widget.snap.docs[0]['uid']);
    followers = widget.snap.docs[0]['followers'];
    super.initState();
    init();
    getFollower();
  }

  void getFollower() async {
    await FirebaseFirestore.instance
        .collection('profile')
        .doc(widget.snap.docs[0]['uid'])
        .collection('followers')
        .get()
        .then((value) => setState(() {
              followersnap = value;
            }));

    await FirebaseFirestore.instance
        .collection('profile')
        .doc(widget.snap.docs[0]['uid'])
        .collection('following')
        .get()
        .then((value) => setState(() {
              followingsnap = value;
            }));
  }

  void init() {
    followerefrence.get().then((value) => setState(() {
          data = value.data();
        }));
  }

  void following() {
    if (data != null && data.containsKey(auth.currentUser.uid)) {
      setState(() {
        followers -= 1;
      });
    } else {
      setState(() {
        followers += 1;
      });
    }

    followingrefrence.get().then((value) {
      if (value.data() != null && value.data().length != null) {
        if (value.data().keys.contains(auth.currentUser.uid)) {
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot followingrefs =
                await transaction.get(collection.doc(auth.currentUser.uid));

            if (followingrefs.exists) {
              transaction.update(collection.doc(auth.currentUser.uid),
                  {'following': followingrefs.data()['following'] - 1});

              followingrefrence
                  .update({auth.currentUser.uid: FieldValue.delete()});

              collection
                  .doc(auth.currentUser.uid)
                  .collection('following')
                  .doc(widget.snap.docs[0]['uid'])
                  .delete();

              followerefrence.get().then((value) => setState(() {
                    data = value.data();
                  }));
            }
          });
        } else {
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot followingrefs =
                await transaction.get(collection.doc(auth.currentUser.uid));

            if (followingrefs.exists) {
              transaction.update(collection.doc(auth.currentUser.uid),
                  {'following': followingrefs.data()['following'] + 1});
            }

            followingrefrence.set({auth.currentUser.uid: true});

            followerefrence.get().then((value) => setState(() {
                  data = value.data();
                }));

            collection
                .doc(auth.currentUser.uid)
                .collection('following')
                .doc(widget.snap.docs[0]['uid'])
                .set({
              'name': widget.snap.docs[0]['name'],
              'image': widget.snap.docs[0]['image'],
              'uid': widget.snap.docs[0]['uid']
            });
          });
        }
      } else {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot followingrefs =
              await transaction.get(collection.doc(auth.currentUser.uid));

          if (followingrefs.exists) {
            transaction.update(collection.doc(auth.currentUser.uid),
                {'following': followingrefs.data()['following'] + 1});
          }
          followingrefrence.set({auth.currentUser.uid: true});

          followerefrence.get().then((value) => setState(() {
                data = value.data();
              }));

          collection
              .doc(auth.currentUser.uid)
              .collection('following')
              .doc(widget.snap.docs[0]['uid'])
              .set({
            'name': widget.snap.docs[0]['name'],
            'image': widget.snap.docs[0]['image'],
            'uid': widget.snap.docs[0]['uid']
          });
        });
      }
    });
  }

  void follow() {
    followerefrence.get().then((value) {
      if (value.data() != null && value.data().length != null) {
        if (value.data().keys.contains(auth.currentUser.uid)) {
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot followrefs =
                await transaction.get(collection.doc(widget.snap.docs[0].id));

            if (followrefs.exists) {
              transaction.update(collection.doc(widget.snap.docs[0].id),
                  {'followers': followrefs.data()['followers'] - 1});

              followerefrence
                  .update({auth.currentUser.uid: FieldValue.delete()});

              collection
                  .doc(widget.snap.docs[0]['uid'])
                  .collection('followers')
                  .doc(auth.currentUser.uid)
                  .delete();
            }
          });
        } else {
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot followrefs =
                await transaction.get(collection.doc(widget.snap.docs[0].id));

            if (followrefs.exists) {
              transaction.update(collection.doc(widget.snap.docs[0].id),
                  {'followers': followrefs.data()['followers'] + 1});
            }
            followerefrence.set({auth.currentUser.uid: true});

            collection
                .doc(widget.snap.docs[0]['uid'])
                .collection('followers')
                .doc(auth.currentUser.uid)
                .set({
              'name': auth.currentUser.displayName,
              'image': auth.currentUser.photoURL,
              'uid': auth.currentUser.uid
            });
          });
        }
      } else {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot followrefs =
              await transaction.get(collection.doc(widget.snap.docs[0].id));

          if (followrefs.exists) {
            transaction.update(collection.doc(widget.snap.docs[0].id),
                {'followers': followrefs.data()['followers'] + 1});
          }
          followerefrence.set({auth.currentUser.uid: true});

          collection
              .doc(widget.snap.docs[0]['uid'])
              .collection('followers')
              .doc(auth.currentUser.uid)
              .set({
            'name': auth.currentUser.displayName,
            'image': auth.currentUser.photoURL,
            'uid': auth.currentUser.uid
          });
        });
      }
    });
    following();

    if (isNotify == false) {
      sendNotification(widget.snap.docs[0]['uid'], {
        'title': auth.currentUser.displayName,
        'sub': "Started following you",
        'image': auth.currentUser.photoURL,
        'time': FieldValue.serverTimestamp()
      });

      setState(() {
        isNotify = true;
      });
    }
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
                    "${widget.snap.docs[0]['posts']}",
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
                            uid: widget.snap.docs[0]['uid'])));
              },
              child: Container(
                child: Column(
                  children: [
                    Text(
                      "$followers",
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
                            uid: widget.snap.docs[0]['uid'])));
              },
              child: Container(
                child: Column(
                  children: [
                    Text(
                      "${widget.snap.docs[0]['following']}",
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("${widget.snap.docs[0]['name']}' s profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(
            //   height: height / 25,
            // ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ViewProfilePhoto(
                              title: widget.snap.docs[0]['name'],
                              url: widget.snap.docs[0]['image'],
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                    // image: DecorationImage(
                    //     image: NetworkImage(
                    //       widget.snap.docs[0]['image'],
                    //     ),
                    //     fit: BoxFit.cover)
                    ),
                height: height / 2.8,
                width: width,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: CircleAvatar(
                      radius: 180,
                      backgroundColor: Colors.blue,
                      child: CircleAvatar(
                        radius: 120,
                        backgroundImage: widget.snap.docs[0]['image'] != ""
                            ? NetworkImage(
                                widget.snap.docs[0]['image'],
                              )
                            : AssetImage('assets/search.png'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: height / 10,
              width: width,
              alignment: Alignment.center,
              child: Text(
                widget.snap.docs[0]['name'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              child: Text(
                widget.snap.docs[0]['bio'] == "Add Bio"
                    ? "No bio added yet"
                    : widget.snap.docs[0]['bio'],
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),

            auth.currentUser.uid != widget.snap.docs[0]['uid']
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      height: height / 10,
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RaisedButton(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(width: 2.0)),
                              child: Text(
                                data != null
                                    ? data.containsKey(auth.currentUser.uid)
                                        ? "Unfollow"
                                        : " Follow"
                                    : "Follow",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              onPressed: follow),
                          RaisedButton(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(width: 2.0)),
                              child: Text(
                                "Message",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              onPressed: () {
                                String getChatRoomId(String a, String b) {
                                  if (a.substring(0, 1).codeUnitAt(0) >
                                      b.substring(0, 1).codeUnitAt(0)) {
                                    return "$b\_$a";
                                  } else {
                                    return "$a\_$b";
                                  }
                                }

                                String chatRoomId = getChatRoomId(
                                    auth.currentUser.displayName,
                                    widget.snap.docs[0]['name']);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ChatRoom(
                                              usersnap: widget.snap.docs[0],
                                              chatRoomId: chatRoomId,
                                            )));
                              })
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: height / 18,
                  ),

            infoTile(),

            GestureDetector(
              onTap: () {
                setState(() {
                  showabout = !showabout;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black, width: 2)),
                height: height / 14,
                width: width / 1.02,
                child: Row(
                  children: [
                    Container(
                      width: width / 1.2,
                      child: Text(
                        "  View about ${widget.snap.docs[0]['name']}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 40,
                    )
                  ],
                ),
              ),
            ),
            showabout == false
                ? Container()
                : Container(
                    color: Colors.black12,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text(
                              widget.snap.docs[0]['Location'] == "Add Location"
                                  ? "No Location Added Yet"
                                  : widget.snap.docs[0]['Location']),
                        ),
                        ListTile(
                          leading: Icon(Icons.edit_attributes),
                          title: Text(widget.snap.docs[0]['education'] ==
                                  "Add Education"
                              ? "No Education Added Yet"
                              : widget.snap.docs[0]['education']),
                        ),
                        ListTile(
                          leading: Icon(Icons.work),
                          title: Text(widget.snap.docs[0]['profession'] ==
                                  "Add Profession"
                              ? "No Profession Added Yet"
                              : widget.snap.docs[0]['profession']),
                        ),
                      ],
                    ))
          ],
        ),
      ),
    );
  }
}

class ViewFollowers extends StatefulWidget {
  final QuerySnapshot followersnap;
  final String title;
  final String uid;

  ViewFollowers({this.followersnap, this.title, this.uid});

  @override
  _ViewFollowersState createState() => _ViewFollowersState();
}

class _ViewFollowersState extends State<ViewFollowers> {
  QuerySnapshot updateprofile;

  void updateProfile(int index, DocumentSnapshot ds) async {
    await FirebaseFirestore.instance
        .collection('profile')
        .doc(widget.uid)
        .collection(widget.title == "Followers" ? 'followers' : 'following')
        .doc(ds['uid'])
        .update({
      'name': updateprofile.docs[index]['name'],
      'image': updateprofile.docs[index]['image'],
      'uid': widget.followersnap.docs[index]['uid']
    });
  }

  void onTap(BuildContext context, int index, DocumentSnapshot ds) async {
    await FirebaseFirestore.instance
        .collection('profile')
        .where('uid', isEqualTo: ds['uid'])
        .get()
        .then((value) {
      print(widget.uid);
      print(ds['uid']);
      setState(() {
        updateprofile = value;
      });
      updateProfile(index, ds);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ViewProfile(
                    snap: updateprofile,
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('profile')
              .doc(widget.uid)
              .collection(
                  widget.title == "Followers" ? 'followers' : 'following')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8),
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(width: 1.5)),
                        elevation: 4,
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          onTap: () => onTap(context, index, ds),
                          trailing: Text(
                            "View Profile",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          leading: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(ds['image']),

                            //fit: BoxFit.cover,
                          ),
                          title: Text(
                            ds['name'],
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return Container();
            }
          }),
    );
  }
}

class ViewProfilePhoto extends StatelessWidget {
  final String title, url, asset;

  ViewProfilePhoto({this.title, this.url, this.asset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body:
          Center(child: url == null ? Image.asset(asset) : Image.network(url)),
    );
  }
}
