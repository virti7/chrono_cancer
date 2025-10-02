// doctor_profile_app.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Doctor Profile",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
          centerTitle: true,
        ),
      ),
      home: const DoctorProfilePage(),
    );
  }
}

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final String doctorName = "Dr. Emily Carter";
  final String specialty = "Oncologist";
  final String hospital = "Sunrise Medical Center";
  final String profileImage =
      "https://images.unsplash.com/photo-1607746882042-944635dfe10e"; // sample doctor pic
  final double rating = 4.8;
  final String bio =
      "Dr. Emily Carter is a board-certified oncologist with 12+ years of experience. She specializes in breast and lung cancers, and is passionate about patient-centered care and research in oncology treatments.";

  final List<String> services = [
    "Chemotherapy",
    "Radiation Therapy",
    "Cancer Screening",
    "Immunotherapy",
  ];

  final List<String> patients = [
    "John Doe - Breast Cancer",
    "Maria Smith - Lung Cancer",
    "Alex Johnson - Prostate Cancer",
  ];

  final List<String> schedule = [
    "Mon - 9:00 AM to 2:00 PM",
    "Wed - 11:00 AM to 4:00 PM",
    "Fri - 10:00 AM to 1:00 PM",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(profileImage),
        ),
        const SizedBox(height: 12),
        Text(
          doctorName,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        Text(
          specialty,
          style: const TextStyle(fontSize: 16, color: Colors.deepPurple),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FontAwesomeIcons.hospital, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            Text(hospital, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text("$rating / 5.0",
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("About",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(bio, style: const TextStyle(fontSize: 15, height: 1.4)),
          const SizedBox(height: 20),
          const Text("Services",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: services
                .map((service) => Chip(
                      label: Text(service),
                      backgroundColor: Colors.deepPurple.withOpacity(0.1),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(patients[index]),
            subtitle: const Text("Ongoing treatment"),
            trailing: IconButton(
              icon: const Icon(Icons.chat, color: Colors.deepPurple),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Chat with ${patients[index]}")),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildScheduleTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.deepPurple),
            title: Text(schedule[index]),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildHeader(),
          const SizedBox(height: 20),
          TabBar(
            controller: _tabController,
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.deepPurple,
            tabs: const [
              Tab(text: "About"),
              Tab(text: "Patients"),
              Tab(text: "Schedule"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAboutTab(),
                _buildPatientsTab(),
                _buildScheduleTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple.withOpacity(0.8),
        icon: const Icon(Icons.edit),
        label: const Text("Edit Profile"),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Edit Profile clicked!")),
          );
        },
      ),
    );
  }
}
