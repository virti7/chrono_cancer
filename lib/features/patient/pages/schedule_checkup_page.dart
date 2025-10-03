import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:chronocancer_ai/models.dart'; // Make sure this points to your models.dart

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({Key? key}) : super(key: key);

  @override
  _AppointmentBookingScreenState createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Doctor? _selectedDoctor;
  String? _selectedTime;
  TextEditingController _purposeController = TextEditingController();

  List<Doctor> doctors = [
    Doctor(
        id: 'd1',
        name: 'Dr. Emily White',
        specialty: 'General Physician',
        imageUrl:
            'https://cdn.pixabay.com/photo/2017/03/14/03/20/woman-2141808_1280.jpg'),
    Doctor(
        id: 'd2',
        name: 'Dr. David Lee',
        specialty: 'Pediatrician',
        imageUrl:
            'https://cdn.pixabay.com/photo/2021/01/29/18/14/man-5962002_1280.jpg'),
    Doctor(
        id: 'd3',
        name: 'Dr. Sarah Chen',
        specialty: 'Dermatologist',
        imageUrl:
            'https://cdn.pixabay.com/photo/2020/04/09/10/37/woman-5020155_1280.jpg'),
  ];

  List<String> availableTimes = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM'
  ];

  @override
  void dispose() {
    _purposeController.dispose();
    super.dispose();
  }

  void _bookAppointment() {
    if (_selectedDoctor != null &&
        _selectedTime != null &&
        _purposeController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Appointment booked with ${_selectedDoctor!.name} on ${DateFormat('yyyy-MM-dd').format(_selectedDay)} at $_selectedTime for ${_purposeController.text}!'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        _selectedDoctor = null;
        _selectedTime = null;
        _purposeController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all appointment details.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Book a New Appointment',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.teal),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Select Doctor'),
            SizedBox(
              width: double.infinity,
              child: DropdownButtonFormField<Doctor>(
                isExpanded: true, // ✅ make dropdown take full width
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  labelText: 'Doctor',
                  prefixIcon: const Icon(Icons.people),
                ),
                value: _selectedDoctor,
                onChanged: (Doctor? newValue) {
                  setState(() {
                    _selectedDoctor = newValue;
                  });
                },
                items: doctors.map<DropdownMenuItem<Doctor>>((Doctor doctor) {
                  return DropdownMenuItem<Doctor>(
                    value: doctor,
                    child: Flexible(
                      child: Text(
                        '${doctor.name} (${doctor.specialty})',
                        overflow: TextOverflow.ellipsis, // ✅ ellipsis
                      ),
                    ),
                  );
                }).toList(),
                hint: const Text('Choose a doctor'),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Select Date'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(color: Colors.grey[700]),
                  weekendTextStyle: TextStyle(color: Colors.red[400]),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Select Time'),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: availableTimes.map((time) {
                bool isSelected = _selectedTime == time;
                return ChoiceChip(
                  label: Text(time),
                  selected: isSelected,
                  selectedColor: Colors.teal.withOpacity(0.7),
                  onSelected: (selected) {
                    setState(() {
                      _selectedTime = selected ? time : null;
                    });
                  },
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: Colors.teal.withOpacity(0.1),
                  side: const BorderSide(color: Colors.teal),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Purpose of Visit'),
            TextField(
              controller: _purposeController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                labelText: 'e.g., Routine Checkup, Flu Symptoms',
                prefixIcon: const Icon(Icons.short_text),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: _bookAppointment,
                icon: const Icon(Icons.send),
                label: const Text('Confirm Appointment'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
      ),
    );
  }
}
