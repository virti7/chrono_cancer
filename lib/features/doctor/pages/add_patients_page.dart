import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Patient Model Class
class Patient {
  String name;
  String id;
  String disease;
  int risk;

  Patient({
    required this.name,
    required this.id,
    required this.disease,
    required this.risk,
  });

  // Convert a Patient object into a Map object
  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'disease': disease,
        'risk': risk,
      };

  // Convert a Map object into a Patient object
  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        name: json['name'],
        id: json['id'],
        disease: json['disease'],
        risk: json['risk'],
      );
}

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _diseaseController = TextEditingController();
  final TextEditingController _riskController = TextEditingController();

  List<Patient> _patients = [];
  int? _editingIndex; // To keep track of which patient is being edited

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _diseaseController.dispose();
    _riskController.dispose();
    super.dispose();
  }

  Future<void> _loadPatients() async {
    final prefs = await SharedPreferences.getInstance();
    final String? patientsString = prefs.getString('patients');
    if (patientsString != null) {
      setState(() {
        _patients = (json.decode(patientsString) as List)
            .map((e) => Patient.fromJson(e))
            .toList();
      });
    }
  }

  Future<void> _savePatients() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> patientsJson =
        _patients.map((p) => p.toJson()).toList();
    await prefs.setString('patients', json.encode(patientsJson));
  }

  void _addOrUpdatePatient() {
    if (_nameController.text.isEmpty ||
        _idController.text.isEmpty ||
        _diseaseController.text.isEmpty ||
        _riskController.text.isEmpty) {
      _showSnackBar("Please fill all fields.", Colors.red);
      return;
    }

    final int? riskScore = int.tryParse(_riskController.text);
    if (riskScore == null || riskScore < 0 || riskScore > 100) {
      _showSnackBar("Risk score must be a number between 0 and 100.", Colors.red);
      return;
    }

    final newPatient = Patient(
      name: _nameController.text,
      id: _idController.text,
      disease: _diseaseController.text,
      risk: riskScore,
    );

    setState(() {
      if (_editingIndex != null) {
        _patients[_editingIndex!] = newPatient; // Update existing patient
        _editingIndex = null;
        _showSnackBar("Patient updated successfully!", Colors.green);
      } else {
        _patients.add(newPatient); // Add new patient
        _showSnackBar("Patient added successfully!", Colors.green);
      }
    });
    _savePatients();

    _clearForm();
  }

  void _deletePatient(int index) {
    setState(() {
      _patients.removeAt(index);
    });
    _savePatients();
    _showSnackBar("Patient deleted.", Colors.orange);
  }

  void _editPatient(int index) {
    final patient = _patients[index];
    _nameController.text = patient.name;
    _idController.text = patient.id;
    _diseaseController.text = patient.disease;
    _riskController.text = patient.risk.toString();

    setState(() {
      _editingIndex = index; // Set the index of the patient being edited
    });
    // Scroll to the top to show the form
    // You might need a ScrollController for this in a real app
    // e.g., PrimaryScrollController.of(context).animateTo(...)
  }

  void _clearForm() {
    _nameController.clear();
    _idController.clear();
    _diseaseController.clear();
    _riskController.clear();
    setState(() {
      _editingIndex = null; // Exit editing mode
    });
  }

  Color _getRiskColor(int risk) {
    if (risk >= 75) return Colors.red.shade700;
    if (risk >= 50) return Colors.orange.shade700;
    if (risk >= 25) return Colors.yellow.shade700;
    return Colors.green.shade700;
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF42A5F5), // Light Blue
                Color(0xFF673AB7), // Deep Purple
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Patient Management",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientForm(),
            const SizedBox(height: 24),
            Text(
              "Current Patients (${_patients.length})",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 12),
            _patients.isEmpty
                ? _buildEmptyListMessage()
                : _buildPatientListView(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientForm() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              _editingIndex == null ? "Add New Patient" : "Edit Patient Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[700],
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
                _nameController, "Patient Name", Icons.person, TextInputType.text),
            const SizedBox(height: 16),
            _buildTextField(
                _idController, "Patient ID", Icons.badge, TextInputType.text),
            const SizedBox(height: 16),
            _buildTextField(_diseaseController, "Disease / Condition",
                Icons.local_hospital, TextInputType.text),
            const SizedBox(height: 16),
            _buildTextField(
                _riskController, "Risk Score (0-100%)", Icons.warning, TextInputType.number),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF673AB7), // Deep Purple
                    Color(0xFF42A5F5), // Light Blue
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: _addOrUpdatePatient,
                icon: Icon(
                  _editingIndex == null ? Icons.add_circle : Icons.save,
                  color: Colors.white,
                ),
                label: Text(
                  _editingIndex == null ? "Add Patient" : "Update Patient",
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Make button transparent to show gradient
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            if (_editingIndex != null) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: _clearForm,
                child: const Text(
                  "Cancel Edit",
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon, TextInputType keyboardType) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurple.shade400),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.blueGrey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.deepPurple.shade100, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.deepPurple.shade400, width: 2),
        ),
      ),
    );
  }

  Widget _buildEmptyListMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(Icons.sick_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 10),
            Text(
              "No patients added yet!",
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            Text(
              "Use the form above to add a new patient.",
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientListView() {
    return ListView.builder(
      shrinkWrap: true, // Important for nested list views in SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling of the inner list
      itemCount: _patients.length,
      itemBuilder: (context, index) {
        final patient = _patients[index];
        return Dismissible(
          key: Key(patient.id), // Unique key for Dismissible
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.delete_forever, color: Colors.white, size: 30),
          ),
          onDismissed: (direction) {
            _deletePatient(index);
          },
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border(
                  left: BorderSide(color: _getRiskColor(patient.risk), width: 8),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading: CircleAvatar(
                  backgroundColor: _getRiskColor(patient.risk).withOpacity(0.1),
                  radius: 28,
                  child: Text(
                    patient.name[0].toUpperCase(),
                    style: TextStyle(
                      color: _getRiskColor(patient.risk),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                title: Text(
                  patient.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ID: ${patient.id}", style: TextStyle(color: Colors.grey[700])),
                      Text("Disease: ${patient.disease}", style: TextStyle(color: Colors.grey[700])),
                      Text("Risk Score: ${patient.risk}%", style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.deepPurple, size: 24),
                  onPressed: () => _editPatient(index),
                ),
                onTap: () => _showPatientDetails(patient),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPatientDetails(Patient patient) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            patient.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("ID: ${patient.id}", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text("Disease: ${patient.disease}", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text("Risk Score: ", style: TextStyle(fontSize: 16)),
                    Text(
                      "${patient.risk}%",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getRiskColor(patient.risk),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close", style: TextStyle(color: Colors.deepPurple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}