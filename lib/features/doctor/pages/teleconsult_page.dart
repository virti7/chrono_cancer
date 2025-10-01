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
      title: 'Doctor App',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.deepPurple,
      ),
      home: const TeleconsultPage(),
    );
  }
}

class TeleconsultPage extends StatefulWidget {
  const TeleconsultPage({super.key});

  @override
  State<TeleconsultPage> createState() => _TeleconsultPageState();
}

class _TeleconsultPageState extends State<TeleconsultPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Teleconsult',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w400),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Care',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Family',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Text(
            'Hello, Sarah!',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'How do you want to consult today?',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Consultation options
          Row(
            children: [
              Expanded(
                child: _buildConsultationCard(
                  context,
                  title: 'Video Consultation',
                  icon: Icons.videocam_outlined,
                  color: Colors.deepPurple.shade300,
                  onTap: () {
                    print('Video Consultation tapped');
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildConsultationCard(
                  context,
                  title: 'Chat Consultation',
                  icon: Icons.chat_bubble_outline,
                  color: Colors.pink.shade300,
                  onTap: () {
                    print('Chat Consultation tapped');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Upcoming appointments
          Text(
            'Upcoming Appointments',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildAppointmentCard(
                  context,
                  doctorName: 'Dr. Emily White',
                  date: '24 Oct 2023',
                  time: '10:00 AM',
                  imageUrl: 'https://i.pravatar.cc/150?img=1',
                  onJoinTap: () {
                    print('Join Dr. Emily White consultation');
                  },
                ),
                const SizedBox(width: 16),
                _buildAppointmentCard(
                  context,
                  doctorName: 'Dr. John Doe',
                  date: '25 Oct 2023',
                  time: '02:30 PM',
                  imageUrl: 'https://i.pravatar.cc/150?img=6',
                  onJoinTap: () {
                    print('Join Dr. John Doe consultation');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Past consultations
          Text(
            'Past Consultations',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildPastConsultationTile(
            context,
            doctorName: 'Dr. Jane Smith',
            date: '15 Sep 2023',
            type: 'Video Consultation',
            onViewDetails: () {
              print('View details for Dr. Jane Smith');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context, {
    required String doctorName,
    required String date,
    required String time,
    required String imageUrl,
    required VoidCallback onJoinTap,
  }) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    doctorName,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              date,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Simple Join button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onJoinTap,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.deepPurple.shade200),
                  ),
                ),
                child: Text(
                  'Join',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastConsultationTile(
    BuildContext context, {
    required String doctorName,
    required String date,
    required String type,
    required VoidCallback onViewDetails,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctorName,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$date • $type',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: onViewDetails,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                  side: BorderSide(color: Colors.deepPurple.shade100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  'View Details',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}