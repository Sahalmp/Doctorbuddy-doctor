import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../model/doctormodel.dart';
import '../services/notification.dart';

class UserController extends GetxController {
  User? user = FirebaseAuth.instance.currentUser;
  DoctorModel cuser = DoctorModel();

  @override
  void onInit() {
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
    getdata();
    storeNotificationToken();

    // TODO: implement onInit
    super.onInit();
  }

  storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print('$token');
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': token}, SetOptions(merge: true));
  }

  void getdata() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((cuser) {
      this.cuser = DoctorModel.fromMap(cuser.data());
      update();
    });
  }
}
