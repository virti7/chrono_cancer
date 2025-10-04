import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:math'; // For random avatar background color

class CalendarPage extends StatefulWidget {
  final List<Map<String, dynamic>> appointments; // ✅ take appointments from outside

  const CalendarPage({Key? key, required this.appointments}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late List<Map<String, dynamic>> _appointments; // ✅ local copy of appointments

  // Function to generate a random pastel color for avatar backgrounds
  Color _getRandomPastelColor() {
    final Random random = Random();
    return Color.fromRGBO(
      150 + random.nextInt(100), // R
      150 + random.nextInt(100), // G
      150 + random.nextInt(100), // B
      1,
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _appointments = List.from(widget.appointments); // ✅ keep passed list
  }

  // ✅ Add new appointment dialog
  void _addAppointmentDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController typeController = TextEditingController();
    DateTime selectedDateTime = _selectedDay ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Use StatefulBuilder to update dialog UI
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Add Appointment"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Patient Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: typeController,
                      decoration: const InputDecoration(
                        labelText: "Appointment Type",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.event),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: Text(
                        "Time: ${DateFormat('hh:mm a').format(selectedDateTime)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                        );
                        if (pickedTime != null) {
                          setStateDialog(() { // Update dialog's state
                            selectedDateTime = DateTime(
                              selectedDateTime.year,
                              selectedDateTime.month,
                              selectedDateTime.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF42A5F5),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Add"),
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        typeController.text.isNotEmpty) {
                      setState(() {
                        _appointments.add({
                          'patientName': nameController.text,
                          'appointmentType': typeController.text,
                          'dateTime': selectedDateTime,
                          'colorAccent': Colors.primaries[
                              Random().nextInt(Colors.primaries.length)], // Random accent color
                        });
                      });
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please fill all fields!")),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter appointments for the selected day
    List<Map<String, dynamic>> selectedDayAppointments = _appointments.where((appointment) {
      return isSameDay(appointment['dateTime'], _selectedDay);
    }).toList();

    return WillPopScope(
      // ✅ ensures data persists when going back
      onWillPop: () async {
        Navigator.pop(context, _appointments);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Calendar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF42A5F5), // Light Blue
                  Color(0xFFBA68C8), // Light Purple
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // Calendar Widget
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
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
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                  formatButtonDecoration: BoxDecoration(
                    color: const Color(0xFF42A5F5),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  formatButtonTextStyle: const TextStyle(color: Colors.white),
                  titleTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.black87,
                  ),
                  leftChevronIcon:
                      const Icon(Icons.chevron_left, color: Color(0xFF42A5F5)),
                  rightChevronIcon:
                      const Icon(Icons.chevron_right, color: Color(0xFF42A5F5)),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: const BoxDecoration(
                    color: Color(0xFFBA68C8), // Accent color for today
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFF42A5F5), // Primary color for selected day
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  weekendTextStyle: const TextStyle(color: Colors.redAccent),
                  defaultTextStyle: const TextStyle(color: Colors.black87),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.grey),
                  weekendStyle: TextStyle(color: Colors.redAccent),
                ),
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
            // Appointments List
            Expanded(
              child: selectedDayAppointments.isEmpty
                  ? Center(
                      child: Text(
                        'No appointments for ${DateFormat('EEEE, MMM d').format(_selectedDay!)}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: selectedDayAppointments.length,
                      itemBuilder: (context, index) {
                        final appointment = selectedDayAppointments[index];
                        final String patientName = appointment['patientName'];
                        final String appointmentType =
                            appointment['appointmentType'];
                        final DateTime dateTime = appointment['dateTime'];
                        final Color cardAccentColor = appointment['colorAccent'];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border(
                                  left: BorderSide(
                                    color: cardAccentColor.withOpacity(0.8),
                                    width: 8,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    // Patient Avatar
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: _getRandomPastelColor(),
                                      child: Text(
                                        patientName.isNotEmpty
                                            ? patientName[0].toUpperCase()
                                            : '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Appointment Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            patientName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            appointmentType,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            DateFormat('MMM d, yyyy - hh:mm a')
                                                .format(dateTime),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade700,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // ✅ Delete Button
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          _appointments.remove(appointment);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        // ✅ Floating button to add patients
        floatingActionButton: FloatingActionButton(
          onPressed: _addAppointmentDialog,
          backgroundColor: const Color(0xFF42A5F5),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}