import 'package:flutter/material.dart';
import 'package:chronocancer_ai/models.dart';

/// Represents a booked appointment (between patient and doctor)
class BookedAppointment {
  final String patientName;
  final Doctor doctor;
  final DateTime date;
  final String time;
  final String purpose;
  final Color avatarColor; // <-- Add this

  BookedAppointment({
    required this.patientName,
    required this.doctor,
    required this.date,
    required this.time,
    required this.purpose,
    this.avatarColor = Colors.blue, // <-- Default color if not provided
  });
}

/// Singleton store for all booked appointments
class AppointmentStore {
  static final AppointmentStore _instance = AppointmentStore._internal();
  factory AppointmentStore() => _instance;
  AppointmentStore._internal();

  final List<BookedAppointment> _appointments = [];

  List<BookedAppointment> get appointments => List.unmodifiable(_appointments);

  void addAppointment(BookedAppointment appointment) {
    _appointments.add(appointment);
  }
}
