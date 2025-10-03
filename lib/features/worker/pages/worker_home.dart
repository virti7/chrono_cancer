import 'package:chronocancer_ai/features/doctor/pages/risk_queue_page.dart';
import 'package:chronocancer_ai/features/worker/pages/community_dashboard_page.dart';
import 'package:chronocancer_ai/features/worker/pages/training_hub_page.dart';
import 'package:flutter/material.dart';
import 'package:chronocancer_ai/features/worker/pages/patient_queue_page.dart';
import 'package:chronocancer_ai/features/patient/pages/schedule_checkup_page.dart';
import 'package:chronocancer_ai/features/worker/pages/report_upload_page.dart';

class AshaDashBoard extends StatefulWidget {
  const AshaDashBoard({Key? key}) : super(key: key);

  @override
  State<AshaDashBoard> createState() => _AshaWorkerDashboardState();
}

class _AshaWorkerDashboardState extends State<AshaDashBoard> {
  int _selectedIndex = 0; // Track selected tab

  // Map index to page
  final List<Widget> _pages = [
    const WorkerHomeContent(),
    const TrainingHubScreen(),
    const RiskQueueScreen(),
    const AshaWorkerDashboard(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.green[50],
            child: const Icon(Icons.favorite, color: Colors.green),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Asha Worker',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.menu, color: Colors.black),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[500],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Risk Queue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Community',
          ),
        ],
      ),
    );
  }
}

// ----------------- Worker Home Content -----------------
class WorkerHomeContent extends StatelessWidget {
  const WorkerHomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal[500],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome, Dr. Sarah',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Community Health Worker - Zone 7',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem(
                        icon: Icons.star,
                        value: '1',
                        label: 'Level Certified',
                        iconColor: Colors.white,
                        textColor: Colors.white,
                      ),
                      _buildStatItem(
                        icon: Icons.people,
                        value: '140',
                        label: 'Screenings',
                        iconColor: Colors.white,
                        textColor: Colors.white,
                      ),
                      _buildStatItem(
                        icon: Icons.error_outline,
                        value: '5',
                        label: 'Urgent Cases',
                        iconColor: Colors.lightBlueAccent,
                        textColor: Colors.white,
                        backgroundColor:
                            Colors.lightBlueAccent.withOpacity(0.2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Today's Queue
            _buildInfoCard(
              label: "Today's Queue",
              value: '23',
              icon: Icons.people_alt,
              iconColor: Colors.indigo,
            ),
            const SizedBox(height: 10),

            // Completed Today
            _buildInfoCard(
              label: 'Completed Today',
              value: '12',
              icon: Icons.check_circle_outline,
              iconColor: Colors.green,
            ),
            const SizedBox(height: 10),

            // Referrals Pending
            _buildInfoCard(
              label: 'Referrals Pending',
              value: '3',
              icon: Icons.watch_later_outlined,
              iconColor: Colors.orange,
            ),
            const SizedBox(height: 20),

            const Text(
              'Assistance for Rural Patients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            // AI Screening Tools
            _buildAIScreeningTool(
              context: context,
              icon: Icons.monitor_heart,
              title: 'Schedule Appointments',
              subtitle: 'Book hospital or doctor visits for patients',
              destination: const AppointmentBookingScreen(),
            ),
            const SizedBox(height: 10),
            _buildAIScreeningTool(
              context: context,
              icon: Icons.camera_alt_outlined,
              title: 'Upload Reports',
              subtitle: 'Submit medical records',
              destination: const UploadReportsPage(),
            ),
            const SizedBox(height: 10),
            _buildAIScreeningTool(
              context: context,
              icon: Icons.healing_outlined,
              title: 'Medication Reminders',
              subtitle: 'Set medicine alerts',
              destination: const MedicationRemindersPage(),
            ),
            const SizedBox(height: 10),
            _buildAIScreeningTool(
              context: context,
              icon: Icons.assignment_outlined,
              title: 'Emergency Support',
              subtitle: 'Quick connect to ambulance & helpline',
              destination: const EmergencySupportPage(),
            ),
            const SizedBox(height: 20),

            const Text(
              'Upcoming Campaigns',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            // Upcoming Campaigns
            _buildCampaignCard(
              icon: Icons.school_outlined,
              title: 'School Health Screening',
              location: 'Govt. Bharat Primary School, Sector 12',
              date: '2023-10-01',
              participants: '150',
              status: 'upcoming',
              statusColor: Colors.blue,
            ),
            const SizedBox(height: 10),
            _buildCampaignCard(
              icon: Icons.festival_outlined,
              title: 'Community Festival Camp',
              location: 'Village Square, Shikohpur',
              date: '2023-01-18',
              participants: '85',
              status: 'active',
              statusColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  // ----------------- Helper Widgets -----------------
  static Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
    required Color textColor,
    Color backgroundColor = Colors.transparent,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 5),
              Text(
                value,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  static Widget _buildInfoCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 15,
                backgroundColor: iconColor.withOpacity(0.1),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildAIScreeningTool({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget destination,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => destination),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.grey[700]),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildCampaignCard({
    required IconData icon,
    required String title,
    required String location,
    required String date,
    required String participants,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: Colors.grey[700]),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                participants,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Text(
                'participants',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------- Placeholder Pages -----------------
class UploadReportsPage extends StatelessWidget {
  const UploadReportsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Reports")),
      body: const Center(child: Text("Upload Reports Page (Coming Soon)")),
    );
  }
}

class MedicationRemindersPage extends StatelessWidget {
  const MedicationRemindersPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medication Reminders")),
      body: const Center(child: Text("Medication Reminders Page (Coming Soon)")),
    );
  }
}

class EmergencySupportPage extends StatelessWidget {
  const EmergencySupportPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency Support")),
      body: const Center(child: Text("Emergency Support Page (Coming Soon)")),
    );
  }
}
