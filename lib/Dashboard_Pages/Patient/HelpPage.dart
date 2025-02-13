import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
        backgroundColor: const Color.fromARGB(255, 20, 97, 11),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How to Use the Healthcare App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Navigating the App',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '1. Home: View your health overview and recent activities.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '2. Friends: Connect with friends and family for support.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '3. Hospital: Find hospitals, clinics, and book appointments with healthcare providers.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '4. Profile: Access your profile settings, help, about us, and log out options.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Troubleshooting Common Issues',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '1. Unable to Log In: Ensure you are using the correct email and password. If you forgot your password, use the "Forgot Password" option to reset it.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '2. App Crashing: Try restarting the app or your device. Ensure you have the latest version of the app installed.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '3. Booking Issues: Make sure you have a stable internet connection. If the problem persists, contact our support team.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Contact Support',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'If you need further assistance, please reach out to our support team at support@healthcareapp.com or call us at (123) 456-7890. We are here to help you 24/7.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
