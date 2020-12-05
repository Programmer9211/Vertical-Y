
import 'package:flutter/material.dart';
import 'package:not_whatsapp/services/auth.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

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
                  _auth.signOut();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(213, 210, 221, 0.1),
    );
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
              "Divyanhsu S. Rajput",
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
