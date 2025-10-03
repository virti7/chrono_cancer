// patient_details_1.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronocancer_ai/features/patient/pages/patient_data.dart';
import 'package:chronocancer_ai/features/patient/pages/firestore_service.dart';
import 'patient_details_2.dart'; // Next page

class PatientDetails1 extends StatefulWidget {
  const PatientDetails1({super.key});

  @override
  State<PatientDetails1> createState() => _PatientDetails1State();
}

class _PatientDetails1State extends State<PatientDetails1> {
  final firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _emergencyController;

  int age = 18;
  int gender = 0;
  int height = 170;
  int weight = 70;
  double? bmi;

  @override
  void initState() {
    super.initState();
    final patient = context.read<PatientData>();
    _nameController = TextEditingController(text: patient.fullName ?? '');
    _phoneController = TextEditingController(text: patient.phoneNumber ?? '');
    _emailController = TextEditingController(text: patient.email ?? '');
    _addressController = TextEditingController(text: patient.address ?? '');
    _emergencyController = TextEditingController(text: patient.emergencyContact ?? '');
    age = patient.age;
    gender = patient.gender;
    height = patient.height;
    weight = patient.weight;
    _calculateBmi();
  }

  void _calculateBmi() {
    bmi = weight / ((height / 100) * (height / 100));
  }

  void _saveAndNext() async {
  if (_formKey.currentState!.validate()) {
    final patient = context.read<PatientData>();
    patient.fullName = _nameController.text;
    patient.phoneNumber = _phoneController.text;
    patient.email = _emailController.text;
    patient.address = _addressController.text;
    patient.emergencyContact = _emergencyController.text;
    patient.age = age;
    patient.gender = gender;
    patient.height = height;
    patient.weight = weight;
    patient.calculateBmi();

    // Prepare data Map for Firestore
    final data = {
      "full_name": patient.fullName,
      "age": patient.age,
      "gender": patient.gender == 0
          ? "Male"
          : patient.gender == 1
              ? "Female"
              : "Other",
      "height": patient.height,
      "weight": patient.weight,
      "bmi": patient.bmi,
      "phone_number": patient.phoneNumber,
      "email": patient.email,
      "address": patient.address,
      "emergency_contact": patient.emergencyContact,
    };

    try {
      // Save to Firestore under page1_basic_info
      await firestoreService.savePage1BasicInfo(data);

      // Navigate to next page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PatientDetails2()),
      );
    } catch (e) {
      // Show error if saving fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data: $e')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProgressBar(1, 6),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTextField(_nameController, 'Full Name', Icons.person),
                    const SizedBox(height: 16),
                    _buildSlider('Age', 18, 100, age, (val) {
                      setState(() => age = val.toInt());
                    }),
                    const SizedBox(height: 16),
                    _buildGenderSelector(),
                    const SizedBox(height: 16),
                    _buildSlider('Height (cm)', 120, 220, height, (val) {
                      setState(() {
                        height = val.toInt();
                        _calculateBmi();
                      });
                    }),
                    const SizedBox(height: 16),
                    _buildSlider('Weight (kg)', 30, 150, weight, (val) {
                      setState(() {
                        weight = val.toInt();
                        _calculateBmi();
                      });
                    }),
                    const SizedBox(height: 16),
                    Text('BMI: ${bmi!.toStringAsFixed(1)}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    _buildTextField(_phoneController, 'Phone Number', Icons.phone),
                    const SizedBox(height: 16),
                    _buildTextField(_emailController, 'Email (Optional)', Icons.email),
                    const SizedBox(height: 16),
                    _buildTextField(_addressController, 'Address', Icons.location_on),
                    const SizedBox(height: 16),
                    _buildTextField(_emergencyController, 'Emergency Contact', Icons.emergency),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _saveAndNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Next', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int step, int total) {
    return Column(
      children: [
        Text('Step $step of $total'),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: step / total),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (val) => val == null || val.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildSlider(String label, double min, double max, int value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $value'),
        Slider(min: min, max: max, value: value.toDouble(), onChanged: onChanged),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        _buildGenderButton('Male', 0),
        const SizedBox(width: 8),
        _buildGenderButton('Female', 1),
        const SizedBox(width: 8),
        _buildGenderButton('Other', 2),
      ],
    );
  }

  Widget _buildGenderButton(String label, int val) {
    final selected = gender == val;
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Colors.blue : Colors.grey.shade300,
        ),
        onPressed: () => setState(() => gender = val),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black)),
      ),
    );
  }
}