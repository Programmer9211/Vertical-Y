import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:not_whatsapp/models/Notifications.dart';
import 'package:not_whatsapp/services/auth.dart';

class ChatRoom extends StatefulWidget {
  final DocumentSnapshot usersnap;
  final String chatRoomId;

  ChatRoom({this.usersnap, this.chatRoomId});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  bool isNotify = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("online");
    } else {
      print('offline');
    }
  }

  final TextEditingController message = TextEditingController();

  final CollectionReference chatRoom =
      FirebaseFirestore.instance.collection('Chatroom');

  ScrollController controller = ScrollController();

  TimeOfDay timeNow = TimeOfDay.now();

  Widget showMessage(DocumentSnapshot ds, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
      child: Container(
        alignment: ds['Sendby'] == auth.currentUser.displayName
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: ds['Sendby'] == auth.currentUser.displayName
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Column(
                crossAxisAlignment: ds['Sendby'] == auth.currentUser.displayName
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: ds['Sendby'] == auth.currentUser.displayName
                            ? Color.fromRGBO(0, 185, 157, 1.0)
                            : Color.fromRGBO(101, 97, 125, 1.0),
                        borderRadius:
                            ds['Sendby'] == auth.currentUser.displayName
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                    bottomLeft: Radius.circular(12))
                                : BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12))),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: Text(
                      ds['message'],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                  Text(
                    ds['currenttime'],
                    style: TextStyle(
                        color: Color.fromRGBO(101, 97, 125, 1.0), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromRGBO(220, 220, 230, 1.0),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 245, 206, 1.0),
          title: Row(
            children: [
              Container(
                child: CircleAvatar(
                  radius: 27,
                  backgroundColor: Color.fromRGBO(101, 97, 125, 1.0),
                  child: CircleAvatar(
                    radius: 24,
                    child: Image.network(
                      widget.usersnap['image'],
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              // Container(
              //   height: size.height / 12.9,
              //   width: size.width / 8,
              //   child: ClipOval(
              //     child: Image.network(
              //       widget.usersnap['image'],
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              SizedBox(
                width: size.width / 30,
              ),
              Text(
                widget.usersnap['name'],
                style: TextStyle(
                  fontSize: 24,
                  color: Color.fromRGBO(101, 97, 125, 1.0),
                ),
              ),
            ],
          )),
      body: StreamBuilder<QuerySnapshot>(
          stream: chatRoom
              .doc(widget.chatRoomId)
              .collection('chats')
              .orderBy('time', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                  controller: controller,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return showMessage(ds, context);
                  });
            } else {
              return Container();
            }
          }),
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
                      controller: message,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Send Message...",
                      )),
                ),
                SizedBox(width: 10),
                MaterialButton(
                    elevation: 0.0,
                    child: Icon(Icons.send,
                        color: Color.fromRGBO(0, 245, 206, 1.0), size: 30),
                    onPressed: () {
                      chatRoom.doc(widget.chatRoomId).collection('chats').add({
                        "message": message.text,
                        "Sendby": auth.currentUser.displayName,
                        "currenttime": timeNow.format(context),
                        "time": FieldValue.serverTimestamp()
                      });
                      message.clear();
                      controller.jumpTo(controller.position.maxScrollExtent);

                      if (isNotify == false) {
                        sendNotification(widget.usersnap['uid'], {
                          'title': auth.currentUser.displayName,
                          'sub': "has send you a message",
                          'image': auth.currentUser.photoURL,
                          'time': FieldValue.serverTimestamp()
                        });
                        setState(() {
                          isNotify = true;
                        });
                      }
                    },
                    minWidth: 50,
                    height: 50,
                    color: Color.fromRGBO(101, 97, 125, 1.0))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
