import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:prodoctor/colors.dart';
import 'package:prodoctor/model/chat.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key, required this.doc}) : super(key: key);
  final DocumentSnapshot doc;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var type;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  widget.doc['image'] != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(widget.doc['image']),
                          maxRadius: 20,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 30.0, top: 30),
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 5,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: primary,
                        ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          " ${widget.doc['name']}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          widget.doc['gender'],
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .where('doctor',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where('patient', isEqualTo: widget.doc['uid'])
                .orderBy('timestamp', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('error'));
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('loading'));
              }
              return Stack(
                children: [
                  GroupedListView<QueryDocumentSnapshot, DateTime>(
                    elements: snapshot.data!.docs,
                    reverse: true,
                    order: GroupedListOrder.DESC,
                    floatingHeader: true,
                    useStickyGroupSeparators: true,
                    groupBy: (QueryDocumentSnapshot element) {
                      print(element['timestamp']);

                      return DateTime(
                          DateTime.fromMillisecondsSinceEpoch(
                                  element['timestamp'])
                              .year,
                          DateTime.fromMillisecondsSinceEpoch(
                                  element['timestamp'])
                              .month,
                          DateTime.fromMillisecondsSinceEpoch(
                                  element['timestamp'])
                              .day);
                    },
                    groupHeaderBuilder: _createGroupHeader,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10, bottom: 60),
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, QueryDocumentSnapshot snapshot) {
                      DateTime datetime = DateTime.fromMillisecondsSinceEpoch(
                          snapshot['timestamp']);
                      final time = TimeOfDay.fromDateTime(datetime);
                      if (snapshot['type'] == 'doctor') {
                        type = "sender";
                      } else {
                        type = "receiver";
                      }

                      return Container(
                        padding: const EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment: (type == "receiver"
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Column(
                            children: [
                              GestureDetector(
                                onLongPress: () => _delete(context, snapshot),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: (type == "receiver"
                                        ? Colors.grey.shade200
                                        : Colors.blue[200]),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  child: Text(
                                    snapshot['content'],
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              Text(
                                "${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period.name.toUpperCase()}",
                                style: const TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      height: 60,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                  hintText: "Write message...",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          FloatingActionButton(
                            onPressed: () async {
                              if (controller.text.isNotEmpty &&
                                  controller.text.trim() != "") {
                                FirebaseFirestore firebaseFirestore =
                                    FirebaseFirestore.instance;
                                User? user = FirebaseAuth.instance.currentUser;
                                ChatMessages chatMessages = ChatMessages(
                                    type: 'doctor',
                                    doctor:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    patient: widget.doc['uid'],
                                    timestamp:
                                        DateTime.now().millisecondsSinceEpoch,
                                    content: controller.text.trim());
                                controller.clear();

                                await firebaseFirestore
                                    .collection('chats')
                                    .add(chatMessages.toMap());
                              }
                            },
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                            backgroundColor: primary,
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }));
  }

  void _delete(BuildContext context, ds) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Delete Messege?'),
            content: const Text('Are you sure to delete this message?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () async {
                    // Remove the box
                    Navigator.of(context).pop();

                    await FirebaseFirestore.instance
                        .collection('chats')
                        .doc(ds.id)
                        .delete();

                    // Close the dialog
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  Widget _createGroupHeader(QueryDocumentSnapshot element) {
    // print(element['timestamp']);
    DateTime now = DateTime.now();
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(element['timestamp']);
    String formatedDate = now.day == dateTime.day &&
            now.month == dateTime.month &&
            now.year == dateTime.year
        ? "Today"
        : DateFormat("MMM dd").format(dateTime);
    return SizedBox(
      height: 40,
      child: Align(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              formatedDate,
              style: TextStyle(color: primary),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
