import 'package:flutter/material.dart';

class CommunityInsightsApp extends StatefulWidget {
  const CommunityInsightsApp({Key? key}) : super(key: key);

  @override
  _CommunityInsightsAppState createState() => _CommunityInsightsAppState();
}

class _CommunityInsightsAppState extends State<CommunityInsightsApp> {
  // List of family members
  List<FamilyMember> familyMembers = [
    FamilyMember(
      initials: 'JS',
      name: 'John Smith',
      role: 'Spouse',
      status: 'Healthy',
      lastReport: '2/15/2024',
      statusColor: Colors.green,
      initialsColor: Colors.deepPurpleAccent,
    ),
    FamilyMember(
      initials: 'ES',
      name: 'Emma Smith',
      role: 'Daughter',
      status: 'Needs Attention',
      lastReport: '2/10/2024',
      statusColor: Colors.orange,
      initialsColor: Colors.blueAccent,
    ),
    FamilyMember(
      initials: 'RS',
      name: 'Robert Smith',
      role: 'Father',
      status: 'Healthy',
      lastReport: '2/8/2024',
      statusColor: Colors.green,
      initialsColor: Colors.redAccent,
    ),
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const Icon(Icons.home_outlined, color: Colors.deepPurple),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Community & Family Insights',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Individual -> family -> population health prevention',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/images/transparent_default_user.png'), // Replace with your image
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFamilyHealthCareCard(),
                const SizedBox(height: 20),
                _buildCommunityRiskHeatMapCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------ Family Health Care Card ------------------
  Widget _buildFamilyHealthCareCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite_border, color: Colors.pink),
                    const SizedBox(width: 8),
                    Text(
                      'Family Health Care',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${familyMembers.length} family members',
                    style: TextStyle(color: Colors.pink[700], fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ..._buildFamilyMemberList(),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _showAddFamilyMemberDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Family Member'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.trending_up, color: Colors.deepPurple[700]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Family health score improved by 15% this month',
                      style: TextStyle(color: Colors.deepPurple[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFamilyMemberList() {
    List<Widget> widgets = [];
    for (int i = 0; i < familyMembers.length; i++) {
      widgets.add(_buildFamilyMemberTile(member: familyMembers[i]));
      if (i != familyMembers.length - 1) {
        widgets.add(const Divider(height: 20));
      }
    }
    return widgets;
  }

  Widget _buildFamilyMemberTile({required FamilyMember member}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: member.initialsColor,
          child: Text(
            member.initials,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                member.role,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: member.statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                member.status,
                style: TextStyle(color: member.statusColor, fontSize: 12),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Last report: ${member.lastReport}',
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddFamilyMemberDialog() {
    _nameController.clear();
    _roleController.clear();
    _statusController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Family Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _roleController,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            TextField(
              controller: _statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              final role = _roleController.text.trim();
              final status = _statusController.text.trim();

              if (name.isNotEmpty && role.isNotEmpty && status.isNotEmpty) {
                final initials = name.split(' ').map((e) => e[0]).take(2).join();
                setState(() {
                  familyMembers.add(FamilyMember(
                    initials: initials,
                    name: name,
                    role: role,
                    status: status,
                    lastReport: 'N/A',
                    statusColor: Colors.blue,
                    initialsColor: Colors.purple,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // ------------------ Community Risk HeatMap Card ------------------
  Widget _buildCommunityRiskHeatMapCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(
                  'Community Risk HeatMap',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://i.ibb.co/3kX93G1/OIG-2.png'), // Replace with your heatmap image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildRiskArea(
              area: 'Downtown',
              percentage: '51.1%',
              abnormalReports: '23 / 45 reports',
              riskAssessment: 'High Risk',
              riskColor: Colors.red,
            ),
            const Divider(height: 20),
            _buildRiskArea(
              area: 'Suburbs North',
              percentage: '31.6%',
              abnormalReports: '12 / 38 reports',
              riskAssessment: 'Medium Risk',
              riskColor: Colors.orange,
            ),
            const Divider(height: 20),
            _buildRiskArea(
              area: 'Eastside',
              percentage: '27.6%',
              abnormalReports: '6 / 29 reports',
              riskAssessment: 'Low Risk',
              riskColor: Colors.green,
            ),
            const Divider(height: 20),
            _buildRiskArea(
              area: 'Westpark',
              percentage: '35.7%',
              abnormalReports: '15 / 42 reports',
              riskAssessment: 'Medium Risk',
              riskColor: Colors.orange,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStat(
                  icon: Icons.location_on,
                  color: Colors.red,
                  value: '1',
                  label: 'High Risk\nAreas',
                ),
                _buildSummaryStat(
                  icon: Icons.people,
                  color: Colors.orange,
                  value: '154',
                  label: 'Community\nMembers',
                ),
                _buildSummaryStat(
                  icon: Icons.trending_up,
                  color: Colors.green,
                  value: '23%',
                  label: 'Improvement\nRate',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskArea({
    required String area,
    required String percentage,
    required String abnormalReports,
    required String riskAssessment,
    required Color riskColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              area,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            Text(
              percentage,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          'abnormal reports:',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        Text(
          abnormalReports,
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Risk Assessment',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: LinearProgressIndicator(
                value: riskColor == Colors.red
                    ? 0.7
                    : riskColor == Colors.orange
                        ? 0.4
                        : 0.2,
                valueColor: AlwaysStoppedAnimation<Color>(riskColor),
                backgroundColor: riskColor.withOpacity(0.2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              riskAssessment,
              style: TextStyle(color: riskColor, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryStat({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }
}

// ------------------ Family Member Model ------------------
class FamilyMember {
  final String initials;
  final String name;
  final String role;
  final String status;
  final String lastReport;
  final Color statusColor;
  final Color initialsColor;

  FamilyMember({
    required this.initials,
    required this.name,
    required this.role,
    required this.status,
    required this.lastReport,
    required this.statusColor,
    required this.initialsColor,
  });
}
