import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chronocancer_ai/features/auth/pages/onboarding2_page.dart'; 

class Onboarding1 extends StatefulWidget {
  const Onboarding1({Key? key}) : super(key: key);

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  @override
  void initState() {
    super.initState();

    // 👇 Start a 5-second timer
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Onboarding2()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background wave/gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Color(0xFFF0F6FF),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 32),
                  const Text(
                    'Smarter Screening,\nSafer Futures',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8 * (296 / 358),
                      color: Colors.transparent,
                      child: Image.asset(
                        "assets/images/onboarding1_transparent.png",
                      ),
                    ),
                  ),
                  const SizedBox(height: 64),
                  _buildFeatureText(
                    context,
                    'AI-powered predictions detect risks early, ensuring chronic care doesn\'t turn into cancer.',
                  ),
                  const SizedBox(height: 32),
                  _buildFeatureText(
                    context,
                    'Your health deserves precision — smarter screening for a stronger tomorrow.',
                  ),
                  const SizedBox(height: 32),
                  _buildFeatureText(
                    context,
                    'Reimagining cancer care with technology that looks ahead.',
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        height: 1.5,
        color: Colors.grey[800],
      ),
    );
  }
}
