import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodoctor/adddetailscreen.dart';
import 'package:prodoctor/colors.dart';
import 'package:prodoctor/constants.dart';
import 'package:prodoctor/hospitalappointments.dart';
import 'package:prodoctor/loginscreen.dart';
import 'package:prodoctor/model/doctormodel.dart';
import 'package:prodoctor/viewappointments.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  DoctorModel cuser = DoctorModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((cuser) {
      this.cuser = DoctorModel.fromMap(cuser.data());
      setState(() {});
    });
  }

  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          drawer: MainDrawerWidget(cuser: cuser),
          backgroundColor: background,
          appBar: HomeAppbarWidget(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Dr.${cuser.name}!',
                      style: GoogleFonts.poppins(
                        textStyle:
                            const TextStyle(fontSize: 20, color: primary),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 42,
                      child: TextField(
                          decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.search),
                              hintText: 'Search your patients',
                              contentPadding: const EdgeInsets.all(15),
                              filled: true,
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(30))),
                          onChanged: (value) {
                            // do something
                          }),
                    ),
                    gheight_20,
                  ],
                ),
              ),
              DefaultTabController(
                  length: 2, // length of tabs
                  initialIndex: 0,
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Container(
                      child: TabBar(
                        labelColor: Colors.green,
                        unselectedLabelColor: Colors.black,
                        tabs: [
                          Tab(
                              child: Container(
                            child: const Text('Todays Appointments'),
                          )),
                          const Tab(text: 'All Appointments'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.617,
                      child: TabBarView(children: <Widget>[
                        Container(
                          child: Column(
                            children: [
                              gheight_20,
                              Row(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Todays Appointments',
                                      style: TextStyle(
                                          color: primary,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              gheight_10,
                              StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.hasError) {
                                      return const Center(
                                          child: const Text('Error'));
                                    }
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: Text('Data not available'));
                                    }

                                    DocumentSnapshot<Object?>? data =
                                        snapshot.data;

                                    bool isExist = data!
                                        .data()
                                        .toString()
                                        .contains('hospital');

                                    if (!isExist) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: const [
                                          SizedBox(
                                            height: 150,
                                          ),
                                          Center(
                                              child: Text(
                                                  'Add hospitals: No hospitals found')),
                                        ],
                                      );
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          itemCount:
                                              snapshot.data!['hospital'].length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 2 / 2,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            DateTime todaysdate = DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day);

                                            List hospitals =
                                                snapshot.data!['hospital'];
                                            return InkWell(
                                              onTap: () {
                                                Get.to(() => ViewAppointments(
                                                      hindex: index,
                                                      data: hospitals,
                                                    ));
                                              },
                                              child: Card(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    const Icon(
                                                        Icons.local_hospital),
                                                    Text(
                                                      hospitals[index]['name'],
                                                      style: const TextStyle(
                                                          color: primary,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                    StreamBuilder<
                                                            QuerySnapshot>(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                            .collection(
                                                                'appointments')
                                                            .where(
                                                              'hospital',
                                                              isEqualTo:
                                                                  hospitals[
                                                                          index]
                                                                      ['name'],
                                                            )
                                                            .where('date',
                                                                isEqualTo:
                                                                    todaysdate
                                                                        .millisecondsSinceEpoch)
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            );
                                                          }
                                                          if (snapshot
                                                              .hasError) {
                                                            return const Center(
                                                                child: Text(
                                                                    'Error'));
                                                          }

                                                          return Text(
                                                              'Appointments:${snapshot.data!.docs.length}');
                                                        })
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            gheight_20,
                            Row(
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    'All Appointments',
                                    style: TextStyle(
                                        color: primary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Center(
                                        child: const Text('Error'));
                                  }
                                  if (!snapshot.hasData) {
                                    return const Center(
                                        child: Text('Data not available'));
                                  }

                                  DocumentSnapshot<Object?>? data =
                                      snapshot.data;

                                  bool isExist = data!
                                      .data()
                                      .toString()
                                      .contains('hospital');

                                  if (!isExist) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        SizedBox(
                                          height: 150,
                                        ),
                                        Center(
                                            child: Text(
                                                'Add hospitals: No hospitals found')),
                                      ],
                                    );
                                  }

                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        itemCount:
                                            snapshot.data!['hospital'].length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 2 / 2,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          List hospitals =
                                              snapshot.data!['hospital'];
                                          return InkWell(
                                            onTap: () {
                                              Get.to(() => HospitalAppointments(
                                                    hospital: hospitals[index]
                                                        ['name'],
                                                  ));
                                            },
                                            child: Card(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  const Icon(
                                                      Icons.local_hospital),
                                                  Text(
                                                    hospitals[index]['name'],
                                                    style: const TextStyle(
                                                        color: primary,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  ),
                                                  StreamBuilder<QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .collection(
                                                              'appointments')
                                                          .where(
                                                            'hospital',
                                                            isEqualTo:
                                                                hospitals[index]
                                                                    ['name'],
                                                          )
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasError) {
                                                          return const Center(
                                                              child: Text(
                                                                  'Error'));
                                                        }
                                                        if (!snapshot.hasData) {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        }
                                                        return Text(
                                                            'Appointments:${snapshot.data!.docs.length}');
                                                      })
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ]),
                    ),
                  ])),
            ],
          ),
        ),
      ),
    );
  }

  AppBar HomeAppbarWidget() {
    return AppBar(
          foregroundColor: primary,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.notifications)),
            const SizedBox(
              width: 20,
            ),
          ],
        );
  }
}

class MainDrawerWidget extends StatelessWidget {
  const MainDrawerWidget({
    Key? key,
    required this.cuser,
  }) : super(key: key);

  final DoctorModel cuser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: whiteColor,
      width: MediaQuery.of(context).size.width * 0.72,
      child: ListView(
        children: [
          gheight_30,
          cuser.image == null
              ? const CircleAvatar(
                  radius: 50,
                  backgroundColor: primary,
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 60,
                    ),
                  ),
                )
              : Image(
                  height: 200,
                  image: NetworkImage("${cuser.image}"),
                ),
          Center(
            child: Text(
              "${cuser.name}",
              style: const TextStyle(
                  color: primary, fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'My status',
              style: TextStyle(
                  color: primary, fontSize: 20, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Turn on in and out staus'),
            trailing: Switch(value: false, onChanged: (value) {}),
          ),
          ListTile(
            onTap: () => Get.to(() => AddetailScreen()),
            title: const Text(
              'Add Details',
              style: TextStyle(
                  color: primary, fontSize: 20, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Add or Update timing and Locations'),
          ),
          const ListTile(
            title: Text(
              'Contact Us',
              style: TextStyle(
                  color: primary, fontSize: 20, fontWeight: FontWeight.w500),
            ),
            subtitle: Text('Contact in case of any issue'),
          ),
          ListTile(
            onTap: (() {
              FirebaseAuth.instance.signOut();
              Get.to(() => LoginScreen());
            }),
            title: const Text(
              'Logout',
              style: TextStyle(
                  color: primary, fontSize: 20, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Logout of this device'),
          )
        ],
      ),
    );
  }
}
