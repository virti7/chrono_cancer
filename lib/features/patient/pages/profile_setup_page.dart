import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// ✅ Converted MyApp to StatefulWidget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Detail App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const PatientDetailPage(),
    );
  }
}

class PatientDetailPage extends StatefulWidget {
  const PatientDetailPage({super.key});

  @override
  State<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  String patientName = 'John Doe';
  int age = 32;
  String gender = 'Male';
  String currentCondition =
      'Fever, cough, and fatigue for 3 days. Experiencing mild headaches.';
  String medicalHistory =
      'Asthma (diagnosed childhood), seasonal allergies. No major surgeries.';
  String riskLevel = 'Moderate (due to pre-existing asthma during flu season)';

  // Notes
  final TextEditingController _noteController = TextEditingController();
  List<Map<String, dynamic>> _notes = [];

  // Appointments
  String lastAppointment = "2023-10-26 at 3:00 PM";
  String nextAppointment = "2023-11-10 at 11:30 AM";

  void _addNote() {
    if (_noteController.text.trim().isEmpty) return;
    setState(() {
      _notes.insert(0, {
        "text": _noteController.text.trim(),
        "time": DateTime.now(),
      });
      _noteController.clear();
    });
  }

  void _deleteNoteAt(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patientName),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPatientHeader(),
                  _buildInfoCard(
                    title: 'Current Condition',
                    content: currentCondition,
                    color: const Color(0xFF81C784),
                  ),
                  _buildInfoCard(
                    title: 'Medical History',
                    content: medicalHistory,
                    color: const Color(0xFF64B5F6),
                  ),
                  _buildInfoCard(
                    title: 'Risk Level',
                    content: riskLevel,
                    color: const Color(0xFFFFB74D),
                    trailingIcon: Icons.warning_amber,
                  ),
                  _buildAppointmentSection(),
                  _buildNotesSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  /// Patient Header
  Widget _buildPatientHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFFE3F2FD),
            child: Icon(Icons.person, size: 50, color: Color(0xFF64B5F6)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patientName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[800],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$age years old | $gender',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable Info Card
  Widget _buildInfoCard({
    required String title,
    required String content,
    required Color color,
    IconData? trailingIcon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 5,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                ),
              ),
              if (trailingIcon != null)
                Icon(trailingIcon, color: color, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[700],
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  /// Appointment Section
  Widget _buildAppointmentSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Appointments",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  )),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Last Appointment:",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16)),
              Flexible(
                child: Text(lastAppointment,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Upcoming Appointment:",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16)),
              Flexible(
                child: Text(nextAppointment,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Notes Section
  Widget _buildNotesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recent Notes",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  )),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              hintText: "Write a note...",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _addNote,
              icon: const Icon(Icons.add),
              label: const Text("Add Note"),
            ),
          ),
          const Divider(),
          ..._notes.asMap().entries.map((entry) {
            int index = entry.key;
            var note = entry.value;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(note["text"]),
              subtitle: Text(
                "Added on: ${note["time"].toString().substring(0, 16)}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteNoteAt(index),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// Bottom action buttons (Edit & Schedule)
  Widget _buildActionButtons() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text('Edit Details'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.calendar_today_outlined),
                label: const Text('Schedule'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
