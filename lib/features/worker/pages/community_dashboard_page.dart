import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border,
              color: Colors.green,
              size: 20,
            ),
          ),
        ),
        title: const Text(
          'Asha Worker Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with "Patient Queue" and Sort Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Patient Queue',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Text('Sort by:'),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSort,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: <String>['Harmony Score', 'Age', 'Name']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSort = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Risk Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Flexible(
                  child: RiskCard(
                    label: 'High Risk',
                    count: 5,
                    color: Colors.red,
                    icon: Icons.warning_amber,
                    bgColor: Color(0xFFFFEEEE),
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: RiskCard(
                    label: 'Medium Risk',
                    count: 12,
                    color: Colors.orange,
                    icon: Icons.info_outline,
                    bgColor: Color(0xFFFFF8EE),
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
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
            const SizedBox(height: 20),
            // Patient List
            Column(
              children: const [
                PatientCard(
                  name: 'Rajesh Kumar',
                  age: 45,
                  harmonyScore: 85,
                  lastScreening: '2025-01-10',
                  conditions: ['Hypertension', 'Diabetes Risk'],
                  riskLevel: 'HIGH RISK',
                  riskColor: Colors.red,
                ),
                SizedBox(height: 15),
                PatientCard(
                  name: 'Priya Sharma',
                  age: 32,
                  harmonyScore: 65,
                  lastScreening: '2025-01-12',
                  conditions: ['Oral Health'],
                  riskLevel: 'MEDIUM RISK',
                  riskColor: Colors.orange,
                ),
                SizedBox(height: 15),
                PatientCard(
                  name: 'Amit Patel',
                  age: 28,
                  harmonyScore: 35,
                  lastScreening: '2025-01-15',
                  conditions: ['Regular Checkup'],
                  riskLevel: 'LOW RISK',
                  riskColor: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Handle navigation
        },
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
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
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final String name;
  final int age;
  final int harmonyScore;
  final String lastScreening;
  final List<String> conditions;
  final String riskLevel;
  final Color riskColor;

  const PatientCard({
    super.key,
    required this.name,
    required this.age,
    required this.harmonyScore,
    required this.lastScreening,
    required this.conditions,
    required this.riskLevel,
    required this.riskColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: riskColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Name and Risk Level
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: riskColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  riskLevel,
                  style: TextStyle(
                    color: riskColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Age: $age years', style: TextStyle(color: Colors.grey[600])),
          Text('Harmony Score: $harmonyScore', style: TextStyle(color: Colors.grey[600])),
          Text('Last Screening: $lastScreening', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: conditions.map((condition) {
              return Chip(
                label: Text(condition),
                backgroundColor: Colors.grey[200],
                labelStyle: const TextStyle(fontSize: 12),
              );
            }).toList(),
          ),
          const Divider(height: 25, thickness: 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  side: const BorderSide(color: Colors.teal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('View History'),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.qr_code_scanner, size: 18),
                label: const Text('Screen Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}