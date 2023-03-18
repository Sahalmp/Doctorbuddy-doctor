import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:prodoctor/model/colors.dart';
import 'package:prodoctor/model/constants.dart';
import 'package:prodoctor/view/loginscreen.dart';

class ResetScreen extends StatelessWidget {
  ResetScreen({Key? key}) : super(key: key);
  final TextEditingController _emailcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: primary,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gheight_20,
                const Center(
                  child: Text(
                    'Forgot your Password? ',
                    style: TextStyle(
                        color: primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                gheight_50,
                Center(
                  child: Image.asset(
                    'asset/images/sendemail.gif',
                    height: 180,
                  ),
                ),
                gheight_50,
                const Text(
                    'Please enter your email address, to reset your password '),
                gheight_10,
                Form(
                  key: _formKey,
                  child: Field(
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
                      control: _emailcontroller,
                      texthint: 'email',
                      type: TextInputType.emailAddress,
                      icon: Icons.email),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                resetPassword(email: _emailcontroller.text);
                              }
                            },
                            child: Text('Reset Password')),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
