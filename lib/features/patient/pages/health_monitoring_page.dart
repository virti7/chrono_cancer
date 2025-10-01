import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const HealthMonitoringPage(),
    );
  }
}

class HealthMonitoringPage extends StatefulWidget {
  const HealthMonitoringPage({Key? key}) : super(key: key);

  @override
  State<HealthMonitoringPage> createState() => _HealthMonitoringPageState();
}

class _HealthMonitoringPageState extends State<HealthMonitoringPage>
    with SingleTickerProviderStateMixin {
  double _harmonyScore = 75.0;
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Map<String, String>> _medications = [
    {
      'name': 'Metformin',
      'prescribed': '2023-12-01',
      'until': '2024-06-01'
    },
    {
      'name': 'Lisinopril',
      'prescribed': '2024-01-15',
      'until': '2024-07-15'
    },
    {
      'name': 'Atorvastatin',
      'prescribed': '2023-11-20',
      'until': '2024-05-20'
    },
    {
      'name': 'Vitamin D',
      'prescribed': '2024-02-01',
      'until': '2024-08-01'
    },
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: _harmonyScore).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    )..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: "Analytics"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Family"),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital), label: "Doctor"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Health Overview
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Health Overview',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHarmonyScoreCircle(),
                    const SizedBox(height: 24),
                    const Text(
                      'Quick Overview',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildQuickOverviewCards(),
                    const SizedBox(height: 24),
                    const Text(
                      'Medication Tracker',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMedicationTracker(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// New circular Harmony Score
  Widget _buildHarmonyScoreCircle() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 220,
            width: 220,
            child: CircularProgressIndicator(
              value: _animation.value / 100,
              strokeWidth: 14,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(
                _animation.value < 40
                    ? Colors.redAccent
                    : _animation.value < 70
                        ? Colors.amber
                        : Colors.green,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${_animation.value.toInt()}%",
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const Text(
                "Harmony Score",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// Quick Overview Section
  Widget _buildQuickOverviewCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = (constraints.maxWidth ~/ 170).clamp(1, 2);
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9, // FIX: More vertical space, no overflow
          children: [
            _buildVitalCard(
              'Blood Pressure',
              '120/80 mmHg',
              'Normal',
              Colors.teal.shade100,
              Icons.favorite_outline,
            ),
            _buildVitalCard(
              'Glucose',
              '95 mg/dL',
              'Stable',
              Colors.purple.shade100,
              Icons.bloodtype_outlined,
            ),
            _buildVitalCard(
              'Cholesterol',
              '180 mg/dL',
              'Healthy',
              Colors.green.shade100,
              Icons.local_hospital_outlined,
            ),
            _buildVitalCard(
              'Heart Rate',
              '72 bpm',
              'Optimal',
              Colors.orange.shade100,
              Icons.monitor_heart_outlined,
            ),
          ],
        );
      },
    );
  }

  Widget _buildVitalCard(
      String title, String value, String status, Color color, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: color.withOpacity(0.5),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(icon, size: 32, color: Colors.teal.shade900),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.teal.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Medication Tracker
  Widget _buildMedicationTracker() {
    return Column(
      children: _medications.map((med) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ListTile(
            leading: const Icon(Icons.medication_outlined, color: Colors.teal),
            title: Text(
              med['name']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              "Prescribed: ${med['prescribed']} \nUntil: ${med['until']}",
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        );
      }).toList(),
    );
  }
}