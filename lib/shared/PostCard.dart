import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:not_whatsapp/home/Screens/ChatRoom.dart';
import 'package:not_whatsapp/home/Screens/ViewProfile.dart';
import 'package:not_whatsapp/services/auth.dart';

import 'const.dart';

// ignore: must_be_immutable
class Post extends StatefulWidget {
  String uid;
  DocumentSnapshot ds;
  CollectionReference newsrefs;

  Post({this.ds, this.newsrefs, this.uid});

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  DocumentSnapshot del;

  DocumentReference likerefs;
  DocumentReference dislikerefs;
  DocumentReference imagerefs;
  Map<String, dynamic> data;
  Map<String, dynamic> dislikedata;

  final CollectionReference userSpecificPost = FirebaseFirestore.instance
      .collection('profile')
      .doc(auth.currentUser.uid)
      .collection('UserPost');

  @override
  void initState() {
    likerefs = FirebaseFirestore.instance
        .collection('like')
        .doc(auth.currentUser.uid + ":" + widget.ds.id);
    dislikerefs = FirebaseFirestore.instance
        .collection('dislike')
        .doc(auth.currentUser.uid + ":" + widget.ds.id);
    imagerefs = FirebaseFirestore.instance
        .collection('profile')
        .doc(auth.currentUser.uid);
    super.initState();

    // if (profilesnap.data()['uid'] == dspostid['uid']) {
    //   widget.newsrefs.doc(widget.ds.id).update({'image': profilesnap['image']});
    // }
    updateProfile();
    ref();
  }

  void ref() {
    likerefs.get().then((value) => setState(() {
          data = value.data();
        }));
    dislikerefs.get().then((value) => setState(() {
          dislikedata = value.data();
        }));
  }

  void updateProfile() {
    if (widget.ds['uid'] == auth.currentUser.uid &&
        auth.currentUser.photoURL != null) {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot imagereference =
            await transaction.get(widget.newsrefs.doc(widget.ds.id));
        if (imagereference.exists) {
          transaction.update(widget.newsrefs.doc(widget.ds.id),
              {'image': auth.currentUser.photoURL});
        }
      });
    }
  }

  void agree() {
    likerefs.get().then((value) {
      if (value.data() != null && value.data().length != 0) {
        if (value.data().keys.contains(widget.ds.id)) {
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot postrefrence =
                await transaction.get(widget.newsrefs.doc(widget.ds.id));

            if (postrefrence.exists) {
              transaction.update(widget.newsrefs.doc(widget.ds.id),
                  {'likes': postrefrence.data()['likes'] - 1});

              likerefs.update({widget.ds.id: FieldValue.delete()});

              setState(() {
                likerefs.get().then((value) => data = value.data());
              });
            }
          });
        } else {
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot postrefrence =
                await transaction.get(widget.newsrefs.doc(widget.ds.id));

            if (postrefrence.exists) {
              transaction.update(widget.newsrefs.doc(widget.ds.id),
                  {'likes': postrefrence.data()['likes'] + 1});
            }

            likerefs.set({widget.ds.id: true});

            setState(() {
              likerefs.get().then((value) => data = value.data());
            });
          });
        }
      } else {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot postrefrence =
              await transaction.get(widget.newsrefs.doc(widget.ds.id));

          if (postrefrence.exists) {
            transaction.update(widget.newsrefs.doc(widget.ds.id),
                {'likes': postrefrence.data()['likes'] + 1});
          }

          likerefs.set({widget.ds.id: true});

          setState(() {
            likerefs.get().then((value) => data = value.data());
          });
        });
      }
    });
  }

  void disagree() {
    dislikerefs.get().then((value) {
      if (value.data() != null && value.data().length != 0) {
        if (value.data().keys.contains(widget.ds.id)) {
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot postrefrence =
                await transaction.get(widget.newsrefs.doc(widget.ds.id));

            if (postrefrence.exists) {
              transaction.update(widget.newsrefs.doc(widget.ds.id),
                  {'dislikes': postrefrence.data()['dislikes'] - 1});
            }

            dislikerefs.update({widget.ds.id: FieldValue.delete()});

            setState(() {
              dislikerefs.get().then((value) => dislikedata = value.data());
            });
          });
        } else {
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot postreference =
                await transaction.get(widget.newsrefs.doc(widget.ds.id));

            if (postreference.exists) {
              transaction.update(widget.newsrefs.doc(widget.ds.id),
                  {'dislikes': postreference.data()['dislikes'] + 1});
            }

            dislikerefs.set({widget.ds.id: true});

            setState(() {
              dislikerefs.get().then((value) => dislikedata = value.data());
            });
          });
        }
      } else {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot postreference =
              await transaction.get(widget.newsrefs.doc(widget.ds.id));

          if (postreference.exists) {
            transaction.update(widget.newsrefs.doc(widget.ds.id),
                {'dislikes': postreference.data()['dislikes'] + 1});
          }

          dislikerefs.set({widget.ds.id: true});

          setState(() {
            dislikerefs.get().then((value) => dislikedata = value.data());
          });
        });
      }
    });
  }

  void popupMenuOnTapped(value) async {
    if (value == 0) {
      QuerySnapshot snap;

      String getChatRoomId(String a, String b) {
        if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
          return "$b\_$a";
        } else {
          return "$a\_$b";
        }
      }

      String chatRoomId =
          getChatRoomId(auth.currentUser.displayName, widget.ds['name']);

      await FirebaseFirestore.instance
          .collection('profile')
          .where('name', isEqualTo: widget.ds['name'])
          .get()
          .then((value) {
        setState(() {
          snap = value;
        });

        List<String> users = [auth.currentUser.displayName, widget.ds['name']];

        Map<String, dynamic> chats = {'users': users, 'chatroomid': chatRoomId};

        FirebaseFirestore.instance
            .collection('Chatroom')
            .doc(chatRoomId)
            .set(chats)
            .catchError((e) {
          print(e);
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ChatRoom(
                      usersnap: snap,
                      chatRoomId: chatRoomId,
                    )));
      });
    } else if (value == 1) {
      widget.newsrefs.doc(widget.ds.id).delete();
    } else if (value == 2) {
      await FirebaseFirestore.instance
          .collection('profile')
          .where('name', isEqualTo: widget.ds['name'])
          .get()
          .then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ViewProfile(
                      snap: value,
                    )));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
        child: Material(
          elevation: 1,
          color: Color.fromRGBO(231, 228, 233, 1.0),
          borderRadius: BorderRadius.circular(5),
          child: Container(
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: width / 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                            child: CircleAvatar(
                              radius: 27,
                              backgroundColor: Color.fromRGBO(101, 97, 125, 1.0),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundImage: widget.ds['image'] == ""
                                    ? AssetImage("assets/search.png")
                                    : NetworkImage(widget.ds['image']),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width / 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 2),
                              Text(
                                "${widget.ds['name']}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(101, 97, 125, 1.0),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Bio",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                              Text(
                                "${widget.ds['date']} || ${widget.ds['time']},",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      PopupMenuButton(
                          onSelected: (value) async {
                            popupMenuOnTapped(value);
                          },
                          itemBuilder: (context) => [
                                auth.currentUser.uid == widget.ds['uid']
                                    ? PopupMenuItem(
                                        value: 1, child: Text("Delete Post"))
                                    : PopupMenuItem(
                                        value: 0,
                                        child: Text('Message'),
                                      ),
                                PopupMenuItem(
                                    value: 2, child: Text("View Profile"))
                              ]),
                    ],
                  ),
                ),
                Divider(
                  thickness: 0.5,
                ),
                SizedBox(
                  height: height / 70,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      widget.ds['title'],
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(101, 97, 125, 1.0)),
                    )),
                Divider(),
                Container(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "${widget.ds['likes']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(101, 97, 125, 1.0)),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: data != null &&
                                            data.containsKey(widget.ds.id)
                                        ? Color.fromRGBO(0, 180, 160, 1.0)
                                        : Color.fromRGBO(101, 97, 125, 1.0),
                                    size: 30,
                                  ),
                                  onPressed: agree,
                                  color: Color.fromRGBO(101, 97, 125, 1.0),
                                ),
                              ],
                            ),
                            SizedBox(width: 15),
                            Column(
                              children: [
                                Text(
                                  "${widget.ds['dislikes']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(101, 97, 125, 1.0)),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.thumb_down,
                                    color: dislikedata != null &&
                                            dislikedata
                                                .containsKey(widget.ds.id)
                                        ? Color.fromRGBO(0, 180, 160, 1.0)
                                        : Color.fromRGBO(101, 97, 125, 1.0),
                                    size: 30,
                                  ),
                                  onPressed: disagree,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Comments(
                                        ds: widget.ds,
                                        newsref: widget.newsrefs,
                                      )));
                        },
                        child: Card(
                            elevation: 1,
                            child: Container(
                                height: 50,
                                width: 190,
                                child: Container(
                                    height: 50,
                                    width: 190,
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: widget.newsrefs
                                          .doc(widget.ds.id)
                                          .collection('comment')
                                          .snapshots(),
                                      builder: (c, s) {
                                        if (s.data != null) {
                                          return Text(
                                            "${s.data.docs.length} Comments",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    101, 97, 125, 1.0),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          );
                                        } else {
                                          return Text(
                                            "0 Comments",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    101, 97, 125, 1.0),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          );
                                        }
                                      },
                                    )))),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 70,
                ),
              ],
            ),
          ),
        ));
  }
}

class Comments extends StatelessWidget {
  CollectionReference newsref;
  DocumentSnapshot ds;
  Comments({this.newsref, this.ds});
  final TextEditingController title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(220, 220, 230, 1.0),
      bottomNavigationBar: Container(
        color: Color.fromRGBO(0, 245, 206, 1.0),
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: title,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "'Add Comment Here'",
                      )),
                ),
                SizedBox(width: 10),
                MaterialButton(
                    elevation: 0.0,
                    child: Icon(Icons.send,
                        color: Color.fromRGBO(0, 245, 206, 1.0), size: 30),
                    onPressed: () {
                      newsref.doc(ds.id).collection('comment').doc().set({
                        'title': "${title.text}",
                        'name': "${auth.currentUser.displayName}",
                        'image': profilesnap['image']
                      });

                      title.clear();
                    },
                    minWidth: 50,
                    height: 50,
                    color: Color.fromRGBO(101, 97, 125, 1.0))
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(0, 245, 206, 1.0),
        title: Text(
          "Comment Box",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(101, 97, 125, 1.0)),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: newsref.doc(ds.id).collection('comment').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length != null &&
                  snapshot.data.docs != null) {
                print("yes");
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot dsc = snapshot.data.docs[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 5, left: 5),
                        child: Card(
                          elevation: 0.3,
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor:
                                    Color.fromRGBO(101, 97, 125, 1.0),
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundImage: dsc['image'] == ""
                                      ? AssetImage("assets/search.png")
                                      : NetworkImage(dsc['image']),
                                ),
                              ),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                '${dsc['name']}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              "${dsc['title']}",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                              ),
                            ),
                            trailing: Text(
                              "Date",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return ListTile();
              }
            } else {
              return Center(
                        child: Container(
                          height: 100,
                          width: 300,
                          child: Text(
                            "Comment and present your valuable view this let people know your existence 👌",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[500]),
                          ),
                        ),
                      );
            }
          }),
    );
  }
}
