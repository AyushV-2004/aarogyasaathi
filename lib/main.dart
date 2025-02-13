import 'package:aarogyasaathi/Dashboard_Pages/Patient/BMI.dart';
import 'package:aarogyasaathi/Dashboard_Pages/Patient/DoctorPage.dart';
import 'package:aarogyasaathi/Dashboard_Pages/Patient/PatientPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:aarogyasaathi/authentication/loginpage.dart';
// Adjust the import as necessary
import 'firebase_options.dart';
import 'package:aarogyasaathi/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:aarogyasaathi/consts.dart';

void main() async {

  Gemini.init(
    apiKey: GEMINI_API_KEY,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



  User? user = FirebaseAuth.instance.currentUser;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const MYLoginScreen(),
        '/login': (context) => const MYLoginScreen(),
        '/dashboard': (context) => const Dashboard(
         ),
          '/doctor': (context) => const DoctorPage(),
          '/bmi': (context) =>  const BMI(),
          '/chatbot': (context) => const PatientPage(),
          '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
