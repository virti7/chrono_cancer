// lib/features/doctor/pages/reports_page.dart
import 'package:flutter/material.dart';
import 'patient_history_page.dart';

class ReportsPage extends StatefulWidget {
  final List<Map<String, dynamic>> patients;

  const ReportsPage({Key? key, required this.patients}) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  late List<Map<String, dynamic>> _patients;
  bool _sortAscending = true; // toggle state

  @override
  void initState() {
    super.initState();
    _patients = List.from(widget.patients); // clone so we can edit
  }

  // ✅ Decide card accent color based on risk score
  Color _getRiskColor(int score) {
    if (score < 40) return Colors.green.shade400;
    if (score < 70) return Colors.orange.shade400;
    return Colors.red.shade400;
  }

  // Add new report dialog
  void _addReport() {
    _showReportDialog();
  }

  // Edit report dialog
  void _editReport(int index) {
    _showReportDialog(editIndex: index);
  }

  // Delete report
  void _deleteReport(int index) {
    setState(() {
      _patients.removeAt(index);
    });
  }

  // Sort patients by risk score
  void _sortPatients() {
    setState(() {
      _patients.sort((a, b) {
        int riskA = a['riskScore'] ?? 0;
        int riskB = b['riskScore'] ?? 0;
        return _sortAscending ? riskA.compareTo(riskB) : riskB.compareTo(riskA);
      });
      _sortAscending = !_sortAscending; // toggle order
    });
  }

  // Reusable dialog for Add/Edit
  void _showReportDialog({int? editIndex}) {
    final isEdit = editIndex != null;
    final TextEditingController nameController = TextEditingController(
        text: isEdit ? _patients[editIndex]['name'] : '');
    final TextEditingController diseaseController = TextEditingController(
        text: isEdit ? _patients[editIndex]['disease'] : '');
    final TextEditingController riskController = TextEditingController(
        text: isEdit ? "${_patients[editIndex]['riskScore']}" : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? "Edit Report" : "Add Report"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Patient Name"),
                ),
                TextField(
                  controller: diseaseController,
                  decoration: const InputDecoration(labelText: "Disease"),
                ),
                TextField(
                  controller: riskController,
                  decoration: const InputDecoration(labelText: "Risk Score (%)"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text(isEdit ? "Save" : "Add"),
              onPressed: () {
                final String name = nameController.text.trim();
                final String disease = diseaseController.text.trim();
                final int risk =
                    int.tryParse(riskController.text.trim()) ?? 0;

                setState(() {
                  if (isEdit) {
                    _patients[editIndex!] = {
                      'name': name,
                      'disease': disease,
                      'riskScore': risk,
                    };
                  } else {
                    _patients.add({
                      'name': name.isNotEmpty ? name : 'Unnamed',
                      'disease': disease.isNotEmpty ? disease : 'N/A',
                      'riskScore': risk,
                    });
                  }
                });

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reports',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _sortAscending ? Icons.sort : Icons.sort_by_alpha,
              color: Colors.white,
            ),
            tooltip: "Sort by Risk Score",
            onPressed: _sortPatients,
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF42A5F5), Color(0xFF7E57C2)], // Blue → Purple
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _patients.isEmpty
          ? const Center(
              child: Text(
                "No reports available",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _patients.length,
              itemBuilder: (context, index) {
                final patient = _patients[index];
                final riskScore = patient['riskScore'] ?? 0;
                final riskColor = _getRiskColor(riskScore);

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border(
                        left: BorderSide(
                          color: riskColor,
                          width: 8,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Circle Avatar with initials
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: riskColor.withOpacity(0.2),
                          child: Text(
                            patient['name'] != null &&
                                    patient['name'].isNotEmpty
                                ? patient['name'][0].toUpperCase()
                                : "?",
                            style: TextStyle(
                              color: riskColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Patient info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                patient['name'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Disease: ${patient['disease'] ?? 'N/A'}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    "Risk Score: $riskScore%",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: riskColor,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(Icons.circle,
                                      size: 10, color: riskColor)
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Edit Button
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editReport(index),
                        ),

                        // Delete Button
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteReport(index),
                        ),

                        // Forward Icon → Navigate to history page
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios,
                              color: Colors.grey),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PatientHistoryPage(patient: patient),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      // Floating + Button
      floatingActionButton: FloatingActionButton(
        onPressed: _addReport,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
