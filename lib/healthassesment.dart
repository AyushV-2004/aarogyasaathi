import 'package:flutter/material.dart';

class HealthAssessment extends StatefulWidget {
  static const String healthAssessmentRoute = '/healthAssessment';

  const HealthAssessment({super.key});

  @override
  _HealthAssessmentState createState() => _HealthAssessmentState();
}

class _HealthAssessmentState extends State<HealthAssessment> {
  final List<Map<String, dynamic>> _questions = [
    {'question': 'Do you have diabetes?', 'type': 'yes_no'},
    {'question': 'How often do you exercise per week?', 'type': 'multiple', 'options': ['None', '1-2 days', '3-5 days', 'Daily']},
    {'question': 'Do you smoke?', 'type': 'yes_no'},
    {'question': 'How many hours of sleep do you get daily?', 'type': 'multiple', 'options': ['<5 hours', '5-7 hours', '7-9 hours', '>9 hours']},
    {'question': 'Do you consume alcohol?', 'type': 'yes_no'},
    {'question': 'How much water do you drink daily?', 'type': 'multiple', 'options': ['<1 liter', '1-2 liters', '2-3 liters', '>3 liters']},
    {'question': 'How often do you feel stressed?', 'type': 'multiple', 'options': ['Never', 'Rarely', 'Sometimes', 'Often']},
    {'question': 'Do you follow a healthy diet?', 'type': 'yes_no'},
    {'question': 'Do you have any chronic illnesses?', 'type': 'yes_no'},
    {'question': 'How would you rate your overall health?', 'type': 'multiple', 'options': ['Poor', 'Fair', 'Good', 'Excellent']},
  ];

  int _currentQuestionIndex = 0;
  final Map<int, dynamic> _answers = {};
  bool _isReportGenerated = false;
  String _healthReport = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Assessment'),
      ),
      body: _isReportGenerated
          ? _buildHealthReport()
          : _buildQuestionnaire(),
    );
  }

  Widget _buildQuestionnaire() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _questions[_currentQuestionIndex]['question'],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: _buildQuestionWidget(_questions[_currentQuestionIndex]),
        ),
        _buildNavigationButtons(),
        _buildProgressIndicator(),
      ],
    );
  }

  Widget _buildQuestionWidget(Map<String, dynamic> question) {
    if (question['type'] == 'yes_no') {
      return Column(
        children: [
          ListTile(
            title: const Text('Yes'),
            leading: Radio(
              value: 'Yes',
              groupValue: _answers[_currentQuestionIndex],
              onChanged: (value) {
                setState(() {
                  _answers[_currentQuestionIndex] = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('No'),
            leading: Radio(
              value: 'No',
              groupValue: _answers[_currentQuestionIndex],
              onChanged: (value) {
                setState(() {
                  _answers[_currentQuestionIndex] = value;
                });
              },
            ),
          ),
        ],
      );
    } else if (question['type'] == 'multiple') {
      return Column(
        children: question['options'].map<Widget>((option) {
          return ListTile(
            title: Text(option),
            leading: Radio(
              value: option,
              groupValue: _answers[_currentQuestionIndex],
              onChanged: (value) {
                setState(() {
                  _answers[_currentQuestionIndex] = value;
                });
              },
            ),
          );
        }).toList(),
      );
    }
    return Container();
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: _currentQuestionIndex > 0
                ? () {
              setState(() {
                _currentQuestionIndex--;
              });
            }
                : null,
            child: const Text('Previous'),
          ),
          ElevatedButton(
            onPressed: _currentQuestionIndex < _questions.length - 1
                ? () {
              setState(() {
                _currentQuestionIndex++;
              });
            }
                : () {
              _generateHealthReport();
            },
            child: _currentQuestionIndex < _questions.length - 1
                ? const Text('Next')
                : const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LinearProgressIndicator(
        value: (_currentQuestionIndex + 1) / _questions.length,
      ),
    );
  }

  void _generateHealthReport() {
    // Placeholder for report calculation logic.
    // You can add more advanced logic based on answers.
    String report = "Based on your responses, your health status is ";

    int score = 0;

    _answers.forEach((index, answer) {
      if (answer == 'Yes' || answer == 'Daily' || answer == 'Excellent') {
        score += 10;
      } else if (answer == 'No' || answer == 'None' || answer == 'Poor') {
        score -= 10;
      } else {
        score += 5;
      }
    });

    if (score >= 50) {
      report += "good. Keep it up!";
    } else if (score >= 0) {
      report += "fair. You should make some improvements.";
    } else {
      report += "poor. Consider seeing a healthcare professional.";
    }

    setState(() {
      _healthReport = report;
      _isReportGenerated = true;
    });
  }

  Widget _buildHealthReport() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Health Report",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              _healthReport,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Action to reset or navigate elsewhere
                setState(() {
                  _isReportGenerated = false;
                  _currentQuestionIndex = 0;
                  _answers.clear();
                });
              },
              child: const Text('Retake Assessment'),
            ),
          ],
        ),
      ),
    );
  }
}
