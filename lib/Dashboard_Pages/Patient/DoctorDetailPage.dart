import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DoctorDetailPage extends StatefulWidget {
  final String doctorName;

  const DoctorDetailPage({super.key, required this.doctorName});

  @override
  _DoctorDetailPageState createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  String _formattedTime = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment with ${widget.doctorName}'),
        backgroundColor: const Color(0xFF1C285E),
      ),
      body: Column(
        children: [
          Expanded(
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _selectedDate,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
              },
              calendarFormat: CalendarFormat.month,
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
          ),
          GestureDetector(
            onTap: () => _selectTime(context),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: Text(
                _formattedTime.isEmpty
                    ? 'Select a Time'
                    : 'Selected Time: $_formattedTime',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
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
                _confirmAppointment(context);
              },
              child: const Text('Book Now'),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _formattedTime = picked.format(context);
      });
    }
  }

  void _confirmAppointment(BuildContext context) async {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time')),
      );
      return;
    }

    final selectedDate =
        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
    final selectedTime = _formattedTime;

    final appointmentDetail = {
      'doctorName': widget.doctorName,
      'date': selectedDate,
      'time': selectedTime,
    };

    // Store appointment in Firestore
    await FirebaseFirestore.instance.collection('appointments').add(appointmentDetail);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Appointment Confirmed'),
          content: Text(
            'Your appointment is confirmed with ${widget.doctorName} on $selectedDate at $selectedTime.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Navigate back to the previous page
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
