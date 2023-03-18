import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:prodoctor/model/colors.dart';
import 'package:prodoctor/view/chatscreen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: primary,
          title: const Text('Chats'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('chatTo')
                .snapshots(),
            builder: (context, chatsnapshot) {
              print(FirebaseAuth.instance.currentUser!.uid);
              print(chatsnapshot);
              if (chatsnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text('Loading chats....'),
                );
              }
              print("${chatsnapshot.data!.docs.length}++++++++++++++++++");
              if (chatsnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(' chatlist empty'),
                );
              }
              return ListView.separated(
                itemCount: chatsnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('chatTo')
                          .doc(chatsnapshot.data!.docs[index].id)
                          .collection('messages')
                          .where('doctor',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .where('patient',
                              isEqualTo: chatsnapshot.data!.docs[index].id)
                          .orderBy('timestamp', descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Text(''),
                          );
                        }
                        DocumentSnapshot ds = snapshot.data!.docs[0];
                        final todaysdate = DateTime.now();
                        final contentdate = DateTime.fromMillisecondsSinceEpoch(
                            ds['timestamp']);
                        final time = TimeOfDay.fromDateTime(
                            DateTime.fromMillisecondsSinceEpoch(
                                ds['timestamp']));
                        String lastTime = '';
                        if ("${contentdate.day}/${contentdate.month}/${contentdate.year}" ==
                            "${todaysdate.day}/${todaysdate.month}/${todaysdate.year}") {
                          lastTime =
                              "${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period.name.toUpperCase()}";
                        } else if ("${contentdate.day}/${contentdate.month}/${contentdate.year}" ==
                            "${todaysdate.day - 1}/${todaysdate.month}/${todaysdate.year}") {
                          lastTime = 'Yesterday';
                        } else {
                          lastTime =
                              "${contentdate.day}/${contentdate.month}/${contentdate.year}";
                        }
                        print(
                            "${contentdate.day}/${contentdate.month}/${contentdate.year}");
                        print(
                            "${todaysdate.day}/${todaysdate.month}/${todaysdate.year}");

                        return StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('pusers')
                                .doc(ds['patient'])
                                .snapshots(),
                            builder: (context, pusersnapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: Text(''),
                                );
                              }
                              return ListTile(
                                onTap: () {
                                  Get.to(() => ChatScreen(
                                      uid: chatsnapshot.data!.docs[index].id));
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                tileColor: whiteColor,
                                leading: pusersnapshot.data?['image'] != null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            pusersnapshot.data?['image']),
                                        maxRadius: 20,
                                      )
                                    : const CircleAvatar(
                                        backgroundColor: primary,
                                      ),
                                subtitle: ds['type'] == 'doctor'
                                    ? Row(
                                        children: [
                                          Icon(
                                            ds['read']
                                                ? Icons.done_all
                                                : Icons.done,
                                            size: 15,
                                          ),
                                          Text(ds['content']),
                                        ],
                                      )
                                    : Text(ds['content']),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(lastTime),
                                    StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection('chatTo')
                                            .doc(ds['patient'])
                                            .collection('messages')
                                            .where('doctor',
                                                isEqualTo: FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            .where('patient',
                                                isEqualTo: ds['patient'])
                                            .where('type', isEqualTo: 'patient')
                                            .where('read', isEqualTo: false)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Text('');
                                          }
                                          return snapshot.data!.docs.isNotEmpty
                                              ? CircleAvatar(
                                                  radius: 8,
                                                  child: Text(
                                                    snapshot.data!.docs.length
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                )
                                              : const SizedBox();
                                        })
                                  ],
                                ),
                                title: Text(
                                  pusersnapshot.data?['name'] ?? '',
                                ),
                              );
                            });
                      });
                },
                separatorBuilder: ((context, index) => const Divider(
                      height: 0,
                    )),
              );
            }));
  }
}
