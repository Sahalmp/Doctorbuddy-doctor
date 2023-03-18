import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodoctor/model/colors.dart';
import 'package:prodoctor/view/patientdetails.dart';

class CustomSearchDelegate extends SearchDelegate {
  late List<String> searchTerms = [];

  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(""""$query" not found in list"""),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List patients = [];

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('prescription')
          .where('doctorid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // for (int i = 0; i < snapshot.data!.docs.length; i++) {
        //   final data = await FirebaseFirestore.instance
        //       .collection('pusers')
        //       .doc(snapshot.data!.docs[i]['patientid'])
        //       .get();

        //   print(data.toString());
        //   patients.add({'name': data});
        // }

        print(snapshot.data!.docs);

        return FutureBuilder<List<Map>>(
            future: getUserDetails(snapshot.data!.docs),
            builder: (context, AsyncSnapshot<List<Map>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              patients.addAll(snapshot.data!);
              final jsonList =
                  patients.map((item) => jsonEncode(item)).toList();

              // using toSet - toList strategy
              final uniqueJsonList = jsonList.toSet().toList();

              // convert each item back to the original form using JSON decoding
              final newlist =
                  uniqueJsonList.map((item) => jsonDecode(item)).toList();

              final listItems = query.isEmpty
                  ? newlist
                  : newlist
                      .where((element) => element['name']
                          .toLowerCase()
                          .contains(query.toLowerCase().toString()))
                      .toSet()
                      .toList();

              return ListView.separated(
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  print(listItems[index]['uid'].toString());
                  print(query);

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListTile(
                    onTap: () {
                      Get.to(() => PatientDetails(
                            uid: listItems[index]['uid'],
                            appointmentData: null,
                          ));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    tileColor: whiteColor,
                    leading: const CircleAvatar(
                      backgroundColor: primary,
                      child: Icon(Icons.person),
                    ),
                    title: Text(
                      listItems[index]['name'],
                    ),
                  );
                },
                separatorBuilder: ((context, index) => const Divider(
                      height: 0,
                    )),
              );
            });
      },
    );
  }
}

Future<List<Map>> getUserDetails(
    List<QueryDocumentSnapshot<Object?>> docs) async {
  List<Map> patienDetails = [];
  
  for (var index = 0; index < docs.length; index++) {
    print("LOOP");

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('pusers')
            .doc(docs[index]['patientid'])
            .get();
    patienDetails.add({"name": snapshot['name'], "uid": snapshot['uid']});

    // print(snapshot['name']);

    print('=============================');
  }
  return patienDetails;
}
