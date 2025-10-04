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
  int gender = 0; // 0 for Male, 1 for Female, 2 for Other
  int height = 170; // cm
  int weight = 70; // kg
  double? bmi;

  @override
  void initState() {
    super.initState();
    final patient = context.read<PatientData>();
    _nameController = TextEditingController(text: patient.fullName ?? '');
    _phoneController = TextEditingController(text: patient.phoneNumber ?? '');
    _emailController = TextEditingController(text: patient.email ?? '');
    _addressController = TextEditingController(text: patient.address ?? '');
    _emergencyController =
        TextEditingController(text: patient.emergencyContact ?? '');
    age = patient.age;
    gender = patient.gender;
    height = patient.height;
    weight = patient.weight;
    _calculateBmi();
  }

  void _calculateBmi() {
    if (height > 0) {
      bmi = weight / ((height / 100) * (height / 100));
    } else {
      bmi = 0.0; // Avoid division by zero
    }
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
      patient.calculateBmi(); // Ensure BMI is calculated in patient data

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
          SnackBar(
            content: Text(
              'Failed to save data: $e',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F5F9),
      appBar: AppBar(
        automaticallyImplyLeading: false, // 🔹 Disable default back button
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade600,
                Colors.indigo.shade400,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade200.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          'Basic Profile',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Text(
                  'Patient Onboarding',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        children: [
          _buildProgressBar(1, 6),
          const SizedBox(height: 30),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildSectionCard(
                  title: 'Personal Information',
                  icon: Icons.person_outline_rounded,
                  children: [
                    _buildTextField(_nameController, 'Full Name', Icons.person),
                    const SizedBox(height: 20),
                    _buildSlider('Age', 18, 100, age, (val) {
                      setState(() => age = val.toInt());
                    }),
                    const SizedBox(height: 20),
                    _buildGenderSelector(),
                    const SizedBox(height: 20),
                    _buildSlider('Height (cm)', 120, 220, height, (val) {
                      setState(() {
                        height = val.toInt();
                        _calculateBmi();
                      });
                    }),
                    const SizedBox(height: 20),
                    _buildSlider('Weight (kg)', 30, 150, weight, (val) {
                      setState(() {
                        weight = val.toInt();
                        _calculateBmi();
                      });
                    }),
                    const SizedBox(height: 20),
                    _buildBmiDisplay(),
                  ],
                ),
                const SizedBox(height: 30),
                _buildSectionCard(
                  title: 'Contact Details',
                  icon: Icons.contact_phone_outlined,
                  children: [
                    _buildTextField(
                        _phoneController, 'Phone Number', Icons.phone),
                    const SizedBox(height: 20),
                    _buildTextField(
                        _emailController, 'Email (Optional)', Icons.email),
                    const SizedBox(height: 20),
                    _buildTextField(_addressController, 'Address',
                        Icons.location_on_outlined),
                    const SizedBox(height: 20),
                    _buildTextField(_emergencyController, 'Emergency Contact',
                        Icons.health_and_safety_outlined),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          _buildNextButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue.shade700, size: 28),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const Divider(height: 30, thickness: 1, color: Color(0xFFE0E6EE)),
          ...children,
        ],
      ),
    );
  }

  Widget _buildProgressBar(int step, int total) {
    return Column(
      children: [
        Text(
          'Progress: $step of $total steps',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.indigo.shade700,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: step / total,
            backgroundColor: const Color(0xFFD6E0E6),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade400),
            minHeight: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Icon(icon, color: Colors.blue.shade400, size: 22),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 40),
        filled: true,
        fillColor: const Color(0xFFF5F9FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
      validator: (val) =>
          val == null || val.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildSlider(
      String label, double min, double max, int value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $value',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.blue.shade500,
            inactiveTrackColor: Colors.blue.shade100,
            thumbColor: Colors.blue.shade700,
            overlayColor: Colors.blue.shade100.withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            trackHeight: 6.0,
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: Colors.blue.shade700,
            valueIndicatorTextStyle: const TextStyle(color: Colors.white),
          ),
          child: Slider(
            min: min,
            max: max,
            value: value.toDouble(),
            divisions: (max - min).toInt(),
            onChanged: onChanged,
            label: value.toString(),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F9FC),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: Row(
                children: [
                  _buildGenderSegment('Male', 0, constraints),
                  _buildGenderSegment('Female', 1, constraints),
                  _buildGenderSegment('Other', 2, constraints),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGenderSegment(String label, int val, BoxConstraints constraints) {
    final selected = gender == val;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => gender = val),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: selected ? Colors.blue.shade600 : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.blue.shade300.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              color: selected ? Colors.white : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBmiDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade200, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.accessibility_new_rounded,
              color: Colors.blue.shade700, size: 24),
          const SizedBox(width: 10),
          Text(
            'Current BMI: ${bmi!.toStringAsFixed(1)}',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [Colors.green.shade500, Colors.teal.shade500],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade300.withOpacity(0.6),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _saveAndNext,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white, size: 24),
                const SizedBox(width: 10),
                const Text(
                  'Next Step',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
