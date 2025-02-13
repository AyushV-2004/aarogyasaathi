import 'package:aarogyasaathi/Dashboard_Pages/Patient/AboutUsPage.dart';
import 'package:aarogyasaathi/Dashboard_Pages/Patient/MyProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aarogyasaathi/Dashboard_Pages/Patient/DoctorPage.dart';
import 'package:aarogyasaathi/Dashboard_Pages/Patient/HelpPage.dart';
import 'package:aarogyasaathi/Dashboard_Pages/Patient/HomePage.dart';
import 'package:aarogyasaathi/Dashboard_Pages/Patient/BMI.dart'; // Import BMI page


User? user = FirebaseAuth.instance.currentUser;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});


  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final PageController _pageController = PageController();


  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/login'); // Navigate to the login page
    } catch (e) {
      // Handle logout error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                _pageController.jumpToPage(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_outlined),
              title: const Text('Doctor Page'),
              onTap: () {
                _pageController.jumpToPage(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('BMI'),
              onTap: () {
                _pageController.jumpToPage(2);
                Navigator.pop(context);
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
      body: PageView(
        controller: _pageController,
        children: [
          HomePage( user: FirebaseAuth.instance.currentUser,
              username: ""),
          const DoctorPage(),
          const BMI(), // Ensure this page is included
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(215, 255, 255, 255),
        buttonBackgroundColor: const Color.fromARGB(255, 20, 97, 11),
        color: const Color.fromARGB(255, 20, 97, 11),
        height: 65,
        items: const <Widget>[
          Icon(
            Icons.home_outlined,
            size: 35,
            color: Color.fromARGB(215, 255, 255, 255),
          ),
          Icon(
            Icons.group_outlined,
            size: 35,
            color: Color.fromARGB(215, 255, 255, 255),
          ),
          Icon(
            Icons.monitor_weight_outlined,
            size: 35,
            color: Color.fromARGB(215, 255, 255, 255),
          ),
          Icon(
            Icons.person_4_outlined,
            size: 35,
            color: Color.fromARGB(215, 255, 255, 255),
          ),
        ],
        onTap: (index) {
          _pageController.animateToPage(index,
              duration: const Duration(seconds: 1), curve: Curves.easeOut);
        },
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color.fromARGB(255, 20, 97, 11),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text(
                'My Profile',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyProfilePage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Help',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HelpPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'About Us',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Log Out',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

