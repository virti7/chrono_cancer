import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ------------------ Patient & RiskLevel ------------------
class Patient {
  final String name;
  final int age;
  final String condition;
  final int riskScore;
  final DateTime lastVisit;
  final RiskLevel riskLevel;

  Patient({
    required this.name,
    required this.age,
    required this.condition,
    required this.riskScore,
    required this.lastVisit,
    required this.riskLevel,
  });
}

enum RiskLevel { high, medium, low }

extension RiskLevelExtension on RiskLevel {
  Color get baseColor {
    switch (this) {
      case RiskLevel.high:
        return Colors.red;
      case RiskLevel.medium:
        return Colors.amber;
      case RiskLevel.low:
        return Colors.green;
    }
  }

  Color get lightBackground {
    switch (this) {
      case RiskLevel.high:
        return const Color(0xFFFFEBEE); // Light red
      case RiskLevel.medium:
        return const Color(0xFFFFF8E1); // Light yellow
      case RiskLevel.low:
        return const Color(0xFFE8F5E9); // Light green
    }
  }

  String get displayName {
    switch (this) {
      case RiskLevel.high:
        return 'High Risk';
      case RiskLevel.medium:
        return 'Medium Risk';
      case RiskLevel.low:
        return 'Low Risk';
    }
  }
}

// ------------------ RiskQueueScreen ------------------
class RiskQueueScreen extends StatefulWidget {
  const RiskQueueScreen({super.key});

  @override
  State<RiskQueueScreen> createState() => _RiskQueueScreenState();
}

class _RiskQueueScreenState extends State<RiskQueueScreen> {
  RiskLevel? _selectedFilter;
  int _selectedNavIndex = 2; // Default to Risk Queue

  final List<Patient> _patients = [
    Patient(
        name: 'Alice Johnson',
        age: 68,
        condition: 'Hypertension',
        riskScore: 85,
        lastVisit: DateTime(2023, 10, 15),
        riskLevel: RiskLevel.high),
    Patient(
        name: 'Bob Williams',
        age: 72,
        condition: 'Diabetes Type 2',
        riskScore: 78,
        lastVisit: DateTime(2023, 11, 01),
        riskLevel: RiskLevel.high),
    Patient(
        name: 'Charlie Brown',
        age: 55,
        condition: 'Asthma',
        riskScore: 42,
        lastVisit: DateTime(2023, 12, 05),
        riskLevel: RiskLevel.medium),
    Patient(
        name: 'Diana Prince',
        age: 45,
        condition: 'Migraines',
        riskScore: 25,
        lastVisit: DateTime(2024, 01, 20),
        riskLevel: RiskLevel.low),
    Patient(
        name: 'Eve Adams',
        age: 60,
        condition: 'High Cholesterol',
        riskScore: 65,
        lastVisit: DateTime(2023, 09, 22),
        riskLevel: RiskLevel.medium),
    Patient(
        name: 'Frank White',
        age: 30,
        condition: 'Seasonal Allergies',
        riskScore: 15,
        lastVisit: DateTime(2024, 02, 10),
        riskLevel: RiskLevel.low),
    Patient(
        name: 'Grace Taylor',
        age: 80,
        condition: 'Congestive Heart Failure',
        riskScore: 92,
        lastVisit: DateTime(2023, 08, 01),
        riskLevel: RiskLevel.high),
  ];

  List<Patient> get _filteredPatients {
    if (_selectedFilter == null) {
      return List.from(_patients)
        ..sort((a, b) => b.riskScore.compareTo(a.riskScore));
    }
    return _patients
        .where((patient) => patient.riskLevel == _selectedFilter)
        .toList()
      ..sort((a, b) => b.riskScore.compareTo(a.riskScore));
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedNavIndex = index;
      // Add navigation logic here if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      bottomNavigationBar: _buildBottomNavBar(),
      body: CustomScrollView(
        slivers: [
          // ----------------- Title + Search -----------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0)
                  .copyWith(top: 40.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Risk Queue',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, size: 28),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Search pressed')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // ----------------- Filter Chips -----------------
          SliverToBoxAdapter(child: _buildFilterBar()),
          // ----------------- Patient List -----------------
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final patient = _filteredPatients[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _PatientRiskCard(patient: patient),
                  );
                },
                childCount: _filteredPatients.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: RiskLevel.values.map((level) {
          final isSelected = _selectedFilter == level;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(
                  level.displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black54,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = selected ? level : null;
                  });
                },
                selectedColor: level.baseColor,
                backgroundColor: level.lightBackground,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedNavIndex,
      onTap: _onNavBarTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.indigo,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Risk Queue'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Patient Detail'),
      ],
    );
  }
}

// ------------------ Patient Card ------------------
class _PatientRiskCard extends StatelessWidget {
  final Patient patient;
  const _PatientRiskCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: patient.riskLevel.lightBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name + Risk Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  patient.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: patient.riskLevel.baseColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${patient.riskScore}%',
                    style: TextStyle(
                      color: patient.riskLevel.baseColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${patient.age} yrs • ${patient.condition}',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            Text(
              'Last Visit: ${patient.lastVisit.day}/${patient.lastVisit.month}/${patient.lastVisit.year}',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ Main App ------------------
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Risk Queue',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      home: const RiskQueueScreen(),
    );
  }
}