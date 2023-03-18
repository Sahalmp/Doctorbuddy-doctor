import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodoctor/model/colors.dart';
import 'package:prodoctor/services/notification.dart';
import 'package:prodoctor/view/SplashScreen.dart';
import 'package:prodoctor/view/homescreen.dart';
import 'package:prodoctor/view/loginscreen.dart';
import 'package:get/get.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const DoctorAppPro());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('A bg message just showed up :  ${message.messageId}');
}

class DoctorAppPro extends StatelessWidget {
  const DoctorAppPro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: primary,
    ));
    final currentuser = FirebaseAuth.instance.currentUser;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(backgroundColor: primary),
          tabBarTheme: const TabBarTheme(
              labelColor: primary, unselectedLabelColor: Colors.grey),
          fontFamily: GoogleFonts.outfit().fontFamily,
          primaryColor: primary,
          primarySwatch: Colors.indigo,
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(primary))),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(primary),
          ))),
      home: const SplashScreen(),
    );
  }
}
