import 'package:flutter/material.dart';

class AshaDashBoard extends StatefulWidget {
  const AshaDashBoard({Key? key}) : super(key: key);

  @override
  State<AshaDashBoard> createState() => _AshaWorkerDashboardState();
}

class _AshaWorkerDashboardState extends State<AshaDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.green[50],
            child: Icon(Icons.favorite, color: Colors.green),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Asha Worker',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
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
              // Welcome Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal[500],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, Dr. Sarah',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Community Health Worker - Zone 7',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem(
                          icon: Icons.star,
                          value: '1',
                          label: 'Level Certified',
                          iconColor: Colors.white,
                          textColor: Colors.white,
                        ),
                        _buildStatItem(
                          icon: Icons.people,
                          value: '140',
                          label: 'Screenings',
                          iconColor: Colors.white,
                          textColor: Colors.white,
                        ),
                        _buildStatItem(
                          icon: Icons.error_outline,
                          value: '5',
                          label: 'Urgent Cases',
                          iconColor: Colors.lightBlue[100]!,
                          textColor: Colors.white,
                          backgroundColor: Colors.lightBlue[100]!.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Today's Queue
              _buildInfoCard(
                label: "Today's Queue",
                value: '23',
                icon: Icons.people_alt,
                iconColor: Colors.indigo,
              ),
              SizedBox(height: 10),

              // Completed Today
              _buildInfoCard(
                label: 'Completed Today',
                value: '12',
                icon: Icons.check_circle_outline,
                iconColor: Colors.green,
              ),
              SizedBox(height: 10),

              // Referrals Pending
              _buildInfoCard(
                label: 'Referrals Pending',
                value: '3',
                icon: Icons.watch_later_outlined,
                iconColor: Colors.orange,
              ),
              SizedBox(height: 20),

              Text(
                'AI Screening Tools',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 15),

              // AI Screening Tools
              _buildAIScreeningTool(
                icon: Icons.monitor_heart,
                title: 'BP Monitor',
                subtitle: 'Blood Pressure Screening',
              ),
              SizedBox(height: 10),
              _buildAIScreeningTool(
                icon: Icons.camera_alt_outlined,
                title: 'Oral Scan',
                subtitle: 'AI-powered oral health',
              ),
              SizedBox(height: 10),
              _buildAIScreeningTool(
                icon: Icons.healing_outlined,
                title: 'Skin Check',
                subtitle: 'Dermatology screening',
              ),
              SizedBox(height: 10),
              _buildAIScreeningTool(
                icon: Icons.assignment_outlined,
                title: 'Health Survey',
                subtitle: 'Symptom Questionnaire',
              ),
              SizedBox(height: 20),

              Text(
                'Upcoming Campaigns',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 15),

              // Upcoming Campaigns
              _buildCampaignCard(
                icon: Icons.school_outlined,
                title: 'School Health Screening',
                location: 'Govt. Bharat Primary School, Sector 12',
                date: '2023-10-01',
                participants: '150',
                status: 'upcoming',
                statusColor: Colors.blue[700]!,
              ),
              SizedBox(height: 10),
              _buildCampaignCard(
                icon: Icons.festival_outlined,
                title: 'Community Festival Camp',
                location: 'Village Square, Shikohpur',
                date: '2023-01-18',
                participants: '85',
                status: 'active',
                statusColor: Colors.green[700]!,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal[500],
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
    required Color textColor,
    Color backgroundColor = Colors.transparent,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              SizedBox(width: 5),
              Text(
                value,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 10),
              CircleAvatar(
                radius: 15,
                backgroundColor: iconColor.withOpacity(0.1),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIScreeningTool({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.grey[700]),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignCard({
    required IconData icon,
    required String title,
    required String location,
    required String date,
    required String participants,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: Colors.grey[700]),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                participants,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'participants',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}