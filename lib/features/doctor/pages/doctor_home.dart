import 'package:chronocancer_ai/features/doctor/pages/doctor_profile_page.dart';
import 'package:chronocancer_ai/features/patient/pages/patient_home.dart';
import 'package:flutter/material.dart';
import 'package:chronocancer_ai/features/doctor/pages/analytics_dashboard_page.dart';
import 'package:chronocancer_ai/features/doctor/pages/prescription_page.dart';
import 'package:chronocancer_ai/features/doctor/pages/risk_queue_page.dart';
import 'package:chronocancer_ai/data/appointment_store.dart';
// import 'package:chronocancer_ai/core/models/' as models;
// import 'package:fl_chart/fl_chart.dart'; // Uncomment if you use charts

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

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomePage(), // Home tab
      HealthAnalyticsScreen(), // Analytics tab
      PrescriptionPage(), // Prescription tab
      DoctorProfilePage(), // Placeholder Profile tab
    ];
  }

  // Dummy data for Patient List
  final List<Map<String, dynamic>> _patients = [
    {
      'name': 'Sarah Johnson',
      'id': '#1',
      'type': 'Type 2 Diabetes',
      'riskScore': 78,
      'lastVisit': '1/15/2024',
      'avatarColor': Colors.deepOrangeAccent,
    },
    {
      'name': 'John Doe',
      'id': '#2',
      'type': 'Hypertension',
      'riskScore': 65,
      'lastVisit': '1/10/2024',
      'avatarColor': Colors.lightBlueAccent,
    },
    {
      'name': 'Emily White',
      'id': '#3',
      'type': 'Asthma',
      'riskScore': 50,
      'lastVisit': '1/05/2024',
      'avatarColor': Colors.greenAccent,
    },
    {
      'name': 'Michael Brown',
      'id': '#4',
      'type': 'Obesity',
      'riskScore': 85,
      'lastVisit': '1/20/2024',
      'avatarColor': Colors.purpleAccent,
    },
  ];

  // // Dummy data for Upcoming Appointments
  // final List<Map<String, dynamic>> _upcomingAppointments = [
  //   {
  //     'patientName': 'Sarah Johnson',
  //     'time': '10:00 AM',
  //     'type': 'Follow-up',
  //     'avatarColor': Colors.deepOrangeAccent,
  //   },
  //   {
  //     'patientName': 'David Lee',
  //     'time': '11:30 AM',
  //     'type': 'New Patient',
  //     'avatarColor': Colors.tealAccent,
  //   },
  //   {
  //     'patientName': 'Jessica Chen',
  //     'time': '02:00 PM',
  //     'type': 'Consultation',
  //     'avatarColor': Colors.pinkAccent,
  //   },
  // ];

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
          ..._patients.map((patient) => _buildPatientListItem(patient)).toList(),
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
            _buildQuickActionItem(Icons.person_add_alt_1, 'Add Patient', primaryBlue, () {}),
            _buildQuickActionItem(Icons.calendar_today_outlined, 'Calendar', orangeAccent, () {}),
            _buildQuickActionItem(Icons.message_outlined, 'Messages', darkGreen, () {}),
            _buildQuickActionItem(Icons.analytics_outlined, 'Reports', purpleAccent, () {}),
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
    return Container(
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

Widget _buildAppointmentCardFromModel(BookedAppointment appointment) {
  return Container(
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
              backgroundColor: appointment.avatarColor,
              child: Text(
                appointment.patientName[0],
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                appointment.patientName,
                style: const TextStyle(
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
          appointment.time,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryBlue),
        ),
        const SizedBox(height: 5),
        Text(
          appointment.purpose,
          style: TextStyle(fontSize: 12, color: greyText),
        ),
      ],
    ),
  );
}


Widget _buildUpcomingAppointmentsSection() {
  final appointments = AppointmentStore().appointments; // get from store
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
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return _buildAppointmentCardFromModel(appointment);
          },
        ),
      ),
    ],
  );
}


  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    return Container(
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
            appointment['type'],
            style: TextStyle(
              fontSize: 12,
              color: greyText,
            ),
          ),
        ],
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
        Icon(Icons.sort, color: greyText),
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
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: greyText),
          hintText: 'Search patients...',
          hintStyle: TextStyle(color: greyText),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.black87),
      ),
    );
  }

  Widget _buildPatientListItem(Map<String, dynamic> patient) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: patient['avatarColor'] ?? Colors.blueGrey,
                    child: Text(
                      patient['name'][0],
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Patient ID: ${patient['id']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: greyText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(Icons.more_horiz, color: greyText),
            ],
          ),
          const SizedBox(height: 15),
          Divider(color: Colors.grey.shade300, height: 1),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildInfoChip(Icons.medical_services_outlined, patient['type'], tealAccent, tealAccent),
              const SizedBox(width: 10),
              _buildInfoChip(Icons.warning_amber, 'Risk Score: ${patient['riskScore']}%', orangeAccent, orangeAccent),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Last visit: ${patient['lastVisit']}',
            style: TextStyle(fontSize: 12, color: greyText),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton('View Timeline', primaryBlue, lightBlue, () {}),
              _buildActionButton('Quick Consult', darkGreen, lightGreen, () {}),
              _buildActionButton('AI Suggestions', orangeAccent, yellowAccent.withOpacity(0.5), () {}),
            ],
          ),
        ],
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
