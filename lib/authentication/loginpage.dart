import 'dart:ui';
import 'package:aarogyasaathi/authentication/forgot_password.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this for Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aarogyasaathi/Custom/custombutton.dart';
import 'package:aarogyasaathi/Custom/customcolor.dart';
import 'package:aarogyasaathi/Custom/customtextfield.dart';
import 'package:aarogyasaathi/dashboard.dart';
import 'regestrationpage.dart'; // Import the registration page

class MYLoginScreen extends StatefulWidget {
  const MYLoginScreen({super.key});

  @override
  State<MYLoginScreen> createState() => _MYLoginScreenState();
}

class _MYLoginScreenState extends State<MYLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // For showing a loading spinner during login

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text.toString(),
        password: _passwordController.text.toString(),
      );

      User? user = userCredential.user;

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("user")
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        String username = userDoc['name'] ?? 'User';

        // Navigate to the Dashboard, no userType check needed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              "User data not found. Please register again.",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            "Error: Invalid Email or Password",
            style: TextStyle(
              color: Color.fromARGB(255, 255, 0, 0),
            ),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
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
                              color: Colors.white.withOpacity(0.05), // Reduced opacity
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5), // Black shadow
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
                                    "Sign in",
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
                                  MyTextFieldWidget(_emailController, "Email"),
                                  MyTextFieldWidget(_passwordController, "Password"),

                                  _isLoading
                                      ? const CircularProgressIndicator() // Show loading indicator if login is in progress
                                      : GestureDetector(
                                    onTap: () {
                                      loginUser();
                                    },
                                    child: MyCustomButton("LOG IN"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const MyRegistrationScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "New User | Register Here",
                                        style: TextStyle(
                                          color: DISPLAY_TEXT_COLOR,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const ForgotPasswordScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        color: DISPLAY_TEXT_COLOR,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
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

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    final gradientPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color.fromARGB(255, 19, 97, 10),
          Color.fromARGB(255, 255, 255, 255),
          Color.fromARGB(255, 16, 72, 28),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    final smallCirclePath = Path();
    smallCirclePath.addOval(Rect.fromCircle(
      center: Offset(size.width * 0.08, size.height * 0.08), // Move out of frame
      radius: size.width * 0.3, // Increase size
    ));

    final bigCirclePath = Path();
    bigCirclePath.addOval(Rect.fromCircle(
      center: Offset(size.width * 0.9, size.height * 0.9),
      radius: size.width * 0.4,
    ));

    canvas.drawPath(smallCirclePath, gradientPaint);
    canvas.drawPath(bigCirclePath, gradientPaint);

    final blurPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawPath(smallCirclePath, blurPaint);
    canvas.drawPath(bigCirclePath, blurPaint);

    final echoPaint1 = Paint()
      ..color = const Color.fromARGB(255, 19, 97, 10).withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawPath(smallCirclePath, echoPaint1);
    canvas.drawPath(bigCirclePath, echoPaint1);

    final echoPaint2 = Paint()
      ..color = const Color.fromARGB(255, 16, 72, 28).withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawPath(smallCirclePath, echoPaint2);
    canvas.drawPath(bigCirclePath, echoPaint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
