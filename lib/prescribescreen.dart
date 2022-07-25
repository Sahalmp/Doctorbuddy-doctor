import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodoctor/colors.dart';
import 'package:prodoctor/constants.dart';
import 'package:prodoctor/controllers/prescribecontroller.dart';
import 'package:prodoctor/model/prescriptionmodel.dart';

class PrescribeScreen extends StatelessWidget {
  PrescribeScreen({Key? key, required this.data, required this.appointmentdata})
      : super(key: key);
  final DocumentSnapshot data, appointmentdata;
  final PrescribeContoller prescribeContoller = Get.put(PrescribeContoller());
  final TextEditingController drugcontroller = TextEditingController(),
      usagecontroller = TextEditingController(),
      durcontroller = TextEditingController(),
      remarkscontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                elevation: 1,
                backgroundColor: const Color.fromARGB(255, 11, 77, 130),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async {
                Get.back();

                await FirebaseFirestore.instance
                    .collection('prescription')
                    .add({
                  'pdata': prescribeContoller.prescriptionlist,
                  'doctorid': FirebaseAuth.instance.currentUser!.uid,
                  'patientid': data['uid'],
                  'date': appointmentdata['date'],
                  'reason': appointmentdata['reason']
                }).then((value) {
                  FirebaseFirestore.instance
                      .collection('pusers')
                      .doc(data['uid'])
                      .collection('appointments')
                      .doc(appointmentdata.id)
                      .delete();
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('appointments')
                      .doc(appointmentdata.id)
                      .delete();

                  return Get.snackbar("added", 'Prescribed successfully');
                }).catchError(
                        (e) => Get.snackbar("Error Adding", e.toString()));
              },
              child: const Text("Save"),
            ),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            gheight_20,
            const Center(
              child: Text(
                "New Prescription",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: drugcontroller,
              cursorColor: Colors.black,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                isDense: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(width: 1.5, color: Colors.black)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: "Drug",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: usagecontroller,
              cursorColor: Colors.black,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                isDense: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(width: 1.5, color: Colors.black)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: "Usage",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: durcontroller,
              cursorColor: Colors.black,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(width: 1.5, color: Colors.black)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: "Duration",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: remarkscontroller,
              maxLines: 5,
              textAlign: TextAlign.start,
              cursorColor: Colors.black,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                isDense: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(width: 1.5, color: Colors.black)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: "Remarks",
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Prescription prescription = Prescription(
                    drug: drugcontroller.text.trim(),
                    usage: usagecontroller.text.trim(),
                    duration: durcontroller.text.trim(),
                    remark: remarkscontroller.text.trim());
                prescribeContoller.updatelist(prescription);
                // prescriptionlist.add(prescription.toMap());
              },
              child: const CircleAvatar(
                radius: 30,
                backgroundColor: primary,
                child: Icon(
                  Icons.add,
                  color: whiteColor,
                  size: 30,
                ),
              ),
            ),
            Obx(() => ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: prescribeContoller.prescriptionlist.length,
                itemBuilder: (context, index) {
                  print(prescribeContoller.prescriptionlist[index]['drug']);

                  return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                            color: whiteColor),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prescribeContoller.prescriptionlist[index]
                                    ['drug'],
                                style: const TextStyle(
                                    color: primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Divider(),
                              Row(
                                children: [
                                  Expanded(flex: 1, child: Text('Usage:')),
                                  Expanded(
                                      flex: 2,
                                      child: Text(prescribeContoller
                                          .prescriptionlist[index]['usage'])),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(flex: 1, child: Text('Duration:')),
                                  Expanded(
                                      flex: 2,
                                      child: Text(prescribeContoller
                                              .prescriptionlist[index]
                                          ['duration'])),
                                ],
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text('Remarks:')),
                                  Expanded(
                                      flex: 2,
                                      child: Text(prescribeContoller
                                          .prescriptionlist[index]['remark'])),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ));
                }))
          ],
        ),
      ),
    );
  }
}
