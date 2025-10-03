import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Patient model
class Patient {
  final String name;
  final int age;
  final int harmonyScore;
  final String lastScreening;
  final List<String> conditions;
  final String riskLevel;
  final Color riskColor;

  Patient({
    required this.name,
    required this.age,
    required this.harmonyScore,
    required this.lastScreening,
    required this.conditions,
    required this.riskLevel,
    required this.riskColor,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asha Worker Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AshaWorkerDashboard(),
    );
  }
}

class AshaWorkerDashboard extends StatefulWidget {
  const AshaWorkerDashboard({super.key});

  @override
  State<AshaWorkerDashboard> createState() => _AshaWorkerDashboardState();
}

class _AshaWorkerDashboardState extends State<AshaWorkerDashboard> {
  String selectedSort = 'Harmony Score';

  // Sample patient list (keeps UI identical to your original)
  List<Patient> patients = [
    Patient(
      name: 'Rajesh Kumar',
      age: 45,
      harmonyScore: 85,
      lastScreening: '2025-01-10',
      conditions: ['Hypertension', 'Diabetes Risk'],
      riskLevel: 'HIGH RISK',
      riskColor: Colors.red,
    ),
    Patient(
      name: 'Priya Sharma',
      age: 32,
      harmonyScore: 65,
      lastScreening: '2025-01-12',
      conditions: ['Oral Health'],
      riskLevel: 'MEDIUM RISK',
      riskColor: Colors.orange,
    ),
    Patient(
      name: 'Amit Patel',
      age: 28,
      harmonyScore: 35,
      lastScreening: '2025-01-15',
      conditions: ['Regular Checkup'],
      riskLevel: 'LOW RISK',
      riskColor: Colors.green,
    ),
  ];

  void _sortPatients() {
    setState(() {
      if (selectedSort == 'Harmony Score') {
        patients.sort((a, b) => b.harmonyScore.compareTo(a.harmonyScore));
      } else if (selectedSort == 'Age') {
        patients.sort((a, b) => a.age.compareTo(b.age));
      } else if (selectedSort == 'Name') {
        patients.sort((a, b) => a.name.compareTo(b.name));
      }
    });
  }

  void _viewHistory(Patient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PatientHistoryPage(patient: patient),
      ),
    );
  }

  void _screenNow(Patient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScreeningPage(patient: patient),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure list is initially sorted according to selectedSort
    // (optional: you could call _sortPatients() in initState instead)
    // _sortPatients();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Patient Queue',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Sort by:',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal.shade200),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.teal.shade50,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSort,
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.teal),
                          style: const TextStyle(
                              color: Colors.teal, fontSize: 16),
                          items: <String>['Harmony Score', 'Age', 'Name']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue == null) return;
                            setState(() {
                              selectedSort = newValue;
                            });
                            _sortPatients();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Risk cards (kept const as they are static)
              Row(
                children: const [
                  Expanded(
                    child: RiskCard(
                      label: 'High Risk',
                      count: 5,
                      color: Colors.red,
                      icon: Icons.warning_amber,
                      bgColor: Color(0xFFFFEEEE),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: RiskCard(
                      label: 'Medium Risk',
                      count: 12,
                      color: Colors.orange,
                      icon: Icons.info_outline,
                      bgColor: Color(0xFFFFF8EE),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: RiskCard(
                      label: 'Low Risk',
                      count: 6,
                      color: Colors.green,
                      icon: Icons.check_circle_outline,
                      bgColor: Color(0xFFEEFFF0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Patient list (non-const instances)
              Column(
                children: patients.map((patient) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: PatientCard(
                      patient: patient,
                      onViewHistory: () => _viewHistory(patient),
                      onScreenNow: () => _screenNow(patient),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RiskCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;
  final Color bgColor;

  const RiskCard({
    super.key,
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, size: 20, color: color),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// NOTE: constructor is intentionally NOT const to avoid hot-reload removal errors
class PatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback onViewHistory;
  final VoidCallback onScreenNow;

  PatientCard({
    super.key,
    required this.patient,
    required this.onViewHistory,
    required this.onScreenNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: patient.riskColor.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Name and Risk Level
          Row(
            children: [
              Expanded(
                child: Text(
                  patient.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: patient.riskColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  patient.riskLevel,
                  style: TextStyle(
                    color: patient.riskColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Age: ${patient.age} years',
              style: TextStyle(color: Colors.grey[700], fontSize: 14)),
          Text('Harmony Score: ${patient.harmonyScore}',
              style: TextStyle(color: Colors.grey[700], fontSize: 14)),
          Text('Last Screening: ${patient.lastScreening}',
              style: TextStyle(color: Colors.grey[700], fontSize: 14)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: patient.conditions.map((condition) {
              return Chip(
                label: Text(condition),
                backgroundColor: Colors.teal.shade50,
                labelStyle:
                    const TextStyle(fontSize: 13, color: Colors.teal),
                side: BorderSide(color: Colors.teal.shade200),
              );
            }).toList(),
          ),
          const Divider(height: 30, thickness: 1, color: Colors.teal),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: onViewHistory,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  side: const BorderSide(color: Colors.teal, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 12),
                ),
                child: const Text('View History',
                    style: TextStyle(fontSize: 15)),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: onScreenNow,
                icon: const Icon(Icons.qr_code_scanner, size: 20),
                label:
                    const Text('Screen Now', style: TextStyle(fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Simple Patient History page (keeps UI minimal and informative)
class PatientHistoryPage extends StatelessWidget {
  final Patient patient;

  const PatientHistoryPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${patient.name} - History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Showing medical history for ${patient.name}.\n\n'
          'Age: ${patient.age}\n'
          'Conditions: ${patient.conditions.join(", ")}\n'
          'Last Screening: ${patient.lastScreening}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// Simple Screening page (placeholder for screening flow)
class ScreeningPage extends StatelessWidget {
  final Patient patient;

  const ScreeningPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screening - ${patient.name}'),
      ),
      body: Center(
        child: Text(
          'Starting screening process for ${patient.name}...',
          style: const TextStyle(fontSize: 18, color: Colors.teal),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
