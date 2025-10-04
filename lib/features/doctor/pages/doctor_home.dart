import 'package:chronocancer_ai/features/doctor/pages/doctor_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:chronocancer_ai/features/doctor/pages/analytics_dashboard_page.dart';
import 'package:chronocancer_ai/features/doctor/pages/prescription_page.dart';
import 'package:chronocancer_ai/features/doctor/pages/risk_queue_page.dart';

// New Page Imports
import 'package:chronocancer_ai/features/doctor/pages/add_patients_page.dart';
// import 'package:chronocancer_ai/features/doctor/pages/calendar_page.dart' as cal;
import 'package:chronocancer_ai/features/doctor/pages/reports_page.dart';
// import 'package:chronocancer_ai/features/doctor/pages/patient_history_page.dart' as history;
import 'package:chronocancer_ai/features/doctor/pages/calendar_page.dart';
import 'package:chronocancer_ai/features/doctor/pages/patient_history_page.dart' as history;


class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({Key? key}) : super(key: key);

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  // Define custom colors based on your design
  static const Color primaryBlue = Color(0xFF6B7BFC);
  static const Color lightBlue = Color(0xFFE0E5FF);
  static const Color lightGreen = Color(0xFFC8F6E6);
  static const Color darkGreen = Color(0xFF14B860);
  static const Color lightRed = Color(0xFFFFE0E0);
  static const Color darkRed = Color(0xFFD32F2F);
  static const Color greyText = Color(0xFF8A8A8A);
  static const Color cardColor = Color(0xFFF8F8F8); // A light grey for card backgrounds
  static const Color purpleAccent = Color(0xFFC062F8);
  static const Color orangeAccent = Color(0xFFF8A762);
  static const Color tealAccent = Color(0xFF62F8C0);
  static const Color yellowAccent = Color(0xFFF8E562);

  int _selectedIndex = 0; // For the bottom navigation bar

  // List of pages for bottom navigation
  late final List<Widget> _pages;

  // Search controller for patient list
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredPatients = [];


  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomePage(), // Home tab
      HealthAnalyticsScreen(), // Analytics tab
      PrescriptionPage(), // Prescription tab
      DoctorProfilePage(), // Placeholder Profile tab
    ];
    _filteredPatients = List.from(_patients);
    _searchController.addListener(_filterPatients); // Add listener for search
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPatients);
    _searchController.dispose();
    super.dispose();
  }

  void _filterPatients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPatients = _patients.where((patient) {
        return patient['name'].toLowerCase().contains(query) ||
               patient['id'].toLowerCase().contains(query);
      }).toList();
    });
  }

  // Dummy data for Patient List (Now including more details for history)
  final List<Map<String, dynamic>> _patients = [
    {
      'name': 'Sarah Johnson',
      'id': '#1',
      'type': 'Type 2 Diabetes',
      'riskScore': 78,
      'lastVisit': '1/15/2024',
      'avatarColor': Colors.deepOrangeAccent,
      'disease': 'Type 2 Diabetes',
      'medication': ['Metformin 500mg', 'Insulin Glargine'],
      'appointments': [
        {'date': '2024-01-15', 'type': 'Follow-up', 'notes': 'Reviewed blood sugar levels, adjusted insulin.'},
        {'date': '2023-11-20', 'type': 'Initial Consult', 'notes': 'Diagnosis confirmed, started Metformin.'},
      ],
      'reports': [
        {'date': '2024-01-10', 'type': 'Blood Test', 'summary': 'HbA1c 7.2%', 'file': 'report_sarah_jan.pdf'},
        {'date': '2023-11-15', 'type': 'Initial Screening', 'summary': 'Elevated blood glucose.', 'file': 'report_sarah_nov.pdf'},
      ],
      'timeline': [
        {'date': '2024-01-15', 'event': 'Appointment: Follow-up'},
        {'date': '2024-01-10', 'event': 'Report: Blood Test submitted'},
        {'date': '2023-11-20', 'event': 'Appointment: Initial Consult'},
        {'date': '2023-11-15', 'event': 'Report: Initial Screening submitted'},
      ]
    },
    {
      'name': 'John Doe',
      'id': '#2',
      'type': 'Hypertension',
      'riskScore': 65,
      'lastVisit': '1/10/2024',
      'avatarColor': Colors.lightBlueAccent,
      'disease': 'Essential Hypertension',
      'medication': ['Lisinopril 10mg', 'Hydrochlorothiazide 25mg'],
      'appointments': [
        {'date': '2024-01-10', 'type': 'Follow-up', 'notes': 'Blood pressure stable, no adverse effects.'},
        {'date': '2023-12-01', 'type': 'Initial Consult', 'notes': 'Diagnosed with hypertension, prescribed Lisinopril.'},
      ],
      'reports': [
        {'date': '2024-01-05', 'type': 'Blood Pressure Log', 'summary': 'Average BP 130/85', 'file': 'report_john_jan.pdf'},
        {'date': '2023-11-28', 'type': 'ECG', 'summary': 'Normal sinus rhythm', 'file': 'report_john_nov.pdf'},
      ],
      'timeline': [
        {'date': '2024-01-10', 'event': 'Appointment: Follow-up'},
        {'date': '2024-01-05', 'event': 'Report: BP Log submitted'},
        {'date': '2023-12-01', 'event': 'Appointment: Initial Consult'},
        {'date': '2023-11-28', 'event': 'Report: ECG submitted'},
      ]
    },
    {
      'name': 'Emily White',
      'id': '#3',
      'type': 'Asthma',
      'riskScore': 50,
      'lastVisit': '1/05/2024',
      'avatarColor': Colors.greenAccent,
      'disease': 'Persistent Asthma',
      'medication': ['Albuterol inhaler', 'Fluticasone propionate inhaler'],
      'appointments': [
        {'date': '2024-01-05', 'type': 'Annual Check-up', 'notes': 'Asthma well-controlled, no recent exacerbations.'},
        {'date': '2023-07-18', 'type': 'Follow-up', 'notes': 'Adjusted Fluticasone dosage.'},
      ],
      'reports': [
        {'date': '2024-01-03', 'type': 'Pulmonary Function Test', 'summary': 'FEV1 85% of predicted', 'file': 'report_emily_jan.pdf'},
        {'date': '2023-07-10', 'type': 'Spirometry', 'summary': 'Mild obstructive pattern', 'file': 'report_emily_jul.pdf'},
      ],
      'timeline': [
        {'date': '2024-01-05', 'event': 'Appointment: Annual Check-up'},
        {'date': '2024-01-03', 'event': 'Report: PFT submitted'},
        {'date': '2023-07-18', 'event': 'Appointment: Follow-up'},
        {'date': '2023-07-10', 'event': 'Report: Spirometry submitted'},
      ]
    },
    {
      'name': 'Michael Brown',
      'id': '#4',
      'type': 'Obesity',
      'riskScore': 85,
      'lastVisit': '1/20/2024',
      'avatarColor': Colors.purpleAccent,
      'disease': 'Obesity (BMI 35)',
      'medication': ['Orlistat 120mg'],
      'appointments': [
        {'date': '2024-01-20', 'type': 'Weight Management', 'notes': 'Discussed diet and exercise plan, weight loss of 2kg.'},
        {'date': '2023-10-25', 'type': 'Initial Consult', 'notes': 'Diagnosed, started Orlistat.'},
      ],
      'reports': [
        {'date': '2024-01-18', 'type': 'Body Composition Analysis', 'summary': 'Decreased body fat percentage', 'file': 'report_michael_jan.pdf'},
        {'date': '2023-10-20', 'type': 'Blood Panel', 'summary': 'Elevated cholesterol, normal glucose.', 'file': 'report_michael_oct.pdf'},
      ],
      'timeline': [
        {'date': '2024-01-20', 'event': 'Appointment: Weight Management'},
        {'date': '2024-01-18', 'event': 'Report: Body Composition Analysis submitted'},
        {'date': '2023-10-25', 'event': 'Appointment: Initial Consult'},
        {'date': '2023-10-20', 'event': 'Report: Blood Panel submitted'},
      ]
    },
     {
      'name': 'David Lee',
      'id': '#5',
      'type': 'Seasonal Allergies',
      'riskScore': 30,
      'lastVisit': '12/01/2023',
      'avatarColor': Colors.tealAccent,
      'disease': 'Allergic Rhinitis',
      'medication': ['Loratadine 10mg'],
      'appointments': [
        {'date': '2023-12-01', 'type': 'Initial Consult', 'notes': 'Discussed allergy symptoms and prescribed antihistamine.'},
      ],
      'reports': [
        {'date': '2023-11-25', 'type': 'Allergy Test', 'summary': 'Positive for pollen.', 'file': 'report_david_nov.pdf'},
      ],
      'timeline': [
        {'date': '2023-12-01', 'event': 'Appointment: Initial Consult'},
        {'date': '2023-11-25', 'event': 'Report: Allergy Test submitted'},
      ]
    },
    {
      'name': 'Sophia Garcia',
      'id': '#6',
      'type': 'Migraine',
      'riskScore': 55,
      'lastVisit': '02/05/2024',
      'avatarColor': Colors.pinkAccent,
      'disease': 'Chronic Migraine',
      'medication': ['Sumatriptan 50mg', 'Propranolol 20mg'],
      'appointments': [
        {'date': '2024-02-05', 'type': 'Follow-up', 'notes': 'Migraine frequency reduced with current medication.'},
        {'date': '2023-09-10', 'type': 'Initial Consult', 'notes': 'Diagnosed with chronic migraine, started Propranolol.'},
      ],
      'reports': [
        {'date': '2024-01-30', 'type': 'Migraine Diary', 'summary': 'Migraine days: 4/month.', 'file': 'report_sophia_jan.pdf'},
        {'date': '2023-09-01', 'type': 'Neurological Exam', 'summary': 'Normal findings.', 'file': 'report_sophia_sep.pdf'},
      ],
      'timeline': [
        {'date': '2024-02-05', 'event': 'Appointment: Follow-up'},
        {'date': '2024-01-30', 'event': 'Report: Migraine Diary submitted'},
        {'date': '2023-09-10', 'event': 'Appointment: Initial Consult'},
        {'date': '2023-09-01', 'event': 'Report: Neurological Exam submitted'},
      ]
    },
  ];

  // Dummy data for Upcoming Appointments
  final List<Map<String, dynamic>> _upcomingAppointments = [
    {
      'patientName': 'Sarah Johnson',
      'time': '10:00 AM',
      'date': '2024-03-10', // Added date
      'type': 'Follow-up',
      'avatarColor': Colors.deepOrangeAccent,
      'patientId': '#1', // Link to patient data
    },
    {
      'patientName': 'David Lee',
      'time': '11:30 AM',
      'date': '2024-03-10', // Added date
      'type': 'New Patient',
      'avatarColor': Colors.tealAccent,
      'patientId': '#5', // Example for a new patient in _patients list
    },
    {
      'patientName': 'Sophia Garcia', // Changed to Sophia Garcia who is in _patients list
      'time': '02:00 PM',
      'date': '2024-03-11', // Added date
      'type': 'Consultation',
      'avatarColor': Colors.pinkAccent,
      'patientId': '#6', // Link to patient data
    },
    {
      'patientName': 'Emily White',
      'time': '03:00 PM',
      'date': '2024-03-11', // Added date
      'type': 'Annual Check-up',
      'avatarColor': Colors.greenAccent,
      'patientId': '#3', // Link to patient data
    },
  ];

  
  // ----------------- Patient Card -----------------
  Widget _buildPatientListItem(Map<String, dynamic> patient) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => history.PatientHistoryPage(
              patient: patient,
              initialTabIndex: 0,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: patient['avatarColor'] ?? Colors.blue,
              child: Text(
                patient['name'][0],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient['name'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    patient['disease'] ?? "Unknown",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildInfoChip(Icons.local_hospital, "Risk: ${patient['riskScore']}%", Colors.red, Colors.redAccent),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.calendar_today, "Last Visit: ${patient['lastVisit']}", Colors.blue, Colors.blueAccent),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



// ------------------ Search Helper ------------------
String _searchQuery = "";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: lightBlue,
            child: Icon(Icons.person_outline, color: primaryBlue),
          ),
        ),
        title: const Text(
          'Doctor Home',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: greyText),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: greyText),
            onPressed: () {
              // Handle settings
            },
          ),
        ],
      ),
      // Display the selected page
body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: primaryBlue,
        unselectedItemColor: greyText,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Prescription',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ------------------- HOME PAGE CONTENT -------------------
  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreetingSection(),
          const SizedBox(height: 20),
          _buildQuickActions(),
          const SizedBox(height: 20),
          _buildTodaysConsultStats(),
          const SizedBox(height: 20),
          _buildUpcomingAppointmentsSection(),
          const SizedBox(height: 20),
          _buildHealthTrendsOverview(),
          const SizedBox(height: 20),
          _buildPatientListHeader(),
          const SizedBox(height: 10),
          _buildSearchBar(),
          const SizedBox(height: 15),
          // Dynamically build patient list items for the AI-Ranked section
          ..._filteredPatients.map((patient) => _buildPatientListItem(patient)).toList(), // Use filtered patients
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hello, Sarah!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'How are you feeling today?',
          style: TextStyle(
            fontSize: 16,
            color: greyText,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Phase 1.1: Add Patient button
           _buildQuickActionItem(Icons.person_add_alt_1, 'Add Patient', primaryBlue, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddPatientPage()));
            }),
            // Phase 1.2: Calendar button
           _buildQuickActionItem(Icons.calendar_today_outlined, 'Calendar', orangeAccent, () {
             Navigator.push(context, MaterialPageRoute(    builder: (context) => CalendarPage(appointments: _upcomingAppointments),
));
            }),
            // Phase 1.3: Messages icon and button removed
            // _buildQuickActionItem(Icons.message_outlined, 'Messages', darkGreen, () {}),
            // Phase 1.4: Reports button
            _buildQuickActionItem(Icons.analytics_outlined, 'Reports', purpleAccent, () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => ReportsPage(patients: _patients)));
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: greyText, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysConsultStats() {
    return GestureDetector(
      // Phase 2: Make Today's Consult Stats dynamic
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HealthAnalyticsScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Consult Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('12', 'Completed', primaryBlue, lightBlue),
                _buildStatItem('3', 'In Progress', orangeAccent, yellowAccent.withOpacity(0.5)),
                _buildStatItem('2', 'Scheduled', darkGreen, lightGreen),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label, Color color, Color bgColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            count,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: greyText,
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingAppointmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Appointments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Container(
        height: 135, // increase this
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _upcomingAppointments.length,
          itemBuilder: (context, index) {
            final appointment = _upcomingAppointments[index];
            return _buildAppointmentCard(appointment);
          },
        ),
      ),
      ],
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    // Find the patient details from _patients list using patientId
    final patientDetails = _patients.firstWhere(
      (p) => p['id'] == appointment['patientId'],
      orElse: () => {
        'name': appointment['patientName'],
        'id': appointment['patientId'],
        'disease': 'N/A',
        'medication': [],
        'appointments': [],
        'reports': [],
        'timeline': [],
        'riskScore': 0,
        'type': 'N/A',
        'lastVisit': 'N/A',
        'avatarColor': appointment['avatarColor']
      }, // Default if not found (e.g., new patient)
    );

    return GestureDetector(
      // Phase 3: Navigate to Patient History on tap
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
           builder: (context) => history.PatientHistoryPage(
  patient: patientDetails,
  initialTabIndex: 2,
),
          ),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: appointment['avatarColor'],
                  child: Text(
                    appointment['patientName'][0],
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    appointment['patientName'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              appointment['time'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              appointment['type'] + ' - ' + appointment['date'], // Display date
              style: TextStyle(
                fontSize: 12,
                color: greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthTrendsOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Patient Health Trends',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16.0),
          height: 180,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bar_chart, size: 50, color: greyText.withOpacity(0.5)),
                const SizedBox(height: 10),
                Text(
                  'Visual health data and trends will appear here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: greyText),
                ),
                Text(
                  '(e.g., Blood Pressure, Glucose levels over time)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: greyText.withOpacity(0.7)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientListHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'Patient List (AI-Ranked)',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      PopupMenuButton<String>(
        icon: Icon(Icons.sort, color: greyText),
        onSelected: (value) {
          setState(() {
            if (value == 'High Risk') {
              _filteredPatients.sort((a, b) => b['riskScore'].compareTo(a['riskScore']));
            } else if (value == 'Low Risk') {
              _filteredPatients.sort((a, b) => a['riskScore'].compareTo(b['riskScore']));
            } else if (value == 'Name') {
              _filteredPatients.sort((a, b) => a['name'].compareTo(b['name']));
            }
          });
        },
        itemBuilder: (context) => [
          PopupMenuItem(value: 'High Risk', child: Text('Sort by High Risk')),
          PopupMenuItem(value: 'Low Risk', child: Text('Sort by Low Risk')),
          PopupMenuItem(value: 'Name', child: Text('Sort by Name')),
        ],
      ),
    ],
  );
}

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchController, // Phase 4.1: Search bar controller
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: greyText),
          hintText: 'Search patients...',
          hintStyle: TextStyle(color: greyText),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.black87),
        onChanged: (value) {
          // _filterPatients is called by the listener already
        },
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color textColor, Color chipColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color textColor, Color bgColor, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            elevation: 0,
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}