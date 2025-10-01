import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asha Worker - Training Hub',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TrainingHubScreen(),
    );
  }
}

class TrainingHubScreen extends StatefulWidget {
  const TrainingHubScreen({super.key});

  @override
  State<TrainingHubScreen> createState() => _TrainingHubScreenState();
}

class _TrainingHubScreenState extends State<TrainingHubScreen> {
  double progressModule1 = 0.78;
  double progressModule2 = 0.25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite_border, color: Colors.green),
          ),
        ),
        title: const Text(
          'Asha Worker Dashboard',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Training Hub',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildProgressCard(),
              const SizedBox(height: 32),
              const Text(
                'Achievement Badges',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildAchievementBadgesGrid(),
              const SizedBox(height: 32),
              const Text(
                'Available Modules',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildModuleCard(
                title: 'Advanced BP Monitoring',
                description: 'Learn advanced techniques for accurate readings',
                progress: progressModule1,
                buttonText: 'Continue',
                buttonColor: Colors.green,
                icon: Icons.favorite_border,
                iconColor: Colors.green,
              ),
              const SizedBox(height: 16),
              _buildModuleCard(
                title: 'AI-Powered Oral Health Screening',
                description: 'Master mobile photography for oral health assessment',
                progress: progressModule2,
                buttonText: 'Start',
                buttonColor: Colors.blue.shade700,
                icon: Icons.camera_alt_outlined,
                iconColor: Colors.blue.shade700,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: 'Emergency'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade400, Colors.pink.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Progress',
              style: TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Community Health Specialist Track:',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Text(
                  '${(progressModule1 * 100).toInt()}%',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progressModule1,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              borderRadius: BorderRadius.circular(10),
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Complete',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadgesGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4, // taller to fit text
      children: [
        _buildBadgeCard(
          title: '100 Screenings',
          icon: Icons.emoji_events_outlined,
          color: Colors.amber.shade50,
          iconColor: Colors.amber.shade700,
        ),
        _buildBadgeCard(
          title: 'AI Expert',
          icon: Icons.check_circle_outline,
          color: Colors.green.shade50,
          iconColor: Colors.green.shade700,
        ),
        _buildBadgeCard(
          title: 'Community Leader',
          icon: Icons.people_outline,
          color: Colors.blue.shade50,
          iconColor: Colors.blue.shade700,
        ),
        _buildBadgeCard(
          title: 'Team Builder',
          subtitle: 'Train 5 workers',
          icon: Icons.person_add_alt_1_outlined,
          color: Colors.grey.shade100,
          iconColor: Colors.grey.shade600,
        ),
      ],
    );
  }

  Widget _buildBadgeCard({
    required String title,
    String? subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 30),
            const SizedBox(height: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard({
    required String title,
    required String description,
    required double progress,
    required String buttonText,
    required Color buttonColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                    borderRadius: BorderRadius.circular(5),
                    minHeight: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(buttonText, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}