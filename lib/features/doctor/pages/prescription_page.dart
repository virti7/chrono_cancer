import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define a consistent color palette for the app
const Color primaryColor = Color(0xFF4CAF50); // Green
const Color accentColor = Color(0xFF8BC34A); // Light Green
const Color backgroundColor = Color(0xFFF0F2F5); // Light Grey
const Color cardColor = Colors.white;
const Color textColor = Color(0xFF333333); // Dark Grey
const Color lightTextColor = Color(0xFF777777); // Medium Grey

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
        textTheme: GoogleFonts.poppinsTextTheme(),
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
  // Dummy data for prescriptions
  final List<Map<String, dynamic>> _prescriptions = [
    {
      'patientName': 'Alice Smith',
      'age': 35,
      'date': '2023-10-26',
      'medications': [
        {'name': 'Amoxicillin', 'dosage': '500mg, 2 times a day'},
        {'name': 'Ibuprofen', 'dosage': '200mg, as needed'},
      ],
      'notes': 'Take with food to avoid stomach upset.',
    },
    {
      'patientName': 'Bob Johnson',
      'age': 52,
      'date': '2023-10-25',
      'medications': [
        {'name': 'Lisinopril', 'dosage': '10mg, once daily'},
      ],
      'notes': 'Monitor blood pressure regularly.',
    },
    {
      'patientName': 'Charlie Brown',
      'age': 28,
      'date': '2023-10-24',
      'medications': [
        {'name': 'Prednisone', 'dosage': '10mg, once daily for 5 days'},
        {'name': 'Cetirizine', 'dosage': '10mg, once daily'},
      ],
      'notes': 'For allergic reaction. Taper Prednisone as directed.',
    },
    {
      'patientName': 'Diana Prince',
      'age': 41,
      'date': '2023-10-23',
      'medications': [
        {'name': 'Metformin', 'dosage': '500mg, 2 times a day'},
      ],
      'notes': 'For diabetes management. Advised diet control.',
    },
    {
      'patientName': 'Eve Adams',
      'age': 60,
      'date': '2023-10-22',
      'medications': [
        {'name': 'Atorvastatin', 'dosage': '20mg, once daily'},
        {'name': 'Aspirin', 'dosage': '81mg, once daily'},
      ],
      'notes': 'For cholesterol and cardiovascular health.',
    },
  ];

  List<Map<String, dynamic>> _filteredPrescriptions = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredPrescriptions = _prescriptions;
    _searchController.addListener(_filterPrescriptions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  void _addNewPrescription() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Add New Prescription button pressed!'),
        backgroundColor: primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Prescription',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search patient or medication...',
                prefixIcon: const Icon(Icons.search, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: cardColor,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
              style: GoogleFonts.poppins(color: textColor),
            ),
          ),
          Expanded(
            child: _filteredPrescriptions.isEmpty
                ? Center(
                    child: Text(
                      'No prescriptions found.',
                      style: GoogleFonts.poppins(
                          fontSize: 18, color: lightTextColor),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _filteredPrescriptions.length,
                    itemBuilder: (context, index) {
                      final prescription = _filteredPrescriptions[index];
                      return PrescriptionCard(prescription: prescription);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewPrescription,
        backgroundColor: accentColor,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Add New Prescription',
      ),
    );
  }
}

class PrescriptionCard extends StatelessWidget {
  final Map<String, dynamic> prescription;

  const PrescriptionCard({Key? key, required this.prescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  prescription['patientName'],
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  'Age: ${prescription['age']}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: lightTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${prescription['date']}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: lightTextColor,
              ),
            ),
            const Divider(height: 20, color: Colors.grey),
            Text(
              'Medications:',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            ..._buildMedicationList(prescription['medications']),
            if (prescription['notes'] != null &&
                prescription['notes'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Notes:',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    prescription['notes'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: lightTextColor,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMedicationList(List<dynamic> medications) {
    return medications.map<Widget>((medication) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Text(
          '• ${medication['name']} (${medication['dosage']})',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: textColor,
          ),
        ),
      );
    }).toList();
  }
}