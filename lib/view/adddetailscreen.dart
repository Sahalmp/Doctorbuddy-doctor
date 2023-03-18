import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:prodoctor/model/colors.dart';
import 'package:prodoctor/model/constants.dart';
import 'package:prodoctor/view/leavescreen.dart';
import 'package:prodoctor/model/category_model.dart';
import 'package:prodoctor/model/hospital_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddetailScreen extends StatelessWidget {
  AddetailScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _hospitalcontroller = TextEditingController();
  final _auth = FirebaseAuth.instance;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<String> hospitals = [];
  final TextEditingController stimeCtl = TextEditingController();
  final TextEditingController etimeCtl = TextEditingController();
  final TextEditingController _placecontroller = TextEditingController();
  final TextEditingController _feecontroller = TextEditingController();
  final TextEditingController _tokencontroller = TextEditingController();

  String? _selectedhospital;
  @override
  Widget build(BuildContext context) {
    bool status = false;

    FirebaseFirestore.instance.collection('hospitals').get().then((snaps) {
      print(
          "${snaps.docs[0].id}bhxbhbxhbxhbxnhdxbhxhdxhhsv===================================.////////////");
      for (int i = 0; i < snaps.docs.length; i++) {
        hospitals.add(snaps.docs[i].id);
      }
      print(
          '==========================================================================');
    });
    User? user = _auth.currentUser;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primary,
        foregroundColor: whiteColor,
        title: const Text(
          ' Timings and locations',
        ),
      ),
      body: Column(
        children: [
          const Divider(
            thickness: 1,
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gheight_10,
                        const Text(
                          'Hospitals',
                          style: TextStyle(color: primary),
                        ),
                        TypeAheadFormField<String>(
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _hospitalcontroller,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.local_hospital),
                                hintText: "hospital",
                                isDense: true,
                                filled: true,
                                fillColor: whiteColor,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: primary),
                                    borderRadius: BorderRadius.circular(10)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              )),
                          suggestionsCallback: (pattern) {
                            return SuggestfField.getSuggestions(
                                pattern, hospitals);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                            );
                          },
                          transitionBuilder:
                              (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) {
                            _hospitalcontroller.text = suggestion;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please select a hospital or addnew';
                            }
                          },
                          onSaved: (value) => _selectedhospital = value,
                        ),
                        gheight_20,
                        TextFormField(
                          controller: _placecontroller,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.place),
                            hintText: "Place",
                            isDense: true,
                            filled: true,
                            fillColor: whiteColor,
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: primary),
                                borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field cannot be empty';
                            } else {
                              return null;
                            }
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(" Start"),
                                  TexttimeField(
                                    controller: stimeCtl,
                                    hint: "Start",
                                  ),
                                ],
                              ),
                            )),
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(" End"),
                                          TexttimeField(
                                            controller: etimeCtl,
                                            hint: "End",
                                          ),
                                        ]))),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Appointment Fee'),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _feecontroller,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.attach_money),
                                  hintText: "Appointment Fee",
                                  isDense: true,
                                  filled: true,
                                  fillColor: whiteColor,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: primary),
                                      borderRadius: BorderRadius.circular(10)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Field cannot be empty';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        gheight_10,
                        Center(
                          child: FloatingActionButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await showdialogm(context, user, status);
                              }
                            },
                            backgroundColor: primary,
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: firebaseFirestore
                            .collection('users')
                            .doc(user!.uid)
                            .collection('timing')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                DocumentSnapshot doc =
                                    snapshot.data!.docs[index];
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: whiteColor,
                                          border: Border.all(color: primary)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    doc['hospital'],
                                                    style: const TextStyle(
                                                        color: primary,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  PopupMenuButton<int>(
                                                    itemBuilder: (context) => [
                                                      // PopupMenuItem 1
                                                      PopupMenuItem(
                                                        value: 1,
                                                        // row with 2 children
                                                        child: Row(
                                                          children: const [
                                                            Icon(Icons.star),
                                                            gwidth_10,
                                                            Text("Mark Leave")
                                                          ],
                                                        ),
                                                      ),

                                                      PopupMenuItem(
                                                        value: 2,
                                                        child: Row(
                                                          children: const [
                                                            Icon(Icons.delete),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text("Delete")
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                    elevation: 2,
                                                    onSelected: (value) async {
                                                      if (value == 1) {
                                                        Get.to(
                                                            () => LeaveScreen(
                                                                  docid: doc.id,
                                                                ));
                                                      } else if (value == 2) {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                            .collection(
                                                                'timing')
                                                            .doc(doc.id).delete();
                                                            
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    'Timing:',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                      '${doc['start']} to ${doc['end']}'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    gheight_10,
                                  ],
                                );
                              });
                        }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  showdialogm(BuildContext context, User? user, bool status) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Add ${_hospitalcontroller.text} to my consult locations?'),
                Text('Confirm Timing ${stimeCtl.text} to ${etimeCtl.text}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();
                DocumentSnapshot ds = await firebaseFirestore
                    .collection('hospitals')
                    .doc(_hospitalcontroller.text)
                    .get();
                print(ds.exists);
                if (!ds.exists) {
                  HospitalModel hospitalModel = HospitalModel();
                  hospitalModel.name = _hospitalcontroller.text;
                  hospitalModel.place = _placecontroller.text;

                  await firebaseFirestore
                      .collection('hospitals')
                      .doc(_hospitalcontroller.text)
                      .set(hospitalModel.toMap());
                  Get.snackbar(_hospitalcontroller.text, 'Successfully added');
                }
                await firebaseFirestore
                    .collection('users')
                    .doc(user!.uid)
                    .collection('timing')
                    .doc(_hospitalcontroller.text)
                    .set({
                  "hospital": _hospitalcontroller.text,
                  "start": stimeCtl.text,
                  "end": etimeCtl.text,
                  "fee": _feecontroller.text
                });

                await firebaseFirestore
                    .collection('users')
                    .doc(user.uid)
                    .update({
                  "hospital": FieldValue.arrayUnion([
                    {'name': _hospitalcontroller.text, 'status': status}
                  ])
                });
              },
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'))
          ],
        );
      },
    );
  }
}

class TexttimeField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  const TexttimeField({Key? key, required this.controller, required this.hint})
      : super(key: key);

  @override
  State<TexttimeField> createState() => _TexttimeFieldState();
}

class _TexttimeFieldState extends State<TexttimeField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller, // add this line.
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.timer_outlined),
        hintText: widget.hint,
        isDense: true,
        filled: true,
        fillColor: whiteColor,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(10)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onTap: () async {
        TimeOfDay time = TimeOfDay.now();
        FocusScope.of(context).requestFocus(FocusNode());

        TimeOfDay? picked =
            await showTimePicker(context: context, initialTime: time);
        if (picked != null && picked != time) {
          widget.controller.text =
              "${picked.hourOfPeriod.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')} ${picked.period.name.toUpperCase()}"; // add this line.
          setState(() {
            time = picked;
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'cant be empty';
        }
        return null;
      },
    );
  }
}
