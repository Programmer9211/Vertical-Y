import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:not_whatsapp/home/Screens/ChatRoom.dart';
import 'package:not_whatsapp/home/Screens/postCreation.dart';
import 'package:not_whatsapp/home/Screens/profile.dart';
import 'package:not_whatsapp/services/auth.dart';
import 'package:not_whatsapp/shared/const.dart';
import 'package:not_whatsapp/shared/postCard.dart';

import '../shared/const.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    setValue();
    getFollowers();
  }

  void getFollowers() async {
    await FirebaseFirestore.instance
        .collection('profile')
        .doc(auth.currentUser.uid)
        .collection('followers')
        .get()
        .then((value) {
      for (int i = 0; i <= value.docs.length; i++) {
        followersUid.add(value.docs[i]['uid']);
      }
      print(followersUid);
    });
  }

  void setValue() async {
    print('object');
    return await FirebaseFirestore.instance
        .collection('profile')
        .doc(auth.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        profilesnap = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 245, 206, 1.0),
          title: Text(
            "Vertical Y",
            style: TextStyle(
              fontSize: 29,
              color: Color.fromRGBO(101, 97, 125, 1.0),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            FlatButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CreatePost(
                              FirebaseFirestore.instance.collection('news'))));
                },
                icon: Icon(
                  Icons.local_post_office,
                  color: Color.fromRGBO(101, 97, 125, 1.0),
                ),
                label: Text("New Post",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(101, 97, 125, 1.0),
                    ))),
            IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 20,
                  color: Color.fromRGBO(101, 97, 125, 1.0),
                ),
                onPressed: () {
                  BuildContext dialogcontxt;

                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        dialogcontxt = context;
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });

                  signout(context, dialogcontxt);
                })
          ],
          bottom: TabBar(
            indicatorColor: Color.fromRGBO(101, 97, 125, 1.0),
            tabs: [
              Tab(
                text: "News",
                icon: Icon(Icons.rss_feed,
                    color: Color.fromRGBO(101, 97, 125, 1.0)),
              ),
              Tab(
                text: "Chat",
                icon:
                    Icon(Icons.chat, color: Color.fromRGBO(101, 97, 125, 1.0)),
              ),
              Tab(
                icon: Icon(Icons.notifications,
                    color: Color.fromRGBO(101, 97, 125, 1.0)),
                text: "Notifys",
              ),
              Tab(
                icon: Icon(Icons.account_circle,
                    color: Color.fromRGBO(101, 97, 125, 1.0)),
                text: "Profile",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [Feeds(), Message(), Notifications(), Profile()],
        ),
      ),
    );
  }
}

class Feeds extends StatefulWidget {
  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  final TextEditingController title = TextEditingController();
  final TextEditingController des = TextEditingController();

  CollectionReference newsRefs = FirebaseFirestore.instance.collection('news');

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    des.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(213, 210, 221, 0.1),
      body: StreamBuilder<QuerySnapshot>(
          stream: newsRefs.orderBy('order', descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
            if (snap.hasData) {
              return StreamBuilder<QuerySnapshot>(
                  stream: (FirebaseFirestore.instance
                      .collection('profile')
                      .doc(auth.currentUser.uid)
                      .collection('UserPost')
                      .orderBy('order', descending: true)
                      .snapshots()),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snap.data.docs.length != 0) {
                      return ListView.builder(
                          itemCount: snap.data.docs.length,
                          itemBuilder: (context, index) {
                            dspostid = snap.data.docs[index];

                            return Post(
                                ds: dspostid,
                                newsrefs: newsRefs,
                                uid: snap.data.docs[index]['uid']);
                          });
                    } else {
                      return Center(
                        child: Container(
                          height: 100,
                          width: 300,
                          child: Text(
                            "Yay 🙌 You Have The Chance To become out first Person To Post Don't Miss this Opportunity",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[500]),
                          ),
                        ),
                      );
                    }
                  });
            } else {
              return Container(
                child: Text(
                  "I was Feeling bored. So, I just posted it blank",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[200]),
                ),
              );
            }
          }),
    );
  }
}

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  TextEditingController searchbyname = TextEditingController();

  QuerySnapshot snap;

  QuerySnapshot chatsnap;

  getUserName() async {
    await FirebaseFirestore.instance
        .collection('profile')
        .where('name', isEqualTo: searchbyname.text)
        .get()
        .then((value) {
      setState(() {
        snap = value;
      });
    });
  }

  void createChatRoom(DocumentSnapshot ds) {
    String chatRoomId = getChatRoomId(auth.currentUser.displayName,
        ds == null ? snap.docs[0]['name'] : ds['name']);

    List<String> users = [
      auth.currentUser.displayName,
      ds == null ? snap.docs[0]['name'] : ds['name']
    ];

    Map<String, dynamic> chats = {'users': users, 'chatroomid': chatRoomId};

    FirebaseFirestore.instance
        .collection('Chatroom')
        .doc(chatRoomId)
        .set(chats)
        .catchError((e) {
      print(e);
    });

    FirebaseFirestore.instance
        .collection('profile')
        .doc(auth.currentUser.uid)
        .collection('chats')
        .doc(snap.docs[0]['uid'])
        .set({
      'name': snap.docs[0]['name'],
      'image': snap.docs[0]['image'],
      'uid': snap.docs[0]['uid']
    });

    FirebaseFirestore.instance
        .collection('profile')
        .doc(snap.docs[0]['uid'])
        .collection('chats')
        .doc(auth.currentUser.uid)
        .set({
      'name': auth.currentUser.displayName,
      'image': auth.currentUser.photoURL,
      'uid': auth.currentUser.uid
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ChatRoom(
                  usersnap: ds == null ? snap.docs[0] : ds,
                  chatRoomId: chatRoomId,
                )));
  }

  String getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget searchList() {
    return snap != null
        ? ListView.builder(
            itemCount: snap.docs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                  tileColor: Color.fromRGBO(0, 245, 206, 1.0),
                  title: Text(snap.docs[index]['name']),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(snap.docs[index]['image']),
                  ),
                  trailing: RaisedButton(
                      textColor: Color.fromRGBO(0, 245, 206, 1.0),
                      child: Text(
                        "Message",
                      ),
                      color: Color.fromRGBO(101, 97, 125, 1.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () {
                        createChatRoom(null);
                      }),
                ),
              );
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Color.fromRGBO(0, 245, 206, 1.0),
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            controller: searchbyname,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "'Search here'",
                            )),
                      ),
                      SizedBox(width: 10),
                      MaterialButton(
                          elevation: 0.0,
                          child: Icon(Icons.search,
                              color: Color.fromRGBO(0, 245, 206, 1.0),
                              size: 30),
                          onPressed: () {
                            getUserName();
                          },
                          minWidth: 50,
                          height: 50,
                          color: Color.fromRGBO(101, 97, 125, 1.0))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height / 50,
            ),
            snap != null
                ? Container(
                    height: height / 12,
                    child: searchList(),
                  )
                : Container(),
            Container(
                height: height / 1.5,
                width: width,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('profile')
                        .doc(auth.currentUser.uid)
                        .collection('chats')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data != null) {
                        return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  print(snapshot.data.docs[index]['name']);
                                  createChatRoom(snapshot.data.docs[index]);
                                },
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      snapshot.data.docs[index]['image']),
                                ),
                                title: Text(snapshot.data.docs[index]['name']),
                              );
                            });
                      } else {
                        return Container();
                      }
                    })),
          ],
        ),
      ),
    );
  }
}

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('profile')
            .doc(auth.currentUser.uid)
            .collection('notify')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(ds['image']),
                    ),
                    title: Text(ds['title']),
                    subtitle: Text(ds['sub']),
                  );
                });
          } else {
            return Center(
              child: Container(
                child: Text("No Notifications yet"),
              ),
            );
          }
        },
      ),
    );
  }
}
