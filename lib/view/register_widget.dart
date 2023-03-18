import 'dart:io';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodoctor/model/colors.dart';
import 'package:prodoctor/view/loginscreen.dart';
import 'package:prodoctor/model/category_model.dart';
import 'package:prodoctor/model/doctormodel.dart';

class RegisterWidget extends StatelessWidget {
  RegisterWidget({Key? key}) : super(key: key);

  final _namecontroller = TextEditingController();

  final _genderController = TextEditingController();

  final _qualificationController = TextEditingController();

  final _registerController = TextEditingController();

  final _placeController = TextEditingController();
  final _categorycontroller = TextEditingController();

  final formkey = GlobalKey<FormState>();
  String? _selectedcategory;
  List<String> hello = [];
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.collection('category').get().then((snaps) {
      print(snaps.docs[1].id);
      for (int i = 0; i < snaps.docs.length; i++) {
        hello.add(snaps.docs[i].id);
      }
      print(
          '==========================================================================');
    });

    return WillPopScope(
      onWillPop: (() async {
        SystemNavigator.pop();
        return false;
      }),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Form(
                      key: formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Register A Doctor",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Field(
                            icon: Icons.person,
                            control: _namecontroller,
                            texthint: "Full Name",
                            type: TextInputType.name,
                            validate: (value) {
                              RegExp regex = RegExp("[a-zA-Z ]");
                              if (value == null ||
                                  value.isEmpty ||
                                  !regex.hasMatch(value) ||
                                  value.length < 4) {
                                return 'Enter a valid name (Min 3 characters)';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Field(
                            icon: Icons.male_outlined,
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'Field cannot be empty';
                              } else {
                                return null;
                              }
                            },
                            control: _genderController,
                            texthint: 'Gender',
                            type: TextInputType.name,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Field(
                            icon: Icons.school,
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'Field cannot be empty';
                              } else {
                                return null;
                              }
                            },
                            control: _qualificationController,
                            texthint: 'Qualification',
                            type: TextInputType.name,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Field(
                            icon: Icons.medical_information_rounded,
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'Field cannot be empty';
                              } else {
                                return null;
                              }
                            },
                            control: _registerController,
                            texthint: 'Registered Practioner No',
                            type: TextInputType.number,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TypeAheadFormField<String>(
                            textFieldConfiguration: TextFieldConfiguration(
                                controller: _categorycontroller,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.category),
                                  labelText: 'Category',
                                  isDense: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: primary),
                                      borderRadius: BorderRadius.circular(10)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                )),
                            suggestionsCallback: (pattern) {
                              return SuggestfField.getSuggestions(
                                  pattern, hello);
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
                              _categorycontroller.text = suggestion;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please select a category';
                              }
                            },
                            onSaved: (value) => _selectedcategory = value,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Field(
                              icon: Icons.place,
                              validate: (value) {
                                if (value.isEmpty) {
                                  return 'Field cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                              control: _placeController,
                              texthint: "Place",
                              type: TextInputType.streetAddress),
                          // const Spacer(),
                          const SizedBox(
                            height: 180,
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        )),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  Get.to(() => RegisterMoreDetails(
                        category: _categorycontroller.text,
                        name: _namecontroller.text.trim(),
                        gender: _genderController.text,
                        place: _placeController.text,
                        regno: _registerController.text,
                        qualification: _qualificationController.text,
                      ));
                }
              },
              child: const Text("Next")),
        ),
      ),
    );
  }
}

class RegisterMoreDetails extends StatefulWidget {
  const RegisterMoreDetails(
      {super.key,
      required this.name,
      required this.gender,
      required this.qualification,
      required this.place,
      required this.regno,
      required this.category});
  final String name;
  final String gender;
  final String category;

  final String qualification;

  final String place;
  final String regno;

  @override
  State<RegisterMoreDetails> createState() => _RegisterMoreDetailsState();
}

class _RegisterMoreDetailsState extends State<RegisterMoreDetails> {
  final formkey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  String emailpattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";

  final ImagePicker _picker = ImagePicker();

  final _emailcontroller = TextEditingController();

  final _passwordController = TextEditingController();

  final _phoneController = TextEditingController();

  final _confirmpasswordcontroller = TextEditingController();

  String? image;

  UploadTask? uploadTask;
  XFile? img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Hello, ${widget.name}",
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Column(
                            children: [
                              Field(
                                icon: Icons.email_rounded,
                                control: _emailcontroller,
                                texthint: "Email",
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
                                icon: Icons.phone,
                                control: _phoneController,
                                texthint: 'Phone No',
                                type: TextInputType.phone,
                                validate: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter a valid phone number';
                                  } else if (value.length < 10) {
                                    return '10 digits required ';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Field(
                                icon: Icons.key_sharp,
                                control: _passwordController,
                                texthint: 'Password',
                                type: TextInputType.visiblePassword,
                                validate: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length <= 6) {
                                    return 'Enter a valid Password (min 6 char)';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Field(
                                icon: Icons.key_sharp,
                                control: _confirmpasswordcontroller,
                                texthint: 'Confirm Password',
                                type: TextInputType.visiblePassword,
                                validate: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      _passwordController.text !=
                                          value.toString()) {
                                    return 'Password does not match';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "upload photo :",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    img = await _picker.pickImage(
                                        source: ImageSource.gallery);
                                    setState(() {});
                                  },
                                  child: const Text("Upload"))
                            ],
                          ),
                          img != null
                              ? Image(
                                  height: 100,
                                  image: FileImage(File(img!.path)))
                              : const SizedBox(
                                  height: 150,
                                ),
                          // Spacer(),
                        ],
                      )),
                )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
                child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          if (img == null) {
                            Get.snackbar(
                                'Image not available', 'Please Upload Image');
                          } else {
                            signup(_emailcontroller.text.trim(),
                                _passwordController.text.trim());
                          }
                        },
                        child: const Text("Submit"))),
              ],
            )),
          )
        ],
      ),
    );
  }

  void signup(String email, String password) {
    if (formkey.currentState!.validate()) {
      _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        postDetailsToFirebaseStore();
      }).catchError((e) {
        Get.snackbar("Error", e!.messege);
      });
    }
  }

  postDetailsToFirebaseStore() async {
    if (img != null) {
      File file = File(img!.path);
      final ref =
          FirebaseStorage.instance.ref().child("doctor/${DateTime.now()}");
      uploadTask = ref.putFile(file);

      await uploadTask
          ?.then((snap) async => image = await snap.ref.getDownloadURL());
    }
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    DoctorModel doctormodel = DoctorModel();
    doctormodel.email = user!.email;
    doctormodel.uid = user.uid;
    doctormodel.phno = _phoneController.text;

    doctormodel.name = widget.name;
    doctormodel.gender = widget.gender;

    doctormodel.place = widget.place;

    doctormodel.qualification = widget.qualification;
    doctormodel.regno = widget.regno;
    doctormodel.image = image;
    doctormodel.category = widget.category;
    DocumentSnapshot ds = await firebaseFirestore
        .collection('category')
        .doc(widget.category)
        .get();
    print(ds.exists);
    if (!ds.exists) {
      CategoryModel categoryModel = CategoryModel();
      categoryModel.name = widget.category;
      categoryModel.image =
          "https://firebasestorage.googleapis.com/v0/b/doctorbuddy-26682.appspot.com/o/category%2Fdoctor.png?alt=media&token=a28e3f6e-6e72-4983-9384-3ed36474cabf";

      await firebaseFirestore
          .collection('category')
          .doc(widget.category)
          .set(categoryModel.toMap());
    }

    await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(doctormodel.toMap());
    Get.to(() => const UnderReviewWidget());
  }
}

class UnderReviewWidget extends StatelessWidget {
  const UnderReviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => LoginScreen());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.offAll(LoginScreen());
            },
          ),
          elevation: 0,
          foregroundColor: primary,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "We will verify your details\nand contact you soon",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Icon(
                CupertinoIcons.checkmark_seal_fill,
                size: 60,
                color: primary,
              ),
              SizedBox(height: 30),
              Text(
                "You have Submitted",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
