import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aarogyasaathi/Custom/custombutton.dart';
import 'package:aarogyasaathi/Custom/customcolor.dart';
import 'package:aarogyasaathi/Custom/customtextfield.dart';
import 'loginpage.dart';

class MyRegistrationScreen extends StatefulWidget {
  const MyRegistrationScreen({super.key});

  @override
  State<MyRegistrationScreen> createState() => _MyRegistrationScreenState();
}

class _MyRegistrationScreenState extends State<MyRegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Add a user type variable
  String _userType = 'Patient'; // Default value

  Future<void> registeruser() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: _emailController.text.toString(),
        password: _passwordController.text.toString());

    User? user = userCredential.user;

    await FirebaseFirestore.instance.collection("user").doc(user!.uid).set({
      "name": _usernameController.text.toString(),
      "email": _emailController.text.toString(),
      "userType": _userType, // Add user type to Firestore
      "profile":
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
      "password": _passwordController.text.toString(),
    });

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MYLoginScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: CustomPaint(
          painter: BackgroundPainter(),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/mainlogo.png',
                      height: 200,
                      width: 200,
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    Card(
                      color: Colors.transparent,
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 15,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Create an Account",
                                    style: TextStyle(
                                      fontSize: 36,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  MyTextFieldWidget(_usernameController, "Username"),
                                  MyTextFieldWidget(_emailController, "Email"),
                                  MyTextFieldWidget(_passwordController, "Password"),

                                  const SizedBox(height: 20),

                                  // Add a dropdown to select user type
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _userType,
                                        items: <String>['Patient', 'Doctor']
                                            .map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _userType = newValue!;
                                          });
                                        },
                                        dropdownColor: Colors.black87, // Set dropdown background color
                                        style: const TextStyle(
                                          color: Colors.white, // Set text color in dropdown
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  GestureDetector(
                                      onTap: () {
                                        registeruser();
                                      },
                                      child: MyCustomButton("SIGN UP")),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const MYLoginScreen(),
                                            ));
                                      },
                                      child: const Text(
                                        "Existing User | Click Here",
                                        style: TextStyle(
                                          color: DISPLAY_TEXT_COLOR,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
