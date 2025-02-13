import 'package:flutter/material.dart';
import 'package:aarogyasaathi/Dashboard_Pages/Patient/DoctorDetailPage.dart';

class DoctorInfoPage extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String hospital;
  final String location;
  final String imagePath;

  const DoctorInfoPage({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.hospital,
    required this.location,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Details'),
        backgroundColor: const Color(0xFF1C285E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/male_doctor.jpg'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              doctorName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              specialty,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              'Hospital: $hospital',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Location: $location',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C285E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 15.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorDetailPage(
                        doctorName: doctorName,
                      ),
                    ),
                  );
                },
                child: const Text('Book Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
