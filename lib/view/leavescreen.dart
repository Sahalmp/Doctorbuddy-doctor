import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prodoctor/controllers/usercontroller.dart';
import 'package:prodoctor/model/colors.dart';
import 'package:prodoctor/services/notification.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({Key? key, required this.docid}) : super(key: key);
  final docid;
  @override
  State<StatefulWidget> createState() => LeaveScreenState();
}

class LeaveScreenState extends State<LeaveScreen> {
  List _selectedDate = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            GetBuilder<UserController>(
              init: UserController(),
              builder: (controller) {
                return IconButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('timing')
                          .doc(widget.docid)
                          .update({'leave': _selectedDate});
                      Get.back();

                      List leave = _selectedDate;
                      print(leave);
                      for (int i = 0; i < _selectedDate.length; i++) {
                        final appointments = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('appointments')
                            .where('hospital', isEqualTo: widget.docid)
                            .where('date',
                                isEqualTo: leave[i].millisecondsSinceEpoch)
                            .get();
                        if (appointments.docs.isNotEmpty) {
                          for (int j = 0; j < appointments.docs.length; j++) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('appointments')
                                .doc(appointments.docs[j].id)
                                .delete();
                            await FirebaseFirestore.instance
                                .collection('pusers')
                                .doc(appointments.docs[j]['uid'])
                                .collection('appointments')
                                .doc(appointments.docs[j].id)
                                .delete();
                            DocumentSnapshot<Map<String, dynamic>> timingdata =
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('timing')
                                    .doc(widget.docid)
                                    .get();
                            DocumentSnapshot<Map<String, dynamic>> userdata =
                                await FirebaseFirestore.instance
                                    .collection('pusers')
                                    .doc(appointments.docs[j]['uid'])
                                    .get();
                            await FirebaseFirestore.instance
                                .collection('pusers')
                                .doc(appointments.docs[j]['uid'])
                                .update({
                              'Wallet': userdata['Wallet'] +
                                  num.parse(timingdata['fee']),
                            });
                            await FirebaseFirestore.instance
                                .collection('pusers')
                                .doc(userdata['uid'])
                                .collection('notifications')
                                .add({
                              'title':
                                  ' Appointment of Dr. ${controller.cuser.name} Cancelled',
                              'read': false,
                              'description':
                                  "Doctor is on leave on ${DateFormat('dd MMM yyyy ,EEE').format(leave[i])}\n Your amount will credited to your wallet "
                            });
                            NotificationService.sendNotification(
                                title:
                                    ' Appointment of Dr. ${controller.cuser.name} Cancelled',
                                token: userdata['token'],
                                description:
                                    'Doctor is on leave on ${DateFormat('dd MMM yyyy ,EEE').format(leave[i])}');
                          }
                        }
                      }
                    },
                    icon: Icon(Icons.done));
              },
            )
          ],
          backgroundColor: primary,
          centerTitle: true,
          title: const Text('Mark Leave'),
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Select dates to Mark Leave',
                    style:
                        TextStyle(color: primary, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              top: 80,
              right: 20,
              bottom: 80,
              child: SfDateRangePicker(
                selectionColor: primary,
                onSelectionChanged: (data) {
                  setState(() {
                    _selectedDate = data.value;
                  });
                },
                enablePastDates: false,
                selectionMode: DateRangePickerSelectionMode.multiple,
              ),
            ),
          ],
        ));
  }
}
