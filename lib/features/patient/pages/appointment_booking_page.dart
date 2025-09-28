import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// You might need to add this dependency to your pubspec.yaml:
// table_calendar: ^3.0.9

class SchedulingPage extends StatefulWidget {
  const SchedulingPage({Key? key}) : super(key: key);

  @override
  State<SchedulingPage> createState() => _SchedulingPageState();
}

class _SchedulingPageState extends State<SchedulingPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final Map<DateTime, List<dynamic>> _events = {
    DateTime.utc(2024, 6, 10): ['Appointment with Dr. Elena'],
    DateTime.utc(2024, 6, 15): ['Follow-up with Nurse Sarah'],
    DateTime.utc(2024, 6, 20): ['Consultation with Dr. Marcus'],
  };

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Schedule & Appointments',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.blueAccent),
            onPressed: () {
              // Handle adding new appointment
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color(0xFFF0F4F8), // Light grey background
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2023, 1, 1),
                    lastDay: DateTime.utc(2025, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay; // update `_focusedDay` here as well
                      });
                    },
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    eventLoader: _getEventsForDay,
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: Color(0xFF4CAF50), // Green for events
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: TextStyle(color: Colors.red[600]),
                      holidayTextStyle: TextStyle(color: Colors.red[600]),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon: Icon(Icons.arrow_back_ios, color: Colors.black),
                      rightChevronIcon: Icon(Icons.arrow_forward_ios, color: Colors.black),
                    ),
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Appointments for ${_selectedDay != null ? '${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}' : 'Selected Day'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            _selectedDay != null && _getEventsForDay(_selectedDay!).isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _getEventsForDay(_selectedDay!).length,
                    itemBuilder: (context, index) {
                      return AppointmentCard(
                        appointmentTitle: _getEventsForDay(_selectedDay!)[index],
                        doctorName: 'Dr. Marcus Hieb', // Example doctor
                        time: '10:00 AM - 11:00 AM',
                        status: 'Confirmed',
                        color: Colors.blueAccent,
                      );
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                    child: Center(
                      child: Text(
                        _selectedDay != null
                            ? 'No appointments scheduled for this day.'
                            : 'Select a day to view appointments.',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Upcoming Appointments',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            AppointmentCard(
              appointmentTitle: 'Annual Check-up',
              doctorName: 'Dr. Sarah Johnson',
              time: 'Tomorrow, 9:00 AM - 10:00 AM',
              status: 'Confirmed',
              color: const Color(0xFF4CAF50), // Green for confirmed
            ),
            AppointmentCard(
              appointmentTitle: 'Cardiology Follow-up',
              doctorName: 'Dr. Elena Maria',
              time: 'June 25, 2:00 PM - 3:00 PM',
              status: 'Pending',
              color: Colors.orange, // Orange for pending
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'My Doctors',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: const [
                  DoctorAvatar(
                    doctorName: 'Dr. Marcus H.',
                    specialty: 'Cardiologist',
                    imageUrl: 'https://images.unsplash.com/photo-1612349317031-6415f36e4f1d?fit=crop&w=400&q=80',
                  ),
                  DoctorAvatar(
                    doctorName: 'Dr. Elena M.',
                    specialty: 'Neurologist',
                    imageUrl: 'https://images.unsplash.com/photo-1559839734-2b7194cb90ad?fit=crop&w=400&q=80',
                  ),
                  DoctorAvatar(
                    doctorName: 'Dr. Steve J.',
                    specialty: 'Oncologist',
                    imageUrl: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?fit=crop&w=400&q=80',
                  ),
                  DoctorAvatar(
                    doctorName: 'Dr. Sarah K.',
                    specialty: 'Pediatrician',
                    imageUrl: 'https://images.unsplash.com/photo-1579482591745-f095759160a2?fit=crop&w=400&q=80',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // Assuming this is the 'Appointments' tab
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String appointmentTitle;
  final String doctorName;
  final String time;
  final String status;
  final Color color;

  const AppointmentCard({
    Key? key,
    required this.appointmentTitle,
    required this.doctorName,
    required this.time,
    required this.status,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appointmentTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  doctorName,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  time,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: OutlinedButton(
                onPressed: () {
                  // Handle view details or reschedule
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blueAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorAvatar extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String imageUrl;

  const DoctorAvatar({
    Key? key,
    required this.doctorName,
    required this.specialty,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: Colors.blue.shade100,
          ),
          const SizedBox(height: 8),
          Text(
            doctorName,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            specialty,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}