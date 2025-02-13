import 'package:aarogyasaathi/Dashboard_Pages/Patient/AboutUsPage.dart';
import 'package:aarogyasaathi/Dashboard_Pages/Patient/BMI.dart';
import 'package:aarogyasaathi/Dashboard_Pages/Patient/DoctorPage.dart';
import 'package:aarogyasaathi/Dashboard_Pages/Patient/HelpPage.dart';
import 'package:aarogyasaathi/Dashboard_Pages/Patient/MyProfilePage.dart';
import 'package:aarogyasaathi/Dashboard_Pages/appointment_manager.dart';
import 'package:aarogyasaathi/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:aarogyasaathi/healthassesment.dart';
import 'package:aarogyasaathi/Dashboard_Pages/Patient/PatientPage.dart';

class HomePage extends StatefulWidget {
  final User? user;
  final String username;
  const HomePage({super.key, required this.user, required this.username});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Map<String, String>> _sliderItems = [
    {
      'image': 'assets/Appointment.jpeg',
      'route': '/doctor',
    },
    {
      'image': 'assets/Fitness.jpeg',
      'route': '/bmi',
    },
    {
      'image': 'assets/Chat.jpeg',
      'route': '/chatbot',
    },
  ];

  void _showAppointmentDetails() async {
    final appointments = await AppointmentManager().getAppointments();
    print("Fetched appointments: $appointments"); // Debug print

    if (appointments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No appointment details available')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Appointment Details'),
          content: SingleChildScrollView( // Use SingleChildScrollView if there are many appointments
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: appointments.map((appointment) {
                return Text(
                  'Appointment with ${appointment['doctorName']} on ${appointment['date']} at ${appointment['time']}',
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed(
          '/login'); // Navigate to the login page
    } catch (e) {
      // Handle logout error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  void _showPatientPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PatientPage(), // Navigate to PatientPage
      ),
    );
  }

  String getGreeting() {
    final hour = DateTime
        .now()
        .hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  int? selectedProductIndex;

  Widget _buildProductCard(String title, String imagePath, int index) {
    return GestureDetector(
      onTapDown: (_) {
        // When the user touches down, update the selected index
        setState(() {
          selectedProductIndex = index;
        });
      },
      onTapUp: (_) {
        // When the user lifts the touch, revert the selected index
        setState(() {
          selectedProductIndex = null;
        });
      },
      child: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Animated text sliding up on hover
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: selectedProductIndex == index ? 0 : -50,
            // Slide up when selected
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String userName = "Start your healthcare journey"; // Replace with the user name from registration

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome ${widget.username}',
          style: const TextStyle(
            fontSize: 23,
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 20, 97, 11),
        foregroundColor: Colors.white,
        elevation: 20,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showAppointmentDetails,
          ),
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: _showPatientPage,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 97, 11),
              ),
              child: Text(
                'Dashboard Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
                      HomePage(user: user, username: "Sid")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_outlined),
              title: const Text('Doctor Page'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const DoctorPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('BMI'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const BMI()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HelpPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Us'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: _logout, // Call logout method
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greyish Section with curved background
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Profile Picture
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                              'assets/aarogya.png'), // Placeholder or user-uploaded image
                        ),
                        const SizedBox(width: 10),
                        // Greeting and User Name
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getGreeting(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              userName,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Bell Icon with Hover Effect
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          // Action when bell icon is clicked
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.notifications, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Greeting Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'How are you feeling today?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 3 Buttons for Appointment, Fitness, Profile
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/doctor');
                      },
                      child: const Text('Appointment'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/bmi');
                      },
                      child: const Text('Fitness'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: const Text('Profile'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40), // More space before next section
              // Greyish Background fades to white
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Our Services" Text
                    const Text(
                      'Our Services',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Carousel Slider
                    CarouselSlider.builder(
                      itemCount: _sliderItems.length,
                      itemBuilder: (context, index, realIndex) {
                        final item = _sliderItems[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, item['route']!);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: AssetImage(item['image']!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 200,
                        viewportFraction: 1.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                      ),
                    ),
                    const SizedBox(height: 40), // Spacing before next section
                    // Monsoon Essentials Section
                    const Text(
                      'Monsoon Essentials',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 2x2 Grid for Monsoon Essentials Products
                    GridView.count(
                      shrinkWrap: true,
                      // Ensures the grid fits within the scrollable content
                      crossAxisCount: 2,
                      // 2 items per row
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      // Disable grid scroll as part of the whole page scroll
                      children: [
                        _buildProductCard('Vicks', 'assets/product1.webp', 0),
                        _buildProductCard(
                            'Koflet', 'assets/product2.webp', 1),
                        _buildProductCard(
                            'Odomos', 'assets/product3.webp', 2),
                        _buildProductCard(
                            'Tablets', 'assets/Lopox.jpg', 3),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Placeholder for the Carousel Image
                    // Single Image Display
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                            const AboutUsPage()),
                        );
                      },
                      child: Container(
                        width: double.infinity, // Make it responsive
                        height: 200, // Set height as per your requirement
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/about.jpeg'),
                            // Ensure this asset exists
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(
                              10), // Optional: Add border radius for styling
                        ),
                      ),
                    ),
                    const SizedBox(height: 40), // Spacing before next section
                    // Travel Essentials Section
                    const Text(
                      'Travel Essentials',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 2x2 Grid for Travel Essentials Products
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildProductCard(
                            'First Aid Kit', 'assets/firstaid.webp', 4),
                        _buildProductCard(
                            'Sanitiser', 'assets/sanitiser.webp', 5),
                        _buildProductCard(
                            'Travel Sickness', 'assets/TravelSickness.jpg', 6),
                        _buildProductCard(
                            'Wet Wipes', 'assets/WetWipes.webp', 7),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Healthcare Thought of the Day Section
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          '"The greatest wealth is health." - Virgil',
                          style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    // Another Travel Essentials Section
                    const Text(
                      'Personal Care',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 2x2 Grid for More Travel Essentials Products
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildProductCard(
                            'Moisturizer', 'assets/mosturizer.webp', 8),
                        _buildProductCard(
                            'Face Wash', 'assets/facewash.webp', 9),
                        _buildProductCard(
                            'Shampoo', 'assets/shampoo.jpg', 10),
                        _buildProductCard(
                            'Body Soap', 'assets/soap.jpg', 11),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Carousel Image Section

                    // Appointment Reminder Image with Overlay Text
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/reminder.jpeg'),
                          // Change this to your actual asset
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(
                            10), // Optional: Add border radius for styling
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          color: Colors.black54,
                          padding: const EdgeInsets.symmetric(vertical: 10,
                              horizontal: 20),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Upcoming Appointment',
                                style: TextStyle(color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Time: 2:30 PM, Sep 28, 2024',
                                // Example time, replace dynamically
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Winter Warmness',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildProductCard(
                            'Lip Balm', 'assets/lipbalm.webp', 12),
                        _buildProductCard(
                            'Foot Warmer', 'assets/footwarmer.jpg', 13),
                        _buildProductCard(
                            'Cough Syrup', 'assets/CoughSyrup.webp', 14),
                        _buildProductCard(
                            'Hot Packs', 'assets/HotPacks.jpg', 15),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Wellness Tips Section
                    const Text(
                      'Wellness Tips',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Dynamic Wellness Tips Slider
                    CarouselSlider(
                      items: [
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Drink plenty of water daily.',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Exercise regularly for a healthy heart.',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                        height: 100,
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Extra spacing at bottom
              // Image Container
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/records.jpeg'), // Use your image
                    fit: BoxFit.contain,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

// Add some space between the image and the button
              const SizedBox(height: 10),

// Add Records Button placed below the image
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.black),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HealthAssessment()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      'Add Records',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

