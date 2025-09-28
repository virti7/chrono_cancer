import 'package:flutter/material.dart';
import 'dart:async'; // Required for Timer
import 'package:chronocancer_ai/features/auth/pages/onboarding1_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 5), () {
      // After 5 seconds, navigate to the SignUpPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Onboarding1()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo Image
            Image.asset(
              'assets/images/chronocancer_logo.png', // Ensure this path is correct
              width: 250, // Adjust width as needed
              height: 80, // Adjust height as needed
            ),
            const SizedBox(height: 50), // Space between logo and text

            // Tagline Text
            const Text(
              'Awareness is the first step toward\nprevention.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600, // Semi-bold for emphasis
                color: Color(0xFF1A237E), // A deep blue color
                height: 1.5, // Line height for better readability
              ),
            ),
          ],
        ),
      ),
    );
  }
}