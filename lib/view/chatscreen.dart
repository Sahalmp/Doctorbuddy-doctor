import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:prodoctor/model/colors.dart';
import 'package:prodoctor/model/chat.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var type;

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pusers')
            .doc(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final doc = snapshot.data!;
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
                        doc['image'] != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(doc['image']),
                                maxRadius: 20,
                              )
                            : CircleAvatar(
                                child: Icon(Icons.person),
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
                                " ${doc['name']}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                doc['gender'],
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
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('chatTo')
                      .doc(widget.uid)
                      .collection('messages')
                      .where('doctor',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .where('patient', isEqualTo: doc['uid'])
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
                          itemBuilder:
                              (context, QueryDocumentSnapshot snapshot) {
                            DateTime datetime =
                                DateTime.fromMillisecondsSinceEpoch(
                                    snapshot['timestamp']);
                            final time = TimeOfDay.fromDateTime(datetime);
                            if (snapshot['type'] == 'doctor') {
                              type = "sender";
                            } else {
                              type = "receiver";
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('chatTo')
                                  .doc(widget.uid)
                                  .collection('messages')
                                  .doc(snapshot.id)
                                  .update({'read': true});
                            }

                            return GestureDetector(
                              onLongPress: type == 'sender'
                                  ? () {
                                      _delete(context, snapshot);
                                    }
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 18, right: 18, top: 5, bottom: 5),
                                child: Column(
                                  crossAxisAlignment: type == "receiver"
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: (type == "receiver"
                                            ? Colors.grey.shade200
                                            : Colors.blue[200]),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot['content'],
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 13.0, left: 5),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period.name.toUpperCase()}",
                                                      style: const TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                    type != "receiver"
                                                        ? Icon(
                                                            snapshot['read']
                                                                ? Icons.done_all
                                                                : Icons.done,
                                                            size: 15,
                                                          )
                                                        : const SizedBox()
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10, bottom: 10, top: 10),
                            height: 60,
                            width: double.infinity,
                            color: whiteColor,
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
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
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
                                      User? user =
                                          FirebaseAuth.instance.currentUser;
                                      ChatMessages chatMessages = ChatMessages(
                                          read: false,
                                          type: 'doctor',
                                          doctor: user!.uid,
                                          patient: doc['uid'],
                                          timestamp: DateTime.now()
                                              .millisecondsSinceEpoch,
                                          content: controller.text.trim());
                                      controller.clear();
                                      firebaseFirestore
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection('chatTo')
                                          .doc(widget.uid)
                                          .set({'chatuid': widget.uid});
                                      final DocumentReference ds =
                                          await firebaseFirestore
                                              .collection('users')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .collection('chatTo')
                                              .doc(widget.uid)
                                              .collection('messages')
                                              .add(chatMessages.toMap());
                                    }
                                  },
                                  backgroundColor: primary,
                                  elevation: 0,
                                  child: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }));
        });
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
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('chatTo')
                        .doc(widget.uid)
                        .collection('messages')
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
