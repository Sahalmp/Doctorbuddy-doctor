import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodoctor/model/colors.dart';
import 'package:prodoctor/model/constants.dart';
import 'package:prodoctor/view/editPrescribescreen.dart';
import 'package:prodoctor/view/prescribescreen.dart';

class PrescriptionScreen extends StatelessWidget {
  const PrescriptionScreen({Key? key, required this.predata}) : super(key: key);
  final DocumentSnapshot predata;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => EditPrescribe(data: predata));
              },
              icon: const Icon(Icons.edit))
        ],
        centerTitle: true,
        title: const Text(
          "Prescriptions",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        foregroundColor: primary,
        backgroundColor: background,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.separated(
                  itemCount: predata['pdata'].length,
                  separatorBuilder: (context, index) => gheight_10,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: whiteColor),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              predata['pdata'][index]['drug'],
                              style: TextStyle(
                                  color: primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(),
                            Row(
                              children: [
                                Expanded(flex: 1, child: Text('Usage:')),
                                Expanded(
                                    flex: 2,
                                    child:
                                        Text(predata['pdata'][index]['usage'])),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(flex: 1, child: Text('Duration:')),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                        predata['pdata'][index]['duration'])),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(flex: 1, child: Text('Remarks:')),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                        predata['pdata'][index]['remark'])),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
