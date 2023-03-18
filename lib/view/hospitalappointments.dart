import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:prodoctor/model/colors.dart';
import 'package:prodoctor/view/patientdetails.dart';

import '../model/constants.dart';

class HospitalAppointments extends StatelessWidget {
  HospitalAppointments({Key? key, required this.hospital}) : super(key: key);
  final String hospital;
  bool checkdivider = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        // centerTitle: true,
        elevation: 0,
        backgroundColor: primary,
        foregroundColor: whiteColor,
        title: Text(
          hospital,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('appointments')
                .where('hospital', isEqualTo: hospital)
                .orderBy('date', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              int lastIndex = 0;
              final todaysdate = DateTime(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day)
                  .millisecondsSinceEpoch;

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data!.docs.isEmpty) {
                return Column(
                  children: const [
                    gheight_50,
                    Center(child: Text('No appointments')),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Appointments',
                      style: TextStyle(
                          color: primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          checkdivider = false;

                          if (todaysdate ==
                                  snapshot.data!.docs[index]['date'] &&
                              index == 0) {
                            checkdivider = true;
                          }
                          if (index == 0) {
                            checkdivider = true;
                          }
                          if (snapshot.data!.docs[lastIndex]['date'] !=
                              snapshot.data!.docs[index]['date']) {
                            checkdivider = true;
                          }
                          lastIndex = index;
                          DocumentSnapshot appdoc = snapshot.data!.docs[index];
                          print(
                              "${appdoc.id}++++++++++++++++++++++++++++++++++++++++++++++++++++");
                          final DateTime date =
                              DateTime.fromMillisecondsSinceEpoch(
                                  snapshot.data!.docs[index]['date']);
                          return Column(
                            children: [
                              checkdivider
                                  ? Row(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 2,
                                          color: Colors.grey,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(date
                                                      .millisecondsSinceEpoch ==
                                                  todaysdate
                                              ? "Today"
                                              : "${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}"),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 2,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    )
                                  : SizedBox(),
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('pusers')
                                      .where(
                                        'uid',
                                        isEqualTo: appdoc['uid'],
                                      )
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    DocumentSnapshot ds =
                                        snapshot.data!.docs[0];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        onTap: () {
                                          Get.to(() => PatientDetails(
                                              uid: ds['uid'],
                                              appointmentData: appdoc));
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        tileColor: whiteColor,
                                        leading: ds['image'] == null
                                            ? const CircleAvatar(
                                                backgroundColor: primary,
                                                child: Icon(Icons.person))
                                            : CircleAvatar(
                                                backgroundImage:
                                                    NetworkImage(ds['image']),
                                              ),
                                        title: Text(
                                          ds['name'],
                                        ),
                                        subtitle: Text(ds['gender']),
                                      ),
                                    );
                                  }),
                            ],
                          );
                        }),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
