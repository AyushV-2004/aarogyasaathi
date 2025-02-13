import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          "Password reset email sent",
          style: TextStyle(color: Colors.deepPurple),
        ),
        duration: Duration(seconds: 3),
      ));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          "Error: ${e.message}",
          style: const TextStyle(color: Colors.deepPurple),
        ),
        duration: const Duration(seconds: 3),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          "An unexpected error occurred. Please try again.",
          style: TextStyle(color: Colors.deepPurple),
        ),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: CustomPaint(
          painter: BackgroundPainter(), // Reusing the background from login page
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
                                    "Reset Password",
                                    style: TextStyle(
                                      fontSize: 36,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      labelText: "Email",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () {
                                      resetPassword();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        "RESET PASSWORD",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        "GO BACK",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
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
      center: Offset(size.width * 0.08, size.height * 0.08),
      radius: size.width * 0.3,
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
