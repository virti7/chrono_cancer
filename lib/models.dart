import 'package:flutter/material.dart'; // Only if you need colors/material in models

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl; // For a doctor's profile picture
  final double rating;
  final String bio;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    this.rating = 0.0,
    this.bio = 'No bio available.',
  });
}

class Appointment {
  final String id;
  final Doctor doctor;
  final DateTime dateTime;
  final String purpose;
  final String status; // e.g., 'Pending', 'Confirmed', 'Completed', 'Cancelled'

  Appointment({
    required this.id,
    required this.doctor,
    required this.dateTime,
    required this.purpose,
    this.status = 'Pending',
  });
}