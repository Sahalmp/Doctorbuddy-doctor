import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodoctor/model/colors.dart';
import 'package:prodoctor/model/constants.dart';
import 'package:prodoctor/controllers/prescribecontroller.dart';
import 'package:prodoctor/view/editPrescribescreen.dart';
import 'package:prodoctor/model/prescriptionmodel.dart';

class PrescribeScreen extends StatelessWidget {
  PrescribeScreen({
    Key? key,
    required this.data,
    this.appointmentdata,
  }) : super(key: key);
  final DocumentSnapshot data;
  final DocumentSnapshot? appointmentdata;
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
                  'date': appointmentdata!['date'],
                  'reason': appointmentdata!['reason']
                }).then((value) {
                  FirebaseFirestore.instance
                      .collection('pusers')
                      .doc(data['uid'])
                      .collection('appointments')
                      .doc(appointmentdata!.id)
                      .delete();
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('appointments')
                      .doc(appointmentdata!.id)
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
            gheight_20,
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
            gheight_20,
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

                  return MedicinePrescribtion(
                      index: index, prescribeContoller: prescribeContoller);
                }))
          ],
        ),
      ),
    );
  }
}
