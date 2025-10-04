import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// Import your existing pages
import 'patient_history_page.dart';
import 'calendar_page.dart';
// Import the new view_profile_doctor.dart
import 'view_profile_doctor_page.dart';
import 'package:chronocancer_ai/features/auth/pages/role_selection_page.dart';


// Add this at the very top of doctor_profile_page.dart (below imports)

class DoctorDetail {
  final String name;
  final String specialty;
  final String hospital;
  final String imageUrl;
  final double rating;
  final String bio;
  final List<String> services;

  const DoctorDetail({
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.imageUrl,
    required this.rating,
    required this.bio,
    required this.services,
  });
}


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
        // Define a primary color for consistency
        primaryColor: const Color(0xFF4A148C), // A deep, rich purple
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF8E24AA), // A slightly lighter purple for accents
          primary: const Color(0xFF4A148C),
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F2F5), // Light grey background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0, // Flat app bar for a modern look
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4, // More pronounced shadow for cards
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFE0B0FF).withOpacity(0.4), // Lighter, more subtle chip
          labelStyle: const TextStyle(color: Color(0xFF4A148C), fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A148C), // Use primary color for buttons
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF4A148C), // Use primary color for text buttons
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tileColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none, // No border for a cleaner look
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: TextStyle(color: Colors.grey[600]),
          floatingLabelBehavior: FloatingLabelBehavior.never, // Label inside the field
        )
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

  String doctorName = "Dr. Emily Carter";
  String specialty = "Oncologist";
  String hospital = "Sunrise Medical Center";
  String profileImage =
      "https://images.unsplash.com/photo-1607746882042-944635dfe10e";
  double rating = 4.8;

  String bio =
      "Dr. Emily Carter is a board-certified oncologist with 12+ years of experience. She specializes in breast and lung cancers, and is passionate about patient-centered care and research in oncology treatments.";

  List<String> services = [
    "Chemotherapy",
    "Radiation Therapy",
    "Cancer Screening",
    "Immunotherapy",
  ];

  /// Static patients list (only patients doctor is treating)
  final List<Map<String, String>> patients = [
    {"name": "John Doe", "condition": "Breast Cancer"},
    {"name": "Maria Smith", "condition": "Lung Cancer"},
    {"name": "Alex Johnson", "condition": "Prostate Cancer"},
  ];

  /// Static schedule with disease details
  final List<Map<String, dynamic>> schedule = [
    {
      "day": "Mon - 9:00 AM",
      "patient": "John Doe",
      "condition": "Breast Cancer",
      "risk": 70,
    },
    {
      "day": "Wed - 11:00 AM",
      "patient": "Maria Smith",
      "condition": "Lung Cancer",
      "risk": 85,
    },
    {
      "day": "Fri - 10:00 AM",
      "patient": "Alex Johnson",
      "condition": "Prostate Cancer",
      "risk": 60,
    },
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

  /// ---------- Header Section ----------
  Widget _buildHeader() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16), // Reduced padding here
        child: Column(
          children: [
            // Doctor Photo with subtle shadow (radius reduced)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10, // Reduced blur
                    spreadRadius: 1, // Reduced spread
                    offset: const Offset(0, 5), // Reduced offset
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 45, // Smaller avatar radius
                backgroundImage: NetworkImage(profileImage),
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 15), // Reduced spacing
            // Doctor Name with Gradient
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                doctorName,
                style: const TextStyle(
                  fontSize: 26, // Slightly smaller font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Color is overridden by ShaderMask
                ),
              ),
            ),
            const SizedBox(height: 8), // Reduced spacing
            // Specialty and Hospital - Made interactive
            InkWell(
              onTap: () {
                // TODO: Add navigation or action for specialty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Tapped on Specialty")),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0), // Reduced vertical padding
                child: Text(
                  specialty,
                  style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w600), // Smaller font size
                ),
              ),
            ),
            const SizedBox(height: 4), // Reduced spacing
            InkWell(
              onTap: () {
                // TODO: Add navigation or action for hospital
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Tapped on Hospital")),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0), // Reduced vertical padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.hospital,
                        size: 16, color: Colors.grey[600]), // Smaller icon
                    const SizedBox(width: 6), // Reduced spacing
                    Text(hospital, style: TextStyle(color: Colors.grey[600], fontSize: 14)), // Smaller font size
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10), // Reduced spacing
            const Divider(height: 1, thickness: 1, indent: 20, endIndent: 20),
            const SizedBox(height: 10), // Reduced spacing

            // Rating with AnimatedSwitcher for subtle interaction
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 24), // Smaller icon
                const SizedBox(width: 6), // Reduced spacing
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Text(
                    "$rating / 5.0",
                    key: ValueKey<double>(rating), // Key is important for AnimatedSwitcher
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16, // Smaller font size
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                TextButton.icon(
                  onPressed: () {
                    // Navigate to ViewProfileDoctorPage
                    final currentDoctor = DoctorDetail(
                      name: doctorName,
                      specialty: specialty,
                      hospital: hospital,
                      imageUrl: profileImage,
                      rating: rating,
                      bio: bio,
                      services: services,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                         builder: (context) => ViewProfileDoctorPage(doctor: currentDoctor),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Theme.of(context).primaryColor), // Smaller icon
                  label: Text("View Profile", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14)), // Smaller font size
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ---------- About Tab ----------
  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("About",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)), // Using theme for text style
          const SizedBox(height: 12),
          Text(bio, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87)),
          const SizedBox(height: 24), // More spacing
          Text("Services",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12, // Increased spacing between chips
            runSpacing: 10, // Increased run spacing
            children: services
                .map((service) => Chip(
                      label: Text(service),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  /// ---------- Patients Tab ----------
  Widget _buildPatientsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1), // Lighter background
              child: Icon(Icons.person, color: Theme.of(context).primaryColor, size: 28), // Icon in primary color
            ),
            title: Text(patient["name"]!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            subtitle: Text(patient["condition"]!, style: const TextStyle(color: Colors.grey)),
            trailing: Icon(Icons.arrow_forward_ios_rounded, // Rounded arrow icon
                color: Theme.of(context).primaryColor.withOpacity(0.7)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PatientHistoryPage(patient: patient),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// ---------- Schedule Tab ----------
  Widget _buildScheduleTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        final item = schedule[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(Icons.calendar_today_rounded, // Rounded calendar icon
                color: Theme.of(context).primaryColor, size: 28),
            title: Text("${item["day"]} - ${item["patient"]}",
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text("Condition: ${item["condition"]}", style: const TextStyle(color: Colors.grey)),
                Text("Risk Score: ${item["risk"]}/100",
                    style: TextStyle(
                      color: item["risk"] > 75 ? Colors.red.shade700 : (item["risk"] > 50 ? Colors.orange.shade700 : Colors.green.shade700),
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).primaryColor.withOpacity(0.7)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CalendarPage(appointments: schedule),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// ---------- Edit Profile Dialog ----------
  void _editProfileDialog() {
    final TextEditingController aboutController =
        TextEditingController(text: bio);
    final TextEditingController servicesController =
        TextEditingController(text: services.join(", "));

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // More rounded corners
        title: const Text("Edit Profile",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the dialog content wrap
            children: [
              TextField(
                controller: aboutController,
                maxLines: 5, // Allow more lines for bio
                minLines: 3,
                decoration: const InputDecoration(
                  labelText: "About",
                  hintText: "Enter a brief description of yourself...",
                ),
              ),
              const SizedBox(height: 16), // Increased spacing
              TextField(
                controller: servicesController,
                decoration: const InputDecoration(
                  labelText: "Services (comma separated)",
                  hintText: "e.g., Chemotherapy, Radiation Therapy",
                ),
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding for actions
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary, // Use a more vibrant color for save
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            icon: const Icon(Icons.save_rounded, color: Colors.white), // Rounded save icon
            label: const Text("Save",
                style: TextStyle(color: Colors.white)), // Text color is white from theme
            onPressed: () {
              setState(() {
                bio = aboutController.text;
                services = servicesController.text
                    .split(",")
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty) // Remove empty strings from services
                    .toList();
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  /// ---------- Main Build ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent), // Logout icon
            onPressed: () {
              // TODO: Implement actual logout logic (e.g., clear user session, navigate to login page)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logged out successfully!")),
              );
              // Example: Navigate to a login page (you'd replace this with your actual login route)
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(builder: (context) => LoginPage()),
              //   (Route<dynamic> route) => false,
              // );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding for the tab bar
            child: Card( // Wrap TabBar in a Card for consistent styling
              elevation: 2,
              margin: EdgeInsets.zero, // Remove default card margin
              child: TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: Theme.of(context).primaryColor,
                indicatorWeight: 4, // Thicker indicator
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
                indicatorSize: TabBarIndicatorSize.tab, // Indicator covers the full tab width
                tabs: const [
                  Tab(text: "About"),
                  Tab(text: "Patients"),
                  Tab(text: "Schedule"),
                ],
              ),
            ),
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
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.edit_rounded, color: Colors.white), // Rounded edit icon
        label: const Text("Edit Profile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: _editProfileDialog,
      ),
    );
  }
}