import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:not_whatsapp/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int colorint = 300;

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
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  signout(context);
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

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    des.dispose();
  }

  static final TimeOfDay timenow = TimeOfDay.now();
  static final DateTime dateTime = DateTime.now();

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                child: Column(
                  children: [
                    TextField(
                      controller: title,
                    ),
                    TextField(
                      controller: des,
                    ),
                    FlatButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection('news').add({
                            'title': "${title.text}",
                            'des': "${des.text}",
                            'name': "${auth.currentUser.displayName}",
                            'order': dateTime,
                            'time': timenow.format(context),
                            'date': dateTime.toString().split(' ')[0]
                          });

                          title.clear();
                          des.clear();
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
        backgroundColor: Color.fromRGBO(213, 210, 221, 0.1),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('news')
                .orderBy('order', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length != 0 &&
                    snapshot.data.docs != null) {
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[
                            index]; // used to get indexes of all documents present in collections
                        return Post(
                          ds: ds,
                        );
                      });
                } else {
                  return Container(
                      // yaha kuch bhi dikha diyo jb koi bhi news na ho tab
                      );
                }
              } else {
                return Container(
                    //
                    );
              }
            }),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Color.fromRGBO(101, 97, 125, 1.0),
          ),
          backgroundColor: Color.fromRGBO(0, 245, 206, 1.0),
          onPressed: _showDialog,
        ));
  }
}

// ignore: must_be_immutable
class Post extends StatelessWidget {
  DocumentSnapshot ds;

  Post({this.ds});

  DocumentSnapshot del;
  int count = 0;

  void agree() {}

  void disagree() {}

  Widget options(String title, IconData iconData, Function onTap, double height,
      double width, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        color: color,
        child: Row(
          children: [
            SizedBox(width: width / 12),
            Icon(
              iconData,
              color: Colors.white,
            ),
            Text(
              " $title",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
        child: Material(
          elevation: 5,
          color: Color.fromRGBO(214, 255, 249, 1),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            child: Column(
              children: [
                Container(
                  height: height / 12,
                  child: Row(
                    children: [
                      SizedBox(
                        width: width / 40,
                      ),
                      CircleAvatar(
                        backgroundColor: Color.fromRGBO(214, 255, 249, 1),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Icon(
                            Icons.account_circle_outlined,
                            size: 35,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width / 15,
                      ),
                      Text(
                        "${ds['name']} \n${ds['time']}  ${ds['date']}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: height / 70,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      ds['title'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    )),
                SizedBox(
                  height: height / 70,
                ),
                Divider(
                  thickness: 2,
                ),
                Container(
                  height: height / 12,
                  child: Row(
                    children: [
                      SizedBox(
                        width: width / 20,
                      ),
                      options(" 0 Agree", Icons.thumb_up, () {}, height / 16,
                          width / 2.6, Colors.green),
                      SizedBox(
                        width: width / 13.5,
                      ),
                      options(" 0 Disagree", Icons.thumb_down, disagree,
                          height / 16, width / 2.6, Colors.red),
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

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.symmetric(),
                // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(150), bottomRight: Radius.circular(150),)
              ),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Color.fromRGBO(0, 245, 206, 1.0),
                      child: CircleAvatar(
                          radius: 75,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(75),
                            child: Image.asset("assets/1.jpg"),
                          )),
                    ),
                  )
                ],
              ),
            ),
            Text(
              "Divyanshu S. Rajput",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            Divider(
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}
