import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prodoctor/chatscreen.dart';
import 'package:prodoctor/colors.dart';
import 'package:prodoctor/constants.dart';
import 'package:prodoctor/prescribescreen.dart';
import 'package:prodoctor/prescriptions.dart';

class PatientDetails extends StatelessWidget {
  const PatientDetails(
      {Key? key, required this.data, required this.appointmentData})
      : super(key: key);
  final DocumentSnapshot data, appointmentData;
  @override
  Widget build(BuildContext context) {
    final Size devSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: background,
      body: ListView(children: <Widget>[
        gheight_10,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: devSize.width * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              IconButton(
                  onPressed: () {
                    Get.to(() => ChatScreen(
                          doc: data,
                        ));
                  },
                  icon: const Icon(Icons.chat)),
            ],
          ),
        ),
        Column(
          children: [
            gheight_20,
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white38,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: data['image'] == null
                      ? const CircleAvatar(
                          radius: 60, child: Icon(Icons.person))
                      : CircleAvatar(
                          backgroundImage: NetworkImage(data['image']),
                        )),
            ),
            gheight_10,
            Text(
              data['name'],
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 22)),
            ),
            Text(
              "Age:${getAge(data['dob'])}",
              style: const TextStyle(color: Colors.blueGrey),
            ),
            Text(
              'Gender:${data['gender']}',
              style: const TextStyle(color: Colors.blueGrey),
            ),
            Text(
              'Blood Group: ${data['bloodgroup']}',
              style: const TextStyle(color: Colors.blueGrey),
            ),
            Text(
              'Address: ${data['address']}',
              style: const TextStyle(color: Colors.blueGrey),
            ),
            gheight_30,
          ],
        ),
        const Divider(
          thickness: 3,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: devSize.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Prescriptions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              gheight_20,
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('prescription')
                      .where('doctorid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .where('patientid', isEqualTo: data['uid'])
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            gheight_10,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot prescrdata =
                              snapshot.data!.docs[index];
                          DateTime date = DateTime.fromMillisecondsSinceEpoch(
                              prescrdata['date']);
                          DateFormat df = DateFormat('dd MMMM\n yyyy');

                          String formatteddate = df.format(date);

                          return InkWell(
                            onTap: () {
                              Get.to(() => PrescriptionScreen(
                                    predata: prescrdata['pdata'],
                                  ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: whiteColor,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8)),
                                      color: primary,
                                    ),
                                    height: 50,
                                    width: 80,
                                    child: Center(
                                      child: Text(
                                        formatteddate,
                                        style: TextStyle(color: whiteColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  gwidth_10,
                                  Text(
                                    prescrdata['reason'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                  ),
                                  gwidth_10,
                                ],
                              ),
                            ),
                          );
                        });
                  }),
              const SizedBox(
                height: 200,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => PrescribeScreen(
                              appointmentdata: appointmentData,
                              data: data,
                            ));
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text('Prescribe'),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

String getAge(dateString) {
  var today = DateTime.now();
  DateTime birthDate = DateFormat('dd/mm/yyyy').parse(dateString);
  var age = today.year - birthDate.year;
  var m = today.month - birthDate.month;
  if (m < 0 || (m == 0 && today.day < birthDate.day)) {
    age--;
  }
  return age.toString();
}
