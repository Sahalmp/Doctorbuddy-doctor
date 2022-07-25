import 'package:flutter/material.dart';
import 'package:prodoctor/colors.dart';
import 'package:prodoctor/constants.dart';

class PrescriptionScreen extends StatelessWidget {
  const PrescriptionScreen({Key? key, required this.predata}) : super(key: key);
  final List predata;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
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
                  itemCount: predata.length,
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
                              predata[index]['drug'],
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
                                    child: Text(predata[index]['usage'])),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(flex: 1, child: Text('Duration:')),
                                Expanded(
                                    flex: 2,
                                    child: Text(predata[index]['duration'])),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(flex: 1, child: Text('Remarks:')),
                                Expanded(flex: 2, child: Text('')),
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
