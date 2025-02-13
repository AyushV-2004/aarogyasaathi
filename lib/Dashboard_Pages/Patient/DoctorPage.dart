import 'package:flutter/material.dart';
import 'package:aarogyasaathi/Dashboard_Pages/Patient/DoctorInfo.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({super.key});

  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  String _searchQuery = '';

  final List<Map<String, String>> _specialties = [
    {
      'specialty': 'Cardiology',
      'doctorName': 'Dr. Arvind Kumar',
      'hospital': 'Apollo Hospitals',
      'location': 'Chennai, Tamil Nadu',
    },
    {
      'specialty': 'Neurology',
      'doctorName': 'Dr. Priya Sharma',
      'hospital': 'Fortis Hospital',
      'location': 'Bangalore, Karnataka',
    },
    {
      'specialty': 'Orthopedics',
      'doctorName': 'Dr. Rajesh Mehta',
      'hospital': 'Max Healthcare',
      'location': 'Delhi, Delhi',
    },
    {
      'specialty': 'Pediatrics',
      'doctorName': 'Dr. Anjali Verma',
      'hospital': 'Kokilaben Dhirubhai Ambani Hospital',
      'location': 'Mumbai, Maharashtra',
    },
    {
      'specialty': 'Gynecology',
      'doctorName': 'Dr. Sunil Rao',
      'hospital': 'Medanta - The Medicity',
      'location': 'Gurugram, Haryana',
    },
    {
      'specialty': 'Oncology',
      'doctorName': 'Dr. Meera Patel',
      'hospital': 'Tata Memorial Hospital',
      'location': 'Mumbai, Maharashtra',
    },
    // Add more doctors as needed
  ];

  @override
  Widget build(BuildContext context) {
    final filteredSpecialties = _specialties.where((specialty) {
      final searchQuery = _searchQuery.toLowerCase();
      return specialty['specialty']!.toLowerCase().contains(searchQuery) ||
          specialty['doctorName']!.toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors'),
        backgroundColor: const Color.fromARGB(255, 20, 97, 11),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _searchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredSpecialties.length,
                itemBuilder: (context, index) {
                  return _doctorCard(
                    context,
                    filteredSpecialties[index]['specialty']!,
                    filteredSpecialties[index]['doctorName']!,
                    filteredSpecialties[index]['hospital']!,
                    filteredSpecialties[index]['location']!,
                    'assets/male_doctor.jpg', // Ensure you have images named 'doctor_1.png', 'doctor_2.png', etc.
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search by specialty or doctor name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
      ),
    );
  }

  Widget _doctorCard(BuildContext context, String specialty, String doctorName, String hospital, String location, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(specialty, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () => _navigateToDoctorInfoPage(context, doctorName, specialty, hospital, location, imagePath),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('View Details', style: TextStyle(color: Colors.blue)),
                        Icon(Icons.arrow_forward, color: Colors.blue),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDoctorInfoPage(BuildContext context, String doctorName, String specialty, String hospital, String location, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorInfoPage(
          doctorName: doctorName,
          specialty: specialty,
          hospital: hospital,
          location: location,
          imagePath: imagePath,
        ),
      ),
    );
  }
}
