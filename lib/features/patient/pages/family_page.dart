import 'package:flutter/material.dart';

class CommunityInsightsApp extends StatefulWidget {
  const CommunityInsightsApp({Key? key}) : super(key: key);

  @override
  _CommunityInsightsAppState createState() => _CommunityInsightsAppState();
}

class _CommunityInsightsAppState extends State<CommunityInsightsApp> {
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
                'Family Cancer Intelligence',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Track hereditary patterns & community risk factors',
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
                backgroundImage: AssetImage('assets/images/transparent_default_user.png'),
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
                _buildFamilyCancerTreeCard(),
                const SizedBox(height: 20),
                _buildHereditaryRiskCard(),
                const SizedBox(height: 20),
                _buildEnvironmentalCancerHotspots(),
                const SizedBox(height: 20),
                _buildPreventionImpactCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section 1: Family Cancer Tree (genetic lineage tracking)
  Widget _buildFamilyCancerTreeCard() {
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
                    const Icon(Icons.account_tree, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Text(
                      'Family Cancer History',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${familyMembers.length} tracked',
                    style: TextStyle(color: Colors.deepPurple[700], fontSize: 12),
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
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange[700]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '2 family members with breast cancer history detected - genetic screening recommended',
                      style: TextStyle(color: Colors.orange[800], fontSize: 13),
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

  // Section 2: Hereditary Risk Assessment (UNIQUE VALUE)
  Widget _buildHereditaryRiskCard() {
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
                const Icon(Icons.biotech, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  'Your Hereditary Cancer Risk',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildRiskRow('Breast Cancer', 'High', 0.65, Colors.red, '2 maternal cases'),
            const SizedBox(height: 12),
            _buildRiskRow('Colon Cancer', 'Medium', 0.35, Colors.orange, '1 paternal case'),
            const SizedBox(height: 12),
            _buildRiskRow('Lung Cancer', 'Low', 0.15, Colors.green, 'No family history'),
            const SizedBox(height: 12),
            _buildRiskRow('Prostate Cancer', 'Medium', 0.40, Colors.orange, '1 case detected'),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[50]!, Colors.blue[100]!],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.insights, color: Colors.blue[700]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'AI recommends BRCA1/BRCA2 genetic test based on family pattern',
                      style: TextStyle(color: Colors.blue[900], fontSize: 13, fontWeight: FontWeight.w500),
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

  Widget _buildRiskRow(String cancer, String level, double value, Color color, String reason) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(cancer, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(level, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: color.withOpacity(0.2),
          minHeight: 6,
        ),
        const SizedBox(height: 4),
        Text(reason, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
      ],
    );
  }

  // Section 3: Environmental Cancer Hotspots (UNIQUE VALUE)
  Widget _buildEnvironmentalCancerHotspots() {
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
                const Icon(Icons.map, color: Colors.deepOrange),
                const SizedBox(width: 8),
                Text(
                  'Environmental Cancer Hotspots',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Areas with elevated cancer incidence near you',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 15),
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: NetworkImage('https://i.ibb.co/3kX93G1/OIG-2.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildHotspotRow('Industrial Zone East', 'Lung cancer: 2.3x avg', Colors.red, '342 cases/yr', '8 hospitals'),
            const Divider(height: 20),
            _buildHotspotRow('Downtown Metro', 'Breast cancer: 1.8x avg', Colors.orange, '156 cases/yr', '5 hospitals'),
            const Divider(height: 20),
            _buildHotspotRow('Suburban West', 'Colon cancer: 1.4x avg', Colors.orange, '89 cases/yr', '3 hospitals'),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red[700]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'You live 3km from Industrial Zone East - consider quarterly lung screenings',
                      style: TextStyle(color: Colors.red[900], fontSize: 13),
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

  Widget _buildHotspotRow(String area, String stats, Color color, String cases, String hospitals) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(area, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(stats, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.people_outline, size: 12, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(cases, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  const SizedBox(width: 12),
                  Icon(Icons.local_hospital, size: 12, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(hospitals, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Section 4: Prevention Impact Metrics (UNIQUE VALUE)
  Widget _buildPreventionImpactCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[400]!, Colors.green[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.shield_outlined, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Community Impact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildImpactStat('1,847', 'Early\nDetections', Icons.search),
                  _buildImpactStat('92%', 'Survival\nRate', Icons.favorite),
                  _buildImpactStat('6mo', 'Avg Time\nSaved', Icons.schedule),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Impact This Year',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text('3 family members screened', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text('1 polyp detected and removed early', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text('Prevented potential Stage 3 diagnosis', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImpactStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 11,
          ),
        ),
      ],
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
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
              'Last scan: ${member.lastReport}',
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Family Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _roleController,
              decoration: const InputDecoration(labelText: 'Relation (e.g., Mother, Sister)'),
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

              if (name.isNotEmpty && role.isNotEmpty) {
                final initials = name.split(' ').map((e) => e[0]).take(2).join();
                setState(() {
                  familyMembers.add(FamilyMember(
                    initials: initials,
                    name: name,
                    role: role,
                    status: 'Pending Screening',
                    lastReport: 'N/A',
                    statusColor: Colors.grey,
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
}

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