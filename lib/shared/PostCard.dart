import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Post extends StatefulWidget {
  DocumentSnapshot ds;

  Post({this.ds});

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  DocumentSnapshot del;

  int count = 0;

  void agree() {}

  void disagree() {}

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
                            "Flutter Developer",
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
                                  "000",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(101, 97, 125, 1.0)),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: Color.fromRGBO(101, 97, 125, 1.0),
                                    size: 30,
                                  ),
                                  onPressed: () {},
                                )
                              ],
                            ),
                            SizedBox(width: 15),
                            Column(
                              children: [
                                Text(
                                  "000",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(101, 97, 125, 1.0)),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.thumb_down,
                                    color: Color.fromRGBO(101, 97, 125, 1.0),
                                    size: 30,
                                  ),
                                  onPressed: () {},
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.menu,size: 30, color: Color.fromRGBO(101, 97, 125, 1.0),),
                        onPressed: (){},
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
