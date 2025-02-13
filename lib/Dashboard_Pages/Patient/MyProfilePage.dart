import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _selectedGender;

  bool _isLoading = false;
  bool _isEditing = false; // Flag to track editing mode
  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // Fetch user profile from Firestore
  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently logged in.')),
        );
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user_profiles') // Use new collection name
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _fullNameController.text = data['fullName'] ?? '';
          _ageController.text = data['age']?.toString() ?? '';
          _phoneNumberController.text = data['phoneNumber'] ?? '';
          _addressController.text = data['address'] ?? '';
          _selectedGender = data['gender'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserProfile() async {
    if (!_formKey.currentState!.validate()) {
      return; // Invalid input
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently logged in.')),
        );
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }

      // Use set to create/update the user's document in Firestore
      await FirebaseFirestore.instance.collection('user_profiles').doc(user.uid).set({
        'fullName': _fullNameController.text.trim(),
        'age': int.parse(_ageController.text.trim()),
        'phoneNumber': _phoneNumberController.text.trim(),
        'address': _addressController.text.trim(),
        'gender': _selectedGender,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _isEditing = false; // Reset editing state after saving
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    _fullNameController.dispose();
    _ageController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color.fromARGB(255, 20, 97, 11),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = true; // Enter edit mode
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Details
            if (!_isEditing) ...[
              _buildProfileDetail('Full Name', _fullNameController.text),
              const SizedBox(height: 16),
              _buildProfileDetail('Age', _ageController.text),
              const SizedBox(height: 16),
              _buildProfileDetail('Phone Number', _phoneNumberController.text),
              const SizedBox(height: 16),
              _buildProfileDetail('Address', _addressController.text),
              const SizedBox(height: 16),
              _buildProfileDetail('Gender', _selectedGender ?? 'Not specified'),
              const SizedBox(height: 24),
            ],

            // Editable Form Fields
            if (_isEditing) ...[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Full Name
                    _buildTextField(
                      controller: _fullNameController,
                      label: 'Full Name',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Full Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Age
                    _buildTextField(
                      controller: _ageController,
                      label: 'Age',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Age is required';
                        }
                        if (int.tryParse(value.trim()) == null) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone Number
                    _buildTextField(
                      controller: _phoneNumberController,
                      label: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone Number is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Address
                    _buildTextField(
                      controller: _addressController,
                      label: 'Address',
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Address is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Gender
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                      items: _genders
                          .map((gender) => DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Gender is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    ElevatedButton(
                      onPressed: _updateUserProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 20, 97, 11),
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int? maxLines,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
