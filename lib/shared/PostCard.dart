import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  Map<String, dynamic> data;
  Map<String, dynamic> dislikedata;
  bool islikes;

  @override
  void initState() {
    likerefs = FirebaseFirestore.instance
        .collection('like')
        .doc(auth.currentUser.uid + ':' + widget.ds.id);
    dislikerefs = FirebaseFirestore.instance
        .collection('dislike')
        .doc(auth.currentUser.uid + ':' + widget.ds.id);
    super.initState();
    initialize();
  }

  void initialize() {
    setState(() {
      likerefs.get().then((value) {
        data = value.data();
        if (data.length != 0 && data.length != null) {
          islikes = true;
        }
        print(islikes);
      });
      dislikerefs.get().then((value) {
        dislikedata = value.data();
        if (dislikedata.length != 0 && dislikedata.length != null) {
          islikes = false;
        }
        print(islikes);
      });
    });
  }

  void agree() {
    print(islikes);

    // if (islikes == false) {
    //   FirebaseFirestore.instance.runTransaction((transaction) async {
    //     DocumentSnapshot postrefrence =
    //         await transaction.get(widget.newsrefs.doc(widget.ds.id));

    //     if (postrefrence.exists) {
    //       transaction.update(widget.newsrefs.doc(widget.ds.id),
    //           {'dislikes': postrefrence.data()['dislikes'] - 1});

    //       dislikerefs.update({widget.ds.id: FieldValue.delete()});

    //       setState(() {
    //         dislikerefs.get().then((value) => dislikedata = value.data());
    //       });
    //     }
    //   });
    // }

    likerefs.get().then((value) {
      if (value.data() != null && value.data().length != 0) {
        if (value.data().keys.contains(widget.ds.id)) {
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot postrefrence =
                await transaction.get(widget.newsrefs.doc(widget.ds.id));

            if (postrefrence.exists) {
              transaction.update(widget.newsrefs.doc(widget.ds.id),
                  {'likes': postrefrence.data()['likes'] - 1});

              setState(() {
                islikes = null;
              });

              likerefs.update({widget.ds.id: FieldValue.delete()});

              setState(() {
                likerefs.get().then((value) => data = value.data());
              });
            }
          });
        }
      } else {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot postrefrence =
              await transaction.get(widget.newsrefs.doc(widget.ds.id));

          if (postrefrence.exists) {
            transaction.update(widget.newsrefs.doc(widget.ds.id),
                {'likes': postrefrence.data()['likes'] + 1});
            setState(() {
              islikes = true;
            });
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
    print(islikes);

    // if (islikes == true) {
    //   FirebaseFirestore.instance.runTransaction((transaction) async {
    //     DocumentSnapshot postrefrence =
    //         await transaction.get(widget.newsrefs.doc(widget.ds.id));

    //     if (postrefrence.exists) {
    //       transaction.update(widget.newsrefs.doc(widget.ds.id),
    //           {'likes': postrefrence.data()['likes'] - 1});

    //       likerefs.update({widget.ds.id: FieldValue.delete()});

    //       setState(() {
    //         likerefs.get().then((value) => data = value.data());
    //       });
    //     }
    //   });
    // }

    dislikerefs.get().then((value) {
      if (value.data() != null && value.data().length != 0) {
        if (value.data().keys.contains(widget.ds.id)) {
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot postrefrence =
                await transaction.get(widget.newsrefs.doc(widget.ds.id));

            if (postrefrence.exists) {
              transaction.update(widget.newsrefs.doc(widget.ds.id),
                  {'dislikes': postrefrence.data()['dislikes'] - 1});
              setState(() {
                islikes = null;
              });

              dislikerefs.update({widget.ds.id: FieldValue.delete()});

              setState(() {
                dislikerefs.get().then((value) => dislikedata = value.data());
              });
            }
          });
        }
      } else {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot postreference =
              await transaction.get(widget.newsrefs.doc(widget.ds.id));

          if (postreference.exists) {
            transaction.update(widget.newsrefs.doc(widget.ds.id),
                {'dislikes': postreference.data()['dislikes'] + 1});
            setState(() {
              islikes = false;
            });

            dislikerefs.set({widget.ds.id: true});

            setState(() {
              dislikerefs.get().then((value) => dislikedata = value.data());
            });
          }
        });
      }
    });
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
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.asset(
                                  "assets/search.png",
                                  fit: BoxFit.fill,
                                )),
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
                            "About me",
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        ? Colors.blue
                                        : Color.fromRGBO(101, 97, 125, 1.0),
                                    size: 30,
                                  ),
                                  onPressed: agree,
                                )
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
                                        ? Colors.blue
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
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          size: 30,
                          color: Color.fromRGBO(101, 97, 125, 1.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Comments(
                                        newsref: widget.newsrefs,
                                        ds: widget.ds,
                                      )));
                        },
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

  void _showDialog(BuildContext context) {
    final TextEditingController title = TextEditingController();

    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: TextField(
                        controller: title,
                        decoration: textPostField.copyWith(
                            hintText: "Give a nice Catchy Title 👌"),
                      ),
                    ),
                    FlatButton(
                        onPressed: () {
                          newsref.doc(ds.id).collection('comment').doc().set({
                            'title': "${title.text}",
                            'name': "${auth.currentUser.displayName}",
                          });

                          title.clear();

                          Navigator.pop(context);
                        },
                        child: Text("Post"))
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Comments"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: newsref.doc(ds.id).collection('comment').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length != null &&
                    snapshot.data.docs != null) {
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot dsc = snapshot.data.docs[index];
                        return ListTile(
                          title: Text(dsc['title']),
                        );
                      });
                } else {
                  return ListTile();
                }
              } else {
                return ListTile();
              }
            }),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Color.fromRGBO(101, 97, 125, 1.0),
          ),
          backgroundColor: Color.fromRGBO(0, 245, 206, 1.0),
          onPressed: () {
            _showDialog(context);
          },
        ));
  }
}
