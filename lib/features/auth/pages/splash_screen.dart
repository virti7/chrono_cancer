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
    Timer(const Duration(seconds: 2), () {
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
              'assets/images/splash_screen_logo.jpeg', // Ensure this path is correct
              width: 375, // Adjust width as needed //250
              height: 220, // Adjust height as needed //80
            ),
            const SizedBox(height: 20), // Space between logo and text

            // Tagline Text
            const Text(
              'Awareness is the first step toward\nprevention.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600, // Semi-bold for emphasis
                color: Color(0xFF1A237E), // A deep blue color
                height: 1.4, // Line height for better readability
              ),
            ),
          ],
        ),
      ),
    );
  }
}