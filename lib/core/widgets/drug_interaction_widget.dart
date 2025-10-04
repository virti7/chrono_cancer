import 'package:flutter/material.dart';

class DrugInteractionWidget extends StatefulWidget {
  const DrugInteractionWidget({Key? key}) : super(key: key);

  @override
  _DrugInteractionWidgetState createState() => _DrugInteractionWidgetState();
}

class _DrugInteractionWidgetState extends State<DrugInteractionWidget> {
  final TextEditingController _medicationController = TextEditingController();
  bool _isAnalyzing = false;

  List<Medication> medications = [
    Medication(
      name: 'Metformin',
      dosage: '500mg',
      frequency: 'Twice daily',
      type: 'Diabetes',
      color: Colors.blue,
    ),
    Medication(
      name: 'Aspirin',
      dosage: '75mg',
      frequency: 'Once daily',
      type: 'Heart',
      color: Colors.red,
    ),
  ];

  List<Interaction> interactions = [
    Interaction(
      severity: 'Moderate',
      drugs: 'Metformin + Aspirin',
      risk: 'Increased bleeding risk',
      recommendation: 'Monitor blood glucose closely',
      severityColor: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[50]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildMedicationList(),
              const SizedBox(height: 12),
              _buildAddMedicationField(),
              const SizedBox(height: 16),
              if (interactions.isNotEmpty) ...[
                _buildInteractionsSection(),
                const SizedBox(height: 12),
              ],
              _buildAIInsights(),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------- HEADER -----------------
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.medication, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Drug Interaction Monitor',
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'AI actively monitoring',
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${medications.length} meds',
            style: TextStyle(
              color: Colors.orange[800],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ----------------- MEDICATION LIST -----------------
  Widget _buildMedicationList() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Medications',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          ...medications.map((med) => _buildMedicationTile(med)).toList(),
        ],
      ),
    );
  }

  Widget _buildMedicationTile(Medication med) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: med.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      med.name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: med.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        med.type,
                        style: TextStyle(
                            fontSize: 9, color: med.color, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${med.dosage} • ${med.frequency}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: Colors.grey[400]),
            onPressed: () {
              setState(() {
                medications.remove(med);
              });
            },
          ),
        ],
      ),
    );
  }

  // ----------------- ADD MEDICATION -----------------
  Widget _buildAddMedicationField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _medicationController,
              decoration: InputDecoration(
                hintText: 'Add medication or supplement...',
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          _isAnalyzing
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.deepPurple, size: 28),
                  onPressed: _analyzeMedication,
                ),
        ],
      ),
    );
  }

  // ----------------- INTERACTIONS -----------------
  Widget _buildInteractionsSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Detected Interactions',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[900]),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...interactions.map((interaction) => _buildInteractionTile(interaction)).toList(),
        ],
      ),
    );
  }

  Widget _buildInteractionTile(Interaction interaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: interaction.severityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  interaction.severity.toUpperCase(),
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: interaction.severityColor),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  interaction.drugs,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            interaction.risk,
            style: TextStyle(fontSize: 11, color: Colors.grey[700]),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 12, color: Colors.blue[700]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  interaction.recommendation,
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue[700],
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------- AI INSIGHTS -----------------
  Widget _buildAIInsights() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple[400]!, Colors.deepPurple[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.psychology, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'AI Recommendation',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Based on your chronic diabetes + heart condition:',
            style: TextStyle(fontSize: 11, color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white, size: 14),
              SizedBox(width: 6),
              Expanded(
                child: Text('Take Metformin 30min before meals',
                    style: TextStyle(fontSize: 11, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white, size: 14),
              SizedBox(width: 6),
              Expanded(
                child: Text('Aspirin should be taken with food',
                    style: TextStyle(fontSize: 11, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: const [
              Icon(Icons.warning, color: Colors.amber, size: 14),
              SizedBox(width: 6),
              Expanded(
                child: Text('Avoid grapefruit juice (drug absorption)',
                    style: TextStyle(fontSize: 11, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------- ANALYZE MEDICATION -----------------
  void _analyzeMedication() async {
    if (_medicationController.text.trim().isEmpty) return;

    setState(() {
      _isAnalyzing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      medications.add(
        Medication(
          name: _medicationController.text.trim(),
          dosage: '10mg',
          frequency: 'Once daily',
          type: 'New',
          color: Colors.purple,
        ),
      );

      interactions.add(
        Interaction(
          severity: 'Low',
          drugs: '${_medicationController.text.trim()} + Metformin',
          risk: 'Minor interaction detected',
          recommendation: 'Take at different times of day',
          severityColor: Colors.green,
        ),
      );

      _medicationController.clear();
      _isAnalyzing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Expanded(child: Text('AI analysis complete - No major risks detected')),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ----------------- DATA CLASSES -----------------
class Medication {
  final String name;
  final String dosage;
  final String frequency;
  final String type;
  final Color color;

  Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.type,
    required this.color,
  });
}

class Interaction {
  final String severity;
  final String drugs;
  final String risk;
  final String recommendation;
  final Color severityColor;

  Interaction({
    required this.severity,
    required this.drugs,
    required this.risk,
    required this.recommendation,
    required this.severityColor,
  });
}
