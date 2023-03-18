import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodoctor/controllers/usercontroller.dart';
import 'package:prodoctor/services/notification.dart';
import 'package:prodoctor/view/adddetailscreen.dart';
import 'package:prodoctor/model/colors.dart';
import 'package:prodoctor/model/constants.dart';
import 'package:prodoctor/view/chatlistscreen.dart';
import 'package:prodoctor/view/hospitalappointments.dart';
import 'package:prodoctor/view/loginscreen.dart';
import 'package:prodoctor/model/doctormodel.dart';
import 'package:prodoctor/view/notifictionscreen.dart';
import 'package:prodoctor/view/search.dart';
import 'package:prodoctor/view/viewappointments.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
        child: GetBuilder<UserController>(
          init: UserController(),
          builder: (controller) {
            return SafeArea(
              child: Scaffold(
                drawer: MainDrawerWidget(cuser: controller.cuser),
                backgroundColor: background,
                appBar: homeAppbarWidget(),
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, Dr.${controller.cuser.name ?? ""}!',
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
                                readOnly: true,
                                decoration: InputDecoration(
                                    suffixIcon: const Icon(Icons.search),
                                    hintText: 'Search your patients',
                                    contentPadding: const EdgeInsets.all(15),
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                onTap: () {
                                  showSearch(
                                      context: context,
                                      delegate: CustomSearchDelegate());
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
                            Column(mainAxisSize: MainAxisSize.min, children: <
                                Widget>[
                          const SizedBox(
                            child: TabBar(
                              labelColor: Colors.green,
                              unselectedLabelColor: Colors.black,
                              tabs: [
                                Tab(
                                    child: SizedBox(
                                  child: Text('Todays Appointments'),
                                )),
                                Tab(text: 'All Appointments'),
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.0),
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
                                                child: Text('Error'));
                                          }
                                          if (!snapshot.hasData) {
                                            return const Center(
                                                child:
                                                    Text('Data not available'));
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
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          return Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                itemCount: snapshot
                                                    .data!['hospital'].length,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        childAspectRatio: 2 / 2,
                                                        crossAxisSpacing: 10,
                                                        mainAxisSpacing: 10),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  DateTime todaysdate =
                                                      DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now().day);

                                                  List hospitals = snapshot
                                                      .data!['hospital'];
                                                  return InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          ViewAppointments(
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
                                                          const Icon(Icons
                                                              .local_hospital),
                                                          Text(
                                                            hospitals[index]
                                                                ['name'],
                                                            style: const TextStyle(
                                                                color: primary,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900),
                                                          ),
                                                          StreamBuilder<
                                                                  QuerySnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid)
                                                                  .collection(
                                                                      'appointments')
                                                                  .where(
                                                                    'hospital',
                                                                    isEqualTo: hospitals[
                                                                            index]
                                                                        [
                                                                        'name'],
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
                                                                          Text(
                                                                    'Appointments:',
                                                                  ));
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
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
                                              child:
                                                  Text('Data not available'));
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
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: snapshot
                                                  .data!['hospital'].length,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      childAspectRatio: 2 / 2,
                                                      crossAxisSpacing: 10,
                                                      mainAxisSpacing: 10),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                List hospitals =
                                                    snapshot.data!['hospital'];
                                                return InkWell(
                                                  onTap: () {
                                                    Get.to(() =>
                                                        HospitalAppointments(
                                                          hospital:
                                                              hospitals[index]
                                                                  ['name'],
                                                        ));
                                                  },
                                                  child: Card(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        const Icon(Icons
                                                            .local_hospital),
                                                        Text(
                                                          hospitals[index]
                                                              ['name'],
                                                          style: const TextStyle(
                                                              color: primary,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                        ),
                                                        StreamBuilder<
                                                                QuerySnapshot>(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
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
                                                                          [
                                                                          'name'],
                                                                )
                                                                .snapshots(),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                  .hasError) {
                                                                return const Center(
                                                                    child: Text(
                                                                        'Error'));
                                                              }
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return const Center(
                                                                  child: Text(
                                                                      'Appointments:'),
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
            );
          },
        ));
  }

  AppBar homeAppbarWidget() {
    return AppBar(
      foregroundColor: primary,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
            onPressed: () {
              Get.to(() => const ScreenNotification());
            },
            icon: Stack(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.notifications,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('notifications')
                          .where('read', isEqualTo: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox();
                        }
                        return snapshot.data!.docs.length != 0
                            ? CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 8,
                                child: Text(
                                  '${snapshot.data!.docs.length}',
                                  style: TextStyle(
                                      color: whiteColor, fontSize: 12),
                                ))
                            : SizedBox();
                      }),
                ),
              ],
            )),
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
          gheight_30,
          CircleAvatar(
            backgroundColor: background,
            radius: 80,
            child: cuser.image == null
                ? const CircleAvatar(
                    radius: 75,
                    backgroundColor: primary,
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 50,
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 75,
                    backgroundColor: primary,
                    backgroundImage: Image.network("${cuser.image}").image,
                  ),
          ),
          gheight_10,
          Center(
            child: Text(
              "${cuser.name}",
              style: const TextStyle(
                  color: primary, fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              Get.to(() => const ChatListScreen());
            },
            title: Row(
              children: [
                Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6.0, right: 15),
                      child: Text(
                        'Chat',
                        style: TextStyle(
                            color: primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chats')
                            .where('read', isEqualTo: false)
                            .where('doctor',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: SizedBox(),
                            );
                          }
                          int count = 0;
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            count = count + 1;
                          }
                          return count != 0
                              ? Positioned(
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 8,
                                    child: Text(
                                      '$count',
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ),
                                )
                              : const SizedBox();
                        })
                  ],
                ),
              ],
            ),
            subtitle: const Text('Messages from patients'),
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
