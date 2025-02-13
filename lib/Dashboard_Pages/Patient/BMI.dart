import 'dart:math';
import 'package:flutter/material.dart';
import 'package:item_count_number_button/item_count_number_button.dart';

class BMI extends StatefulWidget {
  const BMI({super.key});

  @override
  State<BMI> createState() => _BMIState();
}

class _BMIState extends State<BMI> {
  int _selectedGender = 0, _height = 170, _age = 23, _weight = 65;
  double _bmi = 0;

  final Color _backgroundColor = Colors.teal.shade800; // Background color
  final Color _activeColor = Colors.teal.shade300; // Active color for sliders and buttons

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI'),
        backgroundColor: const Color.fromARGB(255, 20, 97, 11),
      ),
      backgroundColor: _backgroundColor, // Set background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: _buildInputs()),
            const SizedBox(height: 20),
            _bmiResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputs() {
    return Column(
      children: [
        _genderSelector(),
        const SizedBox(height: 16),
        _heightInput(),
        const SizedBox(height: 16),
        _weightAndAgeInputRow(),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _bmi = _weight / pow(_height / 100, 2); // Calculate BMI
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _activeColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: const CircleBorder(), // Make button circular
          ),
          child: const Icon(
            Icons.calculate,
            color: Colors.white,
            size: 40, // Increase icon size
          ),
        ),
      ],
    );
  }

  Widget _genderSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _genderIcon(Icons.male, "Male", 0),
        _genderIcon(Icons.female, "Female", 1),
      ],
    );
  }

  Widget _genderIcon(IconData icon, String label, int gender) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: _selectedGender == gender ? _activeColor : Colors.grey.shade300,
            child: Icon(
              icon,
              color: _selectedGender == gender ? Colors.white : Colors.black,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              color: _selectedGender == gender ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _heightInput() {
    return Column(
      children: [
        const Text(
          "Height (cm)",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Slider(
          min: 0,
          max: 300,
          divisions: 300,
          value: _height.toDouble(),
          activeColor: _activeColor,
          inactiveColor: Colors.teal.shade100,
          onChanged: (value) {
            setState(() {
              _height = value.toInt();
            });
          },
        ),
        Text(
          "$_height cm",
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ],
    );
  }

  Widget _weightAndAgeInputRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _weightInput()),
        const SizedBox(width: 16), // Spacing between weight and age inputs
        Expanded(child: _ageInput()),
      ],
    );
  }

  Widget _weightInput() {
    return Column(
      children: [
        const Text(
          "Weight (kg)",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        ItemCount(
          buttonSizeHeight: 50, // Increased button size
          buttonSizeWidth: 70,
          initialValue: _weight,
          minValue: 50,
          maxValue: 350,
          onChanged: (value) {
            setState(() {
              _weight = value.toInt();
            });
          },
          decimalPlaces: 0,
          color: Colors.black12,
        ),
      ],
    );
  }

  Widget _ageInput() {
    return Column(
      children: [
        const Text(
          "Age",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        ItemCount(
          buttonSizeHeight: 50, // Increased button size
          buttonSizeWidth: 70,
          initialValue: _age,
          minValue: 1,
          maxValue: 100,
          onChanged: (value) {
            setState(() {
              _age = value.toInt();
            });
          },
          decimalPlaces: 0,
          color: Colors.black12, // Color for the buttons
        ),
      ],
    );
  }

  Widget _bmiResult() {
    String bmiCategory = _getBMICategory(_bmi); // Get BMI category
    Color resultColor;

    // Set color based on BMI category
    switch (bmiCategory) {
      case 'Underweight':
        resultColor = Colors.blue.shade400;
        break;
      case 'Normal':
        resultColor = Colors.green.shade400;
        break;
      case 'Overweight':
        resultColor = Colors.orange.shade400;
        break;
      case 'Obesity':
        resultColor = Colors.red.shade400;
        break;
      default:
        resultColor = Colors.white;
    }

    return Container(
      decoration: BoxDecoration(
        color: resultColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Your BMI: ${_bmi.toStringAsFixed(1)}",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            bmiCategory,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 24.9) {
      return 'Normal';
    } else if (bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }
}
