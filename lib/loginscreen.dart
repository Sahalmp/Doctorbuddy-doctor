import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodoctor/homescreen.dart';
import 'package:prodoctor/register_widget.dart';

import 'colors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final _userController = TextEditingController();

  final _passController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final formkey = GlobalKey<FormState>();
  String emailpattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: [
            Row(
              children: const [
                Spacer(),
                Text(
                  "Find A Doctor ?",
                  style: TextStyle(
                      color: primary, decoration: TextDecoration.underline),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Doctor Login",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
            ),
            const SizedBox(
              height: 30,
            ),
            const Center(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('asset/images/doctorlogo.png'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Hello Doctor Please Login, if you are already Register",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: formkey,
              child: Column(
                children: [
                  Field(
                    icon: Icons.email_rounded,
                    control: _userController,
                    texthint: 'Email',
                    type: TextInputType.emailAddress,
                    validate: (value) {
                      RegExp regex = RegExp(emailpattern);
                      if (value == null ||
                          value.isEmpty ||
                          !regex.hasMatch(value)) {
                        return 'Enter a valid email address';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Field(
                      icon: Icons.key_outlined,
                      control: _passController,
                      texthint: 'Password',
                      type: TextInputType.visiblePassword),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              auth
                                  .signInWithEmailAndPassword(
                                      email: _userController.text,
                                      password: _passController.text)
                                  .then((uid) {
                                Get.to(() => HomeScreen());
                              }).catchError((e) {
                                Get.snackbar(
                                  "Invalid Credentials ",
                                  "please check your password and email",
                                  colorText: whiteColor,
                                  icon: const Icon(Icons.person_off,
                                      color: whiteColor),
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                );
                              });
                            }
                          },
                          child: const Text("Login"))),
                ],
              ),
            ),
            Row(
              children: [
                const Spacer(),
                InkWell(
                  onTap: () {
                    Get.to(() => RegisterWidget());
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(
                        color: primary, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}

class Field extends StatelessWidget {
  const Field(
      {Key? key,
      required this.control,
      required this.texthint,
      required this.type,
      this.validate = null,
      required this.icon})
      : super(key: key);
  final TextEditingController control;
  final String texthint;
  final TextInputType type;
  final validate;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   texthint,
        //   style: TextStyle(color: primary),
        //   textAlign: TextAlign.start,
        // ),
        TextFormField(
          controller: control,
          maxLength: texthint == "Phone No" ? 10 : null,
          obscureText:
              texthint == ("Password") || texthint == ("Confirm Password")
                  ? true
                  : false,
          decoration: InputDecoration(
              prefixText: texthint == "Phone No" ? '+91' : null,
              counterText: "",
              isDense: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primary),
                  borderRadius: BorderRadius.circular(10)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: texthint,
              prefixIcon: Icon(icon)),
          keyboardType: type,
          validator: validate,
        ),
      ],
    );
  }
}
