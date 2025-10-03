import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Assume this is the content of patient_history_page.dart
// You'll need to create this file or adapt its content.
// For this example, I'll provide a simple placeholder.
class PatientHistoryPage extends StatelessWidget {
  final Map<String, dynamic> patient;

  const PatientHistoryPage({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${patient['patientName']}\'s History', style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Patient Name:', patient['patientName']),
              _buildInfoRow('Age:', patient['age'].toString()),
              _buildInfoRow('Date of Last Visit:', patient['date']),
              const SizedBox(height: 20),
              Text(
                'Medications:',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 10),
              ..._buildMedicationList(patient['medications']),
              if (patient['notes'] != null && patient['notes'].isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  'Doctor\'s Notes:',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      patient['notes'],
                      style: GoogleFonts.poppins(fontSize: 16, color: lightTextColor),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Text(
                'Risk Score:',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 10),
              Text(
                '${patient['riskScore']} (Higher score indicates higher risk)',
                style: GoogleFonts.poppins(fontSize: 16, color: _getRiskColor(patient['riskScore']), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 16, color: lightTextColor),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMedicationList(List<dynamic> medications) {
    return medications.map((med) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.medical_services, size: 20, color: accentColor),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    med['name'],
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
                  ),
                  Text(
                    med['dosage'],
                    style: GoogleFonts.poppins(fontSize: 14, color: lightTextColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Color _getRiskColor(int riskScore) {
    switch (riskScore) {
      case 3: return Colors.red.shade700;
      case 2: return Colors.orange.shade700;
      default: return primaryColor;
    }
  }
}


// Define color palette - Adjusted for better contrast and vibrancy
const Color primaryColor = Color(0xFF2E7D32); // Darker Green
const Color accentColor = Color(0xFF66BB6A); // Medium Green
const Color backgroundColor = Color(0xFFF0F4F8); // Lighter, more modern background
const Color cardColor = Colors.white;
const Color textColor = Color(0xFF263238); // Very Dark Grey (almost black)
const Color lightTextColor = Color(0xFF546E7A); // Medium Dark Grey

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor App',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: textColor,
          displayColor: textColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor, // Button background color
            foregroundColor: Colors.white, // Button text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor, // Text button color
            textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none, // No border for a cleaner look
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: accentColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          fillColor: cardColor,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          hintStyle: GoogleFonts.poppins(color: lightTextColor.withOpacity(0.7)),
          labelStyle: GoogleFonts.poppins(color: primaryColor),
        ),
        cardTheme: CardThemeData(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: cardColor,
          margin: const EdgeInsets.only(bottom: 16.0),
        ),
      ),
      home: const PrescriptionPage(),
    );
  }
}

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({Key? key}) : super(key: key);

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  final List<Map<String, dynamic>> _prescriptions = [
    {
      'patientName': 'Alice Smith',
      'age': 35,
      'date': '2023-10-26',
      'medications': [
        {'name': 'Amoxicillin', 'dosage': '500mg, 2 times a day'},
        {'name': 'Ibuprofen', 'dosage': '200mg, as needed'},
      ],
      'notes': 'Take with food to avoid stomach upset. Patient reported mild fever and sore throat. Advised plenty of rest and fluids.',
      'riskScore': 2,
    },
    {
      'patientName': 'Bob Johnson',
      'age': 52,
      'date': '2023-10-25',
      'medications': [
        {'name': 'Lisinopril', 'dosage': '10mg, once daily'},
        {'name': 'Hydrochlorothiazide', 'dosage': '12.5mg, once daily'},
      ],
      'notes': 'Monitor blood pressure regularly. Advised lifestyle changes for hypertension management. Follow-up in 3 months.',
      'riskScore': 3,
    },
    {
      'patientName': 'Charlie Brown',
      'age': 28,
      'date': '2023-10-24',
      'medications': [
        {'name': 'Prednisone', 'dosage': '10mg, once daily for 5 days'},
        {'name': 'Cetirizine', 'dosage': '10mg, once daily'},
      ],
      'notes': 'For allergic reaction. Taper Prednisone as directed. Avoid known allergens.',
      'riskScore': 1,
    },
    {
      'patientName': 'Diana Prince',
      'age': 41,
      'date': '2023-10-23',
      'medications': [
        {'name': 'Metformin', 'dosage': '500mg, 2 times a day'},
        {'name': 'Glipizide', 'dosage': '5mg, once daily'},
      ],
      'notes': 'For diabetes management. Advised diet control and regular exercise. Monitor blood sugar levels.',
      'riskScore': 2,
    },
    {
      'patientName': 'Eve Adams',
      'age': 60,
      'date': '2023-10-22',
      'medications': [
        {'name': 'Atorvastatin', 'dosage': '20mg, once daily'},
        {'name': 'Aspirin', 'dosage': '81mg, once daily'},
      ],
      'notes': 'For cholesterol and cardiovascular health. Advised low-fat diet. Regular check-ups for lipid profile.',
      'riskScore': 3,
    },
  ];

  List<Map<String, dynamic>> _filteredPrescriptions = [];
  final TextEditingController _searchController = TextEditingController();

  String _sortBy = "risk"; // default sort by risk

  @override
void initState() {
  super.initState();
  _sortPrescriptions();
  _filterPrescriptions(); // instead of _filteredPrescriptions = List.from(_prescriptions)
  _searchController.addListener(_filterPrescriptions);
}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtering by search
  void _filterPrescriptions() {
  final query = _searchController.text.toLowerCase();
  setState(() {
    _filteredPrescriptions = _prescriptions.where((prescription) {
      final patientName = prescription['patientName'].toLowerCase();
      final medications = prescription['medications']
          .map((med) => med['name'].toLowerCase())
          .join(' ');
      return patientName.contains(query) || medications.contains(query);
    }).toList();
  });
}
  // Sorting logic
  void _sortPrescriptions() {
    setState(() {
      if (_sortBy == "risk") {
        _prescriptions.sort((a, b) => b['riskScore'].compareTo(a['riskScore']));
      } else if (_sortBy == "name") {
        _prescriptions.sort((a, b) =>
            a['patientName'].toLowerCase().compareTo(b['patientName'].toLowerCase()));
      } else if (_sortBy == "dateNewest") {
        _prescriptions.sort((a, b) => b['date'].compareTo(a['date']));
      } else if (_sortBy == "dateOldest") {
        _prescriptions.sort((a, b) => a['date'].compareTo(b['date']));
      }
// Do not reset filtered list here
    });
  }

  // Add new patient
  void _addNewPrescription() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController dateController = TextEditingController(text: DateTime.now().toString().split(' ')[0]);
    final TextEditingController notesController = TextEditingController();
    List<Map<String, TextEditingController>> medControllers = [
      {'name': TextEditingController(), 'dosage': TextEditingController()}
    ];
    int riskScore = 1; // Default risk score for new patient

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text("Add New Prescription", style: GoogleFonts.poppins(color: textColor)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: "Patient Name")),
                  const SizedBox(height: 10),
                  TextField(controller: ageController, decoration: const InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
                  const SizedBox(height: 10),
                  TextField(controller: dateController, decoration: const InputDecoration(labelText: "Date (YYYY-MM-DD)")),
                  const SizedBox(height: 10),
                  const Divider(height: 20, color: Colors.grey),
                  Text("Medications:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: textColor)),
                  ...medControllers.map((medCtrl) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: medCtrl['name'],
                              decoration: const InputDecoration(labelText: "Medicine Name"),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: medCtrl['dosage'],
                              decoration: const InputDecoration(labelText: "Dosage"),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  TextButton.icon(
                    onPressed: () {
                      setStateDialog(() {
                        medControllers.add({
                          'name': TextEditingController(),
                          'dosage': TextEditingController(),
                        });
                      });
                    },
                    icon: const Icon(Icons.add_circle, color: primaryColor),
                    label: Text("Add Medication", style: GoogleFonts.poppins(color: primaryColor)),
                  ),
                  const Divider(height: 20, color: Colors.grey),
                  TextField(controller: notesController, decoration: const InputDecoration(labelText: "Notes"), maxLines: 3),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    value: riskScore,
                    decoration: const InputDecoration(labelText: "Risk Score"),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Low Risk (1)')),
                      DropdownMenuItem(value: 2, child: Text('Medium Risk (2)')),
                      DropdownMenuItem(value: 3, child: Text('High Risk (3)')),
                    ],
                    onChanged: (value) {
                      setStateDialog(() {
                        riskScore = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.all(15),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _prescriptions.add({
                      'patientName': nameController.text.isNotEmpty ? nameController.text : 'New Patient',
                      'age': int.tryParse(ageController.text) ?? 30,
                      'date': dateController.text,
                      'medications': medControllers.where((medCtrl) => medCtrl['name']!.text.isNotEmpty).map((medCtrl) {
                        return {
                          'name': medCtrl['name']!.text,
                          'dosage': medCtrl['dosage']!.text,
                        };
                      }).toList(),
                      'notes': notesController.text,
                      'riskScore': riskScore,
                    });
                    _sortPrescriptions();
                    _filterPrescriptions();
                  });
                  Navigator.pop(context);
                },
                child: const Text("Add"),
              ),
            ],
          );
        },
      ),
    );
  }

  // Edit patient
  void _editPrescription(int index) {
    final patient = _filteredPrescriptions[index]; // Edit the filtered list item
    final originalIndex = _prescriptions.indexOf(patient); // Find original index for update

    final nameController = TextEditingController(text: patient['patientName']);
    final ageController = TextEditingController(text: patient['age'].toString());
    final dateController = TextEditingController(text: patient['date']);
    final notesController = TextEditingController(text: patient['notes']);
    int riskScore = patient['riskScore'];

    List<Map<String, TextEditingController>> medControllers =
        (patient['medications'] as List).map((med) {
      return {
        'name': TextEditingController(text: med['name']),
        'dosage': TextEditingController(text: med['dosage']),
      };
    }).toList();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text("Edit Prescription", style: GoogleFonts.poppins(color: textColor)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: "Patient Name")),
                  const SizedBox(height: 10),
                  TextField(controller: ageController, decoration: const InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
                  const SizedBox(height: 10),
                  TextField(controller: dateController, decoration: const InputDecoration(labelText: "Date (YYYY-MM-DD)")),
                  const SizedBox(height: 10),
                  const Divider(height: 20, color: Colors.grey),
                  Text("Medications:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: textColor)),
                  ...medControllers.map((medCtrl) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: medCtrl['name'],
                              decoration: const InputDecoration(labelText: "Medicine Name"),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: medCtrl['dosage'],
                              decoration: const InputDecoration(labelText: "Dosage"),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  TextButton.icon(
                    onPressed: () {
                      setStateDialog(() {
                        medControllers.add({
                          'name': TextEditingController(),
                          'dosage': TextEditingController(),
                        });
                      });
                    },
                    icon: const Icon(Icons.add_circle, color: primaryColor),
                    label: Text("Add Medication", style: GoogleFonts.poppins(color: primaryColor)),
                  ),
                  const Divider(height: 20, color: Colors.grey),
                  TextField(controller: notesController, decoration: const InputDecoration(labelText: "Notes"), maxLines: 3),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    value: riskScore,
                    decoration: const InputDecoration(labelText: "Risk Score"),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Low Risk (1)')),
                      DropdownMenuItem(value: 2, child: Text('Medium Risk (2)')),
                      DropdownMenuItem(value: 3, child: Text('High Risk (3)')),
                    ],
                    onChanged: (value) {
                      setStateDialog(() {
                        riskScore = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.all(15),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _prescriptions[originalIndex]['patientName'] = nameController.text;
                    _prescriptions[originalIndex]['age'] = int.tryParse(ageController.text) ?? patient['age'];
                    _prescriptions[originalIndex]['date'] = dateController.text;
                    _prescriptions[originalIndex]['notes'] = notesController.text;
                    _prescriptions[originalIndex]['riskScore'] = riskScore;
                    _prescriptions[originalIndex]['medications'] = medControllers.where((medCtrl) => medCtrl['name']!.text.isNotEmpty).map((medCtrl) {
                      return {
                        'name': medCtrl['name']!.text,
                        'dosage': medCtrl['dosage']!.text,
                      };
                    }).toList();
                  });
                  Navigator.pop(context);
                  _sortPrescriptions(); // Re-sort and filter after saving
                  _filterPrescriptions();
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );
  }

  // Delete patient
  void _deletePrescription(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Prescription", style: GoogleFonts.poppins(color: textColor)),
        content: Text("Are you sure you want to delete this prescription for ${_filteredPrescriptions[index]['patientName']}?", style: GoogleFonts.poppins(color: lightTextColor)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () {
              setState(() {
                final patientToRemove = _filteredPrescriptions[index];
                _prescriptions.removeWhere((p) => p == patientToRemove);
                _filteredPrescriptions = List.from(_prescriptions); // Rebuild filtered list
                _sortPrescriptions(); // Re-sort after deletion
              });
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Prescription Management", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.white),
            onSelected: (val) {
              setState(() {
                _sortBy = val;
                _sortPrescriptions();
                _filterPrescriptions(); // Re-filter after sorting
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: "risk", child: Text("Sort by Risk", style: GoogleFonts.poppins(color: textColor))),
              PopupMenuItem(value: "name", child: Text("Sort by Name", style: GoogleFonts.poppins(color: textColor))),
              PopupMenuItem(value: "dateNewest", child: Text("Newest Appointments", style: GoogleFonts.poppins(color: textColor))),
              PopupMenuItem(value: "dateOldest", child: Text("Oldest Appointments", style: GoogleFonts.poppins(color: textColor))),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search patient or medication...',
                prefixIcon: const Icon(Icons.search, color: primaryColor),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                filled: true,
                fillColor: cardColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
              ),
            ),
          ),
          // Patients list
          Expanded(
            child: _filteredPrescriptions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open, size: 80, color: lightTextColor.withOpacity(0.5)),
                        const SizedBox(height: 10),
                        Text(
                          'No prescriptions found.',
                          style: GoogleFonts.poppins(fontSize: 18, color: lightTextColor),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _filteredPrescriptions.length,
                    itemBuilder: (context, index) {
                      final prescription = _filteredPrescriptions[index];
                      return PrescriptionCard(
                        prescription: prescription,
                        onEdit: () => _editPrescription(index),
                        onDelete: () => _deletePrescription(index),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewPrescription,
        backgroundColor: accentColor,
        tooltip: 'Add New Prescription',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class PrescriptionCard extends StatelessWidget {
  final Map<String, dynamic> prescription;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PrescriptionCard({
    Key? key,
    required this.prescription,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  Color _getRiskColor(int riskScore) {
    switch (riskScore) {
      case 3: return Colors.red.shade700;
      case 2: return Colors.orange.shade700;
      default: return primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final riskColor = _getRiskColor(prescription['riskScore']);
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: riskColor.withOpacity(0.7), width: 2), // Softer border color
      ),
      elevation: 5,
      color: cardColor,
      child: InkWell( // Use InkWell for better tap feedback
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PatientHistoryPage(patient: prescription)),
          );
        },
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      prescription['patientName'],
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Risk: ${prescription['riskScore']}',
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: riskColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Age: ${prescription['age']} | Date: ${prescription['date']}',
                style: GoogleFonts.poppins(fontSize: 14, color: lightTextColor),
              ),
              Divider(height: 25, thickness: 1, color: Colors.grey.shade300),
              Text(
                'Medications:',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
              ),
              const SizedBox(height: 8),
              ...prescription['medications'].map<Widget>((med) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: accentColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${med['name']} (${med['dosage']})',
                        style: GoogleFonts.poppins(fontSize: 14, color: textColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )).toList(),
              if (prescription['notes'] != null && prescription['notes'].isNotEmpty) ...[
                const SizedBox(height: 15),
                Text(
                  'Notes:',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
                ),
                const SizedBox(height: 8),
                Text(
                  prescription['notes'],
                  style: GoogleFonts.poppins(fontSize: 14, color: lightTextColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: primaryColor.withOpacity(0.8)),
                    tooltip: 'Edit Prescription',
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.shade700),
                    tooltip: 'Delete Prescription',
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}