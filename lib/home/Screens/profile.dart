
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
               "No name" ,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              Divider(
                thickness: 2,
              ),
              Text(
                "I am a Flutter Developer And I am an Optimistic person",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Divider(
                thickness: 2,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(
                        height: 15,
                      ),
                      InfoTile(
                        icon: Icons.work,
                        title: "Student Currently not Working",
                      ),
                      InfoTile(
                        icon: Icons.work,
                        title: "Student Currently not Working",
                      ),
                      InfoTile(
                        icon: Icons.work,
                        title: "Student Currently not Working",
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Color.fromRGBO(0, 245, 206, 1.0),
        label: Text(
          "Say Hi 👋",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(101, 97, 125, 1.0)),
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final IconData icon;

  InfoTile({this.icon, this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Color.fromRGBO(101, 97, 125, 1.0),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
