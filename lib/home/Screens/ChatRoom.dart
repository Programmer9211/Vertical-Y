import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:not_whatsapp/services/auth.dart';

class ChatRoom extends StatefulWidget {
  final QuerySnapshot usersnap;
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
    controller.attach(controller.position);
  }

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
                            ? Colors.blue
                            : Colors.grey,
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
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                  Text(
                    ds['currenttime'],
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
      appBar: AppBar(
          title: Row(
        children: [
          Container(
            height: size.height / 12.9,
            width: size.width / 8,
            child: ClipOval(
              child: Image.network(
                widget.usersnap.docs[0]['image'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: size.width / 30,
          ),
          Text(widget.usersnap.docs[0]['name']),
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
