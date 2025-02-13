import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentManager {
  // Singleton pattern for simplicity, if needed
  static final AppointmentManager _instance = AppointmentManager._internal();
  factory AppointmentManager() => _instance;
  AppointmentManager._internal();

  Future<List<Map<String, dynamic>>> getAppointments() async {
    try {
      final now = DateTime.now();
      final snapshot = await FirebaseFirestore.instance.collection('appointments').get();

      // Debug: print the retrieved documents
      print("Fetched ${snapshot.docs.length} appointment documents.");

      return snapshot.docs.where((doc) {
        final appointmentTime = _parseDateTime(doc['date'], doc['time']);
        return appointmentTime.isAfter(now);
      }).map((doc) {
        // Debug: print each document being processed
        print("Processing appointment: ${doc.data()}");
        return {
          'doctorName': doc['doctorName'],
          'date': doc['date'],
          'time': doc['time'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }


  DateTime _parseDateTime(String date, String time) {
    final dateParts = date.split('/');
    final timeParts = time.split(':');

    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1].substring(0, 2)); // Get minutes without AM/PM

    // Check for AM/PM
    if (time.endsWith('PM') && hour != 12) {
      hour += 12; // Convert to 24-hour format
    } else if (time.endsWith('AM') && hour == 12) {
      hour = 0; // Convert 12 AM to 0 hours
    }

    return DateTime(
      int.parse(dateParts[2]), // Year
      int.parse(dateParts[1]), // Month
      int.parse(dateParts[0]), // Day
      hour, // Hour
      minute, // Minute
    );
  }
}
