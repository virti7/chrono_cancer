import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chronocancer_ai/features/auth/pages/role_selection_page.dart';

class LocationNotifierScreen extends StatefulWidget {
  const LocationNotifierScreen({super.key});

  @override
  State<LocationNotifierScreen> createState() => _LocationNotifierScreenState();
}

class _LocationNotifierScreenState extends State<LocationNotifierScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    // ⏱ Keep navigation logic unchanged
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserSelectionPage()),
        );
      }
    });

    // ✨ Fade-in animation (same as other screens)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🌈 Gradient background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFEAF2FF),
                    Color(0xFFDCEBFF),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),

          // 🌊 Decorative circular wave
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: size.width * 1.4,
              height: size.width * 1.4,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFFB8D8FF),
                    Colors.transparent,
                  ],
                  radius: 0.7,
                ),
              ),
            ),
          ),

          // 📱 Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // 🩺 Headline
                      const Text(
                        'Location Notifier',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 📍 Beautiful location icon instead of image
                      Center(
                        child: Container(
                          width: size.width * 0.6,
                          height: size.width * 0.6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade100,
                                Colors.purple.shade100,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade200.withOpacity(0.4),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.location_on_rounded,
                              size: size.width * 0.3,
                              color: Colors.deepPurple.shade400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // 📝 Description
                      _buildFeatureText(
                        '📍 Automatically shares your real-time location with trusted contacts during critical times, ensuring they know where you are.',
                      ),
                      const SizedBox(height: 20),
                      _buildFeatureText(
                        '🛡️ Enhancing safety and peace of mind — because care goes beyond prediction.',
                      ),
                      const SizedBox(height: 40),

                      // 🟣 Progress dots (step 3 active)
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildDot(false),
                            _buildDot(false),
                            _buildDot(true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        height: 1.6,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 14 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1E88E5) : Colors.grey[400],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
