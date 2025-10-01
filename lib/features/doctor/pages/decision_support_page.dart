import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Decision Support',
      theme: ThemeData(
        primaryColor: const Color(0xFF6C63FF), // Purple accent
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
      ),
      home: const DecisionSupportPage(),
    );
  }
}

class DecisionSupportPage extends StatefulWidget {
  const DecisionSupportPage({super.key});

  @override
  State<DecisionSupportPage> createState() => _DecisionSupportPageState();
}

class _DecisionSupportPageState extends State<DecisionSupportPage> {
  static const Color _backgroundColor = Color(0xFFF0F2F5);

  // Different card background colors
  final List<Color> cardColors = [
    const Color(0xFFE3F2FD), // Light Blue
    const Color(0xFFE8F5E9), // Light Green
    const Color(0xFFF3E5F5), // Light Purple
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          "Decision Support",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "AI-Powered Suggestions",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Suggestion Cards
            _buildSuggestionCard(
              title: "High Blood Pressure Risk",
              description: "Recommend lifestyle changes & monitoring.",
              buttonText: "Apply",
              backgroundColor: cardColors[0],
              onPressed: () => debugPrint("Apply High Blood Pressure Risk"),
            ),
            const SizedBox(height: 15),
            _buildSuggestionCard(
              title: "Diabetes Risk",
              description: "Suggest regular blood sugar checks.",
              buttonText: "View More",
              backgroundColor: cardColors[1],
              onPressed: () => debugPrint("View More Diabetes Risk"),
            ),
            const SizedBox(height: 15),
            _buildSuggestionCard(
              title: "Medication Reminder",
              description: "Patient due for refill on 5 Oct 2023.",
              buttonText: "Acknowledge",
              backgroundColor: cardColors[2],
              onPressed: () => debugPrint("Acknowledge Medication Reminder"),
            ),
            const SizedBox(height: 30),

            // Insights Section
            Text(
              "Insights",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            _buildInsightsPlaceholder("Health Trends", Colors.lightBlue[100]!),
            const SizedBox(height: 15),
            _buildInsightsPlaceholder("Medication Adherence", Colors.purple[100]!),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard({
    required String title,
    required String description,
    required String buttonText,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 2,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black87.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo, // Buttons stand out
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: onPressed,
                child: Text(
                  buttonText,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsPlaceholder(String label, Color backgroundColor) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}