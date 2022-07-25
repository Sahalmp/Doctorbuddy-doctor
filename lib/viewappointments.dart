import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:prodoctor/colors.dart';
import 'package:prodoctor/constants.dart';
import 'package:prodoctor/hospitalappointments.dart';
import 'package:prodoctor/patientdetails.dart';

class ViewAppointments extends StatefulWidget {
  const ViewAppointments({Key? key, required this.data, required this.hindex})
      : super(key: key);

  final List data;
  final hindex;

  @override
  State<ViewAppointments> createState() => _ViewAppointmentsState();
}

class _ViewAppointmentsState extends State<ViewAppointments> {
  @override
  Widget build(BuildContext context) {
    final hdata = widget.data[widget.hindex];
    DateTime todaysdate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () {
                Get.to(() => HospitalAppointments(hospital: hdata['name']));
              },
              child: const Text("View all"))
        ],
        // centerTitle: true,
        elevation: 0,
        backgroundColor: primary,
        foregroundColor: whiteColor,
        title: Text(
          hdata['name'],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('appointments')
                .where('hospital', isEqualTo: hdata['name'])
                .where('date', isEqualTo: todaysdate.millisecondsSinceEpoch)
                .orderBy('token')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                children: [
                  gheight_10,
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListTile(
                            tileColor: whiteColor,
                            title: const Text('Status'),
                            trailing: Switch(
                              value: snapshot.data!['hospital'][widget.hindex]
                                  ['status'],
                              onChanged: (value) {
                                setState(() {
                                  widget.data[widget.hindex]['status'] =
                                      !snapshot.data!['hospital'][widget.hindex]
                                          ['status'];

                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({'hospital': widget.data});
                                });
                              },
                            ));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 2,
                        color: Colors.grey,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Today'),
                      ),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot appdoc = snapshot.data!.docs[index];
                          print(
                              "${appdoc.id}++++++++++++++++++++++++++++++++++++++++++++++++++++");
                          return StreamBuilder<QuerySnapshot>(
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
                                DocumentSnapshot ds = snapshot.data!.docs[0];
                                if (widget.data[widget.hindex]['status']) {
                                  if (index == 0) {
                                    return _BuildCard(ds: ds, appdoc: appdoc);
                                  }
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    onTap: () {
                                      Get.to(() => PatientDetails(
                                            appointmentData: appdoc,
                                            data: ds,
                                          ));
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    tileColor: whiteColor,
                                    leading: const CircleAvatar(
                                      backgroundColor: primary,
                                      child: Icon(Icons.person),
                                    ),
                                    title: Text(
                                      ds['name'],
                                    ),
                                    subtitle: Text(appdoc['reason']),
                                  ),
                                );
                              });
                        }),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

class _BuildCard extends StatelessWidget {
  const _BuildCard({
    Key? key,
    required this.ds,
    required this.appdoc,
  }) : super(key: key);

  final DocumentSnapshot<Object?> ds;
  final DocumentSnapshot<Object?> appdoc;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ds['image'] == null
                        ? const CircleAvatar(
                            child: Icon(Icons.person),
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(ds['image']),
                          ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        gwidth_20,
                        Text(
                          "${ds['name']}",
                          style: const TextStyle(
                              color: primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        gwidth_20,
                        Text("Age:${getAge(ds['dob'])}"),
                        gwidth_20,
                        Text("Gender:${ds['gender']}"),
                      ],
                    ),
                    gheight_10,
                    Row(
                      children: [
                        gwidth_20,
                        Container(
                          color: background,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Reason:${appdoc['reason']}"),
                          ),
                        ),
                        gwidth_30,
                        CircleAvatar(
                          backgroundColor: primary,
                          child: Text("${appdoc['token']}"),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                    icon: Icon(Icons.cancel),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red.shade900)),
                    onPressed: () {},
                    label: Text("Reject")),
                ElevatedButton.icon(
                    icon: Icon(Icons.check),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.green.shade900)),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('appointments')
                          .doc(appdoc.id)
                          .update({'currenttoken': true});
                      Get.to(() =>
                          PatientDetails(data: ds, appointmentData: appdoc));
                    },
                    label: Text("Accept"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
