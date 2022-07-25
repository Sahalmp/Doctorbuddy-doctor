import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodoctor/colors.dart';
import 'package:prodoctor/homescreen.dart';
import 'package:prodoctor/loginscreen.dart';
import 'package:get/get.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DoctorAppPro());
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
      home: currentuser == null ? LoginScreen() : HomeScreen(),
    );
  }
}
